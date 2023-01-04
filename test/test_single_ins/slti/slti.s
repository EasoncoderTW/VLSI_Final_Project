.data

.text
    #load data
    addi x1, x0 ,2
    addi x2, x0 -2


    #positive
    #test 
    slti x24, x1 ,1
    slti x25, x1 ,3
    slti x26, x1 ,0

    #negtive
    slti x27, x2 ,-1
    slti x28, x2 ,-3
    slti x29, x2 ,-0

    #different sign
    slti x30, x1 , -3
    slti x31, x2 , 1

 
	hcf
	hcf
	hcf
	hcf
	hcf
	
