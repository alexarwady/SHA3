
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg1 is

  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (11 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
    
end entity reg1;

architecture behavioral of reg1 is

signal storedbits: std_logic_vector(63 downto 0);

begin

-- mode 00: slice phase - reading from RAM
-- mode 01: slice phase - wrtiting to RAM
-- mode 10: rho phase

p_clk: process (res, clk, mode)
  begin
    if res='0' then          
      output1 <= (others => '0');
      output2 <= (others => '0');
      storedbits <= (others => '0');
    elsif mode = "10" and clk'event and clk ='1' then 
      storedbits <= storedbits(59 downto 0) & input1;
    elsif mode = "00" and clk'event and clk ='1' then
      storedbits <= storedbits(59 downto 12) & input1 & storedbits(11 downto 0);
    elsif mode = "01" and clk'event and clk ='1' then
      storedbits <= storedbits(51 downto 12) & input2 & storedbits(11 downto 0);
    end if;
  end process p_clk;

  output1 <= storedbits;
  output2 <= storedbits(63 downto 14);

end behavioral;


