.data 

	msgLinha: .asciz "Digite o numero da linha: \n"
	msgColuna: .asciz "Digite o numero da coluna: \n"
	msgMenu: .asciz "Escolha a sua jogada:\n0)Abrir uma posicao:\n1)Inserir uma bandeira: "
	msgQuebraLinha: .asciz	"\n"
	msgOpIvalida: "\nEsta opcao nao existe, tente novamente!\n"
	
	campo:
		   .word   0, 9, 0, 9, 0, 0, 0, 0,                         
			   0, 0, 0, 0, 0, 0, 0, 0,
			   0, 0, 9, 0, 9, 0, 0, 0,
			   0, 0, 0, 0, 0, 9, 0, 9,
			   0, 0, 0, 0, 0, 0, 0, 0,
			   9, 0, 0, 9, 0, 0, 0, 0,
			   9, 0, 0, 0, 0, 0, 0, 0,
			   0, 0, 0, 0, 0, 0, 0, 9
			
	results:
		
		   
      		    .word   -1,-1,-1,-1,-1,-1,-1,-1
      		    .word   -1,-1,-1,-1,-1,-1,-1,-1
       		    .word   -1,-1,-1,-1,-1,-1,-1,-1
       		    .word   -1,-1,-1,-1,-1,-1,-1,-1
       		    .word   -1,-1,-1,-1,-1,-1,-1,-1
       		    .word   -1,-1,-1,-1,-1,-1,-1,-1
       		    .word   -1,-1,-1,-1,-1,-1,-1,-1
      		    .word   -1,-1,-1,-1,-1,-1,-1,-1
		
		                            			 		
	         msg1:
	      	       .asciz "\n"       		    

			



.text

	

#mostra_campo:

#	j retorno

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
	la a0, campo   	                                #endereco inicial do vetor
	addi t1,zero, 64                                #tamanho
	addi t0, zero, 0                                #cont
	
imprime:
        mv a3, a0                                       #a3 = endereco inicial do vetor
for:                                            
	beq t1, t0, quebra_linha               
	lw a0, 0(a3)                                    #le valor no vetor
	li a7, 1                                        #imprime o valor
	ecall                        
	addi t0, t0, 1                                  #incrementa o cont
	addi a3, a3, 4                                  #anda uma pos no vetor
	j for
	
quebra_linha:
	la a0, msg1                                    
	li a7, 4
	ecall
	
	
