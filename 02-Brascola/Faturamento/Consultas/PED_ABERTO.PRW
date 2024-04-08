#INCLUDE "TbiConn.ch"
#INCLUDE "RWMAKE.CH"     
/******************************************************************************************************************
** FONTE:     PED_ABERTO.PRW																				     **
** FUNCAO:    MAPA01()																							 **
** DESCRICAO: SOLICITADO POR RONALDO LIMA, ESTE PROGRAMA GERA UM ARQUIVO EXCEL COM A CARTEIRA DE PEDIDOS EM      **
**            ABERTO , CONFORME PARAMETROS PREENCHIDOS POR USUARIO 											     **
******************************************************************************************************************/
USER FUNCTION MAPA01()  

Local  cPerg 	:= U_CRIAPERG("MAPA01")
Local  aRegs 	:= {}

AADD(aRegs,{ALLTRIM(cPerg),"01","Dt Inicial         ?"," "," ","mv_ch1","D",8,0,0,"G","","mv_par01"})
AADD(aRegs,{ALLTRIM(cPerg),"02","Dt Final           ?"," "," ","mv_ch2","D",8,0,0,"G","","mv_par02"})
AADD(aRegs,{ALLTRIM(cPerg),"03","Retirar o Estado   ?"," "," ","mv_ch3","C",2,0,0,"G","","mv_par03"})

lValidPerg(aRegs)

If !PERGUNTE(cPerg,.T.)
	Return
EndIf

Processa({ || CRIAMAPA(.F.)}, "Aguarde",,.t.)

RETURN(.T.)

/******************************************************************************************************************
** FONTE:                    																											     **
** FUNCAO:             																													     **
******************************************************************************************************************/

STATIC FUNCTION CRIAMAPA(lSchedule)      

Local _MP01 	:= {}    
Local nConvert := 1   
Local cAlias 	:= "MP01"
Local cDirDocs := MsDocPath()

Aadd(_MP01,{"PEDCLI"         ,"C",009,0})
Aadd(_MP01,{"PEDIDO"         ,"C",006,0})
Aadd(_MP01,{"PRODUTO"        ,"C",015,0})
Aadd(_MP01,{"DESCRI"         ,"C",050,0})
Aadd(_MP01,{"FABRIC"         ,"C",001,0})
Aadd(_MP01,{"GRUPOPRO"       ,"C",030,0})
Aadd(_MP01,{"CLIENTE"        ,"C",006,0})
Aadd(_MP01,{"NOMCLI"         ,"C",040,0})
Aadd(_MP01,{"VENDA"          ,"N",016,2})
Aadd(_MP01,{"ENTREGA"        ,"N",016,2})
Aadd(_MP01,{"SALDO"          ,"N",016,2})
Aadd(_MP01,{"SITCRED"        ,"C",001,0})
Aadd(_MP01,{"VLRITEM"        ,"N",016,2})
Aadd(_MP01,{"VLRATEN"        ,"N",016,2})
Aadd(_MP01,{"VLRABTO"        ,"N",016,2})
Aadd(_MP01,{"EMISSAO"        ,"D",008,0})
Aadd(_MP01,{"DT_ENT"         ,"D",008,0})
Aadd(_MP01,{"VENDOR"         ,"C",006,0})
Aadd(_MP01,{"NOMVND"         ,"C",040,0})
Aadd(_MP01,{"FILIAL"         ,"C",003,0})
Aadd(_MP01,{"GRPCLI"         ,"C",040,0})
Aadd(_MP01,{"SITPED"         ,"C",001,0})
Aadd(_MP01,{"GERAFAT"        ,"C",001,0})
Aadd(_MP01,{"DESCONT"        ,"C",001,0})
Aadd(_MP01,{"TES"            ,"C",003,0})

_cArqCbc := CriaTrab(_MP01,.T.)
dbUseArea( .T.,,_cArqCbc, "MP01", .F., .F. )

PROCREGUA(SC5->(LASTREC()))

DBSELECTAREA("SC5")
dbSetOrder(2)
//dbSeek(xFilial()+DToS(mv_par01),.T.)
//dbSeek(xFilial()+DToS(IF(!LSCHEDULE,MV_PAR01,CTOD("01/01/09"))),.T.)
DBGOTOP()

