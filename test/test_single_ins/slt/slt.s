.data

.text
    #load data
    addi x1, x0 ,1
    addi x2, x0 ,-1
    addi x3, x0 ,2
    addi x4, x0 ,-2
    addi x5, x0 1

    #positive
    #test 
    slt x23, x1 ,x3
    slt x24, x3 ,x1

    #negtive
    slt x25, x2 ,x4
    slt x26, x4 ,x2

    #different sign
    slt x27, x1 , x2
    slt x28, x2 , x1
    slt x29, x3 , x4
    slt x30, x4 , x3

    #equal
    slt x31, x1, x5


	hcf
	hcf
	hcf
	hcf
	hcf
	
