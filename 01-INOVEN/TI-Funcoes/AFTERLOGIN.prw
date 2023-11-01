#Include "PROTHEUS.CH"
#Include "parmtype.ch"
#Include "FWMVCDEF.CH"
#Include "FWBROWSE.CH"
#Include "TOPCONN.CH"
       
/*
Funcao      : AFTERLOGIN
Objetivos   : P.E. para Controle de acessos 
Autor     	: Anderson Arrais 
Data     	: 16/01/2020
TDN         : Ao acessar pelo SIGAMDI, este ponto de entrada é chamado ao entrar na rotina. Pelo modo SIGAADV, a abertura dos SXs é executado após o login.
Módulo      : Todos
*/
*----------------------------*
User Function AFTERLOGIN()
*----------------------------*  

//Validação de ambiente emergencial
//If ValidaEmerg()
//	ALERT("Acesso não Autorizado!")
//	KillApp( .T. )         
//EndIf

//Busca a cotação da moeda no BACEN
GetCotMoeda()

Return
   
*---------------------------*
Static Function GetCotMoeda()
*---------------------------*
Local i
Local xPar1 := ""
Local xPar2 := 1     // CODIGO 1 PARA DOLAR
Local oBC
Local nDollar 	:= 0  
Local nEuro   	:= 0
//Local nLibraEst	:= 0
//Local nDollarCan:= 0

Private dDataCot := DATE()

SYE->(DbSetOrder(2))//YE_FILIAL+YE_MOEDA+DTOS(YE_DATA)
SM2->(DbSetOrder(1))

//For dos ultimos 7 dias, para garantir que todos os dias contem taxa moeda. (sabado,domingo e feriados)
For i:=6 TO 0 STEP -1
	dDataCot := DATE()-i
	SET DATE FORMAT "dd/mm/yyyy"
	xPar1 := dDataCot

	nDollar:= 0
	nEuro  := 0

	//Criação do Registro da Data no SM2
	If !SM2->(DbSeek(DTOS(dDataCot)))
		SM2->(RecLock("SM2",.T.))
		SM2->M2_INFORM := "S"
		SM2->M2_DATA   := dDataCot
		SM2->M2_MOEDA2 := nDollar
		SM2->M2_MOEDA4 := nEuro
		SM2->(MsUnlock())
	EndIf

	If SM2->(DbSeek(DTOS(dDataCot)))
		If SM2->M2_MOEDA2 == 0
			xPar2	:= 1     // CODIGO 1 PARA DOLAR
			oBC		:= WSBACEN():NEW(xPar1,xPar2)
			nDollar	:= oBC:NVALOR
		EndIf
		If SM2->M2_MOEDA4 == 0
			oBc		:= nil  
			xPar2	:= 21619 //Série EURO no banco central
			oBC		:= WSBACEN():NEW(xPar1,xPar2)
			nEuro	:= oBC:NVALOR 
		EndIf
		//xPar2	:= 21623 //Série Libra esterlina (venda)
		//xPar2	:= 21635 //Série Dólar Canadense (venda)

		If SM2->M2_MOEDA2 == 0 .or. SM2->M2_MOEDA4 == 0
			SM2->(RecLock("SM2",.F.))
			SM2->M2_INFORM := "S"
			SM2->M2_MOEDA2 := IIF(nDollar<>0,nDollar,SM2->M2_MOEDA2)
			SM2->M2_MOEDA4 := IIF(nEuro<>0  ,nEuro  ,SM2->M2_MOEDA4)
			SM2->(MsUnlock())
		EndIf
	EndIf

	//Gravação das moedas do EIC
	//DOllar
	If SM2->M2_MOEDA2 <> 0
		If !SYE->(DbSeek(xFilial("SYE")+"US$"+DTOS(dDataCot)))
			SYE->(RecLock("SYE",.T.))
			SYE->YE_FILIAL	:= xFilial("SYE")
			SYE->YE_DATA	:= dDataCot
			SYE->YE_MOE_FIN	:= ' 2'
			SYE->YE_MOEDA	:= "US$"
			SYE->YE_VLCON_C := SM2->M2_MOEDA2
			SYE->YE_VLFISCA := SM2->M2_MOEDA2
			SYE->YE_TX_COMP := SM2->M2_MOEDA2
			SYE->(MsUnlock())
		ElseIf SYE->YE_VLCON_C == 0 .or. SYE->YE_VLFISCA == 0 .or. SYE->YE_TX_COMP == 0
			SYE->(RecLock("SYE",.F.))
			SYE->YE_VLCON_C := SM2->M2_MOEDA2
			SYE->YE_VLFISCA := SM2->M2_MOEDA2
			SYE->YE_TX_COMP := SM2->M2_MOEDA2
			SYE->(MsUnlock())
		EndIf
	EndIf
	//Euro
	If SM2->M2_MOEDA4 <> 0
		If !SYE->(DbSeek(xFilial("SYE")+"EUR"+DTOS(dDataCot)))
			SYE->(RecLock("SYE",.T.))
			SYE->YE_FILIAL	:= xFilial("SYE")
			SYE->YE_DATA	:= dDataCot
			SYE->YE_MOE_FIN	:= ' 4'
			SYE->YE_MOEDA	:= "EUR"
			SYE->YE_VLCON_C := SM2->M2_MOEDA4
			SYE->YE_VLFISCA := SM2->M2_MOEDA4
			SYE->YE_TX_COMP := SM2->M2_MOEDA4
			SYE->(MsUnlock())
		ElseIf SYE->YE_VLCON_C == 0 .or. SYE->YE_VLFISCA == 0 .or. SYE->YE_TX_COMP == 0
			SYE->(RecLock("SYE",.F.))
			SYE->YE_VLCON_C := SM2->M2_MOEDA4
			SYE->YE_VLFISCA := SM2->M2_MOEDA4
			SYE->YE_TX_COMP := SM2->M2_MOEDA4
			SYE->(MsUnlock())
		EndIf
	EndIf
