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

begin
process(selector)
begin
    case selector is
        when "0000" => output <= input(3 downto 0);
        when "0001" => output <= input(7 downto 4);
        when "0010" => output <= input(11 downto 8);
        when "0011" => output <= input(15 downto 12);
        when "0100" => output <= input(19 downto 16);
        when "0101" => output <= input(23 downto 20);
        when "0110" => output <= input(27 downto 24);
        when "0111" => output <= input(31 downto 28);
        when "1000" => output <= input(35 downto 32);
        when "1001" => output <= input(39 downto 36);
        when "1010" => output <= input(43 downto 40);
        when "1011" => output <= input(47 downto 44);
        when "1100" => output <= input(51 downto 48);
        when "1101" => output <= input(55 downto 52);
        when "1110" => output <= input(59 downto 56);
        when "1111" => output <= input(63 downto 60);
        when others => output <= (others => '0');
    end case;
end process;
end behavioral; 



