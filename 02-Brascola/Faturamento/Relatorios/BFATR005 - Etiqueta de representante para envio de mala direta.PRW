#Include "rwmake.ch"
#Include "topconn.ch"        

/*/
----------------------------------------------------------------------------
PROGRAMA: BFATR005         AUTOR:                        DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Gera e imprime etiqueta para envio de mala direta.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BFATR005()    
*************************
Private oDlg1
Private vSair    := .f.
Private cRepresDe:= Space(06)
Private cRepresAt:= "ZZZZZZ"
Private cGerentDe:= Space(06)
Private cGerentAt:= "ZZZZZZ"
Private cSupervDe:= Space(06)
Private cSupervAt:= "ZZZZZZ"
Private cEstadoDe:= Space(02)
Private cEstadoAt:= "ZZ"
Private cComboCal:= "Não" 
Private aItemsCal:= {"Sim","Não","Todos"}
Private cComboBlq:= "Não" 
Private aItemsBlq:= {"Sim","Não","Todos"}

While !vSair
   @ 003,001 To 345,228 Dialog oDlg1 Title "Etiqueta de Representantes"
   @ 010,004 To 150,113
   @ 020  ,008 Say "Representante De :"
   @ 020.1,070 Get cRepresDe    F3 "SA3"   Size 025,20  Picture "@R XXXXXX"   
   @ 030  ,008 Say "Representante Ate:"
   @ 030.1,070 Get cRepresAt    F3 "SA3"   Size 025,20  Picture "@R XXXXXX"   
   @ 045  ,008 Say "Gerente De :"
   @ 045.1,070 Get cGerentDe    F3 "SA3"   Size 025,20  Picture "@R XXXXXX"   
   @ 055  ,008 Say "Gerente Ate:"
   @ 055.1,070 Get cGerentAt    F3 "SA3"   Size 025,20  Picture "@R XXXXXX"   
   @ 070  ,008 Say "Supervisor De :"
   @ 070.1,070 Get cSupervDe    F3 "SA3"   Size 025,20  Picture "@R XXXXXX"   
   @ 080  ,008 Say "Supervisor Ate:"
   @ 080.1,070 Get cSupervAt    F3 "SA3"   Size 025,20  Picture "@R XXXXXX"   
   @ 095  ,008 Say "Estado De :"
   @ 095.1,070 Get cEstadoDe    F3 "12"    Size 025,20  Picture "@R XX"   
   @ 105  ,008 Say "Estado Ate:"
   @ 105.1,070 Get cEstadoAt    F3 "12"    Size 025,20  Picture "@R XX"   
   @ 120  ,008 Say "Call Center?"
   @ 120.1,070 ComboBox cComboCal   Items aItemsCal     Size 025,15
   @ 135  ,008 Say "Bloqueado?"
   @ 135.1,070 ComboBox cComboBlq   Items aItemsBlq     Size 025,15
   @ 155,045 Button "_Imprimir"            Size 030,13 Action ImpEtiq()
   @ 155,080 Button "_Sair"                Size 030,13 Action Sair()
   Activate Dialog oDlg1 Centered
EndDo

Return



Static Function ImpEtiq()
*************************
Private aDados  := {}
Private cQuery  := ""
Private cPorta  := "LPT1"
Private nLin    := 0

cQuery := "SELECT A3_COD, A3_NOME, A3_END, A3_BAIRRO, A3_MUN, A3_EST, A3_CEP, A3_NREDUZ " 
cQuery += " FROM "+RetSQLName("SA3") 
cQuery += " WHERE A3_COD BETWEEN '"+cRepresDe+"' AND '"+cRepresAt+"' " 
cQuery += "   AND A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAt+"' " 
cQuery += "   AND A3_GEREN BETWEEN '"+cGerentDe+"' AND '"+cGerentAt+"' "
cQuery += "   AND A3_EST BETWEEN '"+cEstadoDe+"' AND '"+cEstadoAt+"' "
If SubStr(cComboBlq,1,1)=="S"
	cQuery += "   AND A3_BLQ = 'S' " 
ElseIf SubStr(cComboBlq,1,1)=="N"
	cQuery += "   AND A3_BLQ <> 'S' " 
EndIf
If SubStr(cComboCal,1,1)=="S"
	cQuery += "   AND A3_GRPREP == '000200' " 
ElseIf SubStr(cComboCal,1,1)=="N"
	cQuery += "   AND A3_GRPREP <> '000200' " 
EndIf
cQuery += "   AND D_E_L_E_T_ = '' " 
cQuery += " ORDER BY A3_COD " 
If Select("TRB")>0
	TRB->(dbCloseArea())
EndIf
TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
dbGoTop()

//MSCBPRINTER("S500-8",cPorta,,,.f.,,,,) 
MSCBPRINTER("S500-6",cPorta,Nil,040,.f.,,,,)
MSCBCHKStatus(.F.)    

While !Eof()
	MSCBBEGIN(1,4) 
	
	nLin:= 10
	MSCBSAY(06,nLin, TRB->A3_NOME ,"N","C","19,23")
	nLin+= 10
	MSCBSAY(06,nLin, TRB->A3_END ,"N","C","18,18")
	nLin+= 5
	MSCBSAY(06,nLin, TRB->A3_BAIRRO,"N","C","18,18")
	nLin+= 5
	MSCBSAY(06,nLin, AllTrim(TRB->A3_MUN)+" - "+Alltrim(A3_EST) ,"N","C","18,18")
	nLin+= 5
	MSCBSAY(06,nLin, "CEP: "+AllTrim(TRB->A3_CEP),"N","C","18,18")
	nLin+= 10
	MSCBSAY(06,nLin, TRB->A3_NREDUZ,"N","C","18,18")
	
	MSCBEND()

	DbSkip()
EndDo

MSCBCLOSEPRINTER() 
dbCloseArea()

Sair()

Return 	    



Static Function Sair()
********************
Close(oDlg1)
vSair := .t.

Return