#include "rwmake.ch"  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATR13  ³ Autor ³ Marcos Eduardo Rocha     ³ Data ³ 04/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Analise Previsto x Realizado                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±³          ³                                                               ³±±
±±³ Alteracao³ 24.11.05 - Daniel Pelegrinelli                                ³±±
±±³          ³ Alterado Regiao para Grupo de Vendedor                        ³±±
±±³ Alteracao³ 06.12.05 - Daniel Pelegrinelli                                ³±±
±±³          ³ Pedidos Bloqueados apenas por credito - Req. usuario Peterson ³±±
±±³          ³ Informar nome dos Supervisores e Grupo no Totalizador.        ³±±
±±³          ³ Alteracao de Lay Out.                                         ³±±
±±³          ³ Utilizacao do parametro Grupo de / ate.                       ³±±
±±³ Alteracao³ 14.03.06 - Elias Reis                                         ³±±
±±³          ³ Inserir pergunta onde o usuario possa selecionar pedidos      ³±±
±±³          ³ que possuem movimento financeiro = SIM/NAO/AMBOS.             ³±±
±±³ Alteracao³ 06.06.06 - Luciano Lorenzetti                                 ³±±
±±³          ³ Inserir pergunta onde o usuario possa selecionar se deseja    ³±±
±±³          ³ apenas produtos do tipo "PA" ou TODOS.                        ³±±          
±±³          ³															     ³±±	
±±³ Alteracao³	12.04.07 - Elias Reis							  			  ³±±	
±±³          ³	Modificacao para dar ao usuario a opção de filtrar os vendedo-³±±	
±±³          ³	res bloqueados.           									  ³±±	
±±³          ³																  ³±±	
±±³          ³																  ³±±	
±±³          ³																  ³±±	
±±³          ³																  ³±±	
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATR13()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1     := "Este relatorio ira imprimir uma Analise de Vendas/Faturamento "
Local cDesc2     := " previsto x realizado."
Local cDesc3     := ""

Private cString  := "SC5"
Private Tamanho  := "G"
Private aReturn  := { "Zebrado",1,"Administracao",2,2,1,"",1 }
Private wnrel    := "RFATR13"
Private NomeProg := "RFATR13"
Private nLastKey := 0
Private Limite   := 220
Private Titulo   := "Analise Vendas Previstas x Realizadas"
Private cPerg    := U_CRIAPERG("FATR13")
Private nTipo    := 0
Private cbCont   := 0
Private cbTxt    := "registro(s) lido(s)"
Private Cabec1   := ""
Private Cabec2   := ""
Private Li       := 80
Private m_pag    := 1
Private aOrd     := {}
//Private cParSuper:= GetMv("BR_000014")//Parametro que define se o usuário logado tem direito a ver informações de outros Supervisores

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros do relatorio                                             ³
//³ mv_par01 - Emissao De                                               ³
//³ mv_par02 - Emissao Ate                                              ³
//³ mv_par03 - Data Refererencia Fat.Dia                                ³
//³ mv_par04 - Grupo De                                                 ³
//³ mv_par05 - Grupo Ate                                                ³
//³ mv_par06 - TES quanto ao faturamento                                ³
//³ mv_par07 - Considera somente PA                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas

