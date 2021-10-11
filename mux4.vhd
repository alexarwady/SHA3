library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4 is

  port ( 
    input1 : in  std_logic_vector(3 downto 0);
    input2 : in  std_logic_vector(3 downto 0);
    selector  : in std_logic;
    output : out std_logic_vector(3 downto 0)
    );

end entity mux4;

architecture behavioral of mux4 is 

begin

output <= input1 when selector ='0' else input2;
 
end behavioral; 


