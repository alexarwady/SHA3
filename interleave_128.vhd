library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity interleave_128 is

  port (
    input1: in std_logic_vector (63 downto 0);
    input2: in std_logic_vector (63 downto 0);
    output: out std_logic_vector (127 downto 0)
    );
    
end entity interleave_128;

architecture behavioral of interleave_128 is

signal temp: std_logic_vector (127 downto 0);

begin

process(temp, input1, input2)
begin
    for i in 0 to 127 loop
        if(i mod 2 = 0) then temp(i) <= input1(i/2);
        elsif(i mod 2 = 1) then temp(i) <= input2(integer(floor(real(i)/2.0)));
        end if;
    end loop;
end process;

output <= temp;

end behavioral;
