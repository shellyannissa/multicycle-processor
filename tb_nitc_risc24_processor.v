`timescale 1ns / 1ps

module tb_nitc_risc24_processor;
    reg clk;
    reg reset;

    // Instantiate the Unit Under Test (UUT)
    nitc_risc24_processor uut (
        .clk(clk), 
        .reset(reset)
    );

    initial begin
        // Initialize reset and clock
        reset = 1;  
        clk = 0;    

        #10 reset = 0;
        // Clock generation in a forever loop
        forever begin
            #10 clk = ~clk;  // Toggle clock every 10 time units
        end
    end

    initial begin
        #1200 $finish;
    end
endmodule