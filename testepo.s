.data

.

.text
	la tp,exceptionHandling	# carrega em tp o endere?o base das rotinas do sistema ECALL
 	csrw tp,utvec 		# seta utvec para o endere?o tp
 	csrsi ustatus,1 	# seta o bit de habilita??o de interrup??o em ustatus (reg 0)	
 	
 	###### O CODIGO FUNCIONA ATRAVEZ DE INTERRUÇÃO, PRECISAMOS DO POOLING AMIGO	 	 		 	 	 	
 	li a7,147
	li a0,160
	li a1,120
	li a2,170
	li a3,120
	li a4,0x0038
	li a5,0

	addi sp,sp,-20 	#pilha posiacao inicial da cobra
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)	
	ecall
	
	li s3 0 #primeira vez que vira pra baixo
	li s4 1 #primeira vez que vira pra direita
	li t4 0 #primeira vez que vira pra esquerda
	li t6 0 #primeira vez que vira pra cima
	

	li s1,1 #se ta pra cima
	li a6 1 #se ta virado pra esquerdA
	
#input flag
input:

	li t1 0xff200000 #Endereço do MMIO
	lw t0 0(t1) 	 #Le o bit de controle do teclado
	andi t0 t0 0x0001 #Mascara o bit menos significativo
	
	beq t0 zero input # = estado anterior #nao tem tecla pressionada entao volta ao loop
	lw t2 4(t1)	#Le o valor da tecla
	mv s2 t2
	
	li t1 0x61 # a
	beq s2 t1 esquerda

	li t1 0x64 # d
	beq s2 t1 direita

	li t1 0x73 # s
	beq s2 t1 desce
	
	li t1 0x77 # w
	beq s2 t1 cima
	
	ret
	
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
	
	li s3,0 
	li s4,0	
	li t4,0
	li s1,1
	j input
			
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
	li s3,0 
	li s4,0	
	li t4,0
	li s1,1
	j input
	
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
	li s3,0 
	li s4,0	
	li t4,0
	li s1,1
	j input
	
direita:
	
	beq s4,zero,viraDireitaCima
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	
	li a7,147
	ecall
	
	li a7,147
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
	ecall
	
	li s3,0
	li t4,0
	li a6,1
	li t6,0
	j input
	
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
	addi s4,s4,1
	li t4,0
	li s3,0
	li a6,1
	li t6,0
	j input
	
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
	addi s4,s4,1
	li t4,0
	li s3,0
	li a6,1
	li t6,0
	j input
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
	li s3,0
	li s4,0
	li a6,0
	li t6,0
	j input

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
	li s3,0
	li s4,0
	li a6,0
	li t6,0
	j input
	
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
	li s3,0
	li s4,0
	li a6,0
	li t6,0
	j input

desce:
	beq s3,zero,viraBaixo
	
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
	li s4,0	
	li t4,0
	li t6,0
	li s1,0
	j input
	
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
	addi s3,s3,1
	li s4,0	
	li t4,0
	li t6,0
	li s1,0
	j input
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
	
	addi s3,s3,1
	li s4,0	
	li t4,0
	li t6,0
	li s1,0
	j input

.include "../SYSTEMv17b.s"