.data

.text
    #load data
    addi x1, x0 ,2
    addi x2, x0 -2

    #test 
    #equal
    sltiu x23, x1 ,2 
    #positive
    sltiu x24, x1 ,1
    sltiu x25, x1 ,3
    sltiu x26, x1 ,0

    #negtive
    sltiu x27, x2 ,-1
    sltiu x28, x2 ,-3
    sltiu x29, x2 ,-0

    #different sign
    sltiu x30, x1 , -3
    sltiu x31, x2 , 1


	hcf
	hcf
	hcf
	hcf
	hcf
	
