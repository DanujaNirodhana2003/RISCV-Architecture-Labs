// Computer Architecture (CO2070) - Lab 03
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne
`timescale 1ns/1ps  //1ns - the unit of mesurement   1ps - the percision

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
    // LAB 5 MODIFICATION: Declare wires to interface with data memory
    wire mem_read, mem_write, mem_busywait;
    wire [7:0] mem_address, mem_writedata, mem_readdata;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    reg [7:0] instr_mem [0:1023];

    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};



    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
        //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000000101;
        //{instr_mem[10'd7], instr_mem[10'd6], instr_mem[10'd5], instr_mem[10'd4]} = 32'b00000000000000100000000000001001;
        //{instr_mem[10'd11], instr_mem[10'd10], instr_mem[10'd9], instr_mem[10'd8]} = 32'b00000010000001100000010000000010;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        $readmemb("instr_mem.mem", instr_mem);
        // Lab 5 modification: TODO - Update your instr_mem.mem with a test program that uses the new instructions!
    end
    
    /* 
    -----
     CPU
    -----
    */
    // LAB 5 MODIFICATION: Update cpu instantiation to connect the new data memory wires
    cpu mycpu(PC, INSTRUCTION, CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);

    // LAB 5 MODIFICATION: Instantiate data_memory (from lab05.v) and connect it to the wires
    data_memory mydatamem(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        #5 RESET = 1'b1; // assert reset
        #10 RESET = 1'b0; // de-assert reset
        // finish simulation after some time
        #500
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule