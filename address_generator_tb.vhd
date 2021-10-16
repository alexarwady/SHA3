library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity address_generator_tb is
end address_generator_tb;

architecture behavioral of address_generator_tb is

component address_generator is
port(
    clk: in std_logic;
    res: in std_logic;
    mode: in std_logic;
    offset: in integer;
    output: out integer
);
end component;

signal clk_sig: std_logic;
signal res_sig: std_logic := '0';
signal mode_sig: std_logic := '0';
signal offset_sig: integer := 0;
signal output_sig: integer := 0;

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

u1: address_generator port map(clk_sig, res_sig, mode_sig, offset_sig, output_sig);

end behavioral;