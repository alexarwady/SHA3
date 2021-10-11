library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rc_bit_generator is

  port (
    round : in unsigned(4 downto 0);
    slice : in unsigned(5 downto 0);
    rc_bit: out std_logic
    );
    
end entity rc_bit_generator;

architecture behavioral of rc_bit_generator is

signal temp: std_logic_vector(63 downto 0);

begin

rc_bit_process : process (round)

begin
	case round is
        when "00000" => temp <= X"0000000000000001" ;
	    when "00001" => temp <= X"0000000000008082" ;
	    when "00010" => temp <= X"800000000000808A" ;
	    when "00011" => temp <= X"8000000080008000" ;
	    when "00100" => temp <= X"000000000000808B" ;
	    when "00101" => temp <= X"0000000080000001" ;
	    when "00110" => temp <= X"8000000080008081" ;
	    when "00111" => temp <= X"8000000000008009" ;
	    when "01000" => temp <= X"000000000000008A" ;
	    when "01001" => temp <= X"0000000000000088" ;
	    when "01010" => temp <= X"0000000080008009" ;
	    when "01011" => temp <= X"000000008000000A" ;
	    when "01100" => temp <= X"000000008000808B" ;
	    when "01101" => temp <= X"800000000000008B" ;
	    when "01110" => temp <= X"8000000000008089" ;
	    when "01111" => temp <= X"8000000000008003" ;
	    when "10000" => temp <= X"8000000000008002" ;
	    when "10001" => temp <= X"8000000000000080" ;
	    when "10010" => temp <= X"000000000000800A" ;
	    when "10011" => temp <= X"800000008000000A" ;
	    when "10100" => temp <= X"8000000080008081" ;
	    when "10101" => temp <= X"8000000000008080" ;
	    when "10110" => temp <= X"0000000080000001" ;
	    when "10111" => temp <= X"8000000080008008" ;	    	    
	    when others => temp <=(others => '0');
        end case;
end process rc_bit_process;

rc_bit <= temp(to_integer(slice));
end behavioral;