Next i

Return .T.

//#############################################################################################################
//#############################################################################################################
//###########                                                   ###############################################
//########### Objeto de tratamento do acesso aos dados do BACEN ###############################################
//###########                                                   ###############################################
//#############################################################################################################
//#############################################################################################################
CLASS WSBacen

//======================
METHOD NEW() constructor

//=============
METHOD finish()  

DATA dData   // data da operacao
DATA dPTAX   // data do ptax
DATA nTipo   // tipo
DATA cTipo
DATA nValor  
DATA cDia
DATA cMensagem           
DATA lNoDia
DATA lStatus 

ENDCLASS
                     
//=====================================
METHOD NEW(_dData,_nTipo) CLASS WsBacen      
Private cSoapSend	:= ""
Private cSoapAction := ""
Private cURL := ""
Private aSem := {"DOMINGO","SEGUNDA","TERCA","QUARTA","QUINTA","SEXTA","SABADO"}
Private nProc := 0
Private __lWsErro //:= .f.  //variavel para controle de erro, se .t. erro de operacao
Private __cWSErro //:= ""   // variavel com o log de erro caso __lWSErro seja .t.
Private __dData //:= _dData
Private __dPTAX //:= _dData 
Private __nTipo //:= _nTipo
Private __cTipo //:= IIF(_nTipo == 1, "VENDA" , IIF(_nTipo==10813,"Compra","Indeterminado") )
Private __nValor //:= 0
Private __cDia   //:= aSem[dow(::dPTAX)]
Private __cMensagem //:= "Objeto Iniciado"
Private __lNoDia  //:= .t.
Private __lStatus //:= .T.

DEFAULT _dData := date()
DEFAULT _NTIPO := 1 // VENDA

__lWsErro := .f.  //variavel para controle de erro, se .t. erro de operacao
__cWSErro := ""   // variavel com o log de erro caso __lWSErro seja .t.
__dData := _dData
__dPTAX := _dData 
__nTipo := _nTipo
__cTipo := IIF(_nTipo == 1, "VENDA" , IIF(_nTipo==10813,"Compra","Indeterminado") )
__nValor := 0
__cDia   := aSem[dow(__dPTAX)]
__cMensagem := "Objeto Iniciado"
__lNoDia  := .t.
__lStatus := .T.

//cURL := "https://www3.bcb.gov.br/sgspub/JSP/sgsgeral/FachadaWSSGS.wsdl"
cURL := "https://www3.bcb.gov.br/wssgs/services/FachadaWSSGS?method=getValor&codigoSerie=#MOEDA#&data=#DATA#"

cSoapAction := ""
 
oRet := GETSEFAZ(__dPtax,__nTipo)
     
While !UPPER(VALTYPE(oRet)) == "O" .and. nProc < 7
	nProc++ 
	__dPTAX := __dPTAX - 1
	oRet := GETSEFAZ(__dPtax,__nTipo)
