//Registration numbers : E/22/054 (Danuja), E/22/058 (Tharuka)
//Lab02 Task 01 : AlU module 
`timescale 1ns/1ps  //1ns - the unit of mesurement   1ps - the percision

module add_unit (A,B,Add_result);       //creating add module
    input [7:0] A,B ;                   // get input A and B as 8 bit  
    output [7:0] Add_result;            // assign output Add_result as 8 bit 
    assign  #2 Add_result = A+B;        //assigning add_result as A+B after 2 time unit
endmodule

module forward_unit (A , forward_result);       //creating forward module
    input [7:0] A;                              
    output [7:0] forward_result;
    assign #1 forward_result = A;               //forward A to forward_result after 1 time unit 
endmodule

module and_unit (A,B,And_result);               // creating add module
    input [7:0] A,B ;                       
    output [7:0] And_result;
    assign  #1 And_result = A & B;              //assign A and B as And_module after 1 time unit
endmodule

module or_unit (A,B,or_result);                 //creating or module 
    input [7:0] A,B ;
    output [7:0] or_result;
    assign  #1 or_result = A | B;               //assign A or B as or_result after 1 time unit
endmodule

// LAB 4.5 MODIFICATION: Custom Logical Shift Left module (sll)
// Implemented as a hardware barrel shifter without using the << operator
module shift_left_unit (A, SHIFT, OUT);
    input [7:0] A;
    input [7:0] SHIFT;
    output [7:0] OUT;
    
    wire [7:0] s0, s1, s2;
    // stage 0: shift by 1 if bit 0 is set
    assign s0 = SHIFT[0] ? {A[6:0], 1'b0} : A;
    // stage 1: shift by 2 if bit 1 is set
    assign s1 = SHIFT[1] ? {s0[5:0], 2'b00} : s0;
    // stage 2: shift by 4 if bit 2 is set
    assign s2 = SHIFT[2] ? {s1[3:0], 4'b0000} : s1;
    // Final check: if shift amount is greater than 7, output is all zeros
    assign #1 OUT = (SHIFT[7:3] != 5'b00000) ? 8'b00000000 : s2;
endmodule



module alu(DATA1, DATA2, RESULT, ZERO, SELECT); // LAB 04 MODIFICATION: added ZERO port
    input [7:0] DATA1 , DATA2 ;                 // assign 8 bit DATA1 and DATA2 as inputs
    input [2:0] SELECT;                         // assign 3 bit SELECT as a input
    output reg [7:0] RESULT;                    //assign 8 bit RESULT as a output
    output ZERO;                                // LAB 04 MODIFICATION: ZERO flag output

    wire [7:0] add_wire , forward_wire , and_wire, or_wire, sll_wire; // LAB 4.5 MODIFICATION: added sll_wire
    
    // LAB 04 MODIFICATION: Set ZERO to 1 if RESULT is exactly 0
    assign ZERO = (RESULT == 8'b00000000) ? 1'b1 : 1'b0;
    
    add_unit add_gate (DATA1,DATA2, add_wire);              // creating a add module inside ALU
    forward_unit forward_gate (DATA2, forward_wire);        // creating a forward module inside the ALU module
    and_unit and_gate (DATA1,DATA2, and_wire);              //creating a and module inside the ALU
    or_unit or_gate (DATA1,DATA2, or_wire);                 //creating a or module inside ALU
    shift_left_unit sll_gate (DATA1, DATA2, sll_wire);      // LAB 4.5 MODIFICATION: instantiate custom barrel shifter

    always @(*) begin                                   //create always block
        case (SELECT)                               //creating a case block to check SELECT and to give the right output
            3'b000 : RESULT = forward_wire;         // if SELECT = 000 then result should be forward function
            3'b001 : RESULT = add_wire;             // if SELECT = 001 then do add function
            3'b010 : RESULT = and_wire;             // if SELECT = 010 then do the and function
            3'b011 : RESULT = or_wire;              // if SELECT = 011 then do or function
            3'b100 : RESULT = sll_wire;             // LAB 4.5 MODIFICATION: if SELECT = 100 then do sll function
            default: RESULT = 8'b00000000;     //add a default as all bits are 0 for safty of the multiplexer
        endcase  
    end
endmodule