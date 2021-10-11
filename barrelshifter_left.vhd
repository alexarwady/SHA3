library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrelshifter_left is

  port (
    input: in std_logic_vector (3 downto 0);
    shift: in integer;
    output: out std_logic_vector (3 downto 0)
    );
    
end entity barrelshifter_left;

architecture behavioral of barrelshifter_left is

begin

output <= std_logic_vector(shift_left(unsigned(input), shift));

end behavioral;


