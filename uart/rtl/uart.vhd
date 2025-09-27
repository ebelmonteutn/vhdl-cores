-- SPDX-License-Identifier: MIT
----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional Buenos Aires
-- Engineer: Enzo Belmonte
-- 
-- Create Date: 21.10.2024 21:44:12
-- Design Name: 
-- Module Name: uart - Behavioral
-- Project Name: UART
-- Target Devices: 
-- Tool Versions: 
-- Description:  UART
-- 
-- Dependencies: 
-- 
-- Revision: 1.0.21.10.2024.0
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

entity uart is
    Generic (baudRate : integer := 20000000;
            sysClk : integer := 100000000;
            dataSize : integer := 8);
    Port (  clk : in std_logic;
            rst : in std_logic;
            dataWr : in std_logic;
            dataTx : in std_logic_vector (dataSize - 1 downto 0);
            ready : out std_logic;
            tx : out std_logic;
            dataRd : out std_logic;
            dataRx : out std_logic_vector (dataSize - 1 downto 0);
            rx : in std_logic);
end uart;
    

architecture Behavioral of uart is
	signal dataRd_uartTx : std_logic;
    signal dataRx_uartRx : std_logic_vector(dataSize - 1 downto 0);
    signal ready_uartTx : std_logic;

    component uartTx is
        Generic (baudRate : integer;
                 sysClk : integer;
                 dataSize : integer);
        Port (  clk : in std_logic;
                rst : in std_logic;
                dataWr : in std_logic;
                dataTx : in std_logic_vector(dataSize - 1 downto 0);
                ready : out std_logic;
                tx : out std_logic);
    end component;

    component uartRx is
        Generic (baudRate : integer;
                 sysClk : integer;
                 dataSize : integer);
        Port (  clk : in std_logic;
                rst : in std_logic;
                dataRd : out std_logic;
                dataRx : out std_logic_vector(dataSize - 1 downto 0);
                rx : in std_logic);
    end component;

begin

    Uart_Tx: uartTx
        Generic map (
            baudRate => baudRate,
            sysClk => sysClk,
            dataSize => dataSize
        )
        Port map (
            clk => clk,
            rst => rst,
            dataWr => dataWr,
            dataTx => dataTx,
            ready => ready,
            tx => tx
        );

    Uart_Rx: uartRx
        Generic map (
            baudRate => baudRate,
            sysClk => sysClk,
            dataSize => dataSize
        )
        Port map (
            clk => clk,
            rst => rst,
            dataRd => dataRd,
            dataRx => dataRx,
            rx => rx
        );
end Behavioral;
