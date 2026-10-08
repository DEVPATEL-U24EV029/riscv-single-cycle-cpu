`timescale 1ns / 1ps

module tb_immediate_generator;

    reg  [31:0] instruction;
    wire [31:0] immediate;
    integer checks_passed;

    immediate_generator uut (
        .instruction(instruction),
        .immediate(immediate)
    );

    initial begin
        $dumpfile("immediate_generator.vcd");
        $dumpvars(0, tb_immediate_generator);
    end

    task check_immediate;
        input [31:0] expected;

        begin
            #1;

            if (immediate !== expected) begin
                $fatal(1, "FAIL: instruction=%h expected=%h got=%h",
                       instruction, expected, immediate);
            end

            checks_passed = checks_passed + 1;
            $display("PASS: instruction=%h immediate=%h",
                     instruction, immediate);
        end
    endtask

    initial begin
        checks_passed = 0;

        // I-type: ADDI x1, x0, 10
        instruction = 32'h00A00093;
        check_immediate(32'h0000000A);

        // I-type: ADDI x1, x0, -1
        instruction = 32'hFFF00093;
        check_immediate(32'hFFFFFFFF);

        // S-type: SW x2, 16(x1)
        instruction = 32'h0020A823;
        check_immediate(32'h00000010);

        // S-type: SW x2, -16(x1)
        instruction = 32'hFE20A823;
        check_immediate(32'hFFFFFFF0);

        // B-type: BEQ x1, x2, +8
        instruction = 32'h00208463;
        check_immediate(32'h00000008);

        // B-type: BEQ x1, x2, -8
        instruction = 32'hFE208CE3;
        check_immediate(32'hFFFFFFF8);

        // U-type: LUI x1, 0x12345
        instruction = 32'h123450B7;
        check_immediate(32'h12345000);

        // J-type: JAL x1, +8
        instruction = 32'h008000EF;
        check_immediate(32'h00000008);

        // J-type: JAL x1, -8
        instruction = 32'hFF9FF0EF;
        check_immediate(32'hFFFFFFF8);

        // Unsupported opcode
        instruction = 32'h00000000;
        check_immediate(32'h00000000);

        $display("All %0d immediate generator checks passed.", checks_passed);

        $finish;

    end

endmodule
