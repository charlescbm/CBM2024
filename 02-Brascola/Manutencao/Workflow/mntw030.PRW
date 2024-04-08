#INCLUDE "mntw030.ch"
#INCLUDE "RWMAKE.CH" 
#INCLUDE "PROTHEUS.CH"   
#INCLUDE "TOPCONN.CH"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ MNTW030  บAutor  ณ Ricardo Dal Ponte   บ Data ณ  11/12/06  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para enviar workflow de resumo de SS para o       บฑฑ
ฑฑบ          ณ executante da SS                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAMNT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Function MNTW030() 
Private cMailExec, cNmExec
Private oProcess := Nil, cArquivo := "MNTW030_01.htm"
Private cDir := Alltrim(GetMV("MV_WFDIR"))       
Private aRegistros := {}

private lAMBIE   := .F.
private cIniFile := GetAdv97()
private cCodEmp  := ""
private cCodFil  := ""   
Private cEmail := ""
Private cARQ1, aVETINR  := {}
	                    	
Processa({ || MNTW030TRB()})

DbSelectArea("TRB")
DbGotop()

If RecCount() <= 0
   //Deleta o arquivo temporario fisicamente 
   NGDELETRB("TRB",cARQ1)            
   return .f.
Endif

//Abre tabelas necessarias
If !(Type("oMainWnd")=="O")
	   
   lAMBIE  := .T.
   cCodEmp := GetPvProfString("ONSTART",STR0001,"",cInIfile) //"Empresa"
   cCodFil := GetPvProfString("ONSTART",STR0002 ,"",cInIfile) //"Filial"
	 
   conout(STR0001+": "+cCodEmp) //"Empresa"
   conout(STR0002+".: "+cCodFil) //"Filial"
   conout(" ") 
	         
   If cCodEmp == '-1' .Or. cCodFil == '-1'
      cEcho := MsgUserLog(STR0003,STR0004) //"Configura็ใo invalida de Filial"###"Verificar Empresa/Filial nos Jobs"
	   conout(cEcho)
	   Return .f.
   Endif
   
   RPCSetType(3)
	   
   //Abre empresa/filial/modulo/arquivos 
   RPCSetEnv(cCodEmp,cCodFil,"","","MNT","",{"ST9"})
	   
   //Faz a chamada da funcao para inciar o processo de exportacao dos dados
	conout(" ")
	conout(STR0005) //"Iniciando o Workflow"
	conout("=======================================================")
	conout(STR0006+":"+dtoc(MsDate())+" "+STR0007+": "+Time()) //"Data"###"Hora"
	Processa({ || MNTW030F()}) //WorkFlow
   conout("=======================================================")
Else
	Processa({ || MNTW030F()}) //WorkFlow
EndIf

//Deleta o arquivo temporario fisicamente 
NGDELETRB("TRB",cARQ1)            
Return  .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNTW030TRBบAutor  ณ Ricardo Dal Ponte  บ Data ณ  24/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ GERACAO DE ARQUIVO TEMPORARIO                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAMNT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Function MNTW030TRB()
Local aDBF, cIndR030

//criacao arquivo temporario
//----------------------------------------
//Numero SS / Data abertura / tipo servi็o / Solicitante e descri็ใo do servi็o.
aDBF := {{"SOLICI" ,"C",16,0},;
         {"ORDEM" ,"C",6,0},;
         {"DTABER" ,"D",8,0},;
         {"HRABER" ,"C",5,0},;
         {"CDSERV" ,"C",6,0},;
         {"NMSERV" ,"C",25,0},;
         {"CDSOLI" ,"C",06,0},;
         {"NMSOLI" ,"C",25,0},;
         {"RAMAL" ,"C",10,0},;
         {"CDRESP" ,"C",15,0},;
         {"CDEXEC" ,"C",15,0},;
         {"NMEXEC" ,"C",40,0},;
         {"PRIORI" ,"C",1,0},;
         {"DESPRI" ,"C",5,0},;
         {"EMAIL"  ,"C",50,0},;
         {"CODMSS" ,"C",06,0},;
         {"DESMSS" ,"M",80,0}}

cARQ1 := CriaTrab(aDBF)
dbUseArea(.T.,,cARQ1,"TRB",.f.)  
cIndR030 := CriaTrab(Nil, .F.)
            
IndRegua("TRB",cIndR030,"CDEXEC+PRIORI+CDSERV+SOLICI",,,STR0008) //"Selecionando Registros..."
                                                 
dbClearIndex()
dbSetIndex(cIndR030 + OrdBagExt())

