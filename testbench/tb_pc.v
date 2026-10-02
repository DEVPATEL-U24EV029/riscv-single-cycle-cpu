`timescale 1ns / 1ps

module tb_pc;

    reg         clk;
    reg         reset;
    reg  [31:0] pc_next;
    wire [31:0] pc;

    pc uut (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc  (pc)
    );

    // A rising edge arrives every 10 ns.
    always #5 clk = ~clk;

    task expect_pc;
        input [31:0] expected;
        begin
            if (pc !== expected) begin
                $fatal(1, "PC check failed at %0t: expected %h, got %h",
                       $time, expected, pc);
            end
        end
    endtask

    initial begin
        clk     = 1'b0;
        reset   = 1'b1;
        pc_next = 32'd4;

        // Reset is synchronous, so wait for a rising edge before checking it.
        @(posedge clk);
        #1;
        expect_pc(32'b0);

        // Once reset is released, the PC should follow pc_next each cycle.
        reset = 1'b0;
        @(posedge clk);
        #1;
        expect_pc(32'd4);

        pc_next = 32'd8;
        @(posedge clk);
        #1;
        expect_pc(32'd8);

        pc_next = 32'd12;
        @(posedge clk);
        #1;
        expect_pc(32'd12);

        pc_next = 32'd16;
        @(posedge clk);
        #1;
        expect_pc(32'd16);

        $display("PC checks passed.");
        $finish;
    end

endmodule
