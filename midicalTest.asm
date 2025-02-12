#Name: Mohammad Khdour		ID:1212517		Section:3
#Name: Alhassan manasra 	ID:1211705 		Section:1

.data
fileName: .asciiz "/Users/Apple/Desktop/University/ARC/data.txt"
newLine: .asciiz "\n"
errorInvalidInput: .asciiz "Invalid input. Please enter a number between 1-6.\n"
IDstatement: .asciiz "IDs in the file is:\n"
Menu: .asciiz "\n1_Add new medical Test\n2_Search for test by patient ID\n3_Average Test value\n4_update in existing test result\n5_Delete Test\n6_exit\nSelect option: "
successAddmassage: .asciiz "New midical test has added successfully\n"
errorrmassage: .asciiz "sorry, the file could not open"
errormassage2: .asciiz "Enter 7 digit intger for ID"
EnterIDmassage: .asciiz "\nEnter Id: "
errorIDmsg: .asciiz "Please enter 7 digit intger for ID"
EnterIDmassage2: .asciiz "\nEnter Id or 0 to exit mode: "
EnterTestType: .asciiz "\nEnter name of the Test: "
EnterDate: .asciiz "\nEnter the Date: "
errorYear: .asciiz "\nPlease enter a year between 1948 - 2024\n"
errorMonth: .asciiz "\nPlease enter a month between 01 - 12\n"
EnterRate: .asciiz "\nEnter Rate: "
searchMsg: .asciiz "\n 1_search for all test by ID\n 2_search for unnormal test by ID\n 3_search for normal Test\n 4_search for all tests within a specific period\nSelect operation: "
updateMsg: .asciiz "\nEnter ID for patient to update: "
deleteMsg: .asciiz "the test has deleted successfully"
updateDone: .asciiz "\nupdate has done successfully"
EnterNewIDMsg: .asciiz "\nEnter new ID: "
EnterNewResultMsg: .asciiz "\nEnter new result: " 
TestFound: .asciiz "Test is found"
TestNotFound: .asciiz "Test is not found"
normalMsg: .asciiz "\nNormal Test\n"
unnormalMsg: .asciiz "\nUnNormal Test\n"
inPeriodMsg: .asciiz "\nin period\n"
promptStartDate: .asciiz "Enter start date (Y-M): "
promptEndDate: .asciiz "Enter end date (Y-M): "
point: .asciiz ":"
dash: .asciiz "-"
LDL: .asciiz "LDL"
RBC: .asciiz "RBC"
HGB: .asciiz "HGB"
BGT: .asciiz "BGT"
BPT: .asciiz "BPT"
avgLDL: .asciiz "Avarege for 'LDL' test is"
avgRBC: .asciiz "Avarege for 'RBC' test is"
avgHGB: .asciiz "Avarege for 'HGB' test is"
avgBGT: .asciiz "Avarege for 'BGT' test is"
avgBPT: .asciiz "Avarege for 'BPT' test is"
maxHGBrate: .float 17.2
minHGBrate: .float 13.8
float_num: .float 0.0
.align 2
fileWord: .space 1024
TestName: .space 4
Date: .space 8
minDate: .space 8
maxDate: .space 8
Rate: .space 4
newMidcal: .space 1024
row: .word 100
col: .word 5
buffer: .space 1024
arrayPointer: .space 1024 
dateOffset: .word 8  # Date is 8 bytes from the start of each record
   


.text


main:

	# Print the header before IDs
        li $v0, 4
        la $a0, IDstatement
        syscall
        
	#jal string_compare_ignore_case
	jal readfromFile
	jal createArray
	WhileTRUE:
	li $v0,4
	la $a0,Menu
	syscall
	
	li $v0,5
	syscall
	
	move $t0,$v0
	
	#Options for menu
	beq $t0,1,AddNewTest
	beq $t0,2,SearchForTest
	beq $t0,3,CalculateAverage
	beq $t0,4,UpdateForTest
	beq $t0,5,DeleteTest
	beq $t0,6,EXIT
	
	#Option '#1' to add a new test
	AddNewTest:
	jal addNewMidicalTest
	j WhileTRUE
	
	SearchForTest:
	jal searchForPatient
	j WhileTRUE
	
	CalculateAverage:
	jal AverageValue
	j WhileTRUE
	
	UpdateForTest:
	jal updateTest
	j WhileTRUE
	
	DeleteTest:
	jal deleteTest
	j WhileTRUE
	
	#Exit from the program
	EXIT:
	jal writeToFile
	li $v0,10
	syscall
	
printTestType:
	move $t0,$a3 #inedx i
	li $t2,1 #index j
	#print (:)
	li $v0,4
	la $a0,point
	syscall

	la $a1,arrayPointer
	mul $t0,$t0,5 # i x 5
	add $t0,$t0,$t2 #(i x 5) + j
	mul $t0,$t0,4 # ((i x 5) + j) x element size 
	add $t0,$t0,$a1
	la $a0,($t0)
	li $v0,4
	syscall
	
	jr $ra

printDate:
	move $t0,$a3 #inedx i
	li $t2,2 #index j
	li $v0,4
	la $a0,point
	syscall

	la $a1,arrayPointer
	mul $t1,$t0,5 # i x 5
	add $t1,$t1,$t2 #(i x 5) + j
	mul $t1,$t1,4 # ((i x 5) + j) x element size 
	add $t1,$t1,$a1
	la $a0,($t1)
	li $v0,4
	syscall
	la $a0,point
	syscall
	
	jr $ra

