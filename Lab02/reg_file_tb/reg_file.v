// Registration numbers  : E/22/054 (Danuja), E/22/058 (Tharuka)
// Lab02 Task 02:  register file.

`timescale 1ns/1ps

module reg_file(
    input [7:0] IN,             // data input to write
    output [7:0] OUT1,          // asynchronous read data output 1 and output 2
    output [7:0] OUT2,             
    input [2:0] INADDRESS,      // register address to write
    input [2:0] OUT1ADDRESS,    // register address to read for OUT1 and OUT2
    input [2:0] OUT2ADDRESS, 
    input WRITE,                // write enable control signal
    input CLK,                  //  clock signal 
    input RESET                 // reset signal for synchronous clear
);

   
    reg [7:0] registers [7:0];    // Represent the 8 registers as eight 8-bit registers

    always @(posedge CLK) begin                 //synchronous to the positive edge of the clock
        if (RESET) begin
            registers[0] <= #1 8'd0;            //clear all 8 registers to zero on clock edge
            registers[1] <= #1 8'd0;
            registers[2] <= #1 8'd0;
            registers[3] <= #1 8'd0;
            registers[4] <= #1 8'd0;
            registers[5] <= #1 8'd0;
            registers[6] <= #1 8'd0;
            registers[7] <= #1 8'd0;
        end else if (WRITE) begin
            registers[INADDRESS] <= #1 IN;      // Synchronously write input data into the specified register
        end
    end

    assign #2 OUT1 = registers[OUT1ADDRESS];        // Reading values from specified registers occurs asynchronously
    assign #2 OUT2 = registers[OUT2ADDRESS];        //update the outputs OUT1 and OUT2 after a delay of #2

endmodule
