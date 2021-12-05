library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is

  port (
    clk: in std_logic;
    res: in std_logic;
    state_in: in std_logic_vector(1599 downto 0);
    output_ram: in std_logic_vector(7 downto 0);
    state_out: out std_logic_vector(1599 downto 0);
    input_ram: out std_logic_vector(7 downto 0);
    control_out: out std_logic_vector(33 downto 0);
    ram_we: out std_logic;
    ram_out: out integer
    );
    
end entity control_unit;

architecture behavioral of control_unit is

component rc_bit_generator is
  port (
    round : in integer;
    slice : in integer;
    rc_bit: out std_logic
    );
end component;

component rho_constant_generator is
  port (
    round : in integer;
    rho_constant0: out std_logic_vector (5 downto 0);
    rho_constant1: out std_logic_vector (5 downto 0);
    mux_64_0: out std_logic_vector(3 downto 0);
    mux_64_1: out std_logic_vector(3 downto 0)
    );
end component;

type state_type is (preamble_l, preamble_c, slice_l, slice_c, slice_w, rho_l, rho_c, rho_w, state_w, state_r);
signal current_state: state_type := state_w;
signal control_output: std_logic_vector(33 downto 0) := (others => '0');
signal ram_we_sig: std_logic := '0';

signal count: integer := 0; -- counter for load/store to RAM
signal offset: integer := 15; -- counter for looping over slice/rho phase
signal current: integer := 15; -- ram_out address
signal round: integer := 0; -- counter for round (between 0 and 24 because of the implementation)
signal slice: integer := 0; -- counter for slice phase
signal slice_sig: integer :=0; -- slice number for RC bit generation
signal rc_bit: std_logic := '0'; -- RC bit signal
signal round_sig: integer := 0;
signal rho_constant0_sig, rho_constant1_sig: std_logic_vector (5 downto 0) := (others => '0');
signal mux_64_0, mux_64_1: std_logic_vector(3 downto 0) := (others => '0');
signal i: integer := 0;
signal input_ram_sig: std_logic_vector(7 downto 0):= (others => '0');
signal state_out_sig: std_logic_vector(1599 downto 0):= (others => '0');

begin

