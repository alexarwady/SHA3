library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity slice_unit is

  port (
    input: in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    rc: in std_logic;
    bypass_pi_iota_chi: in std_logic;
    bypass_theta: in std_logic;
    we_reg: in std_logic;
    output: out std_logic_vector (24 downto 0)
    );
    
end entity slice_unit;

architecture behavioral of slice_unit is

component left_shifter is
  port (
    input: in std_logic_vector (4 downto 0);
    output: out std_logic_vector (4 downto 0)
    ); 
end component;

component rc_bit_generator is
  port (
    round : in unsigned(4 downto 0);
    slice : in unsigned(5 downto 0);
    rc_bit: out std_logic
    );
end component;

component right_shifter is
  port (
    input: in std_logic_vector (4 downto 0);
    output: out std_logic_vector (4 downto 0)
    );
end component;

component pi_unit is
  port (
    input: in std_logic_vector (24 downto 0);
    output: out std_logic_vector (24 downto 0)
    );   
end component;

component parity_unit is
  port (
    input: in std_logic_vector (24 downto 0);
    output: out std_logic_vector (4 downto 0)
    );
end component;

component parity_reg is
  port (
    p_in : in std_logic_vector (4 downto 0);
    res : in std_logic;
    clk : in std_logic;
    we: in std_logic;
    p_out : out std_logic_vector (4 downto 0)
    );
end component;

component mux25 is
  port ( 
    input1 : in  std_logic_vector(24 downto 0);
    input2 : in  std_logic_vector(24 downto 0);
    selector  : in std_logic;
    output : out std_logic_vector(24 downto 0)
    );
end component;

component iota_chi_unit is
  port (
    input: in std_logic_vector (24 downto 0);
    rc: in std_logic;
    output: out std_logic_vector (24 downto 0)
    );
end component;

component mux_5to25 is
  port ( 
    input1 : in  std_logic_vector(4 downto 0);
    input2 : in  std_logic_vector(24 downto 0);
    selector  : in std_logic;
    output : out std_logic_vector(24 downto 0)
    );
end component;

signal pi_out, iota_chi_out, mux1_out, mux2_out: std_logic_vector(24 downto 0);
signal parity_out, parity_reg_out, left_out, right_out, temp: std_logic_vector(4 downto 0);

begin

u1: pi_unit port map(input, pi_out);
u2: iota_chi_unit port map(pi_out, rc, iota_chi_out);
mux1: mux25 port map(iota_chi_out, input, bypass_pi_iota_chi, mux1_out);
u3: parity_unit port map(mux1_out, parity_out);
u4: parity_reg port map(parity_out, res, clk, we_reg, parity_reg_out);
u5: left_shifter port map(parity_out, left_out);
u6: right_shifter port map(parity_reg_out, right_out);
temp <= left_out xor right_out;
mux2: mux_5to25 port map(temp, "0000000000000000000000000", bypass_theta, mux2_out);
output <= mux2_out xor mux1_out;

end behavioral;
