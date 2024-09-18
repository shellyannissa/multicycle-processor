module tb_program_counter;

    // Testbench signals
    reg clk;
    reg reset;
    reg [15:0] next_pc;
    wire [15:0] pc;

    // Instantiate the program_counter module
    program_counter uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation: 50% duty cycle clock
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        next_pc = 16'h0000;

        // Apply reset
        reset = 1;
        #10; // Wait for 10 time units
        reset = 0;
        #10;

        $dumpfile("waveform/program_counter_tb.vcd"); // Specify the name of the VCD file
        $dumpvars(0, tb_program_counter); 

        // Test 1: Check reset condition
        if (pc != 16'h0000) begin
            $display("Test 1 failed: PC should be 0 after reset.");
        end else begin
            $display("Test 1 passed: PC is 0 after reset.");
        end

        // Test 2: Provide next PC and check PC update
        next_pc = 16'h0005;
        #10; // Wait for one clock cycle
        if (pc != 16'h0005) begin
            $display("Test 2 failed: PC should update to 5.");
        end else begin
            $display("Test 2 passed: PC updated to 5.");
        end

        // Test 3: Change next PC
        next_pc = 16'h0010;
        #10; // Wait for one clock cycle
        if (pc != 16'h0010) begin
            $display("Test 3 failed: PC should update to 10.");
        end else begin
            $display("Test 3 passed: PC updated to 10.");
        end

        // Test 4: Reset again
        reset = 1;
        #10; // Wait for one clock cycle
        reset = 0;
        if (pc != 16'h0000) begin
            $display("Test 4 failed: PC should reset to 0.");
        end else begin
            $display("Test 4 passed: PC reset to 0.");
        end

        // End simulation
        $finish;
    end

endmodule
