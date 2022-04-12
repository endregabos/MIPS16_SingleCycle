----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2021 06:36:31 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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

entity SSD is
    Port ( Digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end SSD;

architecture Behavioral of SSD is
signal sel_temp: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal x: STD_LOGIC_VECTOR (3 downto 0);
signal sgn_cat: STD_LOGIC_VECTOR (6 downto 0);
signal sgn_an: STD_LOGIC_VECTOR (3 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            sel_temp <= sel_temp + 1;
        end if;
    end process;
    
    process(clk)
    begin
        case sel_temp(15 downto 14) is
            when "00" =>  x<=Digit(3 downto 0);
            when "01" =>  x<=Digit(7 downto 4);
            when "10" =>  x<=Digit(11 downto 8);
            when  others =>  x<=Digit(15 downto 12);
        end case;
    end process;
    
    process(clk)
    begin
        case sel_temp(15 downto 14) is
            when "00" =>  sgn_an <="1110";
            when "01" =>  sgn_an <="1101";
            when "10" =>  sgn_an <="1011";
            when  others => sgn_an <="0111";
        end case;
    end process;
    
    process(x)
    begin
    case x is            
                 when "0000" => sgn_cat <= "1000000"; --0;
                 when "0001" => sgn_cat <= "1111001"; --1
                 when "0010" => sgn_cat <= "0100100"; --2
                 when "0011" => sgn_cat <= "0110000"; --3
                 when "0100" => sgn_cat <= "0011001"; --4
                 when "0101" => sgn_cat <= "0010010"; --5
                 when "0110" => sgn_cat <= "0000010"; --6
                 when "0111" => sgn_cat <= "1111000"; --7
                 when "1000" => sgn_cat <= "0000000"; --8
                 when "1001" => sgn_cat <= "0010000"; --9
                 when "1010" => sgn_cat <= "0001000"; --A
                 when "1011" => sgn_cat <= "0000011"; --b
                 when "1100" => sgn_cat <= "1000110"; --C
                 when "1101" => sgn_cat <= "0100001"; --d
                 when "1110" => sgn_cat <= "0000110"; --E
                 when "1111" => sgn_cat <= "0001110"; --F
                 when others => sgn_cat <= "0111111"; -- gol
     end case;
     cat <= sgn_cat;
     an <= sgn_an;
end process;

end Behavioral;
