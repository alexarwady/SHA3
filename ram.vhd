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
   x"00",x"CC",x"01",x"2D",x"63",x"A3",x"08",x"FD",x"79",x"F3",x"C3",x"94",x"93",x"5F",x"AD",x"DA", x"21",x"D3",x"AE",x"A1",x"D7",x"97",x"AD",x"55",x"62",x"DE",x"73",x"FF",x"E5",x"FB",x"F4",x"BE", x"1A",x"2E",x"5F",x"2D",x"6A",x"86",x"4D",x"FA",x"91",x"FF",x"09",x"F9",x"C6",x"01",x"7A",x"5C", x"F0",x"07",x"84",x"8F",x"9B",x"10",x"69",x"4A",x"3F",x"18",x"17",x"C1",x"D2",x"B5",x"5E",x"EC", x"86",x"88",x"22",x"5F",x"E2",x"A4",x"5B",x"3E",x"7F",x"9A",x"35",x"C9",x"19",x"FC",x"CD",x"CF", x"08",x"FF",x"36",x"20",x"F7",x"68",x"68",x"42",x"D4",x"D6",x"7F",x"C5",x"06",x"E3",x"D0",x"77", x"27",x"92",x"95",x"A1",x"1C",x"30",x"12",x"DB",x"EA",x"C0",x"FC",x"C1",x"6D",x"F7",x"CE",x"2D", x"B9",x"9A",x"AA",x"58",x"4A",x"D8",x"4A",x"13",x"8F",x"55",x"DA",x"B4",x"F5",x"D5",x"3E",x"B5", x"26",x"9E",x"3C",x"56",x"17",x"87",x"4A",x"FC",x"97",x"FB",x"DA",x"64",x"50",x"56",x"6C",x"7A", x"20",x"0C",x"FE",x"01",x"71",x"01",x"A2",x"C3",x"70",x"8C",x"48",x"96",x"BC",x"DD",x"E9",x"1E", x"53",x"6F",x"0B",x"ED",x"E1",x"BB",x"06",x"55",x"75",x"1B",x"27",x"6A",x"01",x"D1",x"65",x"67",
x"5A",x"E3",x"6B",x"3C",x"3A",x"5A",x"99",x"D7",x"E2",x"58",x"A8",x"93",x"23",x"2A",x"DF",x"63",
x"F0",x"F6",x"7C",x"FF",x"10",x"44",x"5D",x"A6" 
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