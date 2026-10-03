// 256-entry, 32-bit instruction memory.
module instruction_memory (
    input      [31:0] address,
    output     [31:0] instruction
);

    reg [31:0] memory [0:255];
    integer i;

    // Initialize unused locations to the RV32I NOP (ADDI x0, x0, 0).
  
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            memory[i] = 32'h00000013;
        end

        memory[0] = 32'h00000013;
        memory[1] = 32'h00000093;
        memory[2] = 32'h00000113;
        memory[3] = 32'h00000193;
        memory[4] = 32'h00000213;
    end

    // Each instruction is 4 bytes; address[1:0] is ignored as it will give memory 0 ,1,2 so
    assign instruction = memory[address[9:2]];

endmodule
