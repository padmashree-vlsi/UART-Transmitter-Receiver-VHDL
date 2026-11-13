----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2026 15:58:13
-- Design Name: 
-- Module Name: uart_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is

    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';

    signal tx_start  : std_logic := '0';
    signal tx_data   : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_serial : std_logic;
    signal tx_busy   : std_logic;
    signal tx_done   : std_logic;

    signal rx_serial : std_logic;
    signal rx_data   : std_logic_vector(7 downto 0);
    signal rx_valid  : std_logic;

begin

    -- 100 MHz clock
    clk <= not clk after 500 ns;

    -- Loopback connection
    rx_serial <= tx_serial;

    DUT : entity work.uart_top
        generic map (
            CLK_FREQ  => 1000000,
            BAUD_RATE => 100000
        )
        port map (
            clk       => clk,
            reset     => reset,
            tx_start  => tx_start,
            tx_data   => tx_data,
            tx_serial => tx_serial,
            tx_busy   => tx_busy,
            tx_done   => tx_done,
            rx_serial => rx_serial,
            rx_data   => rx_data,
            rx_valid  => rx_valid
        );

    process
    begin

        -- Reset
        reset <= '1';
        wait for 25 ns;
        wait until falling_edge(clk);
        reset <= '0';

        -- Test 1: Transmit 0xA5
        tx_data <= x"A5";
        tx_start <= '1';

        wait until falling_edge(clk);
        tx_start <= '0';

        
        wait until rx_valid = '1';
        wait for 1 ns;

        assert rx_data = x"A5"
            report "UART Test 1 FAILED!"
            severity error;

        report "UART Test 1 PASSED: 0xA5"
            severity note;
       if tx_busy = '1' then
    wait until tx_busy = '0';
end if;
        
        -- Test 2: Transmit 0x3C
        wait until falling_edge(clk);
        tx_data <= x"3C";
        tx_start <= '1';

        wait until falling_edge(clk);
        tx_start <= '0';

        
        wait until rx_valid = '1';
        wait for 1 ns;

        assert rx_data = x"3C"
            report "UART Test 2 FAILED!"
            severity error;

        report "UART Test 2 PASSED: 0x3C"
            severity note;

        report "UART LOOPBACK TESTS COMPLETED!"
            severity note;

        wait;
    end process;

end Behavioral;