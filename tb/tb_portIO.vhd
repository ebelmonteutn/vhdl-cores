-- SPDX-License-Identifier: MIT
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_portIO is
end tb_portIO;

architecture sim of tb_portIO is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal portRd : std_logic_vector(7 downto 0) := (others => '0');
    signal portRdReg : std_logic_vector(7 downto 0);
    signal portWrEna : std_logic := '0';
    signal portWr : std_logic_vector(7 downto 0);
    signal portWrReg : std_logic_vector(7 downto 0) := (others => '0');
begin
    clk <= not clk after 5 ns;

    dut: entity work.portIO
        generic map (DATA_BITS => 8)
        port map (
            clk => clk,
            rst => rst,
            portRd => portRd,
            portRdReg => portRdReg,
            portWrEna => portWrEna,
            portWr => portWr,
            portWrReg => portWrReg
        );

    stimulus: process
    begin
        wait until rising_edge(clk);
        rst <= '0';
        portRd <= x"3C";
        portWrReg <= x"A5";
        portWrEna <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        portWrEna <= '0';
        assert portRdReg = x"3C"
            report "portIO no registro la entrada"
            severity failure;
        assert portWr = x"A5"
            report "portIO no registro la salida"
            severity failure;

        portRd <= x"96";
        wait until rising_edge(clk);
        wait for 1 ns;
        assert portRdReg = x"96"
            report "portIO no actualizo la entrada"
            severity failure;
        assert portWr = x"A5"
            report "portIO cambio la salida sin habilitacion"
            severity failure;

        report "tb_portIO: PASS" severity note;
        std.env.stop;
        wait;
    end process;
end sim;
