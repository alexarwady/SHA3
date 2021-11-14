library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg0 is

  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
    
end entity reg0;

architecture behavioral of reg0 is

signal storedbits: std_logic_vector(63 downto 0);
signal count: integer := 3;
signal temp: std_logic_vector(49 downto 0);

begin

-- mode 00: slice phase - reading from RAM
-- mode 01: slice phase - wrtiting to RAM
-- mode 10: rho phase
-- mode 11: standby

p_clk: process (res, clk, mode, slice, temp, storedbits, input1, input2, count)
  begin
    if res='0' then          
      storedbits <= (others => '0');
      count <= 3;
    elsif mode = "10" and clk'event and clk ='1' then 
      storedbits <= storedbits(59 downto 0) & input1;
    elsif mode = "00" and clk'event and clk ='1' then
      storedbits <= storedbits(59 downto 12) & input1 & storedbits(11 downto 0);
    elsif mode = "01" and clk'event and clk ='1' then
      storedbits(63 - count) <= input2(18);
      storedbits(59 - count) <= input2(3);
      storedbits(55 - count) <= input2(13);
      storedbits(51 - count) <= input2(24);
      storedbits(47 - count) <= input2(9);
      storedbits(43 - count) <= input2(15);
      storedbits(39 - count) <= input2(5);
      storedbits(35 - count) <= input2(16);
      storedbits(31 - count) <= input2(1);
      storedbits(27 - count) <= input2(11);
      storedbits(23 - count) <= input2(22);
      storedbits(19 - count) <= input2(7);

        if count = 3 and slice = "00" then
          storedbits(12) <= input2(0);
        elsif count = 3 and slice = "01" then
          storedbits(14) <= input2(0);
        elsif count = 1  and slice = "00" then
          storedbits(13) <= input2(0);
        elsif count = 1 and slice = "01" then
          storedbits(15) <= input2(0);
        end if;
      
      count <= (count - 1) mod 4;

    end if;

    if(slice = "00") then temp <= storedbits(63 downto 16) & storedbits(13 downto 12);
    elsif(slice = "01") then temp <= storedbits(63 downto 14);
    end if;
  end process p_clk;

  output2 <= temp;
  output1 <= storedbits;

end behavioral;


