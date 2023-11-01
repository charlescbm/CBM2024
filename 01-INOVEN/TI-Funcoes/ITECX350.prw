#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX350													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Automação Leitura FTP para GFE					 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 31/01/2023												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX350( aParams )

Local _x

Default aParams := {"01","0102"}

/*RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SF2","SE1"})
FwLogMsg("INFO",, "INOVLOG", FunName(), "", "01", "Relação de notas - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC300()

RpcClearEnv()

Return

User Function WFTEC300()*/
/*
  oFTPHandle := tFtpClient():New()	//cria uma instancia
  //nRet := oFTPHandle:FTPConnect("38.242.209.101",,"lnrtransportes@inoventi","#tr@nsLNR@2023")	//cria conexão
  //nRet := oFTPHandle:FTPConnect("38.242.209.101",,"charles@inoventi","nIaxcNJQVFkh")	//cria conexão
  nRet := oFTPHandle:FTPConnect("207.244.249.80",,"charles2","123456")	//cria conexão
  //master
  //nRet := oFTPHandle:FTPConnect("38.242.209.101",,"inoventi","1mhT0y22FTP")	//cria conexão
  sRet := oFTPHandle:GetLastResponse()
  alert( sRet )
   
  If (nRet != 0)
    alert( "Falha ao conectar" )
    Return .F.
  EndIf

  //oFTPHandle:bFireWallMode := .t.
  //sRet := oFTPHandle:GetLastResponse()
  //alert( sRet )

	//....


  //aCTE := oFTPHandle:Directory("*.xml", .T.)
  aCTE := oFTPHandle:Directory("*",.t.)
  sRet := oFTPHandle:GetLastResponse()
  alert(sRet)
  //for _x := 1 to len(aCTE)
//	alert(aCTE[_x][1] + ' - ' + aCTE[_x][5])
  //next
  alert(len(aCTE))

  //cria diretorio auxiliar
  //nRet := oFTPHandle:MkDir("copiado")
  //varinfo("Mkdir ret",nRet)
  //sRet := oFTPHandle:GetLastResponse()

  //Diretorio de DESTINO dos CTE´s no Protheus GFE
  //cDirXML := GFEA118Bar(AllTrim(SuperGetMv("MV_XMLDIR", .F., "")))
  //alert(cDirXML)

  oFTPHandle:Close()	//fecha conexao
  sRet := oFTPHandle:GetLastResponse()
  alert(sRet)
	
*/

FTPCONNECT( "38.242.209.101" , 21 ,"lnrtransportes@inoventi", "#tr@nsLNR@2023" )
aRetDir := FTPDIRECTORY( "*.*" , ) 
alert(len(aRetDir))
FTPDISCONNECT()
Return

/*Static Function GFEA118Bar(cDir)

	Local cBarra := If(isSrvUnix(),"/","\")

	If SubStr(cDir, Len(cDir), 1) != '/' .And. SubStr(cDir, Len(cDir), 1) != '\'
		cDir += cBarra
	EndIf
return cDir*/
