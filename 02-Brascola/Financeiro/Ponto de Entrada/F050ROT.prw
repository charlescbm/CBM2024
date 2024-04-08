#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ F050ROT  บAutor  ณ Marcelo da Cunha   บ Data ณ  29/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Adicionar botao de Rastreamento de Contabilidade CP        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F050ROT()
*********************
LOCAL aButtons := aClone(paramixb)
aadd(aButtons,{"Rastr.contabil","u_BF050CtbCP()",0,4})
Return aButtons

User Function BF050CtbCP()
***********************
PRIVATE cQuery := "", cVarQ := "", oDlgCtb, oListBox, aContab := {}
                  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Procuro lancamentos no CV3 pelo Titulo SE2                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery := "SELECT CV3_TABORI MTABORI,CV3.R_E_C_N_O_ MRECNO FROM "+RetSqlName("CV3")+" CV3 "
cQuery += "WHERE CV3.D_E_L_E_T_ = '' AND CV3_FILIAL = '"+xFilial("CV3")+"' "
cQuery += "AND CV3_TABORI = 'SE2' AND CV3_RECORI = "+Alltrim(Str(SE2->(Recno())))+" "
cQuery += " UNION "
cQuery += "SELECT CV3_TABORI MTABORI,CV3.R_E_C_N_O_ MRECNO FROM "+RetSqlName("CV3")+" CV3,"+RetSqlName("SEA")+" SEA "
cQuery += "WHERE CV3.D_E_L_E_T_ = '' AND CV3_FILIAL = '"+xFilial("CV3")+"' AND SEA.D_E_L_E_T_ = '' AND EA_FILIAL = '"+xFilial("SEA")+"' "
cQuery += "AND CV3_TABORI = 'SEA' AND CV3_RECORI = SEA.R_E_C_N_O_ AND EA_CART = 'P' AND EA_PREFIXO = '"+SE2->E2_prefixo+"' AND EA_NUM = '"+SE2->E2_num+"' "
cQuery += "AND EA_PARCELA ='"+SE2->E2_parcela+"' AND EA_TIPO = '"+SE2->E2_tipo+"' AND EA_FORNECE = '"+SE2->E2_fornece+"' AND EA_LOJA = '"+SE2->E2_loja+"' "
cQuery += " UNION "
cQuery += "SELECT CV3_TABORI MTABORI,CV3.R_E_C_N_O_ MRECNO FROM "+RetSqlName("CV3")+" CV3,"+RetSqlName("SE5")+" SE5 "
cQuery += "WHERE CV3.D_E_L_E_T_ = '' AND CV3_FILIAL = '"+xFilial("CV3")+"' AND SE5.D_E_L_E_T_ = '' AND E5_FILIAL = '"+xFilial("SE5")+"' "
cQuery += "AND CV3_TABORI = 'SE5' AND CV3_RECORI = SE5.R_E_C_N_O_ AND E5_RECPAG = 'P' AND E5_PREFIXO = '"+SE2->E2_prefixo+"' AND E5_NUMERO = '"+SE2->E2_num+"' "
cQuery += "AND E5_PARCELA ='"+SE2->E2_parcela+"' AND E5_TIPO = '"+SE2->E2_tipo+"' AND E5_FORNECE = '"+SE2->E2_fornece+"' AND E5_LOJA = '"+SE2->E2_loja+"' "
cQuery += "ORDER BY MTABORI,MRECNO "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
CV3->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())
	CV3->(dbGoto(MAR->MRECNO))
	If !Empty(CV3->CV3_recdes)
		aadd(aContab,{MAR->MTABORI,CV3->CV3_dtseq,CV3->CV3_vlr01,CV3->CV3_hist,CV3->CV3_lp+"/"+CV3->CV3_lpseq,CV3->CV3_recdes})
	Endif
	MAR->(dbSkip())
Enddo
If (Len(aContab) == 0)
	Help("",1,"BRASCOLA",,OemToAnsi("Nao foram encontrados registros relacionados ao titulo."),1,0) 
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monto tela para mostrar lancamentos relacionados ao SE2     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlgCtb TITLE OemToAnsi("Lancamento Contabeis Relacionados ao Registro:") FROM 0,0 TO 400,800 OF GetWndDefault() PIXEL
@ 005,005 LISTBOX oListBox VAR cVarQ FIELDS HEADER "Tipo","Data","Valor","Historico","LP","Registro" SIZE 390,160 NOSCROLL PIXEL
oListBox:SetArray(aContab) 
oListBox:bLine:={ || {aContab[oListBox:nAt,1],aContab[oListBox:nAt,2],aContab[oListBox:nAt,3],aContab[oListBox:nAt,4],aContab[oListBox:nAt,5],aContab[oListBox:nAt,6]}}
@ 175,010 BUTTON "Rastrear" ACTION BF050AbrirLC() SIZE 040,012 PIXEL
@ 175,050 BUTTON "Fechar" ACTION oDlgCtb:End() SIZE 040,012 PIXEL
ACTIVATE MSDIALOG oDlgCtb CENTERED
      
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

Static Function BF050AbrirLC()
***************************
PRIVATE lCt102Auto := .F., aAutoCab := {}, aAutoItens := {}, dDataLanc, cDoc, cLote
PRIVATE __lCusto := .F., __lItem := .F., __lCLVL := .F., aCtbEntid
PRIVATE cLoteSub := GetMv("MV_SUBLOTE")
PRIVATE cSubLote := cLoteSub
PRIVATE lSubLote := Empty(cSubLote)
If (oListBox:nAt > 0).and.!Empty(aContab[oListBox:nAt,6])
	dbSelectArea("CT2")                                  
	CT2->(dbSetOrder(1))
	CT2->(dbGoto(Val(aContab[oListBox:nAt,6])))
	Ctba102Cal("CT2",CT2->(Recno()),2)                
Endif
Return