module nitc_risc24_processor(
    input clk,
    input reset
);

    //Wire declaration for connecting the modules
    wire [15:0] pc, next_pc, intsruction, alu_out, rd1, rd2, mem_out, link_address;
    wire [1:0] alu_ctrl, funct;
    wire zero, carry, RegWrite, MemWrite, MemRead, PCWrite, Branch, ALUSrc;

    //Instantiating the modules

    //Program Counter
    program_counter prog_ctr(
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Instruction Memory
    instruction_memory inst_mem(
        .address(pc), // The PC provides the address
        .instruction(instruction) // Instruction output to the datapath
    );

    // Register File
    register_file reg_file(
        .clk(clk),
        .RegWrite(RegWrite),
        .ra(intsruction[11:9]),
        .rb(intsruction[8:6]),
        .rc(intsruction[5:3])
        .wd(alu_out),
        .rd1(rd1),
        .rd2(rd2)
    );

    // ALU
    alu alu(
        .a(rd1),
        .b(ALUSrc ? mem_out : rd2),
        .alu_ctrl(alu_ctrl),
        .alu_out(alu_out),
        .zero(zero),
        .carry(carry)
    );

    // Data Memory
    data_memory data_mem(
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(alu_out),
        .wd(rd2),
        .rd(mem_out)
    );

    //Control Unit
    control_unit ctrl_unit(
        .clk(clk),
        .reset(reset),
        .opcode(intsruction[15:12]),
        .zero(zero),
        .carry(carry),
        .funct(intsruction[1:0]),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .PCWrite(PCWrite),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALUControl(alu_ctrl)
    );

    next_pc_logic pc_logic(
        .pc(pc),                   // Current PC
        .instruction(instruction),  // Current instruction
        .zero_flag(zero),           // Zero flag for conditional branch
        .branch(Branch),     // Branch signal (from control unit)
        .jal(0),           // JAL signal (from control unit) //todo
        .next_pc(next_pc),          // Computed next PC
        .link_address(link_address) // Return address for JAL
    );


endmodule
