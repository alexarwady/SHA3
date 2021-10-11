library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity right_shifter is

  port (
    input: in std_logic_vector (4 downto 0);
    output: out std_logic_vector (4 downto 0)
    );
    
end entity right_shifter;

architecture behavioral of right_shifter is

begin

output(0) <= input(1);
output(1) <= input(2);
output(2) <= input(3);
output(3) <= input(4);
output(4) <= input(0);

end behavioral;
