library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity interleave_state_tb is
end entity interleave_state_tb;

architecture behavioral of interleave_state_tb is

component interleave_state is
  port (
    input: in std_logic_vector (1599 downto 0);
    output: out std_logic_vector (1599 downto 0)
    );
end component;

signal input_sig, output_sig: std_logic_vector (1599 downto 0);

begin

uut: interleave_state port map(input_sig, output_sig);
input_sig <= x"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3a3";

end behavioral;