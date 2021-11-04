library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rho_constant_generator is

  port (
    round : in integer; --between 0 and 11
    rho_constant0: out std_logic_vector (5 downto 0);
    rho_constant1: out std_logic_vector (5 downto 0);
    mux_64_0: out std_logic_vector(3 downto 0);
    mux_64_1: out std_logic_vector(3 downto 0)
    );
    
end entity rho_constant_generator;

architecture behavioral of rho_constant_generator is

begin

rho_constant_process : process (round)

begin
	case round is
        when 0 => 
            rho_constant0 <= std_logic_vector(to_unsigned(21, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(56, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(5, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(14, 4));
        when 1 =>
            rho_constant0 <= std_logic_vector(to_unsigned(28, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(55, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(7, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(13, 4));
        when 2 =>
            rho_constant0 <= std_logic_vector(to_unsigned(25, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(8, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(6, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(2, 4));
        when 3 =>
            rho_constant0 <= std_logic_vector(to_unsigned(14, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(27, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(3, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(6, 4));
        when 4 =>
            rho_constant0 <= std_logic_vector(to_unsigned(20, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(39, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(5, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(9, 4));
        when 5 =>
            rho_constant0 <= std_logic_vector(to_unsigned(41, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(18, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(10, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(4, 4));
        when 6 =>
            rho_constant0 <= std_logic_vector(to_unsigned(36, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(3, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(9, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(0, 4));
        when 7 =>
            rho_constant0 <= std_logic_vector(to_unsigned(45, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(2, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(11, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(0, 4));
        when 8 =>
            rho_constant0 <= std_logic_vector(to_unsigned(1, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(44, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(0, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(11, 4));
        when 9 =>
            rho_constant0 <= std_logic_vector(to_unsigned(10, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(15, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(2, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(3, 4));
        when 10 =>
            rho_constant0 <= std_logic_vector(to_unsigned(61, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(62, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(15, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(15, 4));
        when 11 => 
            rho_constant0 <= std_logic_vector(to_unsigned(6, 6)); 
            rho_constant1 <= std_logic_vector(to_unsigned(43, 6));
            mux_64_0 <= std_logic_vector(to_unsigned(1, 4)); 
            mux_64_1 <= std_logic_vector(to_unsigned(10, 4));
        when others =>
            rho_constant0 <= (others => '0');
            rho_constant1 <= (others => '0');
            mux_64_0 <= (others => '0');
            mux_64_1 <= (others => '0');
    end case;
end process;

end behavioral;


