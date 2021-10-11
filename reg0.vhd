library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg0 is

  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (12 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic;
    output1 : out std_logic_vector (3 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
    
end entity reg0;

architecture behavioral of reg0 is

signal storedbits_ro: std_logic_vector(63 downto 0);

begin

-- mode 0: ro phase
-- mode 1: slice processing phase

p_clk: process (res, clk, mode)
  begin
    if res='0' then          
      output1 <= (others => '0');
      output2 <= (others => '0');
      storedbits_ro <= (others => '0');
      storedbits_slice <= (others => '0');
    elsif mode = '0' and clk'event and clk ='1' then
      output1 <= storedbits_ro(63 downto 60); 
      storedbits_ro <= storedbits_ro(59 downto 0) & input1;
    elsif mode = '1' and clk'event and clk ='1' then
      output2 <= storedbits_slice; 
      storedbits_slice <= storedbits_slice(45 downto 0) & input1;
      -- ???            
    end if;
  end process p_clk;

end behavioral;


