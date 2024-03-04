# Matheus Erick Barros Costa Dias da Silva
# 20200078664

.data
    # Input data
    tol: .float 0.1         # tolerance
    n: .word 100             # iterations
    a: .float 2.0           # value for a
    b: .float 3.0           # for b
    fa: .float 0.0          # for fa
    fp: .float 0.0          # for fp
    error: .asciiz "Erro"  # error message
    p: .float 0.0           # value for p

.text
main:
    lwc1 $f5, tol           # load tolerance
    li $t0, 0               # initialize loop
    lw $t1, n               # load iterations

    lwc1 $f1, a             # load a
    jal f                   # jump to f
    add.s $f19, $f3, $f5    # fa + tol

    lwc1 $f11, tol          # load tolerance

    lwc1 $f13, a            # load value of a
    lwc1 $f15, b            # of b
    lwc1 $f17, p            # of p
    lwc1 $f19, fa           # of fa
    lwc1 $f21, fp           # of fp

while:
    bgt $t0, $t1, endWhile  # exit loop if counter > iterations

    sub.s $f17, $f15, $f13  # b - a
    div.s $f17, $f17, $f13  # divide by $f13
    add.s $f17, $f17, $f13  # add $f13

    mov.s $f1, $f17         # move to $f1
    jal f                   # jump to f
    mov.s $f21, $f3         # move result to $f21

    c.eq.s $f21, $f5        # compare with tolerance
    bc1t print              # jump to print if equal

    sub.s $f25, $f17, $f13  # new a - old a
    c.lt.s $f25, $f11       # compare with tolerance
    bc1t print              # jump to print if less than

    addi $t0, $t0, 1        # increment counter

    mul.s $f27, $f19, $f21  # fa * fp

    c.lt.s $f27, $f5        # compare with tolerance
    bc1t updateB            # jump to updateB if less than

    c.eq.s $f27, $f5        # compare with tolerance
    bc1t updateB            # jump to updateB if equal

    j updateA               # jump to updateA

updateA:
    mov.s $f13, $f17        # update a
    mov.s $f19, $f21        # update fa
    j while                 # jump to while

updateB:
    mov.s $f15, $f17        # update b
    j while                 # jump to while

endWhile:
    li $v0, 4               # print string syscall code
    la $a0, error           # load address of error string
    syscall                 # print error message
    jal terminate           # jump to terminate

f:
    mul.s $f3, $f1, $f1     # f1 * f1
    mul.s $f3, $f3, $f1     # f3 * f1
    sub.s $f3, $f3, $f19    # f3 - fa
    jr $ra                  # return

print:
    li $v0, 2               # print float syscall code
    add.s $f12, $f17, $f5   # result + tol
    syscall                 # print result
    j terminate             # jump to terminate function

terminate:
    li $v0, 10              # exit syscall
    syscall                 # terminate
