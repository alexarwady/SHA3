library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity interleave_state is

  port (
    input: in std_logic_vector (1599 downto 0);
    output: out std_logic_vector (1599 downto 0)
    );
    
end entity interleave_state;

architecture behavioral of interleave_state is

component interleave_128 is
  port (
    input1: in std_logic_vector (63 downto 0);
    input2: in std_logic_vector (63 downto 0);
    output: out std_logic_vector (127 downto 0)
    );
end component;

signal s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24: std_logic_vector(63 downto 0);
signal s18_23, s3_8, s13_19, s24_4, s9_14, s15_20, s5_10, s16_21, s1_6, s11_17, s22_2, s7_12: std_logic_vector(127 downto 0);

begin

int18_23: interleave_128 port map(s18, s23, s18_23);
int3_8: interleave_128 port map(s3, s8, s3_8);
int13_19: interleave_128 port map(s13, s19, s13_19);
int24_4: interleave_128 port map(s24, s4, s24_4);
int9_14: interleave_128 port map(s9, s14, s9_14);
int15_20: interleave_128 port map(s15, s20, s15_20);
int5_10: interleave_128 port map(s5, s10, s5_10);
int16_21: interleave_128 port map(s16, s21, s16_21);
int1_6: interleave_128 port map(s1, s6, s1_6);
int11_17: interleave_128 port map(s11, s17, s11_17);
int22_2: interleave_128 port map(s22, s2, s22_2);
int7_12: interleave_128 port map(s7, s12, s7_12);

s18 <= input(1215 downto 1152);
s23 <= input(1535 downto 1472);
output(127 downto 0) <= s18_23;

s3 <= input(255 downto 192);
s8 <= input(575 downto 512);
output(255 downto 128) <= s3_8;

s13 <= input(895 downto 832);
s19 <= input(1279 downto 1216);
output(383 downto 256) <= s13_19;

s24 <= input(1599 downto 1536);
s4 <= input(319 downto 256);
output(511 downto 384) <= s24_4;

s9 <= input(639 downto 576);
s14 <= input(959 downto 896);
output(639 downto 512) <= s9_14;

s15 <= input(1023 downto 960);
s20 <= input(1343 downto 1280);
output(767 downto 640) <= s15_20;

s5 <= input(383 downto 320);
s10 <= input(703 downto 640);
output(895 downto 768) <= s5_10;

s16 <= input(1087 downto 1024);
s21 <= input(1407 downto 1344);
output(1023 downto 896) <= s16_21;

s1 <= input(127 downto 64);
s6 <= input(447 downto 384);
output(1151 downto 1024) <= s1_6;

s11 <= input(767 downto 704);
s17 <= input(1151 downto 1088);
output(1279 downto 1152) <= s11_17;

s22 <= input(1471 downto 1408);
s2 <= input(191 downto 128);
output(1407 downto 1280) <= s22_2;

s7 <= input(511 downto 448);
s12 <= input(831 downto 768);
output(1535 downto 1408) <= s7_12;

output(1599 downto 1536) <= input(63 downto 0);

end behavioral;