aRegs := {}
aAdd(aRegs, { cPerg, "01","Emissao De             ?" , "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "mv_par01", ""				  , "", "", "", "", "", ""    , "", "", "", "" ,""     ,"","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "02","Emissao Ate            ?" , "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "mv_par02", ""				  , "", "", "", "", "", ""    , "", "", "", "" ,""     ,"","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "03","Data Referencia Fat.Dia?" , "", "", "mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", ""				  , "", "", "", "", "", ""    , "", "", "", "" ,""     ,"","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "04","Grupo De               ?" , "", "", "mv_ch4", "C", 06, 0, 0, "G", "", "mv_par04", ""				  , "", "", "", "", "", ""    , "", "", "", "" ,""     ,"","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "05","Grupo Ate              ?" , "", "", "mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", ""				  , "", "", "", "", "", ""    , "", "", "", "" ,""     ,"","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "06","TES qto faturamento    ?" , "", "", "mv_ch6", "N", 01, 0, 0, "C", "", "mv_par06", "Gera Financeiro", "", "", "", "", "Não Gera", "", "", "", "", "Ambos","","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "07","Considera somente PA   ?" , "", "", "mv_ch7", "N", 01, 0, 0, "C", "", "mv_par07", "Sim"			  , "", "", "", "", "Não"	  , "", "", "", "", ""	   ,"","","","","","","","","","","","","","","","","","" } )
aAdd(aRegs, { cPerg, "08","Filtra Vend.Bloq       ?" , "", "", "mv_ch8", "N", 01, 0, 0, "C", "", "mv_par08", "Sim"			  , "", "", "", "", "Não"	  , "", "", "", "", ""	   ,"","","","","","","","","","","","","","","","","","" } )

U_CriaSx1(aRegs)

Pergunte( cPerg, .f. )

wnrel:= SetPrint( cString, wnrel, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .F., "", .F., Tamanho, .F., .F. )

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estabelece os padroes para impressao, conforme escolha do usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se sera reduzido ou normal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4] == 1, 15, 18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se teclar ESC, sair³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama funcao que processa os dados. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| RFATR13A(@lEnd, wnrel, cString,nomeprog,Titulo) }, Titulo)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FATR13A  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 04.11.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RFATR13                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RFATR13A(lEnd,WnRel,cString,nomeprog,Titulo)

Local cQuery    := ""
Local cEol      := Chr(13)+Chr(10)
Local _cDgrupo  := ""
Local _cDgrupo, _cDsuper

Titulo += " - Emissao De " + Dtoc (mv_par01) + " Ate " + Dtoc (mv_par02)
Cabec1 := "  Repres.  Nome Representante            Vendas        Vendas          Vendas   Variacao    Qtde de         Peso         Pedidos         Pedidos     Faturamento      Devolucao     Media Valor"
Cabec2 := "                                      Previstas           Dia             Mes     (%)       Pedidos       Pedido      Bloqueados       Liberados          do Mes         no Mes      Por Pedido"
//           123456   12345678901234567890   9,999,999,999   999,999,999   9,999,999,999     9999     9999,999   999,999.99   9,999,999,999   9,999,999,999   9,999,999,999   9,999,999,999  9,999,999,999
//          0        10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210       220
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³            Posiciona no vendedor correspondente ao usuario             ³
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Fernando: Filtra Usuario Logado.
DbSelectArea('SA3')
DbSetOrder(7)

cCodRep := ""
DbSeek( xFilial("SA3") + __cUserID, .f. )

While !Eof() .And. ( AllTrim( __cUserId ) == AllTrim( A3_CODUSR ) )
	cCodRep+= AllTrim( SA3->A3_COD ) + '-'
	DbSkip()
EndDo

cCodRep:= Subs(	cCodRep, 1, Len ( cCodRep ) - 1 )

If (AllTrim(USRRETNAME(RETCODUSR())) $ GetMv("BR_000014"))//Parametro que define se o usuário logado tem direito a ver informações de outros Supervisores
	cCodRep:= '%'
EndIf

//**************************************************************************]


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Query para buscar os Pedidos de Venda                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Vendas Previstas x Faturadas
cQuery += " SELECT GRUPO, VEND, SUPER, SUM(TOTPREV) TOTPREV, SUM(TOTVDIA) TOTVDIA, SUM(TOTVMES) TOTVMES, SUM(QTDPED) QTDPED, SUM(TOTPESO) TOTPESO, SUM(TOTPEDB) TOTPEDB, SUM(TOTPEDL) TOTPEDL, SUM(TOTFAT) TOTFAT, SUM(TOTDEV) TOTDEV"+cEol
cQuery += " FROM ("+cEol

// Busca as Previsoes de Venda
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, SUM(SCT.CT_VALOR) TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, 0 TOTPEDB, 0 TOTPEDL, 0 TOTFAT, 0 TOTDEV "+cEol
cQuery += " FROM "+RetSqlName("SCT")+" SCT, "+RetSqlName("SA3")+" SA3"+cEol
cQuery += " WHERE SCT.CT_DATA BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SCT.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_COD = SCT.CT_VEND"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "  
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol
cQuery += " UNION ALL"+cEol
                                    
