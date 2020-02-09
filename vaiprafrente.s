

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
	li a7,105
	ecall
	j limpacauda
	j anda
	
limpacauda:# CLS Clear Screen
		
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	#ret 
	
anda:	
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
	addi a0,a0,5
	addi a2,a2,5
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	lw a2,8(sp)
	li t0,240
	li a7,105
	ecall
	bne a2,t0,anda
	li a7,10
	ecall
	

.include "../SYSTEMv17b.s"
	
