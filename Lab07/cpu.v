// CO2070 Computer Architecture- Lab 5 
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

module control_unit (opcode, RegWrite, ALUOP, Op2Select, JUMP, BRANCH, BNE_BRANCH, READ, WRITE);   
    input [7:0] opcode;                 
    output reg RegWrite;                
    output reg [2:0] ALUOP;             
    output reg [1:0] Op2Select;         
    output reg JUMP;                    
    output reg BRANCH;                  
    output reg BNE_BRANCH;              
    // LAB 5 MODIFICATION: Declare 1-bit output reg ports for READ and WRITE
    output reg READ;
    output reg WRITE;


    always @(*) begin
        #1;                             //add a 1 unit timing delay

        RegWrite = 0;                   //set RegWrite as 0 in default 
        ALUOP = 3'b000;                 //set ALUOP as 000 in default
        Op2Select = 2'b00;              //set Op2Select as 00 in default
        JUMP = 0;                       // LAB 04 MODIFICATION: set JUMP to 0 by default
        BRANCH = 0;                     // LAB 04 MODIFICATION: set BRANCH to 0 by default
        BNE_BRANCH = 0;                 // LAB 4.5 MODIFICATION: set BNE_BRANCH to 0 by default
        // LAB 5 MODIFICATION: Set default values for READ and WRITE to 0
        READ = 0;
        WRITE = 0;

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

            // LAB 5 MODIFICATION: LWD instruction (0x08)
            8'h08: begin                
                RegWrite = 1;           // set RegWrite to 1 (because lwd writes data from memory back to a register)
                ALUOP = 3'b000;         // set ALUOP to 000 (FORWARD operation - forwards the address to the output)
                Op2Select = 2'b00;      // set Op2Select to 00 (selects standard Register OUT2 which contains the RS address)
                READ = 1;               // set READ to 1 (to tell data memory to read)
                WRITE = 0;              // set WRITE to 0 
            end

            // LAB 5 MODIFICATION: LWI instruction (0x09)
            8'h09: begin                
                RegWrite = 1;           // set RegWrite to 1 (because lwi writes data from memory back to a register)
                ALUOP = 3'b000;         // set ALUOP to 000 (FORWARD operation)
                Op2Select = 2'b10;      // set Op2Select to 10 (selects immediate value as the memory address)
                READ = 1;               // set READ to 1 
                WRITE = 0;              // set WRITE to 0 
            end

            // LAB 5 MODIFICATION: SWD instruction (0x0A)
            8'h0A: begin                
                RegWrite = 0;           // set RegWrite to 0 (we are writing to memory, not the register file)
                ALUOP = 3'b000;         // set ALUOP to 000 (FORWARD operation)
                Op2Select = 2'b00;      // set Op2Select to 00 (selects standard Register OUT2 which contains the RS address)
                READ = 0;               // set READ to 0 
                WRITE = 1;              // set WRITE to 1 (to tell data memory to write)
            end

            // LAB 5 MODIFICATION: SWI instruction (0x0B)
            8'h0B: begin                
                RegWrite = 0;           // set RegWrite to 0 
                ALUOP = 3'b000;         // set ALUOP to 000 (FORWARD operation)
                Op2Select = 2'b10;      // set Op2Select to 10 (selects immediate value as the memory address)
                READ = 0;               // set READ to 0 
                WRITE = 1;              // set WRITE to 1 
            end

        endcase
    end
endmodule

module negator (in_val, out_val);       //create negator module
    input [7:0] in_val;                 //make in_val as a 8-bit input port
    output [7:0] out_val;               //make a out_val as 8-bit output port

    assign #1 out_val = ~in_val + 8'h01;        //assign the 2's complement negative of in_val to out_val after a delay of 1 time unit
endmodule

