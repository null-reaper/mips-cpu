----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: Memory_tb - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Memory_tb is
end;

architecture bench of Memory_tb is

  component Memory
    Port ( MemIn : in STD_LOGIC_VECTOR (31 downto 0); -- Data Input from Memory
           MemOut : out STD_LOGIC_VECTOR (31 downto 0); -- Data Output to CPU
           MemRead : in STD_LOGIC; -- Control Signal to Read from Memory
           MemWrite : in STD_LOGIC; -- Control Signal to Write to Memory
           Address : in STD_LOGIC_VECTOR (31 downto 0)); -- Memory Address
  end component;

  signal MemIn: STD_LOGIC_VECTOR (31 downto 0); -- Data Input from Memory
  signal MemOut: STD_LOGIC_VECTOR (31 downto 0); -- Data Output to CPU
  signal MemRead: STD_LOGIC; -- Control Signal to Read from Memory
  signal MemWrite: STD_LOGIC; -- Control Signal to Write to Memory
  signal Address: STD_LOGIC_VECTOR (31 downto 0); -- Memory Address

begin

  -- Mapping Ports to Signals
  uut: Memory port map ( MemIn    => MemIn,
                         MemOut   => MemOut,
                         MemRead  => MemRead,
                         MemWrite => MemWrite,
                         Address  => Address );

  -- Start of Test Bench
  stimulus: process
  begin
  
    MemIn <= x"12345678"; -- Data to Write
    Address <= x"00000004"; -- Memory Address
    MemRead <= '0'; -- MemRead Disabled
    MemWrite <= '0'; -- MemWrite Disabled
    
    wait for 10 ns; -- Wait
    
    MemWrite <= '1'; -- Write to Memory
    
    wait for 10 ns; -- Wait
    
    MemWrite <= '0'; -- MemWrite Disabled
    MemRead <= '1'; -- Read from Memory
    
    wait for 10 ns; -- Wait
    
    MemRead <= '0'; -- MemRead Disabled

    wait; -- Wait Indefinitely
  end process;
  -- End of Test Bench

end;