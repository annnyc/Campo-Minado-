.data 

	msgLinha: .asciz "Digite o numero da linha: (de 0 a 7)\n"
	msgColuna: .asciz "Digite o numero da coluna: (de 0 a 7)\n"
	msgContinue: .asciz "\nVocê está indo bem, continue: \n"
	msgBemVindo: .asciz "Bem vindo ao game!\n"
	msgBomba: .asciz "\nBomba! Perdeu playboy"
	msgVenceu: .asciz "GG IZIII"
	msgMenu: .asciz "Escolha a sua jogada:\n0)Abrir uma posicao:\n1)Inserir uma bandeira: \n"
	msgQuebraLinha: .asciz	"\n"
	msgEspaco: .asciz " "
	msgAsterisco: .asciz "*"
	msgOpInvalida: "\nEsta opcao nao existe, tente novamente!\n"
	msgPosJaEscolhida: "Esta posição já está aberta! Tente outra!\n"
	
	campo:			.space		324   # esta versão suporta campo de até 9 x 9 posições de memória
	salva_S0:		.word		0
	salva_ra:		.word		0
	salva_ra1:		.word		0

	
	#campo:
	#	   .word   0, 0, 0, 0, 0, 0, 0, 0,                         
	#		   0, 0, 0, 0, 0, 0, 0, 0,
	#		   0, 0, 0, 0, 0, 0, 0, 0,
	#		   0, 0, 0, 0, 0, 0, 0, 0,
	#		   0, 0, 0, 0, 0, 0, 0, 0,
	#		   0, 0, 0, 0, 0, 0, 0, 0,
	#		   0, 0, 0, 0, 0, 0, 0, 0,
	#		   0, 0, 0, 0, 0, 0, 0, 0
			
	results:
		
		   
      		 .word    -1,-1,-1,-1,-1,-1,-1,-1,
      		       	  -1,-1,-1,-1,-1,-1,-1,-1,
       		     	  -1,-1,-1,-1,-1,-1,-1,-1,
       		     	  -1,-1,-1,-1,-1,-1,-1,-1,
       		     	  -1,-1,-1,-1,-1,-1,-1,-1,
       		    	  -1,-1,-1,-1,-1,-1,-1,-1,
       		     	  -1,-1,-1,-1,-1,-1,-1,-1,
      		   	  -1,-1,-1,-1,-1,-1,-1,-1
		
		                            			 		

.text

	
main:
		la 	a0, campo
		addi	a1, zero, 8
		jal 	INSERE_BOMBA
		nop

		li t1, 1
		
		#menu:
		la a0, msgBemVindo                       
		li a7, 4
		ecall		
menu:	
		la a0, msgMenu                       
		li a7, 4
		ecall		
		
		li a7, 5                             
		ecall
		add t0, a0, zero       
		
		beq t0, zero, inicio
		beq t0, t1, inicio
		
		la a0, msgOpInvalida                      
		li a7, 4
		ecall     
		
		j menu
		
inicio:
		j calcula_bombas
#conta_bombas:
#		la a0, campo
#		li a1, 64
#		li t3, 9
#		li t0, 0                            #cont
#		li t1, 0                            #quantidade de bombas
#for_cont:	
#		beq t0, a1, fim_cont
#		lw t2, (a0)
#		beq t2, t3, mais_uma
#		addi t0, t0, 1                      #incrementa o cont
#		addi a0, a0, 4                      #anda uma pos
#		j for_cont
		
#mais_uma:
#		addi t1, t1, 1                      #incrementa as bombas
#		addi t0, t0, 1                      #incrementa o cont
#		addi a0, a0, 4                      #anda uma pos
#		j for_cont
		
#fim_cont:
#		sub  s8, a1, a1                     #numero de jogadas possiveis	
#		add a0, s8, zero
#		li a7, 1
#		ecall
			
					
retorno:
		
		addi t2, zero, 8                      #valor p/ testes
		j linha


