----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2026 15:55:03
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
    generic (
        CLK_FREQ  : integer := 100000000;
        BAUD_RATE : integer := 9600
    );
    Port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        tx_start  : in  std_logic;
        tx_data   : in  std_logic_vector(7 downto 0);
        tx_serial : out std_logic;
        tx_busy   : out std_logic;
        tx_done   : out std_logic
    );
end uart_tx;

architecture Behavioral of uart_tx is

    constant CLKS_PER_BIT : integer := CLK_FREQ / BAUD_RATE;

    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    signal clk_count : integer range 0 to CLKS_PER_BIT - 1 := 0;
    signal bit_index : integer range 0 to 7 := 0;

    signal data_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal serial_reg : std_logic := '1';
    signal done_reg   : std_logic := '0';

begin

    tx_serial <= serial_reg;
    tx_busy   <= '0' when state = IDLE else '1';
    tx_done   <= done_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            state      <= IDLE;
            clk_count  <= 0;
            bit_index  <= 0;
            data_reg   <= (others => '0');
            serial_reg <= '1';
            done_reg   <= '0';

        elsif rising_edge(clk) then

            done_reg <= '0';

            case state is

                when IDLE =>
                    serial_reg <= '1';
                    clk_count <= 0;
                    bit_index <= 0;

                    if tx_start = '1' then
                        data_reg <= tx_data;
                        state <= START_BIT;
                    end if;

                when START_BIT =>
                    serial_reg <= '0';

                    if clk_count = CLKS_PER_BIT - 1 then
                        clk_count <= 0;
                        bit_index <= 0;
                        serial_reg <= data_reg(0);
                        state <= DATA_BITS;
                    else
                        clk_count <= clk_count + 1;
                    end if;

                when DATA_BITS =>

                    if clk_count = CLKS_PER_BIT - 1 then
                        clk_count <= 0;

                        if bit_index = 7 then
                            serial_reg <= '1';
                            state <= STOP_BIT;
                        else
                            bit_index <= bit_index + 1;
                            serial_reg <= data_reg(bit_index + 1);
                        end if;

                    else
                        clk_count <= clk_count + 1;
                    end if;

                when STOP_BIT =>
                    serial_reg <= '1';

                    if clk_count = CLKS_PER_BIT - 1 then
                        clk_count <= 0;
                        done_reg <= '1';
                        state <= IDLE;
                    else
                        clk_count <= clk_count + 1;
                    end if;

            end case;
        end if;
    end process;

end Behavioral;