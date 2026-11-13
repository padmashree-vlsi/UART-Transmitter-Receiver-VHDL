\# UART Transmitter and Receiver using VHDL



\## Project Overview



This project implements a UART (Universal Asynchronous Receiver/Transmitter) communication system using VHDL.



It includes:

\- UART Transmitter (TX)

\- UART Receiver (RX)

\- Top-level module connecting TX and RX

\- Testbench for UART loopback verification



The transmitted serial data is connected directly to the receiver, allowing verification of the complete UART communication system.



\## Hardware and Tools



\- \*\*HDL:\*\* VHDL

\- \*\*FPGA:\*\* Artix-7 (`xc7a35tcpg236-1`)

\- \*\*Development Tool:\*\* AMD Vivado 2024.1

\- \*\*Simulation:\*\* Vivado XSim

\- \*\*Clock Frequency (hardware defaults):\*\* 100 MHz

\- \*\*Baud Rate (hardware defaults):\*\* 9600 baud

\- \*\*Data Format:\*\* 8-bit UART, LSB first



\## Project Structure



```text

UART-Transmitter-Receiver-VHDL/

├── rtl/

│   ├── uart\_tx.vhd

│   ├── uart\_rx.vhd

│   └── uart\_top.vhd

├── testbench/

│   └── uart\_tb.vhd

├── constraints/

│   └── uart\_constraints.xdc

├── reports/

│   ├── uart\_utilization.rpt

│   ├── uart\_timing\_summary.rpt

│   └── uart\_check\_timing.rpt

├── screenshots/

│   ├── uart\_loopback\_simulation.png

│   └── uart\_tb\_behav.wcfg

└── README.md

```



\## Module Description



\### 1. UART Transmitter (`uart\_tx.vhd`)

\- Converts 8-bit parallel data into serial data.

\- Transmits data LSB first.

\- Generates start and stop bits.

\- Provides `tx\_busy` and `tx\_done` status signals.



\### 2. UART Receiver (`uart\_rx.vhd`)

\- Receives serial UART data.

\- Detects the start bit.

\- Samples and reconstructs the 8-bit data.

\- Generates `rx\_valid` when received data is ready.



\### 3. Top Module (`uart\_top.vhd`)

\- Instantiates the UART transmitter and receiver.

\- Connects the modules through separate TX and RX serial ports.



\## Simulation and Verification



The testbench (`uart\_tb.vhd`) verifies UART loopback communication.



For faster simulation, the testbench overrides the hardware default generics:



| Parameter | Simulation | Hardware default |

|---|---:|---:|

| Clock frequency | 1 MHz | 100 MHz |

| Baud rate | 100,000 | 9,600 |



\### Test Cases



| Test | Transmitted Data | Expected Received Data | Result |

|---|---|---|---|

| Test 1 | `0xA5` | `0xA5` | PASS |

| Test 2 | `0x3C` | `0x3C` | PASS |



\### Simulation Output



```text

UART Test 1 PASSED: 0xA5

UART Test 2 PASSED: 0x3C

UART LOOPBACK TESTS COMPLETED!

```



\## Simulation Waveform



!\[UART Loopback Simulation](screenshots/uart\_loopback\_simulation.png)



\## FPGA Implementation



The design was synthesized and implemented successfully for the Artix-7 FPGA.



\### Resource Utilization



| Resource | Used | Available | Utilization |

|---|---:|---:|---:|

| Slice LUTs | 60 | 20,800 | 0.29% |

| Slice Registers | 57 | 41,600 | 0.14% |

| Slices | 34 | 8,150 | 0.42% |

| Bonded IOB | 24 | 106 | 22.64% |

| BUFGCTRL | 1 | 32 | 3.13% |



\### Timing Summary



| Timing Parameter | Result |

|---|---:|

| Clock Period | 10 ns |

| Clock Frequency | 100 MHz |

| WNS | +5.880 ns |

| TNS | 0 ns |

| WHS | +0.214 ns |

| THS | 0 ns |

| WPWS | +4.500 ns |



\*\*Timing note:\*\* The clock is constrained to 100 MHz. External input and output delays have not been specified, so the timing results do not represent a fully constrained external interface.



Detailed reports are available in the `reports/` folder.



\## Constraints



The XDC file defines the 100 MHz clock:



```tcl

create\_clock -period 10.000 -name clk \[get\_ports clk]

```



\## Learning Outcomes



\- UART serial communication protocol

\- VHDL FSM-based design

\- Transmitter and receiver architecture

\- Parallel-to-serial and serial-to-parallel conversion

\- Testbench development and loopback verification

\- FPGA synthesis, implementation, and timing analysis



\## Author



Padma Shree Kondrahalli Byra Reddy



\## License



This project is available for educational and learning purposes.

