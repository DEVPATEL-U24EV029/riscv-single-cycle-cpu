# RISC-V Single-Cycle CPU

A modular RISC-V RV32I single-cycle processor implemented in Verilog.

## Project Objective

Design, implement, simulate, verify, and synthesize a functional
32-bit RISC-V RV32I single-cycle processor.

## Architecture

The processor will contain:

- Program Counter (PC)
- Instruction Memory
- Instruction Decoder
- Register File
- Immediate Generator
- ALU
- Control Unit
- Data Memory
- Branch and Jump Logic
- Writeback Logic

## Development Flow

VS Code → GitHub → Vivado → Simulation → Synthesis → FPGA

## Repository Structure

```text
rtl/        - Synthesizable RTL modules
testbench/  - Simulation testbenches
programs/   - Test programs and instruction memory data
notes/      - Project documentation