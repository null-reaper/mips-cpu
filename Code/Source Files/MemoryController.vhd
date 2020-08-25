----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: ControlUnit_tb - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
-- Module Name: MemoryController - Behavioral
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemoryController is
  Port (IorD : in STD_LOGIC; -- Control Signal for Instruction Vs Data
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
end MemoryController;

architecture Behavioral of MemoryController is
begin

-- Forward Appropriate Address to Memory
process (IAddress, DAddress, IorD)
begin
  if IorD = '1' then -- Data?
    AddressOut <= DAddress; -- Data Address
  else -- Instruction?
    AddressOut <= IAddress; -- Instruction Address
  end if;
end process;

-- Forward MemRead & MemWrit to Memory
process (MemRead, MemWrite, IorD)
begin
  MemReadOut <= MemRead; -- Forward MemRead
  -- Forward MemWrite Only If Writing to Data Memory
  if IorD = '1' then MemWriteOut <= MemWrite; 
  else MemWriteOut <= '0';
  end if;
end process;
        
RData <= MemIn; -- Forward Data Read from Memory to CPU
MemOut <= WData; -- Forward Data to Write to Memory from CPU

end Behavioral;