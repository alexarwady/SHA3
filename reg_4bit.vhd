library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_4bit is

  port (
    p_in : in std_logic_vector (3 downto 0);
    res : in std_logic;
    clk : in std_logic;
    p_out : out std_logic_vector (3 downto 0)
    );
    
end entity reg_4bit;

architecture behavioral of reg_4bit is

begin

p_clk: process (res, clk)
  begin
    if (clk'event and clk ='1') then
      p_out <= p_in;                    
    end if;
  end process p_clk;

end behavioral;


