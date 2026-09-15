// Computer Architecture (CO2070) - Lab 07
// Design: Testbench of Integrated CPU with Instruction Cache
// Author: Auto-Generated

`timescale 1ns/100ps  // Set timescale unit to 1ns and precision to 100ps.

module cpu_tb; // Declare the testbench module cpu_tb.

    reg CLK;        // Register for system clock signal.
    reg RESET;      // Register for system reset signal.
    wire [31:0] PC;          // 32-bit wire for program counter value.
    wire [31:0] INSTRUCTION; // 32-bit wire for fetched instruction.
    
    // Wires to interface with data memory
    wire mem_read;      
    wire mem_write;     
    wire mem_busywait;  
    wire [5:0] mem_address;          
    wire [31:0] mem_writedata;       
    wire [31:0] mem_readdata;        

    // Wires to interface with instruction memory and cache
    wire inst_mem_read;
    wire [5:0] inst_mem_address;
    wire [127:0] inst_mem_readdata;
    wire inst_mem_busywait;
    wire inst_busywait;
    
    /* 
    ------------------------
     INSTRUCTION MEMORY & CACHE
    ------------------------
    */
    instruction_memory myinstmem(
        .clock(CLK),
        .read(inst_mem_read),
        .address(inst_mem_address),
        .readinst(inst_mem_readdata),
        .busywait(inst_mem_busywait)
    );
    
    instruction_cache myicache(
        .CLK(CLK),
        .RESET(RESET),
        .PC(PC[9:0]),
        .INSTRUCTION(INSTRUCTION),
        .BUSYWAIT(inst_busywait),
        .mem_read(inst_mem_read),
        .mem_address(inst_mem_address),
        .mem_readdata(inst_mem_readdata),
        .mem_busywait(inst_mem_busywait)
    );

    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(
        PC,            // Connect PC wire to CPU.
        INSTRUCTION,   // Connect instruction wire to CPU.
        CLK,           // Connect CLK register to CPU.
        RESET,         // Connect RESET register to CPU.
        mem_read,      // Connect memory read request wire to CPU.
        mem_write,     // Connect memory write request wire to CPU.
        mem_address,   // Connect memory block address wire to CPU.
        mem_writedata, // Connect memory write block wire to CPU.
        mem_readdata,  // Connect memory read block wire to CPU.
        mem_busywait,  // Connect memory busywait wire to CPU.
        inst_busywait  // Connect instruction cache busywait to CPU.
    );

    // Instantiate data_memory (from lab6) and connect it to the wires
    data_memory mydatamem(
        CLK,           // Connect CLK signal to memory clock.
        RESET,         // Connect RESET signal to memory reset.
        mem_read,      // Connect memory read request to memory.
        mem_write,     // Connect memory write request to memory.
        mem_address,   // Connect memory block address to memory.
        mem_writedata, // Connect memory write data block to memory.
        mem_readdata,  // Connect memory read data block to memory.
        mem_busywait   // Connect memory busywait from memory.
    ); 

    initial // Start of simulation control block.
    begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd"); // Set waveform file name.
		$dumpvars(0, cpu_tb);          // Set dump variable scope.
        
        CLK = 1'b0;   // Initialize Clock to low.
        RESET = 1'b0; // Initialize Reset to low.
        
        // Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        #5 RESET = 1'b1;  // Set reset high at t=5ns.
        #10 RESET = 1'b0; // Set reset low at t=15ns.
        
        // wait 5000ns to let the test program run to completion.
        #5000 
        $finish; 
    end 
    
    // clock signal generation
    always 
        #4 CLK = ~CLK; 

    // Display simulation info on console
    always @(posedge CLK) begin
        if (!RESET && PC >= 72) begin
            $display("t=%0t  Simulation complete: End of program reached.", $time);
            $finish;
        end
        $display("t=%0t  PC=%0d  INST=%h  I_BUSY=%b  D_BUSY=%b",
                  $time, PC, INSTRUCTION, inst_busywait, mem_busywait);
    end

endmodule
