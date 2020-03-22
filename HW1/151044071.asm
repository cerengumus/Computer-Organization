.data  
fin: .asciiz "C:\\Users\\user\\Downloads\\input.txt"      # filename for input
buffer: .space 128
buffer1: .asciiz "\n"
val : .space 128
newline: .asciiz "\n"
space : .asciiz " "
arr: .space 160
subStArr: .space 160
sameArr: .space 160
diffArr: .space 160
tempArr: .space 160
temp: .space 160
.text

################################################ 

#open a file for writing
readFile:
	li   $v0, 13       # system call for open file
	la   $a0, fin      # board file name
	li   $a1, 0        # Open for reading
	li   $a2, 0
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor 

#read from file
	li   $v0, 14       # system call for read from file
	move $a0, $s6      # file descriptor 
	la   $a1, buffer   # address of buffer to which to read
	li   $a2, 1024     # hardcoded buffer length
	syscall            # read from file
# Print string from file
	li $v0, 4		   # system call for print string
	la $a0, buffer		   # string
	syscall			   # print string

	addi $t2,$zero,0
	
        la   $s1,arr
	la   $s2,subStArr
	addi $t2,$zero,0
	addi $t3,$zero,0
	addi $t5,$zero,0

L1:
	lb      $t0, buffer($t2)   #loading value
	add     $t2, $t2, 1
	beq     $t0,32,L1
	
	beq     $t0,34,L2
	sw      $t0,0($s1)
	addi    $s1,$s1,4	
	addi    $t5,$t5,1
	bne     $t0, $zero, L1
	
        la   $s2,subStArr
	addi $t3,$zero,0
	
	j L2
	
L2:    	lb      $t0, buffer($t2)   #loading value
	add     $t2, $t2, 1
	beq     $t0,32,L2
	beq     $t0,10,L2
	sw      $t0,0($s2)
	addi    $s2,$s2,4
	addi    $t3,$t3,1
	bne     $t0, $zero, L2
	
	addi    $t0,$zero,42
	sw      $t0,0($s2)
	addi    $s2,$s2,4
	move  $t3,$s3   # store set size 
	addi $t2,$zero,0

Intersection:

	#beq 	$t3,0,printSubSet	
	jal checkSub 
	j Exit1
	
checkSub:
	addi $t9,$zero,0   # count 
	addi $t2,$zero,0   # index subset	
	addi $t7,$zero,0   # index set
loop2:	
	lw $t4,subStArr($t2)
loop:	
	beq $t4,34,out
	lw $t6,arr($t7)
	bne $t4,$t6 in
	sw $t4,sameArr($t2)
	
	addi $t9,$t9,1
	addi $t2,$t2,4
	j loop2	
in:
	addi $t7,$t7,4
	j loop
out:
	jr $ra
Exit1 :
	addi   $t4,$zero,42
	sw $t4,sameArr($t2)
	addi $t2,$t2,4
	j differs

differs :

	#beq 	$t3,0,printSubSet	
	jal checkSubz 
	j Exit9
	
checkSubz:
	addi $t2,$zero,0   # index subset	
	addi $t7,$zero,0   # index set
	addi $t8,$zero,0   # index set
loop2z:	
	addi $t7,$zero,0
	lw $t4,arr($t2)
	addi $t2,$t2,4
	beq  $t4,42,outz
loopz:	
	
	lw $t6,sameArr($t7)
	addi $t7,$t7,4
	beq $t4,$t6 loop2z
	beq $t4,42,loop2z
	bne $t6,42,loopz
	sw $t4,diffArr($t8)
	addi $t8,$t8,4
	j loop2z
	
	
outz:
	jr $ra
Exit9: 
        addi   $t4,$zero,42
	sw $t4,diffArr($t8)
	addi $t8,$t8,4

differs1 :

	#beq 	$t3,0,printSubSet	
	jal checkSubz1 
	j Exit9z
	
checkSubz1:
	addi $t2,$zero,0   # index subset	
	addi $t7,$zero,0   # index set
	addi $t8,$zero,0   # index set
	addi $t1,$zero,0   # index set
	addi $t0,$zero,0   # index set
loop2z1:	
	addi $t7,$zero,0
	lw   $t4,diffArr($t2)
	addi $t2,$t2,4
	beq  $t4,34,inz1
	beq  $t4,42,outz1
loopz1:	
	
	lw   $t6,subStArr($t7)
	addi $t7,$t7,4
	beq $t4,$t6 loop2z
	beq $t4,42,loop2z
	bne $t6,42,loopz
	addi $t1,$t1,1   # index set
	li   $v0,1     #prepare system call
	move $a0,$t1 #copy t0 to a0
	syscall  
	beq  $t4,34,loop2z1
	sw   $t4,tempArr($t8)
	addi $t8,$t8,4
	j loop2z1
	
inz1:sw   $t1,temp
     addi $t0,$t0,4
     j loop2z1
		
outz1:
	jr $ra
Exit9z: 	
      
printtempArr:
	addi $t3,$zero,0
	addi $t4,$zero,10
	la $a0, 0($t4)   
	li $v0, 11   # system call code for print_in
	syscall     # p
	j tempArrprint
		
tempArrprint :
beq $t3,160,Exit19
lw $t4,tempArr($t3)
addi $t3,$t3,4
la $a0, 0($t4)   # integer to print
li $v0, 11   # system call code for print_in
syscall     # p
j tempArrprint
Exit19 :


printtemp0:
	addi $t3,$zero,0
	addi $t4,$zero,10
	la $a0, 0($t4)   
	li $v0, 11   # system call code for print_in
	syscall     # p
	j temp0
		
temp0 :
beq $t3,160,Exit11
lw $t4,diffArr($t3)
addi $t3,$t3,4
la $a0, 0($t4)   # integer to print
li $v0, 11   # system call code for print_in
syscall     # p
j temp0
Exit11 :

printtemp:
	addi $t3,$zero,0
	addi $t4,$zero,10
	la $a0, 0($t4)   
	li $v0, 11   # system call code for print_in
	syscall     # p
	j temp18
		
temp18:
beq $t3,160,Exit
lw $t4,sameArr($t3)
addi $t3,$t3,4
la $a0, 0($t4)   # integer to print
li $v0, 11   # system call code for print_in
syscall     # p


j temp18

Exit:
	addi $t3,$zero,0
	j printArr
printArr:
	addi $t3,$zero,0
	addi $t4,$zero,10
	la $a0, 0($t4)   
	li $v0, 11   # system call code for print_in
	syscall     # p
	j print
print:
beq $t3,80,Exitx
lw $t4,arr($t3)
addi $t3,$t3,4
la $a0, 0($t4)   # integer to print
li $v0, 11   # system call code for print_in
syscall     # p


j print

Exitx:
 	addi $t3,$zero,0
	j SubSet
SubSet:
	addi $t3,$zero,0
	addi $t4,$zero,10
	la $a0, 0($t4)   
	li $v0, 11   # system call code for print_in
	syscall     # p
	j printSubSet
printSubSet:
	beq $t3,280,Exit0
	lw $t4,subStArr($t3)
	addi $t3,$t3,4
	la $a0, 0($t4)   
	li $v0, 11   # system call code for print_in
	syscall     # p


j printSubSet

Exit0:


closeFile:
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
