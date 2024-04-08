#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "COLORS.CH"

/*
----------------------------------------------------------------------------
PROGRAMA: BESTA009        AUTOR:                          DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO:Consulta lotes a vencer

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
*/   

User Function BESTA008()

Local _odlg
Local _cCod    := Space(15) //Cod Produto
Local _dDtde   := firstday(ddatabase) //Data Inicio
Local _dDtate  := lastday(ddatabase) //Data Fim
Local _cLtde   := Space(10) // Lote De
Local _cLtate  := "ZZZZZZZZZZ"  // Lote Ate
Local _cFlde   := "01" // Filial de
Local _cFlate  := "01" // Filial Ate
Local _cArde   := "  " // Arm de
Local _cArate  := "ZZ" // Arm Ate
Local _nSlini  := 0 // Saldo Inicial
Local _nSlfim  := 0 // Saldo Final
Local aAreaAtu := GETAREA()
Local _cOpc := "1"
Local _cOpc2 := "1"
Local _cSltp := "  "

Local cCombo  := ""
Local aCombo  := {}  
Local cCombo2 := ""
Local aCombo2 := {}
Local nList   := 0
Local aList   := {}
Local cVar    := Space(1)
Local cVar    := Space(1)
Local _aItens := {}
Local oCodigo
Local aAreaAtu :=  GETAREA()
Local _oDlg , oMainwnd, oListBox1,cListBox1 
                          
//Combo para tipo de Movimentacao
AADD(aCombo,("1-Todos"))
AADD(aCombo,("2-Ordem de Producao"))
AADD(aCombo,("3-Transf / Internos"))
AADD(aCombo,("4-Notas Fiscais"))
AADD(aCombo,("5-Transferencia"))
             
AADD(aCombo2,("1-Data"))
AADD(aCombo2,("2-Local"))       
AADD(aCombo2,("3-DOC/OP"))


AADD(_aItens,{"",;
"",;
"",;
"",;
"",;
"",;
"",;
"",;
0,;
"",;
"",;
""})
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Criacao da Interface                                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RESTC032(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate,;
 _nSlini, _nSlfim,aCombo,oListBox1,_oDlg,aCombo,cCombo,_cOpc,_cSltp,aCombo2,cCombo2,_cOpc2)

RETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA022  บAutor  ณDaniel Pelegrinelli บ Data ณ  19/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da tela.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION RESTC032(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini, _nSlfim,;
aCombo,oListBox1,_oDlg,aCombo,cCombo,_cOpc,_cSltp,aCombo2,cCombo2,_cOpc2)