printRate:
	move $t1,$a2 # mode to read normal or unormal (-1) or to print rate (0)
	move $t0,$a3 #inedx i
	li $t2,4 #index j
	la $a0,arrayPointer
	mul $t0,$t0,5 # i x 5
	add $t0,$t0,$t2 #(i x 5) + j
	mul $t0,$t0,4 # ((i x 5) + j) x element size 
	add $t0,$t0,$a0 
	lwc1 $f12,($t0)

	bnez $t1,TestIfNormal
	print:
	li $v0,2
	syscall
	jr $ra
	
	TestIfNormal:
	la $t3 ,LDL	#load the address of the compered test
	li $s4,-1
	move $t0,$a3	#load the index for pateint to $t0
	mul $t0,$t0,5 # i x 5
	add $t0,$t0,1 #(i x 5) + j
	mul $t0,$t0,4 # ((i x 5) + j) x element size 
	add $t0,$t0,$a0
	Findtest:
	addi $s4,$s4,1
	la $t2,($t0) # load the address of the test
	addi $sp ,$sp ,-12
	sw $ra , ($sp)
	sw $t3,4($sp)
	sw $t0, 8($sp)
	move $a0,$t2 # a0 = the address of first test
	move $a1,$t3	# a1 = the address of seconed test
	jal string_compare_ignore_case # v0 return 1 if they equal
	lw $t0, 8($sp)
	lw $t3,4($sp)
	lw $ra , ($sp)
	addi $t3,$t3,4
	addi $sp ,$sp ,12
	bne $v0,1 Findtest# if the test not found
	
	#Options for tests containt MAx & Min Rates to check if it normal or not, return 0 if test normal else return 1
	beq $s4,0,LDLtest
	beq $s4,1,RBCtest
	beq $s4,2,HGBtest
	beq $s4,3,BGTtest
	beq $s4,4,BPTtest
	
	LDLtest:
	li $t4,100 # the maximum rate for the normal LDL
	mtc1 $t4,$f1	# move to F1
	cvt.s.w $f1,$f1	#convert to float
	c.lt.s $f12,$f1 # set cc = ($f12 < 100)
	bc1t normal # if cc = true than the test is normal
	b unnormal
	
	RBCtest:
	li $t4,20 # the maximum rate for the normal RBC
	mtc1 $t4,$f1	# move to F1
	cvt.s.w $f1,$f1	#convert to float
	c.lt.s $f12,$f1 # set cc = ($f12 < 20)
	bc1t normal # if cc = true than the test is normal
	b unnormal
	
	HGBtest:
	lwc1 $f0 ,minHGBrate
	lwc1 $f1,maxHGBrate

	c.lt.s $f12,$f1 # set cc = ($f12 < 17.2)
	bc1f unnormal
	c.lt.s $f0,$f12 # set cc = (13.8 < $f12)
	bc1f unnormal
	b normal
	
	BGTtest:
	li $t4,99 # the maximum rate for the normal BGT
	li $t3,70 # the mainium rate for the normal BGT
	mtc1 $t4,$f1	# move to F1
	mtc1 $t3,$f0
	cvt.s.w $f0,$f0	#convert to float
	cvt.s.w $f1,$f1	#convert to float
	c.lt.s $f12,$f1 # set cc = ($f12 < 99)
	bc1f unnormal
	c.lt.s $f0,$f12 # set cc = (70 < $f12)
	bc1f unnormal
	b normal
	
	BPTtest:
	li $t4,120 # the maximum rate for the normal BPT
	mtc1 $t4,$f1	# move to F1
	cvt.s.w $f1,$f1	#convert to float
	c.lt.s $f12,$f1 # set cc = ($f12 < 120)
	bc1t normal # if cc = true than the test is normal
	b unnormal
	
	normal:
	li $v0,0 # return 0 if test normal
	jr $ra
	
	unnormal: # if cc = true than the test is normal 
	li $v0,1 # return 1 if test unnormal
	jr $ra
	
#reach index ID from file	
getIndexID:
	#a3 is i index
	#a2 is the ID to compaere
	move $t0,$a3 #index i
	li $t2,0 #index j
	la $a0,arrayPointer
	
	again:
	li $v0,0
	addi $t0,$t0,1
	mul $t1,$t0,5 # i x 5
	add $t1,$t1,$t2 #(i x 5) + j
	mul $t1,$t1,4 # ((i x 5) + j) x element size 
	add $t1,$t1,$a0 # address of array + ((i x 5) + j) x element size 
	lw $t3,($t1)	#load the Id
	beq $t3,0,done5
	bne $t3,$a2,again
	li $v0,1
	done5:
	move $v1,$t0 #return the index for pateint in v1
	jr $ra

#Option '#2' in menu	
#this function is for search about tests on 'ID', or 'Unnormal tests' by ID, or 'Normarl tests' by ID, or tests in a 'specific period' 	
searchForPatient:
	#print massage have option search
	li $v0,4
	la $a0,searchMsg
	syscall
	
	#read the option for search
	li $v0, 5
	syscall
	move $t8,$v0 #save the value in t8
	bgt $t8,4,searchForPatient 
	blt $t8,1,searchForPatient
	
	enterID:
	li $v0,4 #print enter id massage
	la $a0,EnterIDmassage2
	syscall
	
	li $v0,5 # read the ID
	syscall
	move $a2,$v0 #a2 equal the entered ID
	beq $a2,0,exit
	
	li $a3,-1 # is the index i
	li $s3,0 #read date one time for period range
	findOtherTest:
	addi $sp,$sp,-4
	sw $ra,($sp)
	jal getIndexID # return the index of the patient in v1 
			# return 1 if find ID or 0 in V0
	move $a3,$v1 # save the index at a3
	
	lw $ra,($sp)
	addi ,$sp,$sp,4
	bne $v0,1,enterID# if patient not found than Enter new ID  v0 =1 if id exist V0=0 continue 
			   #v1 has the index of the test
	
	beq $t8,2,printUnnormal #if $s4 = 2 then print unnormal test for pateint
	beq $t8,3,printnormal #if $s4 = 3 then print normal test for pateint
	beq $t8,4,printPeriod #if $s4 = 4 then print period range date and return dates in specific period
	
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3 ,4($sp)
	sw $ra,($sp)
	move $a0,$a2
	jal printTest  #print test
	lw $a2,8($sp)
	lw $a3,4($sp)
	lw $ra,($sp)
	addi ,$sp,$sp,12
	blt $a3,30,findOtherTest
	b exit
	
	printnormal:
	
	move $a3,$v1	# a3 = the index number for patient
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3,4($sp)
	sw $ra ,($sp)
	li $a2,1
	jal printRate #a3 is the argumenat have the index for patient
	lw $ra , ($sp)
	lw $a3, 4($sp)
	lw $a2,8($sp)
	addi $sp,$sp,12
	
	beq $v0,1,findOtherTest
	
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3,4($sp)
	sw $ra,($sp)
	move $a0,$a2
	jal printTest
	lw $a2,8($sp)
	lw $a3,4($sp)
	lw $ra,($sp)
	addi ,$sp,$sp,8
	li $v0,4
	la ,$a0,normalMsg #print normal massage
	syscall
	
	blt $a3,30,findOtherTest
	j exit
	
	printUnnormal:
	
	move $a3,$v1	# a3 = the index number for patient
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3,4($sp)
	sw $ra ,($sp)
	li $a2,1
	jal printRate #a3 is the argumenat have the index for patient
	lw $ra , ($sp)
	lw $a3, 4($sp)
	lw $a2,8($sp)
	addi $sp,$sp,12
	
	beq $v0,0,findOtherTest
	
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3,4($sp)
	sw $ra,($sp)
	move $a0,$a2
	jal printTest
	lw $a2,8($sp)
	lw $a3,4($sp)
	lw $ra,($sp)
	addi ,$sp,$sp,8
	li $v0,4
	la ,$a0,unnormalMsg # print normal massage
	syscall
	
	blt $a3,30,findOtherTest
	j exit
	
	printPeriod:
	
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3,4($sp)
	sw $ra ,($sp)
	bgtz $s3,compareDate
	addi $s3,$s3,1
	jal enterDateRange
	
	compareDate:
	la $a1,arrayPointer
	lw $a3,4($sp)
	mul $t1,$a3,5 # i x 5
	addi $t1,$t1,2 #(i x 5) + j
	mul $t1,$t1,4 # ((i x 5) + j) x element size 
	add $t1,$t1,$a1
	la $a0,($t1) #load the address for the date
	la $a1,minDate
	la $a2,maxDate
   	jal dateCompare
	lw $ra , ($sp)
	lw $a3, 4($sp)
	lw $a2,8($sp)
	addi $sp,$sp,12
	
	beq $v0,0,findOtherTest
	
	addi $sp,$sp,-12
	sw $a2,8($sp)
	sw $a3,4($sp)
	sw $ra,($sp)
	move $a0,$a2
	jal printTest
	lw $a2,8($sp)
	lw $a3,4($sp)
	lw $ra,($sp)
	addi ,$sp,$sp,8
	li $v0,4
	la ,$a0,inPeriodMsg# print normal massage
	syscall
	
	blt $a3,30,findOtherTest
	
	exit:
	jr $ra
	
		
