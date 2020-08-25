----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: ALU_32_tb - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ALU_32_tb is
end;

architecture bench of ALU_32_tb is

  component ALU_32
      Port ( ALU_OP : in STD_LOGIC_VECTOR(2 downto 0);
                 ALUSrc : in STD_LOGIC;
                 INPUT_A : in STD_LOGIC_VECTOR(31 downto 0);
                 INPUT_B : in STD_LOGIC_VECTOR(31 downto 0);
                 INPUT_IMM : in STD_LOGIC_VECTOR(31 downto 0);
                 OUTPUT : out STD_LOGIC_VECTOR(31 downto 0);
                 ZERO : out STD_LOGIC);
  end component;

  signal ALU_OP: STD_LOGIC_VECTOR(2 downto 0);
  signal ALUSrc: STD_LOGIC;
  signal INPUT_A: STD_LOGIC_VECTOR(31 downto 0);
  signal INPUT_B: STD_LOGIC_VECTOR(31 downto 0);
  signal INPUT_IMM: STD_LOGIC_VECTOR(31 downto 0);
  signal OUTPUT: STD_LOGIC_VECTOR(31 downto 0);
  signal ZERO: STD_LOGIC;

begin

  uut: ALU_32 port map ( ALU_OP     => ALU_OP,
                         ALUSrc     => ALUSrc,
                         INPUT_A    => INPUT_A,
                         INPUT_B    => INPUT_B,
                         INPUT_IMM  => INPUT_IMM,
                         OUTPUT     => OUTPUT,
                         ZERO       => ZERO );

  stimulus: process
  begin
  
        INPUT_A <= "10000110001100011000110000010001";
        INPUT_B <= "00000000000000000000000000000000";
        INPUT_IMM <= "01111001110011100111001111101110";
        ALU_OP <= "010";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;
        ALU_OP <= "011";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;
        ALU_OP <= "101";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;
        ALU_OP <= "100";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;
        ALU_OP <= "110";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;
        ALU_OP <= "111";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;
        ALU_OP <= "000";
        ALUSrc <= '0';
        wait for 50ns;
        ALUSrc <= '1';
        wait for 50ns;

    wait;
  end process;


end;