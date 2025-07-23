# UART-SystemVerilog-Testbench

This repository contains a SystemVerilog testbench for verifying a UART (Universal Asynchronous Receiver-Transmitter) design. The testbench follows a modular verification methodology, using classes for transaction generation, driving, monitoring, and scoreboarding, orchestrated by an environment class.

## Overview

The testbench is designed to verify a UART module (`uart_top`) with a clock frequency of 1 MHz and a baud rate of 9600. It includes:
- **Transaction Class**: Defines the data structure for UART transactions (read/write operations, data, and control signals).
- **Generator Class**: Generates randomized transactions for testing.
- **Driver Class**: Drives transactions to the DUT (Design Under Test) via a virtual interface.
- **Monitor Class**: Observes DUT outputs (TX and RX data) and sends them to the scoreboard.
- **Scoreboard Class**: Compares driver and monitor data to verify correctness.
- **Environment Class**: Coordinates all components and manages test execution.
- **Testbench Module**: Top-level module that instantiates the DUT and environment, with clock generation and waveform dumping