DbSelectArea("TQB")
dbSetOrder(1)
Dbseek(xFilial("TQB"))

ProcRegua(RecCount())

While !Eof() .And. xFilial("TQB") = TQB->TQB_FILIAL
   
   IncProc()

	If TQB->TQB_SOLUCA == "D"
   	TRB->(DbAppend())
	
      TRB->ORDEM := TQB->TQB_ORDEM
      TRB->CDEXEC := TQB->TQB_CDEXEC
      TRB->NMEXEC := ""
      
      TRB->PRIORI := TQB->TQB_PRIORI
      TRB->RAMAL  := TQB->TQB_RAMAL 

      If TRB->PRIORI = "1"
         TRB->DESPRI := STR0009 //"Alta"
      ElseIf TRB->PRIORI = "2"
         TRB->DESPRI := STR0010 //"Media"
      ElseIf TRB->PRIORI = "3"
         TRB->DESPRI := STR0011 //"Baixa"
      EndIf

      TRB->SOLICI := TQB->TQB_SOLICI
      TRB->DTABER := TQB->TQB_DTABER
      TRB->HRABER := TQB->TQB_HOABER
      TRB->CDSERV := TQB->TQB_CDSERV
      //TRB->NMSERV := TQB->TQB_NMSERV
      TRB->CDSOLI := TQB->TQB_CDSOLI
      //TRB->NMSOLI := TQB->TQB_NMSOLI
      TRB->EMAIL := ""
      dbSelectArea("TQ3")                                             
      dbSetOrder(1)

   	Dbseek(xFilial("TQ3")+TQB->TQB_CDSERV)

      While !Eof() .And. xFilial("TQ3") = TQ3->TQ3_FILIAL .And. TQ3->TQ3_CDSERV = TQB->TQB_CDSERV
         TRB->CDRESP := TQ3->TQ3_CDRESP
        dbSkip()
      End
       
      TRB->CODMSS := TQB->TQB_CODMSS
      //TRB->DESMSS := TQB->TQB_DESMSS
   
   EndIf
   
   DbSelectArea("TQB")
	DbSkip()
End


//GRAVA DETALHES DO ARQUIVO TEMPORARIO
DbSelectArea("TRB")
DbGotop()

ProcRegua(LastRec())

While !Eof()
   IncProc()

	//LEITURA DO NOME DO SERVICO
	DbSelectArea("TQ3")
	DbSetOrder(01)

	If Dbseek(xFilial()+TRB->CDSERV)
      TRB->NMSERV := TQ3->TQ3_NMSERV
	EndIf
	
   aUser := {}   
	PswOrder(2)
	
	//LEITURA DO EMAIL DO EXECUTANTE
	DbSelectArea("TQ4")
	DbSetOrder(01)
   
   If dbSeek(xFilial("TQ4")+TRB->CDEXEC)
      TRB->EMAIL := Alltrim(TQ4->TQ4_EMAIL1)
      TRB->NMEXEC := TQ4->TQ4_NMEXEC
	Endif

   aUser := {}   
	PswOrder(1)
	//LEITURA DO NOME DO SOLICITANTE
   If PswSeek(TRB->CDSOLI)
	   cCodUser := PswRet(1)[1][1]

      cNMSOLI := Alltrim(SubStr(UsrRetName(cCodUser), 1, 40))
      nLen := 40-len(cNMSOLI)
      TRB->NMSOLI := cNMSOLI+Space(nLen)
   EndIf

	TRB->DESMSS := MSMM(TRB->CODMSS,80)

	DbSelectArea("TRB")
	DbSkip()
End

Return .t.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MNTW030F บAutor  ณ Ricardo Dal Ponte  บ Data ณ  24/11/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa para exportar dados para gerar workflow com       บฑฑ
ฑฑบ          ณ alerta de Ordem de servico atrasada.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAMNT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function MNTW030F()       
Local cExecutant, lPrimVez
Local lRetu := .T.

//Coloco a barra no final do parametro do diretorio
If Substr(cDir,Len(cDir),1) != "\"
	cDir += "\"
Endif

//Verifico se existe o arquivo de workflow
If !File(cDir+cArquivo)
	Msgstop(">>> "+STR0012+" "+cDir+cArquivo) //"Nao foi encontrado o arquivo"
	Return .F.
Endif
	
dbSelectArea("TRB")
dbSetOrder(1)
ProcRegua(LastRec())

lPrimVez := .T.

