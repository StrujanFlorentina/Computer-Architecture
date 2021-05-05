library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity EX is
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
end EX;

architecture Behavioral of EX is

signal ALUCtrl : std_logic_vector(2 downto 0);
signal B : std_logic_vector(15 downto 0);
signal rez : std_logic_vector(15 downto 0);

begin

ALUControl : process(AluOp, func)
    begin 
    case AluOp is
        when "010" => --tip R
           case func is 
            when "000"=> ALUCtrl<="000"; -- +
            when "001"=> ALUCtrl<="001"; -- -
            when "010"=> ALUCtrl<="101"; -- <<l
            when "011"=> ALUCtrl<="110";-- >>l
            when "100"=> ALUCtrl<="100";-- &
            when "101"=> ALUCtrl<="011";-- |
            when "111"=> ALUCtrl<="111";-- >>v
            when others=>ALUCtrl <= "XXX";
            end case;
        when "001" => -- +
            ALUCtrl<="000";
        when "011" => -- -
            ALUCtrl<="001";
        when "100" => -- |
            ALUCtrl<="011";
        when "101" => -- &
            ALUCtrl<="100";
        when others =>ALUCtrl <= "XXX";
    end case;
end process;

UnitateAritmeticoLogica: process(ALUCtrl)
    begin 
        case ALUCtrl is
            when "000" => rez<=RD1+B;
            when "001" => rez<=RD1-B;
            when "010" => rez<=RD1 and B;
            when "011" => rez<=RD1 or B;
            when "100" => rez<=RD1 xor B;
            when "101" => 
                case RD1 is 
                    when x"0000" => rez<=B;
                    when x"0001" => rez<=B(14 downto 0)&'0';
                    when others => rez<= X"0000";
               end case;
            when "110" => 
                case RD1 is 
                    when x"0000" => rez<=B;
                    when x"0001" => rez<='0'&B(14 downto 0);
                    when others => rez<= X"0000";
               end case;
            when "111" =>  
                case RD1 is 
                    when x"0000" => rez<=B;
                    when x"0001" => rez<=B(14 downto 0)&'0';
                    when x"0002" => rez<=B(13 downto 0)&"00";
                    when x"0003" => rez<=B(12 downto 0)&"000";
                    when x"0004" => rez<=B(11 downto 0)&"0000";
                    when x"0005" => rez<=B(10 downto 0)&"00000";
                    when x"0006" => rez<=B(9 downto 0)&"000000";
                    when x"0007" => rez<=B(8 downto 0)&"0000000";
                    when others => rez<= X"0000";
               end case;              
            when others => rez<= ( others=>'X');
        end case;
        if rez="0000000000000000" then
            zero<='1';
        else
            zero<='0';
        end if;
        aluRes<=rez;
    end process;
    
 MuxAluB: process(ALUSrc)
    begin
        if ALUSrc='0' then
            B<=RD2;
        else
            B<=Ext_Imm;
        end if;
    end process;
      
BranchAdd: process(Ext_Imm, next_instruction)
    begin 
        BranchAddress<=Ext_Imm+next_instruction;
    end process;
    
end Behavioral;
