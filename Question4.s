		.data
half:	.float 0.5
num:	.float 0.000001
input: 	.asciiz "Input a non-negative floating number: "
output: .asciiz "The square-root of the input is approximately: "
error:	.asciiz "Invalid number! Enter a number again: "
return: .asciiz "\n"
		.text
		.globl main

main:	
		la $a0, input
		li $v0, 4
		syscall				# print_string: "Input a non-negative floating number: "
	
read:	
		li $v0, 6
		syscall				# read_float
		sub.s $f1, $f0, $f0	
		c.lt.s $f0, $f1	
		bc1f initial 		# if input >= 0, then jump to label initial
        la $a0, error		
		li $v0, 4
		syscall				# print_string: "Invalid! Enter a number again: "
		j read

initial:	
		mov.s $f1, $f0		# f1=f0
		la $a0, half		# load address
		lwc1 $f2, 0($a0)	# load float at address a0 into f2, f2=0.5
		mul.s $f3, $f2, $f1	# f3=0.5 * f1
		la $a0, num			# load address
		lwc1 $f4, 0($a0)	# f4=0.000001

loop:	
		sub.s $f5, $f1, $f3
		abs.s $f6, $f5		# abs(f1-f3)
		c.lt.s $f6, $f4		# compare abs(f1-f3) with 1e-6
		bc1t res			# if abs(f1-f3) < 1e-6, then jumps to res
		mov.s $f1, $f3		# f1=f3
		div.s $f7, $f0, $f1 # f7=n/f1
		add.s $f7, $f7, $f1	# f7=f1+n/f1
		mul.s $f3, $f2, $f7	# f3=0.5*(f1+n/f1)
		j loop

res:	
		la $a0, output
		li $v0, 4
		syscall				# print_string: "The square-root of the input is approximately: "
		mov.s $f12, $f3	
		li $v0,  2
		syscall				# print_float
		la $a0, return
		li $v0, 4	
		syscall				# print_string: "\n"
		j exit
	
exit:	
		li $v0, 10
		syscall				# exit