printTest: #a0=id,#a3=index i
	li $v0,4
	la $a0,newLine
	syscall
	li $v0,1	# print ID
	move $a0,$a2
	syscall
	addi $sp,$sp,-4
	sw $ra,($sp)
	jal printTestType #a3 is the argumenat have the index for patient
	jal printDate	#a3 is the argumenat have the index for patient
	li $a2,0
	jal printRate #a3 is the argumenat have the index for patient
	lw $ra,($sp)
	addi $sp,$sp,4
	li $v0,4
	la $a0,newLine
	syscall
	jr $ra
    

# Function to prompt and read dates, with validation
enterDateRange:
    	promptStart:
        li $v0, 4
        la $a0, promptStartDate
        syscall
        li $v0, 8
        la $a0, minDate
        li $a1, 10
        syscall
        la $a0, minDate
        addi $sp,$sp,-4
        sw $ra,($sp)
        la $a1,minDate
        jal validateDate1
         lw $ra,($sp)
        addi $sp,$sp,4
        beqz $v0, promptStart

    	promptEnd:
        li $v0, 4
        la $a0, promptEndDate
        syscall
        li $v0, 8
        la $a0, maxDate
        li $a1, 10
        syscall
        la $a0, maxDate
        addi $sp,$sp,-4
        sw $ra,($sp)
        la $a1,maxDate
        jal validateDate1
        lw $ra,($sp)
        addi $sp,$sp,4
        beqz $v0, promptEnd
    
    	jr $ra

# Validate the year and month format
validateDate1:
    	move $a0, $a1     # Load address of the date string
   	li $t0, 0         # Initialize sum for year
    	li $t1, 1000      # Initial multiplier for the first digit (thousands place)

ValidateYear1:
    	lb $t2, 0($a0)    # Load byte (character) from string
    	blt $t2, '0', DateErrorYear1  # Check if character is between '0' and '9'
    	bgt $t2, '9', DateErrorYear1
    	subi $t2, $t2, '0'  # Convert ASCII character to integer
	mul $t3, $t2, $t1   # Multiply digit by place value
    	add $t0, $t0, $t3   # Accumulate into year total
    	addi $a0, $a0, 1    # Move to the next character
    	div $t1, $t1, 10    # Move to the next lower digit place
    	bgtz $t1, ValidateYear1

    	# Check if the year is within valid range
    	li $t3, 1948
    	li $t4, 2024
    	blt $t0, $t3, DateErrorYear1
    	bgt $t0, $t4, DateErrorYear1

    	# Skip '-' character
    	lb $t2, 0($a0)
    	bne $t2, '-', DateErrorYear1
    	addi $a0, $a0, 1

ValidateMonth1:
    	li $t0, 0  # Reset sum for month
    	li $t1, 10  # Multiplier for the tens place of month
    	lb $t2, 0($a0)  # Load first month digit
    	lb $t3, 1($a0)  # Load second month digit
    	subi $t2, $t2, '0'
    	subi $t3, $t3, '0'
    	mul $t0, $t2, $t1
    	add $t0, $t0, $t3

    	li $t1, 1
    	li $t2, 12
    	blt $t0, $t1, DateErrorMonth1
    	bgt $t0, $t2, DateErrorMonth1

    	li $v0, 1  # Set to 1, valid date
    	jr $ra

DateErrorYear1:
    	li $v0, 4
    	la $a0, errorYear
    	syscall
    	li $v0, 0  # Set return value to 0, indicating validation failure
    	jr $ra  # Return to caller, which will check $v0 and potentially re-prompt

DateErrorMonth1:
    	li $v0, 4
    	la $a0, errorMonth
    	syscall
    	li $v0, 0  # Set return value to 0, indicating validation failure
    	jr $ra  # Return to caller, which will check $v0 and potentially re-prompt

DateError1:
   	li $v0, 0  # Set to 0, invalid date
    	jr $ra
   

# Expect $a0 = address of file date, $a1 = start date address, $a2 = end date address
# Checks if file date ($a0) is within the range defined by $a1 and $a2
# Sets $v0 = 1 if in range, 0 if exactly at a boundary
dateCompare:
    	li $t0, 0               # Index for characters in the string
    	move $t4,$a0
    
    	compereMinDate:
    	lb $t1, ($t4)          # Load byte from file date
    	lb $t2, ($a1)          # Load byte from comparison date
     	beq $t1,'\0', compereMaxDate
   	sub $t3,$t1,$t2
    	bgtz $t3,compereMaxDate
    	bltz $t3, outOfRange  # If bytes not equal
    	addiu $t4, $t4, 1       # Increment pointer to next char in $a0
    	addiu $a1, $a1, 1       # Increment pointer to next char in $a1
    	j compereMinDate         # Continue loop

	compereMaxDate:
    	lb $t1, 0($a0)          # Load byte from file date
    	lb $t2, 0($a2)          # Load byte from end date
    	beq $t1,'\0', inRange
    	sub $t3,$t2,$t1
    	bgtz $t3,inRange
    	bltz $t3, outOfRange  # If bytes not equal
    	addiu $a0, $a0, 1       # Increment pointer to next char in $a0
    	addiu $a2, $a2, 1       # Increment pointer to next char in $a1
    	j compereMaxDate        # Continue loop

	outOfRange:
	li $v0,0
	jr $ra
	
	inRange:
	li $v0,1
	jr $ra

