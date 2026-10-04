// 256-entry, 32-bit instruction memory.
module instruction_memory (
    input      [31:0] address,
    output     [31:0] instruction
);

    reg [31:0] memory [0:255];
    integer i;

    // Start with NOPs so fetching past the sample program stays deterministic.
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

    // Instructions are 4 bytes, so address[1:0] does not affect the word index.
    assign instruction = memory[address[9:2]];

endmodule
