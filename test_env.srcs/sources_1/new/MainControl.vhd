----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2021 10:28:26 PM
-- Design Name: 
-- Module Name: MainControl - Behavioral
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

entity MainControl is
  Port ( Instruction : in STD_LOGIC_VECTOR (2 downto 0);
         RegDst : out STD_LOGIC;
         ExtOp : out STD_LOGIC;
         ALUSrc : out STD_LOGIC;
         Branch : out STD_LOGIC;
         Jump : out STD_LOGIC;
         ALUOp : out STD_LOGIC_VECTOR(2 downto 0);
         MemWrite : out STD_LOGIC;
         MemtoReg : out STD_LOGIC;
         RegWrite : out STD_LOGIC
  );
end MainControl;

architecture Behavioral of MainControl is
begin
    process(Instruction)
    begin
        RegDst <= '0'; ExtOp <= '0'; ALUSrc <= '0';
        Branch <= '0'; Jump <= '0'; MemWrite <= '0';
        MemtoReg <= '0'; RegWrite <= '0'; ALUOp <= "000";
        case (Instruction) is
            when "000" => -- tip R
                RegDst <= '1';  
                RegWrite <= '1';
                ALUOp <= "000";
            when "001" => -- ADDI
                ExtOp <= '1';  
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "001";
            when "010" => -- LW
                ExtOp <= '1';
                ALUSrc <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                ALUOp <= "001";
            when "011" => -- SW 
                ExtOp <= '1';
                ALUSrc <= '1';
                MemWrite <= '1';
                ALUOp <= "001";
            when "100" => -- BEQ
                ExtOp <= '1';
                Branch <= '1';
                ALUOp <= "010";
            when "101" => -- SUBI
                ExtOp <= '1';
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "010";
            when "110" => -- ORI 
                ALUSrc <= '1';
                RegWrite <= '1';
                ALUOp <= "011";
            when "111" => -- J
                Jump <= '1';
            when others => 
                RegDst <= 'X'; ExtOp <= 'X'; ALUSrc <= 'X'; Branch <= 'X';
                Jump <= 'X'; 
                ALUOp <= "XXX";
                MemWrite <= 'X';
                RegWrite <= 'X';
                MemtoReg<= 'X';
            end case; 
    end process;

end Behavioral;
