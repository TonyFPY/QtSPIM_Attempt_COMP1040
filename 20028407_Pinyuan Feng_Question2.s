		.data
msg:	.asciiz "There is an overflow!\n"
input1:	.asciiz "Please enter the first number: "
input2:	.asciiz "Please enter the second number: "
res:	.asciiz "The result is: "
return: .asciiz "\n"
		.text
		.globl main	
main:	
		la $a0, input1
		li $v0, 4
		syscall				# print_string: "Please enter the first number: "
		li $v0, 5
		syscall
		move $s0, $v0		# s0=x
		la $a0, input2
		li $v0, 4
		syscall				# print_string: "Please enter the second number: "	
		li $v0, 5
		syscall
		move $s1, $v0		# s1=y

		addu $t0, $s1, $s1  # t0=2*y
		move $a0, $t0
		move $a1, $s1
		move $a2, $s1
		jal check2			# check whether there is an overflow
		addu $s2, $t0, $s1	# s2=3*y
		move $a0, $s2
		move $a1, $t0
		move $a2, $s1
		jal check2			# check whether there is an overflow

		mul $s3, $s0, $s0	# s3=x^2
		mflo $a0
		mfhi $a1
		jal check1			# check whether there is an overflow
		mul $s4, $s1, $s1	# s4=y^2
		mflo $a0
		mfhi $a1
		jal check1			# check whether there is an overflow

		addu $t0, $s4, $s4	# t0=2*(y^2)
		move $a0, $t0
		move $a1, $s4
		move $a2, $s4
		jal check2			# check whether there is an overflow
		addu $s5, $t0, $s4	# s5=3*(y^2)
		move $a0, $s5
		move $a1, $t0
		move $a2, $s4
		jal check2			# check whether there is an overflow

		addu $s6, $s0, $s2	# s6=(x+3*y)
		move $a0, $s6
		move $a1, $s0
		move $a2, $s2
		jal check2			# check whether there is an overflow
		addu $s7, $s3, $s5	# s7=(x^2+3*(y^2))
		move $a0, $s7
		move $a1, $t3
		move $a2, $s5
		jal check2			# check whether there is an overflow
	
		mul $t0, $s6, $s7
		mflo $a0
		mfhi $a1
		jal check1			# check whether there is an overflow
		j result

check1:
		addi $t2, $zero, -1		# t2=-1
		beq $a1, $t2, if1		# if hi == -1, jump to if1
		beq $a1, $zero, if2		# else if hi == 0, jump to if2
		bne $a1, $zero, error	# else if hi != 0, jump to error
		jr $ra

if1:	
		bgez $a0, error		# if lo>=0, jump to error
    	jr $ra

if2:	
		bltz $a0, error		# if lo<0, jump to error
		jr $ra

check2:	
		slt $t3,$a0,$zero
    	slt $t4,$a1,$zero
  		slt $t5,$a2,$zero
		beq $t4, $t5, if3	# if the sign of a1 and a2 are same, jump to if3
		jr $ra

if3:	
		bne $t3, $t4, error	# if the sign of a0 and a0 are different, jump to error
		jr $ra

error:	
		la $a0, msg
		li $v0, 4
		syscall				# print_string "There is an overflow!\n"
		j exit

result:	
		la $a0, res
		li $v0, 4
		syscall				# print_string: "The result is: "
		move $a0, $t0
        li $v0, 1
		syscall				# print_int
        la $a0, return
		li $v0, 4
		syscall				# print_string: "\n"
		j exit

exit:	
		li $v0, 10
		syscall				#exit
	