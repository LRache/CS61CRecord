.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    li t0, 1
    blt a2, t0, dot_error1_exit
    blt a3, t0, dot_error2_exit
    blt a4, t0, dot_error2_exit
    j loop_init

dot_error1_exit:
    li a0, 36
    j exit

dot_error2_exit:
    li a0, 37
    j exit

loop_init:
    addi sp, sp, -20
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)

    mv t0, a0 #array1 ptr
    mv t1, a1 #array2 ptr
    mv t2, zero # counter
    mv a0, zero # result
    slli a3, a3, 2
    slli a4, a4, 2
    j loop_continue

loop_start:
    lw s0, 0(t0)
    lw s1, 0(t1)
    mul s2, s0, s1
    add a0, a0, s2

    add t0, t0, a3
    add t1, t1, a4
    addi t2, t2, 1

loop_continue:
    blt t2, a2, loop_start

loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 20

    jr ra