// Busca as Vendas do Mes
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, SUM(C6_VALOR) TOTVMES, 0 QTDPED, SUM(SC6.C6_QTDVEN*SB1.B1_PESO) TOTPESO, 0 TOTPEDB, 0 TOTPEDL, 0 TOTFAT, 0 TOTDEV"+cEol    
cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4, " + RetSqlName("SB1")+" SB1" + cEol 
cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SC5.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"+cEol
cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"+cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")

// Falta tratar os atendidos parcialmente
cQuery += " AND (SC6.C6_BLQ <> 'R ' OR SC6.C6_QTDENT > 0)"+cEol
cQuery += " AND SC6.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "  // Parametro de grupo de/ate - Daniel  
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado
cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"+cEol
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"+cEol
If mv_par06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol

// Trata produtos do Tipo 'PA'                  
If MV_PAR07 = 1
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.B1_TIPO = '3' " + cEol
EndIf
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol

cQuery += " UNION ALL"+cEol 

// Busca as Vendas do Dia
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, SUM(C6_VALOR) TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, 0 TOTPEDB, 0 TOTPEDL, 0 TOTFAT, 0 TOTDEV"+cEol
If mv_par07 = 1
	cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4, " + RetSqlName("SB1")+" SB1"  + cEol 
Else
	cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4" +cEol 
EndIf	
cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SC5.C5_EMISSAO = '"+Dtos(mv_par03)+"'"+cEol
cQuery += " AND SC5.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"+cEol
cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"+cEol
cQuery += " AND SC6.C6_BLQ <> 'R ' "
cQuery += " AND SC6.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' " 
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado
cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"+cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")

cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"+cEol   
If MV_PAR06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol
// Trata produtos do Tipo 'PA'                  
If MV_PAR07 = 1
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.B1_TIPO = '3' "+cEol
EndIf
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol
cQuery += " UNION ALL"+cEol
// Busca a Quantidade de Pedidos
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, COUNT(*) QTDPED, 0 TOTPESO, 0 TOTPEDB, 0 TOTPEDL, 0 TOTFAT, 0 TOTDEV"+cEol
cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3" +cEol 
cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SC5.C5_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SC5.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "  // Parametro de grupo de/ate - Daniel  
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado
cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"+cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND ( SELECT COUNT(*) "+ cEol 
If mv_par07 = 1
	cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4," + RetSqlName("SB1")+" SB1 " + cEol 
Else
	cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4 " + cEol 
EndIf                                     
cQuery += " 	WHERE SC6.C6_FILIAL = SC5.C5_FILIAL"+cEol
cQuery += " 	AND SC6.C6_NUM = SC5.C5_NUM"+cEol                
cQuery += " 	AND SC6.D_E_L_E_T_ = ''"+cEol
cQuery += " 	AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " 	AND SF4.F4_CODIGO = SC6.C6_TES"+cEol 
cQuery += " AND (SC6.C6_BLQ <> 'R ' OR SC6.C6_QTDENT > 0)"+cEol
If MV_PAR06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " 	AND SF4.D_E_L_E_T_ = '' "+cEol
If MV_PAR07 = 1
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD "+cEol
	cQuery += " AND SB1.D_E_L_E_T_ = ''"+cEol
	cQuery += " AND SB1.B1_TIPO = '3' "+cEol
EndIf                                              
cQuery += " ) > 0"+cEol
// Trata produtos do Tipo 'PA'                  
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol

cQuery += " UNION ALL"+cEol 

// Busca os Pedidos Bloqueados
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, SUM(SC9.C9_QTDLIB*SC9.C9_PRCVEN) TOTPEDB, 0 TOTPEDL, 0 TOTFAT, 0 TOTDEV"+cEol
If MV_PAR07 = 1
	cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SC9")+" SC9, " +  RetSqlName("SB1")+" SB1 "+ cEol 
