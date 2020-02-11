  
.data
.include "snakegame2a.s"
.include "snakegame2b.s"
msg1: .string "SNAKE "
roda_pe: .string "OAC VERAO"
msg_start: .string "Inicializando o jogo: "
msg_high: .string "HIGHSCORE:"
msg_speed: .string "Level Speed:"
buffer: .string "  "
NUM_NOTAS: .word 6 # Numero de Notas a tocar
NOTAS: 79 500 96 500 84 500 96 500 89 600  96 1000 # lista de nota dura??o nota dura??o nota dura??o ...



.text
la tp exceptionHandling
csrw tp utvec 
csrsi ustatus 1

li t0 2
j TelaInicial


TelaInicial:
li t1 0xFF000000# endereco inicial da Memoria- Frame 0
li t2 0xFF012C00# endereco final 
la s1 snakegame2a
addi s1 s1 8# primeiro pixels depois das informa??es de nlin ncol
LOOP1: 
beq t1 t2 Entrada# Se for o ?ltimo endere?o ent?o sai do loop
lw t3 0(s1)# le um conjunto de 4 pixels : word
sw t3 0(t1)# escreve a word na mem?ria VGA
addi t1 t1 4# soma 4 ao endere?o
addi s1 s1 4
j LOOP1# volta a verificar

#enter para iniciar o menu
Entrada: 
li a7 105
ecall

la s0 NUM_NOTAS# define o endere?o do n?mero de notas
lw s1 0(s0)# le o numero de notas
la s0 NOTAS# define o endere?o das notas
li t0 0# zera o contador de notas
li a2 90# define o instrumento
li a3 127# define o volume
MUSICA:  
beq t0 s1  Menu# contador chegou no final? ent?o  v? para FIM
lw a0 0(s0)# le o valor da nota
lw a1 4(s0)# le a duracao da nota
li a7 31# define a chamada de syscall
ecall# toca a nota
mv a0 a1# passa a dura??o da nota para a pausa
li a7 32# define a chamada de syscal 
ecall# realiza uma pausa de a0 ms
addi s0 s0 8# incrementa para o endere?o da pr?xima nota
addi t0 t0 1# incrementa o contador de notas
j MUSICA# volta ao loop

Menu:
li t0 2
li t3  32
beq t3  a7  SEMCOL
li a0 40# define a nota
li a1 1500# define a dura??o da nota em ms
li a2 127# define o instrumento
li a3 127# define o volume
li a7 33# define o syscall
ecall# toca a nota
SEMCOL: 
li t1 0xFF000000# endereco inicial da Memoria VGA - Frame 0
li t2 0xFF012C00# endereco final 
la s1 snakegame2b
addi s1 s1 8# cor preto
LOOP3: beq t1 t2 FIM
lw t3 0(s1)# Se for o ?ltimo endere?o ent?o sai do loop
sw t3 0(t1)# escreve a word na mem?ria VGA
addi t1 t1 4
addi s1 s1 4# soma 4 ao endere?o
j LOOP3# volta a verificar

FIM:
li a7 105
ecall
bge a0 t0 sai
j inicio
sai:
li t1 0xFF000000# endereco inicial da Memoria VGA - Frame 0
li t2 0xFF012C00# endereco final 
li t3 0x00000000# cor vermelho|vermelho|vermelhor|vermelho
LOOP: 
beq t1 t2 sai2# Se for o ?ltimo endere?o ent?o sai do loop
sw t3 0(t1)# escreve a word na mem?ria VGA
addi t1 t1 4# soma 4 ao endere?o
j LOOP# volta a verificar

sai2:   li a7 10
ecall
inicio:
#zerando o os registradores
li s11 0
li s10 0
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
li a0 0x00
li a7 148
li a1 0
ecall
ret

CLSV:
li a7 141
ecall
li a7 148
li a1 0
ecall
ret

#########################
# a1 =  X (0 ate 320)   #
# a2 =  Y (0 ate 240)   #
######################### 

# syscall "SNAKE"
str_snake: 
li a7 104
la a0 msg1
li a1 2
li a2 0
li a3 0x0038
li a4 0
ecall
ret

# sycall "msg_start"
str_start: 
li a7 104
la a0  msg_start
li a1 80
li a2 102
li a3 0x0038
li a4 0
ecall
ret

#sycall "HIGHSCORE"
str_high: 
li a7 104
la a0  msg_high
li a1 2
li a2 70
li a3 0x0038
li a4 0
ecall
ret

