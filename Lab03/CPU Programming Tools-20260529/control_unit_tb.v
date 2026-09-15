`timescale 1ns/1ps

module control_unit_tb;

    // --- 1. Declarations ---
    reg [7:0] opcode;
    wire RegWrite;
    wire [2:0] ALUOP;
    wire [1:0] Op2Select;

    // --- 2. Instantiate the Unit Under Test (UUT) ---
    control_unit uut (
        .opcode(opcode), 
        .RegWrite(RegWrite), 
        .ALUOP(ALUOP), 
        .Op2Select(Op2Select)
    );

    // --- 3. Stimulus Block ---
    initial begin
        // Setup GTKWave dump files (optional)
        $dumpfile("control_unit_wavedata.vcd");
        $dumpvars(0, control_unit_tb);

        // Print header for console output
        $display("---------------------------------------------------------");
        $display("Time | Opcode | RegWrite | ALUOP | Op2Select | Instruction");
        $display("---------------------------------------------------------");

        // --- Test Case 1: loadi (opcode = 8'h00) ---
        opcode = 8'h00;
        #2; // Wait 2 units for the internal #1 decode delay to settle
        $display("%4d |   %2h   |    %b     |  %3b  |    %2b     | loadi", $time, opcode, RegWrite, ALUOP, Op2Select);

        // --- Test Case 2: mov (opcode = 8'h01) ---
        opcode = 8'h01;
        #2;
        $display("%4d |   %2h   |    %b     |  %3b  |    %2b     | mov", $time, opcode, RegWrite, ALUOP, Op2Select);

        // --- Test Case 3: add (opcode = 8'h02) ---
        opcode = 8'h02;
        #2;
        $display("%4d |   %2h   |    %b     |  %3b  |    %2b     | add", $time, opcode, RegWrite, ALUOP, Op2Select);

        // --- Test Case 4: sub (opcode = 8'h03) ---
        opcode = 8'h03;
        #2;
        $display("%4d |   %2h   |    %b     |  %3b  |    %2b     | sub", $time, opcode, RegWrite, ALUOP, Op2Select);

        // --- Test Case 5: and (opcode = 8'h04) ---
        opcode = 8'h04;
        #2;
        $display("%4d |   %2h   |    %b     |  %3b  |    %2b     | and", $time, opcode, RegWrite, ALUOP, Op2Select);

        // --- Test Case 6: or (opcode = 8'h05) ---
        opcode = 8'h05;
        #2;
        $display("%4d |   %2h   |    %b     |  %3b  |    %2b     | or", $time, opcode, RegWrite, ALUOP, Op2Select);

        $display("---------------------------------------------------------");
        $finish; // End the simulation
    end

endmodule
