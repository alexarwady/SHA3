library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity interleave_128_tb is
end entity interleave_128_tb;

architecture behavioral of interleave_128_tb is

component interleave_128 is
  port (
    input1: in std_logic_vector (63 downto 0);
    input2: in std_logic_vector (63 downto 0);
    output: out std_logic_vector (127 downto 0)
    );
end component;

signal input1_sig, input2_sig: std_logic_vector (63 downto 0);
signal output_sig: std_logic_vector (127 downto 0);

begin

u1: interleave_128 port map(input1_sig, input2_sig, output_sig);

input1_sig <= x"a3a3a3a3a3a3a3a3";
input2_sig <= x"0000000000000000";

end behavioral;