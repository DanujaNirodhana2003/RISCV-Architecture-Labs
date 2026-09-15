// CO2070 Computer Architecture- Lab 3 
//Registration numbers : E/22/054 (Danuja), E/22/058 (Tharuka)


`timescale 1ns/1ps  //1ns - the unit of mesurement   1ps - the percision

module pc_register (clk,reset,pc_in,pc_out);       //creating pc register module
    input clk, reset;                
    input [31:0] pc_in;            
    output reg [31:0] pc_out;        

    always @(posedge clk) begin
        if (reset) begin
            #1 pc_out <= 32'h0;    // Reset back to address 0 after 1 time unit
        end else begin
            #1 pc_out <= pc_in;    // Load next instruction address after 1 time unit
        end
    end

endmodule

module control_unit (opcode, RegWrite, ALUOP, Op2Select, JUMP, BRANCH, BNE_BRANCH);   // LAB 4.5 MODIFICATION: added BNE_BRANCH port
    input [7:0] opcode;                 //declare opcode as 8 bit input port
    output reg RegWrite;                //decleare RegWrite as output reg port
    output reg [2:0] ALUOP;             //declare ALUOP as a 3-bit output reg port
    output reg [1:0] Op2Select;         //declare Op2Select as a 2-bit output reg port
    output reg JUMP;                    // LAB 04 MODIFICATION: JUMP control signal
    output reg BRANCH;                  // LAB 04 MODIFICATION: BRANCH control signal
    output reg BNE_BRANCH;              // LAB 4.5 MODIFICATION: BNE_BRANCH control signal

    always @(*) begin
        #1;                             //add a 1 unit timing delay

        RegWrite = 0;                   //set RegWrite as 0 in default 
        ALUOP = 3'b000;                 //set ALUOP as 000 in default
        Op2Select = 2'b00;              //set Op2Select as 00 in default
        JUMP = 0;                       // LAB 04 MODIFICATION: set JUMP to 0 by default
        BRANCH = 0;                     // LAB 04 MODIFICATION: set BRANCH to 0 by default
        BNE_BRANCH = 0;                 // LAB 4.5 MODIFICATION: set BNE_BRANCH to 0 by default

        case (opcode)                   //start a case to check opcode value

            8'h00: begin                // if opcode is 8'h00,          //load immediate
                RegWrite = 1;           //set RegWrite to 1 (because loadi writes back to a register)
                ALUOP = 3'b000;         // set ALUOP to 000 (FORWARD)
                Op2Select = 2'b10;      // set Op2Select to 10 (selects immediate value field [7:0])
            end
                
            8'h01: begin                //if opcode is 8'h01,           //MOV instruction
                RegWrite = 1;           //set RegWrite to 1 (because mov writes back to a register)
                ALUOP = 3'b000;         // set ALUOP to 000 (FORWARD)
                Op2Select = 2'b00;      // set Op2Select to 00 (selects standard Register OUT2)
            end
            
            8'h02: begin                //if opcode is 8'h02,           //ADD
                RegWrite = 1;           //set RegWrite to 1 (because add writes back to a register)
                ALUOP = 3'b001;         // set ALUOP to 001 (ADD operation)
                Op2Select = 2'b00;      // set Op2Select to 00 (selects standard Register OUT2)
            end
            
            8'h03: begin                //if opcode is 8'h03,            //SUB
                RegWrite = 1;           //set RegWrite to 1 (because sub writes back to a register)
                ALUOP = 3'b001;         // set ALUOP to 001 (ADD operation - computes OUT1 + (-OUT2))
                Op2Select = 2'b01;      // set Op2Select to 01 (selects 2's Complement negated Register OUT2)
            end

            8'h04: begin                //if opcode is 8'h04,           //AND
                RegWrite = 1;           //set RegWrite to 1 (because and writes back to a register)
                ALUOP = 3'b010;         // set ALUOP to 010 (AND operation)
                Op2Select = 2'b00;      // set Op2Select to 00 (selects standard Register OUT2)    
            end
            
            8'h05: begin                //if opcode is 8'h05,           //OR    
                RegWrite = 1;           //set RegWrite to 1 (because or writes back to a register)
                ALUOP = 3'b011;         // set ALUOP to 011 (OR operation)
                Op2Select = 2'b00;      // set Op2Select to 00 (selects standard Register OUT2)
            end

            8'h06: begin                // LAB 04 MODIFICATION: J instruction (0x06)
                JUMP = 1;               // set JUMP to 1
                // RegWrite=0, ALUOP=0, Op2Select=0 by default
            end
            
            8'h07: begin                // LAB 04 MODIFICATION: BEQ instruction (0x07)
                BRANCH = 1;             // set BRANCH to 1
                ALUOP = 3'b001;         // set ALUOP to 001 (ADD operation - computes OUT1 + (-OUT2))
                Op2Select = 2'b01;      // set Op2Select to 01 (selects 2's Complement negated Register OUT2 to perform subtraction)
            end

            8'h0C: begin                // LAB 4.5 MODIFICATION: BNE instruction (0x0C)
                BNE_BRANCH = 1;         // set BNE_BRANCH to 1
                ALUOP = 3'b001;         // set ALUOP to 001 (ADD operation - computes OUT1 + (-OUT2))
                Op2Select = 2'b01;      // set Op2Select to 01 (selects 2's Complement negated Register OUT2 to perform subtraction)
            end

            8'h0D: begin                // LAB 4.5 MODIFICATION: SLL instruction (0x0D)
                RegWrite = 1;           // set RegWrite to 1 (because sll writes back to a register)
                ALUOP = 3'b100;         // set ALUOP to 100 (SLL operation)
                Op2Select = 2'b10;      // set Op2Select to 10 (selects immediate value as shift amount)
            end

        endcase
    end
endmodule

module negator (in_val, out_val);       //create negator module
    input [7:0] in_val;                 //make in_val as a 8-bit input port
    output [7:0] out_val;               //make a out_val as 8-bit output port

    assign #1 out_val = ~in_val + 8'h01;        //assign the 2's complement negative of in_val to out_val after a delay of 1 time unit
endmodule

module cpu (PC, INSTRUCTION, CLK, RESET);
    
    output [31:0] PC;                       // Declare PC as a 32-bit output wire port (drives the Program Counter output)
    
    input [31:0] INSTRUCTION;               //  Declare INSTRUCTION as a 32-bit input port (carries the instruction from memory)
    
    input CLK, RESET;                       //  Declare CLK and RESET as 1-bit input ports

    // --- INTERNAL WIRE DECLARATIONS ---
    
    wire [31:0] pc_next;                    // Declare a 32-bit wire named 'pc_next'
    
    wire reg_write;                         // Declare a 1-bit wire named 'reg_write'
    
    wire [2:0] alu_op;                      // Declare a 3-bit wire named 'alu_op'
    
    wire [1:0] op2_select;                  // Declare a 2-bit wire named 'op2_select'
    
    wire [7:0] out1;                        // Declare an 8-bit wire named 'out1'
    
    wire [7:0] out2;                        // Declare an 8-bit wire named 'out2'
   
    wire [7:0] out2_neg;                    // Declare an 8-bit wire named 'out2_neg'
    
    wire [7:0] alu_in2;                     //  Declare an 8-bit wire named 'alu_in2'
    
    wire [7:0] alu_result;                  // Declare an 8-bit wire named 'alu_result'

    wire [31:0] pc_target;                  // LAB 04 MODIFICATION: Declare wire for branch/jump target address
    
    wire [31:0] pc_next_final;              // LAB 04 MODIFICATION: Declare wire for final PC value to load
    
    wire jump, branch, zero, bne_branch;    // LAB 4.5 MODIFICATION: added bne_branch wire

    
    assign #1 pc_next = PC + 32'h4;         // Increment PC by 4 to point to the next instruction (assuming 4-byte instruction width)

    
    // Shift offset (bits 23:16) left by 2 and sign-extend, then add to pc_next
    assign #2 pc_target = pc_next + {{22{INSTRUCTION[23]}}, INSTRUCTION[23:16], 2'b00};

    // LAB 4.5 MODIFICATION: PC Source Multiplexer (Updated for BNE)
    assign pc_next_final = (jump | (branch & zero) | (bne_branch & ~zero)) ? pc_target : pc_next;

    assign alu_in2 = (op2_select == 2'b00) ? out2 :                 // if op2_select is 00, select out2
                 (op2_select == 2'b01) ? out2_neg :                 // if op2_select is 01, select out2_neg
                 (op2_select == 2'b10) ? INSTRUCTION[7:0] :         // if op2_select is 10, select the immediate value from instruction[7:0]
                 8'h00;                                         // if op2_select is anything else, select 8'h00 (default case)

   

    pc_register pc_reg_inst (.clk(CLK), .reset(RESET), .pc_in(pc_next_final), .pc_out(PC));       // LAB 04 MODIFICATION: changed pc_in to pc_next_final

    control_unit cu_inst (.opcode(INSTRUCTION[31:24]), .RegWrite(reg_write), .ALUOP(alu_op), .Op2Select(op2_select), .JUMP(jump), .BRANCH(branch), .BNE_BRANCH(bne_branch));       // LAB 4.5 MODIFICATION: added BNE_BRANCH

    reg_file rf_inst (                      //initiate the reg_file module with instance name rf_inst and connect the ports accordingly
        .IN(alu_result),
        .OUT1(out1),
        .OUT2(out2),
        .INADDRESS(INSTRUCTION[18:16]),
        .OUT1ADDRESS(INSTRUCTION[10:8]),
        .OUT2ADDRESS(INSTRUCTION[2:0]),
        .WRITE(reg_write),
        .CLK(CLK),
        .RESET(RESET)
    );

    negator neg_inst (.in_val(out2), .out_val(out2_neg));       //instantiate the 'negator' module with instance name neg_inst and connect the ports accordingly

    alu alu_inst (.DATA1(out1), .DATA2(alu_in2), .RESULT(alu_result), .ZERO(zero), .SELECT(alu_op));     // LAB 04 MODIFICATION: added ZERO connection

endmodule


