# UART Transmitter and Receiver in Verilog HDL

A UART (Universal Asynchronous Receiver/Transmitter) implementation in **Verilog HDL** featuring separate transmitter and receiver modules, finite state machine (FSM) based control, configurable baud-rate generation, and functional verification using **Icarus Verilog** and **GTKWave**.

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-green)
![Waveforms](https://img.shields.io/badge/Waveforms-GTKWave-orange)

## Project Overview

UART (Universal Asynchronous Receiver/Transmitter) is an asynchronous serial communication interface that enables data transfer between digital devices using separate transmit (TX) and receive (RX) lines. A UART frame consists of a start bit, 8 data bits (transmitted LSB first), and a stop bit.

This project implements both a UART transmitter and receiver in Verilog HDL. The transmitter converts 8-bit parallel data into a serial bit stream, while the receiver reconstructs the original byte by sampling the incoming serial data. Both modules are designed using finite state machines (FSMs) and verified through simulation using Icarus Verilog and GTKWave.

## UART Frame Format

The implemented UART frame follows the standard 8-N-1 format:

```
| Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop |
```

- **Start Bit:** Logic 0
- **Data Bits:** 8 bits (Least Significant Bit first)
- **Parity:** None
- **Stop Bit:** Logic 1

