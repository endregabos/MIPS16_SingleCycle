----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/22/2021 08:38:24 PM
-- Design Name: 
-- Module Name: MPG_lab1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG_lab1 is
    Port ( clk : in STD_LOGIC;
           enable : out STD_LOGIC;
           btn : in STD_LOGIC);
end MPG_lab1;

architecture Behavioral of MPG_lab1 is
signal numarator : std_logic_vector(15 downto 0) := (others => '0');
signal Q1 : std_logic;
signal Q2 : std_logic;
signal Q3 : std_logic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            numarator <= numarator + 1;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            if numarator = "1111111111111111" then
                Q1 <= btn;
            end if;
        end if;
    end process;
    
    process(clk)
    begin
        if rising_edge(clk) then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;
    
    enable <= Q2 and (not Q3);
end Behavioral;
