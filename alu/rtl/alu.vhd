----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.10.2024 19:35:26
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
    generic (DATA_BITS: integer := 16);
    port (  clk : in std_logic;
            rst : in std_logic;
            ena : in std_logic;
            code: in std_logic_vector (3 downto 0);
            op : in std_logic_vector (DATA_BITS-1 downto 0);
            acc : out std_logic_vector (DATA_BITS-1 downto 0);
            zero : out std_logic;
            overflow : out std_logic;
            carryBorrow : out std_logic;
            negative : out std_logic);
end alu;

architecture Behavioral of alu is
    signal acc_q : std_logic_vector(DATA_BITS - 1 downto 0);
    signal acc_d : std_logic_vector(DATA_BITS - 1 downto 0);
    signal carryBorrow_q : std_logic;
    signal carryBorrow_d : std_logic;
    signal overflow_q : std_logic;
    signal overflow_d : std_logic;
    signal negative_q : std_logic;
    signal negative_d : std_logic;
    signal zero_q : std_logic;
    signal zero_d : std_logic;
    signal sat_q : std_logic;
    signal sat_d : std_logic;
    signal temp_res : std_logic_vector(DATA_BITS downto 0); 
    signal min_val: std_logic_vector(DATA_BITS-1 downto 0);
    signal max_val: std_logic_vector(DATA_BITS-1 downto 0);
    signal sum : std_logic_vector (DATA_BITS downto 0);
    signal res : std_logic_vector (DATA_BITS downto 0);
    constant cero : std_logic_vector(DATA_BITS-1 downto 0) := (others => '0');
    signal rot_entrada : std_logic_vector(16 downto 0); 
    signal rot_salida : std_logic_vector(16 downto 0);

begin
    U1: entity work.rot 
        port map (  entrada => rot_entrada, 
                    desplazamiento => op, 
                    salida => rot_salida);

    rot_entrada <= carryBorrow_q & acc_q;

    process (clk, rst)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                acc_q <= (others => '0');
                carryBorrow_q <= '0';
                overflow_q <= '0';
                negative_q <= '0';
                zero_q <= '0';
                sat_q <= '0';
            elsif ena = '1' then
                acc_q <= acc_d;
                carryBorrow_q <= carryBorrow_d;
                overflow_q <= overflow_d;
                negative_q <= negative_d;
                zero_q <= zero_d;
                sat_q <= sat_d;
            end if;
        end if;
    end process;

    min_val <= x"8000";
    max_val <= x"7FFF";
    sum <= std_logic_vector(signed(('0' & acc_q)) + signed(('0' & op)) + signed((cero & carryBorrow_q)));
    res <= std_logic_vector(signed(('0' & acc_q)) - signed(('0' & op)) - signed((cero & carryBorrow_q)));
    
    acc_d <=    (acc_q and op) when(code = "0000") else --0 and
                (acc_q or op)  when(code = "0001") else --1 or
                (acc_q xor op) when(code = "0010") else --2 xor
                (max_val) when(code = "0011" and (signed(sum(DATA_BITS-1 downto 0)) < 0 and signed(acc_q) > 0 and signed(op) > 0) and sat_q = '1') else   --3 suma con saturacion positiva
                (min_val) when(code = "0011" and (signed(sum(DATA_BITS-1 downto 0)) > 0 and signed(acc_q) < 0 and signed(op) < 0) and sat_q = '1') else   --3 suma con saturacion negativa
                (sum(DATA_BITS-1 downto 0)) when(code = "0011") else --3 suma
                (max_val) when(code = "0100" and (signed(res(DATA_BITS-1 downto 0)) < 0 and signed(acc_q) > 0 and signed(op) < 0) and sat_q = '1') else   --4 resta con saturacion positiva
                (min_val) when(code = "0100" and (signed(res(DATA_BITS-1 downto 0)) > 0 and signed(acc_q) < 0 and signed(op) > 0) and sat_q = '1') else   --4 resta con saturacion negativa
                (res(DATA_BITS-1 downto 0)) when(code = "0100") else --4 resta
                (rot_salida(DATA_BITS-1 downto 0)) when(code = "0101") else --5 rotador
                (op)  when(code = "0110") else          --6 acc = op
                (acc_q) when(code = "0111") else        --7 carry=op
                (acc_q) when(code = "1000") else        --8 sat = op
                (others => '0');                        
                
    carryBorrow_d <=    sum(DATA_BITS) when(code = "0011") else --3 suma
                        res(DATA_BITS) when(code = "0100") else --4 resta
                        rot_salida(DATA_BITS) when(code = "0101") else --5 rotador
                        op(0) when(code = "0111") else
                        carryBorrow_q;                 

    overflow_d <=       ('1') when(((signed(acc_d) < 0 and signed(acc_q) > 0 and signed(op) > 0) or (signed(acc_d) > 0 and signed(acc_q) < 0 and signed(op) < 0)) and code = "0011") else --3 suma
                        ('1') when(((signed(acc_d) > 0 and signed(acc_q) < 0 and signed(op) > 0) or (signed(acc_d) < 0 and signed(acc_q) > 0 and signed(op) < 0)) and code = "0100") else --4 resta
                        overflow_q; 
                
    negative_d <=       ('1') when(signed(acc_d) < 0) else 
                        '0';
                
    zero_d <=           ('1') when(signed(acc_d) = 0) else 
                        '0';
  
    sat_d <=            op(0) when(code = "1000") else
                        sat_q;                                             


    acc <= acc_q;
    carryBorrow <= carryBorrow_q;
    overflow <= overflow_q;
    zero <= zero_q;
    negative <= negative_q;

end Behavioral;

