library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pi_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    output: out std_logic_vector (24 downto 0)
    );
    
end entity pi_unit;

architecture behavioral of pi_unit is

begin

output(0) <= input(0);
output(1) <= input(6);
output(2) <= input(12);
output(3) <= input(18);
output(4) <= input(24);
output(5) <= input(3);
output(6) <= input(9);
output(7) <= input(10);
output(8) <= input(16);
output(9) <= input(22);
output(10) <= input(1);
output(11) <= input(7);
output(12) <= input(13);
output(13) <= input(19);
output(14) <= input(20);
output(15) <= input(4);
output(16) <= input(5);
output(17) <= input(11);
output(18) <= input(17);
output(19) <= input(23);
output(20) <= input(2);
output(21) <= input(8);
output(22) <= input(14);
output(23) <= input(15);
output(24) <= input(21);

end behavioral;