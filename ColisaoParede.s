##################################################################
#  Programa de exemplo de uso de frames no Bitmap Display Tool   #
#  ISC Set 2019			  			         #
#  Marcus Vinicius Lamar		  		         #
##################################################################
#
# Use o programa paint.net (baixar da internet) para gerar o arquivo .bmp de imagem 320x240 e 24 bits/pixel 
# para então usar o programa bmp2isc.exe para gerar o arquivo .data correspondente para colocar no include
#
# Abra duas janelas do Bitmap, uma com frame 0 e outra com a frame 1

.data
.include "snakegame2a.s"
.include "snakegame2b.s"
msg1: 	.string "SNAKE "
roda_pe: .string "OAC VERAO"
msg_start: .string "Inicializando o jogo: "
msg_high: .string "HIGHSCORE:"
msg_speed: .string "Level Speed:"
buffer: .string "                                "



.text
	la tp,exceptionHandling	# carrega em tp o endereço base das rotinas do sistema ECALL
 	csrw tp,utvec 		# seta utvec para o endereço tp
 	csrsi ustatus,1 	# seta o bit de habilitação de interrupção em ustatus (reg 0)	
# Preenche a tela de vermelho
	li t0,2
	j TelaInicial
	

# Carrega a imagem1
TelaInicial:	
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la s1,snakegame2a		# endereço dos dados da tela na memoria
	addi s1,s1,8		# primeiro pixels depois das informações de nlin ncol
LOOP1: 	beq t1,t2,Entrada	# Se for o último endereço então sai do loop
	lw t3,0(s1)		# le um conjunto de 4 pixels : word
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	addi s1,s1,4
	j LOOP1			# volta a verificar

#enter para iniciar o menu
Entrada: li a7,105
	 ecall

Menu:	li t0,2
	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	la s1,snakegame2b
	addi s1,s1,8	# cor vermelho|vermelho|vermelhor|vermelho
LOOP3: 	beq t1,t2,FIM	
	lw t3,0(s1)	# Se for o último endereço então sai do loop
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4	
	addi s1,s1,4	# soma 4 ao endereço
	j LOOP3		# volta a verificar
FIM:	li a7,105
	ecall
	bge a0,t0,sai
	j inicio
sai:	li t1,0xFF000000	# endereco inicial da Memoria VGA - Frame 0
	li t2,0xFF012C00	# endereco final 
	li t3,0x00000000	# cor preto
LOOP: 	beq t1,t2,sai2		# Se for o último endereço então sai do loop
	sw t3,0(t1)		# escreve a word na memória VGA
	addi t1,t1,4		# soma 4 ao endereço
	j LOOP			# volta a verificar
sai2:   li a7,10
        ecall
inicio:	
jal CLS
jal str_snake
jal str_start
jal str_roda
jal SLEEP
jal CLS
jal str_snake
jal str_roda
jal str_high
jal str_speed
jal str_score_int
jal str_speed_int

jal botton_bord
jal left_bord
jal right_bord
jal top_bord

##### na funcao str score int t0 = pontuacao
# na funcao str speed t1 = pontuacao

j comecacobra
																																		
# CLS Clear Screen
CLS:
li a0,0x00
li a7,148
li a1,0
ecall
ret
	
CLSV:	
li a7,141
ecall
li a7,148
li a1,0
ecall
ret

#########################
# a1 =  X (0 ate 320)   #
# a2 =  Y (0 ate 240)   #
######################### 		

# syscall "SNAKE"
str_snake: 
li a7,104
la a0,msg1
li a1,2
li a2,0
li a3,0x0038
li a4,0
ecall
ret		

# sycall "msg_start"
str_start: 
li a7,104
la a0, msg_start
li a1 80
li a2 102
li a3,0x0038
li a4,0
ecall
ret		

#sycall "HIGHSCORE"
str_high: 
li a7,104
la a0, msg_high
li a1 2
li a2 70
li a3,0x0038
li a4,0
ecall
ret		

#sycall "LEVEL SPEED"
str_speed: 
li a7,104
la a0, msg_speed
li a1 2
li a2 106
li a3,0x0038
li a4,0
ecall
ret		

#sycall "RODA PE"

str_roda:
li a7,104
la a0, roda_pe
li a1 2
li a2 230
li a3,0x0038
li a4,0
ecall
ret		

# syscall sleep
SLEEP:	
li t0, 2
LOOPHMS:
li a0,1000   # 1 segundo
li a7,132
ecall
addi t0,t0,-1

#print seg
mv a0,t0
li a7,101
li a1,162
li a2,112
li a3,0x0038
li a4,0
ecall
bne t0,zero,LOOPHMS	
ret

#syscall pontuacao
str_score_int:
li t0 0
li a7 101
mv a0 t0
li a1 2
li a2 90
li a3 0x0038
li a4 0
ecall 
ret

str_speed_int:
li t1 0
li a7 101
mv a0 t1
li a1 2
li a2 128
li a3 0x0038
li a4 0
ecall 
ret

