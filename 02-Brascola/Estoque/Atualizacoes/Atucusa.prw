#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function Atucusa()
************************
// Declaracao de Variaveis
Local cDesc1         := ""
Local cDesc2         := ""
Local cDesc3         := ""
Local cPict          := ""
Local nLin        	 := 60
Local imprime      	 := .T.
Local aOrd 			 := {}
Private titulo    	 := "Atualiza"
Private Cabec1       := ""  
Private Cabec2       := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private tamanho      := "P"
Private limite       := 80
Private nomeprog     := "ATUSB1MRP"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MTR430" //"ATUSTD"
Private cString      := "SB1"
Private nContAx      := 1
Private aArray       := {} ,cCondFiltr,lRet
Private li           := 99
Private cProg        :="R430"
Private lDirecao     := .T.

	
If nLastKey == 27
   Return
Endif


Processa({|| Atu_SB1() })

Set Device to Screen

If aReturn[5]==1
   dbCommitAll()
   Set Printer To
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function Atu_SB1()
*************************
Local _nTotRegs:=0
aStru := {}
AADD(aStru,{ "B1_COD"  , "C", 15, 0})
//AADD(aStru,{ "B1_QE"   , "N", 12, 0})
//AADD(aStru,{ "B1_TIPE" , "C", 01, 0})
//AADD(aStru,{ "B1_LM"   , "N", 12, 2})
AADD(aStru,{ "B1_CUSTDM" , "N", 12, 2})
cArqTrab := CriaTrab(aStru, .T.)
Use &cArqTrab new Exclusive alias TRB
//DbSelectArea("TRB")
//Dbgotop()

cArqMRP:= "ESTA.DBF"
dbUseArea(.T.,"DBFCDXADS",cArqMRP,"SEG",.F.)
//cArqMRP:= "G:\PROTHEUS_DATA\DBF_MRP\MRP0207.DBF"
  
//use est via "DBFCDX" NEW


//Append from &cArqMRP sdf
DBSELECTAREA("SEG")	
Dbgotop()

While !Eof() 
	IncProc("Processando...  "+SEG->_COD)
	
	DbSelectArea("SB1")
    DbSetOrder(1)
    MsSeek(xFilial("SB1")+SEG->_COD)
    If Found()
		Begin Transaction
		
		RecLock("SB1",.F.)
		SB1->B1_CUSTDM  := SEG->CUSAQ
		MsUnlock()
		
		End Transaction
   	    _nTotRegs+=1
	EndIf
	
	DbSelectArea("SEG")
	DbSkip()
EndDo
Alert("Alteracao Finalizada - total registros: " +STR(_nTotRegs))
//MsgBox("Atualização concluida!")

DbSelectArea("SEG")
DbCloseArea()


Return