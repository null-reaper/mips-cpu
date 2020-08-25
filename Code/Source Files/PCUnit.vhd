----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: PCUnit - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PCUnit is
   Port ( OPC : in STD_LOGIC_VECTOR (31 downto 0); -- Current PC Inputted In
          JAddress : in STD_LOGIC_VECTOR (25 downto 0); -- 26-Bit Jump Address from Instruction (Bits 25:0)
          BOffset : in STD_LOGIC_VECTOR (31 downto 0); -- 32-Bit Sign-Extended Branch Offset
          PCSrc : in STD_LOGIC_VECTOR (1 downto 0); -- Control Signal to Decide How To Compute NPC
          PCWrite : in STD_LOGIC; -- Control Signal to Update PC to NPC
          Zero : in STD_LOGIC; -- Zero Result From ALU
          NPC : out STD_LOGIC_VECTOR (31 downto 0)); -- NPC Output
end PCUnit;

architecture Behavioral of PCUnit is

    signal PC : STD_LOGIC_VECTOR (31 downto 0) := x"00000000"; -- Signal for NPC
    signal BranchOffset : STD_LOGIC_VECTOR (31 downto 0) := x"00000000"; -- Signal for Left-Shifted-2 Branch Offset
    signal P4OUT : STD_LOGIC_VECTOR (31 downto 0) := x"00000000"; -- Output Signal for PC+4 Adder
    signal BRANCHOUT : STD_LOGIC_VECTOR (31 downto 0) := x"00000000"; -- Output Signal for Branch Adder
     
    -- Full Adder Component 
    component CRA_32
                Port ( A : in STD_LOGIC_VECTOR(31 downto 0);
                   B : in STD_LOGIC_VECTOR(31 downto 0);
                   Cin : in STD_LOGIC;
                   S : out STD_LOGIC_VECTOR(31 downto 0);
                   Cout : out STD_LOGIC);
    end component;

begin
    -- PC + 4 Adder
    PLUS4ADDER: CRA_32 port map ( 
        A => OPC(31 downto 0), -- Current PC
        B => x"00000004",     -- + 4
        Cin => '0', 
        S => P4OUT(31 downto 0));  
    -- Branch Adder 
    BRANCHADDER: CRA_32 port map (
        A => OPC(31 downto 0),         -- Currrent PC
        B => BranchOffset(31 downto 0),-- + Branch Offset
        Cin => '0', 
        S => BRANCHOUT(31 downto 0));

  BranchOffset <= BOffset(29 downto 0) & "00"; -- Left-Shift-2 Branch Offset

-- Compute NPC
process (OPC, JAddress, PCSrc, Zero, P4OUT, BRANCHOUT) is
begin
  if PCSrc = "01" then -- j instruction
      PC <= OPC(31 downto 28) & JAddress(25 downto 0) & "00"; -- Compute Jump Address
  elsif PCSrc = "10" then -- beq instruction
    -- Branch Only if Zero Result of ALU = 1
    if Zero = '1' then 
      PC <= BRANCHOUT; -- Branch Address
    else
      PC <= P4OUT; -- PC + 4
    end if;
  else -- For Any Other Instruction
    PC <= P4OUT; --PC + 4
  end if;
end process;

-- Update PC to NPC
process (PCWrite)
  variable PCHold : STD_LOGIC_VECTOR (31 downto 0) := x"00000000"; -- Buffer for NPC
begin
  -- Output NPC Only if PCWrite Asserted 
  if PCWrite = '1' then
    PCHold := PC;
  end if;
  NPC <= PCHold;
end process;

end Behavioral;