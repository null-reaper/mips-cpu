----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: ALU_32 - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ALU_32 is
    Port ( ALU_OP : in STD_LOGIC_VECTOR(2 downto 0) := "010";
               ALUSrc : in STD_LOGIC := '0';
               INPUT_A : in STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
               INPUT_B : in STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
               INPUT_IMM : in STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
               OUTPUT : out STD_LOGIC_VECTOR(31 downto 0);
               ZERO : out STD_LOGIC);
end ALU_32;

architecture Behavioral of ALU_32 is

component CRA_32
        --Port map for the 4 bit adder
                Port ( A : in STD_LOGIC_VECTOR(31 downto 0);
                   B : in STD_LOGIC_VECTOR(31 downto 0);
                   Cin : in STD_LOGIC ;
                   S : out STD_LOGIC_VECTOR(31 downto 0);
                   Cout : out STD_LOGIC);
end component;
    
    signal Cin,Cout : STD_LOGIC;
    signal ADD_OUT , SUB_OUT , ORER,NANDER , ANDER , NORER , INPUT_INT , SLT_OUT: STD_LOGIC_VECTOR(31 downto 0);
    signal SUB_IN , ZERO_VAL: STD_LOGIC_VECTOR(31 downto 0);
    signal ZERO_OUT: STD_LOGIC;
    
    
begin
    Cin <= '0';
    with ALUSrc select
            SUB_IN <= not(INPUT_B) when '0',
                      not(INPUT_IMM) when others;
    with ALUSrc select
            INPUT_INT <= INPUT_B when '0',
                         INPUT_IMM when others;
    A1: CRA_32 port map (A => INPUT_A(31 downto 0), B => INPUT_INT(31 downto 0), Cin => Cin, S => ADD_OUT(31 downto 0), Cout => Cout);
   
    S1: CRA_32 port map (A => INPUT_A(31 downto 0), B => SUB_IN, Cin => Cin, S => SUB_OUT(31 downto 0), Cout => Cout);
    ZERO_VAL <= "00000000000000000000000000000000";
    ORER <= INPUT_A or INPUT_INT;
    NANDER <= not(INPUT_A) and INPUT_INT;
    NORER <= INPUT_A nor INPUT_INT;
    ANDER <= INPUT_A and INPUT_INT;
    SLT_OUT <= "0000000000000000000000000000000" & SUB_OUT(31);
    
    
    
    with ALU_OP select
            OUTPUT <=   ADD_OUT when "010", 
                        SUB_OUT when "011", 
                        ORER when "101", 
                        ANDER when "100",
                        NORER when "110",
                        SLT_OUT when "111", 
                        "00000000000000000000000000000000" when others;
                        
                        
    with NANDER select
            ZERO <= '1' when "00000000000000000000000000000000",
                    '0' when others;
                    
end Behavioral;
