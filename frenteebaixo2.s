

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
	li t1,2 #anda pra baixo
	li t3,6 #anda pra direita
entrada:li a7,105
	ecall
	beq a0,t1,desce
	beq a0,t3,direita
	li a7,10
	ecall
direita:
	beq t2,zero,viraDireita
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
	j entrada
viraBaixo:	
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
	j entrada
	
	#lw a2,8(sp)
	#li t0,240
	#li a7,105
	#ecall
	#j anda
	#bne a2,t0,anda
	

.include "../SYSTEMv17b.s"
	
