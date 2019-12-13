# x1: b, 
# x2: a, 
# x3: temp
# x4: N value iter

# Load values
    lw      x4, 0x400(x0) # switch (N address) = 12'b 0100_0000_0000
    addi    x1, x0, 0
    addi    x2, x0, 1

# Iterate (While structure)
Loop:
    beq     x4, x0, Finish
    add     x3, x2, x0      # temp = a
    add     x2, x2, x1      # a = a + b
    add     x1, x3, x0      # b = temp
    addi    x4, x4, -1      # N = N - 1 
    beq     x0, x0, Loop    # jump to LOOP

# Write Value
Finish:
    sw      x1, 0x600(x0) # led (out address) = 12'b 0110_0000_0000

Loop_forever:
    beq     x0, x0, Loop_forever

