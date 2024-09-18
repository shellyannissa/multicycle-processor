module instruction_memory (
    input [15:0] address,
    output reg [15:0] instruction
);
    reg [15:0] memory [255:0];

    initial begin
        memory[0] = 16'b0000000010100011; // ADD instruction (example)
        memory[1] = 16'b1010000000110010; // LW instruction (example)
        memory[2] = 16'b1001000000110110; // SW instruction (example)
    end

    always @(*) begin
        instruction = memory[address];
    end
endmodule
    