#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: BFATR004         AUTOR:                        DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Gera relatorio de tabela de preços exportação e envia html por
email.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BFATR004()
*************************
Local aAreaAtu	   := GetArea()
Local cCadastro	   := OemToAnsi("Tabela de Preços Exportação")
Local nProcessa	   := 3
Local lJob		   := .t.
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio do Comissões"
Local cPict        := ""
Local titulo       := "Tabela de Preços Exportação"
Local nLin         := 99
Local imprime      := .T.
Local aOrd         := {}
Local Cabec1       := ""
Local Cabec2       := ""

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "RTABPRCEX" 
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := U_CriaPerg("RTABPRCE")
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RTABPRCEX" 
Private nResul     := 0
Private nTotalMedia:= 0
Private cString    := "DA0"

ValPergunte(cPerg)

Pergunte(cPerg,.T.)

RptStatus({|| U_PTabPEx() },Titulo)

RestArea(aAreaAtu)

Return(Nil)



User Function PTabPEx()
**************************
Local cQuery  := cQuerD  := ""           
Local _cBody  := ""
Local cAssunto:= ""
Local cEmailAx:= ""

cQuerD:= "SELECT B1_GRUPO AS FAMILIA, "
cQuerD+= "       BM_DESC AS DESCFAM,  "
cQuerD+= "       DA1_CODPRO AS CODIGO, "
cQuerD+= "       B1_DESC AS DESCRI, "
cQuerD+= "       SUM(DA1_PRCVEN) AS VALOR "
cQuerD+= "FROM " + RetSqlName("DA0") + " DA0, "+ RetSqlName("DA1") + " DA1, "+ RetSqlName("SB1") + " SB1, "+ RetSqlName("SBM") + " SBM "
cQuerD+= "WHERE DA0.D_E_L_E_T_='' "
cQuerD+= "  AND DA1.D_E_L_E_T_='' "
cQuerD+= "  AND SB1.D_E_L_E_T_='' "
cQuerD+= "  AND SBM.D_E_L_E_T_='' "
cQuerD+= "  AND DA0_CODTAB = '"+mv_par03+"' "
cQuerD+= "  AND DA1_CODTAB=DA0_CODTAB "
cQuerD+= "  AND DA1_CODPRO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuerD+= "  AND DA1_CODPRO=B1_COD "
//cQuerD+= "  AND DA1_ATIVO='1' "
//cQuerD+= "  AND X5_FILIAL='"+xFilial("SX5")+"' "
//cQuerD+= "  AND X5_TABELA='Z2' "
cQuerD+= "  AND BM_GRUPO=B1_GRUPO "
cQuerD+= "  AND SUBSTRING(SB1.B1_DESC,1,1) = '#' "  //ITENS DESCONTINUADOS
cQuerD+= "GROUP BY B1_GRUPO,BM_DESC,DA1_CODPRO,B1_DESC "
cQuerD+= "ORDER BY DESCFAM,DESCRI "
If Select("TRABD") > 0 
	TRABD->(dbCloseArea())
EndIf      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerD),"TRABD",.T.,.T.)
dbGotop()
     

cQuery:= "SELECT B1_GRUPO AS FAMILIA, "
cQuery+= "       BM_DESC AS DESCFAM,  "
cQuery+= "       DA1_CODPRO AS CODIGO, "
cQuery+= "       B1_DESC AS DESCRI, "
cQuery+= "       SUM(DA1_PRCVEN) AS VALOR "
cQuery+= "FROM " + RetSqlName("DA0") + " DA0, "+ RetSqlName("DA1") + " DA1, "+ RetSqlName("SB1") + " SB1, "+ RetSqlName("SBM") + " SBM "
cQuery+= "WHERE DA0.D_E_L_E_T_='' "
cQuery+= "  AND DA1.D_E_L_E_T_='' "
cQuery+= "  AND SB1.D_E_L_E_T_='' "
cQuery+= "  AND SBM.D_E_L_E_T_='' "
cQuery+= "  AND DA0_CODTAB = '"+mv_par03+"' "
cQuery+= "  AND DA1_CODTAB=DA0_CODTAB "
cQuery+= "  AND DA1_CODPRO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery+= "  AND DA1_CODPRO=B1_COD "
//cQuery+= "  AND DA1_ATIVO='1' "
//cQuery+= "  AND X5_FILIAL='"+xFilial("SX5")+"' "
//cQuery+= "  AND X5_TABELA='Z2' "
cQuery+= "  AND BM_GRUPO=B1_GRUPO "
cQuery+= "  AND SUBSTRING(SB1.B1_DESC,1,1)<>'#' "  //ITENS SEM SER DESCONTINUADOS
cQuery+= "GROUP BY B1_GRUPO,BM_DESC,DA1_CODPRO,B1_DESC "
cQuery+= "ORDER BY DESCFAM,DESCRI "
If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAB",.T.,.T.)
dbGotop()

