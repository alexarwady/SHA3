library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg0_new_tb is
end entity reg0_new_tb;

architecture behavioral of reg0_new_tb is

component reg0_new is
port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    count1: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
end component;

signal input1: std_logic_vector(3 downto 0);
signal input2: std_logic_vector (24 downto 0);
signal res, clk : std_logic;
signal mode, slice, count1: std_logic_vector(1 downto 0);
signal output1 : std_logic_vector (63 downto 0);
signal output2 : std_logic_vector (49 downto 0);

begin

res <= '1';

Tb_clkgen : process
    begin
        clk <= '1';
        wait for 50 ns;
        clk <= '0';
        wait for 50 ns;
end process Tb_clkgen;

mode <= "10";
input1 <= "1111", "1010" after 100 ns, "1111" after 200 ns;

u1: reg0_new port map(input1, input2, res, clk, mode, slice, count1, output1, output2);

end behavioral;