#Option '#4' in menu to updates tests in file
updateTest:
	#print massage to enter id for update
	li $v0,4
	la $a0, updateMsg
	syscall
	
	#read ID
	li $v0,5
	syscall
	move $a2,$v0
	li $a3,0 #i = 0
	#find the index for ID
	addi $sp,$sp ,-4
	sw $ra, ($sp)
	jal getIndexID #return id index in array in v1, return 1 if id exist in array on V0 zero else
	lw $ra ,($sp)
	addi $sp,$sp,4
	beq $v0,0,updateTest
	
	
	RateUpdate:
	#print Test Name
	li $v0,4
	la $a0,EnterTestType
	syscall
	
	#read Test Name
	li $v0,8
	la $a0,TestName
	li $a1,4
	syscall
	
	#print massage to read date
	li $v0,4
	la $a0,EnterDate
	syscall
	
	#read date
	li $v0,8
	la $a0,Date
	la $a1,8
	syscall
	
	#print massage to enter new result
	li $v0,4
	la $a0, EnterNewResultMsg
	syscall
	
	#read new result
	li $v0 ,6
	syscall
	
	li $a3,-1 # index i
	loopFindSameID:
	addi $sp ,$sp,-4
	sw $ra ,($sp)
	jal getIndexID
	lw $ra ($sp)
	addi $sp,$sp,4
	beq $v0,0,Done
	
	#get the index of Test Name
	move $a3,$v1
	la $t1,arrayPointer
	mul $t0,$v1,5 # t0 = (i x 5)
	addi $t0,$t0,1 # t0 = ((i x 5) + 1) 1: is index j for rate
	mul $t0,$t0,4 # t0 = (i x 5 + 1) x 4 (element size)
	add $t0,$t0,$t1 # t0 = &array + (i x 5 + 1)x 4 (element size)
	addi $sp,$sp,-4
	sw $ra,($sp)
	
	#check if test name is valible
	move $a0,$t0 #a0= &array [i] [j]
	la $a1,TestName #a1 = address of test name
	jal string_compare_ignore_case
	lw $ra ,($sp)
	addi $sp,$sp,4
	bne $v0,1,loopFindSameID
	
	#get the index of date
	la $t1,arrayPointer
	mul $t0,$v1,5 # t0 = (i x 5)
	addi $t0,$t0,2 # t0 = ((i x 5) + 2) 2: is index j for Date
	mul $t0,$t0,4 # t0 = (i x 5 + 2) x 4 (element size)
	add $t0,$t0,$t1 # t0 = &array + (i x 5 + 2)x 4 (element size)
	addi $sp,$sp,-4
	sw $ra,($sp)
	
	move $a0,$t0 #a0= &array [i] [j]
	la $a1,Date #a1 = address of Date
	jal string_compare_ignore_case
	lw $ra ,($sp)
	addi $sp,$sp,4
	bne $v0,1,loopFindSameID
	
	la $t1,arrayPointer
	mul $t0,$v1,5 # t0 = (i x 5)
	addi $t0,$t0,4 # t0 = ((i x 5) + 4) 4: is index j for rate
	mul $t0,$t0,4 # t0 = (i x 5 + 4) x 4 (element size)
	add $t0,$t0,$t1 # t0 = &array + (i x 5 + 4) x 4 (element size)
	s.s $f0,($t0)
	
	li $v0,4
	la $a0,updateDone
	syscall
	j loopFindSameID
	
	Done:
	
	jr $ra
	
#read data from file
readfromFile:
	#open the file
	li $v0,13
	la $a0 ,fileName
	li $a1, 0
	syscall
	
	move $s3,$v0 # move the discriptor to s0
	bgez $s3, fileExist
	li $v0, 4
	la $a0, errorrmassage
	syscall
	#if the file couldn't open exit program
	li $v0,10
	syscall
	
	#if file exist load the file contant
	fileExist:
	li $v0, 14
	move $a0, $s3
	la $a1, fileWord
	li $a2,1024
	syscall

	# close the file
	li $v0, 16
	move $a0, $s3
	syscall
	jr $ra

#Option '#3' in menu to calculate Avarge values for tests 	
AverageValue:
	la $a0,LDL
	li $t2,0 #inedx i
	li $s4,0 #select Test Type
	mtc1 $t2,$f0
	cvt.s.w $f0,$f0 #average result for each Test
	li $t0,1
	mtc1 $t0,$f4
	cvt.s.w $f4,$f4 #register have 1 used to incerement register by 1
	mov.s $f1,$f0 # counter for test
	findTest:
	la $t1,arrayPointer
	mul $t0,$t2,5 # t0 = (i x 5)
	addi $t0,$t0,1 # t0 = ((i x 5) + 1) 1: is index j for rate
	mul $t0,$t0,4 # t0 = (i x 5 + 1) x 4 (element size)
	add $t0,$t0,$t1 # t0 = &array + (i x 5 + 1)x 4 (element size)
	
	move $a1,$t0 #move the address of the test name to a1
	addi $t2,$t2,1 #incremant i by 1
	lw $t3,($a1) #load test name to t3
	lw $t4,-4($a1)
	beq $t4,-1,findTest
	beq $t3,'\0',NextTest #check if their is no character
	addi $sp,$sp,-12
	sw $a0,8($sp)
	sw $t2,4($sp)
	sw $ra,($sp)
	jal string_compare_ignore_case
	lw $a0,8($sp)
	lw $t2,4($sp)
	lw $ra,($sp)
	addi $sp,$sp,12
	
	bne $v0,1,findTest
	
	add.s $f1,$f1,$f4  #number of test
	l.s $f2,9($a1) #load the rate for test
	add.s $f0,$f0, $f2 #$f0 = the samation for rating
	div.s $f3,$f0,$f1 #the avg value
	j findTest
	
	NextTest:
	li $t2,0 #index i = 0
	mtc1 $t2,$f1 #make counter = 0
	cvt.s.w $f1,$f1 # convert the value in f1 to float
	mov.s $f0,$f1 # make the sum of values =0
	addi $a0,$a0,4 #increament pointer by 4 byte to next Test
	sw $a0,-4($sp)
	
	#Options for Avg test names
	beq $s4,0,AVGLDL
	beq $s4,1,AVGRBC
	beq $s4,2,AVGHGB
	beq $s4,3,AVGBGT
	beq $s4,4,AVGBPT
	
	AVGLDL:
	li $v0,4
	la $a0,avgLDL #load a statment for Avarge LDL test
	syscall
	la $a0,point
	syscall
	j next4
		
	AVGRBC:
	li $v0,4
	la $a0,avgRBC #load a statment for Avarge RBC tesr
	syscall
	la $a0,point
	syscall
	j next4
	
	AVGHGB:
	li $v0,4
	la $a0,avgHGB #load a statment for Avarge HGB test
	syscall
	la $a0,point
	syscall
	j next4
	
	AVGBGT:
	li $v0,4
	la $a0,avgBGT #load a statment for Avarge BGT test
	syscall
	la $a0,point
	syscall
	j next4
	
	AVGBPT:
	li $v0,4
	la $a0,avgBPT #load a statment for Avarge BPT test
	syscall
	la $a0,point
	syscall
	j next4
	
	#print avarge value for test
	next4:
	li $v0,2 
	mov.s $f12,$f3
	syscall
	
	#print new Line
	li $v0,4
	la $a0,newLine
	syscall
	lw $a0,-4($sp)
	
	#make the average equal 0 for next test
	mov.s $f3,$f1 # make the average value = 0
	
	addi $s4,$s4,1 #jump to next test
	#if loop for all test end
	beq $s4,5,Done1
	j findTest
	
	Done1:
	jr $ra

