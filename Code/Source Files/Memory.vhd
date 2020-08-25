----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: Memory - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memory is
  Port ( MemIn : in STD_LOGIC_VECTOR (31 downto 0); -- Data Input from Memory
         MemOut : out STD_LOGIC_VECTOR (31 downto 0); -- Data Output to CPU
         MemRead : in STD_LOGIC; -- Control Signal to Read from Memory
         MemWrite : in STD_LOGIC; -- Control Signal to Write to Memory
         Address : in STD_LOGIC_VECTOR (31 downto 0)); -- Memory Address
end Memory;

architecture Behavioral of Memory is
    type MEMORY is array (1023 downto 0) of STD_LOGIC_VECTOR(31 downto 0);  -- Array of 1024 x 32 bit memory locations
    
    -- Initializing Instructions in Memory
        signal MEMORY1024x32 : MEMORY := (others => x"00000000");
begin    

-- Read from Memory
process (MemRead)
begin
    if MemRead = '1' then -- Read Only if Enabled
      MemOut <= MEMORY1024x32(to_integer(unsigned(Address(31 downto 2)) mod 1024)); -- Read from Appropriate Block of Memory
    end if;
end process;

-- Write to Memory
process (MemWrite)
begin
    if MemWrite = '1' then -- Write Only if Enabled
      MEMORY1024x32(to_integer(unsigned(Address(31 downto 2))) mod 1024) <= MemIn; -- Write to Appropriate Block of Memory
    end if;
end process;

end Behavioral;