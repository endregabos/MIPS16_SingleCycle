----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 07:21:15 PM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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

entity InstructionFetch is
    Port( clk: in STD_LOGIC;
          rst : in STD_LOGIC; --reset asincron pt PC
          en : in STD_LOGIC; --enalble pt PC
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0)); --PC + 2
end InstructionFetch;

architecture Behavioral of InstructionFetch is

type typeROM is array (0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal memorieROM : typeROM := (

    B"000_000_000_001_0_000",     -- X"0010" -- ADD $1, $0, $0
    B"001_000_100_0001010",       -- X"220A" -- ADDI $4, $0, 10
    B"000_000_000_010_0_001",     -- X"0021" -- ADD $2, $0, $0
    B"000_000_000_101_0_010",     -- X"0052" -- ADD $5, $0, $0
    B"100_001_100_0000111",       -- X"8607" -- begin_loop: BEQ $1, $4, end_loop
    B"010_010_011_0010100",       -- X"4994" -- LW $3, A_addr($2)
    B"001_011_011_0000100",       -- X"2D48" -- ADDI $3, $3, 4
    B"011_010_011_0010100",       -- X"6994" -- SW $3, A_addr($2)
    B"000_101_011_101_0_011",     -- X"15D3" -- ADD $5, $5, $3
    B"001_010_010_0000001",       -- X"2901" -- ADDI $2, $2, 1
    B"001_001_001_0000001",       -- X"2481" -- ADDI $1, $1, 1
    B"111_0000000000100",         -- X"E002" -- J begin_loop
    B"001_101_101_111_1011",      -- X"36FB" -- end_loop: ADDI $5, $5, -5
    B"011_000_101_010_1000",      -- X"62A8" -- SW $5, sum_addr($0)    
    others => X"0000"
);

signal PC : STD_LOGIC_VECTOR(15 downto 0) := (others => '0'); --iesirea din Program Counter
signal PCAux, NextAddr, AuxSignal: STD_LOGIC_VECTOR(15 downto 0); --semnale intermediare pt IF
--explicatie semnale: 
--PCAux - intrare in MUX Branch (iesirea din ALU)
--NextAddr - intrarea in PC (iesirea de la MUX Jump)
--AuxSignal - legatura intre MUX-uri

begin
    --proces PC
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                PC <= (others => '0');
            elsif en = '1' then
                PC <= NextAddr;
            end if;
        end if;
    end process;

    -- MUX pt Branch
    process(PCSrc, PCAux, BranchAddress)
    begin
        case PCSrc is 
            when '1' => AuxSignal <= BranchAddress;
            when others => AuxSignal <= PCAux;
        end case;
    end process;	

     -- MUX pt Jump
    process(Jump, AuxSignal, JumpAddress)
    begin
        case Jump is
            when '1' => NextAddr <= JumpAddress;
            when others => NextAddr <= AuxSignal;
        end case;
    end process;
    
    Instruction <= memorieROM(conv_integer(PC(7 downto 0)));
    PCAux <= PC + 1;
    PCinc <= PCAux;

end Behavioral;
