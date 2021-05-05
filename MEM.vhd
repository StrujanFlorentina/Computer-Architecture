library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MEM is
    Port ( MemWrite : in std_logic;
           AluResIn : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           clk : in std_logic;
           en : in std_logic;
           MemData : out std_logic_vector(15 downto 0);
           AluResOut : out std_logic_vector(15 downto 0));
end MEM;

architecture Behavioral of MEM is

type memorie is array(0 to 31) of std_logic_vector(15 downto 0);
signal mem : memorie :=( X"0000", X"0001", X"0002", X"0003", X"0004", X"0005",
                         X"0006", X"0007", X"0008", X"0009", X"000A", X"000B", others=>x"0000");

begin

process(clk) 
begin
    if rising_edge(clk) then
        if en='1' and MemWrite='1' then
            mem(conv_integer(AluResIn(4 downto 0)))<=RD2; 
        end if;
    end if;
end process;

MemData<=mem(conv_integer(AluResIn(4 downto 0)));
AluResOut<=AluResIn;

end Behavioral;
