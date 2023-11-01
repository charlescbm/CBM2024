#include 'protheus.ch'
#INCLUDE "Dbstruct.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	                 		!
+-------------------------------------------------------------------------------+
!Programa			! UFINA010 - Tras o valor corrigido do titulo - INOVEN	! 
+-------------------+-----------------------------------------------------------+
!Autor         	    ! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 13/07/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UFINA010()

Local nVlrCor   := 0  //valor corrigido do titulo
Local nAbatim   := 0  //valor abatimento
Local nDescFin  := 0  //valor desconto financeiro
Local nSaldo    := 0  //saldo
Local nValAces  := 0  //valor despesas acessorias
Local aSE1      := SE1->(GetArea())

Private nJuros  := 0    //valor juros

If empty(SE1->E1_SALDO)
   nSaldo := SE1->E1_VALOR
Else
   nSaldo := SaldoTit( SE1->E1_PREFIXO ,SE1->E1_NUM  ,SE1->E1_PARCELA ,SE1->E1_TIPO , ;
                       SE1->E1_NATUREZ ,"R"           ,SE1->E1_CLIENTE , 1           , ;
                       NIL             ,NIL           ,SE1->E1_LOJA    ,NIL          , ;
                       If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0) )
Endif

//Desconto Financeiro e Abatimento
IF !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)

    //Abatimento
    nAbatim	 := SomaAbat(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA,"R",SE1->E1_MOEDA,,SE1->E1_CLIENTE,SE1->E1_LOJA)
    //Desconto Financeiro
    If SE1->E1_VENCREA >= dDataBase .AND. SE1->E1_SALDO > 0
        nDescFin   := FaDescFin("SE1",dDataBase,SE1->E1_SALDO-nAbatim,SE1->E1_MOEDA)
    Endif
    // Se o Saldo ja estiver Zero, nao calcular os juros.
    If SE1->E1_SALDO > 0
        fa070Juros(1, nSaldo)
        
        If	ExistFunc('FValAcess')
            nValAces := FValAcess(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA, SE1->E1_NATUREZ,!Empty(SE1->E1_BAIXA),,"R",SE1->E1_BAIXA,,SE1->E1_MOEDA)		
        EndIf
    Endif
Endif

//Monta valor
nVlrCor := SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE + nJuros + nValAces - nAbatim - nDescFin

SE1->(RestArea(aSE1))

Return( nVlrCor )
