

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
	
anda:	lw a5,0(sp)
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
	
	bne a2,t0,entra
	
entra:	li a7,105
	ecall
	li t1,2 #baixo
	li t2,6 #direta
	li t3,8 #cima
	li t4,4 #esquerda
	beq a0,t1,desce
	#beq a0,t2,direita
	#beq a0,t3,sobe
	#beq a0,t4,esqueda
	
desce:	
	#limpa o anterior
	#pega o conteudo antigo e pinta de preto
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	#desce
	#para conhecimento geral, to carregando o conteudo antigo e adicionando pra ela andar
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	mv t0,a0
	addi t0,t0,10
	mv a0,t0
	mv a2,t0
	addi a3,a3,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147
	ecall
	j entra
	li a7,10
	ecall
	
.include "../SYSTEMv17b.s"
	
