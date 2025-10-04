----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.10.2024 23:30:45
-- Design Name: 
-- Module Name: pc - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc is
    Generic ( DATA_BITS : integer := 16);
    Port ( clk : in std_logic; -- Clock
    rst : in std_logic; -- Reset sincronico
    ena : in std_logic; -- Enable, cuando está habilitado incrementa el addr en 1
    pl : in std_logic; -- Habilita la carga paralela del addrPl
    plAddr : in std_logic_vector (DATA_BITS - 1 downto 0); -- Direccion a cargar
    data: out std_logic_vector (31 downto 0) -- Dato leido de la memoria
    );
end pc;

architecture Behavioral of pc is

    component myCntBinarioPl is
      Generic (N: integer := 16);
      Port ( clk : in std_logic;
             rst : in std_logic;
             ena : in std_logic;
             dl : in std_logic;
             d : in std_logic_vector (9 downto 0);
             q : out std_logic_vector (9 downto 0));
    end component;
  
    signal cnt_q : std_logic_vector(9 downto 0); 

    component pcMem is
        Port (
            clka : in STD_LOGIC;
            addra : in STD_LOGIC_VECTOR(9 DOWNTO 0);
            douta : out STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;

  begin
    cnt_inst : myCntBinarioPl
      generic map (N => 16)  
      port map (
        clk => clk,
        rst => rst,
        ena => ena,
        dl => pl,
        d => plAddr(9 downto 0),  
        q => cnt_q    
      );

    uut: pcMem
        Port map (
            clka => clk,          
            addra => cnt_q,         
            douta => data     
        );

  end Behavioral;
