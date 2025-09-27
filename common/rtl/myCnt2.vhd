----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.08.2024 19:18:55
-- Design Name: 
-- Module Name: myCnt2 - Behavioral
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

entity myCnt2 is
Generic (N : integer := 4);
Port ( clk : in std_logic;
rst : in std_logic;
ena : in std_logic;
p : in std_logic_vector (N - 1 downto 0);
salida : out std_logic);
end myCnt2;


architecture Behavioral of myCnt2 is
signal cnt_S : unsigned (N - 1 downto 0);
begin

process (clk)
begin
    if (rising_edge (clk)) then
        if (rst = '1') then
            salida <= '0';
            cnt_S <= (others => '0');
        elsif (cnt_S = unsigned(p) and ena = '1') then
            salida <= '1';
            cnt_S <= (others => '0');
        elsif (ena = '1') then
            salida <= '0';
            cnt_S <= cnt_S + 1;
        end if;
    end if;
end process;
end Behavioral;