#Draw map
left_bord:
li a7 147
li a0 100
li a1 10
li a2 100
li a3 230
li a4 0x0038
li a5 0
ecall
ret

top_bord:
li a7 147
li a0 100
li a1 10
li a2 310
li a3 10
li a4 0x0038
li a5 0
ecall
ret

right_bord:
li a7 147
li a0 310
li a1 10
li a2 310
li a3 230
li a4 0x0038
li a5 0
ecall
ret

botton_bord:
li a7 147
li a0 100
li a1 230
li a2 310
li a3 230
li a4 0x0038
li a5 0
ecall
ret
	
comecacobra: 
	li t3,100
	li t4,310
	li t5,10
	li t6,230
	
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
	li s5 0 #primeira vez que vira pra esquerda
	li s6 0 #primeira vez que vira pra cima
	
	#li s5,0

	li s1,1 #se ta pra cima
	li s0 1 #se ta virado pra esquerdA
	
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
limpa:
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0000
	li a7,147
	ecall
	ret
cima:	
	beq s6,zero,viraCima
	jal limpa
	
 	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a1,zero,a3 #aqui
	#mul s6,s6,s7
	#add a1,a1,s6 #se come
	addi a3,a3,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	jal COLISAO
	li s3,0 
	li s4,0	
	li s5,0
	li s1,1
	#addi s5,s5,1
	j input
			
viraCimaEsq:

 	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	add a0,zero,a2 #aqui
	li a2,0
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
	jal COLISAO
	addi s6,s6,1
	li s3,0 
	li s4,0	
	li s5,0
	li s1,1
	j input
	
viraCima:
	beq s6,zero,viraCimaEsq

	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	add a0,zero,a2 #aqui
	li a2,0
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
	jal COLISAO
	addi s6,s6,1
	li s3,0 
	li s4,0	
	li s5,0
	li s1,1
	j input
	
direita:
	
	beq s4,zero,viraDireitaCima
	jal limpa
	
	li a7,147
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a0,zero,a2 #aqui
	#addi a0,a0,-10 #quando come
	addi a2,a2,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp) 	
	ecall
	jal COLISAO
	li s3,0
	li s5,0
	li s0,1
	li s6,0
	j input
	
viraDireitaCima:
	beq s1,zero,viraDireita
	
	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a1,zero,a3 #aqui
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
	jal COLISAO
	addi s4,s4,1
	li s5,0
	li s3,0
	li s0,1
	li s6,0
	j input
	
viraDireita:
	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a1,zero,a3 #aqui
	li a3,0
	add a3,a1,zero
	addi a2,a2,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	jal COLISAO
	addi s4,s4,1
	li s5,0
	li s3,0
	li s0,1
	li s6,0
	j input
esquerda:
	beq s5,zero,viraEsquerdaCima
	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a0,zero,a2 #aqui
	#addi a0,a0,10 #quando come
	addi a2,a2,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	jal COLISAO
	li s3,0
	li s4,0
	li s0,0
	li s6,0
	j input

viraEsquerdaCima:
	beq s1,zero,viraEsquerda
	
	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a1,zero,a3 #aqui
	li a3,0
	add a3,a1,zero
	addi a2,a2,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	jal COLISAO
	addi s5,s5,1
	li s3,0
	li s4,0
	li s0,0
	li s6,0
	j input
	
viraEsquerda:
	
	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a1,zero,a3 #aqui
	li a3,0
	add a3,a1,zero
	addi a2,a2,-10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	jal COLISAO
	addi s5,s5,1
	li s3,0
	li s4,0
	li s0,0
	li s6,0
	j input

desce:
	beq s3,zero,viraBaixo
	
	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	li a4,0x0038
	add a1,zero,a3 #aqui
	#addi a1,a1,-10 #quando come
	addi a3,a3,10
	sw a0,16(sp)
	sw a1,12(sp)
	sw a2,8(sp)
	sw a3,4(sp)
	sw a5,0(sp)
	li a7,147 	
	ecall
	jal COLISAO
	li s4,0	
	li s5,0
	li s6,0
	li s1,0
	j input
	
viraBaixoEsq:
	
 	jal limpa
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	add a0,zero,a2 #aqui
	li a2,0
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
	jal COLISAO
	addi s3,s3,1
	li s4,0	
	li s5,0
	li s6,0
	li s1,0
	j input
viraBaixo:
	jal limpa
   	beq a6,zero,viraBaixoEsq
	
	
	
	lw a5,0(sp)
	lw a3,4(sp)
	lw a2,8(sp)
	lw a1,12(sp)
	lw a0,16(sp)
	add a0,zero,a2 #aqui
	li a2,0
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
	jal COLISAO
	addi s3,s3,1
	li s4,0	
	li s5,0
	li s6,0
	li s1,0
	j input

COLISAO:
	lw a2,8(sp) #x cabeça
	lw a3,4(sp) #y cabeça
	beq a2,t3,Menu
	beq a2,t4,Menu
	beq a3,t5,Menu
	beq a3,t6,Menu
	ret

.include "../SYSTEMv17b.s"
