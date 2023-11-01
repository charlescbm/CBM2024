#Include 'Protheus.ch'
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! M040SE1 - Complemento do titulo							!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne - Crele Cristina									!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 25/10/2021					                          	!
+-------------------+-----------------------------------------------------------+
*/

User Function M040SE1()

if IsInCallStack("MATA460A")	//Se chamada pela geracao da nota de saida
	
	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial('SA1') + SE1->E1_CLIENTE + SE1->E1_LOJA))

	if !empty(SA1->A1_ZPDCFIN)	//Se possui % de desconto financeiro preenchido
		
		//aplica o % de desconto financeiro do cliente
		nNewVlr := SE1->E1_VALOR * ((100 - SA1->A1_ZPDCFIN)/100)

		SE1->(recLock('SE1',.F.))
		SE1->E1_ZVLRORI := SE1->E1_VALOR
		SE1->E1_VALOR 	:= nNewVlr
		SE1->E1_SALDO 	:= nNewVlr
		SE1->E1_VLCRUZ 	:= nNewVlr
		SE1->E1_VALJUR	:= (SE1->E1_VALOR * SE1->E1_PORCJUR) / 100
		SE1->E1_BASCOM1 := SE1->E1_BASCOM1 * ((100 - SA1->A1_ZPDCFIN)/100)
		SE1->E1_BASCOM2 := SE1->E1_BASCOM2 * ((100 - SA1->A1_ZPDCFIN)/100)
		SE1->E1_BASCOM3 := SE1->E1_BASCOM3 * ((100 - SA1->A1_ZPDCFIN)/100)
		SE1->E1_BASCOM4 := SE1->E1_BASCOM4 * ((100 - SA1->A1_ZPDCFIN)/100)
		SE1->E1_BASCOM5 := SE1->E1_BASCOM5 * ((100 - SA1->A1_ZPDCFIN)/100)
		SE1->E1_VALCOM1 := SE1->E1_BASCOM1 * (SE1->E1_COMIS1/100)
		SE1->E1_VALCOM2 := SE1->E1_BASCOM2 * (SE1->E1_COMIS2/100)
		SE1->E1_VALCOM3 := SE1->E1_BASCOM3 * (SE1->E1_COMIS3/100)
		SE1->E1_VALCOM4 := SE1->E1_BASCOM4 * (SE1->E1_COMIS4/100)
		SE1->E1_VALCOM5 := SE1->E1_BASCOM5 * (SE1->E1_COMIS5/100)
		SE1->(msUnlock())

	endif

EndIF

Return

