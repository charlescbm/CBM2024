#INCLUDE "rwmake.ch" 
#INCLUDE "protheus.ch"   
#INCLUDE "TopConn.ch"

/******************************************** VERIFICA CADASTRO DE PROMOCAO ***************************/ 
//Funcao para verificar no campo Produto
User Function BFATG004 ()//(cTipoRet)   

             
Local nUnit  := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN" })] //Grava na variavel   
Local cProd  := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO" })]  
Local nQtd   := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })]
Local cTab   := AllTrim(C5_TABELA)
Local cCli   := AllTrim(C5_CLIENTE)
Local cTipo  := AllTrim(C5_TIPO)
Local cParam := "BR_000004" //Cliente Brascola                      

//seleciona tabela de pre�os
dbSelectArea("DA1")
dbSetOrder(1)
If DA1->(dbSeek(xFilial("DA1")+cTab+cProd))//posiciona na tabela de pre�o x produto
	nPrcTab := DA1->DA1_PRCVEN //captura o pre�o da tabela de pre�os
	nUnitNov:= nPrcTab 
EndIf
  
//seleciona tabela de clientes
dbSelectArea("SA1")
dbSetOrder(1)
If SA1->(dbSeek(xFilial("SA1")+cCli))//posiciona o Cliente selecionado no pedido 
	cGrpCli:= SA1->A1_GRPVEN //Grupo de Clientes
EndIf
   

	_cQuery1 :="  SELECT ZZR_DESCPR,ZZQ_DESCRI,ZZQ_CODPRO FROM "+RetSQLName("ZZR")+" ZZR , "+RetSQLName("ZZQ")+" ZZQ "
	_cQuery1 +="  WHERE ZZR_CODPRO = '"+cProd+"' AND ZZR_CODPRO = ZZQ_CODPRO "
	_cQuery1 +="  AND ZZQ_TIPO = '2' AND ZZQ_GRPVEN = '"+cGrpCli+"' AND ZZQ_CODTAB = '"+cTab+"' "
	_cQuery1 +="  AND ZZR_QTDMIN <= '"+STR(nQtd)+"'   AND ZZR_QTDMAX >= '"+STR(nQtd)+"' " 
	_cQuery1 +="  AND (ZZQ_DATDE <= '"+DTOS(DDATABASE)+"' AND ZZQ_DATATE >= '"+DTOS(DDATABASE)+"')" 


	If Select("QUERY1") > 0
		dbCloseArea()
		EndIf
	
	TCQUERY _cQuery1 NEW ALIAS "QUERY1"


	DBSELECTAREA("QUERY1")
	DBGOTOP()
    
    IF !EOF()
	
		IF (!cCli $ GetMv("BR_000004")) .AND. (!cTipo $ "B/D")
		
			If MsgYesNo("Produto "+AllTrim(cProd)+" cadastrado na promo��o."+QUERY1->ZZQ_CODPRO+" "+QUERY1->ZZQ_DESCRI+""+chr(13)+;
			    "Confirmar para este item?")
  
	   		lRet      := .T.
			nUnitNov := nPrcTab - ((nPrcTab * QUERY1->ZZR_DESCPR)/100) //faz o c�lculo do novo valor unit�rio
			aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })]:=  0
			aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT" })]:=  nUnitNov 
			aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_X_REGRA" })]:=  QUERY1->ZZQ_CODPRO
			aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" })]:=  0 
			aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" })]:=  0 
			GETDREFRESH()
			SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
			oGetDad:Refresh()
	Else 
		nDesc:= aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" })] 
		nQuantVend := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })] 
		nUnitNov := (nPrcTab - ((nPrcTab * nDesc)/100)) 
		//aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" })]:= 0 
		//aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })]:=  0
		aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT" })]:=  nUnitNov
		aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN" })]:=  nUnitNov
		aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_X_REGRA" })]:=  "" 
		aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR" })]:= Round((nQuantVend * nUnitNov),2) 
		lRet := .T.
	EndIf			    
	endif
Else
	lRet:= .T.
EndIf	 

DBSELECTAREA("QUERY1")
dbCloseArea()
		
//If cTipoRet == "N"
   Return lRet//Round(nUnitNov,4)
//Else
//   Return lRet
//EndIf




//Funcao para verificar no campo desconto
User Function BFATG04A() 
  
