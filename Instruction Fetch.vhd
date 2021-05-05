library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstructionFetch is
    Port ( clk : in STD_LOGIC;
           jump : in STD_LOGIC;
           pcsrc : in STD_LOGIC;
           jump_adress : in STD_LOGIC_VECTOR (15 downto 0);
           branch_adress : in STD_LOGIC_VECTOR (15 downto 0);
           mpg_enable : in STD_LOGIC;
           mpg_resetPC : in STD_LOGIC;
           instruction : out STD_LOGIC_VECTOR (15 downto 0);
           next_instruction : out STD_LOGIC_VECTOR (15 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is

type memorie is array(0 to 13) of std_logic_vector(15 downto 0);
signal ROM : memorie  :=  (B"001_000_001_0000010",--addi $1,$0,2
--X"2082"  initializeaza reg1 cu 2
B"001_000_010_1000000",--addi $2,$0,64
--X"2140"  initializeaza reg2 cu 64
B"101_000_011_0000110",--ori $3,$0,6
--X"A186"  initializeaza reg3 cu 6
B"011_000_011_0000011",--sw $3, 3($0)
--X"6183"  stocheaza in memorie la adresa 3 val 6
B"010_000_100_0000011",--lw $4, 3($0)
--X"4203"  il incarca pe 6 din memorie in reg4
B"000_011_100_011_0_001",--sub $3,$3,$4
--X"0E31"  scad din reg3 pe reg4 => reg3 va fi 0
B"001_011_011_0000001",--addi $3,$3,1
--X"2D81"  reg3 +1
B"000_000_001_001_1_010",--sll $1,$1,1
--X"009A"  reg1*2 ( reg1 deplasat la stanga cu 1 
B"100_010_001_0000001",--beq $2,$1,1
--X"8881"  daca reg2 egal reg1(s-a ajuns la val 64) se sare a doua instr urmatoare
B"111_0000000000110",--j 6
--X"E006"  se sare la a 9 a instructiune (incepem cu 0)
B"000_100_011_101_1_001",--sub $5, $4, $3
--X"11D9"  diferenta dintre reg4 si reg3(puterea 6 si cea actuala)
B"100_101_000_0000001",--beq $5,$0,1
--X"9401"  daca diferenta e 0 sare la ultima instr
B"111_0000000000011",--j 3
--X"E003"  sare la a 3 a instructiune (incepem cu 0)
B"011_000_001_00011"--sw $1, 6($0)
--X"6083"  stocheaza a 6 aputere a lui doi la adresa 6 in memorie
);
signal counter : std_logic_vector(15 downto 0) :=x"0000";
signal output_mux1 : std_logic_vector(15 downto 0):=x"0000";
signal output_mux2 :std_logic_vector(15 downto 0) :=x"0000";
signal nextI: std_logic_vector(15 downto 0);
begin

next_instruction<=counter+1;
MUX_Brach: process(pcsrc) 
begin
    if pcsrc='0' then
        output_mux1 <=counter+x"0001";
    else
        output_mux1<=branch_adress;
    end if;
end process;

MUX_Jump: process(jump)
begin
    if jump='1' then
        output_mux2<=jump_adress;
    else
        output_mux2<=output_mux1;
    end if;
end process;

ProgramCounter: process(clk)
begin
   if rising_edge(clk) then 
     if mpg_resetPC='1' then 
        counter<=X"0000";
     elsif mpg_enable='1' then
        counter<=output_mux2;
     end if;
   end if;   
end process;

InstructionMemory: process (output_mux2)
begin
    instruction<= ROM(conv_integer(counter(4 downto 0)));
end process;

end Behavioral;
