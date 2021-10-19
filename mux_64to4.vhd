library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_64to4 is

  port ( 
    input : in  std_logic_vector(63 downto 0);
    selector  : in std_logic_vector(3 downto 0);
    output : out std_logic_vector(3 downto 0)
    );

end entity mux_64to4;

architecture behavioral of mux_64to4 is 

signal temp: std_logic_vector(3 downto 0);

begin
process(selector, input)
begin
    case selector is
        when "0000" => temp <= input(3 downto 0);
        when "0001" => temp <= input(7 downto 4);
        when "0010" => temp <= input(11 downto 8);
        when "0011" => temp <= input(15 downto 12);
        when "0100" => temp <= input(19 downto 16);
        when "0101" => temp <= input(23 downto 20);
        when "0110" => temp <= input(27 downto 24);
        when "0111" => temp <= input(31 downto 28);
        when "1000" => temp <= input(35 downto 32);
        when "1001" => temp <= input(39 downto 36);
        when "1010" => temp <= input(43 downto 40);
        when "1011" => temp <= input(47 downto 44);
        when "1100" => temp <= input(51 downto 48);
        when "1101" => temp <= input(55 downto 52);
        when "1110" => temp <= input(59 downto 56);
        when "1111" => temp <= input(63 downto 60);
        when others => temp <= (others => '0');
    end case;
end process;

output <= temp;

end behavioral; 