#Option '#5' in menu to delete test from file 	
deleteTest:

	li $v0,4 #print enter id massage
	la $a0,EnterIDmassage2
	syscall
	
	li $v0,5 # read the ID
	syscall
	move $a2,$v0 #a2 equal the entered ID
	beq $a2,0,exit2
	
	li $a3,-1 # is the counter to 10
	findOtherTest2:
	addi $sp,$sp,-4
	sw $ra,($sp)
	jal getIndexID # return the index of the patient in v1 
		       # return 1 if find ID or 0 in V0
	move $a3,$v1 # save the index at a3
	
	lw $ra,($sp)
	addi ,$sp,$sp,4
	bne $v0,1,enterID# if patient not found than Enter new ID  v0 =1 if id exist V0=0 continue 
			  #v1 has the index of the test
	
	#print Test Name
	li $v0,4
	la $a0,EnterTestType
	syscall
	
	#read Test Name
	li $v0,8
	la $a0,TestName
	li $a1,4
	syscall
	
	#print massage to read date
	li $v0,4
	la $a0,EnterDate
	syscall
	
	#read date
	li $v0,8
	la $a0,Date
	la $a1,8
	syscall
	
	li $a3,-1 # index i
	loopFindSameID2:
	addi $sp ,$sp,-4
	sw $ra ,($sp)
	jal getIndexID
	lw $ra ($sp)
	addi $sp,$sp,4
	beq $v0,0,exit2
	
	move $a3,$v1
	
	#get the index of Test Name
	la $t1,arrayPointer
	mul $t0,$v1,5 # t0 = (i x 5)
	addi $t0,$t0,1 # t0 = ((i x 5) + 1) 1: is index j for rate
	mul $t0,$t0,4 # t0 = (i x 5 + 1) x 4 (element size)
	add $t0,$t0,$t1 # t0 = &array + (i x 5 + 1)x 4 (element size)
	addi $sp,$sp,-4
	sw $ra,($sp)
	
	#check if test name is valible
	move $a0,$t0 #a0= &array [i] [j]
	la $a1,TestName #a1 = address of test name
	jal string_compare_ignore_case
	lw $ra ,($sp)
	addi $sp,$sp,4
	bne $v0,1,loopFindSameID2
	
	#get the index of date
	la $t1,arrayPointer
	mul $t0,$v1,5 # t0 = (i x 5)
	addi $t0,$t0,2 # t0 = ((i x 5) + 2) 2: is index j for Date
	mul $t0,$t0,4 # t0 = (i x 5 + 2) x 4 (element size)
	add $t0,$t0,$t1 # t0 = &array + (i x 5 + 2)x 4 (element size)
	addi $sp,$sp,-4
	sw $ra,($sp)
	
	move $a0,$t0 #a0= &array [i] [j]
	la $a1,Date #a1 = address of Date
	jal string_compare_ignore_case
	lw $ra ,($sp)
	addi $sp,$sp,4
	bne $v0,1,loopFindSameID2
	
	# delete the test
	la $a0,arrayPointer
	mul $t1,$a3,5 # i x 5
	mul $t1,$t1,4 # (i x 5) x element size 
	add $t1,$t1,$a0 # address of array + ((i x 5)) x element size 
	li $t3,-1
	sw $t3,($t1)	#store -1 in address of the id for delete
	
	li $v0,4 #print new line
	la $a0,newLine
	syscall
	
	la $a0,deleteMsg
	syscall
	
	j loopFindSameID2
	
	exit2:
	jr $ra
	
	
addmemory:
	move $s0,$zero #use S0 as save register to save last byte to write in array pointer
	li $t4,0 #the index for each test
	
	L2:
	#convert ID from string to intger
	li $v0, 0 # Initialize: $v0 = sum = 0
	li $t2,0 # count number of common 
	lb $t1, 0($a0) # load $t1 = str[i]

	beq $t1 , '\0', done
	blt $t1, '0', next2 # exit loop if ($t1 < '0')
	bgt $t1, '9', next2 # exit loop if ($t1 > '9')
	
	#convert the number from string to digit
	addi $sp ,$sp , -8
	sw $v0,4($sp)
	sw $ra ,($sp)
	move $a1,$v0 #argument 1 have ID number
	jal str2int
	
	move $a1,$v0 #argument 1 have the ID 
	jal checkAndStoreID

	move $a0 ,$v1
	lw $v0 ,4($sp)
	lw $ra ,($sp)
	addi $sp , $sp ,8
	
	
	#store the test type in array pointer
	next2: 
	lb $t1, 0($a0)
	addiu $a0, $a0, 1 # $a0 = address of next char
	beq $t1 , '\0', done # if chracter reach end of test the done
	beq $t1 ,'\r',L2 	
	beq $t1 ,'\n',L2 
	beq $t1 , ':',next2
	beq $t1 , ' ',next2 
	bne $t1 , ',',continue # if the character equal to common (,) then replace it by 0
	li $t1,'\0'
	addi $t2,$t2,1
	beq $t2,2,next3
	
	continue: #load the chracter to array
	sb $t1, arrayPointer($s0)
	addi $s0,$s0,1
	j next2
	
	#convert rate to float point and store it an array
	next3:
	addi $sp,$sp,-4
	sw $ra ,($sp)
	addi $a0,$a0,1
	move $a1,$s0
	jal convert_string_to_float
	lw $ra,($sp)
	addi $sp,$sp,4
	j next2

	done:
	move $v1,$s0	#load to v1 last address in array pointer
	move $s5,$a0	#loat to s5 last address in word file
	jr $ra # return to caller

	
#check if there is word empty to store
checkAndStoreID:	
	#s0 is the first argument have address for next character
	#a1 is the seconed argument have ID number
	li $t3,4 #number for bytes to store the ID
	divu  $s0, $t3	
	mfhi $t5	#remindere
	beq $t5 , $zero , store
	addi $s0,$s0,1

	j checkAndStoreID

	store:
	sw $a1 ,arrayPointer ($s0)
	addi $s0,$s0,4
	jr $ra
	
#check if there is word empty to store
checkAndStoreString:	
	#s0 is the first argument have address for next character
	#a1 the address for first character
	li $t3,4 #number for bytes to store the ID
	divu  $s0, $t3	
	mfhi $t5	#remindere
	beq $t5 , $zero , store2
	addi $s0,$s0,1

	j checkAndStoreString

	store2:
	lb $t6,($a1)
	sb $t6 ,arrayPointer ($s0)
	addi $s0,$s0,1
	addi $a1,$a1,1
	bne $t6,'\0',store2
	jr $ra
	
	
#check if there is word empty to store
checkAndStoreRate:	
	#s0 is the first argument have address for next character
	#f1 is the seconed argument have Rate number
	li $t3,4 #number for bytes to store the ID
	divu  $s0, $t3	
	mfhi $t5	#remindere
	beq $t5 , $zero , store3
	addi $s0,$s0,1

	j checkAndStoreRate

	store3:
	s.s $f1 ,arrayPointer ($s0)
	addi $s0,$s0,4
	jr $ra
	
