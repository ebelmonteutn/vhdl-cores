-- SPDX-License-Identifier: MIT
----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional Buenos Aires
-- Engineer: Enzo Belmonte
-- 
-- Create Date: 21.10.2024 19:04:58
-- Design Name: UART testbench
-- Module Name: uart_tb - Behavioral
-- Project Name: VHDL Cores
-- Target Devices: Not specified
-- Tool Versions: Not specified
-- Description: UART transmission and reception stimulus testbench.
-- 
-- Dependencies: uart
-- 
-- Revision: 0.01 - File Created
-- Additional Comments: Based on the UART testbench from TPs-TD1.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is
    constant clk_period : time := 10 ns;  
    constant baudRate : integer := 9600;
    constant sysClk : integer := 100000000;
    constant DATA_SIZE : integer := 8;
    constant bit_period : time := 1 sec / baudRate;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal dataWr : std_logic := '0';
    signal dataTx : std_logic_vector(DATA_SIZE - 1 downto 0) := (others => '0');
    signal ready : std_logic;
    signal tx : std_logic;
    signal dataRd : std_logic;
    signal dataRx : std_logic_vector(DATA_SIZE - 1 downto 0) := (others => '0');
    signal rx : std_logic := '1';
begin
    uut: entity work.uart
        generic map (
            baudRate => baudRate,
            sysClk => sysClk,
            dataSize => DATA_SIZE
        )
        port map (
            clk => clk,
            rst => rst,
            dataWr => dataWr,
            dataTx => dataTx,
            ready => ready,
            tx => tx,
            dataRd => dataRd,
            dataRx => dataRx,
            rx => rx
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimulus_process: process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        dataTx <= "01010101";
        dataWr <= '1';
        wait for clk_period;
        dataWr <= '0';

        wait until ready = '1';

        wait for 100 us;
        wait for clk_period;

        rx <= '0';
        wait for bit_period;
        rx <= '1';
        wait for bit_period;
        rx <= '0';
        wait for bit_period;
        rx <= '1';
        wait for bit_period;
        rx <= '0';
        wait for bit_period;
        rx <= '0';
        wait for bit_period;
        rx <= '1';
        wait for bit_period;
        rx <= '0';
        wait for bit_period;
        rx <= '1';
        wait for bit_period;
        rx <= '1';
        wait for bit_period;
        wait for 100 us;

        wait;
    end process;
end Behavioral;