WHILE !EOF()

	IF SC5->C5_TIPO <> "N" .OR. !( SC5->C5_EMISSAO >= IF(!LSCHEDULE,MV_PAR01,CTOD("01/01/09")); 
		.AND. SC5->C5_EMISSAO <= IF(!LSCHEDULE,MV_PAR02,CTOD("01/01/10"))) 
		
		SC5->(DBSKIP())
		LOOP
	ENDIF

	If  ( SM0->M0_CODFIL == '04' ) .And. ( Posicione( 'SA1', 1 , xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI, 'A1_EST' ) == AllTrim( MV_PAR03 ) .And. !Posicione( 'SA1', 1, xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI, 'A1_GRPVEN' ) $ '000015*000020*000021*000022*000024*000025*000026*000027*000028*000052*000053*000023*000014*000056*000012' )
		SC5->( DbSkip() )
		Loop
	EndIf	
	
	INCPROC("Processando Pedidos Nr.: " + SC5->C5_NUM)
	
	DBSELECTAREA("SC6")
	DBSETORDER(1)
	IF DBSEEK( SC5->C5_FILIAL + SC5->C5_NUM)

		WHILE !EOF() .AND. SC6->C6_FILIAL == SC5->C5_FILIAL .AND. SC6->C6_NUM == SC5->C5_NUM

			IF SC6->C6_QTDVEN > SC6->C6_QTDENT .AND. ALLTRIM(SC6->C6_BLQ) <> "R" //.AND. DtoS(SC6->C6_ENTREG) >= '20090701' .AND. DtoS(SC6->C6_ENTREG) <= '20090801' 
			
                                   
				DBSELECTAREA("MP01")
				RECLOCK("MP01",.T.)

				MP01->FILIAL  := SC6->C6_FILIAL
				MP01->PEDCLI  := SC6->C6_PEDCLI
				MP01->PEDIDO  := SC6->C6_NUM
				MP01->PRODUTO := ALLTRIM(SC6->C6_PRODUTO)
				MP01->TES     := SC6->C6_TES
				
				DBSELECTAREA("SB1")
				DBSETORDER(1)
				IF DBSEEK( XFILIAL("SB1") + SC6->C6_PRODUTO)
					MP01->DESCRI  := ALLTRIM(SB1->B1_DESC)
					MP01->FABRIC  := SB1->B1_FABRI
					IF SB1->B1_MSBLQL == "1"
						MP01->DESCONT  := "S"
					ELSE
						MP01->DESCONT  := "N"
					ENDIF
					
					DBSELECTAREA("SBM")
					DBSETORDER(1)
					IF DBSEEK( XFILIAL("SBM") + SB1->B1_GRUPO)
						MP01->GRUPOPRO := SBM->BM_DESC
					ELSE
						MP01->GRUPOPRO := SPACE(30)
					ENDIF
				ENDIF
				MP01->CLIENTE := SC6->C6_CLI
				MP01->NOMCLI  := SC5->C5_NOMECLI
				MP01->VENDA   := SC6->C6_QTDVEN
				MP01->ENTREGA := SC6->C6_QTDENT
				MP01->SALDO   := (SC6->C6_QTDVEN - SC6->C6_QTDENT)


				IF SC6->C6_QTDENT == 0
					MP01->SITPED := "A"
				ELSE
					MP01->SITPED := "P"
				ENDIF
				
				IF SC5->C5_MOEDA == 1
					nConvert := 1
				ELSEIF SC5->C5_MOEDA == 2
					DBSELECTAREA("SM2")
					DBSETORDER(1)  
					DBGOTOP()
					DBSEEK( DDATABASE )
						nConvert := SM2->M2_MOEDA2
					
				ELSEIF SC5->C5_MOEDA == 3
					DBSELECTAREA("SM2")
					DBSETORDER(1)
					DBGOTOP()
					DBSEEK( DDATABASE )
						nConvert := SM2->M2_MOEDA3
					
				ELSEIF SC5->C5_MOEDA == 4
					DBSELECTAREA("SM2")
					DBSETORDER(1)
					DBGOTOP()
					DBSEEK( DDATABASE )
						nConvert := SM2->M2_MOEDA4
					
				ELSEIF SC5->C5_MOEDA == 5
					DBSELECTAREA("SM2")
					DBSETORDER(1)
					DBGOTOP()
					DBSEEK( DDATABASE )
						nConvert := SM2->M2_MOEDA5
					
				ENDIF
				
				//ALTERACOS PEDIDAS PELO HERNANE
				/*
				P - pENDENTE DE QQER LIBERAÇÃO
				L - LIBERADO INCLUSIVE COM A RELIBERACAO AINDA NAO VENCIDA
				B - LIBERACAO VENCIDA
				R - REJEICAO DO CREDITO

			    ADICIONAR
				C - BLOQUEIO POR REGRA COMERCIAL 	*/				

				DBSELECTAREA("SC9")
				DBSETORDER(1)
				IF DBSEEK( SC5->C5_FILIAL + SC6->C6_NUM + SC6->C6_ITEM)
					WHILE !EOF() .AND. SC9->C9_PEDIDO == SC6->C6_NUM .AND. SC9->C9_ITEM == SC6->C6_ITEM
						IF ALLTRIM(SC9->C9_BLCRED) <> "10"
							IF ALLTRIM(SC9->C9_BLCRED) == "09"
								MP01->SITCRED := "R"
							ELSEIF LEN(ALLTRIM(SC9->C9_BLCRED)) == 0
								MP01->SITCRED := "L"
							ELSE
								MP01->SITCRED := "B"
							ENDIF
						ENDIF

						DBSKIP()
					ENDDO

					IF LEN(ALLTRIM(MP01->SITCRED)) == 0
						MP01->SITCRED := "P"
					ENDIF

				ELSE
					If !AllTrim(SC5->C5_BLQ)$"1"		// Pendente de qqer liberacao
						MP01->SITCRED := "P"	
					Else
						MP01->SITCRED := "C"		// Bloqueado por Regra Comercial
					EndIf
				ENDIF
				
				//Identifica, apesar de todas as variantes, se está bloqueado na tela de reliberação
				If SC6->C6_X_LBFIN <= (dDatabase - GetMv("BR_FBLQDIA")	) 
					MP01->SITCRED := "B"
				EndIf
			
				      
