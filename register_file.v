module register_file (
    input clk,
    input RegWrite, 
    input [2:0] ra, rb, rc,
    input [15:0] wd,
    output [15:0] rd1, rd2
);
    reg [15:0] regfile [7:0]; //8 registers of 16 bits each

    assign rd1 = regfile[ra];
    assign rd2 = regfile[rb];
    always @(posedge clk) begin
        if (RegWrite && (rc != 3'b000)) begin // to prevent writing into R0 (PC)
            regfile[rc] <= wd;
        end
    end
endmodule