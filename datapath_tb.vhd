library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath_tb is 
end entity datapath_tb;

architecture behavioral of datapath_tb is

component datapath is
  port (
    ram_out: in std_logic_vector(7 downto 0);
    ram_in: out std_logic_vector(7 downto 0);
    clk: in std_logic;
    res: in std_logic;
    control: in std_logic_vector(32 downto 0)
    );
end component;

signal ram_out_sig: std_logic_vector(7 downto 0);
signal ram_in_sig: std_logic_vector(7 downto 0);
signal clk_sig: std_logic;
signal res_sig: std_logic := '0';
signal control_sig: std_logic_vector(32 downto 0);

begin

Tb_res: process
begin
  wait for 99 ns;
  res_sig <= '1';
end process Tb_res;

Tb_clkgen : process
  begin
     clk_sig <= '1';
     wait for 50 ns;
     clk_sig <= '0';
     wait for 50 ns;
end process Tb_clkgen;

u1: datapath port map(ram_out_sig, ram_in_sig, clk_sig, res_sig, control_sig);

ram_out_sig <= "00000000",
"00001010" after 99 ns, 
"00001100" after 199 ns,
"00000100" after 299 ns,
"00000010" after 399 ns,
"00000000" after 499 ns,
"00001101" after 599 ns,
"00001010" after 699 ns,
"00000000" after 799 ns,
"00001101" after 899 ns,
"00000000" after 999 ns,
"00000000" after 1099 ns,
"00000000" after 1199 ns,
"00000000" after 1299 ns;

control_sig <= "000010000000000000000000000000000";

end behavioral;