Else
	cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SC9")+" SC9 " +  cEol 
EndIf
cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SC5.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "  // Parametro de grupo de/ate - Daniel 
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"+cEol
cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"+cEol
cQuery += " AND SC6.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"+cEol
If MV_PAR06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	

cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL"+cEol
cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM"+cEol
cQuery += " AND SC9.C9_ITEM = SC6.C6_ITEM"+cEol
cQuery += " AND SC9.C9_BLCRED NOT IN ('10','  ') "+cEol
cQuery +=  "AND SC6.C6_ENTREG BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SC9.D_E_L_E_T_ = ''"+cEol
If MV_PAR07 = 1
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.B1_TIPO = '3' "+cEol
EndIf
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol
cQuery += " UNION ALL"+cEol
// Busca os Pedidos Liberados
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, 0 TOTPEDB, SUM(SC9.C9_QTDLIB*SC9.C9_PRCVEN) TOTPEDL ,0 TOTFAT, 0 TOTDEV"+cEol
If MV_PAR07 = 1
	cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SC9")+" SC9, " + RetSqlName("SB1")+" SB1 " + cEol 
Else
	cQuery += " FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4, "+RetSqlName("SC9")+" SC9" + cEol 
EndIf
cQuery += " WHERE SC5.C5_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SC5.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' " 
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado
cQuery += " AND SA3.A3_COD = SC5.C5_VEND1"+cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SC6.C6_FILIAL = SC5.C5_FILIAL"+cEol
cQuery += " AND SC6.C6_NUM = SC5.C5_NUM"+cEol
cQuery += " AND SC6.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SC6.C6_TES"+cEol
If MV_PAR06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SC9.C9_FILIAL = SC6.C6_FILIAL"+cEol                                                                         
cQuery += " AND SC9.C9_PEDIDO = SC6.C6_NUM"+cEol
cQuery += " AND SC9.C9_ITEM = SC6.C6_ITEM"+cEol
cQuery += " AND SC9.C9_BLCRED IN ('  ') " +cEol
cQuery +=  "AND SC6.C6_ENTREG BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SC9.D_E_L_E_T_ = ''"+cEol
If MV_PAR07 = 1
	cQuery += " AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.B1_TIPO = '3' "+cEol
EndIf
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol 
cQuery += " UNION ALL"+cEol
// Busca o Faturamento do Mes
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, 0 TOTPEDB, 0 TOTPEDL, SUM(D2_VALBRUT) TOTFAT, 0 TOTDEV"+cEol
If MV_PAR07 = 1 
	cQuery += " FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4, " + RetSqlName("SB1")+" SB1 " + cEol 
Else
	cQuery += " FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4" + cEol 
EndIf	
cQuery += " WHERE SF2.F2_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SF2.F2_EMISSAO BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SF2.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL"+cEol
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC"+cEol
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE"+cEol
cQuery += " AND SD2.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado
cQuery += " AND SA3.A3_COD = SF2.F2_VEND1"+cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SD2.D2_TES"+cEol
If MV_PAR06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol
If MV_PAR07 = 1
	cQuery += " AND SD2.D2_COD = SB1.B1_COD AND SB1.B1_TIPO = '3' "+cEol
