`timescale 1ns / 1ps

module tb_register_file;
    reg clk, reset, reg_write;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] write_data;
    wire [31:0] read_data1, read_data2;

    register_file uut (
        .clk(clk), .reset(reset), .reg_write(reg_write),
        .rs1(rs1), .rs2(rs2), .rd(rd), .write_data(write_data),
        .read_data1(read_data1), .read_data2(read_data2)
    );

    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, tb_register_file);
    end
    always #5 clk = ~clk;

    // Check both asynchronous read ports.
    task check_reads;
        input [31:0] expected1, expected2;
        begin
            #1;
            if (read_data1 !== expected1 || read_data2 !== expected2)
                $fatal(1, "Read failed: x%0d=%h (expected %h), x%0d=%h (expected %h)",
                       rs1, read_data1, expected1, rs2, read_data2, expected2);
        end
    endtask

    // Write one register on a rising edge.
    task write_register;
        input [4:0] address;
        input [31:0] value;
        begin
            @(negedge clk);
            reg_write = 1'b1;
            rd = address;
            write_data = value;
            @(posedge clk);
            #1 reg_write = 1'b0;
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        reg_write = 1'b0;
        rd = 5'd0;
        rs1 = 5'd0;
        rs2 = 5'd1;
        write_data = 32'b0;

        @(posedge clk);
        #1 reset = 1'b0;
        check_reads(32'b0, 32'b0);

        write_register(5'd1, 32'h12345678);
        rs1 = 5'd1; rs2 = 5'd0;
        check_reads(32'h12345678, 32'b0);

        write_register(5'd2, 32'hABCDEF01);
        rs1 = 5'd1; rs2 = 5'd2;
        check_reads(32'h12345678, 32'hABCDEF01);

        write_register(5'd10, 32'hDEADBEEF);
        rs1 = 5'd10; rs2 = 5'd1;
        check_reads(32'hDEADBEEF, 32'h12345678);

        write_register(5'd0, 32'hFFFFFFFF);
        rs1 = 5'd0; rs2 = 5'd0;
        check_reads(32'b0, 32'b0);

        rs1 = 5'd1; rs2 = 5'd2;
        check_reads(32'h12345678, 32'hABCDEF01);

        $display("Register file checks passed.");
        $finish;
    end
endmodule