#sycall "LEVEL SPEED"
str_speed: 
li a7 104
la a0  msg_speed
li a1 2
li a2 106
li a3 0x0038
li a4 0
ecall
ret

#sycall "RODA PE"

str_roda:
li a7 104
la a0  roda_pe
li a1 2
li a2 230
li a3 0x0038
li a4 0
ecall
ret

# syscall sleep
SLEEP:
li t0  2
LOOPHMS:
li a0 1000   # 1 segundo
li a7 132
ecall
addi t0 t0 -1

str_score_int:

li a6 0
li a7 101
add a0 a6 s10
li a1 2
li a2 90
li a3 0x0038
li a4 0
ecall 
ret
#print seg
mv a0 t0
li a7 101
li a1 162
li a2 112
li a3 0x0038
li a4 0
ecall
bne t0 zero LOOPHMS
ret


str_speed_int:
li t0 0
add a0 s11 t0
li a7 101
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
salva_pilha:
sw a0 16(sp)
sw a1 12(sp)
sw a2 8(sp)
sw a3 4(sp)
sw a5 0(sp)
ret

carrega_pilha:
lw a5 0(sp)
lw a3 4(sp)
lw a2 8(sp)
lw a1 12(sp)
lw a0 16(sp)
ret

comecacobra: 
jal sorteia_comida
li t3 100
li t4 310
li t5 10
li t6 230
li a7 147
li a0 160
li a1 120
li a2 170
li a3 120
li a4 0x0038
li a5 0

addi sp sp -20 #pilha posiacao inicial da cobra
jal salva_pilha
ecall

li s3 0 #primeira vez que vira pra baixo
li s4 1 #primeira vez que vira pra direita
li s5 0 #primeira vez que vira pra esquerda
li s6 0 #primeira vez que vira pra cima

#li s5 0

li s1 1 #se ta pra cima
li s0 1 #se ta virado pra esquerdA

#input flag
input:

li t1 0xff200000 #Endere?o do MMIO
lw t0 0(t1)  #Le o bit de controle do teclado
andi t0 t0 0x0001 #Mascara o bit menos significativo

beq t0 zero estado_anterior # = estado anterior #nao tem tecla pressionada entao volta ao loop
lw t2 4(t1)#Le o valor da tecla
estado_anterior:
mv s2 t2
li s9 1000 #1 segundo
add a0 s9 s9
li a7 132
ecall


li t1 0x61 # a
beq s2 t1 esquerda

li t1 0x64 # d
beq s2 t1 direita

li t1 0x73 # s
beq s2 t1 desce

li t1 0x77 # w
beq s2 t1 cima

ret

li a7 10
ecall
limpa:
lw a5 0(sp)
lw a3 4(sp)
lw a2 8(sp)
lw a1 12(sp)
lw a0 16(sp)
li a4 0x0000
li a7 147
ecall
ret
cima:
beq s6 zero viraCima
jal limpa

 jal carrega_pilha
li a4 0x0038
add a1 zero a3 #aqui
#mul s6 s6 s7
#add a1 a1 s6 #se come
addi a3 a3 -10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
li s3 0 
li s4 0
li s5 0
li s1 1

lw a2 8(sp)
beq a2 s7 testay
j input

viraCimaEsq:

jal limpa

jal carrega_pilha
add a0 zero a2 #aqui
li a2 0
add a2 a0 zero
addi a3 a3 -10
li a4 0x0038
jal salva_pilha

li a7 147 
ecall
jal COLISAO
addi s6 s6 1
li s3 0 
li s4 0
li s5 0
li s1 1
lw a2 8(sp)
beq a2 s7 testay
j input

viraCima:
beq s6 zero viraCimaEsq

jal limpa

jal carrega_pilha
add a0 zero a2 #aqui
li a2 0
add a2 a0 zero
addi a3 a3 -10
li a4 0x0038
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s6 s6 1
li s3 0 
li s4 0
li s5 0
li s1 1
lw a2 8(sp)
beq a2 s7 testay
j input

direita:

beq s4 zero viraDireitaCima
jal limpa

li a7 147
jal carrega_pilha
li a4 0x0038
add a0 zero a2 #aqui
#addi a0 a0 -10 #quando come
addi a2 a2 10
jal salva_pilha 
ecall
jal COLISAO
li s3 0
li s5 0
li s0 1
li s6 0
lw a2 8(sp)
beq a2 s7 testay
j input

