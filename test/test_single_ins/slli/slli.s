.data

.text
    #load data
    addi x1, x0 ,128
    addi x2, x0 ,-129

    #test
    #pos
    slli x28, x1 ,2
    slli x29, x1 ,0
    #neg
    slli x30, x2 ,2
    slli x31, x2 ,0 


	hcf
	hcf
	hcf
	hcf
	hcf
	