While !Eof() 
   IncProc()
   
   If lPrimVez = .T.
      cExecutant := TRB->CDEXEC
      lPrimVez = .F.
      aRegistros := {}
   Endif

   If cExecutant <> TRB->CDEXEC
      MNTW030ENV()
      aRegistros := {}
      dbSelectArea("TRB")
   EndIf
   
   cMailExec := Alltrim(TRB->EMAIL)
   cNmExec := Alltrim(TRB->NMEXEC)
      
   AADD(aRegistros,{STR0013,; //"Prioridade"
                     STR0014,; //"Servico"
                     STR0015,; //"Numero SS"
                     STR0016,; //"Dt. Abertura"
                     STR0007,; //"Hora"
                     STR0017,; //"Solicitante"
                     STR0018,; //"Ramal"
                     STR0019,; //"OS"
                     "   "+STR0020,; //"Solicita็ใo:"
	   				   TRB->DESPRI,;
					      TRB->NMSERV,;
	   				   TRB->SOLICI,;
		   			   TRB->DTABER,;
			   		   TRB->HRABER,;
					      TRB->NMSOLI,;
					      TRB->RAMAL,;
					      TRB->ORDEM,;
	          		   TRB->DESMSS})

   dbSelectArea("TRB")
   Dbskip()
End

If lPrimVez = .F.
   MNTW030ENV()
   aRegistros := {}
   dbSelectArea("TRB")
Endif

Return lRetu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMNTW030ENVบAutor  ณ Ricardo Dal Ponte  บ Data ณ  12/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email para executante da solicitacao de servico      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAMNT                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Function MNTW030ENV()       
Local i

//Inicio o processo
oProcess := Nil
oProcess := TWFProcess():New("INCPRO",STR0021) //"Rela็ใo de SS em Aberto"
oProcess:NewTask("100001",cDir+cArquivo)
oProcess:cSubject := dtoc(MsDate())+" - "+STR0021 //"Rela็ใo de SS em Aberto"
oProcess:UserSiga := "000000"
oProcess:oHtml:ValByName("CTITULO",STR0021) //"Rela็ใo de SS em Aberto"
oProcess:oHtml:ValByName("CEXECUTANTE",STR0022+": "+cNmExec) //"Executante"
cMailExec := u_BXFormatEmail(cMailExec)
oProcess:cTo := Alltrim(cMailExec)

If Len(aRegistros) = 0 
	Return .t.
EndIf
                                                              		
ProcRegua(Len(aRegistros))

For i := 1 to Len(aRegistros)
   IncProc()

   aadd(oProcess:oHtml:ValByName("it1.strDESPRI") , aRegistros[i,1])		
   aadd(oProcess:oHtml:ValByName("it1.strNMSERV") , aRegistros[i,2])		
   aadd(oProcess:oHtml:ValByName("it1.strSOLICI") , aRegistros[i,3])		
   aadd(oProcess:oHtml:ValByName("it1.strDTABER") , aRegistros[i,4])		
   aadd(oProcess:oHtml:ValByName("it1.strHRABER") , aRegistros[i,5])		
   aadd(oProcess:oHtml:ValByName("it1.strNMSOLI") , aRegistros[i,6])		
   aadd(oProcess:oHtml:ValByName("it1.strRAMAL")  , aRegistros[i,7])		
   aadd(oProcess:oHtml:ValByName("it1.strORDEM")  , aRegistros[i,8])		

   aadd(oProcess:oHtml:ValByName("it1.strDESMSS") , aRegistros[i,9])		

   aadd(oProcess:oHtml:ValByName("it1.strDESPRI1") , aRegistros[i,10])		
   aadd(oProcess:oHtml:ValByName("it1.strNMSERV1") , aRegistros[i,11])		
   aadd(oProcess:oHtml:ValByName("it1.strSOLICI1") , aRegistros[i,12])		
   aadd(oProcess:oHtml:ValByName("it1.strDTABER1") , aRegistros[i,13])		
   aadd(oProcess:oHtml:ValByName("it1.strHRABER1") , aRegistros[i,14])		
   aadd(oProcess:oHtml:ValByName("it1.strNMSOLI1") , aRegistros[i,15])		
   aadd(oProcess:oHtml:ValByName("it1.strRAMAL1")  , aRegistros[i,16])		
   aadd(oProcess:oHtml:ValByName("it1.strORDEM1")  , aRegistros[i,17])		

	aadd(oProcess:oHtml:ValByName("it1.strDESMSS1") , aRegistros[i,18])
Next

IF oProcess:cTo <> ""
   oProcess:Start()
   oProcess:Finish()
   //MsgInfo(STR0023+": "+oProcess:cTo+"!") //"Aviso de Inclusใo de SS enviado para"
Endif
Return .T.