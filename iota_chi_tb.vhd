library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iota_chi_tb is
end entity iota_chi_tb;

architecture behavioral of iota_chi_tb is

component iota_chi_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    rc: in std_logic;
    output: out std_logic_vector (24 downto 0)
    );
    
end component;

signal input_sig: std_logic_vector (24 downto 0);
signal rc_sig: std_logic;
signal output_sig: std_logic_vector (24 downto 0);

begin

u1: iota_chi_unit port map(input_sig, rc_sig, output_sig);
input_sig <= "0100010001000010010000000";
rc_sig <= '1';
            

end behavioral;
