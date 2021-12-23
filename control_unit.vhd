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
    control_out: out std_logic_vector(36 downto 0);
    ram_we: out std_logic;
    ram_out: out std_logic_vector(7 downto 0)
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
signal current_state: state_type;
signal control_output: std_logic_vector(34 downto 0);
signal ram_we_sig: std_logic;
signal count: integer; -- counter for load/store to RAM
signal offset: integer; -- counter for looping over slice/rho phase
signal current: integer; -- ram_out address
signal round: integer; -- counter for round (between 0 and 24 because of the implementation)
signal slice: integer; -- counter for slice phase
signal slice_sig: integer; -- slice number for RC bit generation
signal rc_bit: std_logic; -- RC bit signal
signal round_sig: integer;
signal rho_constant0_sig, rho_constant1_sig: std_logic_vector (5 downto 0);
signal mux_64_0, mux_64_1: std_logic_vector(3 downto 0);
signal input_ram_sig: std_logic_vector(7 downto 0);
signal state_out_sig: std_logic_vector(1599 downto 0);
signal temp: std_logic_vector(3 downto 0);
signal temp1: std_logic_vector(7 downto 0);
signal temp2: std_logic;
signal temp3: std_logic_vector(1 downto 0);
signal count1: integer;

begin

comb_logic: process(slice_sig, round_sig, temp, temp1, temp2, state_in, state_out_sig, input_ram_sig, output_ram, rc_bit, current_state, current, count, offset, control_output, round, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1, slice, ram_we_sig)

  begin
    slice_sig <= offset*4 + slice;
    round_sig <= (round - 1) mod 24;
    ram_out <= std_logic_vector(to_unsigned(current, 8));
    control_out <= temp3 & control_output(34 downto 32) & temp2 & control_output(30 downto 28) & temp(3 downto 2) & control_output(25 downto 18) & temp(1 downto 0) & control_output(15 downto 10) & temp1 & control_output(1 downto 0);
    ram_we <= ram_we_sig;
    input_ram <= input_ram_sig;
    state_out <= state_out_sig;

    case current_state is

    when state_w =>
    input_ram_sig <= state_in((current*8+7) downto (current*8));
    temp2 <= '0';
    temp1 <= (others => '0');
    temp <= (others => '0');

    when preamble_c =>
    temp(3 downto 2) <= std_logic_vector(to_unsigned((slice) mod 4, 2));
    temp(1 downto 0) <= "01";
    temp2 <= rc_bit;
    temp3 <= std_logic_vector(to_unsigned((count1) mod 4, 2));

    when slice_c =>
    temp(3 downto 2) <= std_logic_vector(to_unsigned((slice) mod 4, 2));
    temp(1 downto 0) <= std_logic_vector(to_unsigned((offset) mod 2, 2));
    temp2 <= rc_bit;
    temp3 <= std_logic_vector(to_unsigned((count1) mod 4, 2));

    when slice_w =>
    temp1(7 downto 4) <= std_logic_vector(to_unsigned(15-count, 4));
    temp1(3 downto 0) <= std_logic_vector(to_unsigned(15-count, 4));
    temp2 <= temp2;

    when rho_c =>
    temp1(3 downto 0) <= mux_64_0;
    temp1(7 downto 4) <= mux_64_1;
    temp2 <= rc_bit;

    when rho_w =>
    temp1(3 downto 0) <= std_logic_vector(to_unsigned(to_integer(unsigned((mux_64_0)) - count - 1) mod 16, 4));
    temp1(7 downto 4) <= std_logic_vector(to_unsigned(to_integer(unsigned((mux_64_1)) - count - 1) mod 16, 4));
    temp2 <= temp2;

    when state_r =>
    state_out_sig(((current-1)*8+7) downto ((current-1)*8)) <= output_ram;

    when others => null;
  
    end case;
  end process;

