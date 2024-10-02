module register_file (
    input clk, reset,
    input RegWrite, 
    input PCWrite,
    input [15:0] instruction,
    input [15:0] next_pc,
    input [15:0] wd,            // Write data
    output reg [15:0] rd1,      // Read data 1
    output reg [15:0] rd2,      // Read data 2 or immediate value (for LW, SW)
    output reg [15:0] sw        // Data for SW
);
    reg [15:0] regfile [7:0];     // 8 registers of 16 bits each
    wire [3:0] opcode = instruction[15:12];   
    wire [2:0] ra = instruction[11:9];        
    wire [2:0] rb = instruction[8:6];         
    wire [2:0] rc = instruction[5:3];         
    wire [15:0] immediate = {10'b0, instruction[5:0]};  // Zero-extended immediate for LW/SW

    reg [2:0] rsrc; // Source register
    reg [2:0] rdst; // Destination register


    always @(posedge reset) begin
        regfile[0] = 16'b0;   // Program counter initialized to 0
        regfile[1] = 16'b100;   // Register R1 initialized to 4
        regfile[2] = 16'b0;   // Register R2 initialized to 0
        regfile[3] = 16'b0;   // Register R3 initialized to 0
        regfile[4] = 16'b0;   // Register R4 initialized to 0
        regfile[5] = 16'b0;   // Register R5 initialized to 0
        regfile[6] = 16'b0;   // Register R6 initialized to 0
        regfile[7] = 16'b0;   // Register R7 initialized to 0
    end

    always @(posedge clk) begin
        // Determine the destination and source register based on instruction type (R-Type or I-Type)
        rsrc = (opcode == 4'b0000 || opcode == 4'b0010 || opcode == 4'b1011) ? ra : rb;
        rdst = (opcode == 4'b0000 || opcode == 4'b0010) ? rc : ra;
        
        // Write to register file on positive clock edge if RegWrite is high and not writing to R0
        if (RegWrite && (rdst != 3'b000)) begin
            regfile[rdst] <= wd;
        end

        // Read from register file
        rd1 <= regfile[rsrc];   
        rd2 <= (opcode == 4'b0000 || opcode == 4'b0010 || opcode == 4'b1011) ?
            regfile[rb] : immediate;  

        sw = regfile[ra]; // Data Store for SW

        if ( PCWrite) begin
            regfile[0] <= next_pc; // Update PC
        end
        
        // Display source and destination registers and all current register values
        // $display("RegFile: Time: %0d, Opcode: %b, rsrc: R%d, rdst: R%d sw: %h", $time, opcode, rsrc, rdst, sw);
        // $display("Register values: R0 = %h, R1 = %h, R2 = %h, R3 = %h, R4 = %h, R5 = %h, R6 = %h, R7 = %h", 
        //          regfile[0], regfile[1], regfile[2], regfile[3], regfile[4], regfile[5], regfile[6], regfile[7]);
        
    end

    always @(negedge PCWrite) begin
    $display("Time: %0d Register values: R0 = %h, R1 = %h, R2 = %h, R3 = %h, R4 = %h, R5 = %h, R6 = %h, R7 = %h ", 
                $time, regfile[0], regfile[1], regfile[2], regfile[3], regfile[4], regfile[5], regfile[6], regfile[7]);
end

    
endmodule
