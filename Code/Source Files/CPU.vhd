----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: CPU - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
    Port ( clk : in STD_LOGIC; -- Clock Input
           stage : out STD_LOGIC_VECTOR(3 downto 0)); -- Outputs Current Stage (Only For Testing)
end CPU;

architecture Behavioral of CPU is
  component ControlUnit
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
  end component;
  
  component PCUnit
     Port ( OPC : in STD_LOGIC_VECTOR (31 downto 0); -- Current PC Inputted In
            JAddress : in STD_LOGIC_VECTOR (25 downto 0); -- 26-Bit Jump Address from Instruction (Bits 25:0)
            BOffset : in STD_LOGIC_VECTOR (31 downto 0); -- 32-Bit Sign-Extended Branch Offset
            PCSrc : in STD_LOGIC_VECTOR (1 downto 0); -- Control Signal to Decide How To Compute NPC
            PCWrite : in STD_LOGIC; -- Control Signal to Update PC to NPC
            Zero : in STD_LOGIC; -- Zero Result From ALU
            NPC : out STD_LOGIC_VECTOR (31 downto 0)); -- NPC Output
  end component;
  
  component MemoryController
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
  end component;
  
  component Memory
    Port ( MemIn : in STD_LOGIC_VECTOR (31 downto 0); -- Data Input from Memory
           MemOut : out STD_LOGIC_VECTOR (31 downto 0); -- Data Output to CPU
           MemRead : in STD_LOGIC; -- Control Signal to Read from Memory
           MemWrite : in STD_LOGIC; -- Control Signal to Write to Memory
           Address : in STD_LOGIC_VECTOR (31 downto 0)); -- Memory Address
  end component;
  
  
  component INSTRUCTION_REGISTERS
      Port ( INSTRUCTION : in STD_LOGIC_VECTOR(31 downto 0);
           IRWrite : in STD_LOGIC := '0';
           REG1 : out STD_LOGIC_VECTOR(4 downto 0);
           REG2 : out STD_LOGIC_VECTOR(4 downto 0);
           REG3 : out STD_LOGIC_VECTOR(4 downto 0);
           IMM : out STD_LOGIC_VECTOR(31 downto 0);
           JMP_ADDRESS : out STD_LOGIC_VECTOR(25 downto 0);
           INSTRUCTION_TYP : out STD_LOGIC_VECTOR(3 downto 0));
  end component;
  
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
  
  component ALU_32
      Port ( ALU_OP : in STD_LOGIC_VECTOR(2 downto 0);
                 ALUSrc : in STD_LOGIC;
                 INPUT_A : in STD_LOGIC_VECTOR(31 downto 0);
                 INPUT_B : in STD_LOGIC_VECTOR(31 downto 0);
                 INPUT_IMM : in STD_LOGIC_VECTOR(31 downto 0);
                 OUTPUT : out STD_LOGIC_VECTOR(31 downto 0);
                 ZERO : out STD_LOGIC);
  end component;
    
  signal PCSrc_MCU: STD_LOGIC_VECTOR (1 downto 0); -- PCSrc Output from MCU
  signal PCSrc_PCU: STD_LOGIC_VECTOR (1 downto 0); -- PCSrc Input to PCU
  signal PCWrite_MCU: STD_LOGIC; -- PCWRite Output from MCU
  signal PCWrite_PCU: STD_LOGIC; -- PCWrite Input to PCU
  
  signal IorD_MCU: STD_LOGIC; -- IorD Output from MCU
  signal IorD_MemControl: STD_LOGIC; -- IorD Input to MemControl
  signal MemRead_MCU: STD_LOGIC; -- MemRead Output from MCU
  signal MemRead_MemControl: STD_LOGIC; -- MemRead Input to MemControl
  signal MemWrite_MCU: STD_LOGIC; -- MemWrite Output from MCU
  signal MemWrite_MemControl: STD_LOGIC; -- MemWrite Input to MemControl
  
  signal IAddress : STD_LOGIC_VECTOR (31 downto 0); -- Instruction Address
  signal DAddress : STD_LOGIC_VECTOR(31 downto 0); -- Data Address
  
  signal MemOut_Cache: STD_LOGIC_VECTOR (31 downto 0); -- Data Output from MemControl
  signal MemIn_Cache: STD_LOGIC_VECTOR (31 downto 0); -- Data Input to Cache
  signal MemOut_MemControl: STD_LOGIC_VECTOR (31 downto 0); -- Data Output from Cache
  signal MemIn_MemControl: STD_LOGIC_VECTOR (31 downto 0); -- Data Input to MemControl
  
  signal MemReadOut : STD_LOGIC; -- MemRead Output from MemControl
  signal MemRead_Cache: STD_LOGIC; -- MemRead Input to Cache
  signal MemWriteOut : STD_LOGIC; -- MemWrite Output from MemControl
  signal MemWrite_Cache: STD_LOGIC; -- MemWrite Input to Cache
  signal AddressOut : STD_LOGIC_VECTOR (31 downto 0); -- Address Output from MemControl
  signal Address_Cache: STD_LOGIC_VECTOR (31 downto 0); -- Address Input to Cache
  
  signal RData_MemControl: STD_LOGIC_VECTOR(31 downto 0); -- Memory Data Output from MemControl
  signal INSTRUCTION_IR: STD_LOGIC_VECTOR(31 downto 0); -- Instruction Input to IR
  signal IRWrite_MCU: STD_LOGIC; -- IRWrite Output from MCU
  signal IRWrite_IR: STD_LOGIC; -- IRWrite Input to IR
  signal IMM_IR: STD_LOGIC_VECTOR(31 downto 0); -- 32-Bit Sign-Extended Imm Value Output from IR
  signal BOffset_PCU: STD_LOGIC_VECTOR(31 downto 0); -- 32 Bit Sign-Extended Branch Offset Input to PCU
  signal JMP_ADDRESS_IR: STD_LOGIC_VECTOR(25 downto 0); -- 26 Bit Jump Address Output from IR
  signal JAddress_PCU: STD_LOGIC_VECTOR(25 downto 0); -- 26 Bit Jump Address Input to PCU
  signal INSTRUCTION_TYP_IR : STD_LOGIC_VECTOR(3 downto 0); -- Decoded Instruction Output from IR
  signal instruction_MCU: STD_LOGIC_VECTOR(3 downto 0); -- Decoded Instruction Input to MCU


  signal REG1_IR: STD_LOGIC_VECTOR(4 downto 0); -- Read Register 1 Index Output from IR
  signal READREG1_REGS: STD_LOGIC_VECTOR(4 downto 0); -- Read Register 1 Index Input to Registers
  signal REG2_IR: STD_LOGIC_VECTOR(4 downto 0); -- Read Register 2/Write Register 1 Index Output from IR
  signal READREG2_REGS: STD_LOGIC_VECTOR(4 downto 0); -- Read Register 2.Write Register 1 Index Input to Registers
  signal REG3_IR: STD_LOGIC_VECTOR(4 downto 0); -- Write Register 2 Index Output from IR
  signal READREG3_REGS: STD_LOGIC_VECTOR(4 downto 0); -- Write Register 2 Index Input to Registers
  signal RegWrite_MCU: STD_LOGIC; -- RegWrite Output from MCU
  signal REGWRITE_REGS: STD_LOGIC; -- RegWrite Input to Registers
  signal MemToReg_MCU: STD_LOGIC; -- MemToReg Output from MCU
  signal MemToReg_REGS: STD_LOGIC; -- MemToReg Input to Registers
  signal RegDst_MCU : STD_LOGIC; -- RegDst Output from MCU
  signal RegDst_REGS : STD_LOGIC; -- RegDst Input to Registers

  signal ALUOp_MCU: STD_LOGIC_VECTOR(2 downto 0); -- ALUOp Output from MCU
  signal ALU_OP_ALU: STD_LOGIC_VECTOR(2 downto 0); -- ALUOp Input to ALU
  signal ALUSrc_MCU: STD_LOGIC; -- ALUSrc Output from MCU
  signal ALUSrc_ALU: STD_LOGIC; -- ALUSrc Input to ALU
  signal READDATA1_REGS: STD_LOGIC_VECTOR(31 downto 0); -- Read Register 1 Contents Output from Registers
  signal INPUT_A_ALU: STD_LOGIC_VECTOR(31 downto 0); -- Read Register 1 Contents Input to ALU
  signal READDATA2_REGS: STD_LOGIC_VECTOR(31 downto 0); -- Read Register 2 Contents Output from Registers
  signal INPUT_B_ALU: STD_LOGIC_VECTOR(31 downto 0); -- Read Register 2 Contents Input to ALU
  signal INPUT_IMM_ALU: STD_LOGIC_VECTOR(31 downto 0); -- Imm Value Input to ALU
  signal OUTPUT_ALU: STD_LOGIC_VECTOR(31 downto 0); -- ALU Ouput
  signal Zero_PCU: STD_LOGIC; -- Zero Result Input to PCU 
  signal ZERO_ALU: STD_LOGIC; -- Zero Result Output from ALU
  
  signal WRITEDATA_ALU_REGS : STD_LOGIC_VECTOR(31 downto 0); -- Write Data from ALU Input to Registers
  signal WData_MemControl: STD_LOGIC_VECTOR(31 downto 0); -- Write Dat from Memory Output from MemControl
  signal WRITEDATA_MEM_REGS: STD_LOGIC_VECTOR(31 downto 0); -- Write Data from Memory Input to Registers
  
  signal OPC_PCU : STD_LOGIC_VECTOR (31 downto 0); -- Current PC Input to PCU
  signal NPC_PCU : STD_LOGIC_VECTOR (31 downto 0); -- NPC Output from PCU