EndDo
  
Do Case
	Case nProc == 7
		__nValor    := 0
        __cDia      := aSem[dow(__dPTAX)]
        __cMensagem := "Processado inversao de data com mais de 7 niveis"
        __lNoDia    := .f.
        __lStatus   := .f.

	case UPPER(VALTYPE(oRet)) == "O"
        __nValor    := val(oRet:_MULTIREF:TEXT)
        __cDia      := aSem[dow(__dPTAX)]
        __cMensagem := "Processado em "+DTOC(DATE())+" PTAX DE "+DTOC(__dPTAX)+" | "+__cTipo
        __lNoDia    := iif(__dData == __dPTAX,.t.,.f.)
        __lStatus   := .t.
      
	case __lWsErro 
       __nValor    := 0
       __cDia      := aSem[dow(__dPTAX)]
       __cMensagem := "Falha |"+__cWSErro
       __lNoDia    := .f.
       __lStatus   := .f.
      
	otherwise
        __nValor    := 0
        __cDia      := aSem[dow(__dPTAX)]
        __cMensagem := "Falha inesperada |Abra um chamado para equipe de sistemas."
        __lNoDia    := .f.
        __lStatus   := .f.

endcase 
   
::dData := __dData          
::dPTAX := __dPTAX
::nValor    := IIF(TYPE("oRet:_MULTIREF:TEXT")=="U",0,val(oRet:_MULTIREF:TEXT))
::cDia      := aSem[dow(__dPTAX)]
::cMensagem := "Processado em "+DTOC(DATE())+" PTAX DE "+DTOC(__dPTAX)+" | "+__cTipo
::lNoDia    := iif(__dData == __dPTAX,.t.,.f.)
::lStatus   := .t.

RETURN(self)

//===========================
method Finish() class wsbacen
::dData     := STOD("")
::dPTAX     := STOD("")
::nTipo     := 0
::cTipo     := ""
::nValor    := 0
::cDia      := ""
::cMensagem := ""  
::lStatus   := .F. 
return(self) 
                                                                      
*---------------------------------*
STATIC FUNCTION GETSEFAZ(_xx1,_xx2)
*---------------------------------*
// SOAP REQUEST RETIRADO DA FERRAMENTA SOAPUI
x1 := alltrim(str(int(_xx2)))
x2 := STRZERO(DAY(_xx1),2)+"/"+strzero(month(_xx1),2)+"/"+strzero(year(_xx1),4) 

oXml := ITFSvcSoapCall(cUrl, cSoapSend, cSoapAction, 2)

return(oXML)

*--------------------------------------------------------------------*
STATIC Function ITFSvcSoapCall(cUrl, cSoapSend, cSoapAction, DbgLevel)
*--------------------------------------------------------------------*
// variaveis para o request e reponse do post
Local XMLPostRet := ""
//Local nTimeOut	:= 120
//Local aHeadOut	:= {}
Local XMLHeadRet := ""
// variaveis para checar o header response
Local cHeaderRet := ""
Local nPosCType := 0
Local nPosCTEnd := 0
// variaveis para o parser XML
Local oXmlRet := NIL
Local cError := ""
Local cWarning := ""
// variaveis para retirar ENVELOPE e BODY
Local aTmp1 := {}
Local aTmp2 := {}
Local cEnvSoap := ""
Local cEnvBody := ""
Local cSoapPrefix := ""
// variaveis para determinar soapfault
Local cFaultString := ""
Local cFaultCode := ""

DEFAULT DbgLevel := 2

// REALIZANDO O POST
//XMLPostRet := HttpPost(cUrl,"",cSoapSend,nTimeOut,aHeadOut,@XMLHeadRet)
cUrl := StrTran(cUrl, "#MOEDA#", x1)
cUrl := StrTran(cUrl, "#DATA#" , x2)
XMLPostRet := HttpGet(cUrl)

// Verifica Retorno
If XMLPostRet == NIL
	//wserrolog("WSCERR044 / Não foi possível POST : URL " + cURL)
	return .f.
ElseIf Empty(XMLPostRet)
	If !empty(XMLHeadRet)
		//wserrolog("WSCERR045 / Retorno Vazio de POST : URL "+cURL+' ['+XMLHeadRet+']')
		return .f.
	Else
		//wserrolog("WSCERR045 / Retorno Vazio de POST : URL "+cURL)
		return .f.
	Endif
