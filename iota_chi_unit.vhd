library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iota_chi_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    rc: in std_logic;
    output: out std_logic_vector (24 downto 0)
    );
    
end entity iota_chi_unit;

architecture behavioral of iota_chi_unit is

signal temp: std_logic;

begin

temp <= input(0) xor ((not input(1)) and input(2));
output(0) <= temp xor rc;
output(1) <= input(1) xor ((not input(2)) and input(3));
output(2) <= input(2) xor ((not input(3)) and input(4));
output(3) <= input(3) xor ((not input(4)) and input(0));
output(4) <= input(4) xor ((not input(0)) and input(1));

output(5) <= input(5) xor ((not input(6)) and input(7));
output(6) <= input(6) xor ((not input(7)) and input(8));
output(7) <= input(7) xor ((not input(8)) and input(9));
output(8) <= input(8) xor ((not input(9)) and input(5));
output(9) <= input(9) xor ((not input(5)) and input(6));

output(10) <= input(10) xor ((not input(11)) and input(12));
output(11) <= input(11) xor ((not input(12)) and input(13));
output(12) <= input(12) xor ((not input(13)) and input(14));
output(13) <= input(13) xor ((not input(14)) and input(10));
output(14) <= input(14) xor ((not input(10)) and input(11));

output(15) <= input(15) xor ((not input(16)) and input(17));
output(16) <= input(16) xor ((not input(17)) and input(18));
output(17) <= input(17) xor ((not input(18)) and input(19));
output(18) <= input(18) xor ((not input(19)) and input(15));
output(19) <= input(19) xor ((not input(15)) and input(16));

output(20) <= input(20) xor ((not input(21)) and input(22));
output(21) <= input(21) xor ((not input(22)) and input(23));
output(22) <= input(22) xor ((not input(23)) and input(24));
output(23) <= input(23) xor ((not input(24)) and input(20));
output(24) <= input(24) xor ((not input(20)) and input(21));

end behavioral;