seq_logic: process(clk, res, input_ram_sig, rc_bit, current_state, current, count, offset, control_output, round, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1, slice, ram_we_sig)
  begin
    if(res = '0') then
      current_state <= state_w;
      current <= 0;
      control_output <= "10000000001000000000000000000000000";
      ram_we_sig <= '1';
      count <= 0;
      offset <= 15;
      round <= 0;
      slice <= 0;
      count1 <= 3;
    end if;

    if(rising_edge(clk) and res = '1') then
      case current_state is

      -- write state to RAM
      when state_w =>
      if(current<199) then
        current <= (current + 1) mod 200;
      elsif(current=199) then
        ram_we_sig <= '0';
        current <= 15;
        count <= 0;
        offset <= 15;
        control_output <= "10000000000000000000000000000000000";
        current_state <= preamble_l;
      end if;

      -- load last 4 slices
      when preamble_l =>
      if(count<=10) then
        current <= (current + 16) mod 200;
        count <= count + 1;
      elsif(count = 11) then
        current <= 192 + offset/2 mod 200;
        count <= count + 1;
        control_output(17 downto 16) <= "01";
      elsif(count = 12) then
        count <= count + 1;
      elsif(count = 13) then
        current_state <= preamble_c;
        control_output(25) <= '1';
        control_output(34) <= '0';
        control_output(1 downto 0) <= "11";
        control_output(27 downto 26) <= "11";
        slice <= 3;
        offset <= 15;
        count <= 0;
        if(round = 0) then 
        control_output(30) <= '1';
        else 
        control_output(30) <= '0';
        control_output(31) <= rc_bit;
        end if;
      end if;

      -- perform one slice unit cycle for parity register of slice 63
      when preamble_c =>
      current_state <= slice_l;
      offset <= 0;
      current <= 0;
      control_output(25) <= '0';
      slice <= 0;
      control_output(34) <= '1';
      control_output(1 downto 0) <= "00";
      control_output(30) <= '0';
      control_output(28) <= '1'; -- set we bit of parity register to 1

      -- load 4 slices
      when slice_l =>
      if(count<=10) then
        current <= (current + 16) mod 200;
        count <= count + 1;
      elsif(count = 11) then
        current <= 192 + offset/2 mod 200;
        count <= count + 1;
      elsif(count = 12) then
        count <= count + 1;
      elsif(count = 13) then
        current_state <= slice_c;
        control_output(25) <= '1';
        control_output(28) <= '0';
        control_output(1 downto 0) <= "01";
        control_output(34) <= '0';
        control_output(31) <= rc_bit;
        if(round = 0) then control_output(30) <= '1'; -- bypass pi/iota/chi transformations on round 0
        elsif(round = 24) then control_output(29) <= '1'; -- bypass theta transformations on round 24
        else control_output(30 downto 29) <= "00";
        end if;
      end if;

      -- perform slice unit on the four slices
      when slice_c =>
      if(slice=0) then
        control_output(1 downto 0) <= "01";
        control_output(25) <= '0';
        slice <= (slice + 1) mod 4;
        count1 <= (count1 - 1) mod 4;
      elsif(slice<=2) then
        slice <= (slice + 1) mod 4;
        count1 <= (count1 - 1) mod 4;
      elsif(slice =3) then
        count1 <= (count1 - 1) mod 4;
        current_state <= slice_w;
        ram_we_sig <= '1';
        slice <= (slice + 1) mod 4;
        count <= 0;
        current <= offset;
        control_output(34) <= '1';
        control_output(1 downto 0) <= "11"; -- reg0 and reg1 on standby
        control_output(33 downto 32) <= "11"; -- bypass rho
      end if;

      -- write 4 slices to RAM
      when slice_w =>
      if(count<=10) then
        current <= (current + 16) mod 200;
        count <= count + 1;
      elsif(count = 11) then
        current <= 192 + offset/2 mod 200;
        count <= count + 1;
      elsif(count = 12 and offset <15) then -- repeat slice phase on next slices
        count <= 0;
        offset <= offset + 1 mod 16;
        current <= offset + 1 mod 16;
        ram_we_sig <= '0';
        control_output(34) <= '1';
        control_output(1 downto 0) <= "00";
        control_output(30) <= '0';
        control_output(28) <= '1'; -- set we bit of parity register to 1
        current_state <= slice_l;
      elsif(count = 12 and offset = 15 and round /=24) then 
        count <= 0;
        offset <= 0;
        current <= 0;
        control_output(34) <= '1';
        ram_we_sig <= '0';
        control_output(1 downto 0) <= "10";
        current_state <= rho_l;
      elsif(count = 12 and offset = 15 and round = 24) then 
        count <= count + 1;
        current <= 0;
        ram_we_sig <= '0';
      elsif(count = 13 and offset = 15 and round = 24) then
        current <= 1;
        control_output(34) <= '1';
        ram_we_sig <= '0';
        current_state <= state_r;
      end if;

      -- load 2 lanes from RAM
      when rho_l => 
      if(count<=14) then
        current <= (current + 1) mod 200;
        count <= count + 1;
      elsif(count = 15) then
        count <= count + 1;
      elsif(count = 16) then
        control_output(34) <= '0';
        control_output(1 downto 0) <= "11";
        control_output(15 downto 10) <= rho_constant0_sig;
        control_output(23 downto 18) <= rho_constant1_sig;
        control_output(33 downto 32) <= "00";
        count <= 0;
        current <= 16*offset;
        current_state <= rho_c;
      end if;

      -- store first 4 nibbles in rho unit register
      when rho_c =>
      control_output(34) <= '1';
      ram_we_sig <= '1';
      control_output(15 downto 10) <= rho_constant0_sig;
      control_output(23 downto 18) <= rho_constant1_sig;
      control_output(33 downto 32) <= "00";
      current_state <= rho_w;

      -- write 2 lanes to RAM
      when rho_w =>
      if(count<=14) then
        current <= (current + 1) mod 200;
        count <= count + 1;
      elsif(count = 15 and offset <= 10) then
        offset <= offset+1 mod 12;
        current <= (offset+1)*16;
        count <= 0;
        ram_we_sig <= '0';
        control_output(34) <= '1';
        ram_we_sig <= '0';
        control_output(1 downto 0) <= "10";
        current_state <= rho_l;
      elsif(count = 15 and offset = 11) then
        ram_we_sig <= '0';
        count <= 0;
        offset <= 15;
        current <= 15;
        round <= round + 1;
        control_output(34) <= '1';
        control_output(1 downto 0) <= "00";

        current_state <= preamble_l;
      end if;

      -- write state to RAM
      when state_r =>
      if(current<200) then
        current <= (current + 1) mod 201;
      elsif(current=200) then
        current <= 0;
        round <= 0;
        ram_we_sig <= '1';
        control_output(24) <= '1';
        control_output(34) <= '1';
        current_state <= state_w;
      end if;

      when others => current_state <= preamble_l;

    end case;
    end if;
  end process;

rc: rc_bit_generator port map(round_sig, slice_sig, rc_bit);
rho_constant: rho_constant_generator port map(offset, rho_constant0_sig, rho_constant1_sig, mux_64_0, mux_64_1);

end behavioral;