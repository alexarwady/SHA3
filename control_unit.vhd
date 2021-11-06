library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is

  port (
    clk: in std_logic;
    res: in std_logic;
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

type state_type is (preamble_l, preamble_c, slice_l, slice_c, slice_w, rho_l, rho_c, rho_w);
signal current_state: state_type := preamble_l;
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

begin

comb_logic: process(clk, res, current_state, current, count, offset, control_output, round, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1)
  begin
    case current_state is

    -- load last 4 slices
    when preamble_l =>
    if(clk'event and clk ='1' and count<=10 and res = '1') then
      current <= (current + 16) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 11 and res = '1') then
      current <= 192 + integer(floor(real(offset)/2.0)) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 12 and res = '1') then
      current_state <= preamble_c;
    end if;

    -- perform one slice unit cycle for parity register of slice 63
    when preamble_c =>
    control_output(1 downto 0) <= "11";
    control_output(27 downto 26) <= "11";
    control_output(30) <= '1';
    offset <= 0;
    count <= 0;
    current <= offset;
    if(clk'event and clk ='1' and res = '1') then
      current_state <= slice_l;
    end if;

    -- load 4 slices
    when slice_l =>
    control_output(1 downto 0) <= "00";
    control_output(30) <= '0';
    control_output(28) <= '1'; -- set we bit of parity register to 1
    if(clk'event and clk ='1' and count<=10 and res = '1') then
      current <= (current + 16) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 11 and res = '1') then
      current <= 192 + integer(floor(real(offset)/2.0)) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 12 and res = '1') then
      current_state <= slice_c;
    end if;

    -- perform slice unit on the four slices
    when slice_c =>
    control_output(1 downto 0) <= "01";
    control_output(31) <= rc_bit;
    if(round = 0) then control_output(30) <= '1'; -- bypass pi/iota/chi transformations on round 0
    elsif(round = 24) then control_output(29) <= '1'; -- bypass theta transformations on round 24
    else control_output(30 downto 29) <= "00";
    end if;
    control_output(28) <= '0';
    control_output(27 downto 26) <= std_logic_vector(to_unsigned(slice, 2));
    if(clk'event and clk ='1' and slice<=2 and res = '1') then
      slice <= (slice + 1) mod 4;
    elsif(clk'event and clk ='1' and slice =3 and res = '1') then
      current_state <= slice_w;
      slice <= (slice + 1) mod 4;
      count <= 0;
      current <= offset;
    end if;

    -- write 4 slices to RAM
    when slice_w =>
    control_output(1 downto 0) <= "11"; -- reg0 and reg1 on standby
    control_output(33 downto 32) <= "11"; -- bypass rho
    control_output(5 downto 2) <= std_logic_vector(to_unsigned(count+3, 4)); -- set the mux64 to the correct value
    control_output(9 downto 6) <= std_logic_vector(to_unsigned(count+3, 4)); -- set the mux64 to the correct value
    ram_we_sig <= '1'; -- set ram we signal to 1 so we write in RAM instead of reading
    if(clk'event and clk ='1' and count<=10 and res = '1') then
      current <= (current + 16) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 11 and res = '1') then
      current <= 192 + integer(floor(real(offset)/2.0)) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 12 and res = '1' and offset <15) then -- repeat slice phase on next slices
      count <= 0;
      offset <= offset + 1 mod 16;
      current <= offset + 1 mod 16;
      ram_we_sig <= '0';
      current_state <= slice_l;
    elsif(clk'event and clk ='1' and count = 12 and res = '1' and offset = 15) then 
      count <= 0;
      offset <= 0;
      current <= 0;
      current_state <= rho_l;
    end if;

    -- load 2 lanes from RAM
    when rho_l => 
    ram_we_sig <= '0';
    control_output(1 downto 0) <= "10";
    if(clk'event and clk ='1' and count<=14 and res = '1') then
      current <= (current + 1) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 15 and res = '1') then
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
    if(clk'event and clk ='1' and res = '1') then
      current_state <= rho_w;
    end if;

    -- write 2 lanes to RAM
    when rho_w =>
    ram_we_sig <= '1';
    control_output(5 downto 2) <= std_logic_vector(to_unsigned(to_integer(unsigned((mux_64_0)) + count + 1) mod 16, 4));
    control_output(9 downto 6) <= std_logic_vector(to_unsigned(to_integer(unsigned((mux_64_1)) + count + 1) mod 16, 4));
    control_output(15 downto 10) <= rho_constant0_sig;
    control_output(23 downto 18) <= rho_constant1_sig;
    control_output(33 downto 32) <= "00";
    if(clk'event and clk ='1' and count<=14 and res = '1') then
      current <= (current + 1) mod 200;
      count <= count + 1;
    elsif(clk'event and clk ='1' and count = 15 and offset <= 10 and res = '1') then
      offset <= offset+1 mod 12;
      current <= (offset+1)*16;
      count <= 0;
      ram_we_sig <= '0';
      current_state <= rho_l;
    elsif(clk'event and clk ='1' and count = 15 and offset = 11 and res = '1') then
      ram_we_sig <= '0';
      count <= 0;
      offset <= 0;
      current <= 0;
      round <= round + 1;
      current_state <= preamble_l;
    end if;

    when others => current_state <= preamble_l;

  end case;
end process;

ram_out <= current;
control_out <= control_output;
ram_we <= ram_we_sig;
slice_sig <= offset*4 + slice; --offset or round (?)
round_sig <= (round - 1) mod 24;

rc: rc_bit_generator port map(round_sig, slice_sig, rc_bit);
rho_constant: rho_constant_generator port map(offset, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1);

end behavioral;