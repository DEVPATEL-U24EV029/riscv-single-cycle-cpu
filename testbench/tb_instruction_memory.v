`timescale 1ns / 1ps

module tb_instruction_memory;
    reg  [31:0] address;
    wire [31:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    // Check the output after the address change has settled.
    task check_instruction;
        input [31:0] expected_instruction;
        begin
            if (instruction !== expected_instruction) begin
                $fatal(1, "Test failed at address %h: expected %h, got %h",
                       address, expected_instruction, instruction);
            end else begin
                $display("Test passed at address %h: got %h", address, instruction);
            end
        end
    endtask

    initial begin
        // Save the signals so they can be viewed in a waveform.
        $dumpfile("tb_instruction_memory.vcd");
        $dumpvars(0, tb_instruction_memory);

        // Check the instructions loaded at the start of the ROM.
        // Address  -> memory[i]
        address = 32'h00000000;
        #1;
        check_instruction(32'h00000013);

        address = 32'h00000004;
        #1;
        check_instruction(32'h00000093);

        address = 32'h00000008;
        #1;
        check_instruction(32'h00000113);

        address = 32'h0000000C;
        #1;
        check_instruction(32'h00000193);

        address = 32'h00000010;
        #1;
        check_instruction(32'h00000213);

        // The remaining locations should contain NOPs [no operation].
        address = 32'h00000014;
        #1;
        check_instruction(32'h00000013);

        $display("All tests passed.");
        $finish;
    end
endmodule
