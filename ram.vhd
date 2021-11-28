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
   x"00",x"01",x"02",x"03",-- 0x00: 
   x"04",x"05",x"06",x"07",-- 0x04: 
   x"08",x"09",x"0a",x"0b",-- 0x08: 
   x"0c",x"0d",x"0e",x"0f",-- 0x0C: 
   x"10",x"11",x"12",x"13",-- 0x10: 
   x"14",x"15",x"16",x"17",-- 0x14: 
   x"18",x"19",x"1a",x"1b",-- 0x18: 
   x"1c",x"1d",x"1e",x"1f",-- 0x1C: 
   x"20",x"21",x"22",x"23",-- 0x20: 
   x"24",x"25",x"26",x"27",-- 0x24: 
   x"28",x"29",x"2a",x"2b",-- 0x28: 
   x"2c",x"2d",x"2e",x"2f",-- 0x2C: 
   x"30",x"31",x"32",x"33",-- 0x30: 
   x"34",x"35",x"36",x"37",-- 0x34: 
   x"38",x"39",x"3a",x"3b",-- 0x38: 
   x"3d",x"3c",x"3e",x"3f",-- 0x3C: 
   x"40",x"41",x"42",x"43",-- 0x40: 
   x"44",x"45",x"46",x"47",-- 0x44: 
   x"48",x"49",x"4a",x"4b",-- 0x48: 
   x"4c",x"4d",x"4e",x"4f",-- 0x4C: 
   x"50",x"51",x"52",x"53",-- 0x50: 
   x"54",x"55",x"56",x"57",-- 0x54: 
   x"58",x"59",x"5a",x"5b",-- 0x58: 
   x"5c",x"5d",x"5e",x"5f",-- 0x5C: 
   x"60",x"61",x"62",x"63",-- 0x60: 
   x"64",x"65",x"66",x"67",-- 0x64: 
   x"68",x"69",x"6a",x"6b",-- 0x68: 
   x"6c",x"6d",x"6e",x"6f",-- 0x6C: 
   x"70",x"71",x"72",x"73",-- 0x70: 
   x"74",x"75",x"76",x"77",-- 0x74: 
   x"78",x"79",x"7a",x"7b",-- 0x78: 
   x"7c",x"7d",x"7e",x"7f",-- 0x7C: 
   x"80",x"81",x"82",x"83",-- 0x80: 
   x"84",x"85",x"86",x"87",-- 0x84: 
   x"88",x"89",x"8a",x"8b",-- 0x88: 
   x"8c",x"8d",x"8e",x"8f",-- 0x8C: 
   x"90",x"91",x"92",x"93",-- 0x90: 
   x"94",x"95",x"96",x"97",-- 0x94: 
   x"98",x"99",x"9a",x"9b",-- 0x98: 
   x"9c",x"9d",x"9e",x"9f",-- 0x9C: 
   x"a0",x"a1",x"a2",x"a3",-- 0xA0: 
   x"a4",x"a5",x"a6",x"a7",-- 0xA4: 
   x"a8",x"a9",x"aa",x"ab",-- 0xA8: 
   x"ac",x"ad",x"ae",x"af",-- 0xAC: 
   x"b0",x"b1",x"b2",x"b3",-- 0xB0: 
   x"b4",x"b5",x"b6",x"b7",-- 0xB4: 
   x"b8",x"b9",x"ba",x"bb",-- 0xB8: 
   x"bc",x"bd",x"be",x"bf",-- 0xBC: 
   x"c0",x"c1",x"c2",x"c3",-- 0xC0: 
   x"c4",x"c5",x"c6",x"c7" -- 0xC4: 
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