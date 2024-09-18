module next_pc_logic (
    input [15:0] pc,               // Current PC
    input [15:0] instruction,      // Current instruction
    input zero_flag,               // Zero flag for BEQ
    input branch,                  // Branch control signal (for BEQ)
    input jal,                     // JAL control signal
    output reg [15:0] next_pc,     // Next PC
    output reg [15:0] link_address // Return address for JAL
);

    wire [8:0] immediate = instruction[8:0]; // Immediate for JAL
    wire [5:0] branch_offset = instruction[5:0]; // Immediate for BEQ (I-type)
    
    always @(*) begin
        if (jal) begin
            // Jump and Link (JAL) instruction
            next_pc = pc + {{7{immediate[8]}}, immediate}; // Sign-extend immediate
            link_address = pc + 1; // Save return address (pc + 1)
        end else if (branch && zero_flag) begin
            // BEQ (Branch on Equal) instruction, branch if zero flag is set
            next_pc = pc + {{10{branch_offset[5]}}, branch_offset}; // Sign-extend offset
        end else begin
            // Default case: PC increment by 1 for regular instructions
            next_pc = pc + 1;
        end
    end
endmodule
