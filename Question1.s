		.data
input: 	.asciiz "Please a positive number: "
error:	.asciiz "You should input a positive number! Enter a number again: "
space:	.asciiz " "
return:	.asciiz "\n"
		.text
		.globl main
main:	
		la $a0, input
		li $v0, 4
		syscall				# print_string: "Please a positive number: "

read:	
		li $v0, 5	
		syscall				# read_int: n
		bgtz $v0, initial	# if input>0, jump to initial
        la $a0, error		
		li $v0, 4
		syscall				# print_string: "You should input a positive number! Enter a number again: "
		j read

initial:	
		move $t0, $v0	
		move $t1, $zero		# initialization: row(t1)=0

loop1:	
		beq $t1, $t0, exit
		addi $t1, $t1, 1	# increment by 1
		move $t3, $zero     # initialization: column(t3)=0

loop2:	
		beq $t3, $t1, next
		addi $t3, $t3, 1	# increment by 1
		move $a0, $t3
		li $v0, 1
		syscall				# print_int: column
		la $a0, space
		li $v0, 4
		syscall				# print_string: " "
		j loop2				# go back to loop2

next:	
		la $a0, return
		li $v0, 4
		syscall				# print_string: "\n"
		j loop1				# go back to loop1

exit:           
		li $v0, 10
		syscall				# exit
