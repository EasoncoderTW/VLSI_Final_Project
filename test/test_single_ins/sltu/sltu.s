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
    sltu x23, x1 ,x3
    sltu x24, x3 ,x1

    #negtive
    sltu x25, x2 ,x4
    sltu x26, x4 ,x2

    #different sign
    sltu x27, x1 , x2
    sltu x28, x2 , x1
    sltu x29, x3 , x4
    sltu x30, x4 , x3

    #equal
    sltu x31, x1, x5


	hcf
	hcf
	hcf
	hcf
	hcf
	
