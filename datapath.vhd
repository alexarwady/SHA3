library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is

  port (
    input : in std_logic_vector (3 downto 0);
    res : in std_logic;
    clk : in std_logic;
    shift : std_logic_vector (7 downto 0);
    output : out std_logic_vector (3 downto 0)
    );
    
end entity datapath;

architecture 