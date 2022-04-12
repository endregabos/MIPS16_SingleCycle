----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2021 07:03:21 PM
-- Design Name: 
-- Module Name: test_env - Behavioral
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

entity test_env is
Port (     clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (7 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
                                               
                                                ---SEMNALE INSTRUCTION FETCH (IF)---
signal catod: std_logic_vector(6 downto 0);
signal anod: std_logic_vector(3 downto 0);
signal resetEN:std_logic;
signal enableNum:std_logic;

signal Instruction:std_logic_vector(15 downto 0);
signal PCinc:std_logic_vector(15 downto 0);
signal digits:std_logic_vector(15 downto 0);

                                                ---SEMNALE INSTRUCTION DECODE (ID)---
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal RegWrite: std_logic;
signal ALUSrc: std_logic; 
signal branch: std_logic; 
signal jump: std_logic; 
signal MemWrite: std_logic; 
signal MemToReg: std_logic; 
Signal ALUop: std_logic_vector(2 downto 0):="000";
signal func: std_logic_vector(2 downto 0):="000";
signal wd: std_logic_vector(15 downto 0):=x"0000";
signal rd1: std_logic_vector(15 downto 0):=x"0000";
signal rd2: std_logic_vector(15 downto 0):=x"0000";
signal ExtImm: std_logic_vector(15 downto 0):=x"0000";
signal sa: std_logic;

                                                ---SEMNALE UNITATE DE EXECUTIE (EX)---
signal AluRes: std_logic_vector(15 downto 0);
signal AluRes2: std_logic_vector(15 downto 0);
signal MemData: std_logic_vector(15 downto 0);
signal BranchAddress : std_logic_vector(15 downto 0);
signal zeroSemnal: std_logic;
signal PCsrc: std_logic;
signal JumpAddr: std_logic_vector(15 downto 0);                                              

                                                          ---COMPONENTE---
component MPG_lab1 is
    Port (
        clk : in STD_LOGIC;
        enable : out STD_LOGIC;
        btn : in STD_LOGIC);
end component;

component SSD is
    Port ( 
           Digit : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component InstructionFetch is
    Port( clk: in STD_LOGIC;
          rst : in STD_LOGIC; --reset asincron pt PC
          en : in STD_LOGIC; --enalble pt PC
          BranchAddress : in STD_LOGIC_VECTOR(15 downto 0);
          JumpAddress : in STD_LOGIC_VECTOR(15 downto 0);
          Jump : in STD_LOGIC;
          PCSrc : in STD_LOGIC;
          Instruction : out STD_LOGIC_VECTOR(15 downto 0);
          PCinc : out STD_LOGIC_VECTOR(15 downto 0)); --PC + 4
end component;

component InstrDecode is
  Port (   clk : in std_logic;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0); 
           RegWrite : in STD_LOGIC;
           RegDst : in STD_LOGIC;
           ExtOp : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0); 
           RD2 : out STD_LOGIC_VECTOR (15 downto 0); 
           ExtImm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC;
           writeEn : in STD_LOGIC); 
end component;

component MainControl is
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
end component;

component UnitateExecutie is
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
end component;

component MemorieDate is
    port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           intrareALURes : in STD_LOGIC_VECTOR(15 downto 0);
           RD2 : in STD_LOGIC_VECTOR(15 downto 0);
           MemWrite : in STD_LOGIC;			
           MemData : out STD_LOGIC_VECTOR(15 downto 0);
           iesireALURes : out STD_LOGIC_VECTOR(15 downto 0));
end component;

begin  
    
                     
    MPG_1: MPG_lab1 port map(clk, enableNum, btn(0));
    MPG_2: MPG_lab1 port map(clk, resetEn, btn(1));
    
    InstrFetch: InstructionFetch port map(clk, resetEn, enableNum, BranchAddress, JumpAddr, sw(0), sw(1), Instruction, PCinc);
    Instr_Decode: InstrDecode port map(clk, Instruction, wd, RegWrite, RegDst, ExtOp, rd1, rd2, ExtImm, func, sa, enableNum);
    UnitateConstrol: MainControl port map(Instruction(15 downto 13), RegDst, ExtOp, ALUSrc, branch, jump, ALUop, MemWrite, MemToReg, RegWrite);
    UnitExec: UnitateExecutie port map(rd1, ALUSrc, rd2, ExtImm, sa, func, ALUop, PCinc, AluRes, BranchAddress, zeroSemnal);
    MemoriaRAM: MemorieDate port map(clk, enableNum, AluRes, rd2, MemWrite, MemData, ALURes2); 
    
    -- Write Back (WB) (Mux-ul de langa Memoria de date)
    with MemToReg select
        wd <= MemData when '1',
              ALURes2 when '0',
              (others => '0') when others;
    
    -- Poarta SI pentru Branch 
    PCsrc <= zeroSemnal and Branch;
    
    -- Jump Address
    JumpAddr <= PCinc(15 downto 13) & Instruction(12 downto 0);
    
    process(sw(7 downto 5))
    begin
        case sw(7 downto 5) is 
            when "000" => digits <= Instruction;
            when "001" => digits <= PCinc;
            when "010" => digits <= rd1;
            when "011" => digits <= rd2;
            when "100" => digits <= ExtImm;
            when "101" => digits <= ALURes;
            when "110" => digits <= MemData;
            when "111" => digits <= wd;
            when others=> digits <= X"AAAA"; --mesaj de eroare
        end case;
    end process;
                  
    Afisare: SSD port map(digits, clk, cat, an);
    
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;
end Behavioral;
