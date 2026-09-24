-- SPDX-License-Identifier: MIT
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_myCnt2 is
end tb_myCnt2;

architecture sim of tb_myCnt2 is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ena : std_logic := '0';
    signal p : std_logic_vector(3 downto 0) := "0011";
    signal salida : std_logic;
begin
    clk <= not clk after 5 ns;

    dut: entity work.myCnt2
        generic map (N => 4)
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            p => p,
            salida => salida
        );

    stimulus: process
    begin
        wait until rising_edge(clk);
        rst <= '0';
        ena <= '1';

        for i in 1 to 3 loop
            wait until rising_edge(clk);
            wait for 1 ns;
            assert salida = '0'
                report "myCnt2 genero un pulso antes del conteo programado"
                severity failure;
        end loop;

        wait until rising_edge(clk);
        wait for 1 ns;
        assert salida = '1'
            report "myCnt2 no genero el pulso de terminal count"
            severity failure;

        wait until rising_edge(clk);
        wait for 1 ns;
        assert salida = '0'
            report "myCnt2 mantuvo el pulso mas de un ciclo"
            severity failure;

        report "tb_myCnt2: PASS" severity note;
        std.env.stop;
        wait;
    end process;
end sim;
