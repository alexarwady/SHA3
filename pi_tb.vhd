library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pi_tb is
end entity pi_tb;

architecture behavioral of pi_tb is

component pi_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    output: out std_logic_vector (24 downto 0)
    );
    
end component;

signal input_sig: std_logic_vector (24 downto 0);
signal output_sig: std_logic_vector (24 downto 0);

begin

u1: pi_unit port map(input_sig, output_sig);
input_sig <= "0100000001000010000010010";
              


end behavioral;