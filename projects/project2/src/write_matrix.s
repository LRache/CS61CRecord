.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a1 # matrix ptr
    mul s1, a2, a3 # elements count
    sw a2, 24(sp)
    sw a3, 28(sp)

    li a1, 1 # write only
    jal fopen
    li t0, -1
    beq a0, t0, write_matrix_fopen_error
    mv s2, a0 # file descriptor

    addi a1, sp, 24
    li a2, 2
    li a3, 4
    jal fwrite
    li t0, 2
    bne a0, t0, write_matrix_fwrite_error

    mv a0, s2
    mv a1, s0
    mv a2, s1
    li a3, 4
    jal fwrite
    bne a0, s1, write_matrix_fwrite_error

    mv a0, s2
    jal fclose
    bne a0, zero write_matrix_fclose_error

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 32

    jr ra

write_matrix_fopen_error:
    li a0, 27
    j exit

write_matrix_fclose_error:
    li a0, 28
    j exit

write_matrix_fwrite_error:
    li a0, 30
    j exit