DEFINE MSDIALOG _oDlg Title "Consulta Kardex Lote - Brascola" from 012,036 To 623,841 OF oMainWnd PIXEL
@ 008,001 To 103,389 Title OemToAnsi("Parametros")
@ 017,006 Say OemToAnsi("Produto") Size 36,8 Object _oProd
@ 017,045 MsGet oCodigo VAR _cCod F3 "SB1" Size 76,10 OF _oDlg PIXEL
@ 017,141 Say OemToAnsi("Data De:") Size 26,8 Object _odtde
@ 017,171 Get _dDtde  PICTURE "@E 99/99/99" Size 50,10
@ 017,252 Say OemToAnsi("Data Ate:") Size 26,8
@ 017,278 Get _dDtate  PICTURE "@E 99/99/99" Size 50,10
@ 043,006 Say OemToAnsi("Filial De:") Size 25,8 Object _oFild
@ 043,028 Get _cFlde Size 10,10
@ 043,052 Say OemToAnsi("Filial Ate:") Size 25,8 Object _oFilat
@ 043,085 Get _cFlate Size 10,10
@ 043,141 Say OemToAnsi("Lote De:") Size 24,8
@ 043,171 Get _cLtde  Size 76,10
@ 043,253 Say OemToAnsi("Lote Ate:") Size 36,8 Object _oLtate
@ 043,278 Get _cLtate Size 76,10
@ 075,006 Say OemToAnsi("Arm De:") Size 25,8 Object _oArmd
@ 075,028 Get _cArde Size 10,10
@ 075,052 Say OemToAnsi("Arm Ate:") Size 25,8 Object _oArmat
@ 075,085 Get _cArate Size 10,10
@ 060,155 Say OemToAnsi("Tipo de Documentos") Size 55,8 Object _otpdc
@ 290,127 Say OemToAnsi("Sld Por:") Size 20,8 Object _oSltp
@ 290,155 Get _cSltp Size 10,10
@ 290,180 Say "Sld Ini:" Size 40,8 Object _oSalini
@ 290,200 Get _nSlini Size 76,10 PICTURE "@E 99,999,999,999.9999"
@ 290,285 Say "Sld Fim:" Size 40,8 Object _oSaldfim
@ 290,310 Get _nSlfim Size 76,10 PICTURE "@E 99,999,999,999.9999"
@ 073,148 ComboBox cCombo  Items aCombo  Size 76,21  
@ 290,005 Say "Ordem:" Size 40,8 Object _oOrdem
@ 290,030 ComboBox cCombo2 Items aCombo2 Size 40,21
@ 110,006 LISTBOX oListBox1 VAR cListBox1 Fields HEADER ;
OEMTOANSI("FIL"),;
OEMTOANSI("TP"),;
OEMTOANSI("PRODUTO"),;
OEMTOANSI("ARM"),;
OEMTOANSI("DOC / NF"),;
OEMTOANSI("OP"),;
OEMTOANSI("DATA"),;
OEMTOANSI("MOV"),;
OEMTOANSI("QUANT"),;
OEMTOANSI("LOTE"),;
OEMTOANSI("VALIDADE"),;
OEMTOANSI("ESTORNO") ;
FIELDSIZES ;
GetTextWidth(0,"BBB"),;
GetTextWidth(0,"BBB"),;
GetTextWidth(0,"BBBBBBBBBBBB"),;
GetTextWidth(0,"BBB"),;
GetTextWidth(0,"BBBBBB"),;
GetTextWidth(0,"BBBBBBBBBBBB"),;
GetTextWidth(0,"BBBBBB"),;
GetTextWidth(0,"BBBB"),;
GetTextWidth(0,"BBBBBBBBBBBB"),;
GetTextWidth(0,"BBBBBBBBBBBB"),;
GetTextWidth(0,"BBBBBB"),;
GetTextWidth(0,"BBB");
SIZE 378,165 NOSCROLL PIXEL
oListBox1:SetArray(_aItens)
oListBox1:refresh()
oListBox1:bLine 		:= {|| {	_aItens[oListBox1:nAt,1],;
_aItens[oListBox1:nAt,2],;
_aItens[oListBox1:nAt,3],;
_aItens[oListBox1:nAt,4],;
_aItens[oListBox1:nAt,5],;
_aItens[oListBox1:nAt,6],;
_aItens[oListBox1:nAt,7],;
_aItens[oListBox1:nAt,8],;
_aItens[oListBox1:nAt,9],;
_aItens[oListBox1:nAt,10],;
_aItens[oListBox1:nAt,11] }}    
@ 070,251 BmpButton Type 1 Action RESTC031(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini, _nSlfim,aCombo,oListBox1,;
_oDlg,aCombo,cCombo,_cOpc,_oSalini,_oSaldfim,_cSltp,aCombo2,cCombo2,_cOpc2)
@ 070,299 BmpButton Type 6 Action RESTC033(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini, _nSlfim,aCombo,oListBox1,;
_oDlg,aCombo,cCombo,_cOpc,_oSalini,_oSaldfim,_cSltp,aCombo2,cCombo2,_cOpc2)
@ 070,345 BmpButton Type 2 Action Close(_odlg)
Activate Dialog _odlg Centered
    

RETURN(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini,;
 _nSlfim,aCombo,oListBox1,_oDlg,aCombo,cCombo,_cOpc,aCombo2,cCombo2,_cOpc2)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RESTA021 บAutor  ณDaniel Pelegrinelli บ Data ณ  12/15/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento do array de consulta.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - BRASCOLA                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION RESTC031(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini, _nSlfim,;
aCombo,oListBox1,_oDlg,aCombo,cCombo,_cOpc,_oSalini,_oSaldfim,_cSltp,aCombo2,cCombo2,_cOpc2)

Local _aSlini, _aSlfim

_cOpc := substr(cCombo,1,1) //Opcao do Combo  
_cOpc2 := substr(cCombo2,1,1) //Opcao do Combo2


//Seleciona os pricipais Registros
_cQryD5 := " SELECT D5_FILIAL FILIAL, Case When D5_ORIGLAN < '500' OR D5_ORIGLAN = 'MAN' then 'E' "
_cQryD5 += "                       When D5_ORIGLAN > '499' OR D5_ORIGLAN <> 'MAN'  then 'S' end as TP, "
_cQryD5 += " D5_PRODUTO PRODUTO, D5_LOCAL ARM, D5_DOC DOC, D5_OP OP, D5_DATA DATA, D5_ORIGLAN MOV,  "
_cQryD5 += " D5_QUANT QUANT, D5_LOTECTL LOTE, D5_DTVALID VALIDADE,D5_ESTORNO ESTORNO "
_cQryD5 += " FROM "+RETSQLNAME("SD5")+"  SD5  "
_cQryD5 += " WHERE D5_PRODUTO = '"+_cCod+"' "
_cQryD5 += " AND D5_FILIAL BETWEEN '"+_cFlde+"'AND '"+_cFlate+"' "
_cQryD5 += " AND D5_LOCAL  BETWEEN '" + _cArde + "' AND '" + _cArate + "' "
_cQryD5 += " AND D5_DATA   BETWEEN '"+dtos(_dDtde)+"' AND '"+dtos(_dDtate)+"' "
_cQryD5 += " AND D5_LOTECTL BETWEEN '"+_cLtde+"' AND '"+_cLtate+"' "

