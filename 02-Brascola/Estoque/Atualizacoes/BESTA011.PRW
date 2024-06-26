/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! EST - Estoque                                           !
+------------------+---------------------------------------------------------+
!Nome              ! BESTA011                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Tela para atualiza��o dos campos de custo no cad. prod. !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO AFONSO ERZINGER JUNIOR                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 22/12/2011                                              !
+------------------+---------------------------------------------------------+
*/

#include "protheus.ch"

User Function BESTA011()

Local aCampos := {}
Local nPosCpo := 0 

Local cLinOk    := "U_ESTA011G"
Local cTudoOk   := "AllwaysTrue"
Local cFieldOk  := "AllwaysTrue"
Local cSuperDel := ""
Local cDelOk    := "AllwaysFalse"

Private aHeader := {}
Private aCols   := {}
Private nUsado  := 0
Private cProd   := Space(TamSx3("B1_COD")[1])
Private cDescr  := Space(TamSx3("B1_DESC")[1])

//Adiciona os campos e tamanhos

AADD(aCampos,{"B1_COD"    , 10})
AADD(aCampos,{"B1_DESC"   , 30})
AADD(aCampos,{"B1_CUSTD"  , TAMSX3("B1_CUSTD")[1]})
AADD(aCampos,{"B1_CUSTDIG", TAMSX3("B1_CUSTDIG")[1]})
AADD(aCampos,{"B1_PRMERC" , TAMSX3("B1_PRMERC")[1]})

dbSelectArea("SX3")
dbSetOrder(1)
dbGoTop()
dbSeek("SB1")
While !Eof().And.(SX3->X3_ARQUIVO=="SB1")

	nPosCpo := aScan(aCampos,{ |x| x[1] == ALLTRIM(SX3->X3_CAMPO) })
	
	If nPosCpo <= 0
		dbSkip()
		Loop
	Endif
	
	nUsado++

	If X3USO(x3_usado)
		aAdd(aHeader,{AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		aCampos[nPosCpo,2],;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_F3,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX,;
		SX3->X3_RELACAO})
	Endif
	
	dbSelectArea("SX3")
	SX3->(dbSkip())
EndDo

DEFINE MSDIALOG oDlgCusto TITLE "[BESTA011] - Custos do Produto" From 001,001 to 500,900 Pixel

oGrpCons  := tGroup():New(005,005,030,440,,oDlgCusto,CLR_HBLUE,,.T.)

oSayProd := tSay():New(015,010,{|| "Produto:"   },oGrpCons,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetProd := tGet():New(013,040,{|u| if(PCount()>0,cProd:=u,cProd)}  , oGrpCons,60,9,'@!',{ || fEstrut()  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"SB1",'cProd')
oGetDesc := tGet():New(013,110,{|u| if(PCount()>0,cDescr:=u,cDescr)}, oGrpCons,130,9,'@!',,,,,,,.T.,,, {|| .F. } ,,,,.F.,,,'cDescr')

//========================// Arvore com a estrutura //========================//
oGrpTree  := tGroup():New(035,005,230,190,"Selecione o item",oDlgCusto,CLR_HBLUE,,.T.)

//Cria a Tree
oTree := DbTree():New(045,010,220,180,oGrpTree,,,.T.)
oTree:bLClicked := { || fBuscaProd(oTree:GetCargo()) }

//======================== Browse com as etiquetas ========================//
oGrpBrow  := tGroup():New(035,200,230,440,"Custo",oDlgCusto,CLR_HBLUE,,.T.)
oGetDados := MsNewGetDados():New(045,205,220,435,GD_UPDATE,cLinOk,cTudoOk,,{"B1_CUSTDIG","B1_PRMERC"},0,9999,cFieldOk,cSuperDel,cDelOk,oGrpBrow,aHeader,aCols)

oBtnSair := tButton():New(235,400,'Sair'      ,oDlgCusto, {|| ::End() },40,12,,,,.T.)

ACTIVATE MSDIALOG oDlgCusto CENTERED

Return

//======================== Carrega estrutura ========================//
Static Function fEstrut()

Local cDescPro := ""

oTree:Reset()

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SB1")+cProd)
	
	cDescr := SB1->B1_DESC
	oTree:AddItem(ALLTRIM(SB1->B1_COD) + " - " + cDescr , SB1->B1_COD, "FOLDER5" ,,,,1)
	
	nEstru   := 0
	aStru    := {}
	aStru := Estrut(SB1->B1_COD)
	
	oTree:TreeSeek(SB1->B1_COD)

	For i:=1 to Len(aStru)
		If aStru[i,4] > 0
			cDescPro := POSICIONE("SB1",1,XFILIAL("SB1")+aStru[i,3],"B1_DESC")
			If aStru[i,1] == 1
				oTree:TreeSeek(cProd)
				oTree:AddItem(ALLTRIM(aStru[i,3]) + " - " + cDescPro , aStru[i,3], "FOLDER5" ,,,,2)
			Else
				oTree:TreeSeek(aStru[i,2])
				oTree:AddItem(ALLTRIM(aStru[i,3]) + " - " + cDescPro , aStru[i,3], "FOLDER5" ,,,,2)
			EndIf
		EndIf
	Next i
Else
	ApMsgStop("Produto n�o encontrado!","[BESTA011] - ATENCAO")
	cProd := Space(TamSx3("B1_COD")[1])
EndIf

Return

//======================== Carrega browse ========================//
Static Function fBuscaProd(cProdEst)

oGetDados:aCols := {}

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SB1")+cProdEst)
		
	AADD(oGetDados:aCols,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_CUSTDIG,SB1->B1_PRMERC,SB1->B1_CUSTD,.F.})
	
	nEstru := 0
	aStru2 := {}
	aStru2 := Estrut(SB1->B1_COD)
	
	For i:=1 to Len(aStru2)
		If aStru2[i,4] > 0 .And. aStru2[i,2] == cProdEst
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SB1")+aStru2[i,3])
				AADD(oGetDados:aCols,{SB1->B1_COD,SB1->B1_DESC,SB1->B1_CUSTDIG,SB1->B1_PRMERC,SB1->B1_CUSTD,.F.})
			EndIf
		EndIf
	Next i
EndIf

Return

//============================================= GRAVA ALTERA��ES NOS ITENS =============================================//
User Function ESTA011G()

Local nPosCod := aScan(aHeader,{ |x| ALLTRIM(x[2]) == "B1_COD" })
Local nPosCus := aScan(aHeader,{ |x| ALLTRIM(x[2]) == "B1_CUSTDIG" })
Local nPosPrM := aScan(aHeader,{ |x| ALLTRIM(x[2]) == "B1_PRMERC" })

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SB1")+oGetDados:aCols[oGetDados:nAt,nPosCod])
	Reclock("SB1",.F.)
	SB1->B1_CUSTDIG := oGetDados:aCols[oGetDados:nAt,nPosCus]
	SB1->B1_PRMERC  := oGetDados:aCols[oGetDados:nAt,nPosPrM]
	SB1->(MsUnlock())
EndIf

Return .T.