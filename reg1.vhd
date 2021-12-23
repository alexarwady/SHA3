library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg1 is

  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    count1: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
    
end entity reg1;

architecture behavioral of reg1 is

signal storedbits: std_logic_vector(63 downto 0);
signal count: integer;
signal temp: std_logic_vector(49 downto 0);

begin

count <= to_integer(unsigned(count1));

-- mode 00: slice phase - reading from RAM
-- mode 01: slice phase - wrtiting to RAM
-- mode 10: rho phase
-- mode 11: standby

p_clk: process (res, clk, mode, slice, temp, storedbits, input1, input2, count)
  begin
    if(rising_edge(clk)) then
      if mode = "10" then 
        storedbits <= storedbits(59 downto 0) & input1;
      elsif mode = "00" then
        storedbits <= storedbits(59 downto 12) & input1 & storedbits(11 downto 0);
      elsif mode = "01" then
        storedbits(63 - count) <= input2(23);
        storedbits(59 - count) <= input2(8);
        storedbits(55 - count) <= input2(19);
        storedbits(51 - count) <= input2(4);
        storedbits(47 - count) <= input2(14);
        storedbits(43 - count) <= input2(20);
        storedbits(39 - count) <= input2(10);
        storedbits(35 - count) <= input2(21);
        storedbits(31 - count) <= input2(6);
        storedbits(27 - count) <= input2(17);
        storedbits(23 - count) <= input2(2);
        storedbits(19 - count) <= input2(12);

        if count = 2 and slice = "00" then
          storedbits(12) <= input2(0);
        elsif count = 2 and slice = "01" then
          storedbits(14) <= input2(0);
        elsif count = 0  and slice = "00" then
          storedbits(13) <= input2(0);
        elsif count = 0 and slice = "01" then
          storedbits(15) <= input2(0);
        else null;
        end if;
        
      end if;
    end if;

    if(slice = "00") then temp <= storedbits(63 downto 16) & storedbits(13 downto 12);
    elsif(slice = "01") then temp <= storedbits(63 downto 14);
    else null;
    end if;
  end process p_clk;

  output2 <= temp;
  output1 <= storedbits;

end behavioral;


