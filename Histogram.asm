# Matheus Erick Barros Costa Dias da Silva
# 20200078664

.data
    # Input data
    array: .word 9, 5, 7, 5, 3, 4, 0, 2, 6, 4, 2, 5, 4, 1, 2, 1, 6, 2, 2, 3, 6, 3, 0, 0, 7, 8, 3, 4, 5, 4, 0, 5, 2, 9, 8, 7
    arraySize: .word 36
    histogram: .space 40
    histogramSize: .word 10
    spaceChar: .asciiz " "

.text
    lw $s0, arraySize               # Load array size
    lw $s1, histogramSize           # Load histogram size
    
    # Initialize loop
    li $t0, 0
    li $t1, 0

    initLoop:
        sw $zero, histogram($t1)    # Initialize histogram to zero
        addiu $t0, $t0, 1           # Increment loop counter
        addiu $t1, $t1, 4           # Increment histogram pointer
        bne $t0, $s1, initLoop      # Loop until all elements of histogram are initialized

    # Reset loop counters
    li $t0, 0
    li $t1, 0

    Histogram:
        lw $t2, array($t1)          # Load from array
        sll $t3, $t2, 2             # Multiply element by 4 to get offset in histogram
        lw $t4, histogram($t3)      # Load current histogram element
        addiu $t4, $t4, 1           # Increment histogram element
        sw $t4, histogram($t3)      # Store updated histogram element
        addiu $t0, $t0, 1           # Increment loop counter
        addiu $t1, $t1, 4           # Increment array pointer
        bne $t0, $s0, Histogram     # Loop until all elements of array are processed

    # Reset loop counters
    li $t0, 0
    li $t1, 0

    printHistogram:
        beq $t0, $s1, exit          # Exit loop if all elements of histogram have been printed

        li $v0, 1                   # Print histogram element
        lw $a0, histogram($t1)
        syscall

        li $v0, 4                   # Print space character
        la $a0, spaceChar
        syscall

        addiu $t0, $t0, 1           # Increment loop counter
        addiu $t1, $t1, 4           # Increment histogram pointer
        j printHistogram            # Continue printing histogram

    exit:
        li $v0, 10                  # Exit
        syscall
