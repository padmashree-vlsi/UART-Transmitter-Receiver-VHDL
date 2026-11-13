----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2026 15:57:31
-- Design Name: 
-- Module Name: uart_top - Behavioral
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

entity uart_top is
    generic (
        CLK_FREQ  : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;

        -- Transmitter interface
        tx_start  : in  std_logic;
        tx_data   : in  std_logic_vector(7 downto 0);
        tx_serial : out std_logic;
        tx_busy   : out std_logic;
        tx_done   : out std_logic;

        -- Receiver interface
        rx_serial : in  std_logic;
        rx_data   : out std_logic_vector(7 downto 0);
        rx_valid  : out std_logic
    );
end uart_top;

architecture Structural of uart_top is

begin

    UART_TX_INST : entity work.uart_tx
        generic map (
            CLK_FREQ  => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map (
            clk       => clk,
            reset     => reset,
            tx_start  => tx_start,
            tx_data   => tx_data,
            tx_serial => tx_serial,
            tx_busy   => tx_busy,
            tx_done   => tx_done
        );

    UART_RX_INST : entity work.uart_rx
        generic map (
            CLK_FREQ  => CLK_FREQ,
            BAUD_RATE => BAUD_RATE
        )
        port map (
            clk       => clk,
            reset     => reset,
            rx_serial => rx_serial,
            rx_data   => rx_data,
            rx_valid  => rx_valid
        );

end Structural;
