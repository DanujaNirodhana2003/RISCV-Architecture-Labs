// CO2070 Computer Architecture - Lab 6
// Test Program — Exercises all Data Cache Scenarios
// Registration numbers : E/22/054 (Danuja), E/22/058 (Tharuka)
//
// Instruction format (32-bit little-endian):
//   file bytes:  [7:0]  [15:8]  [23:16]  [31:24]
//   bits:        byte0  byte1   byte2    byte3
//   INSTRUCTION = {byte3(rightmost), byte2, byte1, byte0(leftmost)}
//   [31:24]=opcode  [23:16]={5'b0,INADDRESS}  [15:8]={5'b0,OUT1ADDRESS}  [7:0]=imm/OUT2ADDRESS
//
// Address map for this test:
//   0x04 → block 1, index 1 (tag=0, offset 0)
//   0x05 → block 1, index 1 (tag=0, offset 1) ← same block as 0x04
//   0x08 → block 2, index 2 (tag=0, offset 0) ← different block
//   0x18 → block 6, index 6 (tag=0, offset 0) ← different block
//
// Cache scenario coverage:
//   Instr 3  : WRITE-MISS (block 1 not in cache → fetch then write)
//   Instr 4  : READ-HIT   (block 1 just loaded)
//   Instr 7  : WRITE-HIT  (block 1 in cache, different word)
//   Instr 8  : READ-HIT   (block 1 in cache, dirty)
//   Instr 11 : WRITE-MISS (block 6 not in cache → fetch then write)
//   Instr 12 : READ-HIT   (block 6 now in cache)
//   Instr 13 : WRITE-HIT  (block 1 still in cache via swi)
//   Instr 14 : READ-MISS  (block 2 never loaded, clean miss)
//   Instr 15 : READ-HIT   (block 1 in cache)

loadi 1 0xAA        // R1 = 0xAA
loadi 4 0x04        // R4 = 4   (memory address 0x04)
swd   1 4          // MEM[0x04] = 0xAA  — WRITE-MISS
lwd   7 4          // R7 = MEM[0x04]    — READ-HIT
loadi 2 0xBB        // R2 = 0xBB
loadi 5 0x05        // R5 = 5   (memory address 0x05)
swd   2 5          // MEM[0x05] = 0xBB  — WRITE-HIT
lwd   7 5          // R7 = MEM[0x05]    — READ-HIT
loadi 3 0x55        // R3 = 0x55
loadi 6 0x18        // R6 = 0x18 = 24   (memory address 0x18, block 6)
swd   3 6          // MEM[0x18] = 0x55  — WRITE-MISS  (block 6 fetched from memory, then written)
lwd   7 6          // R7 = MEM[0x18]    — READ-HIT    (block 6 now in cache, R7 should = 0x55)
swi   1 0x04        // MEM[0x04] = 0xAA  — WRITE-HIT   (block 1 still in cache, dirty overwrite)
lwi   7 0x08        // R7 = MEM[0x08]    — READ-MISS   (block 2 never accessed, clean miss)
lwi   7 0x04        // R7 = MEM[0x04]    — READ-HIT    (block 1 still in cache, R7 should = 0xAA)
loadi 0 0x24        // R0 = 0x24 = 36 (address 0x24: tag=1, index=1 — CONFLICTS with block1@tag0 in cache)
lwd   7 0          // R7 = MEM[0x24]    — READ-MISS dirty! block1 is dirty (tag=0) @ index=1
                      //                      Cache must: (1) write dirty block1 back to memory (MEM_WRITE)
                      //                                 (2) fetch new block (tag=1,index=1) from memory (MEM_FETCH)
                      //                      Total penalty: 42 CPU cycles
lwi   7 0x24        // R7 = MEM[0x24]    — READ-HIT    (new block at index=1 now in cache)

