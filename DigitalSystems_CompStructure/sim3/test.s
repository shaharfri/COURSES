.text
main:   # Put your code here
        add		t6, x0, x0
		lw 		t2, 8(x0)
		addi 	t2,t2,12
		sw 		t2, 16(x0)
        beq		t6, x0, finish

deadend: beq	t6, x0, deadend        

finish:
        lw		t4, 0(x0)
        lw		t5, 4(x0)
        sw		t5, 0xFF(t4)
        beq		t6, x0, deadend
