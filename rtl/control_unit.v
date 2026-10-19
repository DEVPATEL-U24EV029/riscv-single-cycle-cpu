`timescale 1ns / 1ps

module control_unit (
    input  [6:0] opcode,
    input  [2:0] func3,
    input  [6:0] func7,

    output reg       reg_write,
    output reg       alu_src,
    output reg       mem_read,
    output reg       mem_write,
    output reg       mem_to_reg,
    output reg       branch,
    output reg       jump,
    output reg       jalr,

    output reg [3:0] alu_control,
    output reg [2:0] branch_type
);

    // ALU operation codes (must match alu.v)
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;
    localparam ALU_SRA = 4'b1000;

    always @(*) begin

        // Safe default values
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_to_reg  = 1'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        jalr        = 1'b0;

        alu_control = ALU_ADD;
        branch_type = 3'b000;

        case (opcode)

            // R-type: ADD, SUB, AND, OR, XOR, SLT, SLL, SRL, SRA
            7'b0110011: begin
                case (func3)

                    3'b000: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_ADD;
                        end
                        else if (func7 == 7'b0100000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SUB;
                        end
                    end

                    3'b111: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_AND;
                        end
                    end

                    3'b110: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_OR;
                        end
                    end

                    3'b100: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_XOR;
                        end
                    end

                    3'b010: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SLT;
                        end
                    end

                    3'b001: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SLL;
                        end
                    end

                    3'b101: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SRL;
                        end
                        else if (func7 == 7'b0100000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SRA;
                        end
                    end

                    default: begin
                        reg_write = 1'b0;
                    end

                endcase
            end

            // I-type arithmetic: ADDI, ANDI, ORI, XORI, SLTI, shifts
            7'b0010011: begin
                alu_src = 1'b1;

                case (func3)

                    3'b000: begin
                        reg_write   = 1'b1;
                        alu_control = ALU_ADD;
                    end

                    3'b111: begin
                        reg_write   = 1'b1;
                        alu_control = ALU_AND;
                    end

                    3'b110: begin
                        reg_write   = 1'b1;
                        alu_control = ALU_OR;
                    end

                    3'b100: begin
                        reg_write   = 1'b1;
                        alu_control = ALU_XOR;
                    end

                    3'b010: begin
                        reg_write   = 1'b1;
                        alu_control = ALU_SLT;
                    end

                    3'b001: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SLL;
                        end
                        else begin
                            alu_src = 1'b0;
                        end
                    end

                    3'b101: begin
                        if (func7 == 7'b0000000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SRL;
                        end
                        else if (func7 == 7'b0100000) begin
                            reg_write   = 1'b1;
                            alu_control = ALU_SRA;
                        end
                        else begin
                            alu_src = 1'b0;
                        end
                    end

                    default: begin
                        alu_src = 1'b0;
                    end

                endcase
            end

            // Loads: LB, LH, LW, LBU, LHU
            7'b0000011: begin
                case (func3)
                    3'b000, 3'b001, 3'b010, 3'b100, 3'b101: begin
                        reg_write   = 1'b1;
                        alu_src     = 1'b1;
                        mem_read    = 1'b1;
                        mem_to_reg  = 1'b1;
                        alu_control = ALU_ADD;
                    end
                    default: begin
                    end
                endcase
            end

            // Stores: SB, SH, SW
            7'b0100011: begin
                case (func3)
                    3'b000, 3'b001, 3'b010: begin
                        alu_src     = 1'b1;
                        mem_write   = 1'b1;
                        alu_control = ALU_ADD;
                    end
                    default: begin
                    end
                endcase
            end

            // Conditional branches: BEQ, BNE, BLT, BGE, BLTU, BGEU
            7'b1100011: begin
                case (func3)
                    3'b000, 3'b001, 3'b100,
                    3'b101, 3'b110, 3'b111: begin
                        branch      = 1'b1;
                        branch_type = func3;
                        alu_control = ALU_SUB;
                    end
                    default: begin
                    end
                endcase
            end

            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
            end

            // JALR: valid func3 is 000
            7'b1100111: begin
                if (func3 == 3'b000) begin
                    reg_write   = 1'b1;
                    alu_src     = 1'b1;
                    jalr        = 1'b1;
                    alu_control = ALU_ADD;
                end
            end

            // LUI
            7'b0110111: begin
                reg_write = 1'b1;
            end

            // AUIPC
            7'b0010111: begin
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                alu_control = ALU_ADD;
            end

            // Unsupported opcode: retain safe defaults
            default: begin
            end

        endcase
    end

endmodule