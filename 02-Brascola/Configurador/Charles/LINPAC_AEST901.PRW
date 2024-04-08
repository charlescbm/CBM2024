/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! EST - Estoque                                           !
+------------------+---------------------------------------------------------+
!Nome              ! AEST901                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Importação do Cadastro de Produtos                      !
+------------------+---------------------------------------------------------+
!Autor             ! Paulo Afonso Erzinger Junior                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 13/12/2011                                              !
+------------------+---------------------------------------------------------+
*/

#include "totvs.ch"
#include "protheus.ch"

User Function AEST901()

Processa({ || fImporta() }, "[AEST901] - AGUARDE")

Return

Static Function fImporta()

Local aFilial    := {"01","03","04","05","06","07"}
Local cArq       := "\produtos.txt"
Local cArqOld    := SUBSTR(cArq,1,Len(cArq)-3)+"#tx"
Local cLinha     := ""
Local lPrim      := .T.
Local aCampos    := {}
Local aDados     := {}
Local aProduto   := {}
Local nPosEst    := 0
Local nPosCodMun := 0
Local cFilBkp    := cFilAnt

Private aErro := {}

If !File(cArq)
	MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será abortada!","[AEST901] - ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
	
	IncProc("Lendo arquivo texto...")
	
	cLinha := FT_FREADLN()
	cLinha := ALLTRIM(cLinha)
	
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))
	EndIf
		
	FT_FSKIP()
EndDo

FT_FUSE()

nPosProd  := aScan(aCampos,{ |x| ALLTRIM(x) == "B1_COD" })
nPosDescr := aScan(aCampos,{ |x| ALLTRIM(x) == "B1_DESC" })

