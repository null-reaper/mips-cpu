----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: REGISTERS_tb - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity REGISTERS_tb is
end;

architecture bench of REGISTERS_tb is

  component REGISTERS
      Port ( READREG1 : in STD_LOGIC_VECTOR(4 downto 0);
             READREG2 : in STD_LOGIC_VECTOR(4 downto 0);
             READREG3 : in STD_LOGIC_VECTOR(4 downto 0);
             WRITEDATA_ALU : in STD_LOGIC_VECTOR(31 downto 0);  
             WRITEDATA_MEM : in STD_LOGIC_VECTOR(31 downto 0);  
             REGWRITE : in STD_LOGIC;
             RegDst : in STD_LOGIC;
             MemToReg : in STD_LOGIC;
             READDATA1 : out STD_LOGIC_VECTOR(31 downto 0);
             READDATA2 : out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  signal READREG1: STD_LOGIC_VECTOR(4 downto 0);
  signal READREG2: STD_LOGIC_VECTOR(4 downto 0);
  signal READREG3: STD_LOGIC_VECTOR(4 downto 0);
  signal WRITEDATA_ALU: STD_LOGIC_VECTOR(31 downto 0);
  signal WRITEDATA_MEM: STD_LOGIC_VECTOR(31 downto 0);
  signal REGWRITE: STD_LOGIC;
  signal RegDst : STD_LOGIC;
  signal MemToReg: STD_LOGIC;
  signal READDATA1: STD_LOGIC_VECTOR(31 downto 0);
  signal READDATA2: STD_LOGIC_VECTOR(31 downto 0);

begin

  uut: REGISTERS port map ( READREG1  => READREG1,
                            READREG2  => READREG2,
                            READREG3  => READREG3,
                            WRITEDATA_ALU => WRITEDATA_ALU,
                            WRITEDATA_MEM => WRITEDATA_MEM,
                            REGWRITE  => REGWRITE,
                            RegDst => RegDst,
                            MemToReg   => MemToReg,
                            READDATA1 => READDATA1,
                            READDATA2 => READDATA2);

  stimulus: process
  begin
  
        READREG1 <= "10001";
        READREG2 <= "10000";
        READREG3 <= "00000";
        WRITEDATA_ALU <= "01111001110011100111001111101110";
        WRITEDATA_MEM <= "11111111111111111111111111111111";
        RegDst <= '0';
        REGWRITE <= '0';
        MemToReg <= '0';
        wait for 50ns;
        RegDst <= '0';        
        REGWRITE <= '0';
        MemToReg <= '1';
        READREG3 <= "00001";
        wait for 50ns;
        RegDst <= '1';
        REGWRITE <= '0';
        MemToReg <= '0';
        READREG3 <= "00010";
        wait for 50ns;
        RegDst <= '1';
        REGWRITE <= '0';
        MemToReg <= '1';
        READREG3 <= "00011";
        wait for 50ns;
        RegDst <= '0';
        REGWRITE <= '1';
        MemToReg <= '0';
        wait for 50ns;
        RegDst <= '0';        
        REGWRITE <= '1';
        MemToReg <= '1';
        READREG3 <= "00001";
        wait for 50ns;
        RegDst <= '1';
        REGWRITE <= '1';
        MemToReg <= '0';
        READREG3 <= "00010";
        wait for 50ns;
        RegDst <= '1';
        REGWRITE <= '1';
        MemToReg <= '1';
        READREG3 <= "00011";
        wait for 50ns;
  end process;
end;
