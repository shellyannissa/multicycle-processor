module nitc_risc24_processor(
    input clk,
    input reset
);

    //Wire declaration for connecting the modules
    wire [15:0] pc, next_pc, instruction, alu_out, rd1, rd2, sw, mem_out, reg_write_data;
    wire [1:0] alu_ctrl, funct;
    wire zero, carry, RegWrite, MemWrite, MemRead, PCWrite, Branch, JAL;

    //Instantiating the modules

    //Program Counter
    program_counter prog_ctr(
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Instruction Memory
    instruction_memory inst_mem(
        .address(pc),
        .instruction(instruction) 
    );

    // Register File
    register_file reg_file(
        .clk(clk),
        .RegWrite(RegWrite),
        .PCWrite(PCWrite),
        .next_pc(next_pc),
        .instruction(instruction),
        .wd(reg_write_data),
        .reset(reset),
        .rd1(rd1),
        .rd2(rd2),
        .sw(sw)
    );

    // ALU
    alu alu(
        .a(rd1),
        .b(rd2),
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
        .wd(sw),
        .rd(mem_out)
    );

    //Control Unit
    control_unit ctrl_unit(
        .clk(clk),
        .reset(reset),
        .opcode(instruction[15:12]),
        .zero(zero),
        .carry(carry),
        .JAL(JAL),
        .funct(instruction[1:0]),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .PCWrite(PCWrite),
        .Branch(Branch),
        .ALUControl(alu_ctrl)
    );

    // Multiplexer for selecting the data to write to the register file
    assign reg_write_data = (instruction[15:12] == 4'b1010) ? mem_out :  // LW instruction
                            (instruction[15:12] == 4'b1101) ? (pc + 1) :  // JAL instruction
                            alu_out; 

    next_pc_logic pc_logic(
        .pc(pc),                   
        .instruction(instruction),  
        .zero_flag(zero),           
        .branch(Branch),     
        .jal(JAL),           
        .next_pc(next_pc)         
    );

    always @(negedge PCWrite) begin
        casex({instruction[15:12], instruction[1:0]})
            6'b000000: begin
                $display("Time: %0d ADD R%d, R%d, R%d ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:3], zero, carry);
            end
            6'b000010: begin
                $display("Time: %0d ADC R%d, R%d, R%d ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:3], zero, carry);
            end
            6'b001000: begin
                $display("Time: %0d NDU R%d, R%d, R%d ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:3], zero, carry);
            end
            6'b001001: begin
                $display("Time: %0d NDZ R%d, R%d, R%d ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:3], zero, carry);
            end
            6'b1010??: begin
                $display("Time: %0d LW R%d, R%d, Imm: %b  ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:0], zero, carry);
            end
            6'b1001??: begin
                $display("Time: %0d SW R%d, R%d, Imm: %b  ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:0], zero, carry);
            end
            6'b1011??: begin
                $display("Time: %0d BEQ R%d, R%d, Imm: %b  ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:6], instruction[5:0], zero, carry);
            end
            6'b1101??: begin
                $display("Time: %0d JAL R%d, Imm: %b ZERO: %b, CARRY: %b", $time, instruction[11:9], instruction[8:0], zero, carry);
            end
        endcase


    end

    always @(posedge clk) begin
        $display("-----------------------------------------------");
    end

endmodule
