.data

.text
    #load data
    addi x1, x0 ,1024
    
    #test x0
    ori x0, x1 ,100

    #test 0

    ori x27, x1, 0

    #test 1
    ori x28, x1 ,-1

	hcf
	hcf
	hcf
	hcf
	hcf
	