// Opcao de Nota Fiscal
If _cOpc $ "4"
	_cQryD5 += " AND D5_CLIFOR <> SPACE(6) "
Elseif _cOpc $ "2/3/5/6"
	_cQryD5 += " AND D5_CLIFOR = SPACE(6) "
Endif

//Opcao de Ordem de Producao
If _cOpc $ "2"
	_cQryD5 += " AND D5_OP <> SPACE(11) "
Elseif _cOpc $ "3/4/5"
	_cQryD5 += " AND D5_OP = SPACE(11) "
Endif

//Opcao de Transferencia
If _cOpc $ "5"
	_cQryD5 += " AND D5_ORIGLAN IN ('499','999')  "
Endif

//Exclui Deletados
_cQryD5 += " AND SD5.D_E_L_E_T_ <> '*' "   

If _cOpc2 $ "2" //LOCAL
_cQryD5 += " ORDER BY D5_FILIAL, D5_LOCAL,D5_DATA, D5_PRODUTO, D5_LOTECTL, D5_ORIGLAN "
Elseif _cOpc2 $ "3"   //DOC/OP
_cQryD5 += " ORDER BY D5_FILIAL, D5_DOC, D5_OP, D5_LOCAL, D5_PRODUTO, D5_LOTECTL, D5_ORIGLAN "
Else //DATA
_cQryD5 += " ORDER BY D5_FILIAL, D5_DATA, D5_LOCAL, D5_PRODUTO, D5_LOTECTL, D5_ORIGLAN "
Endif


DBUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryD5),"XSD5",.F.,.F.)

XSD5->(DBGOTOP())

If XSD5->(EOF())
	ALERT("Produto "+ALLTRIM(_cCod)+" sem Movimento ou Sem Controle de Lote !!","KARDEX")
	_aItens := {}
	
	AADD(_aItens,{"",;
	"",;
	"",;
	"",;
	"",;
	"",;
	"",;
	"",;
	0,;
	"",;
	"",;
	""})
	
ELSE
	
	_aItens := {}
	DO WHILE XSD5->(!EOF())
		
		_cQuant :=  Transform(XSD5->QUANT,"@E 9,999,999.999999")
		_dDtmov :=  STOD(XSD5->DATA)
		_dDtval :=  STOD(XSD5->VALIDADE)
		
		AADD(_aItens,{XSD5->FILIAL,;
		XSD5->TP,;
		XSD5->PRODUTO,;
		XSD5->ARM,;
		XSD5->DOC,;
		XSD5->OP,;
		_dDtmov,;
		XSD5->MOV,;
		_cQuant,;
		XSD5->LOTE,;
		_dDtval,;
		XSD5->ESTORNO})
		DBSKIP()
	ENDDO
ENDIF


If _cLtde == _cLtate .and. _cArde == _cArate
	_aSlini := CalcEstL(_cCod,_cArde,_dDtde,_cLtde,"","","")
	_aSlfim := CalcEstL(_cCod,_cArde,_dDtate+1,_cLtde,"","","")
	_nSlini := _aSlini[1]
	_nSlfim := _aSlfim[1]
	
	_cSltp := "LT"
	
Elseif _cArde == _cArate
	_aSlini    := CalcEst(_cCod,_cArde,_dDtde)
	_aSlfim    := CalcEst(_cCod,_cArde,_dDtate+1)
	_nSlini := _aSlini[1]
	_nSlfim := _aSlfim[1]
	_cSltp := "AR"
Else
	dbselectarea("SZ9")
	DBSETORDER(1)
	DBGOTOP()
	DO WHILE SZ9->(!EOF())
		_aSlini    := CalcEst(_cCod,Z9_COD,_dDtde)
		_aSlfim    := CalcEst(_cCod,Z9_COD,_dDtate+1)
		_nSlini := _aSlini[1] + _nSlini
		_nSlfim := _aSlfim[1] + _nSlfim
		SZ9->(DBSKIP())
	ENDDO
	DBSELECTAREA("SZ9")
	DBCLOSEAREA("SZ9")
	_cSltp := "PD"
Endif

@ 290,127 Say OemToAnsi("Sld Por:") Size 20,8 Object _oSltp
@ 290,155 Get _cSltp Size 10,10
@ 290,180 Say "Sld Ini:" Size 40,8 Object _oSalini
@ 290,200 Get _nSlini Size 76,10 PICTURE "@E 99,999,999,999.9999"
@ 290,285 Say "Sld Fim:" Size 40,8 Object _oSaldfim
@ 290,310 Get _nSlfim Size 76,10 PICTURE "@E 99,999,999,999.9999"

