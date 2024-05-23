.globl abs

.text
# =================================================================
# FUNCTION: Given an int return its absolute value.
# Arguments:
#   a0 (int*) is a pointer to the input integer
# Returns:
#   None
# =================================================================
abs:
    # Prologue

    # PASTE HERE
    lw t0 0(a0)
    bgt t0, zero, return
    sub t0, zero, t0
    
return:
    sw t0 0(a0)
    # Epilogue

    jr ra
