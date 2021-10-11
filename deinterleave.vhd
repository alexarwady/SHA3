library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity deinterleave is

  port (
    input: in std_logic_vector (7 downto 0);
    output1: out std_logic_vector (3 downto 0);
    output2: out std_logic_vector (3 downto 0)
    );
    
end entity deinterleave;

architecture behavioral of deinterleave is

begin

output1(0) <= input(0);
output1(1) <= input(2);
output1(2) <= input(4);
output1(3) <= input(6);

output2(0) <= input(1);
output2(1) <= input(3);
output2(2) <= input(5);
output2(3) <= input(7);

end behavioral;