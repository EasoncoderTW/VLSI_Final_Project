.data

.text
    #load data
    addi x1, x0 ,128
    addi x2, x0 ,-129

    #test
    #pos
    srai x28, x1 ,2
    srai x29, x1 ,0
    #neg
    srai x30, x2 ,2
    srai x31, x2 ,0 


	hcf
	hcf
	hcf
	hcf
	hcf
	
