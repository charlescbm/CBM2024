#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATC13   ºAutor  ³Elias Reis          º Data ³  06/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Este relatorio fornece dados para analise de rentabilidade º±±
±±º          ³ dos produtos.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ronaldo Lima - Controladoria                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                           
User Function RFATC13()  

Processa({ ||RFATC131()}, "Aguarde",,.t.)

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATC131 ³ Autor ³                          ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RFATC131()

Local cQuery 	:= ""
Local aRegs  	:= {}
Local cPerg  	:= U_CriaPerg("FATC13")
Local aTRBP		:= {}
Local nTotRegs := 0
Local nHoraMOD := GetMv("BR_000018") 

Private aCusRep := {}  
Private dInicio 
Private dFinal 
pRIVATE cTesNFE := ""
Private lAntigo := .F.
Private hor1321
PRIVATE hor1322
PRIVATE hor1323
PRIVATE hor1324
PRIVATE hor1355

Aadd(aRegs,{cPerg,"01","Emissao de ?"          ,"","","mv_ch1","D",08,0,0,"G","","mv_par01",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"" ,"","",""})
Aadd(aRegs,{cPerg,"02","Emissao até ?"         ,"","","mv_ch2","D",08,0,0,"G","","mv_par02",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"" ,"","",""})
Aadd(aRegs,{cPerg,"03","Quanto ao Tes ?"       ,"","","mv_ch3","N",01,0,1,"C","","mv_par03","Gera Dupl." ,"","","","","Nao Gera Dupl" ,"","","","","Todos" ,"","","","","","","","","","","","","",""    ,"S","","",""})
Aadd(aRegs,{cPerg,"04","Somente PA ?"          ,"","","mv_ch4","N",01,0,1,"C","","mv_par04","Sim       " ,"","","","","Nao          " ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"S","","",""})
Aadd(aRegs,{cPerg,"05","Produto De ?"          ,"","","mv_ch5","C",15,0,0,"G","","mv_par05",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","","SB1" ,"" ,"","",""})
Aadd(aRegs,{cPerg,"06","Produto Até?"          ,"","","mv_ch6","C",15,0,0,"G","","mv_par06",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","","SB1" ,"" ,"","",""})
Aadd(aRegs,{cPerg,"07","NFiscal De ?"          ,"","","mv_ch7","C",09,0,0,"G","","mv_par07",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"" ,"","",""})
Aadd(aRegs,{cPerg,"08","NFiscal Até?"          ,"","","mv_ch8","C",09,0,0,"G","","mv_par08",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"" ,"","",""})
Aadd(aRegs,{cPerg,"09","Desconsidera TES NFS?" ,"","","mv_ch9","C",20,0,0,"G","","mv_par09",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"" ,"","",""})
Aadd(aRegs,{cPerg,"10","Desconsidera TES NFE?" ,"","","mv_cha","C",20,0,0,"G","","mv_par10",""           ,"","","","",""              ,"","","","",""      ,"","","","","","","","","","","","","",""    ,"" ,"","",""})

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
   Return
EndIf     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajusta o conteudo das variaveis de data para que ³
//³possam ser reutilizados os seus conteudos        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dInicio := mv_par01
dFinal  := mv_par02
cTesNFE := AllTrim(mv_par10)
hor1321:=mv_par11
hor1322:=mv_par12
hor1323:=mv_par13
hor1324:=mv_par14
hor1355:=mv_par15


/*
Aadd(aTRBP,{"CODIGO"     ,"C",015,0})
Aadd(aTRBP,{"DESCRICAO"  ,"C",050,0})
Aadd(aTRBP,{"QTDA"       ,"N",016,0})
Aadd(aTRBP,{"VLRBRUTO"   ,"N",016,0})
Aadd(aTRBP,{"PMEDIO"     ,"N",016,6})
Aadd(aTRBP,{"ICMS"       ,"N",016,6})
Aadd(aTRBP,{"COFINS"     ,"N",016,6})
Aadd(aTRBP,{"PIS"        ,"N",016,6})
Aadd(aTRBP,{"IMPOSTO"    ,"N",016,6})
Aadd(aTRBP,{"VLRLIQUIDO" ,"N",016,6})
Aadd(aTRBP,{"MP"         ,"N",016,6})
Aadd(aTRBP,{"EMBALAGE"   ,"N",016,6})
Aadd(aTRBP,{"MO"         ,"N",016,6})
Aadd(aTRBP,{"TOTAL"      ,"N",016,6})
Aadd(aTRBP,{"MARGEM_VLR" ,"N",016,6})
Aadd(aTRBP,{"MARGEM_PRC" ,"N",016,6}) 
*/
Aadd(aTRBP,{"CODIGO"     ,"C",015,0})
Aadd(aTRBP,{"DESCRICAO"  ,"C",050,0})
Aadd(aTRBP,{"QTDA"       ,"N",016,0})
Aadd(aTRBP,{"VLRBRUTO"   ,"N",016,0})
Aadd(aTRBP,{"PMEDIO"     ,"N",016,2})
Aadd(aTRBP,{"ICMS"       ,"N",016,2})
Aadd(aTRBP,{"COFINS"     ,"N",016,2})
Aadd(aTRBP,{"PIS"        ,"N",016,2})
Aadd(aTRBP,{"IMPOSTO"    ,"N",016,2})
Aadd(aTRBP,{"VLRLIQUIDO" ,"N",016,2})
Aadd(aTRBP,{"MP"         ,"N",016,2})
Aadd(aTRBP,{"EMBALAGE"   ,"N",016,2})
Aadd(aTRBP,{"MO"         ,"N",016,2})
Aadd(aTRBP,{"TOTAL"      ,"N",016,2})
Aadd(aTRBP,{"MARGEM_VLR" ,"N",016,2})
Aadd(aTRBP,{"MARGEM_PRC" ,"N",016,2}) 
*/
_cArqCbc := CriaTrab(aTRBP,.T.)
dbUseArea( .T.,,_cArqCbc, "TRBP", .F., .F. )
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a opcao seja selecionar dados sinteticos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " SELECT BM_DESC,
cQuery += "        D2_COD, 
cQuery += "        B1_DESC,
cQuery += "        SUM(D2_QUANT)   QUANT, 
cQuery += "        SUM(D2_VALBRUT) VLR_BRUTO, 
cQuery += "        SUM(D2_TOTAL) / SUM(CASE WHEN D2_QUANT>0 THEN D2_QUANT ELSE 1 END ) P_MEDIO,
cQuery += "        SUM(D2_VALICM)  ICMS, 
cQuery += "        SUM(D2_VALIMP5) COFINS,
cQuery += "        SUM(D2_VALIMP6) PIS,
cQuery += "        SUM(D2_VALICM+D2_VALIMP5+D2_VALIMP6) IMPOSTO,
cQuery += "        SUM(D2_VALBRUT-(D2_VALICM+D2_VALIMP5+D2_VALIMP6)) VLR_LIQUID
cQuery += " FROM "+RetSQLName("SD2")+ " SD2 , "+RetSQLName("SB1")+" SB1 LEFT JOIN "+RetSQLName("SBM")+" SBM ON B1_GRUPO=BM_GRUPO AND SBM.D_E_L_E_T_=''
cQuery += " WHERE
cQuery += "     D2_TIPO NOT IN ('D','B')
cQuery += " AND D2_EMISSAO BETWEEN '"+dtos(dinicio)+"' AND '"+dtos(dfinal)+"'"
cQuery += " AND SD2.D_E_L_E_T_=''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtra somente os itens que geram duplicatas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par03 == 1 
	cQuery += " AND D2_TES IN (SELECT F4_CODIGO FROM "+RetSQLName("SF4")+" SF4 WHERE F4_CODIGO=D2_TES AND F4_DUPLIC IN ('1','S') AND SF4.D_E_L_E_T_='')
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtra somente os PA's³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par04 == 1 
	cQuery += " AND D2_TP='3'
EndIf                                                                                  
cQuery += " AND D2_COD=B1_COD
cQuery += " AND SB1.D_E_L_E_T_='' 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Intervalo de produtos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " AND D2_COD >= '"+If(AllTrim(mv_par05)=="",Space(15),         AllTrim(mv_par05))+"'"
cQuery += " AND D2_COD <= '"+If(AllTrim(mv_par06)=="","ZZZZZZZZZZZZZZZ", AllTrim(mv_par06))+"'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Intervalo de NFs      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cQuery += " AND D2_DOC >= '"+If(AllTrim(mv_par07)=="",Space(6),AllTrim(mv_par07))+"'"
//cQuery += " AND D2_DOC <= '"+If(AllTrim(mv_par08)=="","ZZZZZZ",AllTrim(mv_par08))+"'"

// MIGRAÇÃO 10
cQuery += " AND D2_DOC >= '"+If(AllTrim(mv_par07)=="",Space(9),mv_par07)+"'"
cQuery += " AND D2_DOC <= '"+If(AllTrim(mv_par08)=="","ZZZZZZZZZ",mv_par08)+"'"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Desconsidera TES      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par09) <> ''
	cQuery += " AND D2_TES NOT IN ('"+StrTran(mv_par09,"/","','")+"')"
EndIf

// Cleiton
If !Empty(MV_Par16) 	
	cQuery += " AND D2_CLIENTE = '" + MV_PAR16 + "'	"
EndIf
// Cleiton

cQuery += " GROUP BY BM_DESC, D2_COD, B1_DESC 
cQuery += " ORDER BY D2_COD

//cQuery := ChangeQuery(cQuery)
//MemoWrite("\QUERYSYS\RFATC13.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SQL',.F.,.T.) 
dbSelectArea("SQL")
SQL->(dbEval({||nTotRegs++},,{||!Eof()}))

ProcRegua(nTotRegs)

dbSelectArea('SQL')
dbGoTop()
While !Eof()

		IncProc()

		dbSelectArea("TRBP")
		RecLock("TRBP",.T.)                            
		TRBP->CODIGO        := SQL->D2_COD
		TRBP->DESCRICAO     := SQL->B1_DESC
		TRBP->QTDA          := SQL->QUANT
		TRBP->VLRBRUTO      := SQL->VLR_BRUTO
		TRBP->PMEDIO        := SQL->P_MEDIO
		TRBP->ICMS          := SQL->ICMS
		TRBP->COFINS        := SQL->COFINS
		TRBP->PIS           := SQL->PIS
		TRBP->IMPOSTO       := SQL->IMPOSTO
		TRBP->VLRLIQUIDO    := SQL->VLR_LIQUID
                                             
		//Chama o calculo do custo dos produtos
		aCusRep := {}
		lAntigo := .F.
		MFormCusto()
		             
		//Se o produto nao foi identificado com o custo muito defasado
		//grava as informacoes de MOD 
		If !lAntigo

			TRBP->MP       := aCusRep[1,1] * SQL->QUANT
			TRBP->EMBALAGE := aCusRep[1,2] * SQL->QUANT
            
            TRBP->MO       := u_PlanTemp(SQL->D2_COD) * SQL->QUANT //RODOLFO
		            
            //TRBP->MO       := u_PlanTemp(SQL->D2_COD) * nHoraMOD * SQL->QUANT
		
			IF TRBP->(MP+EMBALAGE+MO) == 0
			   TRBP->TOTAL := TRBP->QTDA * u_RESTC041({SQL->D2_COD,dinicio,dfinal,cTesNFE})	
			Else 
			   TRBP->TOTAL := TRBP->(MP+EMBALAGE+MO)
			EndIf
		
			TRBP->MARGEM_VLR := TRBP->(VLRLIQUIDO-TOTAL)
			TRBP->MARGEM_PRC := TRBP->(TOTAL / VLRLIQUIDO) * 100 
		EndIf
		
		MsUnlock()
		
		dbSelectArea("SQL")
		dbSkip()

EndDO

u_ProcExcel("TRBP")
SQL->(DBClosearea()) 
TRBP->(dbCloseArea()) 
fErase(_cArqCbc+'.DBF') 

Return(.T.)         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MFormCusto    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function MFormCusto()

Local aRegs			:= {}
Local cPerg 		:= 'FORCTO'

Private cPerg2		:= 'MTR430' 
Private nOpcSel 	:= 0
Private nOpcRel 	:= 0
Private aHeader	:= {}
Private aCols		:= {}
Private nOpca		:= 3
Private INCLUI		:= .T.
Private lCont 		:= .T.

Public lDescPCof	:= .F.
Public nDescPCof	:= 0

Pergunte( cPerg, .F. )

mv_par01 = 2
mv_par02 = 1
mv_par03 = 1
mv_par04 = 0

lDescPCof	:= If(mv_Par03==1,.T.,.F.)
nDescPCof	:= Mv_Par04
nOpcSel 	:= Mv_Par01
nOpcRel	 	:= Mv_Par02
	
Pergunte( cPerg2, .f. )

RunFormPrc()

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunFormPrcºAutor  ³Evaldo V. Batista   º Data ³  26/07/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta os parametros do relatorio para permitir a seleção deº±±
±±º          ³ produtos pela seleção manual                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunFormPrc()

Local cPerg			:= 'MTR430' 

Private aPar		:= Array(20)
Private aParC010	:= Array(20)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Produto inicial                              ³
//³ mv_par02     // Produto final                                ³
//³ mv_par03     // Nome da planilha utilizada                   ³
//³ mv_par04     // Imprime estrutura : Sim / Nao                ³
//³ mv_par05     // Moeda Secundaria  : 1 2 3 4 5                ³
//³ mv_par06     // Nivel de detalhamento da estrutura           ³
//³ mv_par07     // Qual a Quantidade Basica                     ³
//³ mv_par08     // Considera Qtde Neg na estrutura: Sim/Nao     ³
//³ mv_par09     // Considera Estrutura / Pre Estrutura          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//Fixa o conteudo do parametro 01 e 02
MV_PAR01 := MV_PAR02 := SQL->D2_COD

//Salvar variaveis existentes 
For ni := 1 to 20
	aPar[ni] := &("mv_par"+StrZero(ni,2))
Next ni

C430Imp()
Return Nil
  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³C430Imp   ºAutor  ³Evaldo V. Batista   º Data ³  26/07/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C430Imp(lEnd)

Local cRodaTxt := ""
Local nCntImpr := 0,nReg
Local aArray   := {}
Local cCondFiltr
Local lRet
Local nI       := 0
Local cProdFim :=""
Local aStru		:= {}

PRIVATE cProg:="R430"
PRIVATE nQualCusto := 1
PRIVATE aAuxCusto
PRIVATE cArqMemo := "STANDARD"
PRIVATE lDirecao := .T.

If nOpcRel <> 2
	MTC010SX1()
	PERGUNTE("MTC010", .F.)

 	For ni := 1 to 20
		aParC010[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	
	//Forca mesmo valor do relatorio na pergunta 09
	mv_par09     := aPar[09]
	aParC010[09] := aPar[09]
		      	
	lConsNeg := apar[08] = 1     // Esta variavel será usada na função MC010Forma
	
	DbSelectArea("SB1")
	cArqMemo := apar[03]

EndIf

dbSelectArea("SB1")
If nOpcSel == 1
	ProcRegua( Len( aCols ) ) 
Else
	ProcRegua(LastRec())
EndIf

If nOpcRel == 1 
	Aadd( aStru, {'CEL',        'N', 3, 0} )
	Aadd( aStru, {'NIV1','C', 1, 0} )
	Aadd( aStru, {'NIV2',		'C', 1, 0} )
	Aadd( aStru, {'NIV3',		'C', 1, 0} )
	Aadd( aStru, {'CODIGO',		'C', 15, 0} )
	Aadd( aStru, {'DESCRI',		'C', 40, 0} )
	Aadd( aStru, {'UM',			'C', 2, 0} )
	//Aadd( aStru, {'QTD',		'N', TamSx3("G1_QUANT")[1], TamSx3("G1_QUANT")[2]} )
    Aadd( aStru, {'QTD',		'N', 16,6} )
	
	Aadd( aStru, {'VAL_UNIT',	'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'VAL_TOT',	'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'PART',		'N', 19, 3} )
	Aadd( aStru, {'ULT_COMP',	'D', 8, 0} )
ElseIf nOpcRel == 3
	Aadd( aStru, {'CODIGO',		'C', 15, 0} )
	Aadd( aStru, {'DESCRI',		'C', 40, 0} )
   	//Aadd( aStru, {'QTD',			'N', TamSx3("G1_QUANT")[1], TamSx3("G1_QUANT")[2]} )
  	Aadd( aStru, {'QTD',			'N', 16, 6} )
  	Aadd( aStru, {'UM',			'C', 2, 0} )
	Aadd( aStru, {'MP',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'EMB',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'MOD',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'GGF',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'TOTAL',		'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
EndIf

If nOpcRel <> 2
	cArqTmp := CriaTrab( aStru, .T. ) 
	dbUseArea( .T.,, cArqTmp, cArqTmp, .F., .F. )
EndIf

lRet:=MR430PlanU(.T.)

dbSelectArea( 'SB1' ) 

If lRet .and. nOpcSel == 1
	If nOpcRel == 1 .OR. nOpcRel == 3 
		For _nA := 1 To Len( aCols ) 
			SB1->( dbSetOrder( 1 ) ) 
			If SB1->( dbSeek( xFilial('SB1') + aCols[_nA,1], .F. ) ) 
				nReg := Recno()
				Incproc()
				dbSelectArea( 'SB1' ) 
			   //	aArray := MC010Forma('SB1',nReg,99,aPar[07])
			     	aArray := MC010Forma('SB1',nReg,99,1)
			
					R430Impr(aArray[1],aArray[2],aArray[3], cArqTmp)
				SB1->( dbGoTo(nReg) ) 
			EndIf
		Next _nA
	ElseIf nOpcRel == 2 
		cArqTmp:=GPlanTemp()
	EndIf
Else
	If nOpcRel == 1  .OR. nOpcRel == 3 
		cProdFim:=apar[02]
		SB1->( dbSetOrder(1) ) 
		If !SB1->( dbSeek( xFilial("SB1") + aPar[01], .F. ) ) 
			SB1->( dbGoTop() )
		EndIf
		While !SB1->(EOF()) .And. SB1->B1_FILIAL+SB1->B1_COD <= xFilial()+cProdFim .And. lRet
			If SB1->B1_COD < aPar[01] .or. SB1->B1_COD > cProdFim
				SB1->( dbSkip() ) 
				Loop
			EndIf
			IncProc()
			nReg := SB1->( Recno() ) 
			dbSelectArea( 'SB1' ) 
			aArray := MC010Forma('SB1',nReg,99,1)
			R430Impr(aArray[1],aArray[2],aArray[3],cArqTmp)
			SB1->( dbGoTo(nReg) ) 
			SB1->( dbSkip() ) 
		EndDo
	ElseIf nOpcRel == 2 
		cArqTmp:=GPlanTemp()
	EndIf
EndIf

If lCont 
   CalcCusto(cArqTmp)
	(cArqTmp)->(dbCloseArea()) 
	fErase( cArqTmp+'.DBF' ) 
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R430Impr ³ Autor ³ Eveli Morasco         ³ Data ³ 30/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados ja' calculados                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  R430Impr(ExpC1,ExpA1,ExpN1)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Titulo do custo utilizado                          ³±±
±±³          ³ ExpA1 = Array com os dados ja' calculados                  ³±±
±±³          ³ ExpN1 = Numero do elemento inicial a imprimir              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR430                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R430Impr(cCusto,aArray,nPosForm, cAlias)
LOCAL nX

LOCAL nCotacao,nValUnit,nValUnit2
LOCAL cPicQuant:=PesqPictQt("G1_QUANT",13)
LOCAL cPicUnit :=PesqPict("SB1","B1_CUSTD",18)
LOCAL cPicTot	:=PesqPict("SB1","B1_CUSTD",19)
LOCAL cMoeda1,cMoeda2
Local nDecimal :=0
LOCAL nI       :=0
LOCAL lIncRec	:= .F.
Local lTotaliza:= .F.

cCusto := If(cCusto=Nil,'',AllTrim(Upper(cCusto)))
If cCusto == 'ULT PRECO'
	nDecimal := TamSX3('B1_UPRC')[2]
ElseIf 'MEDIO' $ cCusto
	nDecimal := TamSX3('B2_CM1')[2]
Else
	nDecimal := TamSX3('B1_CUSTD')[2]
EndIf

If Str(nQualCusto,1) $ "3/4/5/6"
	nCotacao:=ConvMoeda(dDataBase,,1,Str(nQualCusto-1,1))
	cMoeda1:=GetMV("MV_MOEDA"+Str(nQualCusto-1,1,0))
Else
	nCotacao:=1
	cMoeda1:=GetMV("MV_MOEDA1")
EndIf
cMoeda1:=PADC(Alltrim(cMoeda1),15)

cMoeda2:=PADC(Alltrim(GetMV("MV_MOEDA"+Str(apar[05],1,0))),38)

For nX := 1 To Len(aArray)
   _xTXT := 0
	If apar[04] == 1
		If Val(apar[06]) != 0
			If Val(aArray[nX,2]) > Val(apar[06])  
				Loop                    
			Endif
		Endif
	Endif

	If If( (Len(aArray[ nX ])==12),aArray[nX,12],.T. )
		If nOpcRel == 1 .or. nOpcRel == 3
			If nOpcRel == 1
				RecLock( cAlias, .T. ) 
				If nX < nPosForm-1
					If mv_par02 == 1
						nValUnit := Round(aAuxCusto[nX]/aArray[nX][05], nDecimal)
					Else
						nValUnit := NoRound(aAuxCusto[nX]/aArray[nX][05], nDecimal)
					EndIf
					nValUnit2:= Round(ConvMoeda(dDataBase,,nValUnit/nCotacao,Str(apar[05],1)), nDecimal)
				EndIf

				If (Len(AllTrim(aArray[nX][02]))>1 .or. Val(AllTrim(aArray[nX][02]))<=2)
					_lLstEstr := .T.
				EndIf

				If nOpcRel == 1
					(cAlias)->( FieldPut(1, aArray[nX][01] ) )                 
					(cAlias)->( FieldPut(2, Substr( aArray[nX][02], 1, 1 )  ) ) 
					(cAlias)->( FieldPut(3, Substr( aArray[nX][02], 2, 1 )  ) ) 
					(cAlias)->( FieldPut(4, Substr( aArray[nX][02], 3, 1 )  ) ) 
					If _lLstEstr
						(cAlias)->( FieldPut(5, aArray[nX][04] ) ) 
						(cAlias)->( FieldPut(6, Left(aArray[nX][03],30) ) ) 
					Else
						(cAlias)->( FieldPut(5, "" ) ) 
						(cAlias)->( FieldPut(6, "" ) ) 
					EndIf
				Else
					(cAlias)->( FieldPut(5, aArray[1][04] ) ) 
					(cAlias)->( FieldPut(6, Left(aArray[nX][03],30) ) ) 
				EndIf
				If aArray[nX][04] != Replicate("-",15)
					If nX < nPosForm-1
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona na UM correta do produto ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cOldAlias:=Alias()
						dbSelectArea("SB1")
						nOrder:=IndexOrd()
						nRecno:=Recno()
						SB1->( dbSetOrder(1) )
						SB1->( dbSeek(xFilial()+aArray[nX][04]) ) 
						If _lLstEstr
							(cAlias)->( FieldPut(7, SB1->B1_UM ) ) 
						Else
							(cAlias)->( FieldPut(7, "" ) ) 						
						Endif
						
						(cAlias)->( FieldPut(7, SB1->B1_TIPO ) ) 
						
						dUltCompra := SB1->B1_UCOM
						SB1->( dbSetOrder(nOrder) )            
						SB1->( dbGoTo(nRecno) ) 
						dbSelectArea(cOldAlias)
						If _lLstEstr
							(cAlias)->( FieldPut(8, aArray[nX][05] ) )
							(cAlias)->( FieldPut(9, nValUnit  ) ) 
						Else
							(cAlias)->( FieldPut(8, 0 ) )
							(cAlias)->( FieldPut(9, 0  ) ) 
						Endif
						(cAlias)->( FieldPut(12, dUltCompra ) ) 
					EndIf          
					If _lLstEstr                                  
						(cAlias)->( FieldPut(10, aArray[nX][06] ) ) 
						(cAlias)->( FieldPut(11, aArray[nX][07] ) ) 
					Else
						(cAlias)->( FieldPut(10, 0 ) ) 
						(cAlias)->( FieldPut(11, 0 ) ) 
					EndIf
				EndIf
			ElseIf nOpcRel == 3 .And. Substr( aArray[nX][02], 1, 1 ) == '-'
				If !lIncRec
					lIncRec	:= .T.
					RecLock( cAlias, .T. ) 
					(cAlias)->( FieldPut(1, aArray[1][04] ) ) 
					(cAlias)->( FieldPut(2, Left(aArray[1][03],30) ) ) 
				EndIf
				If 'TOTAL DE MATERIA PRIMA' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('MP') ), aArray[nX][06] ) ) 
				ElseIf 'TOTAL DE EMBALAGEM' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('EMB') ), aArray[nX][06] ) ) 
				ElseIf 'TOTAL DE MAO DE OBRA' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('MOD') ), aArray[nX][06] ) ) 
				ElseIf 'TOTAL DE GASTOS GERAIS' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('GGF') ), aArray[nX][06] ) ) 
				EndIf
				If lTotaliza
					lTotaliza:= .F.
					(cAlias)->( FieldPut( FieldPos( AllTrim('TOTAL')  ), FieldGet( FieldPos( 'TOTAL')  )+aArray[nX][06] ) ) 
				EndIf 
				If Nx == Len(aArray)
					(cAlias)->(MsUnLock())
				EndIf
			EndIf
		EndIf
		If nX == 1 .And. apar[04] == 2
			nX += (nPosForm-3)
		EndIf
		(cAlias)->( MsUnLock() ) 
	EndIf
