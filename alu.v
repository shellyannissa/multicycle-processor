module alu(
    input [15:0] a, b,
    input [3:0] alu_ctrl,
    output reg [15:0] alu_out,
    output reg zero, carry
);
    always@(*) begin
        case (alu_ctrl)
            2'b00: {carry, alu_out} = a + b; // ADD & ADC
            2'b01: alu_out = ~( a & b ); // NDU & NDZ
            2'b10: alu_out = a - b; // SUB
            // default: alu_out = 16'b0;
        endcase
        zero = (alu_out == 16'b0);
    end
endmodule    