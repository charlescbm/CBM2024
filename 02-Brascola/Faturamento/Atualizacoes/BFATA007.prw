#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"        
#INCLUDE "TbiConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BFATA007   ºAutor  ³Fernando           º Data ³  26/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza Campo de Conferencia no SF2010                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Brascola                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function BFATA007()
Private _cQuery  := ""   
Private cPerg    := "BFATA007"
Private aRegs    := {}  
Private cNotaDe  :=  ""
Private cNotaAte :=  ""  
Private cConfere :=  ""

U_BCFGA002("BFATA007")//Grava detalhes da rotina usada

aAdd(aRegs,{cPerg,"01" ,"Nota Fiscal De? "  ,"","","mv_ch1","C" ,9      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SF2",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"02" ,"Nota Fiscal Ate?"  ,"","","mv_ch2","C" ,9      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SF2",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"03" ,"Conferido?"  ,"","","mv_ch3","N" ,1      ,0      ,0     ,"C",""   ,"mv_par03","1-Sim"           ,"","" ,""   ,""   ,"2-Nao"         ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,"","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03", "Conferido?      "  ,"","","mv_ch3","N" ,1      ,0      ,0     ,"C",""   ,"mv_par03","1-Sim"           ,"","" ,""   ,""   ,"2-Nao"         ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,"","","","","","","","","","",""}) 
ValidPerg(aRegs,cPerg,.F.)

If !Pergunte(cPerg,.T.)
	Return
Endif

cNotaDe := AllTrim(mv_par01)  
cNotaAte:= AllTrim(mv_par02)    
cConfere:= AllTrim(Str(mv_par03))
               
cAlias:= GetNextAlias()

BeginSql alias cAlias
	SELECT F2_DOC
	FROM %table:SF2% F2
	WHERE F2_FILIAL  = %xfilial:SF2% 
	AND F2.%notDel%
    AND F2_DOC BETWEEN %exp:AllTrim(cNotaDe)%  AND %exp:AllTrim(cNotaAte)%
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos

dbSelectArea(cAlias)
dbGotop()

aNotas:= {} 

While (cAlias)->(!Eof())
	aADD(aNotas,AllTrim((cAlias)->F2_DOC))//adiciona no array todos os pedidos localizados
	DbSkip()
End

cNotas:= chr(13)+chr(10)

For i:= 1 to len(aNotas)
	cNotas+= aNotas[i]+chr(13)+chr(10)  //alimenta a variavel com todos os Pedidfmaiaos pesquisados
Next i

//cNotas:= Substr(cNotas,1,len(cNotas)-1) //tira a ultima virgula no final da string

If MsgYesNo("Confirma Atualização das Notas abaixo?"+cNotas)
	_cQuery := "UPDATE SF2010 SET  F2_CONFERE = '" + cConfere + "' "
	_cQuery += " WHERE F2_FILIAL = '" +xFilial("SF2")+ "' AND D_E_L_E_T_ <> '*' "
	_cQuery += " AND F2_DOC BETWEEN " + cNotaDe  + " AND " + cNotaAte + " "
	_cQuery += " AND F2_CONFERE = '' AND F2_CONFERE <> '1'"  
	
	nRet:=TcSqlExec(_cQuery) 
	
	If nRet == 0
		//Aviso("Conferencia de Notas Fiscais","Notas Fiscais "+cNotas+ "Atualizadas.",{"&Ok"},,"Usuário : "+AllTrim(cUserName))
	    //MsgAlert("Notas abaixo atualizadas:"+cNotas) 
	    MsgAlert("Notas atualizadas com sucesso!")
	Else
	    MsgAlert("Erro na atualização")
	EndIf
Endif
           
Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
//          Grupo/Ordem/Pergunta/                              Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture/IDFil
aAdd(aRegs,{cPerg,"01" ,"Nota Fiscal De? "  ,"","","mv_ch1","C" ,9      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SF2",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"02" ,"Nota Fiscal Ate?"  ,"","","mv_ch2","C" ,9      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SF2",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"03" ,"Conferido?      "  ,"","","mv_ch3","N" ,1      ,0      ,0     ,"C",""   ,"mv_par03","1-Sim"           ,"","" ,""   ,""   ,"2-Nao"         ,"","" ,""   ,""   ,""                 ,"","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return