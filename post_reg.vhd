library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity post_reg is

  port (
    input1 : in std_logic_vector (63 downto 0);
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    count1: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
    
end entity post_reg;

architecture behavioral of post_reg is

signal count: integer;
signal temp: std_logic_vector(49 downto 0);

begin

-- mode 00: slice phase - reading from RAM
-- mode 01: slice phase - wrtiting to RAM
-- mode 10: rho phase
-- mode 11: standby

count <= to_integer(unsigned(count1));

p_clk: process (mode, slice, temp, input1, count)
  begin
    if(slice = "00") then temp <= input1(63 downto 16) & input1(13 downto 12);
    elsif(slice = "01") then temp <= input1(63 downto 14);
    end if;
  end process p_clk;

  output2 <= temp;
  output1 <= input1;

end behavioral;