str2int:
	#a0 is the address for the string which need to convert to integer
	li $v0, 0 # Initialize: $v0 = sum = 0
	li $t0, 10 # Initialize: $t0 = 10
	Loop: lb $t1, 0($a0) # load $t1 = str[i]

	blt $t1, '0', finish # exit loop if ($t1 < '0')
	bgt $t1, '9', finish # exit loop if ($t1 > '9')
	subi $t1, $t1, '0' # Convert character to digit
	mul $v0, $v0, $t0 # $v0 = sum * 10
	addu $v0, $v0, $t1 # $v0 = sum * 10 + digit
	addiu $a0, $a0, 1 # $a0 = address of next char
	j Loop # loop back

	finish: 
	move $v1,$a0 #move the address reached to v1
	move $a0,$v0	#move the ID to a0 to print
	addi $sp ,$sp ,-4
	sw $v0,($sp)
	li $v0,1
	syscall
	li $v0 ,4
	la $a0,newLine
	syscall

	lw $v0,($sp)
	addi $sp ,$sp ,4
	jr $ra # return to calle
	
int2strForID:	#a0 is the integer
		#a1 is the address to store the result

	li $t0, 10 # $t0 = divisor = 10
	addiu $t2, $a1, 9# start at end of buffer
	addi $t2,$t2,-1
	li $t1,' '
	sb $t1,($t2)
	addi $t2,$t2,-1
	li $t1,':'
	sb $t1,($t2)
	L3: divu $a0, $t0 # LO = value/10, HI = value%10

	mflo $a0 # $a0 = value/10
	mfhi $t1 # $t1 = value%10
	addiu $t1, $t1, '0' # convert digit into ASCII
	addiu $t2, $t2, -1# point to previous byte
	sb $t1, 0($t2) # store character in memory
	bnez $a0, L3 # loop if value is not 0
	addi $t2,$t2,-1
	add $t2,$t2,10
	move $v0,$t2
	jr $ra # return to caller

createArray:

	lw $t3, row
	lw $t4,col
	li $t5,4
	
	mul $t3,$t3,$4
	mul $t3,$t3,$t5
	
	li $v0, 9	#creat 2D array
	move $a0,$t3
	syscall
	
	move $s4, $v0	#move the address for array to $s4
	sw $s4, arrayPointer # arrayPointer
	
	
	la $s3, fileWord
	move $a0,$s3 	#address for file word

	addi $sp ,$sp , -4
	sw $ra ,($sp)
	jal addmemory
	lw $ra ,($sp)
	addi $sp , $sp ,4

	jr $ra

#Option '#1' in menu to add a new medical test with it's ID, Test name, Date & Rate with validation and check errors in them		
addNewMidicalTest:
	#print massage for user to inter 7 digit
	EnterID:
	li $v0,4
	la $a0,errormassage2
	syscall
	#print enter id massage
	li $v0,4
	la $a0,EnterIDmassage
	syscall
	
	#read Id
	li $v0,5
	syscall
	
	move $t0,$v0 #the t0 = ID added
	move $t3,$v0
	li $t1,0 # number of digit integer for ID
	li $t2,10 # counetr = ID/10
	counter:
	div $t0,$t2  #lo:ID/10 hi ID%10
	mflo $t0
	addu $t1,$t1,1
	bne $t0 ,$zero,counter
	li $v0,1
	move $a0,$t1
	syscall
	
	bne $t1,7,ErrorID #if the ID is not 7 digit enter new ID
	beq $t1,7,cont
	
	ErrorID:
	li $v0,4 #print new line
	la $a0,newLine
	syscall
	
	li $v0,4 #if ID is not equal 7 digits
	la $a0,errorIDmsg
	syscall
	
	li $v0,4 #print new line
	la $a0,newLine
	syscall
	bne $t1,7,EnterID #if the ID is not 7 digit enter new ID
	
	cont:
	addi $sp,$sp,-4
	sw $ra,($sp)
	move $a1,$t3
	jal checkAndStoreID	#store the ID in array pointer 4 bytes
	lw $ra,($sp)
	addi $sp,$sp,4
	
	#massage to enter test name
	addi $sp,$sp,-4
	sw $ra ,($sp)
	jal EnterTestName
	move $a1,$v0 # move the address of the test to a1
	#argumant a1 have the address for test name to store
	jal checkAndStoreString #store the test name in word at array
	lw $ra,($sp)
	addi $sp,$sp,4
	
	# Print message to enter the date
	enterDate:
    	li $v0, 4
    	la $a0, EnterDate
    	syscall

    	# Read date input from user
    	li $v0, 8
    	la $a0, Date
    	li $a1, 8  # Buffer size
    	syscall
   
    	# Validate the year and month format 
	validateDate:
    	la $a0, Date  # Load address of the date string
    	li $t0, 0     # Initialize sum for year
    	li $t1, 1000  # Initial multiplier for the first digit	

	ValidateYear:
    	lb $t2, 0($a0)  # Load byte (character) from string
    	# Check if character is between '0' and '9'
    	blt $t2, '0', DateErrorYear
    	bgt $t2, '9', DateErrorYear
    	subi $t2, $t2, '0'  # Convert ASCII to integer
    	mul $t3, $t2, $t1   # Multiply digit by its place value
    	add $t0, $t0, $t3   # Add to the year total
    	addi $a0, $a0, 1    # Move to next character
    	div $t1, $t1, 10    # Decrease multiplier by 10
    	bgtz $t1, ValidateYear

    	# Validate year range
    	li $t3, 1948
    	li $t4, 2024
    	blt $t0, $t3, DateErrorYear
    	bgt $t0, $t4, DateErrorYear

    	# Skip '-' character
    	addi $a0, $a0, 1

    	# Validate month (assume characters are valid digits)
    	li $t0, 0  # Reset sum for month
    	li $t1, 10  # Multiplier for the tens place of month
    	lb $t2, 0($a0)  # Load first month digit
    	lb $t3, 1($a0)  # Load second month digit
    	# Convert and check month digits
    	subi $t2, $t2, '0'  # First digit
    	subi $t3, $t3, '0'  # Second digit
    	mul $t0, $t2, $t1   # Month tens
    	add $t0, $t0, $t3   # Complete month number

    	# Check month range
    	li $t1, 1
    	li $t2, 12
    	blt $t0, $t1, DateErrorMonth1
    	bgt $t0, $t2, DateErrorMonth1

    	j storeDate
    	
    	#Message for error in year 
	DateErrorYear:
    	li $v0, 4
    	la $a0, errorYear
    	syscall
    	j enterDate
	
	#Message for error in month
	DateErrorMonth:
    	li $v0, 4
    	la $a0, errorMonth
    	syscall
    	j enterDate
	
	#Save date
	storeDate:
	addi $sp,$sp,-4
    	sw $ra,($sp)  # Save return address on stack
    	la $a1, Date  # Argument for where the date string is stored

    	jal checkAndStoreString # store the date in array
    	lw $ra, ($sp)  # Save return address on stack
    	addi $sp,$sp,4
    	
	#print message to enter the rate
	li $v0,4
	la $a0,EnterRate
	syscall
	
	#read Rate
	li $v0,6
	syscall
	
	mov.s $f1,$f0 #move the entered rate to f1: argumant for checkAndStoreRate to store on array
	addi $sp,$sp,-4
	sw $ra,($sp)
	jal checkAndStoreRate
	lw $ra, ($sp)
	addi $sp,$sp,4
	
	
	li $v0,4
	la $a0,successAddmassage #Message  for added a new test successfully
	syscall

	jr $ra
	
	#print message to enter test name
	EnterTestName:
	li $v0,4
	la $a0,EnterTestType
	syscall
	
	#read test name
	li $v0, 8
	la $a0, TestName
	li $a1,4
	syscall
	
	#check test name if valied
	la $a1,LDL # load the first test address to check if the entered test is exist 
	li $s1,0
	addi,$sp,$sp,-12
	sw $ra,($sp)
	FindTest:
	sw $a1,4($sp)
	sw $a0,8($sp)
	jal string_compare_ignore_case #compere between saved test and enterted test	
	lw $ra,($sp)  #load the address of the return function to ra
	lw $a1,4($sp)
	lw $a0,8($sp)
	beq $v0,1,valied #if the test entered is valied then store it in memory
	beq $s1,4,unvalied #if the entered test is not valied try agian to enter test name
	addi $a1,$a1,4
	addi $s1,$s1,1
	j FindTest

	#print massage to tell user the test is unvalied
	unvalied:
	li $v0,4
	la $a0,newLine #print new line
	syscall
	la $a0,TestNotFound #print massage to tell user test not found
	syscall
	addi $sp,$sp,12 # to repeat the operation we need to add 12 to stack pointer to make the stack empty
	j EnterTestName #repeat the operation to add name of the test
	
	valied: #print massage to know that the test found
	li $v0,4
	la $a0,newLine
	syscall
	la $a0,TestFound #print massage to tell user test found
	syscall
	addi $sp,$sp,12 #when find the test is valied incremeant stack pointer with 12 to make it empty
	move $v0,$a1 # return the address for Test name in V0
	jr $ra

