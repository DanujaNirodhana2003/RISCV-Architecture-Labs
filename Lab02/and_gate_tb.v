// and_gate_tb.v - Testbench to simulate the AND gate
`timescale 1ns/1ps // Set time units to nanoseconds

module and_gate_tb;
    reg a, b;       // Inputs are declared as reg (registers) in testbenches
    wire out;       // Outputs are declared as wire

    // Instantiate our AND gate module
    and_gate uut (
        .a(a), 
        .b(b), 
        .out(out)
    );

    initial begin
        // Generate the VCD waveform file for GTKWave
        $dumpfile("and_gate_wave.vcd");
        $dumpvars(0, and_gate_tb);

        // Test Case 1: a=0, b=0
        a = 0; b = 0;
        #10; // Wait 10 nanoseconds
        
        // Test Case 2: a=0, b=1
        a = 0; b = 1;
        #10;
        
        // Test Case 3: a=1, b=0
        a = 1; b = 0;
        #10;
        
        // Test Case 4: a=1, b=1
        a = 1; b = 1;
        #10;

        $display("Simulation complete!");
        $finish; // End the simulation
    end
endmodule