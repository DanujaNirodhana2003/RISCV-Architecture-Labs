// Fibonacci Sequence Generator
// Generates first 10 Fibonacci numbers and stores them in memory starting at address 0x00

loadi 0 0        // 1 R0 = 0 (Constant 0)  
loadi 1 0        // 2 R1 = 0 (F_0)
loadi 2 1        // 3 R2 = 1 (F_1)
loadi 4 0        // 4 R4 = 0 (Memory Address to store)
loadi 5 10       // 5 R5 = 10 (Loop Counter)
loadi 6 1        // 6 R6 = 1 (Constant 1 for increment/decrement)

// LOOP START (Instruction index 6)
swd 1 4          // 7 Mem[R4] = R1 (Store current Fibonacci number)
add 3 1 2        // 8 R3 = R1 + R2 (Calculate next Fibonacci number)
mov 1 2          // 9 R1 = R2 (Update F_n-1)
mov 2 3          // 10 R2 = R3 (Update F_n)
add 4 4 6        // 11 R4 = R4 + 1 (Increment Memory Address)
sub 5 5 6        // 12 R5 = R5 - 1 (Decrement Counter)

// Check if loop is done
beq 0x01 5 0     // 13 If R5 == 0, jump forward 1 instruction to exit loop
                 // (Target = current_pc_next(13) + 1 = 14)

j 0xF8           // 14 Jump backward 8 instructions to LOOP START (Index 6)
                 // (Target = current_pc_next(14) - 8 = 6) -8 kiyana eka hexa wali n ganne 256 - 8 = 248   0xF8

// EXIT (Instruction index 14)
mov 0 0          // 15 NOP
mov 0 0          // 16 NOP
mov 0 0          // 17 NOP
mov 0 0          // 18 NOP
mov 0 0          // 19 NOP (PC reaches 72 here, simulation finishes)
