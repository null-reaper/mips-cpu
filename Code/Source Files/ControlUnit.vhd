----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: ControlUnit - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlUnit is
    Port ( clk : in STD_LOGIC; -- Clock Input
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
end ControlUnit;

architecture Behavioral of ControlUnit is
    signal instr : STD_LOGIC_VECTOR (3 downto 0) := "1111"; -- Signal to Hold Decoded Instruction (Default -- Invalid Instruction)
begin
    instr <= instruction; -- Get Decoded Instruction from IR
    
process(clk) is
    variable stageCount : integer := 0; -- Stage Counter
    variable stageEnd : integer  := 4; -- Stage Counter Limit   
begin

-- Perform Operation On Every Rising Edge of Clock
    if (rising_edge(clk)) then
       
       stageCount := stageCount + 1; -- Increment Stage Count
       
       -- First 2 Stages Common to All Intsructions
       case stageCount is
             when 1 => -- IF: Fetch Instruction from Memory
               IorD <= '0'; -- Instruction
               MemRead <= '1'; -- MemRead Asserted
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00";
               PCWrite <= '0';
             when 2 => -- ID: Decode Instruction
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '1'; -- Send Instrution to IR for Decoding
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00";
               PCWrite <= '0';
             when others=> -- Others Clause
               null;
       end case; 
       
       -- Remaining Stages Depending on Decoded Instruction
       case instr is
         when "0000" => -- j instruction
           stageEnd := 4; -- Jump Takes 4 Stages for Execution
           case stageCount is
             when 3 =>null; -- PC: Compute NPC
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "01"; -- PCU Computes Jump Address
               PCWrite <= '0';
             when 4 =>null; -- PCW: Update PC to NPC 
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "01";
               PCWrite <= '1'; -- Write NPC to Output
             when others=> -- Others Clause
               null;
           end case;
           
         when "0001" => -- beq instruction
           stageEnd := 6; -- Branch On Equal Takes 6 Stages
           case stageCount is
             when 3 => -- REG: Wait for Registers Block to Output Register Contents
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00";
               PCWrite <= '0';
             when 4 => -- ALU: ALU Performs Operation
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "011"; -- Subtract
               ALUSrc <= '0'; -- Use Register Content as ALU Input #2
               PCSrc <= "00";
               PCWrite <= '0';
             when 5 =>  -- PC: Compute NPC
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "011";
               ALUSrc <= '0';
               PCSrc <= "10"; -- PC Computes Branch Address
               PCWrite <= '0';
              when 6 =>null; -- PCW: Update PC to NPC 
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "011";
               PCSrc <= "10";
               PCWrite <= '1'; -- Write NPC to Output
             when others=> -- Others Clause
               null;
           end case;
         
          when "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1010" | "1100" | "1101" => -- add/sub/and/or/nor/slt/addi/andi/ori instruction
           stageEnd := 7; -- R-Type & I-Type Instructions Take 7 stages
           case stageCount is
             when 3 => -- REG: Wait for Registers Block to Output Register Contents
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= not instruction(3); -- Set RegDst Based On Instruction
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00";
               PCWrite <= '0';
             when 4 => -- ALU: ALU Performs Operation
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= not instruction(3);
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= instruction(2 downto 0); -- Select ALUOp Based on Decoded Instruction
               ALUSrc <= instruction(3); -- Select Imm Value Vs Register Contents as ALU Input #2 Based On Decoded Instruction
               PCSrc <= "00";
               PCWrite <= '0';
             when 5 => -- WB: Write Data to Register
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= not instruction(3);
               MemToReg <= '0'; -- Writing from ALU Output
               RegWrite <= '1'; -- Enable Write to Register
               ALUOp <= instruction(2 downto 0);
               ALUSrc <= instruction(3);
               PCSrc <= "00";
               PCWrite <= '0';
             when 6 =>  -- PC: Compute NPC
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00"; -- PCU Computes PC + 4 
               PCWrite <= '0';
              when 7 =>null; -- PCW: Update PC to NPC 
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "00";
               PCWrite <= '1'; -- Write NPC to Output
             when others=> -- Others Clause
               null;
           end case;  
           
         when "1000" => -- sw instruction
           stageEnd := 7;
           case stageCount is
             when 3 => -- REG: Wait for Registers Block to Output Register Contents
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00";
               PCWrite <= '0';
             when 4 => -- ALU: ALU Performs Operation
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "010"; -- Add
               ALUSrc <= '1'; -- Use Imm Value as ALU Input #2
               PCSrc <= "00";
               PCWrite <= '0';
             when 5 => -- MEM: Memory Access
               IorD <= '1';
               MemRead <= '0';
               MemWrite <= '1'; -- Enable Write to Memory
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "010";
               ALUSrc <= '1';
               PCSrc <= "00";
               PCWrite <= '0';
             when 6 => -- PC: Compute NPC
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00"; -- PCU Computes PC + 4
               PCWrite <= '0';
              when 7 =>null; -- PCW: Update PC to NPC 
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "00";
               PCWrite <= '1'; -- Write NPC to Output
             when others=> -- Others Clause
               null;
            end case;
            
         when "1001" => -- lw instruction
           stageEnd := 8;
           case stageCount is
             when 3 => -- REG: Wait for Registers Block to Output Register Contents
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0'; -- RegDst for lw instruction
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00";
               PCWrite <= '0';
             when 4 => -- ALU: ALU Performs Operation
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "010"; -- Add
               ALUSrc <= '1'; -- Use Imm Value as ALU Input #2
               PCSrc <= "00";
               PCWrite <= '0';
             when 5 => -- MEM: Memory Access
               IorD <= '1';
               MemRead <= '1'; -- Enable Memory Read
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "010";
               ALUSrc <= '1';
               PCSrc <= "00";
               PCWrite <= '0';
             when 6 => -- WB: Write Data to Register
               IorD <= '1';
               MemRead <= '1';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '1'; -- Writing from Memory
               RegWrite <= '1'; -- Enable Write to Register
               ALUOp <= "010";
               ALUSrc <= '1';
               PCSrc <= "00";
               PCWrite <= '0';
             when 7 => -- PC: Compute NPC
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUOp <= "000";
               ALUSrc <= '0';
               PCSrc <= "00"; -- PCU Computes PC + 4
               PCWrite <= '0';
              when 8 =>null; -- PCW: Update PC to NPC 
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "00";
               PCWrite <= '1'; -- Write NPC to Output
             when others=> -- Others Clause
               null;
            end case;     
             
         when others => -- Invalid Instruction
            stageEnd := 4;
           case stageCount is
             when 3 =>null; -- PC: Compute NPC
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "00"; -- PCU Computes PC + 4
               PCWrite <= '0';
             when 4 =>null; -- PCW: Update PC to NPC 
               IorD <= '0';
               MemRead <= '0';
               MemWrite <= '0';
               IRWrite <= '0';
               RegDst <= '0';
               MemToReg <= '0';
               RegWrite <= '0';
               ALUSrc <= '0';
               ALUOp <= "000";
               PCSrc <= "00";
               PCWrite <= '1'; -- Write NPC to Output
             when others=> -- Others Clause
               null;
             end case;
      end case;
        
      stage <= STD_LOGIC_VECTOR(to_signed(stageCount, 4)); -- Output Current Stage
  
      -- Restart Stage Count at End of Instruction Execution
      if stageCount >= stageEnd then
        stageCount := 0;
      end if;
            
    end if;
end process;

end Behavioral;