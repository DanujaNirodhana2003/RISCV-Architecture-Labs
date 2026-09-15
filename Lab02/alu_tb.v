//Registration numbers : E/22/054 (Danuja), E/22/058 (Tharuka)
//Lab02 Task 01 : AlU module test bench
`timescale 1ns/1ps //set simulater time 1ns - the unit of mesurement   1ps - the percision

module alu_tb;
    
    reg [7:0] DATA1;        // declare inputs to the ALU as reg (registers) 
    reg [7:0] DATA2;
    reg [2:0] SELECT;

    
    wire [7:0] RESULT;      // declare outputs from the ALU as wire 

   
    alu my_alu (            //previouse created ALU link to the test bench
        .DATA1(DATA1),
        .DATA2(DATA2),
        .RESULT(RESULT),        // .DATA is the alu ports (defined alu)
        .SELECT(SELECT)         //  (    )  is testbench wire
    );

    
    initial begin               //simulation Procedure
        
        $dumpfile("alu_wave.vcd");      // generate the VCD waveform file for GTKWave
        $dumpvars(0, alu_tb);           //Start recording everything in this testbench

        
        $display("-----------------------------------------------------------------");
        $display("Time\tSELECT\tDATA1\t\tDATA2\t\tRESULT (Expected)");
        $display("-----------------------------------------------------------------");

        // Monitor signal changes automatically in the terminal
        $monitor("%0dns\t%b\t%d (8'b%b)\t%d (8'b%b)\t%d (8'b%b)", 
                 $time, SELECT, DATA1, DATA1, DATA2, DATA2, RESULT, RESULT);

        
        DATA1 = 8'd45; DATA2 = 8'd99; SELECT = 3'b000;     //case 01 forward case
        #10;                    //wait 10 unit times

        DATA1 = 8'd10; DATA2 = 8'd20; SELECT = 3'b001;      //Add case 
        #10;                    //wait 10 unit times

        DATA1 = 8'b10101010; DATA2 = 8'b11001100; SELECT = 3'b010;      //AND case 
        #10;                    //wait 10 unit times

        DATA1 = 8'b10101010; DATA2 = 8'b11001100; SELECT = 3'b011;      // OR case
        #10;                    //wait 10 unit times

        DATA1 = 8'd50; DATA2 = 8'd80; SELECT = 3'b100;          //case default Operation (SELECT as 100)
        #10;                    //wait 10 unit times

        $display("-----------------------------------------------------------------");
        $display("Simulation successfully complete!");
        $finish;                            // ended] the simulation
    end
endmodule