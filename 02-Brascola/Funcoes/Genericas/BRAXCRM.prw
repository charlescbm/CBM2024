#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE CRLF chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRAXCRM  ºAutor  ³ Marcelo da Cunha   º Data ³  05/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes Diversas para CRM Brascola                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BXCrmDanfeºAutor  ³ Marcelo da Cunha   º Data ³  05/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para envio automatico DANFE/XML de acordo com acao  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BXCrmDanfe()
***********************
LOCAL lRetu1 := .F., aAutoDanfe, cFilePrint, cFileXML
LOCAL cIdEnt, aIndArq := {}, oDanfe, oSetup, nHRes := 0, nVRes := 0
LOCAL aDevice := {}, nDevice, cTitulo, cTexto, cEmail, cCopia, aAnexo
LOCAL cTempPath := GetTempPath(), cServPath := MsDocPath(), cNFes := ""
LOCAL lContinua := .F., aWizard := MontaPainel(@lContinua)
LOCAL cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Diretorio tempoaraio e do servidor para gravar o arquivo     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTempPath := Alltrim(cTempPath)
If (Right(cTempPath,1) != "\")
	cTempPath += "\"
Endif
cServPath := Alltrim(cServPath)
If (Right(cServPath,1) != "\")
	cServPath += "\"
Endif
                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (lContinua).and.!Empty(aWizard[1,3]).and.(!Empty(aWizard[1,4]).or.!Empty(aWizard[1,5]))
	SF2->(dbSetOrder(1))
	If !SF2->(dbSeek(xFilial("SF2")+aWizard[1,3]+aWizard[1,2]))
		Help("",1,"BRASCOLA",,OemToAnsi("Nota Fiscal Informada ("+aWizard[1,3]+"/"+aWizard[1,2]+") nao foi ncontrada!"),1,0)
		Return (lRetu := .F.)
	Endif
	//////////////////////////////////////////////////////
	aAnexo := {}
	cIdEnt := u_BXGetIdEnt()
	If ("DANFE"$aWizard[1,1]) //Danfe ou Ambos
		PRIVATE cCondicao := "", bFiltraBrw, aFilBrw := {"SF2",".T."}, lRedefVeic := .F., lVeicOK := .T.
		PRIVATE cCondQry := "", aPergCCe := {}, aIndArq := {}, aParamVeic := {}, aPergCle := {}
		//////////////////////////////////////////////////////
		cFilePrint := "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")+".pdf"
		lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
		oDanfe := FWMSPrinter():New(cFilePrint,IMP_PDF,lAdjustToLegacy,,.T.,,NIL,,,,,.F.)
		oDanfe:SetResolution(78) // Tamanho estipulado para a Danfe
		oDanfe:SetLandscape()
		oDanfe:SetPaperSize(DMPAPER_A4)
		oDanfe:SetMargin(60,60,60,60)
		oDanfe:lServer := .F.
		oDanfe:cPathPDF := cTempPath
		//////////////////////////////////////////////////////
		aAutoDanfe := Array(6)
		aAutoDanfe[1] := aWizard[1,3] //Nota De
		aAutoDanfe[2] := aWizard[1,3] //Nota Ate
		aAutoDanfe[3] := aWizard[1,2] //Serie
		aAutoDanfe[4] := 2 //Tipo Operacao: Saida
		aAutoDanfe[5] := 2 //Verso
		aAutoDanfe[6] := 2 //Simplificado
		MsAguarde( {|| u_DANFE_P1(cIdEnt,,,oDanfe,NIL,aAutoDanfe) }, "Gerando PDF..." )
		__CopyFile(cTempPath+cFilePrint,cServPath+cFilePrint)
		If File(cServPath+cFilePrint)
		   aadd(aAnexo,cServPath+cFilePrint)
		Endif        
		If (oDanfe != Nil)
			FreeObj(oDanfe)
		Endif
		oDanfe := Nil
		oSetup := Nil
		//////////////////////////////////////////////////////
	Endif
	//////////////////////////////////////////////////////
	If ("XML"$aWizard[1,1]) //XML ou Ambos
		cFileXML := "NFEXML_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")+".xml"
		//////////////////////////////////////////////////////
		oWS:= WSNFeSBRA():New()
		oWS:cUSERTOKEN        := "TOTVS"
		oWS:cID_ENT           := cIdEnt 
		oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
		oWS:cIdInicial        := aWizard[1,2]+aWizard[1,3]
		oWS:cIdFinal          := aWizard[1,2]+aWizard[1,3]
		oWS:dDataDe           := ctod("01/01/1980")
		oWS:dDataAte          := ctod("01/01/2049")
		oWS:cCNPJDESTInicial  := Replicate(" ",14)
		oWS:cCNPJDESTFinal    := Replicate("z",14)
		oWS:nDiasparaExclusao := 0
		lOk := oWS:RETORNAFX()
		oRetorno := oWS:oWsRetornaFxResult
		If lOk
		    For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
		 		oXml := oRetorno:OWSNOTAS:OWSNFES3[nX]
				oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
				cXML := "" 
				If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U" 
					cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
				ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
					cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)				
				Else
	    			cCNPJDEST := ""
    			EndIf	
  				cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')                                 
  				cVerCte := Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
		 		If !Empty(oXml:oWSNFe:cProtocolo)
			    	cNotaIni := oXml:cID	 		
					cIdflush := cNotaIni
			 		cNFes    := cNFes+cNotaIni+CRLF
			 		cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")	 			
					cModelo  := cChvNFe
					cModelo  := StrTran(cModelo,"NFe","")
					cModelo  := StrTran(cModelo,"CTe","")
					cModelo  := SubStr(cModelo,21,02)
					Do Case
						Case cModelo == "57"
							cPrefixo := "CTe"
						OtherWise
							cPrefixo := "NFe"
					EndCase	 				
		 			cFileXML:=SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml"
		 			nHandle := FCreate(cTempPath+cFileXML)
		 			If nHandle > 0
		 				cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
		 				If cModelo == "57"
							cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
							cRodap := '</cteProc>'
						Else
							Do Case
								Case cVerNfe <= "1.07"
									cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
								Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
									cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
								OtherWise
									cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
							EndCase
							cRodap := '</nfeProc>'
						EndIf
						FWrite(nHandle,AllTrim(cCab1))							
			 			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
			 			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
						FWrite(nHandle,AllTrim(cRodap))	 
			 			FClose(nHandle)
						__CopyFile(cTempPath+cFileXML,cServPath+cFileXML)
						If File(cServPath+cFileXML)
						   aadd(aAnexo,cServPath+cFileXML)
						Endif
			 			cXML := AllTrim(cCab1)+AllTrim(oXml:oWSNFe:cXML)+AllTrim(cRodap)
			 		EndIf					
			 	EndIf
			 	If oXml:OWSNFECANCELADA <>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
				 	cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
				 	cNotaIni := oXml:cID	 		
					cIdflush := cNotaIni
			 		cNFes := cNFes+cNotaIni+CRLF
				 	If !"INUT"$oXml:oWSNFeCancelada:cXML
					 	cFileXML:= SubStr(cChvNFe,3,44)+"-ped-can.xml"
			 			nHandle := FCreate(cTempPath+cFileXML)
			 			If nHandle > 0
			 				cCanc := oXml:oWSNFeCancelada:cXML
			 				oXml:oWSNFeCancelada:cXML := '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + oXml:oWSNFeCancelada:cXML + "</procCancNFe>"
				 			FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
				 			FClose(nHandle)
							__CopyFile(cTempPath+cFileXML,cServPath+cFileXML)
							If File(cServPath+cFileXML)
							   aadd(aAnexo,cServPath+cFileXML)
							Endif
				 		EndIf      
				 		cFileXML:= SubStr(cChvNFe,3,44)+"-can.xml"
			 			nHandle := FCreate(cTempPath+cFileXML)
			 			If nHandle > 0
				 			FWrite(nHandle,'<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + cCanc + oXml:oWSNFeCancelada:cXMLPROT + "</procCancNFe>")
				 			FClose(nHandle)
							__CopyFile(cTempPath+cFileXML,cServPath+cFileXML)
							If File(cServPath+cFileXML)
							   aadd(aAnexo,cServPath+cFileXML)
							Endif
				 		EndIf
				 	Else 
						cXmlInut  := oXml:OWSNFECANCELADA:CXML
				 	   cAnoInut1 := At("<ano>",cXmlInut)+5
					 	cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
			 			nHandle := FCreate(cDestino+SubStr(cChvNFe,3,2)+cAnoInut+SubStr(cChvNFe,5,38)+"-ped-inu.xml")
			 			If nHandle > 0
				 			FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
				 			FClose(nHandle)
				 		EndIf
				 		cFileXML:= cAnoInut+SubStr(cChvNFe,5,38)+"-inu.xml"
			 			nHandle := FCreate(cTempPath+cFileXML)
			 			If nHandle > 0
				 			FWrite(nHandle,oXml:oWSNFeCancelada:cXMLPROT)
				 			FClose(nHandle)
							__CopyFile(cTempPath+cFileXML,cServPath+cFileXML)
							If File(cServPath+cFileXML)
							   aadd(aAnexo,cServPath+cFileXML)
							Endif
				 		EndIf		 	
				 	EndIf
				EndIf
			Next nX
		Endif
	Endif
	//////////////////////////////////////////////////////
	If (Len(aAnexo) > 0)             
	   cTitulo := "["+SUC->UC_codigo+"] > Envio Automático "+aWizard[1,1]+" para Cliente"
	   cTexto  := "ATENDIMENTO: "+SUC->UC_codigo+"<br>"
	   cTexto  += "OPERADOR: "+Alltrim(Posicione("SU7",1,xFilial("SU7")+SUC->UC_operado,"U7_NOME"))+"<br>"
		If (SUC->UC_entidad == "SA1")
	   	cTexto  += "CLIENTE: "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SUC->UC_chave,"A1_NOME"))+"<br>"
	 	Endif
	   cTexto  += "NOTA/SERIE: "+aWizard[1,3]+"/"+aWizard[1,2]+"<br>"
	   cEmail  := aWizard[1,4] //Email Destino
	   cCopia  := aWizard[1,5] //Email Copia
	   u_GDVWFAviso("WDANFE","000001",cTitulo,cTexto,cEmail,cCopia,aAnexo)
	   lRetu1 := .T. //Processo Executado com Sucesso
	Endif	