#function to write data on file	
writeToFile:
	# open the file to write
	li $v0, 13
	la $a0, fileName
	li $a1, 1
	li $a2,0
	syscall
	
	move $s1, $v0 #file descriptor
	li $t0,-1 #t0= i index
	la $a2,arrayPointer
	la $a1,buffer
	loop3:
	addi $t0,$t0,1
	#for ID
	mul $t2,$t0,5 #(i x 5)
	add $t2,$t2,0 #(i x 5) + j
	mul $t2,$t2,4 #((i x 5) + j ) x element size 
	add $t2,$t2,$a2 # &arrayPointer + ((i x 5) + j ) x element size 
	lw $a0,($t2) #a0 = ID
	beq $a0,-1,loop3
	beq $a0,0,Done4
	addi $sp,$sp,-12
    	sw $ra,($sp)
    	sw $t0,4($sp)
    	sw $a2,8($sp)
    	#a1 = address for buffer
    	jal int2strForID
    	lw $ra,($sp)
    	lw $t0,4($sp)
    	lw $a2,8($sp)
    	addi $sp,$sp,12
    	
    	move $a1,$v0
    	
    	#for Test Name
    	mul $t2,$t0,5 #(i x 5)
	add $t2,$t2,1 #(i x 5) + j
	mul $t2,$t2,4 #((i x 5) + j ) x element size 
	add $t2,$t2,$a2 # &arrayPointer + ((i x 5) + j ) x element size 
	move $a0,$t2
	
	addi $sp,$sp,-12
    	sw $ra,($sp)
    	sw $t0,4($sp)
    	sw $a2,8($sp)
    	#a1 = address for buffer
    	jal StoreString
    	lw $ra,($sp)
    	lw $t0,4($sp)
    	lw $a2,8($sp)
    	addi $sp,$sp,12
    	
    	move $a1,$v0
    	
    	#for Date
    	mul $t2,$t0,5 #(i x 5)
	add $t2,$t2,2 #(i x 5) + j
	mul $t2,$t2,4 #((i x 5) + j ) x element size 
	add $t2,$t2,$a2 # &arrayPointer + ((i x 5) + j ) x element size 
	move $a0,$t2
	
	addi $sp,$sp,-12
    	sw $ra,($sp)
    	sw $t0,4($sp)
    	sw $a2,8($sp)
    	#a1 = address for buffer
    	jal StoreString
    	lw $ra,($sp)
    	lw $t0,4($sp)
    	lw $a2,8($sp)
    	addi $sp,$sp,12
    	
    	move $a1,$v0
    	
    	#for Float numbe
    	mul $t2,$t0,5 #(i x 5)
	add $t2,$t2,4 #(i x 5) + j
	mul $t2,$t2,4 #((i x 5) + j ) x element size 
	add $t2,$t2,$a2 # &arrayPointer + ((i x 5) + j ) x element size 
	l.s $f10,($t2)
	
	addi $sp,$sp,-12
    	sw $ra,($sp)
    	sw $t0,4($sp)
    	sw $a2,8($sp)
    	#a1 = address for buffer
    	jal convertFLoatToSTR
    	lw $ra,($sp)
    	lw $t0,4($sp)
    	lw $a2,8($sp)
    	addi $sp,$sp,12
    	
    	 move $a1,$v0
    	li $t1,'\n'
    	sb $t1,($a1)
    	
    	addi $a1,$a1,1
    	
    	j loop3
    	
    	Done4:
	#write to file
	li $v0,15
	move $a0,$s1
	la $a1,buffer
	li $a2,1024
	syscall
	
	 #close the file
	li $v0, 16
	move $a0, $s1
	syscall
	
	jr $ra
	
	
StoreString:
	#a0 is the address for first character to store
	#a1 is the address where to storestore2:
	lb $t0,($a0)
	sb $t0 , ($a1)
	addi $a0,$a0,1
	addi $a1,$a1,1
	bne $t0,'\0',StoreString
	addi $a1,$a1,-1
	li $t0,','
	sb $t0,($a1)
	addi $a1,$a1,1
	li $t0,' '
	sb $t0,($a1)
	addi $a1,$a1,1
	move $v0,$a1
	jr $ra
	

convertFLoatToSTR:  #$f10 is the first argumeant have the float number 
		     #$a1,is the second argumant to store the result
    	mov.s $f0, $f10  #load float number on $f0
   	li $t0, 10
   	mtc1 $t0,$f1
   	cvt.s.w $f1,$f1
    
    	li $t3,10 #mulipler and divider
    	li $t1,0  #to store digits after float point
    	li $t2,0  #counter for digits after point
    
    	cvt.w.s $f0, $f0  #convert from a single float to an integer word and store on it selfs
    	mfc1 $t0, $f0     #move the integer to $t0
    	move $t4, $zero   #copy zero on $t4
  
   	mov.s  $f0,$f10 #reload the float number on $f0 again
    
    	#In this function i want to store the digits after floating point in $t1 and use $t2 counter for this digits
    	after_point:
    	mul $t1,$t1,$t3       #muliply digit after dicemal by 10
    	mul.s $f0,$f0,$f1     # muliply float number by 10
    	cvt.w.s $f3,$f0       #convert to an integer word
    	mfc1 $t5,$f3          #move the integer number to t5
    	div $t5,$t3           #divied the integer by 10
    	mfhi $t4              #save the reminder in t4
    	add $t1,$t1,$t4       #add to t1 remander
    	addi $t2,$t2,1        #incermeant the counter by 1
    	bne $t2,2,after_point #check if read 4 digit after point
    
    	li $t4,0     #reset the counter used for digit counting
    	move $t2,$t0 #copy the integer part of the float number 

