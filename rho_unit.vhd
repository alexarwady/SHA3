library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rho_unit is

  port (
    input : in std_logic_vector (3 downto 0);
    res : in std_logic;
    clk : in std_logic;
    shift : in std_logic_vector (5 downto 0);
    output : out std_logic_vector (3 downto 0)
    );
    
end entity rho_unit;

architecture behavioral of rho_unit is

component reg_4bit is
  port (
    p_in : in std_logic_vector (3 downto 0);
    res : in std_logic;
    clk : in std_logic;
    p_out : out std_logic_vector (3 downto 0)
    );
end component;

component barrelshifter_right is
  port (
    input: in std_logic_vector (3 downto 0);
    shift: in integer;
    output: out std_logic_vector (3 downto 0)
    );  
end component;

component barrelshifter_left is
  port (
    input: in std_logic_vector (3 downto 0);
    shift: in integer;
    output: out std_logic_vector (3 downto 0)
    );
end component;

signal modulo: integer;
signal modulo1: integer;
signal out_reg, out_shift_left, out_shift_right: std_logic_vector(3 downto 0);

begin

modulo <= to_integer(unsigned(shift)) mod 4;
modulo1 <= 4-modulo;
reg: reg_4bit port map(input, res, clk, out_reg);
b_left: barrelshifter_left port map(input, modulo, out_shift_left);
b_right: barrelshifter_right port map(out_reg, modulo1, out_shift_right);
output <= out_shift_left xor out_shift_right;

end behavioral;