linha:	
		la a0, msgLinha                       #pede a linha
		li a7, 4
		ecall		
		
		li a7, 5                              #le a linha
		ecall
		add t0, a0, zero 
		
		blt t0, zero, linhaI                  #testa a linha
		bge t0, t2, linhaI
		add t3, t0, zero                      #linha correta em t3
coluna:	
		la a0, msgColuna                      #pede a coluna
		li a7, 4
		ecall
		
		li a7, 5                              #le a coluna
		ecall
		add t0, a0, zero 
		
		blt t0, zero, colunaI                  #testa a coluna
		bge t0, t2, colunaI
		add t4, t0, zero                       #coluna correta em t4
		j pos_valida
linhaI:
		
		la a0, msgOpInvalida                    
		li a7, 4
		ecall 
			
		j linha
colunaI:
		la a0, msgOpInvalida                    
		li a7, 4
		ecall 
		
		j coluna
		
pos_valida:				                 #testa se a posicao ja foi aberta

		addi t5, zero, 8                         #total de colunas
		addi t6, zero, 64                        #tamanho da matriz
		li s3, -1                                #testes
		
		#calculo p/ achar a posicao na matriz
		mul a2, t3, t5				#a2 = linha * quantidade de colunas
		add a2, a2, t4                          #posicao que precisamos achar 

		la s10, campo                          #endereco inical de campo
		la s11, results                        #endereco inicial de results
		
		li t0, 0                               #cont
for:
		beq t0, t6, valida                     #fim da matriz, posicao ainda nao foi aberta
		beq t0, a2, testa
		
		addi t0, t0, 1
		addi s11, s11, 4
	

testa:
		lw t1(s11)                           #le a pos
		beq t1,	s3, valida                   #se a pos == -1, nao foi aberta
		
		la a0, msgPosJaEscolhida                      
		li a7, 4
		ecall 
		
		j linha
														
valida:	
	
mostra_campo:
		la a0, campo
		la a1, results
		addi t6, zero, 64       #tamanho
		
		addi t0, zero, 0        #cont
for_campo:
		beq t0, t6, imprime
		beq t0, a2, posicaoD            #posicao que queremos achar
		addi t0, t0, 1
		addi a0, a0, 4
		j for_campo
			
posicaoD:
		lw t1, (a0)                     #le o valor da posicao encrontada
		addi t0, zero, 0
	
for_results:	                        #for pra achar a mesma posicao na matriz results
		beq t0, t6, imprime
		beq t0, a2, troca_v             
		addi t0, t0, 1
		addi a1, a1, 4
		j for_results
	
troca_v:
	sw t1,0(a1)	                #grava valor na matriz results (interface)
	add t5, t1, zero
	
	
imprime:
	addi t0, zero, 0          #cont i
	addi t1, zero, 0          #cont j
	addi t2, zero, 64         #tamanho
	addi t3, zero, 8          #quebra linha
	addi t4, zero, -1         #testes
	la s11, results
	
for_e:	
	beq t0, t2, ok
	beq t1, t3, quebra
	
	lw s2 (s11)               #le as posições da matriz
	beq s2, t4, asterisco     #se for -1 imprime o asterisco
	
	add a0, zero, s2
	li a7, 1
	ecall
	la a0 msgEspaco	
	li a7, 4
	ecall
	
	addi t1, t1, 1
	addi t0, t0, 1
	addi s11, s11, 4
	j for_e
	
asterisco:
	la a0, msgAsterisco
	li a7, 4
	ecall
	
	la a0 msgEspaco	
	li a7, 4
	ecall
	
	addi t1, t1, 1
	addi t0, t0, 1
	addi s11, s11, 4
	j for_e
	
	
quebra:
	la a0, msgQuebraLinha
	li a7, 4
	ecall
	
	addi t1, zero, 0

	j for_e
		
ok:
	addi a5, zero, 9
	beq t5, a5, BOMBAA
	j novamente
		
BOMBAA:		
	la a0, msgBomba                          #achou uma bomba, fim de game
	li a7, 4
	ecall	
	
	nop
	ebreak
	
			
				
					