Next nX
If nOpcRel <> 3
	RecLock( cAlias, .T. ) 
	(cAlias)->( MsUnLock() ) 
	RecLock( cAlias, .T. ) 
	(cAlias)->( MsUnLock() ) 
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MR430Plan ³ Autor ³ Eveli Morasco         ³ Data ³ 30/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se a Planilha escolhida existe                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR430                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MR430PlanU(lGravado)
Local cArq := ""
DEFAULT lGravado:=.F.
cArq:=AllTrim(If(lGravado,apar[03],&(ReadVar())))+".PDV"
If !File(cArq)
	Help(" ",1,"MR430NOPLA")
	Return .F.
EndIf
Return .T.   


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³CalcCusto ³ Autor ³                       ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Totaliza os custos de MP/EMB/MO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CalcCusto(cArqTemp)

Local cAlias   := cArqTemp
Local nTotMP   := 0
Local nTotEM   := 0 
Local nCusto   := 0
Local nCusto   := 0
Local nNivel   := 0 
Local nBase1   := 0
Local nBase2   := 0

dbSelectArea(cAlias)
dbGoTop()
While !Eof()  

		//Localiza o ultimo custo de entrada do produto
		//e totaliza por tipo EM/MP
		If (cAlias)->UM $ "EM/MP"
			aAreaAtu := GetArea()
			nCusto := u_RESTC041({(cAlias)->CODIGO,dinicio,dfinal,cTesNFE})
			RestArea(aAreaAtu)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//|Caso encontre um retorno zerado, que significa que o produto e muito antigo   |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAlias)->UM $ "EM/MP" .and. nCusto == 0 
			//Marca que o produto esta com custo extremamente defasado e sai do loop
			lAntigo := .T.
			Exit	
		Endif		
		
		If (cAlias)->UM == 'EM'
			nTotEM += (cAlias)->QTD * nCusto
		ElseIf (cAlias)->UM == 'MP
			nTotMP += (cAlias)->QTD * nCusto
		EndIf
		      
		dbSelectArea(cAlias)
		(cAlias)->(dbSkip())   
		
		nCusto := 0

