# RISC-V Assembly Lab
# E Numbers :
# Names :
# Description: 

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

done:
    nop                 # Main program complete