# modify ret to 5* hcf

.data

.text
    #test every reg
    addi x1, x0 ,1
    addi x2, x0 ,2 
    addi x3, x0 ,3 
    addi x4, x0 ,4 
    addi x5, x0 ,5 
    addi x6, x0 ,6 
    addi x7, x0 ,7 
    addi x8, x0 ,8 
    addi x9, x0 ,9 
    addi x10, x0 ,10 
    addi x11, x0 ,11 
    addi x12, x0 ,12 
    addi x13, x0 ,13 
    addi x14, x0 ,14 
    addi x15, x0 ,15 
    addi x16, x0 ,16 
    addi x17, x0 ,17 
    addi x18, x0 ,18 
    addi x19, x0 ,19 
    addi x20, x0 ,20
    addi x21, x0 ,21
    addi x22, x0 ,22 
    addi x23, x0 ,23 
    addi x24, x0 ,24 
    addi x25, x0 ,25 
    addi x26, x0 ,26 
    addi x27, x0 ,27 
    addi x28, x0 ,28 
    addi x29, x0 ,29 
    addi x30, x0 ,30
    addi x31, x0 ,31
    
    #test x0
    addi x0, x10 ,10 

    #test immediate zero
    addi x29, x2 ,0

    #test immediate positive
    addi x30, x2 ,2

    #test immediate negtive
    addi x31, x2 ,-3 

	hcf
	hcf
	hcf
	hcf
	hcf
	
