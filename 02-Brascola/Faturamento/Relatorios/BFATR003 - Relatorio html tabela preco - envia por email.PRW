#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
 
/*/
----------------------------------------------------------------------------
PROGRAMA: BFATR003         AUTOR:                        DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Gera relatorio de tabela de preços e envia html por email.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BFATR003()


Local aAreaAtu	   := GetArea()
Local cCadastro	   := OemToAnsi("Tabela de Preços")
Local nProcessa	   := 3
Local lJob		   := .t.
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio do Comissões"
Local cPict        := ""
Local titulo       := "Tabela de Preços"
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
Private nomeprog   := "BFATR003" 
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := U_CriaPerg("BFATR003")
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "BFATR003" 
Private nResul     := 0
Private nTotalMedia:= 0
Private cString    := "DA0"

U_BCFGA002("BFATR003")//Grava detalhes da rotina usada   

ValPergunte(cPerg)

Pergunte(cPerg,.T.) 

RptStatus({|| U_ProcTabPrc() },Titulo)

RestArea(aAreaAtu)

Return(Nil)


User Function ProcTabPrc()

Local cQuery  := ""           
Local cQueryC := ""           
Local _cBody  := ""
Local cAssunto:= ""
Local cEmailAx:= ""
Local _cArqTmp:= ""
Local aEstru  := {}

aAdd(aEstru, {"FAMILIA"  , "C", 20, 00})
aAdd(aEstru, {"CODIGO"   , "C", 15, 00})
aAdd(aEstru, {"CODANT"   , "C", 15, 00})//Fernando
aAdd(aEstru, {"DESCRICAO", "C", 40, 00})
aAdd(aEstru, {"EMBALAGEM", "C", 40, 00})
//aAdd(aEstru, {"VALIDADE" , "N", 06, 00})
aAdd(aEstru, {"PESO"     , "N", 14, 02})
aAdd(aEstru, {"IPI"      , "N", 14, 02})
aAdd(aEstru, {"ST"       , "C", 03, 00})
aAdd(aEstru, {"PRECO7ZFM", "N", 14, 02})
aAdd(aEstru, {"PRECO7"   , "N", 14, 02})
aAdd(aEstru, {"PRECO12"  , "N", 14, 02})
aAdd(aEstru, {"PRECO17"  , "N", 14, 02})
aAdd(aEstru, {"PRECO18"  , "N", 14, 02})
_cArqTmp := CriaTrab(aEstru, .T.)

If Select("TEMP") > 0
	TEMP->(DbCloseArea())
EndIf

dbUseArea( .T.,,_cArqTmp, "TEMP", .F., .F. )
//IndRegua("TEMP", CriaTrab(,.f.), "FAMILIA + DESCRICAO",,, "Consultando...")


cQueryC:= "SELECT E4_CODIGO AS CODIGO, "
cQueryC+= "       E4_DESCRI AS DESCRI, "
cQueryC+= "       E4_INFLATO AS INFLATO, "
cQueryC+= "       E4_COND AS COND "
cQueryC+= " FROM "+RetSqlName("SE4")+" SE4 "
cQueryC+= "WHERE D_E_L_E_T_='' "
cQueryC+= "  AND E4_SETOR='V'  "
cQueryC+= "  AND E4_STATUS='A' "
cQueryC+= "  AND E4_X_LISTA='1' "
cQueryC+= "ORDER BY 1 "

If Select("TRABC") > 0 
	TRABC->(dbCloseArea())
EndIf      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryC),"TRABC",.T.,.T.)
dbGotop()
   
cQuery:= "SELECT B1_GRUPO AS FAMILIA, B1_CODANT AS CODANT, "
cQuery+= "       BM_DESC AS DESCFAM,  "
cQuery+= "       DA1_CODPRO AS CODIGO, "
cQuery+= "       B1_DESC AS DESCRI, "
cQuery+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par07+"' THEN DA1_PRCVEN ELSE 0 END) AS VL18, "
cQuery+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par06+"' THEN DA1_PRCVEN ELSE 0 END) AS VL17, "
cQuery+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par05+"' THEN DA1_PRCVEN ELSE 0 END) AS VL12, "
cQuery+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par04+"' THEN DA1_PRCVEN ELSE 0 END) AS VL07, "
cQuery+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par03+"' THEN DA1_PRCVEN ELSE 0 END) AS VL07ZF "
cQuery+= "FROM " + RetSqlName("DA0") + " DA0, "+ RetSqlName("DA1") + " DA1, "+ RetSqlName("SB1") + " SB1, "+ RetSqlName("SBM") + " SBM "
cQuery+= "WHERE DA0.D_E_L_E_T_='' "
cQuery+= "  AND DA1.D_E_L_E_T_='' "
cQuery+= "  AND SB1.D_E_L_E_T_='' "
cQuery+= "  AND SBM.D_E_L_E_T_='' "
cQuery+= "  AND DA0_CODTAB IN('"+mv_par03+"','"+mv_par04+"','"+mv_par05+"','"+mv_par06+"','"+mv_par07+"') "
cQuery+= "  AND DA1_CODTAB=DA0_CODTAB "
cQuery+= "  AND DA1_CODPRO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' " 
cQuery+= "  AND B1_GRUPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
cQuery+= "  AND DA1_CODPRO=B1_COD "
//cQuery+= "  AND DA1_ATIVO='1' "
cQuery+= "  AND BM_FILIAL='"+xFilial("SBM")+"' "
//cQuery+= "  AND X5_TABELA='Z2' "
cQuery+= "  AND BM_GRUPO=B1_GRUPO "
cQuery+= "  AND SUBSTRING(SB1.B1_DESC,1,1)<>'#' "  //ITENS SEM SER DESCONTINUADOS
cQuery+= "GROUP BY B1_GRUPO,BM_DESC,DA1_CODPRO,B1_DESC,B1_CODANT "
cQuery+= "ORDER BY CODIGO "
//cQuery+= "ORDER BY DESCFAM,DESCRI " 


If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAB",.T.,.T.)
dbGotop()

cQuerD:= "SELECT B1_GRUPO AS FAMILIA, B1_CODANT AS CODANT, "
cQuerD+= "       BM_DESC AS DESCFAM,  "
cQuerD+= "       DA1_CODPRO AS CODIGO, "
cQuerD+= "       B1_DESC AS DESCRI, "
cQuerD+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par07+"' THEN DA1_PRCVEN ELSE 0 END) AS VL18, "
cQuerD+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par06+"' THEN DA1_PRCVEN ELSE 0 END) AS VL17, "
cQuerD+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par05+"' THEN DA1_PRCVEN ELSE 0 END) AS VL12, "
cQuerD+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par04+"' THEN DA1_PRCVEN ELSE 0 END) AS VL07, "
cQuerD+= "       SUM(CASE WHEN DA0_CODTAB='"+mv_par03+"' THEN DA1_PRCVEN ELSE 0 END) AS VL07ZF "
cQuerD+= "FROM " + RetSqlName("DA0") + " DA0, "+ RetSqlName("DA1") + " DA1, "+ RetSqlName("SB1") + " SB1, "+ RetSqlName("SBM") + " SBM "
cQuerD+= "WHERE DA0.D_E_L_E_T_='' "
cQuerD+= "  AND DA1.D_E_L_E_T_='' "
cQuerD+= "  AND SB1.D_E_L_E_T_='' "
cQuerD+= "  AND SBM.D_E_L_E_T_='' "
cQuerD+= "  AND DA0_CODTAB IN('"+mv_par03+"','"+mv_par04+"','"+mv_par05+"','"+mv_par06+"','"+mv_par07+"') "
cQuerD+= "  AND DA1_CODTAB=DA0_CODTAB "
cQuerD+= "  AND DA1_CODPRO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "  
cQuery+= "  AND B1_GRUPO BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
cQuerD+= "  AND DA1_CODPRO=B1_COD "
//cQuerD+= "  AND DA1_ATIVO='1' "
cQuerD+= "  AND BM_FILIAL='"+xFilial("SBM")+"' "
//cQuerD+= "  AND X5_TABELA='Z2' "
cQuerD+= "  AND BM_GRUPO=B1_GRUPO "
cQuerD+= "  AND SUBSTRING(SB1.B1_DESC,1,1) = '#' " //ITENS DESCONTINUADOS
cQuerD+= "GROUP BY B1_GRUPO,BM_DESC,DA1_CODPRO,B1_DESC,B1_CODANT "
cQuerD+= "ORDER BY CODIGO "
//cQuerD+= "ORDER BY DESCFAM,DESCRI "

If Select("TRABD") > 0 
	TRABD->(dbCloseArea())
EndIf      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerD),"TRABD",.T.,.T.)
dbGotop()

dbSelectArea("TRAB")
dbGotop()

If Eof()
	dbCloseArea()	

	dbSelectArea("TRABC")
	dbCloseArea()	

	dbSelectArea("TRABD")
	dbCloseArea()	

	dbSelectArea("TEMP")
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
_cBody += "   <tr><font face='Tahoma' size='5'>TABELA DE PREÇOS</font></tr>" 
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
_cBody += " <td width='05%' align='left'   bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Codigo</b></font></td>" 
_cBody += " <td width='04%' align='left'   bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Cod.Ant</b></font></td>"//Fernando
_cBody += " <td width='23%' align='left'   bgcolor='#ffff50'><font face='Tahoma' size='1'><b>Descrição</b></font></td>"
_cBody += " <td width='19%' align='left'   bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Embalagem</b></font></td>"
//_cBody += " <td width='04%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Valid. meses</b></font></td>" 
_cBody += " <td width='06%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Peso (kg)</b></font></td>"
_cBody += " <td width='04%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>IPI</b></font></td>"
_cBody += " <td width='04%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='1'><b>ST</b></font></td>"
_cBody += " <td width='07%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Preço 7% ZFM/ALC</b></font></td>"
_cBody += " <td width='07%' align='right'  bgcolor='#ffff50'><font face='Tahoma' size='1'><b>Preço 7%</b></font></td>"
_cBody += " <td width='07%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Preço 12%</b></font></td>"
_cBody += " <td width='07%' align='right'  bgcolor='#ffff50'><font face='Tahoma' size='1'><b>Preço 17%</b></font></td>"
_cBody += " <td width='07%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Preço 18%</b></font></td>"
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
		cEmbAx := SB1->B1_X_EMBL
		//nMesVAx:= SB1->B1_MESVALI
		nIPIAx := SB1->B1_IPI
		cSTAx  := Iif(SB1->B1_PICMRET>0, "Sim", "Não")

		_cBody += "<tr>"                                                                                                                                                            
		_cBody += " <td width='05%' align='left'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRAB->CODIGO)+"</font></td>"
		_cBody += " <td width='04%' align='left'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRAB->CODANT)+"</font></td>"
		_cBody += " <td width='23%' align='left'   bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(TRAB->DESCRI)+"</font></td>"
		_cBody += " <td width='19%' align='left'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(cEmbAx)+"</font></td>"
		//_cBody += " <td width='04%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nMesVAx,"@E 999"))+"</font></td>" 
		_cBody += " <td width='06%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nPesoAx,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='04%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nIPIAx,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='04%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+cSTAx+"</font></td>"
		_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRAB->VL07ZF,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRAB->VL07  ,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRAB->VL12  ,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRAB->VL17  ,"@E 999,999.99"))+"</font></td>"
		_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRAB->VL18  ,"@E 999,999.99"))+"</font></td>"
		_cBody += "</tr>"                                                                                                                                                           

        DbSelectArea("TEMP")
        RecLock("TEMP",.T.)
        TEMP->FAMILIA  := TRAB->DESCFAM
        TEMP->CODIGO   := TRAB->CODIGO
        TEMP->CODANT   := TRAB->CODANT
        TEMP->DESCRICAO:= TRAB->DESCRI
        TEMP->EMBALAGEM:= cEmbAx
        //TEMP->VALIDADE := nMesVAx
        TEMP->PESO     := nPesoAx
        TEMP->IPI      := nIPIAx
        TEMP->ST       := cSTAx
        TEMP->PRECO7ZFM:= TRAB->VL07ZF
        TEMP->PRECO7   := TRAB->VL07
        TEMP->PRECO12  := TRAB->VL12
        TEMP->PRECO17  := TRAB->VL17
        TEMP->PRECO18  := TRAB->VL18 
        MsUnlock()

        dbSelectArea("TRAB")
		dbSkip()
	EndDo	

	_cBody += "</tbody>"                                                                                                                                                           
	_cBody += "</table>"

EndDo	

_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"

_cBody += " <hr> " //linha horizontal


//Itens que serão descontinuados

dbSelectArea("TRABD")
dbGoTop()

If !Eof()
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Itens que serão Descontinuados</b></font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	
	_cBody += "<table border='1' cellspacing='1' width='100%'>"
	_cBody += "<tbody>"
	_cBody += "<tr>"
	_cBody += " <td width='05%' align='left'   bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Codigo</b></font></td>" 
	_cBody += " <td width='04%' align='left'   bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Cod.Ant</b></font></td>"//Fernando
	_cBody += " <td width='23%' align='left'   bgcolor='#ffff50'><font face='Tahoma' size='1'><b>Descrição</b></font></td>"
	_cBody += " <td width='19%' align='left'   bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Embalagem</b></font></td>"
	//_cBody += " <td width='04%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Valid. meses</b></font></td>" 
	_cBody += " <td width='06%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Peso (kg)</b></font></td>"
	_cBody += " <td width='04%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>IPI</b></font></td>"
	_cBody += " <td width='04%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='1'><b>ST</b></font></td>"
	_cBody += " <td width='07%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Preço 7% ZFM/ALC</b></font></td>"
	_cBody += " <td width='07%' align='right'  bgcolor='#ffff50'><font face='Tahoma' size='1'><b>Preço 7%</b></font></td>"
	_cBody += " <td width='07%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Preço 12%</b></font></td>"
	_cBody += " <td width='07%' align='right'  bgcolor='#ffff50'><font face='Tahoma' size='1'><b>Preço 17%</b></font></td>"
	_cBody += " <td width='07%' align='right'  bgcolor='#ffff99'><font face='Tahoma' size='1'><b>Preço 18%</b></font></td>"
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
			cEmbAx := SB1->B1_X_EMBL
			//nMesVAx:= SB1->B1_MESVALI
			nIPIAx := SB1->B1_IPI
			cSTAx  := Iif(SB1->B1_PICMRET>0, "Sim", "Não")
	
			_cBody += "<tr>"                                                                                                                                                            
			_cBody += " <td width='05%' align='left'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRABD->CODIGO)+"</font></td>"
			_cBody += " <td width='04%' align='left'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(TRABD->CODANT)+"</font></td>"//Fernando
			_cBody += " <td width='23%' align='left'   bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(TRABD->DESCRI)+"</font></td>"
			_cBody += " <td width='19%' align='left'   bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(cEmbAx)+"</font></td>"
			//_cBody += " <td width='04%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nMesVAx,"@E 999"))+"</font></td>" 
			_cBody += " <td width='06%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nPesoAx,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='04%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nIPIAx,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='04%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+cSTAx+"</font></td>"
			_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABD->VL07ZF,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABD->VL07  ,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABD->VL12  ,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABD->VL17  ,"@E 999,999.99"))+"</font></td>"
			_cBody += " <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABD->VL18  ,"@E 999,999.99"))+"</font></td>"
			_cBody += "</tr>"                                                                                                                                                           
	
	        DbSelectArea("TEMP")
	        RecLock("TEMP",.T.)
	        TEMP->FAMILIA  := "#"+TRABD->DESCFAM
	        TEMP->CODIGO   := TRABD->CODIGO  
	        TEMP->CODANT   := TRABD->CODANT
	        TEMP->DESCRICAO:= TRABD->DESCRI
	        TEMP->EMBALAGEM:= cEmbAx
	        //TEMP->VALIDADE := nMesVAx
	        TEMP->PESO     := nPesoAx
	        TEMP->IPI      := nIPIAx
	        TEMP->ST       := cSTAx
	        TEMP->PRECO7ZFM:= TRABD->VL07ZF
	        TEMP->PRECO7   := TRABD->VL07
	        TEMP->PRECO12  := TRABD->VL12
	        TEMP->PRECO17  := TRABD->VL17
	        TEMP->PRECO18  := TRABD->VL18 
	        MsUnlock()
	
	        dbSelectArea("TRABD")
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

_cBody += "<table border='1' cellspacing='1' width='40%'>"
_cBody += "<tbody>"
_cBody += "<tr>"
_cBody += " <td width='100%' align='center'  bgcolor='9FFF9F'><font face='Tahoma' size='2'><b>Prazos de Pagamentos Vigentes</b></font></td>"
_cBody += "</tr>"                                                                                                                                                           
_cBody += "</tbody>"                                                                                                                                                           
_cBody += "</table>"

_cBody += "<table border='1' cellspacing='1' width='40%'>"
_cBody += "<tbody>"
_cBody += "<tr>"
_cBody += " <td width='10%' align='center'  bgcolor='#d7ffd7'><font face='Tahoma' size='1'><b>Codigo</b></font></td>"
_cBody += " <td width='40%' align='center'  bgcolor='#d7ffd7'><font face='Tahoma' size='1'><b>Prazo Pagto (dias)</b></font></td>"
_cBody += " <td width='25%' align='center'  bgcolor='#d7ffd7'><font face='Tahoma' size='1'><b>Inflator %</b></font></td>"
_cBody += " <td width='25%' align='center'  bgcolor='#d7ffd7'><font face='Tahoma' size='1'><b>Prazo Médio</b></font></td>" 
_cBody += "</tr>"                                                                                                                                                           


DbSelectArea("TRABC")
dbGoTop()

While !Eof()
	xE4_Cond:= TRABC->COND
	nQtdeDia:= 0  
	nSomaDia:= 0
	cNumAux := ""
	
	For nI:= 1 to Len(AllTrim(xE4_Cond))
		If SubStr(Alltrim(xE4_Cond), nI, 1)<>","
			cNumAux+= SubStr(xE4_Cond, nI, 1)
		Else
			nQtdeDia++
			nSomaDia+= Val(cNumAux)
			cNumAux := ""
		EndIf	
	Next
	
	If !Empty(cNumAux)
		nQtdeDia++
		nSomaDia+= Val(cNumAux)
	EndIf
	
	nMediaDias:= nSomaDia/nQtdeDia
	
	cBgColor:= '#ffffff' //Iif(TRABC->INFLATO==0,'#f0f0f0','#ffffff')

	_cBody += "<tr>"
	_cBody += " <td width='10%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+TRABC->CODIGO+"</font></td>" 
	//_cBody += " <td width='10%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+TRABC->CODANT+"</font></td>"//Fernando
	_cBody += " <td width='40%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+TRABC->COND+"</font></td>"
	_cBody += " <td width='25%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(TRABC->INFLATO,"@E 9999.99"))+"</font></td>"
	_cBody += " <td width='25%' align='center' bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+AllTrim(Transform(nMediaDias,"@E 999"))+"</font></td>" 
	_cBody += "</tr>"                                                                                                                                                           
	
	DbSkip()	
EndDo

_cBody += "</tbody>"                                                                                                                                                           
_cBody += "</table>"

_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += " <td><font face='Tahoma' size='2'>"+DtoC(Date())+" - "+Time()+"</font></td>"
_cBody += "</body>"
_cBody += "</html>"

cEmailAx:= AllTrim(mv_par08)
cAssunto:= "Tabela de Preços - "+DtoC(dDataBase)
//cAnexo  := U_GeraCSV("TEMP", .f.)

If !Empty(cEmailAx)
	U_SendMail(cEmailAx,cAssunto,_cBody,"",.t.)
EndIf	

dbSelectArea("TEMP")
dbGoTop()

U_ProcExcel("TEMP")


dbSelectArea("TRAB")
dbCloseArea()	

dbSelectArea("TRABD")
dbCloseArea()	

dbSelectArea("TEMP")
dbCloseArea()	

Return



Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:={}
//          Grupo/Ordem/Pergunta                     /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04              /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme  /GrpSXG /Help /Picture /IDFil
aAdd(aRegs,{cPerg,"01" ,"Codigo De ? "         ,"","","mv_ch1","C" ,15     ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SB1",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"02" ,"Codigo Ate? "         ,"","","mv_ch2","C" ,15     ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SB1",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"03" ,"Tabela p/ Prc 7%-ZFM:","","","mv_ch3","C" ,3      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"DA0",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"04" ,"Tabela p/ Prc 7% :"   ,"","","mv_ch4","C" ,3      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"DA0",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"05" ,"Tabela p/ Prc 12%:"   ,"","","mv_ch5","C" ,3      ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"DA0",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"06" ,"Tabela p/ Prc 17%:"   ,"","","mv_ch6","C" ,3      ,0      ,0     ,"G",""   ,"mv_par06",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"DA0",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"07" ,"Tabela p/ Prc 18%:"   ,"","","mv_ch7","C" ,3      ,0      ,0     ,"G",""   ,"mv_par07",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"DA0",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"08" ,"Email: "              ,"","","mv_ch8","C" ,40     ,0      ,0     ,"G",""   ,"mv_par08","                ","","" ,""   ,""   ,"              ","","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"09" ,"Grupo De ? "          ,"","","mv_ch9","C" ,2      ,0      ,0     ,"G",""   ,"mv_par09",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SBM",""    ,""     ,""   ,""      ,""})
aAdd(aRegs,{cPerg,"10" ,"Grupo Ate? "          ,"","","mv_chA","C" ,2      ,0      ,0     ,"G",""   ,"mv_par10",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SBM",""    ,""     ,""   ,""      ,""})

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