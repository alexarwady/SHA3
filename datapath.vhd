library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is

  port (
    ram_out: in std_logic_vector(7 downto 0);
    ram_in: out std_logic_vector(7 downto 0);
    clk: in std_logic;
    res: in std_logic;
    control: in std_logic_vector(33 downto 0)
    );
    
end entity datapath;

architecture behavioral of datapath is

component deinterleave is
  port (
    input: in std_logic_vector (7 downto 0);
    output1: out std_logic_vector (3 downto 0);
    output2: out std_logic_vector (3 downto 0)
    );
end component;

component reg0 is
  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
end component;

component reg1 is
  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
end component;

component mux_64to4 is
  port ( 
    input : in  std_logic_vector(63 downto 0);
    selector  : in std_logic_vector(3 downto 0);
    output : out std_logic_vector(3 downto 0)
    );
end component;

component rho_unit is
  port (
    input : in std_logic_vector (3 downto 0);
    res : in std_logic;
    clk : in std_logic;
    shift : in std_logic_vector (5 downto 0);
    output : out std_logic_vector (3 downto 0)
    );  
end component;

component mux_100to25 is
  port ( 
    input : in  std_logic_vector(99 downto 0);
    selector  : in std_logic_vector(1 downto 0);
    output : out std_logic_vector(24 downto 0)
    );
end component;

component slice_unit is
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
end component;

component mux4 is
  port ( 
    input1 : in  std_logic_vector(3 downto 0);
    input2 : in  std_logic_vector(3 downto 0);
    selector  : in std_logic;
    output : out std_logic_vector(3 downto 0)
    );
end component;

component interleave is
  port (
    input1: in std_logic_vector (3 downto 0);
    input2: in std_logic_vector (3 downto 0);
    output: out std_logic_vector (7 downto 0)
    );
end component;

signal deinterleave_sig_r0, deinterleave_sig_r1: std_logic_vector(3 downto 0);
signal rho0_out, rho1_out, rho0_in, rho1_in: std_logic_vector(3 downto 0);
signal mux0_out, mux1_out: std_logic_vector(3 downto 0);
signal reg0_out_50, reg1_out_50: std_logic_vector(49 downto 0);
signal slice_in, slice_out: std_logic_vector(24 downto 0);
signal sig_100: std_logic_vector(99 downto 0);
signal reg0_out_rho0, reg1_out_rho1: std_logic_vector(63 downto 0);
signal interleave_out: std_logic_vector(7 downto 0);

begin

deint: deinterleave port map(ram_out, deinterleave_sig_r0, deinterleave_sig_r1);
register0: reg0 port map(deinterleave_sig_r0, slice_out, res, clk, control(1 downto 0), control(27 downto 26), reg0_out_rho0, reg0_out_50);
register1: reg1 port map(deinterleave_sig_r1, slice_out, res, clk, control(1 downto 0), control(27 downto 26), reg1_out_rho1, reg1_out_50);
mux64_0: mux_64to4 port map(reg0_out_rho0, control(5 downto 2), rho0_in);
mux64_1: mux_64to4 port map(reg1_out_rho1, control(9 downto 6), rho1_in);
rho0: rho_unit port map(rho0_in, res, clk, control(15 downto 10), rho0_out);
rho1: rho_unit port map(rho1_in, res, clk, control(23 downto 18), rho1_out);
mux0: mux4 port map(rho0_out, rho0_in, control(32), mux0_out);
mux1: mux4 port map(rho1_out, rho1_in, control(33), mux1_out);
mux25: mux_100to25 port map(sig_100, control(27 downto 26), slice_in);
slice: slice_unit port map(slice_in, res, clk, control(31), control(30), control(29), control(28), slice_out);
inter: interleave port map(mux0_out, mux1_out, interleave_out);
ram_in <= interleave_out;

-- hardcoded sig_100 into slice3, slice2, slice1, slice0

