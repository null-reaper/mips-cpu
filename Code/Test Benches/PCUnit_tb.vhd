----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: PCUnit_tb - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PCUnit_tb is
end;

architecture bench of PCUnit_tb is

  component PCUnit
    Port ( OPC : in STD_LOGIC_VECTOR (31 downto 0); -- Current PC Inputted In
           JAddress : in STD_LOGIC_VECTOR (25 downto 0); -- 26-Bit Jump Address from Instruction (Bits 25:0)
           BOffset : in STD_LOGIC_VECTOR (31 downto 0); -- 32-Bit Sign-Extended Branch Offset
           PCSrc : in STD_LOGIC_VECTOR (1 downto 0); -- Control Signal to Decide How To Compute NPC
           PCWrite : in STD_LOGIC; -- Control Signal to Update PC to NPC
           Zero : in STD_LOGIC; -- Zero Result From ALU
           NPC : out STD_LOGIC_VECTOR (31 downto 0)); -- NPC Output
  end component;

  signal OPC: STD_LOGIC_VECTOR (31 downto 0); -- Current PC Inputted In
  signal JAddress: STD_LOGIC_VECTOR (25 downto 0); -- 26-Bit Jump Address from Instruction (Bits 25:0)
  signal BOffset: STD_LOGIC_VECTOR (31 downto 0); -- 32-Bit Sign-Extended Branch Offset
  signal PCSrc: STD_LOGIC_VECTOR (1 downto 0); -- Control Signal to Decide How To Compute NPC
  signal PCWrite: STD_LOGIC; -- Control Signal to Update PC to NPC
  signal Zero: STD_LOGIC; -- Zero Result From ALU
  signal NPC: STD_LOGIC_VECTOR (31 downto 0); -- NPC Output

begin

  -- Mapping Ports to Signals
  uut: PCUnit port map ( OPC      => OPC,
                         JAddress => JAddress,
                         BOffset  => BOffset,
                         PCSrc    => PCSrc,
                         PCWrite  => PCWrite,
                         Zero     => Zero,
                         NPC      => NPC );

  -- Start of Test Bench
  stimulus: process
  begin
  
    OPC <= x"00000000"; -- Initial PC
    JAddress <= "10000000000000000000000001"; -- Jump to 0x08000004
    BOffset <= x"0000003f"; -- Branch to 0x000000fc
    PCSrc <= "00"; -- NPC = PC + 4
    PCWrite <= '0'; -- PCWrite Disabled
    Zero <= '0'; -- Branch Condition = False
  
    wait for 10 ns; -- Delay
  
    PCSrc <= "00"; -- Perform Regular PC + 4
    PCWrite <= '1'; -- Update NPC
    
    wait for 10 ns; -- Delay
    PCWrite <= '0'; -- PCWrite Disabled
        PCSrc <= "00"; -- Perform Regular PC + 4
    wait for 10 ns; -- Delay

    PCSrc <= "01"; -- Perform Jump 
    PCWrite <= '1'; -- Update NPC  
    
    wait for 10 ns; -- Delay
    PCWrite <= '0'; -- PCWrite Disabled
        PCSrc <= "00"; -- Perform Regular PC + 4
    wait for 10 ns; -- Delay

    PCSrc <= "10"; -- Perform Branch 
    Zero <= '0'; -- Branch Not Taken
    PCWrite <= '1'; -- Update NPC 
    
    wait for 10 ns; -- Delay
    PCWrite <= '0'; -- PCWrite Disabled
        PCSrc <= "00"; -- Perform Regular PC + 4
    wait for 10 ns; -- Delay

    PCSrc <= "10"; -- Perform Branch
    Zero <= '1'; -- Branch Taken
    PCWrite <= '1'; -- Update NPC

    wait; -- Wait Indefinitely
  end process;
  -- End of Test Bench

end;