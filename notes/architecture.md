# RISC-V RV32I Single-Cycle CPU Architecture

## 1. Objective

Design and implement a modular 32-bit RISC-V RV32I single-cycle processor
using Verilog.

The processor will be developed, simulated, verified, and synthesized
using Xilinx Vivado.

## 2. Processor Architecture

The CPU consists of the following major blocks:

1. Program Counter (PC)
2. PC + 4 Adder
3. Instruction Memory
4. Instruction Decoder
5. Register File
6. Immediate Generator
7. Control Unit
8. ALU
9. Data Memory
10. Branch and Jump Logic
11. Writeback Multiplexer

## 3. Basic Datapath

```text
                 ┌─────────────┐
                 │     PC      │
                 └──────┬──────┘
                        │
                        ▼
                ┌───────────────┐
                │ Instruction   │
                │    Memory     │
                └───────┬───────┘
                        │
                        ▼
                ┌───────────────┐
                │   Instruction │
                │    Decoder    │
                └───────┬───────┘
                        │
          ┌─────────────┼─────────────┐
          │             │             │
          ▼             ▼             ▼
    Register File   Immediate      Control
                    Generator        Unit
          │             │             │
          └─────────────┼─────────────┘
                        ▼
                   ┌─────────┐
                   │   ALU   │
                   └────┬────┘
                        │
                ┌───────┴────────┐
                │                │
                ▼                ▼
          Data Memory       Branch/Jump
                │                │
                └───────┬────────┘
                        ▼
                    Writeback
                        │
                        ▼
                  Register File
4. Program Counter

The PC is a 32-bit register.

For sequential execution:

PC_next = PC + 4

Branches and jumps can select a different next-PC value.

5. Register File

The processor contains 32 general-purpose 32-bit registers.

* x0 is hardwired to zero.
* Two registers can be read simultaneously.
* One register can be written per instruction.
* Register writes occur on the clock edge.

6. ALU

The ALU performs arithmetic and logical operations required by the
supported RV32I instructions.

Initial operations include:

* ADD
* SUB
* AND
* OR
* XOR
* SLT
* Shift operations

7. Memory

Instruction memory stores 32-bit instructions.

Data memory is used by load and store instructions.

8. Single-Cycle Operation

Each instruction completes its datapath operation within one clock cycle.

The basic sequence is:

Instruction Fetch
→ Decode
→ Register Read
→ Execute
→ Memory Access
→ Writeback

9. Development Strategy

Each hardware block will be:

1. Designed
2. Implemented in Verilog
3. Tested with an independent testbench
4. Behaviorally simulated
5. Verified using waveforms

After individual modules are verified, they will be integrated into the
complete CPU.

10. Implementation Flow

VS Code
→ Git
→ GitHub
→ Vivado
→ Behavioral Simulation
→ Integration
→ Synthesis
→ Implementation
→ Timing and Resource Analysis
→ FPGA Testing