#count digits of integer part of the float number   
CountDigits:
    	div $t2, $t2, 10  #divied inetger part by 10
    	addiu $t4, $t4, 1 #Count the number of digits
    	mflo $t2          #save the quotient of the division.
    	beq $t2, 0, Done3  #If no more digits left exit
    	j CountDigits
	
	Done3: 

    	move $a0, $t0    #a0 = the number befor point   
    	move $a1,$a1     #a1 is the address to store      
    	move $a2,$t4 
    	addi $sp,$sp,-4
    	sw $ra,($sp)        
    	jal Float2str
    	lw $ra,($sp)
    	addi $sp,$sp,4
    	move $a1,$v0  #store the address of the end of the string
    
    	li $t2, '.'
    	sb $t2, ($a1)
    	addi $a1,$a1,1

    	beq $t1,0,exit3
     	move $a0,$t1
    	li $a2,2
    	addi $sp,$sp,-4
    	sw $ra,($sp)        
    	jal Float2str
    	lw $ra,($sp)
    	addi $sp,$sp,4
    	move $a1,$v0    
     	#V0 is the return value have the address for next character
     	exit3:
   	jr $ra
    
Float2str:
    	li    $t0, 10        # $t0 = divisor = 10
    	add $s4, $a1, $a2   # Start at end of buffer
	L1:    
	divu  $a0, $t0      # LO = value/10, HI = value%10
    	mflo  $a0        # $a0 = value/10
    	mfhi  $t2         # $t1 = value%10
    	addiu $t2, $t2, 48  # Convert digit into ASCII
    	addi $s4, $s4, -1  # Point to previous byte
     	sb    $t2, 0($s4)   # Store character in memory
    	bnez  $a0, L1       # Loop if value is not 0
    
    	add $s4,$s4,$a2
    	move $v0,$s4
    	jr    $ra           # Return to calle
	
# String comparison function with ignoring case and converting lower case to upper case
string_compare_ignore_case:
    # $a0: Address of the first string
    # $a1: Address of the second string

    	loop5:
        lb  $t0, 0($a0)   # Load byte from the first string
        lb  $t1, 0($a1)   # Load byte from the second string
        
        # Convert characters to uppercase (if applicable)
        sw $a0,-4($sp)
        sw $a1,-8($sp)
        sw $ra,-12($sp)
        move $a0,$t0
        move $t4,$t1
        jal to_uppercase  # Convert character in $t0 to uppercase
        move $t2, $v0     # Store uppercase character of the first string
        move $a0,$t4
        jal to_uppercase  # Convert character in $t1 to uppercase
        move $t3, $v0     # Store uppercase character of the second string
        lw $a0,-4($sp)
        lw $a1,-8($sp)
        lw $ra,-12($sp)
        # Check if the characters are equal
        beq $t2, $t3, check_null   # If characters are equal, continue checking or exit loop
        # If characters are not equal, strings are not equal
 
        li $v0,0	#return zero if not equal
        jr  $ra            # Return
        
    	check_null:
        # Check if the end of the string is reached
        beq $t2, $zero, strings_equal   # If end of string is reached, strings are equal
        addi $a0, $a0, 1   # Move to next character in the first string
        addi $a1, $a1, 1   # Move to next character in the second string
        j loop5            # Continue loop
        
	strings_equal:
 
        li $v0,1 #return 1 if equal
	jr $ra

        
	to_uppercase:
    	# $a0: ASCII value of the character to convert
    
   	 li   $t0, 'a'       # ASCII value of 'a'
   	 li   $t1, 'z'       # ASCII value of 'z'
   	 blt  $a0, $t0, end_convert_uppercase   # If character is not lowercase, end conversion
   	 bgt  $a0, $t1, end_convert_uppercase   # If character is not lowercase, end conversion
    
    	subi $a0, $a0, 32   # Subtract 32 to convert to uppercase (ASCII difference between 'a' and 'A')
    
	end_convert_uppercase:
	    move $v0, $a0       # Return converted character in $v0
    	jr   $ra            # Return
	
# Function to convert a string representing a float number to a float number
# $a0: Address of the string
# $a1: address for array to store the result
convert_string_to_float:
    	# Initialize variables
    	li $t1, 0          # Counter for digits before the decimal point
    	li $t2, 0          # Counter for digits after the decimal point
    	li $t3, 0          # Flag to track if the current digit is before or after the decimal point
    	li $t4, 10         # Base for decimal arithmetic
    
    	mtc1 $zero,$f1
    	cvt.s.w $f1,$f1
    	mtc1 $t4,$f5
    	cvt.s.w $f5,$f5
    	mtc1 $t4,$f4
    	cvt.s.w $f4,$f4
    
    	# Load the address of the float number storage
    	#la      $a1, float_num
    
    	loop4:
        lb      $t5, 0($a0)    # Load the current character
        
        # Check if the current character is the decimal point
        beq     $t5, '.', set_decimal_flag   # If decimal point, set decimal flag and continue
        
        # Check if the current character is the null terminator
        blt    $t5,'0' done3       # If not a digit, exit loop
        
        # Check if the current character is a digit
        bgt    $t5,'9' done3       # If not a digit, exit loop
        
        
        # Convert character to integer
        subi    $t5, $t5, '0'  # Convert ASCII digit to integer
        
        # Check if the current digit is before or after the decimal point
        beq     $t3, $zero, before_decimal
        b       after_decimal
        
    	before_decimal:
        # Multiply previous digits by base
        mul.s   $f1, $f1, $f4   # Multiply float number by 10
        mtc1    $t5, $f2         # Convert integer to float
        cvt.s.w $f2, $f2
        add.s   $f1, $f1, $f2    # Add digit to float number
        j       next_char
        
    	after_decimal:
        # Divide following digits by base
        mtc1    $t5, $f2         # Convert integer to float
        cvt.s.w  $f2,$f2
        div.s   $f2, $f2, $f4    # Divide float number by divisor
        add.s   $f1, $f1, $f2    # Add digit to float number
        mul.s   $f4,$f4,$f5	   #muliply the divisor by 10
        j       next_char
        
    	set_decimal_flag:
        # Set flag to indicate decimal point has been encountered
        li      $t3, 1           # Set decimal flag
        j       next_char
        
    	next_char:
        # Move to the next character in the string
        addi    $a0, $a0, 1      # Move to next character
        j       loop4             # Repeat loop
        
    	done3:
        # Store the final float number in memory
        addi $sp,$sp ,-4
        sw $ra,($sp)
        jal checkAndStoreRate
        lw $ra ,($sp)
        addi $sp,$sp,4
        
        jr      $ra               # Return
