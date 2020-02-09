

.text
	la tp,exceptionHandling	# carrega em tp o endereço base das rotinas do sistema ECALL
 	csrw tp,utvec 		# seta utvec para o endereço tp
 	csrsi ustatus,1 	# seta o bit de habilitação de interrupção em ustatus (reg 0)	
 	
 	li a7,147
	li a0,160
	li a1,120
	li a2,170
	li a3,120
	li a4,0x0038
	li a5,0
	addi sp,sp,-20 	#pilha posição inicial da cobra
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)	
	ecall
	li t0,0 #primeira vez que vira pra baixo
	li t2,1 #primeira vez que vira pra direita
	li t4,0 #primeira vez que vira pra esquerda
	li t6,0 #primeira vez que vira pra cima
	
	li t1,2 #anda pra baixo
	li t3,6 #anda pra direita
	li t5,4 #anda pra esquerda
	li s0,8 #anda pra cima
	li a6,1 #se ta virado para a esquerda
	li s1,1 #se ta pra cima
entrada:li a7,105
	ecall
	beq a0,t1,desce
	beq a0,t3,direita
	beq a0,t5,esquerda
	beq a0,s0,cima
	li a7,10
	ecall

cima:	
	beq t6,zero,viraCima
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	addi a1,a1,-10
	addi a3,a3,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	
	li t0,0 
	li t2,0	
	li t4,0
	li s1,1
	j entrada
			
viraCimaEsq:

 	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a2,0
	addi a0,a0,-10
	add a2,a0,zero
	addi a3,a3,-10
	li a4,0x0038
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 
	ecall
	addi t6,t6,1
	li t0,0 
	li t2,0	
	li t4,0
	li s1,1
	j entrada
	
viraCima:
	beq a6,zero,viraCimaEsq
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a2,0
	addi a0,a0,10
	add a2,a0,zero
	addi a3,a3,-10
	li a4,0x0038
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 
	ecall
	addi t6,t6,1
	li t0,0 
	li t2,0	
	li t4,0
	li s1,1
	j entrada
	
direita:
	beq t2,zero,viraDireitaCima
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	addi a0,a0,10
	addi a2,a2,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	li t0,0
	li t4,0
	li a6,1
	li t6,0
	j entrada
	
viraDireitaCima:
	beq s1,zero,viraDireita
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	li a3,0
	addi a1,a1,-10
	add a3,a1,zero
	addi a2,a2,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	addi t2,t2,1
	li t4,0
	li t0,0
	li a6,1
	li t6,0
	j entrada
	
viraDireita:
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	li a3,0
	addi a1,a1,10
	add a3,a1,zero
	addi a2,a2,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	addi t2,t2,1
	li t4,0
	li t0,0
	li a6,1
	li t6,0
	j entrada
esquerda:
	beq t4,zero,viraEsquerdaCima
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	addi a0,a0,-10
	addi a2,a2,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	li t0,0
	li t2,0
	li a6,0
	li t6,0
	j entrada

viraEsquerdaCima:
	beq s1,zero,viraEsquerda
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	li a3,0
	addi a1,a1,-10
	add a3,a1,zero
	addi a2,a2,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	addi t4,t4,1
	li t0,0
	li t2,0
	li a6,0
	li t6,0
	j entrada
	
viraEsquerda:
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	li a3,0
	addi a1,a1,10
	add a3,a1,zero
	addi a2,a2,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	addi t4,t4,1
	li t0,0
	li t2,0
	li a6,0
	li t6,0
	j entrada

desce:
	beq t0,zero,viraBaixo
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	addi a1,a1,10
	addi a3,a3,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	li t2,0	
	li t4,0
	li t6,0
	li s1,0
	j entrada
	
viraBaixoEsq:
	
 	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a2,0
	addi a0,a0,-10
	add a2,a0,zero
	addi a3,a3,10
	li a4,0x0038
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 
	ecall
	addi t0,t0,1
	li t2,0	
	li t4,0
	li t6,0
	li s1,0
	j entrada
viraBaixo:
	beq a6,zero,viraBaixoEsq
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a2,0
	addi a0,a0,10
	add a2,a0,zero
	addi a3,a3,10
	li a4,0x0038
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 
	ecall
	
	addi t0,t0,1
	li t2,0	
	li t4,0
	li t6,0
	li s1,0
	j entrada
	
	#lw a2,8(sp)
	#li t0,240
	#li a7,105
	#ecall
	#j anda
	#bne a2,t0,anda
	

.include "../SYSTEMv17b.s"
	