//				IF nConvert == 0
				 nConvert := 1
//				ENDIF
				 
				MP01->VLRITEM := SC6->C6_VALOR * nConvert
				MP01->VLRATEN := ROUND((SC6->C6_QTDENT * SC6->C6_PRCVEN)* nConvert,2)
				MP01->VLRABTO := ROUND((((SC6->C6_QTDVEN - SC6->C6_QTDENT) * SC6->C6_PRCVEN)* nConvert),2)
				MP01->EMISSAO := SC5->(C5_EMISSAO)
				MP01->DT_ENT  := SC6->(C6_ENTREG)
				MP01->VENDOR  := SC5->C5_VEND1
				
				DBSELECTAREA("SA3")
				DBSETORDER(1)
				IF DBSEEK( XFILIAL("SA3") + SC5->C5_VEND1)
					MP01->NOMVND := ALLTRIM(SA3->A3_NOME)
				ENDIF
				
				IF SC6->C6_FILIAL == "01"
					MP01->FILIAL := "MTR"
				ELSEIF SC6->C6_FILIAL == "02"
					MP01->FILIAL := "FNH"
				ELSEIF SC6->C6_FILIAL == "03"
					MP01->FILIAL := "FFR"
				ELSEIF SC6->C6_FILIAL == "04"
					MP01->FILIAL := "JOI"
				ENDIF
				
				DBSELECTAREA("SA1")
				DBSETORDER(1)
				IF DBSEEK(XFILIAL("SA1") + SC6->C6_CLI + SC6->C6_LOJA)
					
					DBSELECTAREA("ACY")
					DBSETORDER(1)
					IF DBSEEK(XFILIAL("ACY") + SA1->A1_GRPVEN)
						MP01->GRPCLI := ACY->ACY_DESCRI
					ENDIF
				ELSE
					MP01->GRPCLI := SPACE(40)
				ENDIF
				
				DBSELECTAREA("SF4")
				DBSETORDER(1)
				IF DBSEEK( XFILIAL("SF4") + SC6->C6_TES)
					IF SF4->F4_DUPLIC == "S"
						MP01->GERAFAT := "S"
					ELSE
						MP01->GERAFAT := "N"
					ENDIF
				ENDIF

				DBSELECTAREA("MP01")
				MSUNLOCK()
				
				DBSELECTAREA("SC6")
				DBSKIP()
			ELSE
				DBSELECTAREA("SC6")
				DBSKIP()
			ENDIF
		ENDDO
		
	ENDIF
	
	DBSELECTAREA("SC5")
	DBSKIP()
ENDDO                      

If !lSchedule
	U_PROCEXCEL(cAlias)
	// U_GeraCSV(cAlias)
Else   
	dbSelectArea("MP01")  
	Copy To &(cDirDocs+"\"+_cArqCbc+".XLS") VIA "DBFCDXADS"
	__CopyFile(cDirDocs+"\"+_cArqCbc+".XLS", "\spool\pedidosemaberto.xls") 
	cEmail    := 	"angela.fioravanti@brascola.com.br;whay@brascola.com.br"
	cAssunto  := 	"Pedidos em Aberto - " + Time()
	cMensagem := 	'Segue o caminho do arquivo gerado pelo relatorio *Pedidos em Aberto. \\server_erp\spool\pedidosemaberto.xls'
  	cAnexo	 := ""
	U_SendMail(cEmail,cAssunto,cMensagem,cAnexo,.t.)
EndIf

If Select("MP01") > 0
	MP01->(DBCLOSEAREA())
EndIf

FERASE(cDirDocs+"\"+_cArqCbc+".XLS")
FERASE(cDirDocs+"\"+_cArqCbc+".DBF")

Return(.T.)            



/******************************************************************************************************************
** FONTE :                                                                                                       **
** FUNCAO:                                                                                                       **
******************************************************************************************************************/
User Function MAPA01SC(lAuto)
//Local aButtons		:= {}
Local aAreaAtu		:= GetArea()
Local cCadastro	:= OemToAnsi("Envio do relatorio PedidosEmAberto")
Local nProcessa	:= 3
Local lAuto			:= If(lAuto == NIL,{.F.},lAuto)
Local lJob			:= .t.
//Local lJob			:= Iif(lAuto[1]==.T.,.T.,.F.)
//Local cQuery                        

RPCSetType(3)  // Nao usar Licensa

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "04" FUNNAME "U_MAPA01SC" //TABLES "SC5"

CRIAMAPA(.T.)

RESET ENVIRONMENT

RestArea(aAreaAtu)  
                
Return(Nil)