EndIf
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol
cQuery += " UNION ALL"+cEol 
// Busca as Devolucoes do Mes com Nota Fiscal Original amarrada
cQuery += " SELECT SA3.A3_GRPREP GRUPO, SA3.A3_COD VEND, SA3.A3_SUPER SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, 0 TOTPEDB, 0 TOTPEDL, 0 TOTFAT, SUM(D1_TOTAL)+SUM(D1_VALIPI) TOTDEV"+cEol
If MV_PAR07 = 1
cQuery += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4, " + RetSqlName("SB1")+" SB1 " + cEol 
Else
cQuery += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4" + cEol 
EndIf
cQuery += " WHERE SD1.D1_TIPO IN ('D','B')"+cEol
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SD1.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF2.F2_FILIAL = SD1.D1_FILIAL"+cEol
cQuery += " AND SF2.F2_DOC = SD1.D1_NFORI"+cEol
cQuery += " AND SF2.F2_SERIE = SD1.D1_SERIORI"+cEol
cQuery += " AND SF2.F2_TIPO NOT IN ('D','B')"+cEol
cQuery += " AND SF2.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SD2.D2_FILIAL = SF2.F2_FILIAL"+cEol
cQuery += " AND SD2.D2_DOC = SF2.F2_DOC"+cEol
cQuery += " AND SD2.D2_SERIE = SF2.F2_SERIE"+cEol
cQuery += " AND SD2.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SD2.D2_ITEM = SD1.D1_ITEMORI"+cEol
cQuery += " AND SA3.A3_FILIAL = '  '"+cEol
cQuery += " AND SA3.A3_COD = SF2.F2_VEND1"+cEol
cQuery += " AND SA3.A3_GRPREP BETWEEN '"+MV_PAR04+"' AND '"+MV_PAR05+"' "  
cQuery += " AND SA3.A3_SUPER LIKE '"+cCodRep+"' " //Fernando - Filtra supervisor conforme usuário logado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o filtro dos vendedores bloqueados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += IIf(mv_par08==1," AND SA3.A3_BLQ<>'1' ","")
cQuery += " AND SA3.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"+cEol
If MV_PAR06 == 1
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == 2
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SD2.D2_COD = SD1.D1_COD "+cEol                    
If MV_PAR07 = 1
	cQuery += " AND SD2.D2_COD = SB1.B1_COD AND SB1.B1_TIPO = '3' "+cEol
EndIf
cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol

// Busca as Devolucoes do Mes sem Nota Fiscal Original amarrada
/*/
cQuery += " SELECT '999999' GRUPO, '999999' VEND, '999999' SUPER, 0 TOTPREV, 0 TOTVDIA, 0 TOTVMES, 0 QTDPED, 0 TOTPESO, 0 TOTPEDB, 0 TOTPEDL, 0 TOTFAT, ISNULL(D1_TOTAL,0) TOTDEV"+cEol
cQuery += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SF4")+" SF4"+cEol
cQuery += " WHERE SD1.D1_FILIAL = '01'"+cEol
cQuery += " AND SD1.D1_TIPO IN ('D','B')"+cEol
cQuery += " AND SD1.D1_DTDIGIT BETWEEN '"+Dtos(mv_par01)+"' AND '"+Dtos(mv_par02)+"'"+cEol
cQuery += " AND SD1.D1_NFORI = '      '"
cQuery += " AND SD1.D_E_L_E_T_ = ''"+cEol
cQuery += " AND SF4.F4_FILIAL = '  '"+cEol
cQuery += " AND SF4.F4_CODIGO = SD1.D1_TES"+cEol
If MV_PAR06 == '1'
	cQuery += " AND SF4.F4_DUPLIC = 'S'"+cEol
ElseIf  MV_PAR06 == '2'
	cQuery += " AND SF4.F4_DUPLIC = 'N'"+cEol
EndIf	
cQuery += " AND SF4.D_E_L_E_T_ = ''"+cEol
/*/
//cQuery += " GROUP BY SA3.A3_GRPREP, SA3.A3_COD, SA3.A3_SUPER"+cEol

cQuery += " ) GERAL"+cEol
cQuery += " GROUP BY GRUPO, VEND, SUPER"+cEol
cQuery += " ORDER BY GRUPO, VEND, SUPER"+cEol

//MemoWrite("\QUERYSYS\RFATR13.SQL",cQuery)
dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "QUERY", .T., .F. )

nGerPrev := 0
nGerVDia := 0
nGerVMes := 0
nGerQtdPV:= 0
nGerPeso := 0
nGerPedB := 0
nGerPedL := 0
nGerFat  := 0
nGerDev  := 0
aGRUPO   := {}
aSuper   := {}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta uma matriz para tratar as informacoes pra se manter informado. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("QUERY")
DbGoTop()

SetRegua( RecCount() )

