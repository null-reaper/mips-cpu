----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: Full_Adder_1 - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder_1 is
--This is the port map for the Full Adder
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
end Full_Adder_1;

architecture Behavioral of Full_Adder_1 is

begin
--This is the gate equivalent of the Full Adder
S <= A xor B xor Cin;
Cout <= (A and B) or (A and Cin) or (B and Cin);
end Behavioral;
