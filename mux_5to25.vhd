library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_5to25 is

  port ( 
    input1 : in  std_logic_vector(4 downto 0);
    input2 : in  std_logic_vector(24 downto 0);
    selector  : in std_logic;
    output : out std_logic_vector(24 downto 0)
    );

end entity mux_5to25;

architecture behavioral of mux_5to25 is 

signal temp: std_logic_vector(24 downto 0);

begin

-- replicate the 5 bits into a 25 bits vector
temp(18) <= input1(0); temp(19) <= input1(1); temp(15) <= input1(2); temp(16) <= input1(3); temp(17) <= input1(4);
temp(23) <= input1(0); temp(24) <= input1(1); temp(20) <= input1(2); temp(21) <= input1(3); temp(22) <= input1(4);
temp(3) <= input1(0); temp(4) <= input1(1); temp(0) <= input1(2); temp(1) <= input1(3); temp(2) <= input1(4);
temp(8) <= input1(0); temp(9) <= input1(1); temp(5) <= input1(2); temp(6) <= input1(3); temp(7) <= input1(4);
temp(13) <= input1(0); temp(14) <= input1(1); temp(10) <= input1(2); temp(11) <= input1(3); temp(12) <= input1(4);

output <= temp when selector ='0' else input2;
 
end behavioral; 


