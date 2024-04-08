#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ MVALTPAR ³ Rotina para efetuar alteração em parâmetros                  º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 21.01.05 ³ Martinho                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 16.01.05 ³ Almir Bandina                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ xx/xx/xx - Consultor - Descricao.                                       º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
User Function MVALTPAR()

Local oDlgTit
//Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualização do Parâmetro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""

Local aRegs     := {}
Local cPerg     := U_CriaPerg("ALTPAR")

Private cParam	:= ""//"MV_DATAFIS"


aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro","","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
//  aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro"    ,"","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
lValidPerg(aRegs)
Pergunte(cPerg,.T.)

Do Case
	Case mv_par01==1
		cParam := "MV_DATAFIN"
		dbSelectArea("SE1")
		_cFilial := xFilial("SE1")
		SE1->(dbCloseArea())
	Case mv_par01==2
		cParam := "MV_DATAFIS"
		dbSelectArea("SF1")
		_cFilial := xFilial("SF1")
		SF1->(dbCloseArea())
		
EndCase

cTitulo	:= "Atualização do Parâmetro "+AllTrim(cParam) + " da Filial " + _cFilial

dbSelectArea("SX6")
dbSetOrder(1)
If !MsSeek(_cFilial+cParam)
	Aviso(	cTitulo,;
	"O parâmetro informado não foi localizado no cadastro! Contate o Administrador.",;
	{"&Ok"},,;
	"Parâmetro: "+AllTrim(cParam) )
Else
	cTexto1		:= SX6->X6_DESCRIC
	cTexto2		:= SX6->X6_DESC1
	cTexto3		:= SX6->X6_DESC2
	cTipo	    := SX6->X6_TIPO
	
	If   cTipo == "D"
		uConteudo	:= SToD(AllTrim(SX6->X6_CONTEUDO))
		
	ElseIf cTipo == "N"
		uConteudo	:= Val(AllTRim(SX6->X6_CONTEUDO))
	Else
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)
	EndIf
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 040,007 SAY "Informe o novo conteúdo para o parâmetro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuPar(uConteudo,cTipo), oDlgTit:End())
DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)

*/
******************************************************************************************************
Static Function AtuPar(uConteudo)
******************************************************************************************************

dbSelectArea("SX6")
Reclock("SX6",.F.)

If cTipo == "D"
	SX6->X6_CONTEUD := DToS(uConteudo)
ElseIf cTipo == "N"
	SX6->X6_CONTEUD := Str(uConteudo)
Else
	SX6->X6_CONTEUD	:= AllTrim(uConteudo)
Endif
MsUnlock()

Return(Nil)


//*************************************************
//  ALTERA PARAMETRO DA DADTA LIMITE FATURAMENTO
//  Rodolfo Gaboardi 19/11/2007
//**************************************************

User Function BFATA008()

Local oDlgTit
Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualização do Parâmetro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= 5000000.00
local _cCodFil := "  "
Local aRegs     := {}
//Local cPerg     := "ALTPAR"



//aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro","","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
//  aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro"    ,"","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
//lValidPerg(aRegs)
//Pergunte(cPerg,.T.)

cParam := "BR_METAFAT"
//_cCodFil:= ''
_cFilial := '  '


If  (AllTrim(cUsername) $ (GetMv("BR_000025")))
	
	cTitulo	:= "Atualização do Parâmetro "+AllTrim(cParam) + " da Filial " + _cFilial
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If MsSeek(_cFilial+cParam)
		
		cTexto1		:= SX6->X6_DESCRIC
		//cTexto2		:= SX6->X6_DESC1
		//cTexto3		:= SX6->X6_DESC2
		cTipo	    := SX6->X6_TIPO
		
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)   
		
		DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
	
		DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
		@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
		@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
		@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
		@ 040,007 SAY "Informe a meta referente ao mês:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
		@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
		DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
		DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
		ACTIVATE MSDIALOG oDlgTit CENTERED  
		
	Else  
	
		Aviso(	cTitulo,;
		"O parâmetro informado não foi localizado no cadastro! Contate o Administrador.",;
		{"&Ok"},,;
		"Parâmetro: "+AllTrim(cParam) )  
			
	EndIf
	

else
	
	Aviso(	"Alteração META DE FATURAMENTO - MAPA OPERACIONAL",;
	"Usuário sem acesso à esta rotina! Contate o Administrador do sistema.",;
	{"&Continua"},,;
	"Parametro BR_000025")
	
endif

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)  


******************************************************************************************************
Static Function AtuParf(uConteudo)
******************************************************************************************************
dbSelectArea("SX6")
Reclock("SX6",.F.)

SX6->X6_CONTEUD := (alltrim(uConteudo))

MsUnlock()   

MsgInfo("Meta alterado SUCESSO !!! ")

return .t.
