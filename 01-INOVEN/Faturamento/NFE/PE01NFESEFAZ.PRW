/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ?±±
±±ºPrograma ?PE01NFESEFAZ ºAutor ³Eduardo (Meliora) ?Data ?01/12/13 ?±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ?±±
±±ºDesc. ?PONTO DE ENTRADA PARA MANIPULAR OS DADOS DA NF ANTES DO XML?	±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ?±±
±±ºUso ?AP ?															±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ?±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ESTE PONTO DE ENTRADA ELIMINA A NECESSIDADE DE SE ALTERAR O FONTE PADRÃO NFESEFAZ.PRW
*/
//DESENVOLVIDO POR INOVEN


#include "protheus.ch"

// aRetorno[1] -> aProd
// aRetorno[2] -> cMensCli
// aRetorno[3] -> cMensFis
// aRetorno[4] -> [4]
// aRetorno[5] -> aNota
// aRetorno[6] -> aInfoItem
// aRetorno[7] -> aDupl
// aRetorno[8] -> aTransp
// aRetorno[9] -> aEntrega
// aRetorno[10] -> aRetirada
// aRetorno[11] -> aVeiculo
// aRetorno[11] -> aReboque

USER FUNCTION PE01NFESEFAZ()

LOCAL aNfe 			:= PARAMIXB
LOCAL aAreaSC5		:= {}
//LOCAL nI			:= 0
LOCAL lNfSaida		:= (aNfe[5][4] == "1")
LOCAL lNfEntrada	:= (aNfe[5][4] == "0")
LOCAL cNumPed		:= "" //Strin com os pedidos para ser usada na mensagem
LOCAL cNumPedCli	:= "" //Strin com os pedidos do cliente para ser usada na mensagem
LOCAL aNumPed 		:= {} //Para montar string com o(s) pedido(s) da nota
local _prodluv      := GetMv("IN_PRODLUV")
//local _ncmttd2		:= GetMv("MV_LINCMF2")
Local lTemDifal := .F.
Local limp := .F.
local _Nvend := space(15)
Local cAux, nX

_EMAILV := ""

//Mensagens adicionais do cadastro da TES
For cAux :=1 to Len(aNfe[1])
	SF4->(Dbsetorder(1))
	IF SF4->(dbseek(xfilial("SF4")+AllTrim(aNfe[1][cAux][27])))
		IF !Empty(SF4->F4_X_FORM2) .AND. Formula(SF4->F4_X_FORM2) <> NIL .And. (!AllTrim(Formula(SF4->F4_X_FORM2)) $ aNfe[2] )
			aNfe[2] += FORMULA(SF4->F4_X_FORM2)
		ELSEIF  EMPTY(aNfe[2]) .AND. !Empty(SF4->F4_X_FORM2) .AND. Formula(SF4->F4_X_FORM2) <> NIL
			aNfe[2] := FORMULA(SF4->F4_X_FORM2)
		ENDIF

		IF !Empty(SF4->F4_X_FORM3) .AND. Formula(SF4->F4_X_FORM3) <> NIL .And. (!AllTrim(Formula(SF4->F4_X_FORM3)) $ aNfe[2] )
			aNfe[2] += FORMULA(SF4->F4_X_FORM3)
		ELSEIF  EMPTY(aNfe[2]) .AND. !Empty(SF4->F4_X_FORM3) .AND. Formula(SF4->F4_X_FORM3) <> NIL
			aNfe[2] := FORMULA(SF4->F4_X_FORM3)
		ENDIF

	ENDIF
Next

