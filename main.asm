######################################################
# author:      A17B0362P silhavyj
# class:       KIV/UPA
# description: solves the hanoi towers problem
#              for the input number of disks <1;9>
# link: https://en.wikipedia.org/wiki/Tower_of_Hanoi
######################################################
.data
	input:    .asciiz "Enter the number of disks: "
	alert:    .asciiz "The number is supposed to be between 1 and 9!"
    newline:  .asciiz "\n"
	arrow:    .asciiz " -> "
	
# Prints the string given as a parameter
# to the standart output.
.macro print_str($arg)
    li      $v0, 4        # print a string
    la      $a0, $arg     # the string itself
    syscall               # call the system function
.end_macro

# Prints the content of the register
# given as a parameter to the standart output.
.macro print_req($arg)
    li      $v0, 1        # print an integer
    move    $a0, $arg     # the register itself
    syscall               # call the system function
.end_macro

# Reads an integer the user enters
# to the standart input. The integer
# wil be stored into a register given
# as a parameter.
.macro read_int($arg)
    li      $v0, 5        # read an integer
    syscall               # call the system function
    move    $arg, $v0     # move the integer into
                          # the appropriate register
.end_macro

.macro exit
    li $v0, 10
    syscall
.end_macro

.macro print_move($d1, $d2)
    print_req($d1)
    print_str(arrow)
    print_req($d2)
    print_str(newline)
.end_macro

.macro push($n, $p1, $p2, $p3)
    sub $sp, $sp, 16
    sw $n, 12($sp)
    sw $p1, 8($sp)
    sw $p2, 4($sp)
    sw $p3, 0($sp)
.end_macro

.macro pop_all()
    lw $ra, 0($sp)
    addi $sp, $sp, 20	
.end_macro

.macro read($n, $p1, $p2, $p3)	
    lw $p3, 4($sp)
    lw $p2, 8($sp)
    lw $p1, 12($sp)
    lw $n, 16($sp)
.end_macro

.text
	.global mian
	main:
		
		print_str(input)
		read_int($t2)
		
		li $t6, 9
		bgt $t2, $t6, err
		bgtz $t2, run
	
	err:
		print_str(alert)
		exit
	
	run:
		li $t3, 1
		li $t4, 2
		li $t5, 3
	
		
		push($t2, $t3, $t4, $t5)
		
		jal hanoi
		exit
	
	hanoi:	
		sub $sp, $sp, 4
		sw $ra, 0($sp)
		
		read($t2, $t3, $t4, $t5)
		li $t6, 1
		beq $t2, $t6, return
		addi $t2, $t2, -1
		push($t2, $t3, $t5, $t4)
		jal hanoi
		
		print_move($t3, $t4)
		
		read($t2, $t3, $t4, $t5)
		li $t6, 1
		beq $t2, $t6, return
		addi $t2, $t2, -1
		push($t2, $t5, $t4, $t3)
		jal hanoi
	
	return:
		pop_all()
		jr $ra
