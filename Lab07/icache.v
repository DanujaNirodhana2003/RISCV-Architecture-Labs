/*
Registration numbers: E/22/054 (Danuja), E/22/058 (Tharuka)
Instruction Cache
128-Byte Instruction Cache, direct mapped.
Block size: 16 Bytes (8 blocks total).
*/

module instruction_cache (
    input             CLK,
    input             RESET,
    
    // CPU side ports
    input      [9:0]  PC,           // 10-bit byte address from CPU
    output reg [31:0] INSTRUCTION,  // 32-bit instruction to CPU
    output reg        BUSYWAIT,     // Stalls the CPU on miss
    
    // Memory side ports
    output reg        mem_read,     // Read request to Instruction Memory
    output reg [5:0]  mem_address,  // 6-bit block address to Instruction Memory
    input     [127:0] mem_readdata, // 16-byte block read from Instruction Memory
    input             mem_busywait  // Busywait from Instruction Memory
);

    // Cache parameters
    localparam NUM_LINES = 8; 

    // 1. Address Mapping
    wire [1:0] word_offset = PC[3:2];           // 2 bits for word offset (to select 1 out of 4 words)
    wire [2:0] index       = PC[6:4];           // 3 bits for index (to select 1 out of 8 lines)
    wire [2:0] tag         = PC[9:7];           // 3 bits for tag

    // 2. Cache Arrays
    reg                  valid_array [0:NUM_LINES-1]; // Valid bits
    reg [2:0]            tag_array   [0:NUM_LINES-1]; // 3-bit tags
    reg [127:0]          data_array  [0:NUM_LINES-1]; // 128-bit data blocks

    // 3. Asynchronous Array Lookup
    reg                cached_valid;
    reg [2:0]          cached_tag;
    reg [127:0]        cached_block;

    always @(*) begin
        #1; // Artificial delay for array extraction
        cached_valid = valid_array[index];
        cached_tag   = tag_array[index];
        cached_block = data_array[index];
    end

    // 4. Tag Comparison and Hit/Miss Logic
    reg hit;
    reg miss;
    always @(*) begin
        #0.9; // Artificial delay for tag comparison
        if (cached_valid == 1'b1 && cached_tag == tag) begin
            hit  = 1'b1;
            miss = 1'b0;
        end else begin
            hit  = 1'b0;
            miss = 1'b1;
        end
    end

    // 5. Word Selection (Multiplexer)
    reg [31:0] selected_word;
    always @(*) begin
        #1; // Artificial delay for multiplexer
        case (word_offset)
            2'b00: selected_word = cached_block[31:0];
            2'b01: selected_word = cached_block[63:32];
            2'b10: selected_word = cached_block[95:64];
            2'b11: selected_word = cached_block[127:96];
        endcase
    end

    // 6. Output Instruction Asynchronously
    always @(*) begin
        if (hit) begin
            INSTRUCTION = selected_word;
        end else begin
            INSTRUCTION = 32'bx;
        end
    end

    // ----------------------------------------
    // Cache Controller FSM
    // ----------------------------------------
    parameter IDLE           = 2'b00;
    parameter MEM_READ_START = 2'b01;
    parameter MEM_READ       = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Track memory busywait to detect completion edge
    reg mem_busy_seen;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (miss)
                    next_state = MEM_READ_START;
                else
                    next_state = IDLE;
            end

            MEM_READ_START: begin
                next_state = MEM_READ;
            end

            MEM_READ: begin
                if (mem_busy_seen && !mem_busywait)
                    next_state = IDLE; // Memory access finished
                else
                    next_state = MEM_READ;
            end

            default: next_state = IDLE;
        endcase
    end

    // Combinational output logic
    always @(*) begin
        case (state)
            IDLE: begin
                mem_read    = 1'b0;
                mem_address = 6'bx;
                BUSYWAIT    = miss; // Stall CPU if it's a miss
            end

            MEM_READ_START: begin
                mem_read    = 1'b1;
                mem_address = PC[9:4]; // 6-bit block address
                BUSYWAIT    = 1'b1;
            end

            MEM_READ: begin
                mem_read    = 1'b1;
                mem_address = PC[9:4];
                BUSYWAIT    = 1'b1;
            end
        endcase
    end

    // Sequential logic for state transitions and array writes
    integer j;
    always @(posedge CLK or posedge RESET) begin
        if (RESET) begin
            state <= IDLE;
            mem_busy_seen <= 1'b0;
            for (j = 0; j < NUM_LINES; j = j + 1) begin
                valid_array[j] <= 1'b0;
                tag_array[j]   <= 3'b0;
                data_array[j]  <= 128'b0;
            end
        end else begin
            state <= next_state;

            // Track mem_busywait
            if (state == IDLE || state == MEM_READ_START)
                mem_busy_seen <= 1'b0;
            else if (state == MEM_READ && mem_busywait)
                mem_busy_seen <= 1'b1;

            // Write fetched block into cache
            if (state == MEM_READ && mem_busy_seen && !mem_busywait) begin
                #1; // Delay for writing to cache arrays
                data_array[index]  <= mem_readdata;
                tag_array[index]   <= tag;
                valid_array[index] <= 1'b1;
            end
        end
    end

endmodule
