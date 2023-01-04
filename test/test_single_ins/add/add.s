.data

.text
    #load data
    addi x1, x0 ,1
    addi x2, x0 ,-2 
    addi x3, x0 ,3 
    addi x4, x0 ,-4
    
    #test x0
    add x0, x1 ,x2

    #test (-)+(+)
    add x28, x2 ,x1

    #test (+)+(-)
    add x29, x3 ,x2

    #test (+)+(+)
    add x30, x3 ,x1

    #test (-)+(-)
    add x31, x2 ,x4

	hcf
	hcf
	hcf
	hcf
	hcf
	