If Eof()
	dbCloseArea()	
	Return
Endif
 

_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"                                                                                                                                                              
_cBody += "<head>"                                                                                                                                                              
_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
_cBody += "</head>"                                                                                                                                                             
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='5'>TABELA DE PREÇOS EXPORTAÇÃO</font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'><b>Atualizada em "+DtoC(dDataBase)+"</b></font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<table border='1' cellspacing='1' width='100%'>"
_cBody += "<tbody>"
_cBody += "<tr>"
_cBody += " <td width='10%' align='left'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Codigo Barra</b></font></td>"
_cBody += " <td width='08%' align='left'   bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Partida Arancelaria</b></font></td>"
_cBody += " <td width='06%' align='left'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Codigo Producto</b></font></td>"
_cBody += " <td width='25%' align='left'  bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Descripcion</b></font></td>" 
_cBody += " <td width='25%' align='left'  bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Embalaje</b></font></td>"
//_cBody += " <td width='07%' align='center' bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Valid.Meses</b></font></td>"
_cBody += " <td width='07%' align='right' bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Peso (kg)</b></font></td>"
_cBody += " <td width='12%' align='right'  bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Precio (R$)</b></font></td>"
_cBody += "</tr>"                                                                                                                                                           
_cBody += "</tbody>"                                                                                                                                                           
_cBody += "</table>"

cBgColor := '#ffffff'
cBgColorC:= '#f0f0f0'
 
While !Eof()

	cFamAux := TRAB->FAMILIA
	
	_cBody += "<body>"
	_cBody += " <td><font face='Tahoma' size='3'>"+TRAB->DESCFAM+"</font></td>"
	_cBody += "</body>"

	_cBody += "<table border='1' cellspacing='1' width='100%'>"
	_cBody += "<tbody>"

	While !Eof() .And. cFamAux== TRAB->FAMILIA
		nPesoAx:= Posicione("SB1",1,xFilial("SB1")+TRAB->CODIGO,"B1_PESO")

		_cBody += "<tr>"                                                                                                                                                            
		_cBody += " <td width='10%' align='left'   bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(SB1->B1_CODBAR)+"</font></td>"
		_cBody += " <td width='08%' align='left'   bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(SB1->B1_POSIPI)+"</font></td>"
		_cBody += " <td width='06%' align='left'   bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(TRAB->CODIGO)+"</font></td>"
		_cBody += " <td width='25%' align='left'   bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(TRAB->DESCRI)+"</font></td>" 
		_cBody += " <td width='25%' align='left'   bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(SB1->B1_X_EMBL)+"</font></td>"
		//_cBody += " <td width='07%' align='center' bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(Transform(SB1->B1_MESVALI,"@E 99999"))+"</font></td>"
		_cBody += " <td width='07%' align='right' bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(Transform(nPesoAx,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='12%' align='right'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRAB->VALOR ,"@E 999,999.99"))+"</font></td>"
		_cBody += "</tr>"                                                                                                                                                           
		
		dbSkip()
	EndDo	

	_cBody += "</tbody>"                                                                                                                                                           
	_cBody += "</table>"

EndDo	

_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"

_cBody += " <hr> " //linha horizontal


//itens que serão descontinuados....

dbSelectArea("TRABD")
dbGoTop()

