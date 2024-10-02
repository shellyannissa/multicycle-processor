module program_counter (
    input clk,
    input reset,
    input PCWrite,
    input [15:0] next_pc,
    output reg [15:0] pc
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 16'b0;
        else if (PCWrite)
            pc <= next_pc;
    end
endmodule
