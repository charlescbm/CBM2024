#include 'protheus.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                   		!
+-------------------------------------------------------------------------------+
!Programa			! UINOV010 - Gerar string - INOVEN	! 
+-------------------+-----------------------------------------------------------+
!Descricao			! Rotina para gerar string em FTP							!
+-------------------+-----------------------------------------------------------+
!Autor         		! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 30/09/2022							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UINOV010( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Gerar string FTP - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
//U_GOTEC010()
U_WGOPAINEL()

RpcClearEnv()

Return

User Function GOTEC010()

//User Function zFTPEnv(cEndereco, nPorta, cUsr, cPass, cArq)
    Local aArea   := GetArea()
    //Local lRet    := .T.
    //Local cDirAbs := GetSrvProfString("STARTPATH","")  
    Local cDirAbs := "" //GetSrvProfString("ROOTPATH","")  
    
	cDirAbs += "\jsonftp"
	//if !file(cDirAbs)
	//	makedir(cDirAbs)
	//endif

	//temporario local
	cPatchRel:= "C:\temp\jsonftp"
	If !ExistDir(cPatchRel)
		MakeDir(cPatchRel)
	EndIf	

	cArq	:= 'stringteste.json'
	cDirAbs	+= "\" + cArq

	if !file(cDirAbs)
		return
	endif
	alert(cPatchRel + '\'+ cArq)
	//nStatus1 := frenameEx(cDirAbs , cPatchRel + '\'+ cArq )
	//alert(nStatus1)
	lRet := __CopyFile( cDirAbs, cPatchRel + '\'+ cArq,,,.F.)
	alert(lRet)

	cEndereco 	:= "ftp.byethost17.com"
	nPorta		:= 21
	cUsrFtp		:= "b17_32699979" 
	cPassFTP	:= "lecrek202209"
     
    //Se conseguir conectar
    If FTPConnect(cEndereco ,nPorta ,cUsrFtp , cPassFTP )
         
        //Desativa o firewall
        FTPSetPasv(.F.)        
        

		If FTPDirChange("/htdocs/")
			alert(FTPGetCurDir())
			
			cPatchRel:= "C:/temp/jsonftp"
			alert(file(cPatchRel + '/'+ cArq))

			//Se não conseguir dar o upload
			//If !FTPUpload(cDirAbs, "/htdocs/"+cArq)
			If !FTPUpload(cPatchRel + '/'+ cArq, '/htdocs/'+cArq)
			
				//Realiza mais uma tentativa
				If !FTPUpload(cPatchRel + '/'+ cArq, '/htdocs/'+cArq)
					MsgStop("Falha ao copiar o arquivo para o FTP!", "Atenção")
					lRet:=.F.
				EndIf
			else
					alert("foi...")
			EndIf
		Else
            MsgStop("Não foi possível mudar o diretório de Upload!", "Atenção")
		endif

        //Desconecta do FTP
        FTPDisconnect()
    Else
            MsgStop("Erro de conexão!", "Atenção")
	EndIf
	
    RestArea(aArea)
Return

