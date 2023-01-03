.data

.text
    #load data
    addi x1, x0 ,11
    addi x2, x0 ,-36
    
    #test x0
    xor x0, x1 ,x2

    #test (-)-(+)
    xor x31, x2 ,x1



	hcf
	hcf
	hcf
	hcf
	hcf
	
