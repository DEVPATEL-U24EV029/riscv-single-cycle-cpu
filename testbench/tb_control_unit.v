`timescale 1ns / 1ps

module tb_control_unit;

    reg [6:0] opcode;
    reg [2:0] func3;
    reg [6:0] func7;

    wire reg_write;
    wire alu_src;
    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire branch;
    wire jump;
    wire jalr;

    wire [3:0] alu_control;
    wire [2:0] branch_type;

    integer pass_count;
    integer fail_count;

    // Instantiate the Control Unit
    control_unit dut (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .alu_control(alu_control),
        .branch_type(branch_type)
    );

    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_SLL = 4'b0110;
    localparam ALU_SRL = 4'b0111;
    localparam ALU_SRA = 4'b1000;

    // Task to check all outputs
    task check_outputs;
        input [8:0] expected_control;
        input [3:0] expected_alu_control;
        input [2:0] expected_branch_type;

        begin
            #1;

            if ({
                reg_write,
                alu_src,
                mem_read,
                mem_write,
                mem_to_reg,
                branch,
                jump,
                jalr,
                1'b0
            } !== expected_control ||
                alu_control !== expected_alu_control ||
                branch_type !== expected_branch_type) begin

                $display("FAIL: opcode=%b func3=%b func7=%b",
                         opcode, func3, func7);

                $display("Actual controls:   %b",
                         {reg_write, alu_src, mem_read, mem_write,
                          mem_to_reg, branch, jump, jalr, 1'b0});

                $display("Expected controls: %b", expected_control);

                $display("Actual ALU control:   %b", alu_control);
                $display("Expected ALU control: %b", expected_alu_control);

                $display("Actual branch type:   %b", branch_type);
                $display("Expected branch type: %b", expected_branch_type);

                fail_count = fail_count + 1;
            end
            else begin
                $display("PASS: opcode=%b func3=%b func7=%b",
                         opcode, func3, func7);
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin

        pass_count = 0;
        fail_count = 0;

        $dumpfile("control_unit.vcd");
        $dumpvars(0, tb_control_unit);

        // 1. ADD
        opcode = 7'b0110011;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b100000000, ALU_ADD, 3'b000);

        // 2. SUB
        opcode = 7'b0110011;
        func3  = 3'b000;
        func7  = 7'b0100000;
        check_outputs(9'b100000000, ALU_SUB, 3'b000);

        // 3. AND
        opcode = 7'b0110011;
        func3  = 3'b111;
        func7  = 7'b0000000;
        check_outputs(9'b100000000, ALU_AND, 3'b000);

        // 4. ADDI
        opcode = 7'b0010011;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b110000000, ALU_ADD, 3'b000);

        // 5. LW
        opcode = 7'b0000011;
        func3  = 3'b010;
        func7  = 7'b0000000;
        check_outputs(9'b111010000, ALU_ADD, 3'b000);

        // 6. SW
        opcode = 7'b0100011;
        func3  = 3'b010;
        func7  = 7'b0000000;
        check_outputs(9'b010100000, ALU_ADD, 3'b000);

        // 7. BEQ
        opcode = 7'b1100011;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b000001000, ALU_SUB, 3'b000);

        // 8. BNE
        opcode = 7'b1100011;
        func3  = 3'b001;
        func7  = 7'b0000000;
        check_outputs(9'b000001000, ALU_SUB, 3'b001);

        // 9. JAL
        opcode = 7'b1101111;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b100000100, ALU_ADD, 3'b000);

        // 10. JALR
        opcode = 7'b1100111;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b110000010, ALU_ADD, 3'b000);

        // 11. LUI
        opcode = 7'b0110111;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b100000000, ALU_ADD, 3'b000);

        // 12. AUIPC
        opcode = 7'b0010111;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b110000000, ALU_ADD, 3'b000);

        // 13. XOR
        opcode = 7'b0110011;
        func3  = 3'b100;
        func7  = 7'b0000000;
        check_outputs(9'b100000000, ALU_XOR, 3'b000);

        // 14. OR
        opcode = 7'b0110011;
        func3  = 3'b110;
        func7  = 7'b0000000;
        check_outputs(9'b100000000, ALU_OR, 3'b000);

        // 15. SLT
        opcode = 7'b0110011;
        func3  = 3'b010;
        func7  = 7'b0000000;
        check_outputs(9'b100000000, ALU_SLT, 3'b000);

        // 16. Unsupported opcode
        opcode = 7'b1111111;
        func3  = 3'b000;
        func7  = 7'b0000000;
        check_outputs(9'b000000000, ALU_ADD, 3'b000);

        // 17. Invalid R-type encoding
        opcode = 7'b0110011;
        func3  = 3'b000;
        func7  = 7'b1111111;
        check_outputs(9'b000000000, ALU_ADD, 3'b000);

        $display("--------------------------------");
        $display("Total tests: %0d", pass_count + fail_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);

        if (fail_count == 0)
            $display("ALL 17 CONTROL UNIT CHECKS PASSED");
        else
            $display("CONTROL UNIT TESTS FAILED");

        $display("--------------------------------");

        $finish;
    end

endmodule