module data_memory(
    input clk,
    input MemRead, MemWrite,
    input [15:0] address,
    input [15:0] wd,
    output reg [15:0] rd
);
    reg [15:0] memory [255:0]; //256 words of 16 bits each

    always @(posedge clk) begin
        if (MemWrite) begin
            memory[address] <= wd;
        end
        if (MemRead) begin
            rd <= memory[address];
        end

        // $display("Data Memory: At time %0d, val at addr %h is %h", $time, address, memory[address]);
    end

endmodule