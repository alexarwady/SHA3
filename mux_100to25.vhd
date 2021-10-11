library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_100to25 is

  port ( 
    input : in  std_logic_vector(99 downto 0);
    selector  : in std_logic_vector(1 downto 0);
    output : out std_logic_vector(24 downto 0)
    );

end entity mux_100to25;

architecture behavioral of mux_100to25 is 

begin
process(selector)
begin
    case selector is
        when "00" => output <= input(24 downto 0);
        when "01" => output <= input(49 downto 25);
        when "10" => output <= input(74 downto 50);
        when "11" => output <= input(99 downto 75);
        when others => output <= (others => '0');
    end case;
end process;
end behavioral; 




