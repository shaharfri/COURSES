# Operands to multiply
.data
a: .word 0xBAD
b: .word 0xFEED

.text
main:   # Load data from memory
		la      t3, a
        lw      t3, 0(t3)
        la      t4, b
        lw      t4, 0(t4)
        
        # t6 will contain the result
        add		t6, x0, x0
		
        # Mask for 16x8=24 multiply
        ori		t0, x0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        slli	t0, t0, 8
        ori		t0, t0, 0xff
        
####################
# Start of your code

add		t5, x0, x0
ori		t5, x0, 0xff        
slli	t5, t5, 8 
and		t6, t3, t5
mul		t6, t6, t4
add		t5, x0, x0
ori		t5, x0, 0xff   
add		t1, x0, x0
and		t1, t3, t5
mul		t1, t1, t4
add		t6, t6, t1

####################
		
finish: addi    a0, x0, 1
        addi    a1, t6, 0
        ecall # print integer ecall
        addi    a0, x0, 10
        ecall # terminate ecall