novamente:
	la a0, msgContinue
	li a7, 4
	ecall
	
#	addi s8, zero, -1
	
#	beq s8, zero, vitoria
	j retorno
									
#vitoria:
#		la a0, msgVenceu                 #achou uma bomba, fim de game
#		li a7, 4
#		ecall	
	
#		nop
#		ebreak															

calcula_bombas:
		addi t1, zero, 8       	#primeira linha
		addi t2, zero, 16       #segunda linha
		addi s0, zero, 24       #terceira linha
		addi s1, zero, 32       #quarta linha
		addi s2, zero, 40       #quinta linha
		addi s3, zero, 48       #sexta linha
		addi s6, zero, 56       #setima linha
		
		addi s5, zero, 9       #bomba
		addi a4, zero, 0       #testes
		addi s10, zero, 64     #tamanho
		
		la a0, campo           #endereço inicial do campo
		mv a1, a0              #endereço em a0 e a1
		li t0, 0               #cont i
	
		addi t6, zero, 0     #cont para as bombas
		
for_i:
		beq t0, s10, break                 #se cont == tamanho: para
		blt t0, t1, primeira_linha         #se cont < 8 -> ta na primeira linha da matriz
		blt t0, t2, segunda_linha          #se cont < 16 -> ta na segunda  linha da matriz
		blt t0, s0, terceira_linha         #se cont < 24 -> ta na terceira  linha da matriz
		blt t0, s1, quarta_linha           #se cont < 32 -> ta na quarta linha da matriz
		blt t0, s2, quinta_linha           #se cont < 40 -> ta na quinta  linha da matriz
		blt t0, s3, sexta_linha            #se cont < 48 -> ta na sexta  linha da matriz
		blt t0, s6, setima_linha           #se cont < 56 -> ta na setima  linha da matriz
		j ultima_linha

primeira_linha:
		beq t0, zero, pos_00               #se cont == 0, primeira pos da matriz
		addi a4, zero, 7
		beq t0, a4, pos_07                 #se cont == 7, ultima pos da primeira linha
		j cima
	
pos_00:
	
		lw t4,(a1)
		beq t4, s5, bomba	
		lw t4, 4(a1)                          #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 32(a1)                         #le a posição de baixo
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 36(a1)                         #le a posicao da diagonal inferior direita 
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, (a1)                           #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
	
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for
	
pos_07:
		mv a1, a0
		lw t4, 0(a1)	
		beq t4, s5, bomba	
		lw t4, -4(a1)                         #le a posição da esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 28(a1)                         #le a posição da diagonal inferior esquerda
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 32(a1)                         #le a posicao de baixo
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
	
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for
	
cima:
		mv a1, a0
		lw t4, 0(a1)	
		beq t4, s5, bomba	
		lw t4, -4(a1)                         #le a posição da esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 4(a1)                          #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 28(a1)                         #diagonal inferior esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas	
		lw t4, 32(a1)                         #le a posição de baixo
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 36(a1)                         #diagonal inferior direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for	

segunda_linha:
		beq t0, t1, col_esq                   #se cont == 8 -> coluna esquerda
		addi a4, zero, 15                     
		beq t0, a4, col_dir                   #se cont == 15 -> coluna direita
		j geral		
		
	
	
col_esq:
		mv a1, a0
		lw t4, 0(a1)
		beq t4, s5, bomba	
		lw t4, -32(a1)                        #le a posição de cima
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -28(a1)                        #le a posição da diagonal superior direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 4(a1)                          #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 32(a1)                         #le a pos de baixo
		addi t4, t4, 1                     	
		slt t5, s5, t4                        #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 36(a1)                         #le a diagonal inferior direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
		
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for	
				
	
col_dir:
		mv a1, a0
		lw t4, 0(a1)
		beq t4, s5, bomba
		lw t4, -36(a1)                        #le a diagonal superior esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -32(a1)                        #le a posição de cima
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -4(a1)                         #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 28(a1)                         #le a diagonal inferior esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 32(a1)                         #le a posição de baixo
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
		
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i  