// LAB 6 MODIFICATION: Cache integrated inside CPU.
// The byte-level data memory signals (READ/WRITE/ADDRESS/WRITEDATA/READDATA/BUSYWAIT)
// are now INTERNAL wires connected to the data_cache instantiation below.
// The CPU module now exposes only the BLOCK-LEVEL memory interface to the testbench.
module cpu (PC, INSTRUCTION, CLK, RESET,
            mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait, inst_busywait);

    output [31:0] PC;                       // Program Counter output
    input  [31:0] INSTRUCTION;              // Instruction from instruction memory
    input         CLK, RESET;

    // LAB 6 MODIFICATION: Block-level memory interface (cache → data_memory_lab6)
    output        mem_read;
    output        mem_write;
    output [5:0]  mem_address;
    output [31:0] mem_writedata;
    input  [31:0] mem_readdata;
    input         mem_busywait;
    input         inst_busywait; // Added for Instruction Cache

    // LAB 6 MODIFICATION: Internal byte-level wires between CPU logic and data_cache
    wire       READ, WRITE;
    wire [7:0] ADDRESS, WRITEDATA;
    wire [7:0] READDATA;
    wire       BUSYWAIT;
    
    // (INSTRUCTION and CLK/RESET already declared in module port list above)

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
    
    // Wires and logic for Data Memory
    wire [7:0] reg_write_data;
    
    assign ADDRESS = alu_result;
    assign WRITEDATA = out1;
    assign reg_write_data = (READ == 1'b1) ? READDATA : alu_result;
    
    //  PC STALL logic
    wire [31:0] stalled_pc_in;
    
    assign stalled_pc_in = (BUSYWAIT == 1'b1 || inst_busywait == 1'b1) ? PC : pc_next_final;

    assign #1 pc_next = PC + 32'h4;         // Increment PC by 4 to point to the next instruction (assuming 4-byte instruction width)

    
    // Shift offset (bits 23:16) left by 2 and sign-extend, then add to pc_next
    assign #2 pc_target = pc_next + {{22{INSTRUCTION[23]}}, INSTRUCTION[23:16], 2'b00};

    // LAB 4.5 MODIFICATION: PC Source Multiplexer (Updated for BNE)
    assign pc_next_final = (jump | (branch & zero) | (bne_branch & ~zero)) ? pc_target : pc_next;

        
    //for decode simulation, we will add a 1-unit delay to the immediate value extraction from the instruction
    wire [7:0] immediate_val;
    assign #1 immediate_val = INSTRUCTION[7:0]; // Add 1-unit delay to simulate Decode extraction time

    // Operand 2 multiplexer (Op2Select)
    assign alu_in2 = (op2_select == 2'b00) ? out2 :                 // if op2_select is 00, select out2
                 (op2_select == 2'b01) ? out2_neg :                 // if op2_select is 01, select out2_neg
                 (op2_select == 2'b10) ? immediate_val :            // if op2_select is 10, select the delayed immediate value
                 8'h00;                                         // if op2_select is anything else, select 8'h00 (default case)

   

    // LAB 5 MODIFICATION: Update pc_reg_inst connection to support the STALL logic
    pc_register pc_reg_inst (.clk(CLK), .reset(RESET), .pc_in(stalled_pc_in), .pc_out(PC));       

    // LAB 5 MODIFICATION: Update cu_inst to connect your new READ and WRITE output wires
    control_unit cu_inst (.opcode(INSTRUCTION[31:24]), .RegWrite(reg_write), .ALUOP(alu_op), .Op2Select(op2_select), .JUMP(jump), .BRANCH(branch), .BNE_BRANCH(bne_branch), .READ(READ), .WRITE(WRITE));       

    reg_file rf_inst (                      //initiate the reg_file module with instance name rf_inst and connect the ports accordingly
        .IN(reg_write_data),                // LAB 5 MODIFICATION: changed from alu_result to reg_write_data
        .OUT1(out1),
        .OUT2(out2),
        .INADDRESS(INSTRUCTION[18:16]),
        .OUT1ADDRESS(INSTRUCTION[10:8]),
        .OUT2ADDRESS(INSTRUCTION[2:0]),
        .WRITE(reg_write),
        .CLK(CLK),
        .RESET(RESET)
    );

    negator neg_inst (.in_val(out2), .out_val(out2_neg));       //instantiate the 'negator' module

    alu alu_inst (.DATA1(out1), .DATA2(alu_in2), .RESULT(alu_result), .ZERO(zero), .SELECT(alu_op));

    // LAB 6 MODIFICATION: Instantiate data_cache inside CPU.
    // CPU's internal byte-level signals connect to cache CPU-side ports.
    // Cache memory-side ports are wired to cpu module's output ports (mem_*).
    data_cache cache_inst (
        .CLK          (CLK),
        .RESET        (RESET),
        .READ         (READ),
        .WRITE        (WRITE),
        .ADDRESS      (ADDRESS),
        .WRITEDATA    (WRITEDATA),
        .READDATA     (READDATA),
        .BUSYWAIT     (BUSYWAIT),
        .mem_read     (mem_read),
        .mem_write    (mem_write),
        .mem_address  (mem_address),
        .mem_writedata(mem_writedata),
        .mem_readdata (mem_readdata),
        .mem_busywait (mem_busywait)
    );

endmodule

// LAB 6 MODIFICATION: Data Cache module definition.
module data_cache (
    // Clock and Reset inputs from system.
    input             CLK,       // Lab 6: Connect to system clock signal.
    input             RESET,     // Lab 6: Connect to system reset signal.

    // CPU side ports (same interface as Lab 5 byte data memory).
    input             READ,      // Lab 6: Read control signal from control unit.
    input             WRITE,     // Lab 6: Write control signal from control unit.
    input      [7:0]  ADDRESS,   // Lab 6: 8-bit memory address from ALU.
    input      [7:0]  WRITEDATA, // Lab 6: 8-bit data to write from Register File.
    output reg [7:0]  READDATA,  // Lab 6: 8-bit data read back sent to Register File.
    output reg        BUSYWAIT,  // Lab 6: Busywait signal to stall CPU execution.

    // Memory side ports (block interface to block data memory).
    output reg        mem_read,      // Lab 6: Read request block signal to memory.
    output reg        mem_write,     // Lab 6: Write request block signal to memory.
    output reg [5:0]  mem_address,   // Lab 6: 6-bit block address to memory.
    output reg [31:0] mem_writedata, // Lab 6: 32-bit data block to write to memory.
    input      [31:0] mem_readdata,  // Lab 6: 32-bit data block read from memory.
    input             mem_busywait   // Lab 6: Busywait signal feedback from memory.
);

    // Cache size parameters.
    localparam OFFSET_BITS = 2;   // Lab 6: Offset is 2 bits (4 bytes per block).
    localparam INDEX_BITS  = 3;   // Lab 6: Index is 3 bits (8 lines in cache).
    localparam TAG_BITS    = 3;   // Lab 6: Tag is 3 bits (remains of 8-bit address).
    localparam NUM_LINES   = 8;   // Lab 6: 8 lines total in direct-mapped cache.

    // Split 8-bit address.
    wire [OFFSET_BITS-1:0] offset = ADDRESS[OFFSET_BITS-1:0];           // Lab 6: Extract bits [1:0] for offset.
    wire [INDEX_BITS -1:0] index  = ADDRESS[OFFSET_BITS +: INDEX_BITS]; // Lab 6: Extract bits [4:2] for index.
    wire [TAG_BITS   -1:0] tag    = ADDRESS[7:5];                        // Lab 6: Extract bits [7:5] for tag.

    // Cache arrays.
    reg                  valid_array [0:NUM_LINES-1]; // Lab 6: Array for valid bit of each line.
    reg                  dirty_array [0:NUM_LINES-1]; // Lab 6: Array for dirty bit of each line.
    reg [TAG_BITS-1:0]   tag_array   [0:NUM_LINES-1]; // Lab 6: Array to store tags for each line.
    reg [31:0]           data_array  [0:NUM_LINES-1]; // Lab 6: Array to store 32-bit block for each line.

    // Array output registers.
    reg                cached_valid;                 // Holds valid bit of the indexed line.
    reg                cached_dirty;                 //  Holds dirty bit of the indexed line.
    reg [TAG_BITS-1:0] cached_tag;                  // Holds tag of the indexed line.
    reg [31:0]         cached_block;                // Lab 6: Holds data block of the indexed line.

    // Index arrays. Delay of 1.
    always @(*) begin //  Trigger on any signal change.
        #1;   // Wait 1 time unit to model array lookup delay.
        cached_valid = valid_array[index]; //Read valid bit.
        cached_dirty = dirty_array[index]; //Read dirty bit.
        cached_tag   = tag_array  [index]; //Read tag value.
        cached_block = data_array [index]; //Read data block.
    end // End of block.

    // Check for hit. Delay of 0.9.
    reg hit;  //Register for hit signal.
    reg miss; //Register for miss signal.
    always @(*) begin //Trigger on any signal change.
        #0.9; // Wait 0.9 time units for tag comparison delay.
        if (cached_valid === 1'b1 && cached_tag == tag) begin // Lab 6: If valid and tag matches.
            hit  = 1'b1;  // Set hit high.
            miss = 1'b0;  // Set miss low.
        end else begin //  Else (miss).
            hit  = 1'b0;  //  Set hit low.
            miss = 1'b1;  // Set miss high.
        end // End of if-else.
    end // End of block.

    // Select word by offset. Delay of 1.
    reg [7:0] selected_byte; // Register to hold selected byte.
    always @(*) begin // Trigger on any signal change.
        #1;  // Wait 1 time unit for offset multiplexer delay.
        case (offset) // Check offset value.
            2'b00: selected_byte = cached_block[7:0];   // Select byte 0.
            2'b01: selected_byte = cached_block[15:8];  // Select byte 1.
            2'b10: selected_byte = cached_block[23:16]; // Select byte 2.
            2'b11: selected_byte = cached_block[31:24]; // Select byte 3.
            default: selected_byte = 8'hxx;             // Default to undefined.
        endcase // Lab 6: End of case.
    end // Lab 6: End of block.

    // Send read data on hit.
    always @(*) begin                       // Trigger on any signal change.
        if (READ && hit)                    // If read is requested and hit is true.
            READDATA = selected_byte;           // Output selected word.
        else                                // Else.
            READDATA = 8'hxx;               // Output undefined.
    end // End of block.

    // State machine parameters.
    parameter IDLE            = 3'b000; // Lab 6: Parameter for IDLE state.
    parameter MEM_READ        = 3'b001; // Lab 6: Parameter for MEM_READ state.
    parameter WRITE_BACK      = 3'b010; // Lab 6: Parameter for WRITE_BACK state.
    parameter WRITE_BACK_DONE = 3'b011; // Lab 6: Parameter for WRITE_BACK_DONE state.   
    parameter MEM_READ_START  = 3'b100; // Lab 6: Parameter for MEM_READ_START state.   

    reg [2:0] state;      // Lab 6: Register for current FSM state.
    reg [2:0] next_state; // Lab 6: Register for next FSM state.

    // Track if memory busy was seen.
    reg mem_busy_seen; // Lab 6: Tracks if memory busywait went high.

    // Next state logic.
    always @(*) begin // Lab 6: Trigger on state or request changes.
        case (state) // Lab 6: Check current state.
            IDLE: begin // Lab 6: In IDLE state.
                if ((READ || WRITE) && miss && !cached_dirty) // Lab 6: If clean miss.
                    next_state = MEM_READ_START;   // Lab 6: Transition to MEM_READ_START.
                else if ((READ || WRITE) && miss && cached_dirty) // Lab 6: If dirty miss.
                    next_state = WRITE_BACK;        // Lab 6: Transition to WRITE_BACK.
                else // Lab 6: Else.
                    next_state = IDLE;              // Lab 6: Stay in IDLE.
            end // Lab 6: End of IDLE.

            MEM_READ_START: begin // Lab 6: In MEM_READ_START.
                next_state = MEM_READ;  // Lab 6: Transition to MEM_READ.
            end // Lab 6: End of MEM_READ_START.

            MEM_READ: begin // Lab 6: In MEM_READ.
                if (mem_busy_seen && !mem_busywait) // Lab 6: If memory complete.
                    next_state = IDLE;   // Lab 6: Transition back to IDLE.
                else // Lab 6: Else.
                    next_state = MEM_READ; // Lab 6: Stay in MEM_READ.
            end // Lab 6: End of MEM_READ.

            WRITE_BACK: begin // Lab 6: In WRITE_BACK.
                if (mem_busy_seen && !mem_busywait) // Lab 6: If write back complete.
                    next_state = WRITE_BACK_DONE;   // Lab 6: Transition to WRITE_BACK_DONE.
                else // Lab 6: Else.
                    next_state = WRITE_BACK; // Lab 6: Stay in WRITE_BACK.
            end // Lab 6: End of WRITE_BACK.

            WRITE_BACK_DONE: begin // Lab 6: In WRITE_BACK_DONE.
                next_state = MEM_READ;  // Lab 6: Transition to MEM_READ.
            end // Lab 6: End of WRITE_BACK_DONE.

            default: next_state = IDLE; // Lab 6: Default to IDLE.
        endcase // Lab 6: End of case.
    end // Lab 6: End of block.

    // Output logic.
    always @(*) begin // Lab 6: Trigger on state or variable changes.
        case (state) // Lab 6: Check current state.

            IDLE: begin // Lab 6: In IDLE state.
                mem_read      = 1'b0;  // Lab 6: Hold memory read low.
                mem_write     = 1'b0;  // Lab 6: Hold memory write low.
                mem_address   = 6'bx;  // Lab 6: Set block address to undefined.
                mem_writedata = 32'bx; // Lab 6: Set write data to undefined.
                BUSYWAIT      = (READ || WRITE) && miss; // Lab 6: Set busywait high on miss.
            end // Lab 6: End of IDLE.

            MEM_READ_START: begin // Lab 6: In MEM_READ_START.
                mem_read      = 1'b1;          // Assert memory read.
                mem_write     = 1'b0;          // Hold memory write low.
                mem_address   = {tag, index};  // Output block address.
                mem_writedata = 32'bx;         // Set write data to undefined.
                BUSYWAIT      = 1'b1;          // Assert busywait.
            end // Lab 6: End of MEM_READ_START.

            MEM_READ: begin // Lab 6: In MEM_READ.
                mem_read      = 1'b1;          // Keep memory read high.
                mem_write     = 1'b0;          // Keep memory write low.
                mem_address   = {tag, index};  // Output block address.
                mem_writedata = 32'bx;         // Keep write data undefined.
                BUSYWAIT      = 1'b1;          // Keep busywait high.
            end // Lab 6: End of MEM_READ.

            WRITE_BACK: begin // Lab 6: In WRITE_BACK.
                mem_read      = 1'b0;                 // Keep memory read low.
                mem_write     = 1'b1;                 // Assert memory write.
                mem_address   = {cached_tag, index};  // Output block address of evicted tag.
                mem_writedata = cached_block;         // Output evicted data block.
                BUSYWAIT      = 1'b1;                 // Keep busywait high.
            end // Lab 6: End of WRITE_BACK.

            WRITE_BACK_DONE: begin                  // In WRITE_BACK_DONE.
                mem_read      = 1'b1;               // Assert memory read.
                mem_write     = 1'b0;               // Hold memory write low.
                mem_address   = {tag, index};       // Output block address of new tag.           
                mem_writedata = 32'bx;              // Set write data block to undefined.
                BUSYWAIT      = 1'b1;               // Keep busywait high.
            end // Lab 6: End of WRITE_BACK_DONE.

            default: begin // Lab 6: Default state.
                mem_read      = 1'b0;  // Lab 6: Hold memory read low.
                mem_write     = 1'b0;  // Lab 6: Hold memory write low.
                mem_address   = 6'bx;  // Lab 6: Set block address to undefined.
                mem_writedata = 32'bx; // Lab 6: Set write data block to undefined.
                BUSYWAIT      = 1'b0;  // Lab 6: Hold busywait low.
            end // Lab 6: End of default.

        endcase // Lab 6: End of case.
    end // Lab 6: End of block.

    // Clock edge logic.
    integer j; // Lab 6: Loop variable.

    always @(posedge CLK, posedge RESET) begin // Lab 6: Trigger on CLK posedge or RESET posedge.

        if (RESET) begin // Lab 6: If reset is high.
            state         <= IDLE; // Lab 6: Reset state to IDLE.
            mem_busy_seen <= 1'b0; // Lab 6: Clear memory busy wait tracking.
            for (j = 0; j < NUM_LINES; j = j + 1) begin // Lab 6: Clear all cache arrays.
                valid_array[j] <= 1'b0; // Lab 6: Set valid to 0.
                dirty_array[j] <= 1'b0; // Lab 6: Set dirty to 0.
                tag_array  [j] <= {TAG_BITS{1'b0}}; // Lab 6: Set tag to 0.
                data_array [j] <= 32'h0; // Lab 6: Set block data to 0.
            end // Lab 6: End of loop.

        end else begin // Lab 6: Else.
            state <= next_state; // Lab 6: Transition state.

            // Track memory busy wait.
            if (state == IDLE || state == MEM_READ_START || state == WRITE_BACK_DONE) // Lab 6: If in startup states.
                mem_busy_seen <= 1'b0; // Lab 6: Reset tracking.
            else if ((state == MEM_READ || state == WRITE_BACK) && mem_busywait) // Lab 6: If memory asserts busywait.
                mem_busy_seen <= 1'b1; // Lab 6: Set tracking high.

            // Write block from memory to cache.
            if (state == MEM_READ && !mem_busywait) begin // Lab 6: On memory access done.
                #1;  // Lab 6: Wait 1 time unit to simulate cache write delay.
                data_array [index] <= mem_readdata; // Lab 6: Write block to array.
                tag_array  [index] <= tag;          // Lab 6: Write tag to array.
                valid_array[index] <= 1'b1;         // Lab 6: Set valid bit to 1.
                dirty_array[index] <= 1'b0;         // Lab 6: Set dirty bit to 0.
            end // Lab 6: End of block write.

            // Write data from CPU to cache.
            if (state == IDLE && WRITE && hit) begin // Lab 6: On CPU write hit.
                #1;  // Lab 6: Wait 1 time unit to simulate cache write delay.
                case (offset) // Lab 6: Check offset.
                    2'b00: data_array[index][7:0]   <= WRITEDATA; // Lab 6: Write to byte 0.
                    2'b01: data_array[index][15:8]  <= WRITEDATA; // Lab 6: Write to byte 1.
                    2'b10: data_array[index][23:16] <= WRITEDATA; // Lab 6: Write to byte 2.
                    2'b11: data_array[index][31:24] <= WRITEDATA; // Lab 6: Write to byte 3.
                endcase // Lab 6: End of case.
                dirty_array[index] <= 1'b1; // Lab 6: Set dirty bit to 1.
            end // Lab 6: End of write hit.

        end // Lab 6: End of if-else.
    end // Lab 6: End of block.

endmodule // Lab 6 MODIFICATION: End of data_cache module definition.


