----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: CRA_4 - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CRA_4 is
--This is the port map for the Full Adder
    Port ( A : in STD_LOGIC_VECTOR(3 downto 0);
           B : in STD_LOGIC_VECTOR(3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR(3 downto 0);
           Cout : out STD_LOGIC);
end CRA_4;

architecture Behavioral of CRA_4 is
--This is for the structural model, to create the component for the 4 bit CRA to made from.
component Full_Adder_1
        Port(A : in STD_LOGIC;
        B : in STD_LOGIC;
        Cin : in STD_LOGIC;
        S : out STD_LOGIC;
        Cout : out STD_LOGIC);
end component;
--These are the signals used to connect the carry bit to the next adder and Cout is the Carry bit of the 4 bit Adder
        signal car1,car2,car3: STD_LOGIC;
begin
--Creates 4 Full Adders and breating down the input of 3 downto 0 into bit strings for each Full Adder, Cout for
--the 4 bit CRA is the Carry bit of only the 4th Full Adder
A1: Full_Adder_1 port map (A(0), B(0), Cin, S(0), car1);
A2: Full_Adder_1 port map (A(1), B(1), car1, S(1), car2);
A3: Full_Adder_1 port map (A(2), B(2), car2, S(2), car3);
A4: Full_Adder_1 port map (A(3), B(3), car3, S(3), Cout);

end Behavioral;
