library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rc_bit_generator is

  port (
    round : in integer;
    slice : in integer;
    rc_bit: out std_logic
    );
    
end entity rc_bit_generator;

architecture behavioral of rc_bit_generator is

signal temp: std_logic_vector(63 downto 0);

begin

rc_bit_process : process (round, slice)

begin
	case round is
        when 0 => temp <= X"0000000000000001" ;
	    when 1 => temp <= X"0000000000008082" ;
	    when 2 => temp <= X"800000000000808A" ;
	    when 3 => temp <= X"8000000080008000" ;
	    when 4 => temp <= X"000000000000808B" ;
	    when 5 => temp <= X"0000000080000001" ;
	    when 6 => temp <= X"8000000080008081" ;
	    when 7 => temp <= X"8000000000008009" ;
	    when 8 => temp <= X"000000000000008A" ;
	    when 9 => temp <= X"0000000000000088" ;
	    when 10 => temp <= X"0000000080008009" ;
	    when 11 => temp <= X"000000008000000A" ;
	    when 12 => temp <= X"000000008000808B" ;
	    when 13 => temp <= X"800000000000008B" ;
	    when 14 => temp <= X"8000000000008089" ;
	    when 15 => temp <= X"8000000000008003" ;
	    when 16 => temp <= X"8000000000008002" ;
	    when 17 => temp <= X"8000000000000080" ;
	    when 18 => temp <= X"000000000000800A" ;
	    when 19 => temp <= X"800000008000000A" ;
	    when 20 => temp <= X"8000000080008081" ;
	    when 21 => temp <= X"8000000000008080" ;
	    when 22 => temp <= X"0000000080000001" ;
	    when 23 => temp <= X"8000000080008008" ;	    	    
	    when others => temp <=(others => '0');
        end case;

		if(slice>=0 and slice<=63) then
			rc_bit <= temp(slice);
		end if;
end process rc_bit_process;
end behavioral;