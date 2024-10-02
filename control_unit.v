module control_unit(
    input clk,
    input reset,
    input zero,
    input carry,
    input [3:0] opcode,
    input [1:0] funct,
    output reg RegWrite, MemRead, MemWrite, PCWrite, Branch, JAL,
    output reg [1:0] ALUControl,
    output reg [2:0] state //FSM state
);
    // state encoding
    parameter IF = 3'b000, ID = 3'b001, EX = 3'b010, MEM = 3'b011, WB = 3'b100;

    always @(posedge clk or posedge reset) begin    
        if (reset)
            state <= IF;
        else begin
            case (state)
                IF: state <= ID;
                ID: if (opcode == 4'b1101) state <= WB; // JAL
                    else state <= EX;
                EX: if (opcode == 4'b1010 || opcode == 4'b1001) state <= MEM; //LW, SW
                    else state <= WB;
                MEM: state <= WB;
                WB: state <= IF;
            endcase
        end
    end

    //Generating control signals
    always @(*) begin   
        case (state)
            IF: begin
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                PCWrite = 0;
                Branch = 0;
                JAL = 0;    
            end
            ID: begin
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                // PCWrite = 0;
                Branch = 0;
            end
            EX: begin   
                case (opcode)
                    4'b0001: ALUControl = 2'b00; // ADC
                    4'b0000: ALUControl = 2'b00; // ADD
                    4'b0010: ALUControl = 2'b01; // NDU
                    4'b0011: ALUControl = 2'b01; // NDZ
                    4'b1011: ALUControl = 2'b10; // BEQ (SUB for comparison)
                    4'b1010: ALUControl = 2'b00; // LW
                    4'b1001: ALUControl = 2'b00; // SW
                endcase
            end
            MEM: begin
                if (opcode == 4'b1010) begin //LW
                    MemRead = 1;
                    MemWrite = 0;
                end
                else if (opcode == 4'b1001) begin //SW
                    RegWrite = 0;
                    MemRead = 0;
                    MemWrite = 1;
                end
            end
            WB: begin
                RegWrite = ( 
                            ({opcode, funct} == 6'b000000) || //ADD
                            (({opcode, funct} == 6'b000010) && (carry == 1)) || //ADC
                             {opcode, funct} == 6'b001000 || //NDU
                            (({opcode, funct} == 6'b001001) && (zero == 1)) || //NDZ
                            (opcode == 4'b1010) || //LW
                            (opcode == 4'b1101) ) //JAL
                                ? 1 : 0;
                MemRead = 0;
                MemWrite = 0;
                PCWrite = 1;
                Branch = (opcode == 4'b1011) ? 1 : 0;
                JAL = (opcode == 4'b1101) ? 1 : 0;
            end
        endcase
    end

endmodule