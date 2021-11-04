library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sha3 is
end entity sha3;

architecture behavioral of sha3 is

component datapath is
  port (
    ram_out: in std_logic_vector(7 downto 0);
    ram_in: out std_logic_vector(7 downto 0);
    clk: in std_logic;
    res: in std_logic;
    control: in std_logic_vector(33 downto 0)
    ); 
end component;

component control_unit is
  port (
    clk: in std_logic;
    res: in std_logic;
    control_out: out std_logic_vector(33 downto 0);
    ram_we: out std_logic;
    ram_out: out integer
    );
end component;

component ram is
port(
    addr_r: in integer;
    input: in std_logic_vector(7 downto 0);
    we: in std_logic;
    clk: in std_logic;
    output: out std_logic_vector(7 downto 0)
    );
end component;

signal addr_r_sig: integer;
signal ram_input_sig, ram_output_sig: std_logic_vector(7 downto 0);
signal we_sig, clk_sig, res_sig: std_logic;
signal control_out_sig: std_logic_vector(33 downto 0);

begin

ctrl1: control_unit port map(clk_sig, res_sig, control_out_sig, we_sig, addr_r_sig);
ram1: ram port map(addr_r_sig, ram_input_sig, we_sig, clk_sig, ram_output_sig);
data1: datapath port map(ram_output_sig, ram_input_sig, clk_sig, res_sig, control_out_sig);

Tb_res: process
begin
  wait for 100 ns;
  res_sig <= '1';
end process Tb_res;

Tb_clkgen : process
  begin
     clk_sig <= '1';
     wait for 50 ns;
     clk_sig <= '0';
     wait for 50 ns;
end process Tb_clkgen;

end behavioral;

