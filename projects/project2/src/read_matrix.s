.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    mv s0, a1
    mv s1, a2

    li a1, 0 # read only
    jal fopen
    li t0, -1
    beq a0, t0, read_matrix_fopen_error
    mv s2, a0 # file descriptor

    addi sp, sp, -8
    mv a1, sp
    li a2, 8
    jal fread
    lw t0, 0(sp)
    lw t1, 4(sp)
    addi sp, sp, 8
    li t2, 8
    bne a0, t2, read_matrix_fread_error

    sw t0, 0(s0)
    sw t1, 0(s1)
    mul s0, t0, t1
    slli s0, s0, 2
    mv a0, s0
    jal malloc
    mv s3, a0 # space
    beq a0, zero read_matrix_malloc_error_d

    mv a0, s2
    mv a1, s3
    mv a2, s0
    jal fread
    bne a0, s0, read_matrix_fread_error

    mv a0, s2
    jal fclose
    bne a0, zero, read_matrix_fclose_error
    
    mv a0, s3
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20
    jr ra

read_matrix_malloc_error_d:
    li a0, 26
    j exit

read_matrix_fopen_error:
    li a0, 27
    j exit

read_matrix_fclose_error:
    li a0, 28
    j exit

read_matrix_fread_error:
    li a0, 29
    j exit
    
