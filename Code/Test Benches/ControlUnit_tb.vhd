----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: ControlUnit_tb - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ControlUnit_tb is
end;

architecture bench of ControlUnit_tb is

  component ControlUnit
      Port (  clk : in STD_LOGIC; -- Clock Input
              instruction : in STD_LOGIC_VECTOR(3 downto 0); -- Decoded Instruction from IR
              stage : out STD_LOGIC_VECTOR(3 downto 0); -- Outputs Current Stage (Only For Testing)
              IorD : out STD_LOGIC; -- Control Signal for Instruction Vs Data
              MemRead : out STD_LOGIC; -- Control Signal to Read from Memory
              MemWrite : out STD_LOGIC; -- Control Signal to Write to Memory
              IRWrite : out STD_LOGIC; -- Control Signal for Updating Instruction in IR
              RegDst : out STD_LOGIC; -- MUX Select Signal to Choose Destination Register Index
              MemToReg : out STD_LOGIC; -- MUX Select Signal to Choose ALU Output Vs Data from Memory for Register Write
              RegWrite : out STD_LOGIC; -- Control Signal for Writing to Register
              ALUOp : out STD_LOGIC_VECTOR(2 downto 0); -- Cntrol Signal to Select ALU Operation
              ALUSrc : out STD_LOGIC; -- MUX Select Signal to Choose Register Contents Vs Imm Value for ALU Input
              PCSrc : out STD_LOGIC_VECTOR(1 downto 0); -- Control Signal for PC Update Operation
              PCWrite : out STD_LOGIC); -- Control Signal to Update PC to NPC
  end component;

  signal clk: STD_LOGIC;  -- Clock Input
  signal instruction: STD_LOGIC_VECTOR(3 downto 0); -- Decoded Instruction from IR
  signal stage: STD_LOGIC_VECTOR(3 downto 0); -- Outputs Current Stage (Only For Testing)
  signal IorD: STD_LOGIC; -- Control Signal for Instruction Vs Data
  signal MemRead: STD_LOGIC; -- Control Signal to Read from Memory
  signal MemWrite: STD_LOGIC; -- Control Signal to Write to Memory
  signal IRWrite: STD_LOGIC; -- Control Signal for Updating Instruction in IR
  signal RegDst: STD_LOGIC; -- MUX Select Signal to Choose Destination Register Index
  signal MemToReg: STD_LOGIC; -- Cntrol Signal to Select ALU Operation
  signal RegWrite: STD_LOGIC; -- Control Signal for Writing to Register
  signal ALUOp: STD_LOGIC_VECTOR(2 downto 0); -- Cntrol Signal to Select ALU Operation
  signal ALUSrc: STD_LOGIC; -- MUX Select Signal to Choose Register Contents Vs Imm Value for ALU Input
  signal PCSrc: STD_LOGIC_VECTOR(1 downto 0); -- Control Signal for PC Update Operation
  signal PCWrite: STD_LOGIC; -- Control Signal to Update PC to NPC

  constant clock_period: time := 10 ns; -- Clock Cycle Time
  signal stop_the_clock: boolean; -- Clock On/Off Flag

begin

  -- Mapping Ports to Signals
  uut: ControlUnit port map ( clk         => clk,
                              instruction => instruction,
                              stage       => stage,
                              IorD        => IorD,
                              MemRead     => MemRead,
                              MemWrite    => MemWrite,
                              IRWrite     => IRWrite,
                              RegDst      => RegDst,
                              MemToReg    => MemToReg,
                              RegWrite    => RegWrite,
                              ALUOp       => ALUOp,
                              ALUSrc      => ALUSrc,
                              PCSrc       => PCSrc,
                              PCWrite     => PCWrite );

  -- Start of Test Bench
  stimulus: process
  begin

    stop_the_clock <= false; -- start clock
        
    instruction <= "1111"; -- instruction #
    wait for 50 ns; -- wait
    
    stop_the_clock <= true; -- end clock
    
    wait; -- Wait Indefinitely
  end process;
  -- End of Test Bench

  -- Generate Clock
  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2; -- Switch Value of CLK every half period
      wait for clock_period;
    end loop;
    wait;
  end process;

end;