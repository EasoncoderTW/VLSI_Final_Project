.data

.text
    #load data
    addi x1, x0 ,128
    addi x2, x0 ,-129
    addi x3, x0 ,2
    addi x4, x0 ,0

    #test
    #pos
    sll x28, x1 ,x3
    sll x29, x1 ,x4
    #neg
    sll x30, x2 ,x3
    sll x31, x2 ,x4 

 
	hcf
	hcf
	hcf
	hcf
	hcf
	