geral:
		mv a1, a0
		lw t4, 0(a1)
		beq t4, s5, bomba
		lw t4, -4(a1)                          #le a posição da esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -28(a1)                        #le a posição da diagonal superior direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -32(a1)                        #le a posição de cima
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -36(a1)                        #le diagonal superior esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 4(a1)                          #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 28(a1)                         #le a diagonal inferior esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 32(a1)                         #le a posição de baixo
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, 36(a1)                         #le a diagonal inferior direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
		
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i 

terceira_linha:
		beq t0, t2, col_esq
		addi a4, zero, 23                     
		beq t0, a4, col_dir                   
		j geral	
	
quarta_linha:
		beq t0, s0, col_esq
		addi a4, zero, 31                     
		beq t0, a4, col_dir                   
		j geral	
		
quinta_linha:	
		beq t0, s1, col_esq
		addi a4, zero, 39                     
		beq t0, a4, col_dir                   
		j geral	

sexta_linha:
		beq t0, s2, col_esq
		addi a4, zero, 47                     
		beq t0, a4, col_dir                   
		j geral	

setima_linha:
		beq t0, s3, col_esq
		addi a4, zero, 55                     
		beq t0, a4, col_dir                   
		j geral	
	
ultima_linha:
		
		addi a4, zero, 56
		beq t0, a4, pos_56
		addi a4, zero, 63
		beq t0, a4, pos_63
		j baixo
	
	
pos_56:	
		mv a1, a0
		lw t4, 0(a1)
		beq t4, s5, bomba	
		lw t4, 4(a1)                          #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bomba
		lw t4, -28(a1)                        #le a diagonal superior direita
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -32(a1)                        #le a pos de cima
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
	
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for

pos_63:
		mv a1, a0
		lw t4, 0(a1)
		beq t4, s5, bomba	
		lw t4, -4(a1)                          #le a posição da esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -32(a1)                        #le a posição de cima
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -36(a1)                        #le a posicao da diagonal superior esquerda
		addi t4, t4, 1
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
	
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for
	
	
baixo:
		mv a1, a0
		lw t4, 0(a1)	
		beq t4, s5, bomba	
		lw t4, 4(a1)                          #le a posição da direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -4(a1)                         #le a posição da esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -28(a1)                        #le a diagonal superior direita
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas	
		lw t4, -32(a1)                        #le a pos de cima
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		lw t4, -36(a1)                        #le a diagonal superior esquerda
		addi t4, t4, 1                     	
		slt   t5, s5, t4                      #se for bomba: t5 = 1 se nao: t5 = 0
		add t6, t6, t5                        #incrementa o cont das bombas
		sw t6, 0(a1)                          #add a quantidade de bombas que tem ao redor.
		add t6, zero, zero                    #zera o cont de bombas
		
		addi t0, t0, 1                        #incrementa o cont (i)
		addi a0, a0, 4
		j for_i                               #volta p/ o for	
		
	
bomba:
	addi t0, t0, 1
	addi a0, a0, 4
	j for_i	
	
#imprimindo só pra ver se ta funcionando	
break:
	j retorno
	#la a0, campo   	                                #endereco inicial do vetor
	#addi t1,zero, 64                                #tamanho
	#addi t0, zero, 0                                #cont
	
#imprime:
#       mv a3, a0                                       #a3 = endereco inicial do vetor
#for:                                            
#	beq t1, t0, quebra_linha               
#	lw a0, 0(a3)                                    #le valor no vetor
#	li a7, 1                                        #imprime o valor
#	ecall                        
#	addi t0, t0, 1                                  #incrementa o cont
#	addi a3, a3, 4                                  #anda uma pos no vetor
#	j for
	
#quebra_linha:
#	la a0, msg1                                    
#	li a7, 4
#	ecall
	
INSERE_BOMBA:
		la	t0, salva_S0
		sw  	s0, 0 (t0)		# salva conteudo de s0 na memoria
		la	t0, salva_ra
		sw  	ra, 0 (t0)		# salva conteudo de ra na memoria
		
		add 	t0, zero, a0		# salva a0 em t0 - endereço da matriz campo
		add 	t1, zero, a1		# salva a1 em t1 - quantidade de linhas 

