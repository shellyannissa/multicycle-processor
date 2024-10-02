module next_pc_logic (
    input [15:0] pc,               
    input [15:0] instruction,      
    input zero_flag,               
    input branch,                  // Branch control signal (for BEQ)
    input jal,                     // JAL control signal
    output reg [15:0] next_pc     
);

    wire [8:0] immediate = instruction[8:0]; // Immediate for JAL
    wire [5:0] branch_offset = instruction[5:0]; // Immediate for BEQ (I-type)
    
    always @(*) begin
        if (jal) begin
            next_pc = pc + {{7{immediate[8]}}, immediate}; // Sign-extend immediate

        end else if (branch && zero_flag) begin
            next_pc = pc + {{10{branch_offset[5]}}, branch_offset}; // Sign-extend offset
            // next_pc = pc + branch_offset;


        end else begin
            // Default case: PC increment by 1 for regular instructions
            next_pc = pc + 1;
        end
    end
endmodule