local lRet := .t.
LOCAL AAREA  :=GETAREA()  
Local nUnit  := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN" })] //Grava na variavel   
Local cProd  := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO" })]  
Local nQtd   := M->C6_QTDVEN//aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN " })]
Local cTab   := AllTrim(C5_TABELA)
Local cCli   := AllTrim(C5_CLIENTE)
Local cTipo  := AllTrim(C5_TIPO)
Local cParam := "BR_000004" //Cliente Brascola                      
local _VEND  := space(6)//SA1->A1_VEND
locaL _GRPREP:= SPACE(6)      
local cGrpCli := space(6) //Grupo de Clientes
local cCliente:=space(6)

IF (!cCli $ GetMv("BR_000004")) .AND. (!cTipo $ "B/D")
	dbSelectArea("DA1")
	dbSetOrder(1)

	If DA1->(dbSeek(xFilial("DA1")+cTab+cProd))//posiciona na tabela de pre�o x produto
		nPrcTab := DA1->DA1_PRCVEN //captura o pre�o da tabela de pre�os
	EndIf


	//seleciona tabela de clientes
	dbSelectArea("SA1")
	dbSetOrder(1)
	If SA1->(dbSeek(xFilial("SA1")+cCli))//posiciona o Cliente selecionado no pedido
		cGrpCli := SA1->A1_GRPVEN //Grupo de Clientes
		cCliente:=SA1->A1_COD
		_VEND   :=SA1->A1_VEND
		_GRPREP:=SA1->A1_REGIAO
	EndIf

	SA3->(DBSEEK(XFILIAL("SA3")+_VEND))
   //	_GRPREP:=SA3->A3_GRPREP 
//   _GRPREP:=SA1->A1_REGIAO

	_cQuery2 :="  SELECT ZZR_DESCPR,ZZQ_DESCRI,ZZQ_CODPRO,ZZQ_CODREG FROM "+RetSQLName("ZZR")+" ZZR , "+RetSQLName("ZZQ")+" ZZQ "
	_cQuery2 +="  WHERE ZZR_CODPRO = '"+cProd+"' AND ZZR_CODPRO = ZZQ_CODPRO "
	_cQuery2 +="  AND ZZQ_TIPO = '2' AND (ZZQ.ZZQ_GRPVEN = '"+cGrpCli+"' OR ZZQ.ZZQ_GRPVEN='"+Space(Len(ZZQ->ZZQ_GRPVEN))+"') AND "
	_cQuery2 +="  (ZZQ.ZZQ_CODTAB = '"+cTab+"' OR ZZQ.ZZQ_CODTAB='"+Space(Len(ZZQ->ZZQ_CODTAB))+"') "
	_cQuery2 += " AND (ZZQ.ZZQ_CODCLI = '"+cCliente+"' OR ZZQ.ZZQ_CODCLI='"+Space(Len(ZZQ->ZZQ_CODCLI))+"') "
	IF !EMPTY(_GRPREP)
		_cQuery2 += "AND (ZZQ.ZZQ_REG1 = '"+_GRPREP+"'  OR    ZZQ.ZZQ_REG2 = '"+_GRPREP+"'   OR  ZZQ.ZZQ_REG3 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG4 = '"+_GRPREP+"' OR  ZZQ.ZZQ_REG5 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG6 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG1 = ' ') "
	ENDIF
	_cQuery2 +="  AND (ZZQ.ZZQ_VEND1 = '' OR ZZQ.ZZQ_VEND1 = '"+_VEND+"') "
	_cQuery2 +="  AND ZZR_QTDMIN <= '"+STR(nQtd)+"'   AND ZZR_QTDMAX >= '"+STR(nQtd)+"' "
	_cQuery2 +="  AND (ZZQ_DATDE <= '"+DTOS(DDATABASE)+"' AND ZZQ_DATATE >= '"+DTOS(DDATABASE)+"')"

	If Select("QUERY2") > 0
		QUERY2->(dbCloseArea())
	EndIf


	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"QUERY2",.T.,.T.)


	DBSELECTAREA("QUERY2")
	DBGOTOP()
    
    IF EOF() .and. ALLTRIM(aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_X_REGRA" })]) <> "" 
	    aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_X_REGRA" })]:=  "" 
	  	lRet := .T.
	Else
		lRet := .T.
	EndIf

	DBSELECTAREA("QUERY2")
	dbCloseArea()
endif
RESTAREA(AAREA)
Return lRet

 