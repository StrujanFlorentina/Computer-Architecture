library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity InstructionDecode is
    Port ( clk : in STD_LOGIC;
           en: in std_logic;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC); 
end InstructionDecode;

architecture Behavioral of InstructionDecode is
component RegFile is
    Port(clk: in std_logic;
        ra1: in std_logic_vector(2 downto 0);
        ra2: in std_logic_vector(2 downto 0);
        wa: in std_logic_vector(2 downto 0);
        wd: in std_logic_vector(15 downto 0);
        wen: in std_logic;
        RegWrite: in std_logic;
        rd1: out std_logic_vector(15 downto 0);
        rd2: out std_logic_vector(15 downto 0)
    );
end component;

signal WrAdd: std_logic_vector(2 downto 0);
signal sign: std_logic:=instr(6);
begin

MUXinstr: process(RegDst)
begin
    if RegDst='1' then
        WrAdd<=instr(6 downto 4);
    else
        WrAdd<=instr(9 downto 7);
    end if;
end process;
   
UnitateExtensie: process(ExtOp)
begin
    if ExtOp='0' then 
        Ext_Imm<="000000000"&instr(6 downto 0);
    elsif sign='0' then
        Ext_Imm<="000000000"&instr(6 downto 0);
    else
        Ext_Imm<="111111111"&instr(6 downto 0);
    end if;
end process;
RegisterFile: RegFile port map(clk=>clk,ra1=>instr(12 downto 10),ra2=>instr(9 downto 7),wa=>WrAdd,wd=>WD,wen=>en, RegWrite=>RegWrite,rd1=>RD1,rd2=>RD2);

func<=instr(2 downto 0);
sa<=instr(3);

end Behavioral;