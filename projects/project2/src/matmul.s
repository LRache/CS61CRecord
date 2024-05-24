.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    ble a1, zero, matmul_error
    ble a2, zero, matmul_error
    ble a4, zero, matmul_error
    ble a5, zero, matmul_error
    bne a2, a4, matmul_error
    
    # Prologue
    addi sp, sp, -56
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw s0, 20(sp)
    sw s1, 24(sp)
    sw s2, 28(sp)
    sw s3, 32(sp)
    sw s4, 36(sp)
    sw s5, 40(sp)
    sw ra, 44(sp)
    sw a6, 48(sp)
    sw s7, 52(sp)
    
    mv s0, a0 # m0 ptr
    mv s1, a1 # m0 rows
    mv s2, a3 # m1 ptr
    mv s3, zero # m0 rows counter
    mv s5, a3 # m1 ptr backup
    slli s7, a2, 2
    
    li a3, 1 # arr0 stride
    mv a4, a5 # arr1 stride
    
outer_loop_start:
    mv s4, zero # m1 column counter
    mv s2, s5

inner_loop_start:
    mv a0, s0
    mv a1, s2
    jal dot
    sw a0, 0(a6)

inner_loop_end:
    addi a6, a6, 4
    addi s4, s4, 1
    addi s2, s2, 4
    bne s4, a4, inner_loop_start

outer_loop_end:
    addi s3, s3, 1
    slli t0, a2, 2
    add s0, s0, a2
    bne s3, s1, outer_loop_start

    # Epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw s0, 20(sp)
    lw s1, 24(sp)
    lw s2, 28(sp)
    lw s3, 32(sp)
    lw s4, 36(sp)
    lw s5, 40(sp)
    lw ra, 44(sp)
    lw a6, 48(sp)
    lw s7, 52(sp)
    addi sp, sp, 56

    jr ra

matmul_error:
    li a0, 38
    j exit
