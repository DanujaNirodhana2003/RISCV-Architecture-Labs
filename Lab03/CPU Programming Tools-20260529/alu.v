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



module alu(DATA1, DATA2, RESULT, SELECT);       //creating super module (ALU module)
    input [7:0] DATA1 , DATA2 ;                 // assign 8 bit DATA1 and DATA2 as inputs
    input [2:0] SELECT;                         // assign 3 bit SELECT as a input
    output reg [7:0] RESULT;                    //assign 8 bit RESULT as a output

    wire [7:0] add_wire , forward_wire , and_wire, or_wire;         //creating 8 bit wires to carry data internally
    
    add_unit add_gate (DATA1,DATA2, add_wire);              // creating a add module inside ALU
    forward_unit forward_gate (DATA2, forward_wire);        // creating a forward module inside the ALU module
    and_unit and_gate (DATA1,DATA2, and_wire);              //creating a and module inside the ALU
    or_unit or_gate (DATA1,DATA2, or_wire);                 //creating a or module inside ALU

    always @(*) begin                                   //create always block
        case (SELECT)                               //creating a case block to check SELECT and to give the right output
            3'b000 : RESULT = forward_wire;         // if SELECT = 000 then result should be forward function
            3'b001 : RESULT = add_wire;             // if SELECT = 001 then do add function
            3'b010 : RESULT = and_wire;             // if SELECT = 010 then do the and function
            3'b011 : RESULT = or_wire;              // if SELECT = 011 then do or function
            default: RESULT = 8'b00000000;     //add a default as all bits are 0 for safty of the multiplexer
        endcase  
    end
endmodule