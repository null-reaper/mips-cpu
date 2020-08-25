----------------------------------------------------------------------------------
-- Project Name: ECE 485 Final Project - Building A CPU
-- Module Name: CPU_tb - Behavioral
-- Programmer: Clive Gomes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CPU_tb is
end;

architecture bench of CPU_tb is

  component CPU
      Port ( clk : in STD_LOGIC; -- Clock Input
             stage : out STD_LOGIC_VECTOR(3 downto 0)); -- Outputs Current Stage (Only For Testing)
  end component;

  signal clk: STD_LOGIC; -- Clock Input
  signal stage: STD_LOGIC_VECTOR(3 downto 0); -- Outputs Current Stage (Only For Testing)
  
  constant clock_period: time := 10 ns; -- Clock Cycle Time
  signal stop_the_clock: boolean; -- Clock On/Off Flag

begin

  -- Mapping Ports to Signals
  uut: CPU port map ( clk   => clk,
                      stage => stage );
     
  -- Start of Test Bench  
                    
  stimulus: process
  begin
  
    stop_the_clock <= false; -- start clock
    
    wait for 1000 ns;-- for 1000 ns; -- Wait
    
    stop_the_clock <= true; -- end clock
    
    wait; -- Wait Indefinitely
  end process;
  
  -- End Test Bench
  
  -- Generate Clock
  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2; -- Switch Value of CLK every half period
      wait for clock_period;
    end loop;
    wait;
  end process;

end;