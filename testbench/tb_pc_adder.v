`timescale 1ns / 1ps

module tb_pc_adder;

    reg  [31:0] pc;
    wire [31:0] pc_plus4;

    pc_adder uut (
        .pc(pc),
        .pc_plus4(pc_plus4)
    );

    task expect_pc_plus4;
        input [31:0] expected;
        begin
            if (pc_plus4 !== expected) begin
                $fatal(1, "PC+4 check failed at %0t: expected %h, got %h",
                       $time, expected, pc_plus4);
            end
        end
    endtask

    initial begin

        pc = 32'h00000000;
        #1;
        expect_pc_plus4(32'h00000004);

        pc = 32'h00000004;
        #1;
        expect_pc_plus4(32'h00000008);

        pc = 32'h00000008;
        #1;
        expect_pc_plus4(32'h0000000C);

        pc = 32'h0000000C;
        #1;
        expect_pc_plus4(32'h00000010);

        pc = 32'hFFFFFFFF;
        #1;
        expect_pc_plus4(32'h00000003);

        $display("PC+4 checks passed.");
        $finish;

    end

endmodule
