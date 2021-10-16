library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity ram_address_tb is
end ram_address_tb;

architecture behavioral of ram_address_tb is

component ram is
port(
    addr: in integer;
    input: in std_logic_vector(7 downto 0);
    we: in std_logic;
    clk: in std_logic;
    output: out std_logic_vector(7 downto 0)
);
end component;

signal addr_sig: integer := 0;
signal input_sig: std_logic_vector(7 downto 0) := "00000000";
signal we_sig: std_logic := '0';
signal clk_sig: std_logic;
signal output_sig: std_logic_vector(7 downto 0);

begin

Tb_clkgen : process
  begin
     clk_sig <= '1';
     wait for 50 ns;
     clk_sig <= '0';
     wait for 50 ns;
end process Tb_clkgen;

Tb_addr : process
  begin
     addr_sig <= addr_sig + 1 mod 200;
     wait for 100 ns;
end process Tb_addr;

ram1: ram port map(addr_sig, input_sig, we_sig, clk_sig, output_sig);

--addr_sig <= 0, 1 after 100 ns, 2 after 200 ns;

end behavioral;