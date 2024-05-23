.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    beq a1, zero, loop_end
    mv t0, a1
    li t1, 1
    bge t0, t1, loop_init
    
    li a0, 36
    j exit

loop_init:
    mv t0, zero
    mv t1, a0
loop_start:
    lw t2, 0(t1)
    bgt t2, zero, loop_continue
    mv t2, zero
    
loop_continue:
    sw t2, 0(t1)
    addi t0, t0, 1
    addi t1, t1, 4
    blt t0, a1, loop_start

loop_end:
    # Epilogue


    jr ra
