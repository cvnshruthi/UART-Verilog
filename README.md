# UART Transmitter and Receiver in Verilog HDL

A UART (Universal Asynchronous Receiver/Transmitter) implementation in **Verilog HDL** featuring separate transmitter and receiver modules, finite state machine (FSM) based control, configurable baud-rate generation, and functional verification using **Icarus Verilog** and **GTKWave**.

![Language](https://img.shields.io/badge/Language-Verilog-blue)
![Simulator](https://img.shields.io/badge/Simulator-Icarus%20Verilog-green)
![Waveforms](https://img.shields.io/badge/Waveforms-GTKWave-orange)

## Table of Contents

- [Project Overview](#project-overview)
- [UART Frame Format](#uart-frame-format)
- [Repository Structure](#repository-structure)
- [UART Transmitter](#uart-transmitter)
- [UART Receiver](#uart-receiver)
- [Simulation](#simulation)
- [Results](#results)
- [Future Improvements](#future-improvements)
- [Author](#author)
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

## Repository Structure

```text
UART-Verilog
│
├── rtl/
│   ├── uart_tx.v
│   └── uart_rx.v
│
├── tb/
│   ├── uart_tx_tb.v
│   └── uart_rx_tb.v
│
├── images/
│   ├── tx_architecture.png
│   ├── tx_fsm.png
│   ├── rx_architecture.png
│   └── rx_fsm.png
│
├── waveforms/
│   ├── uart_tx_waveform.png
│   └── uart_rx_waveform.png
│
└── README.md
```

## UART Transmitter

The UART transmitter converts an 8-bit parallel input into a serial data stream. The transmission follows the standard UART 8-N-1 frame format by sending one start bit, eight data bits (LSB first), and one stop bit. An FSM controls the transmission process while a baud counter ensures correct timing between successive bits.

### Architecture

<p align="center">
  <img src="images/tx_architecture.png" width="700">

  ### Finite State Machine (FSM)

<p align="center">
  <img src="images/tx_fsm.png" width="550">
</p>

### Operation

The transmitter operates using four states:

- **IDLE** – Waits for the `start` signal while keeping the TX line HIGH.
- **START** – Transmits the start bit (`0`) for one baud period.
- **DATA** – Sends eight data bits serially, beginning with the least significant bit (LSB).
- **STOP** – Transmits the stop bit (`1`) and returns to the IDLE state, ready for the next transmission.

- ### Simulation Waveform

<p align="center">
  <img src="waveforms/tx20-200.png">
</p>

The waveform confirms successful transmission of the test byte (`0xAA`) using the UART 8-N-1 frame format. The FSM progresses through the IDLE, START, DATA, and STOP states while the baud counter controls the timing of each transmitted bit.
</p>
