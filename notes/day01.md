# Day 1 — RISC-V Single-Cycle CPU Architecture

## Project Goal

Build a modular RISC-V RV32I single-cycle processor using Verilog.

The processor will first be simulated in Vivado and later, if possible,
tested on an FPGA.

---

## Development Environment

- HDL: Verilog
- EDA Tool: Xilinx Vivado
- Simulator: Vivado Simulator
- Version Control: Git + GitHub

---

## Processor Specification

| Parameter | Value |
|---|---|
| Architecture | RISC-V |
| Base ISA | RV32I subset |
| Data Width | 32-bit |
| Register Count | 32 |
| Register Width | 32-bit |
| PC Width | 32-bit |
| Instruction Width | 32-bit |
| Architecture | Single-cycle |
| HDL | Verilog |

---

# Instruction Set

We will initially implement 13 instructions.

## R-Type

- ADD
- SUB
- AND
- OR
- XOR
- SLT

## I-Type

- ADDI
- ANDI
- ORI
- XORI

## Memory

- LW
- SW

## Branch

- BEQ

---

# Instruction Formats

The processor initially requires four instruction formats:

- R-Type
- I-Type
- S-Type
- B-Type

---

# Hardware Blocks

The complete processor will eventually contain:

1. Program Counter (PC)
2. Instruction Memory
3. Instruction Decoder
4. Register File
5. Immediate Generator
6. ALU
7. ALU Control
8. Main Control Unit
9. Data Memory
10. ALU Input MUX
11. Write-Back MUX
12. Next-PC MUX

---

# Main Control Signals

- RegWrite
- ALUSrc
- MemRead
- MemWrite
- MemToReg
- Branch

---

# Important Concepts

## Program Counter

The PC stores the address of the current instruction.

During normal sequential execution:

PC_next = PC + 4

---

## Register File

RISC-V RV32 contains 32 general-purpose registers.

Each register is 32 bits wide.

The register x0 is permanently zero.

---

## Single-Cycle Architecture

Each instruction completes in one clock cycle.

The basic flow is:

Instruction Fetch
→ Instruction Decode
→ Register Read
→ Execute
→ Memory Access
→ Write Back

All of these operations occur within one clock cycle.

---

# Control Signal Table

| Instruction | RegWrite | ALUSrc | MemRead | MemWrite | MemToReg | Branch |
|---|---:|---:|---:|---:|---:|---:|
| ADD | 1 | 0 | 0 | 0 | 0 | 0 |
| SUB | 1 | 0 | 0 | 0 | 0 | 0 |
| AND | 1 | 0 | 0 | 0 | 0 | 0 |
| OR | 1 | 0 | 0 | 0 | 0 | 0 |
| XOR | 1 | 0 | 0 | 0 | 0 | 0 |
| SLT | 1 | 0 | 0 | 0 | 0 | 0 |
| ADDI | 1 | 1 | 0 | 0 | 0 | 0 |
| ANDI | 1 | 1 | 0 | 0 | 0 | 0 |
| ORI | 1 | 1 | 0 | 0 | 0 | 0 |
| XORI | 1 | 1 | 0 | 0 | 0 | 0 |
| LW | 1 | 1 | 1 | 0 | 1 | 0 |
| SW | 0 | 1 | 0 | 1 | X | 0 |
| BEQ | 0 | 0 | 0 | 0 | X | 1 |

X = Don't Care

---

# Basic Datapath

The eventual datapath will be:

PC
→ Instruction Memory
→ Instruction Decode
→ Register File
→ ALU
→ Data Memory
→ Write Back
→ Register File

The PC selection logic will choose between:

PC + 4

and

PC + Branch Offset

---

# Example Instructions

## ADD

```asm
add x5, x6, x7
Operation:

if x1 == x2:
PC = PC + branch_offset
else:
PC = PC + 4

⸻

Day 1 Understanding

Write my own understanding here after studying.

⸻

Doubts

Write questions and doubts here.

⸻

Important Things to Remember

* RV32 means 32-bit registers.
* There are 32 registers.
* x0 is always zero.
* Instructions are 32 bits.
* Normal PC increment is 4 bytes.
* R-Type uses two source registers and one destination register.
* I-Type uses an immediate.
* S-Type is used for stores.
* B-Type is used for branches.
* Single-cycle means one instruction completes in one clock cycle.