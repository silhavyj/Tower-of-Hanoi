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
    li      $v0, 4      # print a string
    la      $a0, $arg   # the string itself
    syscall             # call the system function
.end_macro

# Prints the content of the register
# given as a parameter to the standart output.
.macro print_req($arg)
    li      $v0, 1      # print an integer
    move    $a0, $arg   # the register itself
    syscall             # call the system function
.end_macro

# Reads an integer the user enters
# to the standart input. The integer
# wil be stored into a register given
# as a parameter.
.macro read_int($arg)
    li      $v0, 5      # read an integer
    syscall             # call the system function
    move    $arg, $v0   # move the integer into
                        # the appropriate register
.end_macro

# Exit of the program.
.macro exit
    li      $v0, 10     # end of the program
    syscall             # call the system function
.end_macro

# Prints out one move of the disks
# from rod d1 to rod d2.
.macro print_move($d1, $d2)
    print_req($d1)      # print the first rod
    print_str(arrow)    # print the arrow " -> "  
    print_req($d2)      # print the second rod
    print_str(newline)  # print a new line
.end_macro

# Pushes data onto the stack.
# n  - number of disks
# p1 - rod number 1
# p2 - rod number 2
# p3 - rot number 3
.macro push($n, $p1, $p2, $p3)
    sub     $sp, $sp, 16  # "allocate" 16B on the stack
    sw      $n, 12($sp)   # store the number of disks
    sw      $p1, 8($sp)   # store rode number 1
    sw      $p2, 4($sp)   # store rode number 2
    sw      $p3, 0($sp)   # store rode number 3
.end_macro

# Pops all data - number of disks along
# with all the rods from the stack.
# It also stores the return address to
# register ra
.macro pop_all()
    lw      $ra, 0($sp)   # store the return address into ra
    addi    $sp, $sp, 20  #	move the stack pointer by 20B
.end_macro

# Reads data - number of disks along
# with all the rods from the stack
# (it does not delete them).
.macro read($n, $p1, $p2, $p3)	
    lw      $p3, 4($sp)   # load rod number 3
    lw      $p2, 8($sp)   # load rod number 2
    lw      $p1, 12($sp)  # load rod number 1
    lw      $n, 16($sp)   # load number of disks
.end_macro

.text
	.global mian
	main:
		print_str(input)  # encourage the user to enter the input
		read_int($t2)     # read the number of disks

		li      $t6, 9          # max number of disks = 9
		bgt     $t2, $t6, err   # if number of disks > 9 -> jump err
		bgtz    $t2, run        # if number of disks > 0 -> jump run
	err:
		print_str(alert)  # print out the error msg for the user
		exit              # terminate the program	
	run:
		li      $t3, 1    # store the first rode (num 1) to register t3
		li      $t4, 2    # store the first rode (num 2) to register t4
		li      $t5, 3    # store the first rode (num 3) to register t5
        li      $t6, 1    # value used to terminate the recursion (n == 1)

		push($t2, $t3, $t4, $t5) # store the rods on the stack		
		jal     hanoi            # call the hanoi function
		exit
	
	hanoi:	
		sub     $sp, $sp, 4   # reserve 4B on the stack for the return address
		sw      $ra, 0($sp)   # store the return address on the stack   
		
		read($t2, $t3, $t4, $t5)  # read the data (number of disks, ...) from the stock
		beq     $t2, $t6, return  # if n == 1 -> return
		addi    $t2, $t2, -1      # n = n - 1 
		push($t2, $t3, $t5, $t4)  # store the data on the stack
		jal     hanoi             # recursively call the same function  
		
		print_move($t3, $t4)      # print one move of a disk  
		
		read($t2, $t3, $t4, $t5)  # read the data (number of disks, ...) from the stock
		addi    $t2, $t2, -1      # n = n - 1   
		push($t2, $t5, $t4, $t3)  # store the data on the stack
		jal     hanoi             # recursively call the same function  
	
	return:
		pop_all()    # pop all the date from the stack
		jr      $ra  # return from the function