XSD5->(DBCLOSEAREA())

RESTAREA(aAreaAtu)

oListBox1:SetArray(_aItens)
oListBox1:refresh()
oListBox1:bLine := {|| {_aItens[oListBox1:nAt,1],;
_aItens[oListBox1:nAt,2],;
_aItens[oListBox1:nAt,3],;
_aItens[oListBox1:nAt,4],;
_aItens[oListBox1:nAt,5],;
_aItens[oListBox1:nAt,6],;
_aItens[oListBox1:nAt,7],;
_aItens[oListBox1:nAt,8],;
_aItens[oListBox1:nAt,9],;
_aItens[oListBox1:nAt,10],;
_aItens[oListBox1:nAt,11] }}

Return(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini, _nSlfim,aCombo,;
oListBox1,_oDlg,aCombo,cCombo,_cOpc,_oSalini,_oSaldfim,_cSltp,aCombo2,cCombo2,_cOpc2)

        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTA023  บAutor  ณMicrosiga           บ Data ณ  12/19/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do Kardex                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


Static Function RESTC033(_cCod,_aItens,aAreaAtu,_dDtde, _dDtate,;
_cLtde, _cLtate, _cFlde, _cFlate, _cArde, _cArate, _nSlini, _nSlfim,aCombo,;
oListBox1,_oDlg,aCombo,cCombo,_cOpc,_oSalini,_oSaldfim,_cSltp,aCombo2,cCombo2,_cOpc2)
 
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Kardex"
Local cPict          := ""
Local titulo       := "Kardex Por Lote"
Local nLin         := 80

Local Cabec1       := "Brascola"
Local Cabec2       := "Kardex - Lote - Consulta"
Local imprime      := .T.
Local aOrd := {}   

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RESTC033" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RESTC033" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SD5"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,_cCod,_aItens,	_nSlini,	_nSlfim,	_cSltp) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,_cCod,_aItens,_nSlini,_nSlfim,_cSltp)

Local nOrdem
Local _cMvent, _cMvsai
Local _nMvent, _nMvsai 

_nMvent := 0
_nMvsai := 0

/*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInforma os tres tipos de saldo - Produto (Filial-PR),ณ
//ณ Armazem(AR) e Lote (LT)                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*/


SetRegua(RecCount())

For n:=1 to len(_aItens)
 

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9   
    @nLin,000 PSAY "FIL"   
    @nLin,005 PSAY "TP"             
    @nLin,010 PSAY "PRODUTO"        
    @nLin,030 PSAY "ARM"            
    @nLin,040 PSAY "DOC / NF"       
    @nLin,055 PSAY "OP"             
    @nLin,072 PSAY "DATA"           
    @nLin,085 PSAY "MOV"        
    @nLin,100 PSAY "QUANT"       
    @nLin,120 PSAY "LOTE"         
    @nLin,130 PSAY "VALIDADE" 
    nLin ++
    @nLin,00 PSAY __PrtThinLine()
    nLin := nLin +1    
    
   Endif
                      
    @nLin,000 PSAY _aItens[n][1]
    @nLin,005 PSAY _aItens[n][2]    
    @nLin,010 PSAY _aItens[n][3]    
    @nLin,030 PSAY _aItens[n][4]    
    @nLin,040 PSAY _aItens[n][5]    
    @nLin,050 PSAY _aItens[n][6]    
    @nLin,070 PSAY _aItens[n][7]    
    @nLin,085 PSAY _aItens[n][8]
    @nLin,095 PSAY _aItens[n][9] 
    @nLin,118 PSAY _aItens[n][10]
    @nLin,130 PSAY _aItens[n][11]
    
   If valtype(_aItens[n][9]) == "C"
  		If  _aItens[n][2]  == "E"            
   		_nMvent := val(_aItens[n][9]) + _nMvent
 		Else   
   		_nMvsai := val(_aItens[n][9]) + _nMvsai
 		EndIf  
   Endif
   nLin := nLin + 1 // Avanca a linha de impressao

   Next   
   
   nLin ++                                            
     @nLin,00 PSAY __PrtThinLine()
   nLin ++
   
_cMvent := Transform(_nMvent,"@E 99,999,999,999.9999")
_cMvsai := Transform(_nMvsai,"@E 99,999,999,999.9999")

 @nLin,000 PSAY " Total de Entradas: "   
 @nLin,025 PSAY _cMvent   
 nLin ++
 @nLin,000 PSAY " Total de Saidas: "
 @nLin,025 PSAY _cMvsai         

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return(_cCod,_aItens,_nSlini,	_nSlfim,	_cSltp)