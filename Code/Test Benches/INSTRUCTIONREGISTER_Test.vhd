----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: INSTRUCTION_REGISTERS_tb - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity INSTRUCTION_REGISTERS_tb is
end;

architecture bench of INSTRUCTION_REGISTERS_tb is

  component INSTRUCTION_REGISTERS
      Port ( INSTRUCTION : in STD_LOGIC_VECTOR(31 downto 0);
           IRWrite : in STD_LOGIC := '0';
           REG1 : out STD_LOGIC_VECTOR(4 downto 0);
           REG2 : out STD_LOGIC_VECTOR(4 downto 0);
           REG3 : out STD_LOGIC_VECTOR(4 downto 0);
           IMM : out STD_LOGIC_VECTOR(31 downto 0);
           JMP_ADDRESS : out STD_LOGIC_VECTOR(25 downto 0);
           INSTRUCTION_TYP : out STD_LOGIC_VECTOR(3 downto 0));
  end component;

  signal INSTRUCTION: STD_LOGIC_VECTOR(31 downto 0);
  signal IRWrite: STD_LOGIC;
  signal REG1: STD_LOGIC_VECTOR(4 downto 0);
  signal REG2: STD_LOGIC_VECTOR(4 downto 0);
  signal REG3: STD_LOGIC_VECTOR(4 downto 0);
  signal IMM: STD_LOGIC_VECTOR(31 downto 0);
  signal JMP_ADDRESS: STD_LOGIC_VECTOR(25 downto 0);
  signal INSTRUCTION_TYP : STD_LOGIC_VECTOR(3 downto 0);

begin

  uut: INSTRUCTION_REGISTERS port map ( INSTRUCTION => INSTRUCTION,
                                        IRWrite     => IRWrite,
                                        INSTRUCTION_TYP => INSTRUCTION_TYP,
                                        REG1        => REG1,
                                        REG2        => REG2,
                                        REG3        => REG3,
                                        IMM         => IMM,
                                        JMP_ADDRESS => JMP_ADDRESS);

  stimulus: process
  begin
           IRWrite <= '1';
           INSTRUCTION <= "10000110001100011000110000100001";
           wait for 50 ns; 
           IRWrite <= '0';
           INSTRUCTION <= "11111111111111111111111111111111";
           wait for 50 ns; 
           IRWrite <= '1';
           wait for 50 ns;

    wait;
  end process;


end;