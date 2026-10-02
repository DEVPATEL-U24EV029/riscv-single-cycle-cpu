// 32-bit program counter with a synchronous, active-high reset.
module pc #(
    parameter [31:0] RESET_ADDRESS = 32'b0
) (
    input            clk,
    input            reset,
    input      [31:0] pc_next,
    output reg [31:0] pc
);

    // Update the PC on each rising edge of the clock.
    always @(posedge clk) begin
        if (reset) begin
            pc <= RESET_ADDRESS;
        end else begin
            pc <= pc_next;
        end
    end

endmodule
