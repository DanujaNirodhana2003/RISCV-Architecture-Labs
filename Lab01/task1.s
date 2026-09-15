# RISC-V Assembly Lab
# E Numbers : E/22/054 , E/22/058
# Names :  Danuja , Tharuka
# Description: Array traversal and conditional logic.

.data
# Initialize the array with 5 sample integers
array:  .word 12, 7, 4, 15, 8   
length: .word 5                 

.text
.globl _start

_start:
    la   t0, array      # t0 = base address of the array
    lw   t1, length     # t1 = length of the array (5)
    li   t2, 0          # t2 = loop counter (i = 0)

# ---------------------------------------------------------
# YOUR CODE GOES HERE:

# Write the logic to iterate through the array.
# Check if each element is even or odd using 'andi'.
# Apply the addition or subtraction, and store it back.
# ---------------------------------------------------------

loop:
    bge  t2, t1, done       # if i >= length, exit loop (branch to done)

    # Calculate address of array[i]: address = base + i * 4
    slli t3, t2, 2          # t3 = i * 4  (shift left by 2 = multiply by 4, since each word = 4 bytes)
    add  t4, t0, t3         # t4 = base address + offset = address of array[i]

    lw   t5, 0(t4)          # t5 = array[i]  (load the current element from memory)

    andi t6, t5, 1          # t6 = t5 AND 1  (isolate the least significant bit)
                            # if t6 == 0 ? element is EVEN
                            # if t6 == 1 ? element is ODD
    bne  t6, zero, is_odd   #if t6 != 0 (i.e., odd), branch to is_odd
is_even:
    addi t5, t5, 10         # even: add 10 to the element
    j    store              # jump to store result (skip is_odd block)

is_odd:
    addi t5, t5, -5         # odd: subtract 5 from the element


store:
    sw   t5, 0(t4)          # store the modified value back to array[i] in memory

    addi t2, t2, 1          # i = i + 1  (increment loop counter)
    j    loop               # jump back to start of loop

done:
    nop                             # Jump here when the array processing is complete
