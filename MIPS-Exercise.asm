# HUGH LEOW
# 3/14/2018
# HOMEWORK #4
# CSCI 260

#PROBLEM #1 (FACTORIAL WITH RECURSION):
.data
startText: .asciiz "Enter a positive integer:"
endText: .asciiz "Factorial of N is ="

.text
main:
    li $a1, n # (load immediate constant) fixed argument 'n' to $a1

    la $a0, startText # (load address) startText into $a0
    li $v0, 4 # MARS code 4 to print string in $a0 
    syscall

    jal factorial # jump to factorial and store next instruction address (PC+4) in $ra
    
    # $ra brings you back here after factorial function
    la $a0, endText # (load address) endText into $a0
    li $v0, 4 # print endText
    syscall

    move $a0, $v1 # copy value/answer from $v1 into $a0 register
    li $v0, 1 # MARS code 1 to print integer in $a0
    syscall

    li $v0, 10 # MARS code 10 to end program
    syscall

factorial:
    addi $sp, $sp, 8 # allocate stack memory to store $ra (return address), $t0 (local varaible). (multiples of 8 only)
    sw $ra, 0($sp) # store $ra address into first position of stack
    sw $t0, 4($sp) # store local variable into next position in stack, used by recursion for each function call

    move $t0, $a1 # move/copy argument from $a1 to local variable $t0
    beq $t0, $zero, baseCase # if $t0 == zero then break to baseCase
    
    subi $a1, $a1, 1 # decrement argument by 1
    jal factorial # jump to factorial and store next instruction address in $ra
    
    # $ra brings you here after we meet the base case / repeat for each time stack pops
    mult $t0, $v1 # multiply $v1 * $t0 and stored in $LO (starts with base case $v1 = 1)
    mflo $v1 # moves value from $LO to $v1
    lw $ra, 0($sp) # restore $ra from memory
    jr $ra # jumps to mult if necessary and does calculations, eventually jumps back to main function and continue program

baseCase:
    li $v1, 1 # load 1 into $v1 for base case
    lw $ra, 0($sp) # restore the $ra from first stack position, puts you on 'mult' instruction
    lw $t0, 4($sp) # restore the previous argument before base case into local variable $t0
    jr $ra # jump to mult instruction



#PROBLEM #2 (BUBBLE SORT):
.data
    list: .space 80 # reserve 80 bytes for list (can hold 20 integers)
.text
main: 
    la $t0, list # load address of array[0] in $t0
    la $s0, list # load address of array[0] in $s0 (for bubbleSort use)
    la $s5, list # keeps address permanently for reset
    li $t1, 0 # counter to find list length
    li $t2, 0 # counter to check if we iterated through list in bubbleSort
    li $t3, 0 # keep track of number of swaps
    beq $t0, $zero, return # if list is empty, terminate program
    
    jal iterateList # jump to iterateList and set $ra

    # $ra puts you back here
    move $s0, $s5 # makes $s0 point to array[0]
    jal printList # prints the sorted list 

    j return # end of program

iterateList:
    beq $t0, $zero, bubbleSort # after list[i] is NULL, jump to bubbleSort
    addi $t1, $t1, 1 # increment counter by one
    addi $t0, $t0, 4 # move to address of next integer in the list
    j iterateList # jump to iterateList again until we see NULL

bubbleSort:
    beq $t1, $t2, reset # if we reach end of array, start again
    lw $s1, 0($s0) # load array[i] value into $s1
    lw $s2, 4($s0) # load array[i+1] value into $s2
    bgt $s1, $s2, swap # if array[i] > array[i+1], swap
    finishSwap:
    addi $s0, $s0, 4 # iterate to next integer in array
    addi $t2, $t2, 1 # increment bubbleSort counter
    j bubbleSort # loop bubbleSort until list is sorted

printList:
    beq $s0, $zero, finished # if $s0 points to null, go back to main
    lw $a0, 0($s0) # load array[i] into $a0
    li $v0, 1 # MARS code 1 to print integer in $a0
    syscall
    addi $s0, $s0, 4 # iterate to next integer in array
    j printList # loop again to print

swap:
    # write new integers into memory
    lw $s1, 4($s0) # load array[i] into array[i+1]
    lw $s2, 0($s0) # load array[i+1] into array[i]
    addi $t3, $t3, 1 # increment # of swaps by 1
    j finishSwap # jump back to bubbleSort and continue

reset:
    beq $t3, $zero, finished # if there are no swaps, bubbleSort is finished
    li $t2, 0 # reset bubbleSort counter to 0
    li $t3, 0 # number of swaps needs to be reset to 0
    move $s0, $s5 # makes $s0 point to array[0] again    
    j bubbleSort # go back to bubbleSort after reset

return:
    li $v0, 10 # MARS code 10 to end program
    syscall

finished:
    jr $ra

