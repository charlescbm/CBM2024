#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE STR0002 "Nota Fiscal"
#DEFINE STR0003 "Série"
#DEFINE STR0004 "Codigo"
#DEFINE STR0005	"Descricao"
#DEFINE STR0008 "Resultado da Consulta"
#DEFINE STR0009 "NF"
#DEFINE STR0010 "Mensagem"
#DEFINE STR0011 "Consultar Novo Protocolo?"
#DEFINE STR0012 "Consultando Protocolo"
#DEFINE STR0013 "Aguarde..."


User Function PROTInfo()

Local aPerg			:= {}
Local aResult		:= {}

Local bPROTSearch

Local cXML

Local cError		:= ""
Local cWarning		:= ""

Local cMensagem
Local cResultado

Local oWSPROT
Local oXML

LOCAL lRetu1 := .F., aAutoDanfe, cFilePrint, cFileXML
LOCAL cIdEnt, aIndArq := {}, oDanfe, oSetup, nHRes := 0, nVRes := 0
LOCAL aDevice := {}, nDevice, cTitulo, cTexto, cEmail, cCopia, aAnexo
LOCAL cTempPath := GetTempPath(), cServPath := MsDocPath(), cNFes := ""
LOCAL lContinua := .F.

Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)

BEGIN SEQUENCE

aAdd( aPerg , { 1 , STR0002 , Space(9) , "999999999" , ".T." , "" , ".T." ,9 , .T. } )
aAdd( aPerg , { 1 , STR0003 , Space(3) , "999"       , ".T." , "" , ".T." ,3 , .T. })


IF ParamBox( @aPerg , "Parametros" , NIL , NIL , NIL , .T. )
	cIdEnt := u_BXGetIdEnt()
	
	oWSPROT 		          := WSNFeSBRA():New()
	oWSPROT:cUSERTOKEN        := "TOTVS"
	oWSPROT:cID_ENT           := cIdEnt
	oWSPROT:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
	oWSPROT:cIdInicial        := MV_PAR02+MV_PAR01
	oWSPROT:cIdFinal          := MV_PAR02+MV_PAR01
	oWSPROT:dDataDe           := ctod("01/01/1980")
	oWSPROT:dDataAte          := ctod("31/12/2049")
	oWSPROT:cCNPJDESTInicial  := Replicate(" ",14)
	oWSPROT:cCNPJDESTFinal    := Replicate("z",14)
	oWSPROT:nDiasparaExclusao := 0
	lOk                       := oWSPROT:RETORNAFX()
	oRetorno                  := oWSPROT:oWsRetornaFxResult
	
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
			
			If !Empty(oXml:oWSNFe:cProtocolo)
				cProtocol:= oXml:oWSNFe:cProtocolo
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
			EndIf
			
			If oXml:OWSNFECANCELADA <>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
				cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
				cNotaIni := oXml:cID
				cIdflush := cNotaIni
				cNFes := cNFes+cNotaIni+CRLF
			EndIf
		Next nX
		
	EndIf
EndIf
END SEQUENCE

Return


