module instruction_memory (
    input [15:0] address,
    output reg [15:0] instruction
);
    reg [15:0] memory [0:255];  

    initial begin
        // Read instructions from a file
        $readmemh("instructions.txt", memory, 0, 255);
    end

    always @(*) begin
        instruction = memory[address];
    end
endmodule