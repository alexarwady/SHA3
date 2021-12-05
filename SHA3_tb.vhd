library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity sha3_tb is
end entity sha3_tb;

architecture behavioral of sha3_tb is

component sha3 is
  port (
    clk: in std_logic;
    res: in std_logic;
    pt: in std_logic_vector(1599 downto 0);
    ct: out std_logic_vector(1599 downto 0)
  );
end component;

component interleave_state is
  port (
    input: in std_logic_vector (1599 downto 0);
    output: out std_logic_vector (1599 downto 0)
    );
end component;

signal clk_sig: std_logic;
signal res_sig: std_logic := '0';
signal pt, ct, pt_int, ct_int, ct_int_true: std_logic_vector(1599 downto 0);

begin

uut: sha3 port map(clk_sig, res_sig, pt_int, ct_int);
int1: interleave_state port map(pt, pt_int);
int2: interleave_state port map(ct, ct_int_true);

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

testbench : process

file test_vectors_file : text;
variable vec_line : line;
variable vec_id : integer;
variable vec_pt : std_logic_vector(1599 downto 0);
variable vec_ct : std_logic_vector(1599 downto 0);
variable id : integer := 1;

begin

    file_open(test_vectors_file, "test_vectors.txt", read_mode);

    while not endfile(test_vectors_file) loop
        report "id: " & integer'image(id); id := id + 1;

        readline(test_vectors_file, vec_line);
        read(vec_line, vec_id);

        readline(test_vectors_file, vec_line);
        hread(vec_line, vec_pt);
        pt <= vec_pt;
        readline(test_vectors_file, vec_line);
        hread(vec_line, vec_ct);
        ct <= vec_ct;

        wait for 2296800 ns;

        if (ct_int_true /= ct_int) then
          assert false report "invalid ciphertext" severity failure;
        end if;
    end loop;

    file_close(test_vectors_file);

end process;

end behavioral;
