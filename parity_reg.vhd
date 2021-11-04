library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parity_reg is

  port (
    p_in : in std_logic_vector (4 downto 0);
    res : in std_logic;
    clk : in std_logic;
    we: in std_logic;
    p_out : out std_logic_vector (4 downto 0)
    );
    
end entity parity_reg;

architecture behavioral of parity_reg is

begin

p_clk: process (res, clk)
  begin
    if res='0' then          
      p_out <= (others => '0');
    elsif clk'event and clk ='1' and we = '0' then
      p_out <= p_in;                    
    end if;
  end process p_clk;

end behavioral;