EndDo

aAdd(aCusRep,{nTotMP,nTotEM})

Return 



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPlanTemp ºAutor  ³Evaldo V. Batista   º Data ³  05/08/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Executa uma query para geracao de relatorio de Produto e   º±±
±±º          ³tempo por Centro de Custo.                                  º±±
±±º          ³ Copia da funcao do fonte FORMCUSTO, para informar o total  º±±
±±º          ³ gasto em mao de obra.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 / Brascola / Estoque                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PlanTemp(cProduto)

Local cQuery 	:= ''
Local cAlias 	:= 'TMPCC'
Local cAliTmp	:= 'TMPCCDBF'
Local cArqTmp	:= ''
Local cGrpCc	:= ""
Local cProds	:= ""
Local aJustCpo	:= {}
Local nDecimal := 6
Local aStruTmp	:= {}
Local aStruProd:= {}
Local cListProd:= ''
Local nRetorno := 0 
Local nHoraMod := 0

aStruProd := {}
Aadd( aStruProd, {cProduto,1} )
lWhile := .T.
While lWhile
		lWhile := .F.
		cListProd := "'"
		aEval( aStruProd, {|x| cListProd += AllTrim(x[1]) + "','" } ) 
		cListProd := Substr( cListProd, 1, Len(cListProd) - 2 ) 
		cQuery := " SELECT G1_COMP, G1_QUANT "
		cQuery += " 	FROM "+RetSqlName('SG1')+" SG1 "
		cQuery += " 	Where SG1.D_E_L_E_T_ <> '*' "
		cQuery += "   		AND SG1.G1_COD IN ("+cListProd+") "
		cQuery += " 		AND SG1.G1_COMP NOT IN ("+cListProd+") "
		//cQuery := ChangeQuery( cQuery ) 
		If Select(cAlias)>0
			dbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		EndIf
		dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .F. ) 
		While !(cAlias)->( Eof() ) 
				If aScan( aStruProd, {|x| AllTrim(x[1]) == AllTrim((cAlias)->G1_COMP) } ) == 0
					lWhile := .T.
					Aadd( aStruProd, {(cAlias)->G1_COMP, (cAlias)->G1_QUANT} ) 
				EndIf
				(cAlias)->( dbSkip() ) 
		EndDo
	   (cAlias)->( dbCloseArea() ) 
