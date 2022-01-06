library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sha3 is
  port (
    clk: in std_logic;
    res: in std_logic;
    pt: in std_logic_vector(7 downto 0);
    ct: out std_logic_vector(7 downto 0);
    current: out std_logic_vector(7 downto 0)
  );
end entity sha3;

architecture behavioral of sha3 is

component datapath is
  port (
    ram_out: in std_logic_vector(7 downto 0);
    ram_in: out std_logic_vector(7 downto 0);
    clk: in std_logic;
    res: in std_logic;
    control: in std_logic_vector(36 downto 0)
    ); 
end component;

component control_unit is
  port (
    clk: in std_logic;
    res: in std_logic;
    state_in: in std_logic_vector(7 downto 0);
    output_ram: in std_logic_vector(7 downto 0);
    state_out: out std_logic_vector(7 downto 0);
    input_ram: out std_logic_vector(7 downto 0);
    control_out: out std_logic_vector(36 downto 0);
    ram_we: out std_logic;
    ram_out: out std_logic_vector(7 downto 0)
    );
end component;

component ram is
port(
    addr_r: in std_logic_vector(7 downto 0);
    input: in std_logic_vector(7 downto 0);
    we: in std_logic;
    clk: in std_logic;
    chipselect: in std_logic;
    output: out std_logic_vector(7 downto 0)
    );
end component;

component mux8 is
  port ( 
    input1 : in  std_logic_vector(7 downto 0);
    input2 : in  std_logic_vector(7 downto 0);
    selector  : in std_logic;
    output : out std_logic_vector(7 downto 0)
    );
end component;

signal addr_r_sig: std_logic_vector(7 downto 0) := (others => '0');
signal ram_input_sig, ram_output_sig, write_ram, write_ram_in: std_logic_vector(7 downto 0) := (others => '0');
signal we_sig: std_logic := '0';
signal control_out_sig: std_logic_vector(36 downto 0) := (others => '0');

begin

current <= addr_r_sig;
ctrl1: control_unit port map(clk, res, pt, ram_output_sig, ct, write_ram, control_out_sig, we_sig, addr_r_sig);
mux1: mux8 port map(ram_input_sig, write_ram, control_out_sig(24), write_ram_in);
ram1: ram port map(addr_r_sig, write_ram_in, we_sig, clk, control_out_sig(34), ram_output_sig);
data1: datapath port map(ram_output_sig, ram_input_sig, clk, res, control_out_sig);

end behavioral;

