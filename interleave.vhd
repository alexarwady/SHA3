library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interleave is

  port (
    input1: in std_logic_vector (3 downto 0);
    input2: in std_logic_vector (3 downto 0);
    output: out std_logic_vector (7 downto 0)
    );
    
end entity interleave;

architecture behavioral of interleave is

begin

output(0) <= input1(0);
output(1) <= input2(0);
output(2) <= input1(1);
output(3) <= input2(1);
output(4) <= input1(2);
output(5) <= input2(2);
output(6) <= input1(3);
output(7) <= input2(3);

end behavioral;
