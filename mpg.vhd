library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity mpg is
    Port ( input : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
end mpg;

architecture Behavioral of mpg is
signal count: std_logic_vector(15 downto 0):="0000000000000000";
signal q1:std_logic;
signal q2: std_logic;
signal q3: std_logic;

begin

en <= q2 and (not q3);
process(clock)
begin
    if rising_edge(clock) then
        count <= count + 1;
    end if;
end process;

process (clock)
begin
 if rising_edge(clock) then
 if count(15 downto 0) = "1111111111111111" then
 q1 <= input;
 end if;
 end if;
end process;

process (clock)
begin
 if rising_edge(clock) then
 q2 <= q1;
 q3 <= q2;
 end if;
end process;
end architecture;
