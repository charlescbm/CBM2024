#include "rwmake.ch"
#include "topconn.ch"
                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATA006 ºAutor  ³ Charles Medeiros   º Data ³  05/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para consultas de Etiquetas                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TFATA006()
*********************
PRIVATE aFixos := {}, aCores := {}, aIndexSB8 := {}, bFilSB8Brw
PRIVATE aRotina := {}, cCadastro := "CONTROLE ETIQUETAS", cFiltraSB8
   
//Monto variavel aRotina
////////////////////////
aAdd(aRotina,{"Pesquisar"  ,"AxPesqui"         ,0,1})
aAdd(aRotina,{"Visualizar" ,"u_BF004Visual"    ,0,2})
aAdd(aRotina,{"Parametros" ,"u_BF004Param"     ,0,3})
aAdd(aRotina,{"Legenda"    ,"u_BF004Legenda"   ,0,3})
aAdd(aRotina,{"Consultar" ,"u_BF004Transm"    ,0,4})

//Cores para o browse
/////////////////////
aCores := {	{ "B8_SALDO > 0", 'BR_VERDE' },;	//Lote com saldo
			{ "B8_SALDO < 0", 'BR_AMARELO' },; 	//Lote com problema
			{ "B8_SALDO == 0", 'BR_VERMELHO'}}	//Lote Sem Saldo

//Posiciono no arquivo correto
//////////////////////////////
dbSelectArea("SB8")
dbSetOrder(1)

//Solcito os paramentros da rotina
//////////////////////////////////
u_BF004Param()

DbSelectArea("SB8")
mBrowse(6,1,22,75,"SB8",,,,,,aCores)
EndFilBrw("SB8",aIndexSB8)

Return

User Function BF004Visual(cAlias,nReg,nOpcx)
***************************************
AxVisual(cAlias,nReg,nOpcx)
Return

User Function BF004Param(cAlias,nReg,nOpcx)
***************************************
LOCAL cPerg := "TFATA006", aRegs := {}

//Crio o grupo de perguntas
///////////////////////////
aadd(aRegs,{cPerg,"01","Mostrar Registros     ?","mv_ch1","N",01,0,0,"C","","MV_PAR01","Todos","","","Com Saldos","","","Sem Saldos","","","","","","","",""})
//aadd(aRegs,{cPerg,"02","Data Arrecadacao De   ?","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"03","Data Arrecadacao Ate  ?","mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"04","Produto de     ?","mv_ch4","C",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SB1"})
aadd(aRegs,{cPerg,"05","Produto Ate    ?","mv_ch5","C",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SB1"})
aadd(aRegs,{cPerg,"06","Lote       ?","mv_ch6","C",04,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"07","Lote Ate      ?","mv_ch7","C",04,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","",""})
//aadd(aRegs,{cPerg,"08","Estado Cliente De     ?","mv_ch8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","12"})
//aadd(aRegs,{cPerg,"09","Estado Cliente Ate    ?","mv_ch9","C",02,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","12"})
u_BXCriaPer(cPerg,aRegs)
If (nOpcx!=Nil)
	If !Pergunte(cPerg,.T.)
		Return .F.
	Endif
Else
	Pergunte(cPerg,.F.)
Endif
      
//Monto filtro arquivo de pedidos de compra
///////////////////////////////////////////
cFiltroSF8 := " !EMPTY(B8_PRODUTO)"
If (mv_par01 == 2) //Pendente Exportacao
	cFiltroSB8 += ".AND.(B8_SALDO > 0)"
Elseif (mv_par01 == 3) //Pendente Baixa Titulo
	cFiltroSB8 += ".AND.(B8_SALDO = 0)"
Endif
//If !Empty(mv_par02)
//	cFiltroSB8 += ".AND.(dtos(F6_DTARREC)>='"+dtos(mv_par02)+"')"
//Endif
//If !Empty(mv_par03)
//	cFiltroSB8 += ".AND.(dtos(F6_DTARREC)<='"+dtos(mv_par03)+"')"
//Endif
If !Empty(mv_par04)
	cFiltroSB8 += ".AND.(B8_PRODUTO>='"+mv_par04+"')"
Endif
If !Empty(mv_par05)
	cFiltroSB8 += ".AND.(B8_PRODUTO<='"+mv_par05+"')"
Endif
If !Empty(mv_par06)
	cFiltroSB8 += ".AND.(B8_LOTECTL ='"+mv_par06+"')"
Endif
/*
If !Empty(mv_par07)
	cFiltroSB8 += ".AND.(B8_LOTECTL<='"+mv_par07+"')"
Endif
If !Empty(mv_par08)
	cFiltroSF8 += ".AND.(F6_EST>='"+mv_par08+"')"
Endif
If !Empty(mv_par09)
	cFiltroSF8 += ".AND.(F6_EST<='"+mv_par09+"')"
Endif
*/
                           
//Aplico filtro e mostro o browse
/////////////////////////////////
dbSelectArea("SB8")
bFilSB8Brw := {|| FilBrowse("SB8",@aIndexSB8,@cFiltroSB8) }
Eval(bFilSB8Brw)

Return

User Function BF004Legenda(cAlias,nReg,nOpcx)
****************************************
LOCAL aCores := {{"BR_VERDE","GUIA Paga e Transmitida"},;
				{"BR_AMARELO","GUIA Pendente de Transmissao"},;
				{"BR_VERMELHO","GUIA Pendente de Pagamento"}}
BrwLegenda(cCadastro,"Legenda",aCores)
Return

User Function BF004Transm(cAlias,nReg,nOpcx)
****************************************
GNREON() //Transmissao da GUIA Online
Return