sig_100(99) <= reg0_out_50(37);     sig_100(74) <= reg0_out_50(36);     sig_100(49) <= reg0_out_50(35);     sig_100(24) <= reg0_out_50(34);
sig_100(98) <= reg1_out_50(49);     sig_100(73) <= reg1_out_50(48);     sig_100(48) <= reg1_out_50(47);     sig_100(23) <= reg1_out_50(46);
sig_100(97) <= reg0_out_50(9);      sig_100(72) <= reg0_out_50(8);      sig_100(47) <= reg0_out_50(7);      sig_100(22) <= reg0_out_50(6);
sig_100(96) <= reg1_out_50(21);     sig_100(71) <= reg1_out_50(20);     sig_100(46) <= reg1_out_50(19);     sig_100(21) <= reg1_out_50(18);
sig_100(95) <= reg1_out_50(29);     sig_100(70) <= reg1_out_50(28);     sig_100(45) <= reg1_out_50(27);     sig_100(20) <= reg1_out_50(26);
sig_100(94) <= reg1_out_50(41);     sig_100(69) <= reg1_out_50(40);     sig_100(44) <= reg1_out_50(39);     sig_100(19) <= reg1_out_50(38);
sig_100(93) <= reg0_out_50(49);     sig_100(68) <= reg0_out_50(48);     sig_100(43) <= reg0_out_50(47);     sig_100(18) <= reg0_out_50(46);
sig_100(92) <= reg1_out_50(13);     sig_100(67) <= reg1_out_50(12);     sig_100(42) <= reg1_out_50(11);     sig_100(17) <= reg1_out_50(10);
sig_100(91) <= reg0_out_50(21);     sig_100(66) <= reg0_out_50(20);     sig_100(41) <= reg0_out_50(19);     sig_100(16) <= reg0_out_50(18);
sig_100(90) <= reg0_out_50(29);     sig_100(65) <= reg0_out_50(28);     sig_100(40) <= reg0_out_50(27);     sig_100(15) <= reg0_out_50(26);
sig_100(89) <= reg1_out_50(33);     sig_100(64) <= reg1_out_50(32);     sig_100(39) <= reg1_out_50(31);     sig_100(14) <= reg1_out_50(30);
sig_100(88) <= reg0_out_50(41);     sig_100(63) <= reg0_out_50(40);     sig_100(38) <= reg0_out_50(39);     sig_100(13) <= reg0_out_50(38);
sig_100(87) <= reg1_out_50(5);      sig_100(62) <= reg1_out_50(4);      sig_100(37) <= reg1_out_50(3);      sig_100(12) <= reg1_out_50(2);
sig_100(86) <= reg0_out_50(13);     sig_100(61) <= reg0_out_50(12);     sig_100(36) <= reg0_out_50(11);     sig_100(11) <= reg0_out_50(10);
sig_100(85) <= reg1_out_50(25);     sig_100(60) <= reg1_out_50(24);     sig_100(35) <= reg1_out_50(23);     sig_100(10) <= reg1_out_50(22);
sig_100(84) <= reg0_out_50(33);     sig_100(59) <= reg0_out_50(32);     sig_100(34) <= reg0_out_50(31);     sig_100(9) <= reg0_out_50(30);
sig_100(83) <= reg1_out_50(45);     sig_100(58) <= reg1_out_50(44);     sig_100(33) <= reg1_out_50(43);     sig_100(8) <= reg1_out_50(42);
sig_100(82) <= reg0_out_50(5);      sig_100(57) <= reg0_out_50(4);      sig_100(32) <= reg0_out_50(3);      sig_100(7) <= reg0_out_50(2);
sig_100(81) <= reg1_out_50(17);     sig_100(56) <= reg1_out_50(16);     sig_100(31) <= reg1_out_50(15);     sig_100(6) <= reg1_out_50(14);
sig_100(80) <= reg0_out_50(25);     sig_100(55) <= reg0_out_50(24);     sig_100(30) <= reg0_out_50(23);     sig_100(5) <= reg0_out_50(22);
sig_100(79) <= reg1_out_50(37);     sig_100(54) <= reg1_out_50(36);     sig_100(29) <= reg1_out_50(35);     sig_100(4) <= reg1_out_50(34);
sig_100(78) <= reg0_out_50(45);     sig_100(53) <= reg0_out_50(44);     sig_100(28) <= reg0_out_50(43);     sig_100(3) <= reg0_out_50(42);
sig_100(77) <= reg1_out_50(9);      sig_100(52) <= reg1_out_50(8);      sig_100(27) <= reg1_out_50(7);      sig_100(2) <= reg1_out_50(6);
sig_100(76) <= reg0_out_50(17);     sig_100(51) <= reg0_out_50(16);     sig_100(26) <= reg0_out_50(15);     sig_100(1) <= reg0_out_50(14);
sig_100(75) <= reg1_out_50(1);      sig_100(50) <= reg0_out_50(1);      sig_100(25) <= reg1_out_50(0);      sig_100(0) <= reg0_out_50(0);

end behavioral;