ProcRegua(Len(aDados))
For i:=1 to Len(aDados)
	
	IncProc("Filial: " + cFilAnt + " - Importando produtos...")
		
	If Len(aCampos) != Len(aDados[i])
		GravaErro("","Linha: " + ALLTRIM(STR(i)),"Linha: " + ALLTRIM(STR(i)),"Formato dos dados inválido!")
		Loop
	EndIf

	aProduto := {}

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek(xFilial("SB1")+aDados[i,nPosProd])
		For j:=1 to Len(aCampos)			
			dbSelectArea("SX3")
			dbSetOrder(2)
			dbGoTop()
			If dbSeek(ALLTRIM(aCampos[j]))
				If ALLTRIM(aCampos[j]) != "B1_FILIAL"
					Do Case
						Case SX3->X3_TIPO == 'N'
							AADD(aProduto,{ALLTRIM(aCampos[j]), VAL(aDados[i,j]), NIL})
						Case SX3->X3_TIPO == 'D'
							AADD(aProduto,{ALLTRIM(aCampos[j]), CTOD(aDados[i,j]), NIL})
						Otherwise
							AADD(aProduto,{ALLTRIM(aCampos[j]), aDados[i,j], NIL})
					EndCase
				ElseIf ALLTRIM(aCampos[j]) != "B1_LOCPAD"
					AADD(aProduto,{ALLTRIM(aCampos[j]), STRZERO(aDados[i,j],2), NIL})
				EndIf
			EndIf
		Next j
		
		Begin Transaction
			lMsErroAuto := .F.
			MSExecAuto({|x,y| mata010(x,y)},aProduto,3) 
			
			If lMsErroAuto
				MostraErro("\SYSTEM\","AEST901.LOG")
				GravaErro(cFilAnt,aDados[i,nPosProd],aDados[i,nPosDescr],NIL)
				DisarmTransaction()
			Else
				aMata220 := {}
				aAdd(aMata220,{"B9_COD"   , SB1->B1_COD , nil})
				aAdd(aMata220,{"B9_LOCAL" , SB1->B1_LOCPAD , nil})
				aAdd(aMata220,{"B9_DATA"  , CTOD("01/01/2012") , nil})
				aAdd(aMata220,{"B9_QINI"  , 1000000 , nil})
				aAdd(aMata220,{"B9_VINI1" , 0 , nil})
		
				lMsErroAuto := .F.
				MsExecAuto({|x,y|mata220(x,y)},aMata220,3)
		
				If lMsErroAuto
					MostraErro("\SYSTEM\","AEST901.LOG")
					GravaErro(cFilAnt,"SB9","Saldo Inicial",NIL)    		
					DisarmTransaction()
				EndIf
				
				Reclock("SB1",.F.)
				SB1->B1_MSBLQL := '1'
				SB1->(MsUnlock())
			EndIf			
		End Transaction
	Else
//		GravaErro(cFilAnt,aDados[i,nPosProd],aDados[i,nPosDescr],"O registro já está cadastrado!")
	EndIf
Next i

If File(cArqOld)
	fErase(cArqOld)
EndIf

fRename(cArq,cArqOld)

If Len(aErro) > 0
	MostraLog()
Else
	ApMsgInfo("Importação de produtos efetuada com sucesso!","[AEST901] - SUCESSO")
EndIf

cFilAnt := cFilBkp

Return
/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Financeiro                                              !
+------------------+---------------------------------------------------------+
!Nome              ! GravaErro                                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina que grava os erros de importação em um array que !
!				   ! será lido posteriormente.                               !
+------------------+---------------------------------------------------------+
!Autor             ! Paulo Afonso Erzinger Junior                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 18/01/10                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/

Static Function GravaErro(cFil,cProd,cDescr,cMsg)

Local cFile := "\SYSTEM\AEST901.LOG"
Local cLine := ""

DEFAULT cMsg  := NIL

If cMsg == NIL
	Begin Sequence
	IF !( lOk := File( cFile ) )
		Break
	EndIF
	
	FT_FUSE(cFile)
	FT_FGOTOP()
	
	While !FT_FEOF()
		
		cLine += FT_FREADLN() + CHR(13)+CHR(10)
		
		FT_FSKIP()
	End While
	
	FT_FUSE()
	End Sequence
	
	cMsg := cLine
EndIf

AADD(aErro,{cFil,cProd,cDescr,cMsg})

Return


/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Financeiro                                              !
+------------------+---------------------------------------------------------+
!Nome              ! MostraLog                                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina que lê o array com os erros gravados anteriormen-!
!				   ! te e exibe na tela para que possa ser salvo ou impresso !
+------------------+---------------------------------------------------------+
!Autor             ! Paulo Afonso Erzinger Junior                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 18/01/10                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/

Static Function MostraLog()

Local oDlg
Local oFont
Local cMemo := ""

DEFINE FONT oFont NAME "Courier New" SIZE 5,0

DEFINE MSDIALOG oDlg TITLE "[AEST901] - Importação Cadastro Produtos" From 3,0 to 400,417 PIXEL

aCabec := {"Filial","Produto","Descrição"}
cCabec := "{aErro[oBrw:nAT][1],aErro[oBrw:nAT][2],aErro[oBrw:nAT][3]}"
bCabec := &( "{ || " + cCabec + " }" )

oBrw := TWBrowse():New( 005,005,200,090,,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrw:SetArray(aErro)
oBrw:bChange    := { || cMemo := aErro[oBrw:nAT][4], oMemo:Refresh()}
oBrw:bLDblClick := { || cMemo := aErro[oBrw:nAT][4], oMemo:Refresh()}
oBrw:bLine := bCabec

@ 100,005 GET oMemo VAR cMemo MEMO SIZE 200,080 OF oDlg PIXEL

oMemo:bRClicked := {||AllwaysTrue()}
oMemo:lReadOnly := .T.
oMemo:oFont := oFont

oImprimir :=tButton():New(185,120,'Imprimir' ,oDlg,{|| fImprimeLog() },40,12,,,,.T.)
oSair     :=tButton():New(185,165,'Sair'     ,oDlg,{|| ::End() },40,12,,,,.T.)

ACTIVATE MSDIALOG oDlg CENTERED

Return


/*
+----------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Financeiro                                              !
+------------------+---------------------------------------------------------+
!Nome              ! fImprimeLog                                             !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina que imprime os erros armazenados no array.       !
+------------------+---------------------------------------------------------+
!Autor             ! Paulo Afonso Erzinger Junior                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 18/01/10                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!                                           !           !           !        !
!                                           !           !           !        !
+-------------------------------------------+-----------+-----------+--------+
*/

Static Function fImprimeLog()

Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

Static Function ReportDef()

Local oReport
Local oSection

oReport := TReport():New("AEST901","Importação Cadastro de Produtos",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao de erros encontrados durante o processo de importação dos dados.")
oReport:SetLandscape()

oSection := TRSection():New(oReport,,{})

TRCell():New(oSection,"FILIAL" ,,"Filial")
TRCell():New(oSection,"PROD"   ,,"Produto")
TRCell():New(oSection,"DESC"   ,,"Descrição")
TRCell():New(oSection,"DESCRI" ,,"Descrição do Erro")

Return oReport

Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)

oReport:SetMeter(Len(aErro))

oSection:Init()

For i:=1 to Len(aErro)
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oReport:IncMeter()
	
	oSection:Cell("FILIAL"):SetValue(aErro[i,1])
	oSection:Cell("FILIAL"):SetSize(20)
	oSection:Cell("PROD"):SetValue(aErro[i,2])
	oSection:Cell("PROD"):SetSize(20)
	oSection:Cell("DESC"):SetValue(aErro[i,3])
	oSection:Cell("DESC"):SetSize(70)
	oSection:Cell("DESCRI"):SetValue(aErro[i,4])
	oSection:Cell("DESCRI"):SetSize(200)
	
	nTamLin := 200
	nTab := 3
	lWrap := .T.
	
	lPrim := .T.
	
	cObsMemo := aErro[i,4]
	nLines   := MLCOUNT(cObsMemo, nTamLin, nTab, lWrap)
	
	For nCurrentLine := 1 to nLines
		If lPrim
			oSection:Cell("DESCRI"):SetValue(MEMOLINE(cObsMemo, nTamLin, nCurrentLine, nTab, lWrap))
			oSection:Cell("DESCRI"):SetSize(300)
			oSection:PrintLine()
			lPrim := .F.
		Else
			oSection:Cell("FILIAL"):SetValue("")
			oSection:Cell("PROD"):SetValue("")
			oSection:Cell("DESC"):SetValue("")
			oSection:Cell("DESCRI"):SetValue(MEMOLINE(cObsMemo, nTamLin, nCurrentLine, nTab, lWrap))
			oSection:Cell("DESCRI"):SetSize(300)
			oSection:PrintLine()
		EndIf
	Next i
	
	oReport:SkipLine()
Next i

oSection:Finish()

Return