begin

  -- Mapping Appropriate Ports
  MCU : ControlUnit port map ( clk         => clk,
                               instruction => instruction_MCU,
                               stage       => stage,
                               IorD        => IorD_MCU,
                               MemRead     => MemRead_MCU,
                               MemWrite    => MemWrite_MCU,
                               IRWrite     => IRWrite_MCU,
                               RegDst      => RegDst_MCU,
                               MemToReg    => MemToReg_MCU,
                               RegWrite    => RegWrite_MCU,
                               ALUOp       => ALUOp_MCU,
                               ALUSrc      => ALUSrc_MCU,
                               PCSrc       => PCSrc_MCU,
                               PCWrite     => PCWrite_MCU );
     
  -- Mapping Appropriate Ports
  PCU : PCUnit port map ( OPC      => OPC_PCU,
                          JAddress => JAddress_PCU,
                          BOffset  => BOffset_PCU,
                          PCSrc    => PCSrc_PCU,
                          PCWrite  => PCWrite_PCU,
                          Zero     => Zero_PCU,
                          NPC      => NPC_PCU );
     
  -- Mapping Appropriate Ports
  MemControl : MemoryController port map ( IorD        => IorD_MemControl,
                                           MemRead     => MemRead_MemControl,
                                           MemWrite    => MemWrite_MemControl,
                                           MemReadOut  => MemReadOut,
                                           MemWriteOut => MemWriteOut,
                                           MemIn       => MemIn_MemControl,
                                           MemOut      => MemOut_MemControl,
                                           WData       => WData_MemControl,
                                           RData       => RData_MemControl,
                                           IAddress    => IAddress,
                                           DAddress    => DAddress,
                                           AddressOut  => AddressOut );
     
  -- Mapping Appropriate Ports
  Cache : Memory port map ( MemIn    => MemIn_Cache,
                            MemOut   => MemOut_Cache,
                            MemRead  => MemRead_Cache,
                            MemWrite => MemWrite_Cache,
                            Address  => Address_Cache );
          
  -- Mapping Appropriate Ports
  IR : INSTRUCTION_REGISTERS port map ( INSTRUCTION => INSTRUCTION_IR,
                                        IRWrite     => IRWrite_IR,
                                        INSTRUCTION_TYP => INSTRUCTION_TYP_IR,
                                        REG1        => REG1_IR,
                                        REG2        => REG2_IR,
                                        REG3        => REG3_IR,
                                        IMM         => IMM_IR,
                                        JMP_ADDRESS => JMP_ADDRESS_IR);
                                        
  -- Mapping Appropriate Ports
  REGS: REGISTERS port map ( READREG1  => READREG1_REGS,
                            READREG2  => READREG2_REGS,
                            READREG3  => READREG3_REGS,
                            WRITEDATA_ALU => WRITEDATA_ALU_REGS,
                            WRITEDATA_MEM => WRITEDATA_MEM_REGS,
                            REGWRITE  => REGWRITE_REGS,
                            RegDst => RegDst_REGS,
                            MemToReg   => MemToReg_REGS,
                            READDATA1 => READDATA1_REGS,
                            READDATA2 => READDATA2_REGS);
                            
  -- Mapping Appropriate Ports
  ALU : ALU_32 port map ( ALU_OP     => ALU_OP_ALU,
                         ALUSrc     => ALUSrc_ALU,
                         INPUT_A    => INPUT_A_ALU,
                         INPUT_B    => INPUT_B_ALU,
                         INPUT_IMM  => INPUT_IMM_ALU,
                         OUTPUT     => OUTPUT_ALU,
                         ZERO       => ZERO_ALU );
        
  -- Wiring Connections
                              
  PCSrc_PCU <= PCSrc_MCU; -- MPU Sends PCSrc to PCU        
  PCWrite_PCU <= PCWrite_MCU; -- MPU Sends PCWrite to PCU          
  IorD_MemControl <= IorD_MCU; -- MPU Sends IorD to MemControl        
  MemRead_MemControl <= MemRead_MCU; -- MPU Sends MemRead to MemControl       
  MemWrite_MemControl <= MemWrite_MCU; -- MPU Sends MemRead to MemControl       
  IAddress <= NPC_PCU; -- PCU Sends Instruction Address to MemControl       
  OPC_PCU <= NPC_PCU; -- Loop Back PCU NPC Output to Current Pc Input
  
  MemIn_Cache <= MemOut_MemControl; -- MemControl Sends Data to Cache       
  MemIn_MemControl <= MemOut_Cache; -- Cache Sends Data to MemControl       
  MemRead_Cache <= MemReadOut; -- MemControl Sends MemRead to Cache       
  MemWrite_Cache <= MemWriteOut; -- MemControl Sends MemWrite to Cache       
  Address_Cache <= AddressOut; -- MemControl Sends Address to Cache       
  
  INSTRUCTION_IR <= RData_MemControl; -- MemControl Sends Instruction Word from Memory to IR       
  IRWrite_IR <= IRWrite_MCU; -- MCU Sends IRWrite to IR       
  BOffset_PCU <= IMM_IR; -- IR Sends 32-Bit Sign-Extended Branch Ofset to PCU       
  JAddress_PCU <= JMP_ADDRESS_IR; -- IR Sends 26-Bit Jump Address to IR       
  instruction_MCU <= INSTRUCTION_TYP_IR; -- IR Sends Decoded Instruction to MCU       
  
  READREG1_REGS <= REG1_IR; -- IR Sends Read Register 1 Index to Registers       
  READREG2_REGS <= REG2_IR; -- IR Sends Read Register 2/Write Register 1 Index to Registers       
  READREG3_REGS <= REG3_IR; -- IR Sends Write Register 2 Index to Registers       
  WRITEDATA_MEM_REGS <= RData_MemControl; -- MemControl Sends Data from Memory to Registers       
  REGWRITE_REGS <= RegWrite_MCU; -- MCU Sends RegWrite to Registers
  MemToReg_REGS <= MemToReg_MCU; -- MCU Sends MemToReg to Registers
  RegDst_REGS <= RegDst_MCU; -- MCU Sends RegDst to Registers
  
  ALU_OP_ALU <= ALUOp_MCU; -- MCU Sends ALUOP to ALU
  ALUSrc_ALU <= ALUSrc_MCU; -- MCU Sends ALUSrc to ALU
  INPUT_A_ALU <= READDATA1_REGS; -- Registers Sends Read Register 1 Contents to ALU
  INPUT_B_ALU <= READDATA2_REGS; -- Registers Sends Read Register 2 Contents to ALU
  INPUT_IMM_ALU <= IMM_IR; -- Registers Sends Imm Value to ALU
  Zero_PCU <= ZERO_ALU; -- ALU Sends Zero Result to PCU
  DAddress <= OUTPUT_ALU; -- ALU Sends Operation Result to MemControl as Data Address
  WRITEDATA_ALU_REGS <= OUTPUT_ALU; -- ALU Sends Operation Result to Registers for Register Write
  WData_MemControl <= READDATA2_REGS; -- Registers Sends Read Register 2 Contents to MemControl for Memory Write

end Behavioral;
