`timescale 1ns / 1ps

module tb_instruction_decoder;
    reg  [31:0] instruction;
    wire [6:0] opcode, func7;
    wire [4:0] rd, rs1, rs2;
    wire [2:0] func3;

    instruction_decoder uut (
        .instruction(instruction), .opcode(opcode), .rd(rd),
        .func3(func3), .rs1(rs1), .rs2(rs2), .func7(func7)
    );

    task check_fields;
        input [6:0] exp_opcode, exp_func7;
        input [4:0] exp_rd, exp_rs1, exp_rs2;
        input [2:0] exp_func3;
        begin
            #1;
            if ({opcode, rd, func3, rs1, rs2, func7} !==
                {exp_opcode, exp_rd, exp_func3, exp_rs1, exp_rs2, exp_func7})
                $fatal(1, "Decode failed for instruction %h", instruction);
        end
    endtask
    
    initial begin
        $dumpfile("instruction_decoder.vcd");
        $dumpvars(0, tb_instruction_decoder);
        
        instruction = 32'h00A081B3; // ADD x3, x1, x10
        check_fields(7'h33, 7'h00, 5'd3, 5'd1, 5'd10, 3'b000);

        instruction = 32'h40A081B3; // SUB x3, x1, x10
        check_fields(7'h33, 7'h20, 5'd3, 5'd1, 5'd10, 3'b000);

        $display("Instruction decoder checks passed.");
        $finish;
    end
endmodule
