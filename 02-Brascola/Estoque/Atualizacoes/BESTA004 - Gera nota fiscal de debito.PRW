#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"        

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA003         AUTOR:                         DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Gera nota fiscal de debito de frete

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/
 
User Function BESTA004()     

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := ""
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Local _aArea		 := GetArea()    
Local _aStruct		 := {}
Local _cQuery1 		 := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := ""
Private cIndTXL   	 := CriaTrab("", .f.)
Private cIndArq    	 := CriaTrab("", .f.)
Private cPerg        := U_CriaPerg("GENFDEB")
Private _aMeses      := {"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}

ValPergunte(cPerg)

Pergunte(cPerg, .t.)

/*
Nota D�bito   Emiss�o    FNC Origem   Transportadora   CNPJ   NF Origem   Data NF Origem    Motivo    C�d.Produto   Descri��o 	 Quantidade   Vl.un.merc.  IPI(%)   Val.IPI   Vlr N.Dev.    Valor Total    Dias     Vl Prorr.    Vlr c/ IPI      Aliq. Inter.do Est.    Vl.ICMS 1 	  Aliq.Inter Estadual    Vl. ICMS 2    Diferen�a    Quinz.    M�s
*/

aAdd(_aStruct, {"NFDEBITO"   , "C",  09, 0})
aAdd(_aStruct, {"EMISSAO"    , "D",  08, 0}) 
aAdd(_aStruct, {"FNCORIGEM"  , "C",  20, 0})
aAdd(_aStruct, {"TRANSPORTA" , "C",  40, 0})
aAdd(_aStruct, {"CNPJ"       , "C",  14, 0})
aAdd(_aStruct, {"NFORIGEM"   , "C",  09, 0})
aAdd(_aStruct, {"DTNFORIGEM" , "D",  08, 0})
aAdd(_aStruct, {"MOTIVO"     , "C", 100, 0})
aAdd(_aStruct, {"VALNFDEBIT" , "N",  14, 2})
aAdd(_aStruct, {"VALORTOTAL" , "N",  14, 2})
aAdd(_aStruct, {"DIAS"       , "N",  05, 0})
aAdd(_aStruct, {"VALPRORROG" , "N",  14, 2})
aAdd(_aStruct, {"VALCOMIPI"  , "N",  14, 2})
aAdd(_aStruct, {"ALIQESTADO" , "N",  06, 2})
aAdd(_aStruct, {"VALIPI"     , "N",  14, 2})
aAdd(_aStruct, {"VALICMS1"   , "N",  14, 2})
aAdd(_aStruct, {"ALIQIESTAD" , "N",  06, 2})
aAdd(_aStruct, {"VALICMS2"   , "N",  14, 2})
aAdd(_aStruct, {"DIFERENCA"  , "N",  14, 2})
aAdd(_aStruct, {"QUINZENA"   , "C",  25, 0})
aAdd(_aStruct, {"MES"        , "C",  20, 0})

cArqTXL := CriaTrab(_aStruct, .t.)
dbUseArea(.T.,"DBFCDX",cArqTXL,"TXL" ,.F.)
 

_cQuery:= "SELECT QI2.QI2_FNC,     "
_cQuery+= "       QI2.QI2_OCORRE,  " 
_cQuery+= "       QI2.QI2_X_NTOR,  "                                   
_cQuery+= "       QI2.QI2_X_TRAN,  "                                   
_cQuery+= "       QI2.QI2_X_MT,    "
_cQuery+= "       QI2.QI2_X_DIAS,  "
_cQuery+= "       QI2.QI2_CODCLI,  "         
_cQuery+= "       QI2.QI2_LOJCLI,  "
_cQuery+= "       SF2.F2_EMISSAO,  "          
_cQuery+= "       SF2.F2_VALBRUT,  "
_cQuery+= "       SF2.F2_VALIPI,   "
_cQuery+= "       SF2.F2_VALICM    " 
_cQuery+= "FROM QI2010 QI2, SF2010 SF2       "
_cQuery+= "WHERE QI2_FILIAL = SF2.F2_FILIAL  "
_cQuery+= "  AND QI2.QI2_X_NTOR <> ''        "
_cQuery+= "  AND QI2.QI2_X_NTOR = SF2.F2_DOC "
_cQuery+= "  AND SF2.F2_SERIE = '5'          "
_cQuery+= "  AND QI2.QI2_CODEFE  IN ('028','001')         "
_cQuery+= "  AND QI2.QI2_OCORRE BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
_cQuery+= "  AND SF2.D_E_L_E_T_='' "        
_cQuery+= "  AND QI2.D_E_L_E_T_='' "       
_cQuery+= "ORDER BY 1,3            "
 
TcQuery _cQuery New Alias "TMP"


cNumNFD:= GetMV("BR_000094")  //sequencial 

DbSelectArea("TMP")
DbGoTop()

While !Eof()
	dbSelectArea("SA4")
	dbSetOrder(1)
	MSSeek(xFilial("SA4")+TMP->QI2_X_TRAN)
		
	dbSelectArea("TXL")
	RecLock("TXL",.t.)
   
	TXL->NFDEBITO  := cNumNFD
	TXL->EMISSAO   := StoD(TMP->QI2_OCORRE)
	TXL->FNCORIGEM := TMP->QI2_FNC
	TXL->TRANSPORTA:= SA4->A4_NOME
	TXL->CNPJ      := SA4->A4_CGC
	TXL->NFORIGEM  := TMP->QI2_X_NTOR
	TXL->DTNFORIGEM:= StoD(TMP->F2_EMISSAO)
	TXL->MOTIVO    := TMP->QI2_X_MT
	TXL->DIAS      := TMP->QI2_X_DIAS
	TXL->VALORTOTAL:= TMP->F2_VALBRUT
	TXL->VALPRORROG:= (TMP->F2_VALBRUT * TMP->QI2_X_DIAS * 0.067/100) + 3.8
	TXL->VALNFDEBIT:= TXL->VALPRORROG + TMP->F2_VALICM + TMP->F2_VALIPI
	TXL->VALIPI    := TMP->F2_VALIPI
	TXL->VALICMS1  := TMP->F2_VALICM
	TXL->VALCOMIPI := 0  //
	TXL->ALIQESTADO:= 0  //
	TXL->ALIQIESTAD:= 0  //
	TXL->VALICMS2  := 0  //
	TXL->DIFERENCA := 0  //
	TXL->QUINZENA  := Iif( Day(StoD(TMP->QI2_OCORRE))<16,"1a QUINZENA-","2a QUINZENA")+"MES "+SubStr(TMP->QI2_OCORRE,5,2)+"/"+SubStr(TMP->QI2_OCORRE,1,4)
	TXL->MES       := _aMeses[Val(SubStr(TMP->QI2_OCORRE,5,2))]+"/"+SubStr(TMP->QI2_OCORRE,3,2)
   
	cNumNFD:= Soma1(cNumNFD) //incrementa sequencial

    MSUnlock()
    
    DbSelectArea("TMP")
    Dbskip()
EndDo


DbSelectarea("SX6")
DbSetOrder(1)
If DbSeek("  BR_000094")	
	If RecLock("SX6",.F.)
		Replace X6_CONTEUD With cNumNFD
		MSUnlock()
	EndIf
EndIf


DbSelectArea("TXL")        
DbGoTop()


U_ProcExcel("TXL")


TXL->(DbCloseArea())
TMP->(DbCloseArea())

RestArea(_aArea)

Return
 
   
 
Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)
aRegs:= {}
//          Grupo/Ordem/Pergunta/                       Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture /ID
aAdd(aRegs,{cPerg,"01" ,"Data De? "              ,"","","mv_ch1","D" ,8      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"02" ,"Data Ate?"              ,"","","mv_ch2","D" ,8      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,""     ,""})

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