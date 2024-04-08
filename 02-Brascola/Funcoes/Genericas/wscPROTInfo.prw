#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://sistema.brascola.com.br:8085/ws/wsprotinfo.apw?WSDL
Gerado em        08/19/13 14:18:26
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _QIWKZUU ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSPROTINFO
------------------------------------------------------------------------------- */

WSCLIENT WSWSPROTINFO

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD PROTSEARCH

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cPROT                     AS string
	WSDATA   cPROTSEARCHRESULT         AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSPROTINFO
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20130625] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSPROTINFO
Return

WSMETHOD RESET WSCLIENT WSWSPROTINFO
	::cPROT              := NIL 
	::cPROTSEARCHRESULT  := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSPROTINFO
Local oClone := WSWSPROTINFO():New()
	oClone:_URL          := ::_URL 
	oClone:cPROT         := ::cPROT
	oClone:cPROTSEARCHRESULT := ::cPROTSEARCHRESULT
Return oClone

// WSDL Method PROTSEARCH of Service WSWSPROTINFO

WSMETHOD PROTSEARCH WSSEND cPROT WSRECEIVE cPROTSEARCHRESULT WSCLIENT WSWSPROTINFO
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<PROTSEARCH xmlns="http://sistema.brascola.com.br:8085/ws/wsprotinfo.apw">'
cSoap += WSSoapValue("PROT", ::cPROT, cPROT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</PROTSEARCH>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://sistema.brascola.com.br:8085/ws/wsprotinfo.apw/PROTSEARCH",; 
	"DOCUMENT","http://sistema.brascola.com.br:8085/ws/wsprotinfo.apw",,"1.031217",; 
	"http://sistema.brascola.com.br:8085/ws/WSPROTINFO.apw")

::Init()
::cPROTSEARCHRESULT  :=  WSAdvValue( oXmlRet,"_PROTSEARCHRESPONSE:_PROTSEARCHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



