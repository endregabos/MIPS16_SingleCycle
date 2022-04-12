----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 07:08:36 PM
-- Design Name: 
-- Module Name: UnitateExecutie - Behavioral
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

entity UnitateExecutie is
    Port ( RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           ALUsrc : in STD_LOGIC;
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ExtImm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR(2 downto 0);
           nextAddr : in STD_LOGIC_VECTOR(15 downto 0);
           ALURes : out STD_LOGIC_VECTOR(15 downto 0);
           BranchAddr : out STD_LOGIC_VECTOR(15 downto 0);
           zero : out STD_LOGIC);
end UnitateExecutie;

architecture Behavioral of UnitateExecutie is

signal iesireMux : STD_LOGIC_VECTOR(15 downto 0);
signal iesireAlu : STD_LOGIC_VECTOR(15 downto 0);
signal AluCtrl: STD_LOGIC_VECTOR(2 downto 0);
signal shiftR: STD_LOGIC_VECTOR(15 downto 0);
signal shiftL: STD_LOGIC_VECTOR(15 downto 0);

begin
    iesireMux <= RD2 when AluSrc = '0' else ExtImm;
    
    process(ALUOp, func)
    begin
        case ALUOp is
            when "000" => 
                case func is
                    when "000" => ALUCtrl <= "000"; -- ADD
                    when "001" => ALUCtrl <= "001"; -- SUB
                    when "010" => ALUCtrl <= "010"; -- SLL
                    when "011" => ALUCtrl <= "011"; -- SRL
                    when "100" => ALUCtrl <= "100"; -- AND
                    when "101" => ALUCtrl <= "101"; -- OR
                    when "110" => ALUCtrl <= "110"; -- NAND
                    when "111" => ALUCtrl <= "111"; -- XOR
                end case;
            when "001" => ALUCtrl <= "000"; -- addi ; lw ; sw
            when "010" => ALUCtrl <= "001"; -- beq ; subi
            when "011" => ALUCtrl <= "101"; -- ori
            when others => ALUCtrl <= "111"; -- jmp (ALUCtrl nu conteaza)
        end case;
    end process;
    
    process(sa)
    begin
        if sa = '1' then
            shiftL <= iesireMux(14 downto 0) & "0";
        else  shiftL <= iesireMux;
        end if; 
    end process;

    process(sa)
    begin
        if sa = '1' then 
            shiftR <= "0" & iesireMux(15 downto 1);
        else shiftR <= iesireMux;
        end if;
    end process;
    
    process(ALUCtrl, RD1, iesireMux)
    begin
        case ALUCtrl  is
            when "000" => iesireAlu <= RD1 + iesireMux; -- ADD
            when "001" => iesireAlu <= RD1 - iesireMux; -- SUB
            when "010" => iesireAlu <= shiftL;        -- SLL                        
            when "011" => iesireAlu <= shiftR;        -- SRL
            when "100" => iesireAlu <= RD1 and iesireMux; -- AND	
            when "101" => iesireAlu <= RD1 or iesireMux;    -- OR
            when "110" => iesireAlu <= RD1 nand iesireMux;  -- NAND
            when "111" => iesireAlu <= RD1 xor iesireMux;  	--XOR	
      end case;
      
      case iesireAlu is
            when x"0000" => Zero <= '1';
            when others => Zero <= '0';
        end case;
        
      end process; 
      
      ALURes <= iesireAlu;
      BranchAddr <= nextAddr + ExtImm; 

end Behavioral;
