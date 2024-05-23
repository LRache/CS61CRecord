.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    li t0, 1
    bge a0, t0, init
    li a0, 36
    j exit
    
init:
    # Prologue
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)

    mv t0, zero
    mv t1, a0
    mv t2, a1
    
    lw s0, 0(t1)
    li a0, 0

loop_start:
    lw s1, 0(t1)
    ble s1, s0, loop_continue
    mv a0, t0
    mv s0, s1

loop_continue:
    addi t0, t0, 1
    addi t1, t1, 4
    blt t0, t2, loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    jr ra
