library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg1_new is

  port (
    input1 : in std_logic_vector (3 downto 0);
    input2 : in std_logic_vector (24 downto 0);
    res : in std_logic;
    clk : in std_logic;
    mode: in std_logic_vector (1 downto 0);
    slice: in std_logic_vector(1 downto 0);
    count1: in std_logic_vector(1 downto 0);
    output1 : out std_logic_vector (63 downto 0);
    output2 : out std_logic_vector (49 downto 0)
    );
    
end entity reg1_new;

architecture behavioral of reg1_new is

signal input, storedbits: std_logic_vector(63 downto 0);
signal count: integer;
signal feed : std_logic_vector(63 downto 0);

begin

-- mode 00: slice phase - reading from RAM
-- mode 01: slice phase - wrtiting to RAM
-- mode 10: rho phase
-- mode 11: standby

count <= to_integer(unsigned(count1));


reg_feed : process(mode, storedbits, input1, input2, count, slice, input, feed)
    variable feed : std_logic_vector(63 downto 0);
begin
    feed := (others => '0');

    if mode = "10" then
        feed := storedbits(59 downto 0) & input1;
    elsif mode = "00" then
        feed := storedbits(59 downto 12) & input1 & storedbits(11 downto 0);
    elsif mode = "01" then
        feed := storedbits;
        feed(63 - count) := input2(23);
        feed(59 - count) := input2(8);
        feed(55 - count) := input2(19);
        feed(51 - count) := input2(4);
        feed(47 - count) := input2(14);
        feed(43 - count) := input2(20);
        feed(39 - count) := input2(10);
        feed(35 - count) := input2(21);
        feed(31 - count) := input2(6);
        feed(27 - count) := input2(17);
        feed(23 - count) := input2(2);
        feed(19 - count) := input2(12);

        if count = 2 and slice = "00" then
            feed(12) := input2(0);
        elsif count = 2 and slice = "01" then
            feed(14) := input2(0);
        elsif count = 0  and slice = "00" then
            feed(13) := input2(0);
        elsif count = 0 and slice = "01" then
            feed(15) := input2(0);
        else null;
        end if;

    elsif mode = "11" then
        feed := storedbits;
    end if;

    input <= feed;
end process;

reg : process(clk, res, input)
begin
    if rising_edge(clk) then
    storedbits <= input;
    end if;
end process;
 
output_mux : process(mode, storedbits, input1, input2, count, slice, input, feed)
begin
    output1 <= storedbits;
    output2 <= (others => '0');
    if (slice = "00") then
        output2 <= storedbits(63 downto 16) & storedbits(13 downto 12);
    elsif (slice = "01") then
        output2 <= storedbits(63 downto 14);
    else null;
    end if;
end process;

end behavioral;
