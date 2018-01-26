#     Find George Variably Scaled
#
#
# This routine finds an exact match of George's face which may be
# scaled in a crowd of faces.
#
# 10/9/2017                   Gabriel Darosa

.data
Array:  .alloc	1024

.text

FindGeorge:	addi	$1, $0, Array		# point to array base
		swi	592			# generate crowd

# your code goes here

					addi $1, $1, 581				# ptr + offset
					addi $2, $0, 8					# used in predicates
					addi $8, $0, 1					# set col_spot_check = 1
loop1:		lbu $3, 0($1)						# pixel = *(ptr+offset)

					slt $6, $2, $3					# if 8 < pixel
					bne $0, $6, endif1			# go to endif1

					addi $4, $1, 1					# address of offset_offset initialized
					lbu $3, 0($4)						# pixel at address for offset_offset
					addi $7, $0, 1					# width = 1

loop2:		slt $6, $2, $3					# if 8 < pixel
					bne $0, $6, end2				# go to end2

					addi $7, $7, 1					# width++
					addi $4, $4, 1					# offset_offset++
					lbu $3, 0($4)						# pixel at address for offset_offset
					j loop2									# makes the loop

end2:			subu $4, $4, $7					# offset_offset -= width
					addi $4, $4, -1					# offset_offset--
					lbu $3, 0($4)						# pixel at address for offset_offset

loop3:		slt $6, $2, $3					# if 8 < pixel
					bne $0, $6, end3				# go to end3

					addi $7, $7, 1					# width++
					addi $4, $4, -1					# offset_offset--
					lbu $3, 0($4)						# pixel at address for offset_offset
					j loop3									# makes the loop

end3:			srl $7, $7, 1						# width /= 2
					addu $4, $4, $7					# offset_offset += width(new)
					lbu $3, 0($4)						# pixel at address for offset_offset
					addi $5, $0, 7					# theres a 7 in predicate

loop4:		slt $6, $2, $3					# if 8 < pixel
					bne $0, $6, e4loop5			# go to end4, which is start of loop5
					beq $3, $5, e4loop5			# if pixel == 7, branch

					addi $4, $4, 64					# offset_offset += 64
					lbu $3, 0($4)						# pixel at address for offset_offset
					j loop4									# makes the loop

e4loop5:	bne $3, $5, end5				# if pixel != 7, end loop

					addi $4, $4, -64				# offset_offset -= 64
					lbu $3, 0($4)						# pixel at address for offset_offset
					j e4loop5								# makes the loop

end5:			addi $5, $0, 5					# theres a 5 in the predicate
					bne $3, $5, endif1			# if pixel != 5, branch

					addi $7, $0, 1					# scale = 1
					addi $4, $4, 1					# offset_offset++
					lbu $3, 0($4)						# pixel at address for offset_offset

loop6:		slt $6, $5, $3					# if 5 < pixel
					bne $0, $6, end6				# go to end6

					addi $7, $7, 1					# scale++
					addi $4, $4, 1					# offset_offset++
					lbu $3, 0($4)						# pixel at address for offset_offset
					j loop6									# makes the loop

end6:			subu $4, $4, $7					# offset_offset -= scale
					lbu $3, 0($4)						# pixel at address for offset_offset

loop7:		slt $6, $5, $3					# if 5 < pixel
					bne $0, $6, end7				# go to end7

					addi $7, $7, 1					# scale++
					addi $4, $4, -1					# offset_offset--
					lbu $3, 0($4)						# pixel at address for offset_offset
					j loop7									# makes the loop

end7:			addi $4, $4, 1					# offset_offset++
					addi $5, $0, 3					# need to divide by 3
					div $7, $5							# scale / 3
					mflo $7									# scale = ^

					addi $3, $0, 318				# gotta mult by scale
					mult $3, $7							# mult by scale
					mflo $3									# mult output
					subu $3, $4, $3					# pixel to check
					lbu $3, 0($3)						# should be 3
					bne $3, $5, endif1			# its not George

					addi $3, $0, 319				# gotta mult by scale
					mult $3, $7							# mult by scale
					mflo $3									# mult output
					subu $3, $4, $3					# pixel to check
					addi $5, $0, 5					# 5 in pred
					lbu $3, 0($3)						# should be 5
					bne $3, $5, endif1			# its not George

					addi $3, $0, 446				# gotta mult by scale
					mult $3, $7							# mult by scale
					mflo $3									# mult output
					subu $3, $4, $3					# pixel to check
					addi $5, $0, 1					# 1 in pred
					lbu $3, 0($3)						# should be 1
					bne $3, $5, endif1			# its not George

					addi $3, $0, 510				# gotta mult by scale
					mult $3, $7							# mult by scale
					mflo $3									# mult output
					subu $3, $4, $3					# pixel to check
					addi $5, $0, 2					# 2 in pred
					lbu $3, 0($3)						# should be 2
					bne $3, $5, endif1			# its not George

					addi $3, $0, 189				# gotta mult by scale
					mult $3, $7							# mult by scale
					mflo $3									# mult output
					subu $3, $4, $3					# pixel to check
					lbu $3, 0($3)						# should be 8
					bne $3, $2, endif1			# its not George

					addi $2, $0, Array			# so i can subtract array
					subu $4, $4, $2					# offset + offset_offset
					addi $5, $0, 708				# gonna muliply woooooo
					mult $5, $7							# scale * 708
					mflo $5									# mult output
					addi $5, $5, -64				# num to get top left
					subu $4, $4, $5					# top left
					sll $2, $4, 16					# load upper with top left
					addi $5, $0, 780				# gonna mult again!!!!
					mult $5, $7							# scale * 780
					mflo $5									# mult output
					addi $5, $5, -65				# num to get bot right
					addu $4, $4, $5					# bot right
					or $2, $2, $4						# loads lower with bot right
					swi 593									# submit answer and check
					jr $31									# return to caller

endif1:		addi $1, $1, 7					# increment check pixel address by 1 grid

					addi $5, $0, 9					# 9 in next predicate
					bne $8, $5, endif2			# if not at right of picture, branch

					addi $1, $1, 513				# if end column, move to next row of grid
					addi $8, $0, 0					# reset col_spot_check to 0

endif2:		addi $8, $8, 1					# increment col_spot_check
					j loop1									# garunteed to find george so infinite loop