comb_logic: process(clk, i, res, input_ram_sig, rc_bit, current_state, current, count, offset, control_output, round, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1, slice, ram_we_sig)
  begin
    case current_state is

    -- write state to RAM
    when state_w =>
    ram_we_sig <= '1';
    current <= i;
    control_output(24) <= '1';
    input_ram_sig <= state_in((i*8+7) downto (i*8));
    if(rising_edge(clk) and i<199 and res = '1') then
      i <= (i + 1) mod 200;
    elsif(rising_edge(clk) and i=199 and res = '1') then
      ram_we_sig <= '0';
      current <= 15;
      count <= 0;
      offset <= 15;
      control_output <= (others => '0');
      current_state <= preamble_l;
    end if;

    -- load last 4 slices
    when preamble_l =>
    control_output(1 downto 0) <= "00";
    if(rising_edge(clk) and count<=10 and res = '1') then
      current <= (current + 16) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 11 and res = '1') then
      current <= 192 + integer(floor(real(offset)/2.0)) mod 200;
      count <= count + 1;
      control_output(17 downto 16) <= "01";
    elsif(rising_edge(clk) and count = 12 and res = '1') then
      count <= count + 1;
    elsif(rising_edge(clk) and count = 13 and res = '1') then
      current_state <= preamble_c;
      control_output(25) <= '1';
    end if;

    -- perform one slice unit cycle for parity register of slice 63
    when preamble_c =>
    control_output(1 downto 0) <= "11";
    control_output(27 downto 26) <= "11";
    slice <= 3;
    if(round = 0) then 
    control_output(30) <= '1';
    else 
    control_output(30) <= '0';
    control_output(31) <= rc_bit;
    end if;
    offset <= 15;
    count <= 0;
    if(rising_edge(clk) and res = '1') then
      current_state <= slice_l;
      offset <= 0;
      current <= 0;
      control_output(25) <= '0';
      slice <= 0;
    end if;

    -- load 4 slices
    when slice_l =>
    control_output(1 downto 0) <= "00";
    control_output(30) <= '0';
    control_output(28) <= '1'; -- set we bit of parity register to 1
    if(rising_edge(clk) and count<=10 and res = '1') then
      current <= (current + 16) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 11 and res = '1') then
      current <= 192 + integer(floor(real(offset)/2.0)) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 12 and res = '1') then
      count <= count + 1;
    elsif(rising_edge(clk) and count = 13 and res = '1') then
      current_state <= slice_c;
      control_output(25) <= '1';
      control_output(28) <= '0';
      control_output(1 downto 0) <= "01";
    end if;

    -- perform slice unit on the four slices
    when slice_c =>
    --control_output(1 downto 0) <= "01";
    control_output(31) <= rc_bit;
    control_output(27 downto 26) <= std_logic_vector(to_unsigned((slice) mod 4, 2));
    control_output(17 downto 16) <= std_logic_vector(to_unsigned((offset) mod 2, 2));

    if(round = 0) then control_output(30) <= '1'; -- bypass pi/iota/chi transformations on round 0
    elsif(round = 24) then control_output(29) <= '1'; -- bypass theta transformations on round 24
    else control_output(30 downto 29) <= "00";
    end if;

    if(rising_edge(clk) and slice=0 and res = '1') then
      control_output(1 downto 0) <= "01";
      control_output(25) <= '0';
      slice <= (slice + 1) mod 4;
    elsif(rising_edge(clk) and slice<=2 and res = '1') then
      slice <= (slice + 1) mod 4;
    elsif(rising_edge(clk) and slice =3 and res = '1') then
      current_state <= slice_w;
      ram_we_sig <= '1';
      slice <= (slice + 1) mod 4;
      count <= 0;
      current <= offset;
    end if;

    -- write 4 slices to RAM
    when slice_w =>
    control_output(1 downto 0) <= "11"; -- reg0 and reg1 on standby
    control_output(33 downto 32) <= "11"; -- bypass rho
    control_output(5 downto 2) <= std_logic_vector(to_unsigned(15-count, 4)); -- set the mux64 to the correct value
    control_output(9 downto 6) <= std_logic_vector(to_unsigned(15-count, 4)); -- set the mux64 to the correct value -- set ram we signal to 1 so we write in RAM instead of reading
    if(rising_edge(clk) and count<=10 and res = '1') then
      current <= (current + 16) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 11 and res = '1') then
      current <= 192 + integer(floor(real(offset)/2.0)) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 12 and res = '1' and offset <15) then -- repeat slice phase on next slices
      count <= 0;
      offset <= offset + 1 mod 16;
      current <= offset + 1 mod 16;
      ram_we_sig <= '0';
      current_state <= slice_l;
    elsif(rising_edge(clk) and count = 12 and res = '1' and offset = 15 and round /=24) then 
      count <= 0;
      offset <= 0;
      current <= 0;
      current_state <= rho_l;
    elsif(rising_edge(clk) and count = 12 and res = '1' and offset = 15 and round = 24) then 
      count <= count + 1;
      i <= 0;
      current <= 0;
      ram_we_sig <= '0';
    elsif(rising_edge(clk) and count = 13 and res = '1' and offset = 15 and round = 24) then
      i <= 1;
      current <= 1;
      current_state <= state_r;
    end if;

    -- load 2 lanes from RAM
    when rho_l => 
    ram_we_sig <= '0';
    control_output(1 downto 0) <= "10";
    if(rising_edge(clk) and count<=14 and res = '1') then
      current <= (current + 1) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 15 and res = '1') then
      count <= count + 1;
    elsif(rising_edge(clk) and count = 16 and res = '1') then
      current_state <= rho_c;
    end if;

    -- store first 4 nibbles in rho unit register
    when rho_c =>
    control_output(1 downto 0) <= "11";
    control_output(5 downto 2) <= mux_64_0;
    control_output(9 downto 6) <= mux_64_1;
    control_output(15 downto 10) <= rho_constant0_sig;
    control_output(23 downto 18) <= rho_constant1_sig;
    control_output(33 downto 32) <= "00";
    count <= 0;
    current <= 16*offset;
    if(rising_edge(clk) and res = '1') then
      current_state <= rho_w;
    end if;

    -- write 2 lanes to RAM
    when rho_w =>
    ram_we_sig <= '1';
    control_output(5 downto 2) <= std_logic_vector(to_unsigned(to_integer(unsigned((mux_64_0)) - count - 1) mod 16, 4));
    control_output(9 downto 6) <= std_logic_vector(to_unsigned(to_integer(unsigned((mux_64_1)) - count - 1) mod 16, 4));
    control_output(15 downto 10) <= rho_constant0_sig;
    control_output(23 downto 18) <= rho_constant1_sig;
    control_output(33 downto 32) <= "00";
    if(rising_edge(clk) and count<=14 and res = '1') then
      current <= (current + 1) mod 200;
      count <= count + 1;
    elsif(rising_edge(clk) and count = 15 and offset <= 10 and res = '1') then
      offset <= offset+1 mod 12;
      current <= (offset+1)*16;
      count <= 0;
      ram_we_sig <= '0';
      current_state <= rho_l;
    elsif(rising_edge(clk) and count = 15 and offset = 11 and res = '1') then
      ram_we_sig <= '0';
      count <= 0;
      offset <= 15;
      current <= 15;
      round <= round + 1;
      current_state <= preamble_l;
    end if;

    -- write state to RAM
    when state_r =>
    current <= i;
    ram_we_sig <= '0';
    state_out_sig(((i-1)*8+7) downto ((i-1)*8)) <= output_ram;
    if(rising_edge(clk) and i<200 and res = '1') then
      i <= (i + 1) mod 201;
    elsif(rising_edge(clk) and i=200 and res = '1') then
      i <= 0;
      round <= 0;
      current_state <= state_w;
    end if;

    when others => current_state <= preamble_l;

  end case;
end process;

ram_out <= current;
control_out <= control_output;
ram_we <= ram_we_sig;
slice_sig <= offset*4 + slice;
round_sig <= (round - 1) mod 24;
input_ram <= input_ram_sig;
state_out <= state_out_sig;

rc: rc_bit_generator port map(round_sig, slice_sig, rc_bit);
rho_constant: rho_constant_generator port map(offset, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1);

end behavioral;