viraDireitaCima:
beq s1 zero viraDireita

jal limpa

jal carrega_pilha
li a4 0x0038
add a1 zero a3 #aqui
li a3 0
#addi a1 a1 -10
add a3 a1 zero
addi a2 a2 10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s4 s4 1
li s5 0
li s3 0
li s0 1
li s6 0
lw a2 8(sp)
beq a2 s7 testay
j input

viraDireita:
jal limpa

jal carrega_pilha
li a4 0x0038
add a1 zero a3 #aqui
li a3 0
add a3 a1 zero
addi a2 a2 10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s4 s4 1
li s5 0
li s3 0
li s0 1
li s6 0
lw a2 8(sp)
beq a2 s7 testay
j input
esquerda:
beq s5 zero viraEsquerdaCima
jal limpa

jal carrega_pilha
li a4 0x0038
add a0 zero a2 #aqui
#addi a0 a0 10 #quando come
addi a2 a2 -10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
li s3 0
li s4 0
li s0 0
li s6 0
lw a2 8(sp)
beq a2 s7 testay
j input

viraEsquerdaCima:
beq s1 zero viraEsquerda

jal limpa

jal carrega_pilha
li a4 0x0038
add a1 zero a3 #aqui
li a3 0
add a3 a1 zero
addi a2 a2 -10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s5 s5 1
li s3 0
li s4 0
li s0 0
li s6 0
lw a2 8(sp)
beq a2 s7 testay
j input

viraEsquerda:

jal limpa

jal carrega_pilha
li a4 0x0038
add a1 zero a3 #aqui
li a3 0
add a3 a1 zero
addi a2 a2 -10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s5 s5 1
li s3 0
li s4 0
li s0 0
li s6 0
lw a2 8(sp)
beq a2 s7 testay
j input

desce:
beq s3 zero viraBaixo

jal limpa

jal carrega_pilha
li a4 0x0038
add a1 zero a3 #aqui
#addi a1 a1 -10 #quando come
addi a3 a3 10
jal salva_pilha
li a7 147 
ecall
jal COLISAO
li s4 0
li s5 0
li s6 0
li s1 0
lw a2 8(sp)
beq a2 s7 testay
j input

viraBaixoEsq:

jal limpa

jal carrega_pilha
add a0 zero a2 #aqui
li a2 0
add a2 a0 zero 
addi a3 a3 10
li a4 0x0038
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s3 s3 1
li s4 0
li s5 0
li s6 0
li s1 0
lw a2 8(sp)
beq a2 s7 testay
j input

viraBaixo:
jal limpa
  beq a6 zero viraBaixoEsq

jal carrega_pilha
add a0 zero a2 #aqui
li a2 0
add a2 a0 zero
addi a3 a3 10
li a4 0x0038
jal salva_pilha
li a7 147 
ecall
jal COLISAO
addi s3 s3 1
li s4 0
li s5 0
li s6 0
li s1 0
lw a2 8(sp)
beq a2 s7 testay
j input

COLISAO:
lw a2 8(sp) #x cabe?a
lw a3 4(sp) #y cabe?a
beq a2 t3 Menu
beq a2 t4 Menu
beq a3 t5 Menu
beq a3 t6 Menu
ret

testay:
lw a3 4(sp)
beq a3 s8 apaga_comida
j input
apaga_comida: 
li a0,90		# define a nota
li a1,500		# define a duração da nota em ms
li a2,121		# define o instrumento
li a3,127		# define o volume
li a7,31
ecall  
li a7 147
add a0 s7 zero
add a1 s8 zero
addi a2 a0 1
addi a3 a1 1
li a4 0x0000
li a5 0
ecall  
addi s10 s10 100
addi s11 s11 1   
addi s9 s9 -100 
jal str_score_int
jal str_speed_int

jal sorteia_comida  
j input

sorteia_comida:
li t1 10
x:li a0  0
li a1  130
li a7 42
ecall
addi a0 a0 100
remu t0 a0 t1
bne t0 zero x
mv s7 a0 #valor de x
y:
li a0  0
li a1  140
li a7 42
ecall
addi a0 a0 20
remu t0 a0 t1
bne t0 zero y
mv s8 a0 #valor de y
li a7 147
mv a0 s7
mv a1 s8
addi a2 a0 1
addi a3 a1 1
li a4 0x00FF
li a5 0
ecall
ret

.include "SYSTEMv17b.s"