While !Eof()
	IncRegua()

	If Li > 55
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo,, .f. )
	Endif
   
	nRegPrev  := 0
	nRegVDia  := 0
	nRegVMes  := 0
	nRegQtdPV := 0
	nRegPesoPV:= 0
	nRegPedB  := 0
	nRegPedL  := 0
	nRegFat   := 0
	nRegDev   := 0

	cGRUPO:= QUERY->GRUPO

	@ Li, 000 PSay "Grupo : " + QUERY->GRUPO + " - " + ALLTRIM( Posicione( "ACA", 1, xFilial( "ACA" ) + cGRUPO, "ACA_DESCRI" ) )

	Li+2

	While !Eof() .And. QUERY->GRUPO == cGRUPO
	
		If Li > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo,,.F.)
		Endif

       // "  Repres.  Nome Representante            Vendas        Vendas          Vendas   Variacao    Qtde de         Peso         Pedidos         Pedidos     Faturamento      Devolucao     Media Valor"
       // "                                      Previstas           Dia             Mes     (%)       Pedidos       Pedido      Bloqueados       Liberados          do Mes         no Mes      Por Pedido"
       //    123456   12345678901234567890   9,999,999,999   999,999,999   9,999,999,999    99999     9999,999   999,999.99   9,999,999,999   9,999,999,999   9,999,999,999   9,999,999,999  9,999,999,999
       //   0        10        20        30        40        50        60        70        80        90        100       110       120       130        140       150       160       170       180       190       200       210       220
       //   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		@ ++Li, 001 PSay QUERY->VEND
		@   Li, 010 PSay Left( Posicione("SA3", 1, xFilial("SA3") + QUERY->VEND, "A3_NOME" ), 20 )
		@   Li, 033 PSay QUERY->TOTPREV  Picture "@E 9,999,999.99"
		@   Li, 049 PSay QUERY->TOTVDIA  Picture "@E 9,999,999.99"
		@   Li, 063 PSay QUERY->TOTVMES  Picture "@E 9,999,999.99"
		If QUERY->TOTPREV > 0
			@ Li, 080 PSay ( ( QUERY->TOTVMES / QUERY->TOTPREV ) -1 ) * 100 Picture "99999"
        Else
			@ Li, 080 PSay 0 Picture "99999"
		EndIf	
		@   Li, 090 PSay QUERY->QTDPED   Picture "@E 9,999,999.99"
		@   Li, 101 PSay QUERY->TOTPESO  Picture "@E 9,999,999.99"
		@   Li, 114 PSay QUERY->TOTPEDB  Picture "@E 9,999,999.99"
		@   Li, 130 PSay QUERY->TOTPEDL  Picture "@E 9,999,999.99"
		@   Li, 146 PSay QUERY->TOTFAT   Picture "@E 9,999,999.99"
		@   Li, 162 PSay QUERY->TOTDEV   Picture "@E 9,999,999.99"
		@   Li, 177 PSay QUERY->TOTVMES / QUERY->QTDPED   Picture "@E 9,999,999.99"

		nRegPrev  += QUERY->TOTPREV
		nRegVDia  += QUERY->TOTVDIA
		nRegVMes  += QUERY->TOTVMES
		nRegQtdPV += QUERY->QTDPED
		nRegPesoPV+= QUERY->TOTPESO
		nRegPedB  += QUERY->TOTPEDB
		nRegPedL  += QUERY->TOTPEDL
		nRegFat   += QUERY->TOTFAT
		nRegDev   += QUERY->TOTDEV

	    cSuper:= QUERY->SUPER
		nPos  := aScan( aSuper, {|x| AllTrim(x[1])==AllTrim( cSuper ) } )

		If nPos == 0
			Aadd( aSuper, { cSuper, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
			nPos:= Len( aSuper )
		EndIf

		aSuper[nPos, 2]+= QUERY->TOTPREV
		aSuper[nPos, 3]+= QUERY->TOTVDIA
		aSuper[nPos, 4]+= QUERY->TOTVMES
		aSuper[nPos, 5]+= QUERY->QTDPED
		aSuper[nPos, 6]+= QUERY->TOTPEDB
		aSuper[nPos, 7]+= QUERY->TOTPEDL
		aSuper[nPos, 8]+= QUERY->TOTFAT
		aSuper[nPos, 9]+= QUERY->TOTDEV
		aSuper[nPos,10]+= QUERY->TOTPESO

	   DbSkip()

	EndDo

	nPos:= aScan( aGRUPO, {|x| AllTrim(x[1]) == AllTrim(cGRUPO) } )

	If nPos == 0
		Aadd( aGRUPO, { cGRUPO, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } )
		nPos := Len(aGRUPO)
	EndIf

	aGRUPO[nPos, 2]+= nRegPrev
	aGRUPO[nPos, 3]+= nRegVDia
	aGRUPO[nPos, 4]+= nRegVMes
	aGRUPO[nPos, 5]+= nRegQtdPV
	aGRUPO[nPos, 6]+= nRegPedB
	aGRUPO[nPos, 7]+= nRegPedL
	aGRUPO[nPos, 8]+= nRegFat
	aGRUPO[nPos, 9]+= nRegDev
	aGRUPO[nPos,10]+= nRegPesoPV

	@ ++Li, 000 PSay "Total Grupo " + cGRUPO 
	@   Li, 033 PSay nRegPrev  Picture "@E 9999999.99"
	@   Li, 049 PSay nRegVDia  Picture "@E 9999999.99"
	@   Li, 063 PSay nRegVMes  Picture "@E 9999999.99"
	If nRegPrev > 0
		@ Li, 080 PSay ( ( nRegVMes / nRegPrev ) -1 ) * 100 Picture "99999"
     Else
		@ Li, 080 PSay 0 Picture "99999"
	EndIf	
	@   Li, 090 PSay nRegQtdPV  Picture "@E 9999999.99"
	@   Li, 101 PSay nRegPesoPV Picture "@E 9999999.99"
	@   Li, 114 PSay nRegPedB   Picture "@E 9999999.99"
	@   Li, 130 PSay nRegPedL   Picture "@E 9999999.99"
	@   Li, 146 PSay nRegFat    Picture "@E 9999999.99"
	@   Li, 162 PSay nRegDev    Picture "@E 9999999.99"
	@   Li, 177 PSay nRegVMes / nRegQtdPV Picture "@E 9,999,999.99"
	    
	@ ++li, 000 Psay __PrtThinLine()
	 		
	li+= 2
	 
	nGerPrev += nRegPrev
	nGerVDia += nRegVDia
	nGerVMes += nRegVMes
	nGerQtdPV+= nRegQtdPV
	nGerPeso += nRegPesoPV
	nGerPedB += nRegPedB
	nGerPedL += nRegPedL
	nGerFat  += nRegFat
	nGerDev  += nRegDev
	
EndDo
	
If Li <> 80
			
	@ Li, 055 PSay " -  T O T A L      G E R A L  -   "
	
	++Li

	@ ++Li, 033 PSay nGerPrev  Picture "@E 9,999,999.99"
	@   Li, 049 PSay nGerVDia  Picture "@E 9,999,999.99"
	@   Li, 063 PSay nGerVMes  Picture "@E 9,999,999.99"
	If nGerPrev > 0
		@  Li, 080 PSay ( ( nGerVMes / nGerPrev ) -1 ) * 100 Picture "99999"
     Else
		@  Li, 080 PSay 0 Picture "99999"
	EndIf	
	@   Li, 090 PSay nGerQtdPV Picture "@E 9,999,999.99"
	@   Li, 101 PSay nGerPeso  Picture "@E 9,999,999.99"
	@   Li, 114 PSay nGerPedB  Picture "@E 9,999,999.99"
	@   Li, 130 PSay nGerPedL  Picture "@E 9,999,999.99"
	@   Li, 146 PSay nGerFat   Picture "@E 9,999,999.99"
	@   Li, 162 PSay nGerDev   Picture "@E 9,999,999.99"
	@   Li, 177 PSay nGerVMes / nGerQtdPV Picture "@E 9,999,999.99"
	
	@ ++li, 000 Psay __PrtThinLine()

EndIf

DbSelectArea("QUERY")
DbCloseArea()

Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo,, .f. )

For nProc:= 1 To Len( aGRUPO )
	If li > 80
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo,, .f.)
	EndIf
		If nProc == 1
			@ ++Li, 010 PSay "   Resumo por Grupo   "
			@ ++Li, 010 PSay "   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  "
		EndIf	
		
		_cDgrupo:= SUBSTR( ALLTRIM( Posicione( "ACA", 1, xFilial("ACA") + aGRUPO[nProc,1], "ACA_DESCRI" ) ), 1, 26 )

		If Empty( _cDgrupo )
			_cDgrupo := "- SEM GRUPO"
		Endif  
		
		@ ++Li, 001 PSay _cDgrupo
		@   Li, 033 PSay aGRUPO[nProc,2] Picture "@E 9,999,999.99"
		@   Li, 049 PSay aGRUPO[nProc,3] Picture "@E 9,999,999.99"
		@   Li, 063 PSay aGRUPO[nProc,4] Picture "@E 9,999,999.99"
		If aGRUPO[nProc,2] > 0
		     @ Li, 080 PSay ((aGRUPO[nProc,4]/aGRUPO[nProc,2])-1)*100 Picture "9999"
	     Else
			@  Li, 080 PSay 0 Picture "9999"
		EndIf	
		@  Li, 090 PSay aGRUPO[nProc, 5] Picture "@E 9,999,999.99"
		@  Li, 101 PSay aGRUPO[nProc,10] Picture "@E 9,999,999.99"
		@  Li, 114 PSay aGRUPO[nProc, 6] Picture "@E 9,999,999.99"
		@  Li, 130 PSay aGRUPO[nProc, 7] Picture "@E 9,999,999.99"
		@  Li, 146 PSay aGRUPO[nProc, 8] Picture "@E 9,999,999.99"
		@  Li, 162 PSay aGRUPO[nProc, 9] Picture "@E 9,999,999.99"
		@  Li, 177 PSay aGRUPO[nProc, 4] / aGRUPO[nProc,5] Picture "@E 9,999,999.99"

