library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity address_generator is
port(
    clk: in std_logic;
    res: in std_logic;
    mode: in std_logic; -- 0 for slice phase, 1 for rho phase
    offset: in integer; --between 0 and 7
    output: out integer
);
end address_generator;

architecture behavioral of address_generator is

signal current: integer := 0;
signal count: integer := 0; -- between 0 and 12

begin

p_clk: process (res, clk, mode)
  begin
    if res='0' then          
      current <= 0;
      count <= 0;
    elsif(clk'event and clk ='1' and mode = '0' and count <=11) then
      current <= (current + 16) mod 200; -- 8 * offset + 128 (in bits)
      count <= count + 1;
    elsif(clk'event and clk ='1' and mode = '0' and count = 12) then
      current <= offset;
      count <= 0;
    elsif(clk'event and clk ='1' and mode = '1') then
      current <= current + 1;
    end if;
  end process p_clk;

output <= current;

end behavioral;