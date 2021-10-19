library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_64to4_tb is
end entity mux_64to4_tb;

architecture behavioral of mux_64to4_tb is 

component mux_64to4 is

  port ( 
    input : in  std_logic_vector(63 downto 0);
    selector  : in std_logic_vector(3 downto 0);
    output : out std_logic_vector(3 downto 0)
    );

end component;

signal input_sig: std_logic_vector(63 downto 0);
signal selector_sig: std_logic_vector(3 downto 0);
signal output_sig: std_logic_vector(3 downto 0);

begin

u1: mux_64to4 port map(input_sig, selector_sig, output_sig);

input_sig <= x"000000000000000F";
selector_sig <= "0000";

end behavioral;