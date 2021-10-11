library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity ram is
port(
 addr: in std_logic_vector(7 downto 0);
 input: in std_logic_vector(7 downto 0);
 we: in std_logic;
 clk: in std_logic;
 output: out std_logic_vector(7 downto 0)
);
end ram;

architecture behavioral of ram is

type RAM_ARRAY is array (0 to 199) of std_logic_vector (7 downto 0);

signal RAM: RAM_ARRAY :=(
   x"00",x"00",x"00",x"00",-- 0x00: 
   x"00",x"00",x"00",x"00",-- 0x04: 
   x"00",x"00",x"00",x"00",-- 0x08: 
   x"00",x"00",x"00",x"00",-- 0x0C: 
   x"00",x"00",x"00",x"00",-- 0x10: 
   x"00",x"00",x"00",x"00",-- 0x14: 
   x"00",x"00",x"00",x"00",-- 0x18: 
   x"00",x"00",x"00",x"00",-- 0x1C: 
   x"00",x"00",x"00",x"00",-- 0x20: 
   x"00",x"00",x"00",x"00",-- 0x24: 
   x"00",x"00",x"00",x"00",-- 0x28: 
   x"00",x"00",x"00",x"00",-- 0x2C: 
   x"00",x"00",x"00",x"00",-- 0x30: 
   x"00",x"00",x"00",x"00",-- 0x34: 
   x"00",x"00",x"00",x"00",-- 0x38: 
   x"00",x"00",x"00",x"00",-- 0x3C: 
   x"00",x"00",x"00",x"00",-- 0x40: 
   x"00",x"00",x"00",x"00",-- 0x44: 
   x"00",x"00",x"00",x"00",-- 0x48: 
   x"00",x"00",x"00",x"00",-- 0x4C: 
   x"00",x"00",x"00",x"00",-- 0x50: 
   x"00",x"00",x"00",x"00",-- 0x54: 
   x"00",x"00",x"00",x"00",-- 0x58: 
   x"00",x"00",x"00",x"00",-- 0x5C: 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00"
   );

begin
process(clk)
    begin
    if(rising_edge(clk)) then
        if(we='1') then
        RAM(to_integer(unsigned(addr))) <= input;
        end if;
    end if;
end process;

output <= RAM(to_integer(unsigned(addr)));
end behavioral;