Next

For nProc := 1 To Len( aSuper )
   If nProc == 1
		++Li
		@ ++Li, 010 PSay "   Resumo por Supervisor   "
		@ ++Li, 010 PSay "   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  "
	EndIf	  
	    
	_cDsuper:= ALLTRIM( Posicione("SA3", 1, xFilial("SA3") + aSuper[nProc,1], "A3_NOME" ) )

	If Empty( _cDsuper )
		_cDsuper := "- SEM SUPERVISOR "
	EndIf  

  	@ ++Li, 001 PSay _cDsuper
	@   Li, 033 PSay aSuper[nProc, 2] Picture "@E 9,999,999.99"
	@   Li, 049 PSay aSuper[nProc, 3] Picture "@E 9,999,999.99"
	@   Li, 063 PSay aSuper[nProc, 4] Picture "@E 9,999,999.99"
	If aSuper[nProc,2] > 0
		@  Li, 080 PSay ((aSuper[nProc,4] / aSuper[nProc,2] ) -1 ) * 100 Picture "9999"
     Else
		@  Li, 080 PSay 0 Picture "9999"
	EndIf	
	@  Li, 090 PSay aSuper[nProc, 5] Picture "@E 9,999,999.99"
	@  Li, 101 PSay aSuper[nProc,10] Picture "@E 9,999,999.99"
	@  Li, 114 PSay aSuper[nProc, 6] Picture "@E 9,999,999.99"
	@  Li, 130 PSay aSuper[nProc, 7] Picture "@E 9,999,999.99"
	@  Li, 146 PSay aSuper[nProc, 8] Picture "@E 9,999,999.99"
	@  Li, 162 PSay aSuper[nProc, 9] Picture "@E 9,999,999.99"
	@  Li, 177 PSay aSuper[nProc, 4] / aSuper[nProc,5] Picture "@E 9,999,999.99"
Next

If aReturn[5] == 1
	dbCommitAll()
	ourspool(wnRel)
EndIf

Ms_Flush()

Return