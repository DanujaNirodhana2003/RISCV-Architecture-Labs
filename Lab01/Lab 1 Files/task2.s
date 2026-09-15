# RISC-V Assembly Lab
# E Numbers :
# Names :
# Description: 

.data
# Space to store the final calculated product
result: .word 0

.text
.globl _start

_start:
    # Load test values into a0 (multiplicand) and a1 (multiplier)
    # You can change these numbers to test different cases
    li   a0, 6        
    li   a1, 7        

    # Call the multiplication subroutine
    jal  ra, mymul

    # Store the returned result (in a0) into the data segment
    la   t0, result
    sw   a0, 0(t0)

done:
    nop               # Main program complete

# ---------------------------------------------------------
# Subroutine: mymul
# Arguments:
#   a0 = multiplicand
#   a1 = multiplier
# Returns:
#   a0 = product (a0 * a1)
# ---------------------------------------------------------
mymul:
# ---------------------------------------------------------
# YOUR CODE GOES HERE:
# ---------------------------------------------------------