QTD_BOMBAS:
		addi 	t2, zero, 15 		# seta para 15 bombas	
		add 	t3, zero, zero 	# inicia contador de bombas com 0
		addi 	a7, zero, 30 		# ecall 30 pega o tempo do sistema em milisegundos (usado como semente
		ecall 				
		add 	a1, zero, a0		# coloca a semente em a1
INICIO_LACO:
		beq 	t2, t3, FIM_LACO
		add 	a0, zero, t1 		# carrega limite para %	(resto da divisão)
		jal 	PSEUDO_RAND
		add 	t4, zero, a0		# pega linha sorteada e coloca em t4
		add 	a0, zero, t1 		# carrega limite para % (resto da divisão)
   		jal 	PSEUDO_RAND
		add 	t5, zero, a0		# pega coluna sorteada e coloca em t5

###############################################################################
# imprime valores na tela (para debug somente) - retirar comentarios para ver
#	
#		li	a7, 4		# mostra texto "Posicao: "
#		la	a0, posicao
#		ecall
#		li	a7, 1
#		add 	a0, zero, t4 	# imprime a linha sorteada	
#		ecall
#
#		add 	a0, zero, t5 	# imprime coluna sorteada
#		ecall
#		
#		li	a7, 4		# imrpime espaço
#		la	a0, espaco
#		ecall
#		li	a7, 1		
#		add 	a0, zero, t3 	# imprime quantidade ja sorteada
#		ecall
#		
##########################################################################	

LE_POSICAO:	
		mul  	t4, t4, t1
		add  	t4, t4, t5  		# calcula (L * tam) + C
		add  	t4, t4, t4  		# multiplica por 2
		add  	t4, t4, t4  		# multiplica por 4
		add  	t4, t4, t0  		# calcula Base + deslocamento
		lw   	t5, 0(t4)   		# Le posicao de memoria LxC
VERIFICA_BOMBA:		
		addi 	t6, zero, 9		# se posição sorteada já possui bomba
		beq  	t5, t6, PULA_ATRIB	# pula atribuição 
		sw   	t6, 0(t4)		# senão coloca 9 (bomba) na posição
		addi 	t3, t3, 1		# incrementa quantidade de bombas sorteadas
PULA_ATRIB:
		j	INICIO_LACO

FIM_LACO:					# recupera registradores salvos
		la	t0, salva_S0
		lw  	s0, 0(t0)		# recupera conteudo de s0 da memória
		la	t0, salva_ra
		lw  	ra, 0(t0)		# recupera conteudo de ra da memória		
		jr 	ra			# retorna para funcao que fez a chamada
		
##################################################################
# PSEUDO_RAND
# função que gera um número pseudo-randomico que será
# usado para obter a posição da linha e coluna na matriz
# entrada: a0 valor máximo do resultado menos 1 
#             (exemplo: a0 = 8 resultado entre 0 e 7)
#          a1 para o número pseudo randomico 
# saida: a0 valor pseudo randomico gerado
#################################################################
#int rand1(int lim, int semente) {
#  static long a = semente; 
#  a = (a * 125) % 2796203; 
#  return (|a % lim|); 
# }  

PSEUDO_RAND:
		addi t6, zero, 125  		# carrega constante t6 = 125
		lui  t5, 682			# carrega constante t5 = 2796203
		addi t5, t5, 1697 		# 
		addi t5, t5, 1034 		# 	
		mul  a1, a1, t6			# a = a * 125
		rem  a1, a1, t5			# a = a % 2796203
		rem  a0, a1, a0			# a % lim
		bge  a0, zero, EH_POSITIVO  	# testa se valor eh positivo
		addi s2, zero, -1           	# caso não 
		mul  a0, a0, s2		    	# transforma em positivo
EH_POSITIVO:	
		ret				# retorna em a0 o valor obtido
############################################################################