EndDo
  
cListProd := "'"
aEval( aStruProd, {|x| cListProd += AllTrim(x[1]) + "','" } ) 
cListProd := Substr( cListProd, 1, Len(cListProd) - 2 ) 

cQuery := " SELECT   SG2.G2_PRODUTO AS 'PRODUTO', "
cQuery += "          SH1.H1_CCUSTO AS CUSTO , "
cQuery += "          CAST( SUM( (SG2.G2_TEMPAD*SG2.G2_MAOOBRA)/SG2.G2_LOTEPAD ) AS NUMERIC(16,6) ) AS 'TEMPO', "
cQuery += "          ISNULL( ( SELECT SG1.G1_QUANT FROM "+RetSqlName('SG1')+" SG1 WHERE SG1.D_E_L_E_T_ <> '*' "
cQuery += "                    AND SG1.G1_COD IN ("+cListProd+") "
cQuery += "                    AND SG1.G1_COMP = SG2.G2_PRODUTO AND SG1.G1_FILIAL = '"+xFilial("SG1")+"'), 1 ) AS 'G1_QUANT' "
cQuery += " 	  		FROM "+RetSqlName("SG2")+" SG2 INNER JOIN "+RetSqlName("SH1")+" SH1 ON SH1.D_E_L_E_T_ <> '*' AND SH1.H1_CODIGO = SG2.G2_RECURSO "
cQuery += " WHERE SG2.D_E_L_E_T_ <> '*' "
cQuery += " AND SG2.G2_PRODUTO IN ("+cListProd+") "
cQuery += " AND SG2.G2_LOTEPAD <> 0 "
cQuery += " GROUP BY SG2.G2_PRODUTO, SH1.H1_CCUSTO "
If Select(cAlias)>0
	dbSelectArea(cAlias)
	(cAlias)->(dbCloseArea())
