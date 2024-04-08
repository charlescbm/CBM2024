#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE STR0001 "Servico de Consulta Protocolo NFE-Sefaz"
#DEFINE STR0002 "Método para pesquisa do Protocolo

/*/
	WSSERVICE:	wsProtInfo
	Autor:		Fernando Maia
	Data:		19/08/13
	Descri‡…o:	Servico de Consulta ao Codigo do Protocolo NFE Sefaz
	Uso:		Consulta ao Protocolo (Codigo de Confirmação Sefaz)
/*/                                                                       
                                     

WSSERVICE wsProtInfo DESCRIPTION STR0001 NAMESPACE "http://sistema.brascola.com.br:8085/ws/wsprotinfo.apw" 

	WSDATA PROT				As String
	WSDATA XML				As String

	WSMETHOD PROTSearch		DESCRIPTION STR0002 //"Método para pesquisa do PROTOCOLO"

ENDWSSERVICE

/*/
	WSMETHOD:	PROTSearch
	Autor:		Fernando Maia
	Data:		19/08/2013
	Uso:		Consulta de Protocolo
	Obs.:		Metodo Para a Pesquisa do Protocolo
	Retorna:	XML com a Consulta do Protocolo
	
/*/
WSMETHOD PROTSearch WSRECEIVE PROT WSSEND XML WSSERVICE wsPROTInfo

	Local cUrl		:= ""
	Local lWsReturn	:= .T.

	DEFAULT PROT		:= Self:PROT
    //cUrl			:= "http://cep.republicavirtual.com.br/web_cep.php?cep="+StrTran(CEP,"-","")+"&formato=xml"
	cUrl			:= "http://sistema.brascola.com.br:8085/ws/NFeSBRA.apw" //PadR(GetNewPar("MV_SPEDURL","http://"),250)  //MV_SPEDURL:http://192.168.1.39:8080  
	Self:XML		:= HttpGet( cUrl )
	XML				:= Self:XML

Return( lWsReturn )