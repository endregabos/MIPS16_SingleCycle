----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 09:23:22 PM
-- Design Name: 
-- Module Name: MemorieDate - Behavioral
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

entity MemorieDate is
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           intrareALURes : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           iesireALURes : out STD_LOGIC_VECTOR(15 downto 0));
end MemorieDate;

architecture Behavioral of MemorieDate is
type tipMem is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal MEM : tipMem := (
-- valori random
    X"0001",
    X"0002",
    X"0003",
    X"0004",
    X"0005",
    X"0006",
    X"0007",
    X"0008",
    X"0009",
    X"000A",
    others => X"0000");
    
begin
    process(clk) 			
    begin
        if rising_edge(clk) then -- scriere SINCRONA
            if en = '1' and MemWrite='1' then
                MEM(conv_integer(intrareALURes(4 downto 0))) <= RD2; -- se iau cei mai putini semnificativi 5 biti pt ca avem o memorie de 32 			
            end if;
        end if;
    end process;
    
    MemData <= MEM(conv_integer(intrareALURes(4 downto 0))); -- citire ASINCRONA
    iesireALURes <= intrareALURes;

end Behavioral;
