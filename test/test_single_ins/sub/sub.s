.data

.text
    #load data
    addi x1, x0 ,1
    addi x2, x0 ,-2 
    addi x3, x0 ,3
    addi x4, x0 ,-4
    
    #test x0
    sub x0, x1 ,x2

    #test 0

    sub x27, x2, x0

    #test (-)-(+)
    sub x28, x2 ,x1

    #test (+)-(-)
    sub x29, x1 ,x2

    #test (+)-(+)
    sub x30, x1 ,x3

    #test (-)-(-)
    sub x31, x2 ,x4


	hcf
	hcf
	hcf
	hcf
	hcf
	
