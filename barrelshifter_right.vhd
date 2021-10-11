library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrelshifter_right is

  port (
    input: in std_logic_vector (3 downto 0);
    shift: in integer;
    output: out std_logic_vector (3 downto 0)
    );
    
end entity barrelshifter_right;

architecture behavioral of barrelshifter_right is

begin

output <= std_logic_vector(shift_right(unsigned(input), shift));

end behavioral;
