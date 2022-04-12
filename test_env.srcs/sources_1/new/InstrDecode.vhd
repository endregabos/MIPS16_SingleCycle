----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 06:56:19 PM
-- Design Name: 
-- Module Name: InstrDecode - Behavioral
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

entity InstrDecode is
  Port (   clk : in std_logic;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0); --*
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0); --*
           RD2 : out STD_LOGIC_VECTOR (15 downto 0); --*
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           writeEn : in STD_LOGIC); --instruction(3)
end InstrDecode;

architecture Behavioral of InstrDecode is

signal writeAddr:std_logic_vector(2 downto 0); -- iesirea de la mux

component RegFile is
    Port ( ra1: in STD_LOGIC_VECTOR (2 downto 0);
           ra2 : in STD_LOGIC_VECTOR (2 downto 0);
           wa : in STD_LOGIC_VECTOR (2 downto 0);
           wd : in STD_LOGIC_VECTOR(15 downto 0);
           regWrite : in STD_LOGIC; --enable pt RF
           clk : in STD_LOGIC;
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           writeEn : in STD_LOGIC);
end component;

begin

process(RegDst)
    begin
        if RegDst = '0' then
            writeAddr <= instruction(9 downto 7);
        else
            writeAddr <= instruction(6 downto 4);
        end if;
    end process;
    
process(ExtOp)
    begin
        if ExtOp = '1' and instruction(6) = '1' then
            ExtImm <= "111111111" & instruction(6 downto 0);
        else
            ExtImm <= "000000000" & instruction(6 downto 0);
        end if;
    end process;

    sa <= instruction(3);
    func <= instruction(2 downto 0);
    
    RegFilePort:RegFile port map(instruction(12 downto 10), instruction(9 downto 7), writeAddr, WD, RegWrite, clk, RD1, RD2, writeEn);
end Behavioral;
