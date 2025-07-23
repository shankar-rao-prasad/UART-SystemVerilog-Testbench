# UART-SystemVerilog-Design and Testbench

This repository contains a SystemVerilog implementation of a UART (Universal Asynchronous Receiver-Transmitter) module, designed to facilitate serial communication at a configurable clock frequency and baud rate. The UART module supports both transmission (TX) and reception (RX) of 8-bit data with no parity and one stop bit, operating at a default clock frequency of 1 MHz and a baud rate of 9600.

## Overview of Testbench

The testbench is designed to verify a UART module (`uart_top`) with a clock frequency of 1 MHz and a baud rate of 9600. It includes:
- **Transaction Class**: Defines the data structure for UART transactions (read/write operations, data, and control signals).
- **Generator Class**: Generates randomized transactions for testing.
- **Driver Class**: Drives transactions to the DUT (Design Under Test) via a virtual interface.
- **Monitor Class**: Observes DUT outputs (TX and RX data) and sends them to the scoreboard.
- **Scoreboard Class**: Compares driver and monitor data to verify correctness.
- **Environment Class**: Coordinates all components and manages test execution.
- **Testbench Module**: Top-level module that instantiates the DUT and environment, with clock generation and waveform dumping
