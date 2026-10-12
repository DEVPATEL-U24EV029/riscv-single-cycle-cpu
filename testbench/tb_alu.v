`timescale 1ns / 1ps

module tb_alu;
    reg  [31:0] a, b;
    reg  [3:0]  alu_control;
    wire [31:0] result;
    wire        zero;
    integer     checks_passed;

    alu uut (
        .a(a), .b(b), .alu_control(alu_control),
        .result(result), .zero(zero)
    );

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu);
    end

    task check_result;
        input [31:0] expected_result;
        input        expected_zero;
        begin
            #1;
            if (result !== expected_result || zero !== expected_zero)
                $fatal(1, "FAIL: control=%b a=%h b=%h expected=%h got=%h expected_zero=%b got_zero=%b",
                       alu_control, a, b, expected_result, result,
                       expected_zero, zero);

            checks_passed = checks_passed + 1;
            $display("PASS: control=%b a=%h b=%h result=%h zero=%b",
                     alu_control, a, b, result, zero);
        end
    endtask

    initial begin
        checks_passed = 0;

        a = 32'd10;       b = 32'd5;       alu_control = 4'b0000;
        check_result(32'd15, 1'b0);
        a = 32'd10;       b = 32'd10;      alu_control = 4'b0001;
        check_result(32'd0, 1'b1);
        a = 32'h0000000F; b = 32'h00000003; alu_control = 4'b0010;
        check_result(32'h00000003, 1'b0);
        a = 32'h0000000F; b = 32'h00000030; alu_control = 4'b0011;
        check_result(32'h0000003F, 1'b0);
        a = 32'h0000000F; b = 32'h00000003; alu_control = 4'b0100;
        check_result(32'h0000000C, 1'b0);
        a = 32'd5;        b = 32'd10;      alu_control = 4'b0101;
        check_result(32'd1, 1'b0);
        a = 32'hFFFFFFFF; b = 32'd1;       alu_control = 4'b0101; // -1 < 1
        check_result(32'd1, 1'b0);
        a = 32'd1;        b = 32'd4;       alu_control = 4'b0110;
        check_result(32'd16, 1'b0);
        a = 32'd16;       b = 32'd2;       alu_control = 4'b0111;
        check_result(32'd4, 1'b0);
        a = 32'hFFFFFFF0; b = 32'd2;       alu_control = 4'b1000; // -16 >>> 2
        check_result(32'hFFFFFFFC, 1'b0);
        a = 32'd10;       b = 32'd5;       alu_control = 4'b1111;
        check_result(32'd0, 1'b1);

        $display("\n==================================");
        $display("ALL %0d ALU CHECKS PASSED", checks_passed);
        $display("==================================");
        $finish;
    end
endmodule
