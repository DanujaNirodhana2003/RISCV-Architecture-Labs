# RISC-V Assembly Lab
# E Numbers : E/22/054 , E/22/058
# Names : Danuja , Tharuka
# Description:  Matrix multiply using the hardware mul instruction.

.data
# Matrix A (4x4, row-major)
A:  .word 1, 2, 3, 4
    .word 5, 6, 7, 8
    .word 9, 10, 11, 12
    .word 13, 14, 15, 16

# Matrix B (4x4, row-major)
B:  .word 1, 2, 3, 4
    .word 0, 1, 2, 3
    .word 0, 0, 1, 2
    .word 0, 0, 0, 1

# Matrix C (4x4, initialized to 0)
C:  .word 0, 0, 0, 0
    .word 0, 0, 0, 0
    .word 0, 0, 0, 0
    .word 0, 0, 0, 0

.text
.globl _start

_start:
# ---------------------------------------------------------
# YOUR CODE GOES HERE:
# ---------------------------------------------------------
la s0, A                    # Load the base address of Matrix A into s0
la s1, B                    # Load the base address of Matrix B into s1
la s2, C                    # Load the base address of Matrix C into s2
li s11, 4                   # Load the matrix size (4) into s11 for loop boundary checks

li s3, 0                    # Initialize outer loop counter i = 0 (Row of A)

loop_i: 
    beq s3, s11, done       # If i == 4, the entire matrix multiplication is complete
    li s4, 0                # Initialize middle loop counter j = 0 (Column of B)

loop_j: 
    beq s4, s11, next_i     # If j == 4, all columns for this row are done, move to next row
    li s5, 0                # Initialize the running sum for C[i][j] to 0
    li s6, 0                # Initialize inner loop counter k = 0 (Dot product index)

loop_k: 
    bge s6, s11, store_c     # If k == 4, the dot product for C[i][j] is complete, go store it

    slli t0, s3, 2          # t0 = i * 4 (since there are 4 columns per row)
    add  t0, t0, s6         # t0 = i * 4 + k (the linear index of A[i][k])
    slli t0, t0, 2          # t0 = (i * 4 + k) * 4 (convert index to byte offset)     
    add  t1, s0, t0         # t1 = Base A + offset (calculate exact memory address of A[i][k])
    lw a0, 0(t1)            # Load the value of A[i][k] into argument register a0

    slli t0, s6, 2          # t0 = k * 4 (since Matrix B has 4 columns per row)
    add  t0, t0, s4         # t0 = k * 4 + j (the linear index of B[k][j])
    slli t0, t0, 2          # t0 = (k * 4 + j) * 4 (convert index to byte offset)
    add  t1, s1, t0         # t1 = Base B + offset (calculate exact memory address of B[k][j])
    lw a1, 0(t1)            # Load the value of B[k][j] into argument register a1

    mul a0, a0, a1                  # Multiply a0 and a1, store result in a0
    add s5, s5, a0          # Accumulate the product into the running sum: sum = sum + a0
    addi s6, s6, 1          # Increment k: k = k + 1
    j loop_k                # Jump back to start of inner loop

store_c:    
    
    slli t0, s3, 2          # t0 = i * 4 (Matrix C has 4 columns per row)
    add  t0, t0, s4         # t0 = i * 4 + j (the linear index of C[i][j])
    slli t0, t0, 2          # t0 = (i * 4 + j) * 4 (convert index to byte offset)
    add  t1, s2, t0         # t1 = Base C + offset (calculate exact memory address of C[i][j])
    sw s5, 0(t1)            # Store the final calculated sum into C[i][j] in memory
    
    addi s4, s4, 1          # Increment j: j = j + 1
    j loop_j                # Jump back to start of middle loop

next_i: 
    addi s3, s3, 1          # Increment i: i = i + 1
    j loop_i                # Jump back to start of outer loop


done:
    nop                 # Main program complete



