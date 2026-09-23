-- SPDX-License-Identifier: MIT
----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional Buenos Aires
-- Engineer: Enzo Belmonte
-- 
-- Create Date: 25.08.2024 18:53:52
-- Design Name: Parallel-load binary counter
-- Module Name: myCntBinarioPl - Behavioral
-- Project Name: VHDL Cores
-- Target Devices: Not specified
-- Tool Versions: Not specified
-- Description: Binary counter with enable and parallel load.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164, IEEE.NUMERIC_STD
-- 
-- Revision: 0.01 - File Created
-- Additional Comments: None.
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

entity myCntBinarioPl is
Generic (N: integer := 16);
Port ( clk : in std_logic;
rst : in std_logic;
ena : in std_logic;
dl : in std_logic;
d : in std_logic_vector (9 downto 0);
q : out std_logic_vector (9 downto 0));
end myCntBinarioPl;


architecture Behavioral of myCntBinarioPl is
signal cnt_S : unsigned (9 downto 0);
begin

process (clk)
begin
    if (rising_edge (clk)) then
        if (rst = '1') then
            cnt_S <= (others => '0');
        elsif (dl = '1') then
            cnt_S <= unsigned(d);
        elsif (ena = '1') then
            cnt_S <= cnt_S + 1;
        end if;
    end if;
end process;
q <= std_logic_vector (cnt_s);
end Behavioral;