Endif

Return lRetu1

Static Function MontaPainel(lContinua)
**********************************
LOCAL aWizard := {}, aPInicial := {}, aParams := {}
LOCAL cTitulo := "Envio da DANFE Automático para o Cliente"
LOCAL cCliente, cEmail1, cEmail2, cArqCfp

//Busco dados do cliente
cCliente := Space(80)
cEmail1  := Space(80) 
If (SUC->UC_entidad == "SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+SUC->UC_chave))
		cCliente := Alltrim(SA1->A1_nome)
		cEmail1  := Alltrim(SA1->A1_email)
	Endif
Endif

//Busco dados do usuario corrente
cEmail2 := Space(80)            
PswOrder(1)
If PswSeek(RetCodUsr())
	cEmail2 := PswRet(1)[1,14]
Endif
                                                        
//Painel Principal
aAdd(aPInicial, cTitulo)
aAdd(aPInicial, "")
aAdd(aPInicial, cTitulo)
aAdd(aPInicial, "Este programa tem por objetivo o envio automático da DANFE para o cliente "+Alltrim(cCliente)+".")

//Parametros da Rotina
aAdd(aParams, {})
aAdd(aParams[1], cTitulo)
aAdd(aParams[1], "Parâmetros")
aAdd(aParams[1], {})                       
aAdd(aParams[1][3], {1,"Enviar Arquivos",,,,,,})
aAdd(aParams[1][3], {3,,,,,{"DANFE+XML","DANFE","XML"},,})
aAdd(aParams[1][3], {1,"Serie Nota Fiscal",,,,,,})
aAdd(aParams[1][3], {2,Space(3),,1,,,,3})
aAdd(aParams[1][3], {1,"Numero Nota Fiscal ",,,,,,})
aAdd(aParams[1][3], {2,Space(9),,1,,,,9})
aAdd(aParams[1][3], {1,"E-mail para Envio",,,,,,})
aAdd(aParams[1][3], {2,cEmail1,,1,,,,80})
aAdd(aParams[1][3], {1,"Copia E-mail para Envio",,,,,,})
aAdd(aParams[1][3], {2,cEmail2,,1,,,,80})

//Tela para solicitar os parametros
cArqCfp := "DANFE"+cEmpAnt
If File(cArqCfp+".cfp")
	FErase(cArqCfp+".cfp")
Endif
lContinua := xMagWizard(aPInicial,aParams,cArqCfp)
If (lContinua)
	lContinua := xMagLeWiz(cArqCfp,@aWizard,.T.)
EndIf

Return aWizard