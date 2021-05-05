library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
signal en: std_logic;
signal wd : std_logic_vector (15 downto 0);
signal rst : std_logic;
signal j : std_logic_vector (15 downto 0) :=X"0000";
--signal br : std_logic_vector (15 downto 0):=X"2082";
signal instr: std_logic_vector (15 downto 0);
signal nexti: std_logic_vector (15 downto 0);
signal instrfin: std_logic_vector (15 downto 0):=X"0000";
signal writeData: std_logic_vector (15 downto 0);
signal readD1: std_logic_vector (15 downto 0);
signal readD2: std_logic_vector (15 downto 0);
signal extImm: std_logic_vector (15 downto 0);
signal funcc: std_logic_vector (2 downto 0);
signal saa: std_logic;
--signal funcExt: std_logic_vector (15 downto 0);
--signal saExt: std_logic_vector (15 downto 0);
signal reggWrite: std_logic;
signal reggDst: std_logic;
signal exttOp: std_logic;
signal jumpp: std_logic;
signal AluuSrc: std_logic;
signal AluuOp: std_logic_vector(2 downto 0);
signal brAddr: std_logic_vector (15 downto 0);
signal AluuRes: std_logic_vector (15 downto 0);
signal MemmWr: std_logic;
signal MemmData: std_logic_vector (15 downto 0);
signal AluuResOut: std_logic_vector (15 downto 0);
signal MemmtoReg: std_logic;
signal zzero: std_logic;
signal branchh: std_logic;
signal pcsrcc: std_logic;



component mpg is
    Port ( input : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD is
    Port ( clk : in STD_LOGIC;
           digits: in STD_LOGIC_VECTOR(15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component InstructionFetch is
    Port ( clk : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           jump_adress : in STD_LOGIC_VECTOR (15 downto 0);
           branch_adress : in STD_LOGIC_VECTOR (15 downto 0);
           mpg_enable : in STD_LOGIC;
           mpg_resetPC : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           next_instruction : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component InstructionDecode is
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
end component;

component UnitateControl is
    Port ( instr : in std_logic_vector(2 downto 0);
           RegDst : out std_logic;
           ExtOp : out std_logic;
           ALUSrc : out std_logic;
           Branch : out std_logic;
           Jump : out std_logic;
           ALUOp : out std_logic_vector(2 downto 0);
           MemWrite: out std_logic;
           MemtoReg : out std_logic;
           RegWrite: out std_logic);
end component;

component EX is
    Port ( RD1 : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           ALUSrc : in std_logic;
           Ext_Imm : in std_logic_vector(15 downto 0);
           sa : in std_logic;
           func : in std_logic_vector(2 downto 0);
           ALUOp : in std_logic_vector(2 downto 0);
           next_instruction : in std_logic_vector(15 downto 0);
           branchAddress : out std_logic_vector(15 downto 0);
           ALURes : out std_logic_vector(15 downto 0);
           zero : out std_logic);
end component;

component MEM is
    Port ( MemWrite : in std_logic;
           AluResIn : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           clk : in std_logic;
           en : in std_logic;
           MemData : out std_logic_vector(15 downto 0);
           AluResOut : out std_logic_vector(15 downto 0));
end component;

begin

enableIF: mpg port map(input=>btn(0),clock=>clk,en=>en);
resetIF: mpg port map(input=>btn(1),clock=>clk,en=>rst);
InstrFetch: InstructionFetch port map(clk=>clk, jump=>jumpp,pcsrc=>pcsrcc,jump_adress=>j,branch_adress=>brAddr,
                                      mpg_enable=>en,mpg_resetPC=>rst,instruction=>instr,next_instruction=>nexti);
MainControl: UnitateControl port map(instr=>instr(15 downto 13), RegDst=>ReggDst, ExtOp=>ExttOp, AluSrc=>AluuSrc, Branch=>branchh, 
                                     Jump=>jumpp, ALUOp=>AluuOp, MemWrite=>MemmWr, MemtoReg=>MemmtoReg, RegWrite=>ReggWrite);
led(6)<=ExttOp;
led(7)<=ReggDst;
led(0)<=ReggWrite;
led(5)<=AluuSrc;
led(10 downto 8)<=AluuOp;
led(2)<=MemmWr;
led(1)<=MemmtoReg;
led(3)<=Jumpp;
led(4)<=Branchh;

InstrDecode: InstructionDecode port map(clk=>clk, en=>en, instr =>instr, WD=>writeData, RegWrite=>ReggWrite, RegDst=>ReggDst,
                                        ExtOp=>ExttOp, RD1=>readD1, RD2=>readD2, Ext_Imm=>extImm, func=>funcc, sa=>saa);
UnitateExecutie: Ex port map( RD1 =>readD1, RD2=>readD2, ALUSrc=>AluuSrc, Ext_Imm=>extImm, sa=>saa, func=>funcc, ALUOp=>AluuOp,
                              next_instruction=>nexti, branchAddress=>brAddr, ALURes=>AluuRes, zero=>zzero);
UnitateMemorie: MEM port map( MemWrite=>MemmWr, AluResIn=>AluuRes, RD2=>readD2, clk=>clk, en=>en, MemData=>MemmData, AluResOut=>AluuResOut); 
WriteBack: process(MemmtoReg)
begin 
    if MemmtoReg='1' then
        writeData<=MemmData;
    else
        writeData<=AluuResOut;
    end if;
end process;
     
pcsrcc<=zzero and branchh;
j<=instr(12 downto 0)&nexti(15 downto 13);                                                      

process(sw(7 downto 5))
begin
    case sw(7 downto 5) is
        when "000" => instrfin<=instr;
        when "001" => instrfin<=nexti;
        when "010" => instrfin<=readD1;
        when "011" => instrfin<=readD2;
        when "100" => instrfin<=extImm;
        when "101" => instrfin<=AluuRes;
        when "110" => instrfin<=MemmData;
        when "111" => instrfin<=writeData;
    end case;
end process;      
sevenSegmentDispaly: SSD port map(clk=>clk, digits=>instrfin, an=>an, cat=>cat);
end architecture;