`timescale 1ns / 1ps

module immediate_generator(input [31:0] instruction, output reg [31:0] immediate);
    // RV32I opcodes whose encodings carry an immediate.
    localparam [6:0] OPCODE_LOAD   = 7'b0000011;
    localparam [6:0] OPCODE_OP_IMM = 7'b0010011; // locolparam defines a constant inside a Verilog module.The case statement can use that name instead of repeating the binary numbe
    localparam [6:0] OPCODE_JALR   = 7'b1100111;
    localparam [6:0] OPCODE_STORE  = 7'b0100011;
    localparam [6:0] OPCODE_BRANCH = 7'b1100011;
    localparam [6:0] OPCODE_LUI    = 7'b0110111;
    localparam [6:0] OPCODE_AUIPC  = 7'b0010111;
    localparam [6:0] OPCODE_JAL    = 7'b1101111;

    always @(*) begin
        // Default to zero for instruction classes without an immediate.
        case (instruction[6:0])
            OPCODE_OP_IMM, OPCODE_LOAD, OPCODE_JALR: // I-type
                immediate = {{20{instruction[31]}}, instruction[31:20]};

            OPCODE_STORE: // S-type
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            OPCODE_BRANCH: // B-type; the encoded offset has an implicit low zero bit.
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            OPCODE_LUI, OPCODE_AUIPC: // U-type
                immediate = {instruction[31:12], 12'b0};

            OPCODE_JAL: // J-type; the encoded offset has an implicit low zero bit.
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            default: immediate = 32'b0;
        endcase
    end
endmodule
