library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slice_unit_tb is
end entity slice_unit_tb;

architecture behavioral of slice_unit_tb is

component slice_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    rc: in std_logic;
    bypass_pi_iota_chi: in std_logic;
    bypass_theta: in std_logic;
    we_reg: in std_logic;
    output: out std_logic_vector (24 downto 0)
    );
    
end component;

signal input_sig: std_logic_vector (24 downto 0);
signal res_sig: std_logic := '0';
signal clk_sig: std_logic;
signal rc_sig: std_logic;
signal we_reg_sig: std_logic := '0';
signal bypass_pi_iota_chi_sig: std_logic;
signal bypass_theta_sig: std_logic;
signal output_sig: std_logic_vector (24 downto 0);

begin

Tb_res: process
begin
  wait for 100 ns;
  res_sig <= '1';
end process Tb_res;

Tb_clkgen : process
  begin
     clk_sig <= '1';
     wait for 50 ns;
     clk_sig <= '0';
     wait for 50 ns;
end process Tb_clkgen;

--input_sig <= "0101010101010010010100000", "1100010100100000100110010" after 100 ns;

--input_sig <= "0110101100100101001010010";
--input_sig <= "0101010101010010010100000";
--input_sig <= "0100000001000010000010010";
--input_sig <= "0100100001010000101001010";

input_sig <= "0000000000000000111111111", "0000000000000000111111111" after 100 ns, "0000000000000000111111111" after 200 ns, "0000000000000000000000000" after 300 ns, "0000000000000000000000000" after 400 ns;
rc_sig <= '0';
bypass_pi_iota_chi_sig <= '1';
bypass_theta_sig <= '0';

u1: slice_unit port map(input_sig, res_sig, clk_sig, rc_sig, bypass_pi_iota_chi_sig, bypass_theta_sig, we_reg_sig, output_sig);

end behavioral;