#INCLUDE "APWEBSRV.CH"
 
#INCLUDE "PROTHEUS.CH"
 
WSSERVICE WSADVPLBRASIL DESCRIPTION "Servi�o com a finalidade de mostrar um exemplo de webservice"
 
WSDATA cString as String
 
WSMETHOD RetornaUrl DESCRIPTION "M�todo que retorna a url do site"
 
ENDWSSERVICE
 
WSMETHOD RetornaUrl WSRECEIVE NULLPARAM WSSEND cString WSSERVICE WSADVPLBRASIL
 
::cString := "http://advplbrasil.com.br/"
 
Return .T.
