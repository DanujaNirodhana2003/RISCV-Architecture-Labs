# RISC-V Assembly Lab
# E Numbers : E/22/054 , E/22/058
# Names :  Danuja , Tharuka
# Description: Subroutine implementation.

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

    li t0 , 0               # 1. Initialize product to 0 (only once!)

my_mul_loop :               # 2. Define a label for the loop
    beq a1, zero , done_loop   # 3. If multiplier is 0, we are finished
    andi t1,a1, 1           # 4. Check the least significant bit (LSB) of the multiplier

    beq t1, zero, skip_add    # 5. If LSB is 0, skip the addition
    add t0, t0, a0          # 6. If LSB is 1, add multiplicand to the running total

skip_add :
    slli a0,a0,1            # 7. Left shift the multiplicand (double it)
    srli a1,a1,1            # 8. Right shift the multiplier (divide by 2)

    j  my_mul_loop          # 9. Repeat the loop


done_loop :

    mv a0, t0               # 10. Move the final result from t0 to a0
    ret                     # 11. Return to the caller  

