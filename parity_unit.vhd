library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parity_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    output: out std_logic_vector (4 downto 0)
    );
    
end entity parity_unit;

architecture behavioral of parity_unit is

begin

output(0) <= input(18) xor input(23) xor input(3) xor input(8) xor input(13);
output(1) <= input(19) xor input(24) xor input(4) xor input(9) xor input(14);
output(2) <= input(15) xor input(20) xor input(0) xor input(5) xor input(10);
output(3) <= input(16) xor input(21) xor input(1) xor input(6) xor input(11);
output(4) <= input(17) xor input(22) xor input(2) xor input(7) xor input(12);

end behavioral;