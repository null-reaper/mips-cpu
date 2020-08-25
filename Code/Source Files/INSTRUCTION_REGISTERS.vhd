----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: INSTRUCTION_REGISTERS - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity INSTRUCTION_REGISTERS is
    Port ( INSTRUCTION : in STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
           IRWrite : in STD_LOGIC := '0';
           REG1 : out STD_LOGIC_VECTOR(4 downto 0);
           REG2 : out STD_LOGIC_VECTOR(4 downto 0);
           REG3 : out STD_LOGIC_VECTOR(4 downto 0);
           IMM : out STD_LOGIC_VECTOR(31 downto 0);
           JMP_ADDRESS : out STD_LOGIC_VECTOR(25 downto 0);
           INSTRUCTION_TYP : out STD_LOGIC_VECTOR(3 downto 0));
end INSTRUCTION_REGISTERS;

architecture Behavioral of INSTRUCTION_REGISTERS is

signal OP_CODE_INT : STD_LOGIC_VECTOR(5 downto 0);
signal FUNC_CODE_INT : STD_LOGIC_VECTOR(5 downto 0);

signal IMM_INT : STD_LOGIC_VECTOR(31 downto 0);
begin
-- This updates the Instruction when a new instruction is given
            writeProcess: process(IRWrite) is
                begin
                    if (IRWrite = '1') then
                    REG1 <= INSTRUCTION(25 downto 21);
                    REG2 <= INSTRUCTION(20 downto 16);
                    REG3 <= INSTRUCTION(15 downto 11);
                    IMM <=  std_logic_vector(resize(signed(INSTRUCTION(15 downto 0)), 32));
                    JMP_ADDRESS <= INSTRUCTION(25 downto 0);
                    OP_CODE_INT <= INSTRUCTION(31 downto 26);
                    FUNC_CODE_INT <= INSTRUCTION(5 downto 0);
                    end if;
            end process;
            
            process (OP_CODE_INT, FUNC_CODE_INT) is
            begin
               case OP_CODE_INT is
                        when "000010" => -- J
                                INSTRUCTION_TYP <= "0000";
                        when "000100" => -- BEQ
                                INSTRUCTION_TYP <= "0001";
                        when "001000" => -- ADDI
                                INSTRUCTION_TYP <= "1010";
                        when "001100" => -- ANDI
                                INSTRUCTION_TYP <= "1100";
                        when "001101" => -- ORI
                                INSTRUCTION_TYP <= "1101";
                        when "101011" => -- SW
                                INSTRUCTION_TYP <= "1000"; 
                        when "100011" => -- LW
                                INSTRUCTION_TYP <= "1001"; 
                        when others =>
                                INSTRUCTION_TYP <= "1111";          
                        end case;
                        
                      case FUNC_CODE_INT is
                        when "100000" => -- ADD
                                INSTRUCTION_TYP <= "0010";
                        when "100010" => -- SUB
                                INSTRUCTION_TYP <= "0011";
                        when "100100" => -- AND
                                INSTRUCTION_TYP <= "0100";
                        when "100101" => -- OR
                                INSTRUCTION_TYP <= "0101";
                        when "100111" => -- NOR
                                INSTRUCTION_TYP <= "0110";
                        when "101010" => -- SLT
                                INSTRUCTION_TYP <= "0111";
                        when others =>
                                null;                
                      end case;
            end process;
            
end Behavioral;