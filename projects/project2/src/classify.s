.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0, 5
    bne a0, t0, classify_args_error

    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)

    mv s0, a2
    addi s1, a1, 4
    addi sp, sp, -24

    # Read pretrained m0
    lw a0, 0(s1)
    addi a1, sp, 0 # m0 rows
    addi a2, sp, 4 # m0 columns
    call read_matrix
    mv s2, a0 # matrix 0 ptr
    
    # Read pretrained m1
    lw a0, 4(s1)
    addi a1, sp, 8  # m1 rows
    addi a2, sp, 12 # m1 columns
    call read_matrix
    mv s3, a0 # matrix 1 ptr

    # Read input matrix
    lw a0, 8(s1)
    addi a1, sp, 16 # input rows
    addi a2, sp, 20 # input columns
    call read_matrix
    mv s4, a0 # input matrix ptr

    # Compute h = matmul(m0, input)
    lw s5, 0(sp) # h rows
    lw s6, 20(sp) # h columns
    mul a0, s5, s6
    slli a0, a0, 2
    call malloc
    beq a0, zero, classify_malloc_error
    mv s7, a0 # h ptr
    
    mv a0, s2
    mv a1, s5
    lw a2, 4(sp)
    mv a3, s4
    lw a4, 16(sp)
    mv a5, s6
    mv a6, s7
    call matmul

    # Compute h = relu(h)
    mv a0, s7
    mul a1, s5, s6
    call relu

    # Compute o = matmul(m1, h)
    lw s8, 8(sp)
    mul a0, s6, s8
    slli a0, a0, 2
    jal malloc
    beq a0, zero, classify_malloc_error
    mv s9, a0 # o ptr
    
    mv a0, s3
    mv a1, s8
    lw a2, 12(sp)
    mv a3, s7
    mv a4, s5
    mv a5, s6
    mv a6, s9
    call matmul

    # Write output matrix o
    lw a0, 12(s1)
    mv a1, s9
    mv a2, s8
    mv a3, s6
    call write_matrix

    # Compute and return argmax(o)
    mv a0, s9
    mul a1, s6, s8
    call argmax
    mv s10, a0

    # If enabled, print argmax(o) and newline
    bne s0, zero, classify_end
    mv a0, s10
    call print_int
    li a0, '\n'
    call print_char

classify_end:

    mv a0, s10
    addi sp, sp, 24

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48

    jr ra

classify_args_error:
    li a0, 31
    j exit

classify_malloc_error:
    li a0, 26
    j exit
