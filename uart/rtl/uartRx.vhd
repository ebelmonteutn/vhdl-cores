-- SPDX-License-Identifier: MIT
----------------------------------------------------------------------------------
-- Company: Universidad Tecnológica Nacional - Facultad Regional Buenos Aires
-- Engineer: Enzo Belmonte
-- 
-- Create Date: 21.10.2024 21:04:12
-- Design Name: 
-- Module Name: uartRx - Behavioral
-- Project Name: UART
-- Target Devices: 
-- Tool Versions: 
-- Description:  Receptor UART
-- 
-- Dependencies: 
-- 
-- Revision: 1.0.21.10.2024.1
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

entity uartRx is
Generic (baudRate : integer := 20000000;
         sysClk : integer := 100000000;
         dataSize : integer := 8);
Port (  clk : in std_logic;
        rst : in std_logic;
        dataRd : out std_logic;
        dataRx : out std_logic_vector (dataSize - 1 downto 0);
        rx : in std_logic);
end uartRx;

architecture Behavioral of uartRx is
	component myCnt2 is
        Generic (N : integer := 4);
        Port (
            clk : in std_logic;
            rst : in std_logic;
            ena : in std_logic;
            p : in std_logic_vector (N - 1 downto 0);
            salida : out std_logic
        );
    end component;

	signal tc_br : std_logic;
	signal ena_cnt : std_logic;
	constant divisor : integer := sysClk / baudRate;
    constant CS : std_logic_vector(32 - 1 downto 0) := std_logic_vector(to_unsigned(divisor, 32));

    type state_type is (stIdle, stStart, st0, st1, st2, st3, st4, st5, st6, st7, stEOF, stStop);
    signal state, next_state : state_type;
	signal dataRx_q : std_logic_vector (dataSize - 1 downto 0);
	signal dataRx_d : std_logic_vector (dataSize - 1 downto 0);
	signal dataRd_flag : std_logic;
    begin
		U1: myCnt2
        Generic map (
            N => 32
        )
        Port map (
            clk => clk,
            rst => rst,
            ena => ena_cnt, 
            p => CS, 
            salida => tc_br
        );

    	

        estadoProc: process (clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    state <= stIdle;
                    dataRx <= (others=>'0');
                else
                    state <= next_state;
					if dataRd_flag = '1' then
						dataRx <= dataRx_d;
					end if;
					dataRx_q <= dataRx_d;
                end if;
            end if;
        end process;
    
        logicaSalida: process (state)
        begin
            ena_cnt <= '0';
            dataRd_flag <= '0';
            dataRx_d <= (others=>'0');
            case state is
                when stIdle =>
					ena_cnt <= '0';
                    dataRd_flag <= '0';
                when stStart =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
                when st0 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(0) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);				
                when st1 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(1) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when st2 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(2) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when st3 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(3) <= rx;
                    dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when st4 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(4) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when st5 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(5) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when st6 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(6) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when st7 =>
					ena_cnt <= '1';
                    dataRd_flag <= '0';
--					dataRx_q(7) <= rx;
					dataRx_d <= rx & dataRx_q(dataSize - 1 downto 1);
                when stStop =>
					ena_cnt <= '1';
					dataRx_d <= dataRx_q;
                    dataRd_flag <= '0';
                when stEOF =>
					ena_cnt <= '0';
					dataRx_d <= dataRx_q;
                    dataRd_flag <= '1';              
                when others =>
					ena_cnt <= '0';
					dataRd_flag <= '0';
            end case;
        end process;
    
        logicaEstadoFuturo: process (state, rx, tc_br)
        begin
            case state is
                when stIdle =>
					if rx = '0' then
						next_state <= stStart;
					else
						next_state <= stIdle;
					end if;
				when stStart =>
					if tc_br = '1' then
						next_state <= st0;
					else
						next_state <= stStart;
					end if;
				when st0 =>
					if tc_br = '1' then
						next_state <= st1;
					else
						next_state <= st0;
					end if;
				when st1 =>
					if tc_br = '1' then
						next_state <= st2;
					else
						next_state <= st1;
					end if;
				when st2 =>
					if tc_br = '1' then
						next_state <= st3;
					else
						next_state <= st2;
					end if;
				when st3 =>
					if tc_br = '1' then
						next_state <= st4;
					else
						next_state <= st3;
					end if;
				when st4 =>
					if tc_br = '1' then
						next_state <= st5;
					else
						next_state <= st4;
					end if;
				when st5 =>
					if tc_br = '1' then
						next_state <= st6;
					else
						next_state <= st5;
					end if;
				when st6 =>
					if tc_br = '1' then
						next_state <= st7;
					else
						next_state <= st6;
					end if;
				when st7 =>
					if tc_br = '1' then
						next_state <= stStop;
					else
						next_state <= st7;
					end if;				
				when stStop =>
					if tc_br = '1' then
						next_state <= stEOF;
					else
						next_state <= stStop;
					end if;
				when stEOF =>
					next_state <= stIdle;
				when others =>
					next_state <= stIdle;               
            end case;
        end process; 

	dataRd <= dataRd_flag;
    end Behavioral;