EndIf
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .F. ) 
TcSetField( cAlias, 'TEMPO','N', 16, nDecimal )
	
(cAlias)->( dbGoTop() )
If !(cAlias)->( Eof() ) 
		While !(cAlias)->( Eof() ) 
			// Cleiton
			// Foi incluido o codigo da filial no inicio para diferenciacao do CC
		    // IF (cAlias)->(CUSTO) = '1321' 
		    // cCodCus := xFilial() + "321"
		    IF ((cAlias)->(CUSTO) = sm0->(right(m0_codfil, 1)) + '321')
               nHoraMOD:= hor1321

			// Cleiton
			// Foi incluido o codigo da filial no inicio para diferenciacao do CC
		    // ELSEIF (cAlias)->(CUSTO)= '1322'
            ELSEIF ((cAlias)->(CUSTO) = sm0->(right(m0_codfil, 1)) + '322')
               nHoraMOD:= hor1322 

			// Cleiton
			// Foi incluido o codigo da filial no inicio para diferenciacao do CC
		    // ELSEIF (cAlias)->(CUSTO) = '1323'
            ELSEIF ((cAlias)->(CUSTO) = sm0->(right(m0_codfil, 1)) + '323')           
               nHoraMOD:= MV_PAR13

			// Cleiton
			// Foi incluido o codigo da filial no inicio para diferenciacao do CC
		    // ELSEIF (cAlias)->(CUSTO) = '1324'  
            ELSEIF ((cAlias)->(CUSTO) = sm0->(right(m0_codfil, 1)) + '324')           
               nHoraMOD:= hor1324

			// Cleiton
			// Foi incluido o codigo da filial no inicio para diferenciacao do CC
		    // ELSEIF (cAlias)->(CUSTO) = '1355'
            ELSEIF ((cAlias)->(CUSTO) = sm0->(right(m0_codfil, 1)) + '355')
                nHoraMOD:= hor1355
            ENDIF   
			if nHoraMOD = 0
			   nHoraMOD:= 1
			endif	
				//nRetorno += (cAlias)->( G1_QUANT * TEMPO )* nHoraMOD
				IF (cAlias)->( G1_QUANT ) <> 1
				   nRetorno += ((cAlias)->( TEMPO )* nHoraMOD) /100//RODOLFO dia 14/12 para deixar igual a estrutura
				ELSE 
				 nRetorno += (cAlias)->( TEMPO )* nHoraMOD //RODOLFO
				ENDIF 
				(cAlias)->( dbSkip() ) 
		EndDo
EndIf

(cAlias)->( dbCloseArea() ) 

Return(nRetorno)