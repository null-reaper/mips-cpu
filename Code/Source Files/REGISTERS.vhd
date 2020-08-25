----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: REGISTERS - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity REGISTERS is
    Port ( READREG1 : in STD_LOGIC_VECTOR(4 downto 0) := "00000";
           READREG2 : in STD_LOGIC_VECTOR(4 downto 0) := "00000";
           READREG3 : in STD_LOGIC_VECTOR(4 downto 0) := "00000";
           WRITEDATA_MEM : in STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
           WRITEDATA_ALU : in STD_LOGIC_VECTOR(31 downto 0) := x"00000000";   
           REGWRITE : in STD_LOGIC := '0';
           RegDst : in STD_LOGIC := '0';
           MemToReg : in STD_LOGIC:= '0'; 
           READDATA1 : out STD_LOGIC_VECTOR(31 downto 0);
           READDATA2 : out STD_LOGIC_VECTOR(31 downto 0));
end REGISTERS;

architecture Behavioral of REGISTERS is

type registersArray is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal readarray:registersArray := (x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
                                x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
                                x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",
                                x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000",x"00000000");
begin
    READDATA1 <= readarray(to_integer(unsigned(READREG1)));
    READDATA2 <= readarray(to_integer(unsigned(READREG2)));
    
    writeProcess: process(RegDst,REGWRITE,MemToReg,WRITEDATA_ALU,WRITEDATA_MEM,READREG2,READREG3) is
    begin
        if (REGWRITE = '1') then
			if (RegDst = '1') then
                 if (MemToReg = '0') then
                    readarray(to_integer(unsigned(READREG3))) <= WRITEDATA_ALU;
                 else
                    readarray(to_integer(unsigned(READREG3))) <= WRITEDATA_MEM;
                 end if;
		    else
                 if (MemToReg = '0') then
                    readarray(to_integer(unsigned(READREG2))) <= WRITEDATA_ALU;
                 else
                    readarray(to_integer(unsigned(READREG2))) <= WRITEDATA_MEM;
                 end if;
			end if;
	   end if;
	end process;

end Behavioral;