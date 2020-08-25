----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: MemoryController_tb - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MemoryController_tb is
end;

architecture bench of MemoryController_tb is

  component MemoryController
    Port ( IorD : in STD_LOGIC; -- Control Signal for Instruction Vs Data
           MemRead : in STD_LOGIC; -- Control Signal to Read from Memory
           MemWrite : in STD_LOGIC; -- Control Signal to Write to Memory
           MemReadOut : out STD_LOGIC; -- Output to Forward MemRead to Memory
           MemWriteOut : out STD_LOGIC; -- Output to Forward MemWrite to Memory
           MemIn : in STD_LOGIC_VECTOR (31 downto 0); -- Data Input From Memory
           MemOut : out STD_LOGIC_VECTOR (31 downto 0); -- Data Output to Memory
           WData : in STD_LOGIC_VECTOR (31 downto 0); -- Data to Write to Memory from CPU
           RData : out STD_LOGIC_VECTOR (31 downto 0); -- Data Read Sent to CPU
           IAddress : in STD_LOGIC_VECTOR (31 downto 0); -- Instruction Address
           DAddress : in STD_LOGIC_VECTOR (31 downto 0); -- Data Address
           AddressOut : out STD_LOGIC_VECTOR (31 downto 0)); -- Output to Forwarde Address to Memory
  end component;

  signal IorD: STD_LOGIC; -- Control Signal for Instruction Vs Data
  signal MemRead: STD_LOGIC; -- Control Signal to Read from Memory
  signal MemWrite: STD_LOGIC; -- Control Signal to Write to Memory
  signal MemReadOut: STD_LOGIC; -- Output to Forward MemRead to Memory
  signal MemWriteOut: STD_LOGIC; -- Output to Forward MemWrite to Memory
  signal MemIn: STD_LOGIC_VECTOR (31 downto 0); -- Data Input From Memory
  signal MemOut: STD_LOGIC_VECTOR (31 downto 0); -- Data Output to Memory
  signal WData: STD_LOGIC_VECTOR (31 downto 0); -- Data to Write to Memory from CPU
  signal RData: STD_LOGIC_VECTOR (31 downto 0); -- Data Read Sent to CPU
  signal IAddress: STD_LOGIC_VECTOR (31 downto 0); -- Instruction Address
  signal DAddress: STD_LOGIC_VECTOR (31 downto 0); -- Data Address
  signal AddressOut: STD_LOGIC_VECTOR (31 downto 0); -- Output to Forwarde Address to Memory

begin

  -- Mapping Ports to Signals
  uut: MemoryController port map ( IorD        => IorD,
                                   MemRead     => MemRead,
                                   MemWrite    => MemWrite,
                                   MemReadOut  => MemReadOut,
                                   MemWriteOut => MemWriteOut,
                                   MemIn       => MemIn,
                                   MemOut      => MemOut,
                                   WData       => WData,
                                   RData       => RData,
                                   IAddress    => IAddress,
                                   DAddress    => DAddress,
                                   AddressOut  => AddressOut );
  
  -- Start of Test Bench
  stimulus: process
  begin
  
    -- Writing to Instruction Memory
    
    IAddress <= x"00000000"; -- Initial Address
    MemRead <= '0'; -- MemRead Disabled
    MemWrite <= '0'; -- MemWrite Disabled
    IorD <= '0'; -- Instruction 
     
    wait for 10 ns; -- Wait
    
    WData <= x"12345678"; -- Data Being Written
    MemWrite <= '1'; -- Write to Memory
    IAddress <= x"00000004"; -- Memory Location 
    
    wait for 10 ns; -- Wait
    MemWrite <= '0'; -- MemWrite Disabled

    wait; -- Wait Indefinitely
  end process;
  -- End of Test Bench

end;