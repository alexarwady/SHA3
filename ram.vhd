library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity ram is
port(
    addr_r: in integer;
    input: in std_logic_vector(7 downto 0);
    we: in std_logic;
    clk: in std_logic;
    output: out std_logic_vector(7 downto 0)
);
end ram;

architecture behavioral of ram is

type RAM_ARRAY is array (0 to 199) of std_logic_vector (7 downto 0);

-- RAM ORGANIZATION:
-- 0x00 -> 0x0C : lanes 18 and 23
-- 0x10 -> 0x1C : lanes 3 and 8
-- 0x20 -> 0x2C : lanes 13 and 19
-- 0x30 -> 0x3C : lanes 24 and 4
-- 0x40 -> 0x4C : lanes 9 and 14
-- 0x50 -> 0x5C : lanes 15 and 20
-- 0x60 -> 0x6C : lanes 5 and 10
-- 0x70 -> 0x7C : lanes 16 and 21
-- 0x80 -> 0x8C : lanes 1 and 6
-- 0x90 -> 0x9C : lanes 11 and 17
-- 0xA0 -> 0xAC : lanes 22 and 2
-- 0xB0 -> 0xBC : lanes 7 and 12
-- 0xC0 -> 0xC4 : lane 0 (non-interleaved)

signal RAM: RAM_ARRAY :=(
   x"00",x"00",x"00",x"00",-- 0x00: 
   x"00",x"00",x"00",x"00",-- 0x04: 
   x"00",x"00",x"00",x"00",-- 0x08: 
   x"00",x"00",x"00",x"00",-- 0x0C: 
   x"0F",x"CC",x"0F",x"CC",-- 0x10: 
   x"0F",x"CC",x"0F",x"CC",-- 0x14: 
   x"0F",x"CC",x"0F",x"CC",-- 0x18: 
   x"0F",x"CC",x"0F",x"CC",-- 0x1C: 
   x"00",x"00",x"00",x"00",-- 0x20: 
   x"00",x"00",x"00",x"00",-- 0x24: 
   x"00",x"00",x"00",x"00",-- 0x28: 
   x"00",x"00",x"00",x"00",-- 0x2C: 
   x"0A",x"88",x"0A",x"88",-- 0x30: 
   x"0A",x"88",x"0A",x"88",-- 0x34: 
   x"0A",x"88",x"0A",x"88",-- 0x38: 
   x"0A",x"88",x"0A",x"88",-- 0x3C: 
   x"00",x"00",x"00",x"00",-- 0x40: 
   x"00",x"00",x"00",x"00",-- 0x44: 
   x"00",x"00",x"00",x"00",-- 0x48: 
   x"00",x"00",x"00",x"00",-- 0x4C: 
   x"00",x"00",x"00",x"00",-- 0x50: 
   x"00",x"00",x"00",x"00",-- 0x54: 
   x"00",x"00",x"00",x"00",-- 0x58: 
   x"00",x"00",x"00",x"00",-- 0x5C: 
   x"05",x"44",x"05",x"44",-- 0x60: 
   x"05",x"44",x"05",x"44",-- 0x64: 
   x"05",x"44",x"05",x"44",-- 0x68: 
   x"05",x"44",x"05",x"44",-- 0x6C: 
   x"00",x"00",x"00",x"00",-- 0x70: 
   x"00",x"00",x"00",x"00",-- 0x74: 
   x"00",x"00",x"00",x"00",-- 0x78: 
   x"00",x"00",x"00",x"00",-- 0x7C: 
   x"0F",x"CC",x"0F",x"CC",-- 0x80: 
   x"0F",x"CC",x"0F",x"CC",-- 0x84: 
   x"0F",x"CC",x"0F",x"CC",-- 0x88: 
   x"0F",x"CC",x"0F",x"CC",-- 0x8C: 
   x"00",x"00",x"00",x"00",-- 0x90: 
   x"00",x"00",x"00",x"00",-- 0x94: 
   x"00",x"00",x"00",x"00",-- 0x98: 
   x"00",x"00",x"00",x"00",-- 0x9C: 
   x"0A",x"88",x"0A",x"88",-- 0xA0: 
   x"0A",x"88",x"0A",x"88",-- 0xA4: 
   x"0A",x"88",x"0A",x"88",-- 0xA8: 
   x"0A",x"88",x"0A",x"88",-- 0xAC: 
   x"05",x"44",x"05",x"44",-- 0xB0: 
   x"05",x"44",x"05",x"44",-- 0xB4: 
   x"05",x"44",x"05",x"44",-- 0xB8: 
   x"05",x"44",x"05",x"44",-- 0xBC: 
   x"A3",x"A3",x"A3",x"A3",-- 0xC0: 
   x"A3",x"A3",x"A3",x"A3" -- 0xC4: 
   );

begin
process(clk, addr_r, input, we, RAM)
    begin
    if(rising_edge(clk)) then
        if(we='1') then
        RAM(addr_r) <= input;
        end if;
    end if;
    if(addr_r <0 or addr_r >199) then
    output <= RAM(15);
    else output <= RAM(addr_r);
    end if;
end process;


end behavioral;