Endif

// Antes de Mandar o XML para o Parser , Verifica se o Content-Type é XML !
If !empty(XMLHeadRet)
	cHeaderRet := XMLHeadRet
	nPosCType := at("CONTENT-TYPE:",Upper(cHeaderRet))
	If nPosCType > 0
		cHeaderRet := substr(cHeaderRet,nPosCType)
		nPosCTEnd := at(CHR(13)+CHR(10) , cHeaderRet)
		cHeaderRet := substr(cHeaderRet,1,IIF(nPosCTEnd > 0 ,nPosCTEnd-1, NIL ) )
		If !"XML"$upper(cHeaderRet)
			//wserrolog("WSCERR064 / Invalid Content-Type return ("+cHeaderRet+") from "+cURL+CHR(13)+CHR(10)+" HEADER:["+XMLHeadRet+"] POST-RETURN:["+XMLPostRet+"]")
			return .f.
		Endif
	Else
		//wserrolog("WSCERR065 / EMPTY Content-Type return ("+cHeaderRet+") from "+cURL+CHR(13)+CHR(10)+" HEADER:["+XMLHeadRet+"] POST-RETURN:["+XMLPostRet+"]")
		return .f.
	Endif
Endif


// Passa pela XML Parser...
oXmlRet := XmlParser(XMLPostRet,'_',@cError,@cWarning)

If !empty(cWarning)
	//wserrolog('WSCERR046 / XML Warning '+cWarning+' ( POST em '+cURL+' )'+CHR(13)+CHR(10)+" HEADER:["+XMLHeadRet+"] POST-RETURN:["+XMLPostRet+"]")
	return .f.
ElseIf !empty(cError)
	//wserrolog('WSCERR047 / XML Error '+cError+' ( POST em '+cURL+' )'+CHR(13)+CHR(10)+" HEADER:["+XMLHeadRet+"] POST-RETURN:["+XMLPostRet+"]")
	return .f.
ElseIF oXmlRet = NIL
	//wserrolog('WSCERR073 / Build '+GETBUILD()+' XML Internal Error.'+CHR(13)+CHR(10)+" HEADER:["+XMLHeadRet+"] POST-RETURN:["+XMLPostRet+"]")
	return .f.
Endif

//--------------------------------------------------------
// Identifica os nodes inicias ENVELOPE e BODY Eles devem ser os primeiros niveis do XML
// RETIRA OS NODES E RETORNA APENAS OS DADOS
//--------------------------------------------------------
If Empty(aTmp1 := ClassDataArr(oXmlRet))
	aTmp1 := NIL
	//wserrolog('WSCERR056 / Invalid XML-Soap Server Response : soap-envelope not found.')
	return .f.
Endif

If empty(cEnvSoap := aTmp1[1][1])
	aTmp1 := NIL
	//wserrolog('WSCERR057 / Invalid XML-Soap Server Response : soap-envelope empty.')
	return .f.
Endif

// Limpa a variável temporária
aTmp1 := NIL

// ITFxGetInfo no lugar de xGetInfo é uma função da LIB de WEB SERVICES
// Elimina este node, re-atribuindo o Objeto
oXmlRet := ITFxGetInfo( oXmlRet, cEnvSoap  )

If valtype(oXmlRet) <> 'O'
	//wserrolog('WSCERR058 / Invalid XML-Soap Server Response : Invalid soap-envelope ['+cEnvSoap+'] object as valtype ['+valtype(oXmlRet)+']')
	return .f.
Endif

If Empty(aTmp2 := ClassDataArr(oXmlRet))
	aTmp2 := NIL
	//wserrolog('WSCERR059 / Invalid XML-Soap Server Response : soap-body not found.')
	return .f.
Endif

If empty(cEnvBody := aTmp2[1][1])
	aTmp2 := NIL
	//wserrolog('WSCERR060 / Invalid XML-Soap Server Response : soap-body envelope empty.')
	return .f.
Endif

// Limpa a variável temporária
aTmp2 := NIL

// Elimina este node, re-atribuindo o Objeto
oXmlRet := ITFxGetInfo( oXmlRet, cEnvBody )

If valtype(oXmlRet) <> 'O'
	//wserrolog('WSCERR061 / Invalid XML-Soap Server Response : Invalid soap-body ['+cEnvBody+'] object as valtype ['+valtype(oXmlRet)+']')
	return .f.
Endif

cSoapPrefix := substr(cEnvSoap,1,rat("_",cEnvSoap)-1)