/*


IF cFilAnt == '0401'

For cAux :=1 to Len(aNfe[1])
//REDUÇÃO BC ICMS
If (AllTrim(aNfe[1][cAux][7]) $ '5102|5403' .AND. AllTrim(aNfe[4][9]) == "SP" .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(aNfe[1][cAux][5]) $ '90183119|90183219')//	 .OR. 	(AllTrim(aNfe[1][cAux][7]) == '6108' .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(SA1->A1_CONTRIB) = "2" .AND. AllTrim(SB1->B1_POSIPI) $ '90183119|90183219') ///////Retirado por mudança de legislação - Gilmar - 12/01/2016
nI := nI+1
EndIf
Next

If 	nI > 0
aNfe[2] += "- RED. ALIQ. A 12% DE ICMS CONF.ART.54 DO RICMS/2000"
EndIf


nI 	 := 0
cAux := 0



For cAux :=1 to Len(aNfe[1])
//PROTOCOLOS DE ICMS
If AllTrim(aNfe[1][cAux][7])  $	'6403|6404'
nI := nI+1
EndIf
Next
If 	nI > 0
Do Case
Case Alltrim(aNfe[4][9]) == "AL"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 35/07"
Case Alltrim(aNfe[4][9]) == "AP"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 59/11"
Case Alltrim(aNfe[4][9]) == "BA"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 105/09"
Case Alltrim(aNfe[4][9]) == "ES"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 25/09"
Case Alltrim(aNfe[4][9]) == "MA"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 95/11"
Case Alltrim(aNfe[4][9]) == "MG"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 37/09"
Case Alltrim(aNfe[4][9]) == "MS"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 12/07"
Case Alltrim(aNfe[4][9]) == "MT"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 7/08"
Case Alltrim(aNfe[4][9]) == "RJ"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA - PROTOCOLO 76/14"
EndCase
EndIf

nI 	 := 0
cAux := 0

For cAux :=1 to Len(aNfe[1])
//PROTOCOLOS DE ICMS - SP
If Alltrim(aNfe[1][cAux][7]) $	'5403' //.AND. SB1->B1_GRTRIB $ '001|002|003|004|005|010|011|020' - Gilmar - Retirado por solicitação do Andrews
nI := nI+1
EndIf
Next

If 	nI > 0
Do Case
Case Alltrim(aNfe[4][9]) == "SP"
aNfe[2] += "- SUBSTITUICAO TRIBUTARIA CONF.313-A DO RICMS/SP"
EndCase
EndIf
elseif cFilAnt == '0404'

For cAux :=1 to Len(aNfe[1])
//REDUÇÃO BC ICMS
//		_POSIPI:=Posicione("SB1", 1, xFilial("SB1") + AllTrim(aNfe[1][cAux][2]), "B1_POSIPI")

If (AllTrim(aNfe[1][cAux][7]) $ '6403|6404' .AND. AllTrim(aNfe[1][cAux][5]) $ '90251110'  .and. Alltrim(aNfe[4][9]) $ 'AP*MG*MT*PR*RJ*RS')//	 .OR. 	(AllTrim(aNfe[1][cAux][7]) == '6108' .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(SA1->A1_CONTRIB) = "2" .AND. AllTrim(SB1->B1_POSIPI) $ '90183119|90183219') ///////Retirado por mudança de legislação - Gilmar - 12/01/2016
nI := nI+1
EndIf
Next

If 	nI > 0
aNfe[2] += Formula("063")
ENDIF


nI 	 := 0
cAux := 0

For cAux :=1 to Len(aNfe[1])
//REDUÇÃO BC ICMS
If (AllTrim(aNfe[1][cAux][7]) $ '6403|6404'  .and. Alltrim(aNfe[4][9]) $ 'AC*AL*AP*BA*ES*MA*MT*MS*PA*PB*PE*PI*PR*RN*RR*RS*SE*TO') //	 .OR. 	(AllTrim(aNfe[1][cAux][7]) == '6108' .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(SA1->A1_CONTRIB) = "2" .AND. AllTrim(SB1->B1_POSIPI) $ '90183119|90183219') ///////Retirado por mudança de legislação - Gilmar - 12/01/2016
nI := nI+1
EndIf
Next

If 	nI > 0
aNfe[2] += Formula("062")
EndIf


nI 	 := 0
cAux := 0
ENDIF

*/
//Adiciona Lote e Data de Validade por Item do DANFE
If lNfSaida

	lluv:= .F.
	lTemPedido := .F.	
	cNrPedC5 := ''
	For cAux := 1 To Len(aNfe[1])
		DbSelectArea('SD2')
		SD2->(DbSetOrder(3))
		SD2->(DbGoTop())
		IF SD2->(DbSeek(xFilial('SD2') + aNfe[5][2] + aNfe[5][1] + SC6->C6_CLI + SC6->C6_LOJA + aNfe[1][cAux][2] + StrZero(aNfe[1][cAux][1], 2) ))
			SC6->(dbSetOrder(1))
			SC6->(msSeek(xFilial('SC6') + SD2->D2_PEDIDO + SD2->D2_ITEMPV))
			SA7->(dbSetOrder(2))  // A7_FILIAL, A7_PRODUTO, A7_CLIENTE, A7_LOJA.
			If SA7->(dBSeek(xFilial() + SD2->D2_COD + SD2->D2_CLIENTE + SD2->D2_LOJA))
				//aNfe[1][cAux][2] := SA7->A7_CODCLI
				aNfe[1][cAux][4] := alltrim(iif(!empty(SA7->A7_DESCCLI),SA7->A7_DESCCLI,SC6->C6_DESCRI))
			else
				aNfe[1][cAux][4] := alltrim(SC6->C6_DESCRI)
			endif
			
			//If Alltrim(SB1->B1_COD) $ SuperGetMv("TG_CODVOLK")
			//	aNfe[1][cAux][4] += AllTrim(Formula("094"))
			//Endif
			
			IF !Empty(SD2->D2_LOTECTL)
				aNfe[1][cAux][4] += ' -LOTE:' + AllTrim(SD2->D2_LOTECTL) + " VAL." + DtoC(SD2->D2_DTVALID)
			ENDIF
			cNumPed := AllTrim(SD2->D2_PEDIDO)
			cNrPedC5 := SD2->D2_PEDIDO
			if SD2->D2_DIFAL > 0
				lTemDifal := .T.
			endif
			lTemPedido := iif(!empty(SD2->D2_PEDIDO), .T., .F.)
			
		ENDIF
		
		//Monta array com os numeros dos pedidos para add na mensagem
		If !empty(cNumPed) .and. ASCAN(aNumPed,cNumPed) == 0
			AADD(aNumPed,cNumPed)
		EndIf
		If !empty(cNumPedCli) .and. ASCAN(aNumPed,cNumPedCli) == 0
			AADD(aNumPed,cNumPedCli)
		EndIf
	Next cAux
	
	//Adiciona o Telefone da Tranportadora
	// Renato Bandeira em 17/11/15 - Verifica se foi informada a transportadora
	If LEN(aNfe[8]) > 0
		aNfe[8][4] := Alltrim(aNfe[8][4]) + " Fone: " + Posicione("SA4", 3, xFilial("SA4") + aNfe[8][1], "A4_DDD") + " " + Posicione("SA4", 3, xFilial("SA4") + aNfe[8][1], "A4_TEL")
	Endif
	
	//Adiciona Numero dos Pedidos - JCB 30/03/2015
	If Len(aNumPed) > 0
		SC5->(DbSetOrder(1))
		nTamArray	:= Len(aNumPed)
		cNumPed 	:= ""
		cNumPedCli 	:= ""
		For nX := 1 To Len(aNumPed)
			If nX <= nTamArray
				cNumPed := cNumPed + aNumPed[nX] //+ " / "
				If (SC5->( DbSeek ( xFilial('SC5') + aNumPed[nX] ) .And. !Empty(SC5->C5_PEDCLI)))
					cNumPedCli := SC5->C5_PEDCLI //+ " / "
				EndIf
			EndIf                                                                     7
		Next nX
		aNfe[2] += " " +'Pedido Venda ' + cNumPed
		//	aNfe[2] += "	Pedido(s) do Cliente: " + cNumPedCli
		If len(aAreaSC5) > 0
			RestArea(aAreaSC5)
		Endif
	EndIf

	if lTemPedido
		SC5->(dbSetOrder(1))
		SC5->(msSeek(xFilial('SC5') + cNrPedC5))
	endif	

	// Adiciona Mensagem Comercial
	//	If ! Empty(SC5->C5_XOBSCO) // Alterado por Guilherme Muniz em 28/10/2016 - Imprimir na DANFE
	//			aNfe[2] += " "+AllTrim(SC5->C5_XOBSCO)
	//	endif
	
	// Adiciona Mensagem Comercial
	If lTemPedido .and. !Empty(SC5->C5_XOBSCO) // Alterado por Guilherme Muniz em 28/10/2016 - Imprimir na DANFE
		aNfe[2] += " "+ConvEsp(AllTrim(SC5->C5_XOBSCO))
	EndIf
	
	
	// Adiciona Mensagem Logistica
	//	If SC5->C5_XMSGLOG=='1' //.AND. cFilant = '0401'
	If lTemPedido .and. !Empty(SC5->C5_XOBSLO) // Alterado por Guilherme Muniz em 28/10/2016 - Imprimir na DANFE
		aNfe[2] += " "+ConvEsp(AllTrim(SC5->C5_XOBSLO))
	EndIf
	
	if lTemPedido .and. !empty(SC5->C5_VEND1)
		_EMAILV:= Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")
		_Nvend := Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_COD")
		aNfe[2] += " " +'Vendedor ' + ALLTRIM(_Nvend) + ' '
	endif	
	
	if !EMPTY(_EMAILV)
		aNfe[4][16] := ALLTRIM(aNfe[4][16])+';'+ALLTRIM(_EMAILV)
	endif
	
	
	
	//-- Altera data de vencimento do título para data de tranmissão para não ocorrer erro de vencimento de parcela.
	//If lNfSaida
	//	For cAux := 1 To Len(aNfe[7])
	//		aNfe[7][cAux][2] := dDataBase
	//	Next cAux
	//EndIf
	//-- FIM
	
	

	//alterado por Guilherme Muniz em 22/12/2016 - Remover Caracter Especial
	//If !Empty(aNfe[2])
	//	aNfe[2] := InfCpl(aNfe[2])
	//	EndIf
	
	/*/
	//Imprime o Endereço de Entrega
	If Alltrim(SA1->A1_END) <> Alltrim(SA1->A1_ENDENT)
		aNfe[4][3] 	:= SA1->A1_ENDENT
		aNfe[4][6] 	:= SA1->A1_BAIRROE
		aNfe[4][7] 	:= SA1->A1_CODMUNE
		aNfe[4][8] 	:= SA1->A1_MUNE
		aNfe[4][9] 	:= SA1->A1_ESTE
		aNfe[4][10] := SA1->A1_CEPE
	EndIf
	/*/
	
	
	nH := 0

	For cAux :=1 to Len(aNfe[1])
	
		If AllTrim(aNfe[1][cAux][2]) $ (_prodluv) 	// .OR. 	(AllTrim(aNfe[1][cAux][7]) == '6108' .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(SA1->A1_CONTRIB) = "2" .AND. AllTrim(SB1->B1_POSIPI) $ '90183119|90183219') ///////Retirado por mudança de legislação - Gilmar - 12/01/2016
			nH := nH+1
			lluv:= .T.
		EndIf
	
	Next
	
	If 	nH > 0 .AND. lluv
		aNfe[2] += 'Luva látex e nitrílica descartável são de uso exclusivo INDL. Não destinado para uso médico hospitalar ou para qualquer aplicação com foco na saúde'
	endif
   
	aNfe[2] += 'Exclusão do ICMS da Base do PIS e COFINS concedida através de liminar referente ao processo nº Nº 5005298-71.2017.4.04.7200/SC'

	//Mensagem especifica cliente
	If !SC5->C5_TIPO $ "DB" 
		SA1->(dbGoTop())
		SA1->(dbSetOrder(1))
		if SA1->(msSeek(xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
			if !empty(SA1->A1_XMSGNF)
				aNfe[2] += " " + SA1->A1_XMSGNF
			endif
		endif
	endif
	
EndIf

If lNfEntrada
	
	limp:= .F.
	
	For cAux := 1 To Len(aNfe[1])
		DbSelectArea('SD1')
		SD1->(DbSetOrder(1))
		SD1->(DbGoTop())
		IF SD1->(DbSeek(xFilial('SD1') + aNfe[5][2] + aNfe[5][1] + SF1->F1_FORNECE + SF1->F1_LOJA + aNfe[1][cAux][2] + StrZero(aNfe[1][cAux][1], 4) ))
			IF !Empty(SD1->D1_LOTECTL)
				//aNfe[1][cAux][4] += '              - LOTE: ' + AllTrim(SD1->D1_LOTECTL) + IIf(!Empty(DtoC(SD1->D1_DTVALID)), " DT. VALID.: " + DtoC(SD1->D1_DTVALID), "")
				aNfe[1][cAux][4] += ' - LOTE: ' + AllTrim(SD1->D1_LOTECTL) + IIf(!Empty(DtoC(SD1->D1_DTVALID)), " DT. VALID.: " + DtoC(SD1->D1_DTVALID), "")
			ENDIF
		ENDIF
	Next cAux
	
	/*
	if cFilAnt == '0404'
	
	For cAux :=1 to Len(aNfe[1])
	
	If (AllTrim(aNfe[1][cAux][7]) $ '3102/3949' .AND. AllTrim(aNfe[1][cAux][5]) $ (_ncmttd1+_ncmttd2)  .and. Alltrim(aNfe[4][9]) $ 'EX')//	 .OR. 	(AllTrim(aNfe[1][cAux][7]) == '6108' .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(SA1->A1_CONTRIB) = "2" .AND. AllTrim(SB1->B1_POSIPI) $ '90183119|90183219') ///////Retirado por mudança de legislação - Gilmar - 12/01/2016
	nI := nI+1
	limp:= .T.
	EndIf
	Next
	
	If 	nI > 0
	aNfe[2] += "IMPORTACAO ICMS DIFERIDO.MEDICAMENTOS EQUIPAMENTOS MEDICOS-HOSPITALARES.TTD No 175000000863680 PROCESSO N?SEF 12274/2017'
	endif
	
	nI 	 := 0
	cAux := 0
	
	For cAux :=1 to Len(aNfe[1])
	//REDUÇÃO BC ICMS
	If (AllTrim(aNfe[1][cAux][7]) $ '3102/3949' .AND. !(AllTrim(aNfe[1][cAux][5]) $ (_ncmttd1+_ncmttd2))  .and. Alltrim(aNfe[4][9]) $ 'EX')//	 .OR. 	(AllTrim(aNfe[1][cAux][7]) == '6108' .AND. AllTrim(SF4->F4_SITTRIB) == "00" .AND. AllTrim(SA1->A1_CONTRIB) = "2" .AND. AllTrim(SB1->B1_POSIPI) $ '90183119|90183219') ///////Retirado por mudança de legislação - Gilmar - 12/01/2016
	nI := nI+1
	limp:= .T.
	EndIf
	Next
	
	If 	nI > 0
	aNfe[2] += "TTD IMPORTACAOES No 175000000792058 : ICMS DIFERIDO '"
	endif
	
	nI 	 := 0
	cAux := 0
	
	ENDIF
	
	if limp
	aNfe[2] += " Local de entrega: NEST ARMAZEM E LOGISTICA, CNPJ :25.211.082/0001-44 ROD BR-470 Num. 6.800,Cep:88371-890 Navegantes-SC"
	endif
	*/
	//GILMAR - 29/03/2016
	If AllTrim(SF1->F1_EST) == "EX" //.And. AllTrim(SD1->D1_CF) <> "3949"
		DbSelectArea("SW6")
		DbSetOrder(1)
		// Procura algum registro na SW6 referente a nota que foi complementada
		If MsSeek(xFilial("SW6")+SF1->F1_HAWB)
			aNfe[2] += "Numero DI: " +Alltrim(SW6->W6_DI_NUM)  + " / "
			aNfe[2] += "Data DI: "+Alltrim(dtoc(SW6->W6_DTREG_D))  + " / "
			aNfe[2] += "Numero PO: "+Alltrim(SW6->W6_PO_NUM)  + " / "
			aNfe[2] += "Pis: "+AllTrim(Transform(SF1->F1_VALIMP6, "@ze 9,999,999,999,999.99"))  + " / "
			aNfe[2] += "Cofins: "+AllTrim(Transform(SF1->F1_VALIMP5, "@ze 9,999,999,999,999.99")) + " / "
			aNfe[2] += "Local Desemb: " +Alltrim(SW6->W6_LOCALN) + " / "
			aNfe[2] += "UF Desemb: " +Alltrim(SW6->W6_UFDESEM) + " / "
			aNfe[2] += "Data Desemb: " +Alltrim(dtoc(SW6->W6_DT_DESE)) + " / "
		EndIf
		
		aNfe[2] += "Despesas acessoria composta por Taxa SisComex "
	ENDIF
	
	
EndIf







RETURN aNfe
//----------------------------------------------------------------------------+
Static Function InfCpl(cString)
Local cStr := AllTrim(SuperGetMV("LA_INFCPL",,">;<;"))
Local aStr := StrToKArr(cStr, ";")                       '
Local nI

For nI := 1 To Len(aStr)
	If !Empty(aStr[nI]) .And. aStr[nI] $ cString
		cString := StrTran(cString, aStr[nI], "")
	EndIf
Next

Return( cString )





//-------------------------------------------------------------------
/*/{Protheus.doc} ConvEsp
Chama função do banco para converter texto retirando caracteres especiais.
@author Leandro Prado
@since 14/08/2018
@version 1.0

/*/
//-------------------------------------------------------------------
Static function ConvEsp(cTexto)
Local cRet := ""
Local cAliasP := GetNextAlias()
Local cQuery := "	SELECT dbo.FN_FORMATAR_TEXTO('" + AllTrim(cTexto) + "') AS TXTALT"

//--Cria uma tabela temporária com as informações da query
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasP,.F.,.T.)

cRet := AllTrim((cAliasP)->TXTALT)

If ValType(cRet) == "U" .OR. Empty(AllTrim(cRet))
	cRet := cTexto
endif

(cAliasP)->(DbCloseArea())
//Alert(AllTrim(cRet))

Return cRet
