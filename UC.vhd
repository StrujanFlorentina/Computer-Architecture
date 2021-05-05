library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity UnitateControl is
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
end UnitateControl;

architecture Behavioral of UnitateControl is
begin
process(instr)
    begin
    RegDst<='0'; ExtOp<='0'; ALUSrc<='0'; Branch<='0'; Jump<='0';
    ALUOp<="000"; MemWrite<='0'; MemtoReg<='0'; RegWrite<='0';
    case instr is
        when "000" => -- de tip R
            RegDst<='1'; RegWrite<='1'; ALUOp<="010";
        when "001" => --addi
            ExtOp<='1'; ALUSrc<='1'; RegWrite<='1'; ALUOp<="001";
        when "010" => --lw
            ExtOp<='1'; ALUSrc<='1'; MemtoReg<='1'; RegWrite<='1'; ALUOp<="001";
        when "011" => --sw 
            ExtOp<='1'; ALUSrc<='1'; MemWrite<='1'; ALUOp<="001";
        when "100" => --beq
            ExtOp<='1'; Branch<='1'; ALUOp<="001";
        when "101" => --ori
            ALUSrc<='1'; RegWrite<='1'; ALUOp<="100";
        when "110" => --andi
            ALUSrc<='1'; RegWrite<='1'; ALUOp<="101";
        when "111" => --j
            Jump<='1';
    end case;
end process;
end Behavioral;
