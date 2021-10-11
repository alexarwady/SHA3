library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rho_unit_tb is
end entity rho_unit_tb;

architecture behavioral of rho_unit_tb is

component rho_unit is
  port (
    input : in std_logic_vector (3 downto 0);
    res : in std_logic;
    clk : in std_logic;
    shift : std_logic_vector (7 downto 0);
    output : out std_logic_vector (3 downto 0)
    );   
end component;

signal input_sig: std_logic_vector(3 downto 0);
signal res_sig: std_logic := '0';
signal clk_sig: std_logic;
signal shift_sig: std_logic_vector (7 downto 0);
signal output_sig: std_logic_vector (3 downto 0);

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

input_sig <= "0101", "1000" after 101 ns, "0101" after 201 ns, "1000" after 301 ns, "0101" after 401 ns, "1000" after 501 ns;
shift_sig <= "00111110";

u1: rho_unit port map(input_sig, res_sig, clk_sig, shift_sig, output_sig);

end behavioral;