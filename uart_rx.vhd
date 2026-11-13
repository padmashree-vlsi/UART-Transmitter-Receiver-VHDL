----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2026 15:56:42
-- Design Name: 
-- Module Name: uart_rx - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_rx is
    generic (
        CLK_FREQ  : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        rx_serial : in  std_logic;
        rx_data   : out std_logic_vector(7 downto 0);
        rx_valid  : out std_logic
    );
end uart_rx;

architecture Behavioral of uart_rx is

    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;

    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    signal clk_count : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_index : integer range 0 to 7 := 0;

    signal data_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal valid_reg : std_logic := '0';

begin

    rx_data  <= data_reg;
    rx_valid <= valid_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            clk_count <= 0;
            bit_index <= 0;
            data_reg <= (others => '0');
            valid_reg <= '0';

        elsif rising_edge(clk) then

            valid_reg <= '0';

            case state is

                when IDLE =>
                    clk_count <= 0;
                    bit_index <= 0;

                    if rx_serial = '0' then
                        state <= START_BIT;
                    end if;

                when START_BIT =>
                    if clk_count = (CLKS_PER_BIT / 2) - 1 then
                        clk_count <= 0;

                        if rx_serial = '0' then
                            state <= DATA_BITS;
                        else
                            state <= IDLE;
                        end if;
                    else
                        clk_count <= clk_count + 1;
                    end if;

                when DATA_BITS =>
                    if clk_count = CLKS_PER_BIT - 1 then
                        clk_count <= 0;
                        data_reg(bit_index) <= rx_serial;

                        if bit_index = 7 then
                            bit_index <= 0;
                            state <= STOP_BIT;
                        else
                            bit_index <= bit_index + 1;
                        end if;
                    else
                        clk_count <= clk_count + 1;
                    end if;

                when STOP_BIT =>
                    if clk_count = CLKS_PER_BIT - 1 then
                        clk_count <= 0;
                        state <= IDLE;
                        valid_reg <= '1';
                    else
                        clk_count <= clk_count + 1;
                    end if;

            end case;
        end if;
    end process;

end Behavioral;