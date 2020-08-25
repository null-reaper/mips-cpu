----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: CRA_32 - Behavioral
-- Programmer: Andrew Woltman
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CRA_32 is
--This is the port map for the Full Adder
    Port ( A : in STD_LOGIC_VECTOR(31 downto 0);
           B : in STD_LOGIC_VECTOR(31 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR(31 downto 0);
           Cout : out STD_LOGIC);
end CRA_32;

architecture Behavioral of CRA_32 is
--This is for the structural model, to create the component for the 32 bit CRA to made from.
component CRA_4
--Port map for the 4 bit adder
        Port ( A : in STD_LOGIC_VECTOR(3 downto 0);
           B : in STD_LOGIC_VECTOR(3 downto 0);
           Cin : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR(3 downto 0);
           Cout : out STD_LOGIC);
end component;
--These are the signals used to connect the carry bit to the next adder and Cout is the Carry bit of the 32 bit Adder
        signal car1,car2,car3,car4,car5,car6,car7: STD_LOGIC;
begin
--Creates 8 4 bit CRA adders and breating down the input of 31 downto 0 into 4 bit strings for each 4 bit CRA, Cout for
--the 32 bit CRA is the Carry bit of only the 8th 4 bit CRA
A1: CRA_4 port map (A(3 downto 0), B(3 downto 0), Cin, S(3 downto 0), car1);
A2: CRA_4 port map (A(7 downto 4), B(7 downto 4), car1, S(7 downto 4), car2);
A3: CRA_4 port map (A(11 downto 8), B(11 downto 8), car2, S(11 downto 8), car3);
A4: CRA_4 port map (A(15 downto 12), B(15 downto 12), car3, S(15 downto 12), car4);
A5: CRA_4 port map (A(19 downto 16), B(19 downto 16), car4, S(19 downto 16), car5);
A6: CRA_4 port map (A(23 downto 20), B(23 downto 20), car5, S(23 downto 20), car6);
A7: CRA_4 port map (A(27 downto 24), B(27 downto 24), car6, S(27 downto 24), car7);
A8: CRA_4 port map (A(31 downto 28), B(31 downto 28), car7, S(31 downto 28), Cout);

end Behavioral;
