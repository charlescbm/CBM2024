#INCLUDE 'PROTHEUS.CH' 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVFIM   ºAutor  ³Cristiane T Polli   º Data ³  02/05/07   º±±                                 	
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±            '
±±ºDesc.     ³ P.E. para gravar campos alguns campos no SC5 e no SC6.     º±±
±±º          ³ obs.: somente se o pedido for de operação faturamento      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Modificacao para gravar valores numericos no campo de amos º±±
±±º          ³ tra.                                                       º±±       
±±º          ³ 18.04.07 - Elias Reis - Pequena query para atualizar um campo±
±±º          ³            utilizado para a liberacao de crédito C6_X_LBFINº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Customizações Brascola                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//formato chamado pela cris do calcenter
//User Function TMKVFIM(cNum)
// este é o formato chamado pelo Pe do marcelo
User Function TMKVFIM(_cNumAtd,_cNumPed)

Local LSC6      := .F.  
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6  := SC6->(GetArea())
Local aDados	:= {}
Local lBloqDesc	:= .F.
Local nX		:= 0
Local cBlq		:= ""
Private aBloq   := {}
	
If SUA->UA_OPER == '1'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorna os bloqueios de cada item do pedido                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aDados := U_BRAAAC08(SC5->C5_NUM, SC5->C5_CLIENTE,SC5->C5_LOJACLI, SC5->C5_TIPO, .f.)
		
	For nX := 1 To Len(aDados)
		If aDados[nX,1]
			lBloqDesc := .T.
			Exit
		EndIf
	Next nX
	
	if lBloqDesc    
	   cBlq := "1"
	EndIf
	   
	if M->UA_AMOSTRA == NIL  
		cAmostra := SUA->UA_AMOSTRA  
	Else	
		cAmostra := M->UA_AMOSTRA
	EndIf
	cNumSC5  := SUA->UA_NUMSC5
	cNumSUA  := SUA->UA_NUM
	cCodCli  := SUA->UA_CLIENTE

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xfilial('SA1')+cCodCli))
		cDescCli := SA1->A1_NOME

		SC5->(dbSetOrder(1))
		SC5->(dbSeek(xfilial('SC5')+cNumSC5))
		RecLock('SC5',.F.)
			SC5->C5_AMOSTRA := cAmostra
			SC5->C5_NOMECLI := cDescCli
			SC5->C5_CLIENT  := cCodCli
			SC5->C5_ESPECI1 := 'VOL'
	   	    SC5->C5_TIPLIB  := "1" //LIBERA POR PEDIDO
			SC5->C5_ENTREGA := SUA->UA_X_DTENT 
			
			// Cleiton
			If Inclui .Or. SC5->(Empty(C5_UsrImpl))
				SC5->C5_USRIMPL := cUserName 
			EndIf
			
			SC5->C5_BLQ     := cBlq
		SC5->(MsUnLock())
		
	If lBloqDesc
		For nX := 1 to Len(aCols)
		
			If aCols[nX,Len(aHeader)+1] == .T. 
				Loop
			Endif
			If Empty(SC6->C6_BLOQUEI)
				cBloq := "01"
				aAdd(aBloq,cBloq)
			EndIf
			
		Next nX
	
	Else
		For nX := 1 to Len(aCols)
			If aCols[nX,Len(aHeader)+1]
				Loop
			Endif            
			If Empty(SC6->C6_BLOQUEI)
				cBloq := "  "
				aAdd(aBloq,cBloq)
			EndIf
		Next nX
	EndIf

If len(aBloq) > 0
	For nX:=1 To len(aCols)
		// Cleiton - 26/11/2008 
		// Incluido para correcao de erro quando existirem itens deletado no faturamento
			If aCols[nX,Len(aHeader)+1]
				Loop
			Endif                   
		// Cleiton - 26/11/2008 		
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		SC6->(dbSeek(XFILIAL("SC6")+SC5->C5_NUM+aCols[nX,1])) 

		RecLock('SC6',.F.)
		SC6->C6_BLOQUEI := aBloq[nX]
		SC6->(MsUnLock())		
	Next	
EndIF	
		
	If lBloqDesc                
		Aviso(	"Pedido de Venda",;
					"Existem itens nesse pedido com bloqueio de desconto.",;
					{"Ok"},,;
					"Pedido: "+SC5->C5_NUM )
	Endif                                          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente enviar e-mail se o pedido for de operação "faturamento"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_BRAAMAIL()	
	
EndIf     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ponto de entrada tb criado pelo marcelo  que inseri aki        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SUA")
DbSetOrder(1)
If DbSeek(xFilial("SUA")+_cNumAtd)
	DbSelectArea("SC5")
	DbSetOrder(1)
	If DbSeek(xFilial("SC5")+_cNumPed)
		Reclock("SC5",.F.)
		SC5->C5_MENNOTA := SUA->UA_X_MENNF // Grava a mensagem da nota do SUA no SC5
		//SC5->C5_HISTORI := SUA->UA_X_OBS		// Grava Obs Brascola
		SC5->C5_HISTORI := MSMM(SUA->UA_CODOBS,43)		// Grava Obs Brascola
		SC5->(MsUnlock())           
	EndIf
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³funcao que agreguei ao fonte do marcelo, para gravar   			³	
//³um campo customizado, que interfere na liberacao do credito    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
cQuery := " UPDATE "+RETSQLNAME("SC6")+" SET C6_X_LBFIN = '"+DToS(dDatabase)+"' "  
cQuery += " WHERE "
cQuery += "     C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM    = '"+_cNumPed+"'"
cQuery += " AND D_E_L_E_T_= '' "        
TcSqlExec(cQuery)                           

RestArea(aAreaSA1)	
RestArea(aAreaSC5)
Restarea(aAreaSC6)    
		
Return (lSC6)