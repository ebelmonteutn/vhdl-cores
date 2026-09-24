-- SPDX-License-Identifier: MIT
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_myCntBinarioPl is
end tb_myCntBinarioPl;

architecture sim of tb_myCntBinarioPl is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal ena : std_logic := '0';
    signal dl : std_logic := '0';
    signal d : std_logic_vector(9 downto 0) := (others => '0');
    signal q : std_logic_vector(9 downto 0);
begin
    clk <= not clk after 5 ns;

    dut: entity work.myCntBinarioPl
        port map (
            clk => clk,
            rst => rst,
            ena => ena,
            dl => dl,
            d => d,
            q => q
        );

    stimulus: process
    begin
        wait until rising_edge(clk);
        rst <= '0';
        d <= std_logic_vector(to_unsigned(5, d'length));
        dl <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        dl <= '0';
        assert q = std_logic_vector(to_unsigned(5, q'length))
            report "myCntBinarioPl no cargo el valor paralelo"
            severity failure;

        ena <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert q = std_logic_vector(to_unsigned(6, q'length))
            report "myCntBinarioPl no incremento el contador"
            severity failure;

        wait until rising_edge(clk);
        wait for 1 ns;
        assert q = std_logic_vector(to_unsigned(7, q'length))
            report "myCntBinarioPl no mantuvo el incremento"
            severity failure;

        report "tb_myCntBinarioPl: PASS" severity note;
        std.env.stop;
        wait;
    end process;
end sim;