If !Eof()
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Itens que serão Descontinuados </b></font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	
	_cBody += "<table border='1' cellspacing='1' width='100%'>"
	_cBody += "<tbody>"
	_cBody += "<tr>"
	_cBody += " <td width='10%' align='left'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Codigo Barra</b></font></td>"
	_cBody += " <td width='08%' align='left'   bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Partida Arancelaria</b></font></td>"
	_cBody += " <td width='06%' align='left'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Codigo Producto</b></font></td>"
	_cBody += " <td width='25%' align='left'  bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Descripcion</b></font></td>" 
	_cBody += " <td width='25%' align='left'  bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Embalaje</b></font></td>"
	//_cBody += " <td width='07%' align='center' bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Valid.Meses</b></font></td>"
	_cBody += " <td width='07%' align='right' bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Peso (kg)</b></font></td>"
	_cBody += " <td width='12%' align='right'  bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Precio (R$)</b></font></td>"
	_cBody += "</tr>"                                                                                                                                                           
	_cBody += "</tbody>"                                                                                                                                                           
	_cBody += "</table>"
	
	cBgColor := '#ffffff'
	cBgColorC:= '#f0f0f0'
	 
	While !Eof()
	
		cFamAux := TRABD->FAMILIA
		
		_cBody += "<body>"
		_cBody += " <td><font face='Tahoma' size='3'>"+TRABD->DESCFAM+"</font></td>"
		_cBody += "</body>"
	
		_cBody += "<table border='1' cellspacing='1' width='100%'>"
		_cBody += "<tbody>"
	
		While !Eof() .And. cFamAux== TRABD->FAMILIA
			nPesoAx:= Posicione("SB1",1,xFilial("SB1")+TRABD->CODIGO,"B1_PESO")
	
			_cBody += "<tr>"                                                                                                                                                            
			_cBody += " <td width='10%' align='left'   bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(SB1->B1_CODBAR)+"</font></td>"
			_cBody += " <td width='08%' align='left'   bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(SB1->B1_POSIPI)+"</font></td>"
			_cBody += " <td width='06%' align='left'   bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(TRABD->CODIGO)+"</font></td>"
			_cBody += " <td width='25%' align='left'   bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(TRABD->DESCRI)+"</font></td>" 
			_cBody += " <td width='25%' align='left'   bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(SB1->B1_X_EMBL)+"</font></td>"
			//_cBody += " <td width='07%' align='center' bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(Transform(SB1->B1_MESVALI,"@E 99999"))+"</font></td>"
			_cBody += " <td width='07%' align='right' bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(Transform(nPesoAx,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='12%' align='right'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABD->VALOR ,"@E 999,999.99"))+"</font></td>"
			_cBody += "</tr>"                                                                                                                                                           
			
			dbSkip()
		EndDo	
	
		_cBody += "</tbody>"                                                                                                                                                           
		_cBody += "</table>"
	
	EndDo	
	
	_cBody += "<body>"
	_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	
	_cBody += " <hr> " //linha horizontal
	
EndIf


_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"

_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2'>"+DtoC(Date())+" - "+Time()+"</font></td>"
_cBody += "</body>"

_cBody += "</html>"

cEmailAx:= AllTrim(mv_par04)
cAssunto:= "Tabela de Preços Exportação - "+DtoC(dDataBase)


U_SendMail(cEmailAx,cAssunto,_cBody,"",.f.)

dbSelectArea("TRAB")
dbCloseArea()	

dbSelectArea("TRABD")
dbCloseArea()	

Return



Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:={}
//          Grupo/Ordem/Pergunta                     /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04              /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme  /GrpSXG /Help /Picture /IDFil
aAdd(aRegs,{cPerg,"01" ,"Codigo De ? "         ,"","","mv_ch1","C" ,8     ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SB1",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"02" ,"Codigo Ate? "         ,"","","mv_ch2","C" ,8     ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SB1",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"03" ,"Tabela p/ Prc Export:","","","mv_ch3","C" ,3      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"DA0",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"04" ,"Email: "              ,"","","mv_ch4","C" ,40     ,0      ,0     ,"G",""   ,"mv_par04","                ","","" ,""   ,""   ,"              ","","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""      ,""})
/*
aAdd(aRegs,{cPerg,"07" ,"Saida: "              ,"","","mv_ch7","N" ,1      ,0      ,0     ,"C",""   ,"mv_par07","Relatorio       ","","" ,""   ,""   ,"E-mail        ","","" ,""   ,""   ,"Relat. e Email"   ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""      ,""})
*/
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