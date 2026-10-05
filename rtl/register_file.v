module register_file (
    input             clk, reset, reg_write,
    input      [4:0]  rs1, rs2, rd,
    input      [31:0] write_data,
    output     [31:0] read_data1, read_data2
);
    reg [31:0] registers [1:31];
    integer i;

    // x0 is hardwired to zero; the other registers clear on reset.
    always @(posedge clk) begin
        if (reset) begin
            for (i = 1; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (reg_write && (rd != 5'd0)) begin
            registers[rd] <= write_data;
        end
    end

    assign read_data1 = (rs1 == 5'd0) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'b0 : registers[rs2];
endmodule
