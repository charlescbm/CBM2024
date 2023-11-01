#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"                                      
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

#DEFINE TAMMAXXML  If((GetNewPar("MV_XMLSIZE",400000) < 400000), 400000, iif((GetNewPar("MV_XMLSIZE",400000) > 800000),800000,GetNewPar("MV_XMLSIZE",400000)))
#DEFINE VBOX       080
#DEFINE HMARGEM    030

//Static cTipoNfe := "" 

/*/{Protheus.doc} IFATM002

@description Realiza a impressão da Danfe

@author Totvs
@type function
/*/
//DESENVOLVIDO POR INOVEN

User Function IFATM002()

Local cIdEnt 		:= ""
//Local aIndArq   	:= {}
Local oDanfe		
//Local nHRes  		:= 0
//Local nVRes  		:= 0
//Local nDevice
Local cFilePrint 	:= ""
Local oSetup
Local aDevice  		:= {}
Local cSession     	:= GetPrinterSession()
Local nRet 			:= 0
Local lUsaColab		:= UsaColaboracao("1") 

If findfunction("U_DANFE_V")
	nRet := U_Danfe_v()
Elseif findfunction("U_DANFE_VI") // Incluido esta validação pois o cliente informou que não utiliza o DANFEII
	nRet := U_Danfe_vi() 
EndIf

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

cIdEnt 			:= RetIdEnti(lUsaColab)

cFilePrint 		:= "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")
                                                                        
nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType      := aScan(aDevice,{|x| x == cDevice })

If IsReady(,,,lUsaColab)
	dbSelectArea("SF2")
	RetIndex("SF2")
	dbClearFilter() 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If nRet >= 20100824
	
		lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
		oDanfe := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)
		
		// ----------------------------------------------
		// Cria e exibe tela de Setup Customizavel
		// OBS: Utilizar include "FWPrintSetup.ch"
		// ----------------------------------------------
		nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
		If ( !oDanfe:lInJob )
			oSetup := FWPrintSetup():New(nFlags, "DANFE")
			// ----------------------------------------------
			// Define saida
			// ----------------------------------------------
			oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
			oSetup:SetPropert(PD_ORIENTATION , nOrientation)
			oSetup:SetPropert(PD_DESTINATION , nLocal)
			oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
			oSetup:SetPropert(PD_PAPERSIZE   , 2)
		
		EndIf
		
		// ----------------------------------------------
		// Pressionado botão OK na tela de Setup
		// ----------------------------------------------
		If oSetup:Activate() == PD_OK // PD_OK =1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Salva os Parametros no Profile             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	        fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
	        fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
	        fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
			
			// Configura o objeto de impressão com o que foi configurado na interface.
	        oDanfe:setCopies( val( oSetup:cQtdCopia ) )
			
			If oSetup:GetProperty(PD_ORIENTATION) == 1
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Danfe Retrato DANFEII.PRW                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
				u_PrtNfeSef(cIdEnt ,/*cVal1*/ ,/*cVal2*/ ,oDanfe ,oSetup ,cFilePrint ,/*lIsLoja*/ )
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Danfe Paisagem DANFEIII.PRW                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				u_DANFE_P1(cIdEnt ,/*cVal1*/ ,/*cVal2*/ ,oDanfe ,oSetup ,/*lIsLoja*/ )
			EndIf
			
		Else
		
			MsgInfo("Relatório cancelado pelo usuário.")
			Pergunte("NFSIGW",.F.)
			Return
		Endif
	
	Else
	 	u_PrtNfeSef(cIdEnt)
	EndIf		

	Pergunte("NFSIGW",.F.)

EndIf
oDanfe := Nil
oSetup := Nil
	
Return Nil

Static Function IsReady(cURL,nTipo,lHelp,lUsaColab)

//Local nX       := 0
Local cHelp    := ""
local cError	:= ""
//Local oWS
Local lRetorno := .F.
DEFAULT nTipo := 1
DEFAULT lHelp := .F.
DEFAULT lUsaColab := .F.
if !lUsaColab
   If FunName() <> "LOJA701"
   		If !Empty(cURL) .And. !PutMV("MV_SPEDURL",cURL)
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial( "SX6" )
			SX6->X6_VAR     := "MV_SPEDURL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "URL SPED NFe"
			MsUnLock()
			PutMV("MV_SPEDURL",cURL)
		EndIf
		SuperGetMv() //Limpa o cache de parametros - nao retirar
		DEFAULT cURL      := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Else
		If !Empty(cURL) .And. !PutMV("MV_NFCEURL",cURL)
			RecLock("SX6",.T.)
			SX6->X6_FIL     := xFilial( "SX6" )
			SX6->X6_VAR     := "MV_NFCEURL"
			SX6->X6_TIPO    := "C"
			SX6->X6_DESCRIC := "URL de comunicação com TSS"
			MsUnLock()
			PutMV("MV_NFCEURL",cURL)
		EndIf
		SuperGetMv() //Limpa o cache de parametros - nao retirar
		DEFAULT cURL      := PadR(GetNewPar("MV_NFCEURL","http://"),250)	
	EndIf	
	//Verifica se o servidor da Totvs esta no ar	
	if(isConnTSS(@cError))	
		lRetorno := .T.
	Else
		If lHelp
			Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Execute o compatibilizador para o registro de saida"},3)
		EndIf
		lRetorno := .F.
	EndIf
	
	
	//Verifica se Há Certificado configurado	
	If nTipo <> 1 .And. lRetorno		
		
		if( isCfgReady(, @cError) )
			lRetorno := .T.
		else	
			If nTipo == 3
				cHelp := cError
			
				If lHelp .And. !"003" $ cHelp
					Aviso("SPED",cHelp,{"Execute o compatibilizador para o registro de saida"},3)
					lRetorno := .F.
			
				EndIf		
			
			Else
				lRetorno := .F.
			
			EndIf
		endif

	EndIf
	
	//Verifica Validade do Certificado	
	If nTipo == 2 .And. lRetorno
		isValidCert(, @cError)
	EndIf
else
	lRetorno := ColCheckUpd()
	if lHelp .And. !lRetorno .And. !lAuto
		MsgInfo("UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0")		
	endif	
endif

Return(lRetorno)
