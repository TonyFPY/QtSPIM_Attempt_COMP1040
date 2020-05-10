		.data
input1:	.asciiz "Input string: "
input2:	.asciiz "Input character: "
output:	.asciiz "Output: "
str:	.space 20
return:	.asciiz "\n"
		.text
		.globl main
main:	
		la $a0, input1
		li $v0, 4
		syscall			# print_string:"Input string: "
		la $a0, str
		li $a1, 20		# the maximum length of the string with "\0" is 20
		li $v0, 8
		syscall			# read_string
		la $t0, str

		la $a0, input2
		li $v0, 4
		syscall			# print_string: "Input character: "
		li $v0,12
		syscall			# read the character1 without press return
		move $s1, $v0
		la $a0, return
		li $v0, 4
		syscall			# print_string: "\n"
	
		la $a0, input2
		li $v0, 4
		syscall			# print_string: "Input character: "
		li $v0,12
		syscall			# read the character2 without press return
		move $s2, $v0
		la $a0, return
		li $v0, 4	
		syscall			# print_string: "\n"

		la $a0, output
		li $v0, 4
		syscall			# print_string: "Output: "

loop:	
		lb $t1, 0($t0)			# load the character into t1
		beq $t1, $s1, replace	# replace the character if it is found in the string.
		addi $t0, $t0, 1		# move to the next address
		lb $t2, 0($t0)	
		beq $t2, $zero, print	# if the next address is null, then print the result.
		j loop					# Continue if not

replace:	
		sb $s2, 0($t0)			# store the character into the memory
		addi $t0, $t0, 1		# move to the next address
		j loop

print:	
		la $a0, str
		li $v0, 4
		syscall			# print_string
		j exit


exit:	
		li $v0, 10
		syscall			# exit

	