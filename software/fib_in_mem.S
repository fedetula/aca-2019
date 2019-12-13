# x1: b, x2: a, x3: temp, x4: N value, x5: out, x6: mem address out

.globl _start
.text
_start:
# Load values
    addi    x6, x0, 0x80
    addi    x4, x0, 8
    addi    x1, x0, 0
    addi    x2, x0, 1

# Iterate
Loop:
    beq     x4, x0, Finish
    add     x3, x2, x0      # temp = a
    add     x2, x2, x1      # a = a + b
    add     x1, x3, x0      # b = temp
    addi    x4, x4, -1      # N = N - 1 
    beq     x0, x0, Loop    # jump to LOOP

# Write Value
Finish:
    sw      x1, 0(x6)
    lw      x5, 0(x6)

Loop_forever:
    beq     x0, x0, Loop_forever

