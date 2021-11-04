library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_tb is
end entity control_unit_tb;

architecture behavioral of control_unit_tb is

component control_unit is
  port (
    clk: in std_logic;
    res: in std_logic;
    control_out: out std_logic_vector(33 downto 0);
    ram_we: out std_logic;
    ram_out: out integer
    );
end component;

signal clk_sig, ram_we_sig: std_logic;
signal res_sig: std_logic := '0';
signal control_out_sig: std_logic_vector(33 downto 0);
signal ram_out_sig: integer;

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

u1: control_unit port map(clk_sig, res_sig, control_out_sig, ram_we_sig, ram_out_sig);

end behavioral;