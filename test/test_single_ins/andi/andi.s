.data

.text
    #load data
    addi x1, x0 ,1
    
    #test x0
    andi x0, x1 ,1

    #test
    andi x29, x1 ,3

    #test 0
    andi x30, x1, 0

    #test 1
    andi x31, x1 ,-1



	hcf
	hcf
	hcf
	hcf
	hcf
	