If Empty(cSoapPrefix)
	//wserrolog('WSCERR062 / Invalid XML-Soap Server Response : Unable to determine Soap Prefix of Envelope ['+cEnvSoap+']')
	return .f.
Endif

// TRATAMENTO DO SOAP FAULT, CASO TENHA SIDO RETORNADO UM
If ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:TEXT" ) != NIL
	// Se achou um soap_fault....
	cFaultString := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTCODE:TEXT" )
	
	If !empty(cFaultString)
		// deve ser protocolo soap 1.0 ou 1.1
		cFaultCode := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTCODE:TEXT" )
		cFaultString := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTSTRING:TEXT" )
	Else
		// caso contrario, trato como soap 1.2
		cFaultCode := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTCODE:TEXT" )
		If Empty(cFaultCode)
			cFaultCode := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:"+cSoapPrefix+"_CODE:TEXT" )
		Else
			cFaultCode += " [FACTOR] " + ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTACTOR:TEXT" )
		EndIf
		DEFAULT cFaultCode := ""
		cFaultString := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_DETAIL:TEXT" )
		If !Empty(cFaultString)
			cFaultString := ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:_FAULTSTRING:TEXT" ) + " [DETAIL] " + cFaultString
		Else
			cFaultString :=  ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:"+cSoapPrefix+"_REASON:"+cSoapPrefix+"_TEXT:TEXT" )
			DEFAULT cFaultString := ""
			cFaultString += " [DETAIL] " + ITFxGetInfo( oXmlRet ,cSoapPrefix+"_FAULT:"+cSoapPrefix+"_DETAIL:TEXT" )
			DEFAULT cFaultString := ""
		Endif
	Endif
	
	// Aborta processamento atual com EXCEPTION
	//wserrolog('WSCERR048 / SOAP FAULT '+cFaultCode+' ( POST em '+cURL+' ) : ['+cFaultString+']')
	return .f.
	
Endif

//-----------------------------------------------------
// Passou por Tudo .. então retorna um XML parseado ...
//------------------------------------------------------

return oXmlRet

/* ----------------------------------------------------------------------------------
Funcao        ITFxGetInfo no lugar de xGetInfo
Parametros     oObj = Objeto XML
cObjCpoInfo = propriedade:xxx do objeto a retornar
Retorno        Conteudo solicitado. Caso não exista , retorna xDefault
Se xDefault não especificado , default = NIL
Exemplo        xGetInfo( oXml , '_SOAP_ENVELOPE:_SOAP_BODY:_NODE:TEXT' )
---------------------------------------------------------------------------------- */
*----------------------------------------------------------------------*
STATIC FUNCTION ITFxGetInfo( oXml ,cObjCpoInfo , xDefault , cNotNILMsg )
*----------------------------------------------------------------------*
Local bEval    := &('{ |x| x:' + cObjCpoInfo +' } ')
Local xRetInfo
Local bOldError := Errorblock({|e| Break(e) })

BEGIN SEQUENCE
xRetInfo := eval(bEval , oXml)
RECOVER
xRetInfo := NIL
END SEQUENCE

ErrorBlock(bOldError)

DEFAULT xRetInfo := xDefault

If xRetInfo == NIL .and. !empty(cNotNILMsg)
	__XMLSaveInfo := .T.
	//wserrolog("WSCERR041 / "+cNotNILMsg)
Endif

Return xRetInfo    

/*
===========================================================================================
funcao wserrolog(cTexto)
Faz o tratamento das excecoes, gravando no log do console e liberando as variaveis de ambiente
__lWsErro := .t. ou seja, com erro
__cWSErro := "Texto do erro"
*/
//*-------------------------------*
//Static function wserrolog(cParam)
//*-------------------------------*
//__lWsErro := .t.
//__cWSErro := alltrim(cParam) 
                 
return nil

/*
Funcao      : ValidaEmerg
Parametros  : Nenhum
Retorno     : Nenhum   
Objetivos   : Controle de Acesso ao Repositorio Emergencial
Autor     	: Jean Victor Rocha
Data     	: 14/01/2014
Obs         : 
*/
*----------------------------*
Static Function ValidaEmerg() 
*----------------------------*
Local lRet := .T.
     
Private cGet1 := Space(6)
//Se for Administrador não executa.
If FwIsAdmin()
	Return !lRet
EndIf

Return lRet                                                                               
           
