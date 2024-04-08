#include "rwmake.ch"
#include "topconn.ch"
#include "folder.ch"        
#include "font.ch"
#include "colors.ch"
#include "msgraphi.ch"
#include "protheus.ch"
#include "dbtree.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100I  ºAutor  ³ Marcelo da Cunha   º Data ³  21/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para atualizar status da NF-e Classifica  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10/MP11                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SF1100I()
*********************
LOCAL lRetu := .T., nLin, nPos, nx, aSD1 := SD1->(GetArea())
LOCAL aHSeg := aClone(aHeader), aCSeg := aClone(aCols), nNSeg := N

PRIVATE oDlgImp, oGetImp, nOpcc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Solicitar as informacoes da DI na nota fiscal de entrada     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (INCLUI.or.ALTERA).and.(SF1->F1_est == "EX").and.(SF1->F1_tipo == "N")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monto tela para cadastramento das informacoes da DI          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader := {} ; aCols := {} ; N := 1
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("CD5",.T.))
	While !SX3->(EOF()).and.(SX3->X3_arquivo == "CD5")
		If X3USO(SX3->X3_USADO).and.!(Alltrim(SX3->X3_CAMPO) $ "CD5_DOC/CD5_SERIE/CD5_FORNEC/CD5_LOJA/CD5_ESPEC").and.(cNivel >= SX3->X3_nivel)
			aadd(aHeader,{Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT})
		Endif
		SX3->(dbSkip())
	Enddo	
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja,.T.))
	While !SD1->(Eof()).and.(xFilial("SD1") == SD1->D1_filial).and.(SD1->D1_doc+SD1->D1_serie+SD1->D1_fornece+SD1->D1_loja == SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja)
		aadd(aCols,Array(Len(aHeader)+1))
		nLin := Len(aCols)
		For nx := 1 to Len(aHeader)
			aCols[nLin,nx] := CriaVar(aHeader[nx,2])
		Next nx
		aCols[nLin,GDFieldPos("CD5_ITEM")] := SD1->D1_item
		aCols[nLin,Len(aHeader)+1] := .F.
		SD1->(dbSkip())
	Enddo
	If (Len(aCols) > 0)
		DEFINE MSDIALOG oDlgImp TITLE OemToAnsi("Dados do Processo de Importacao: ") FROM 0,0 TO 320,800 OF GetWndDefault() PIXEL //"Escolha Padr”es"
		oGetImp := MsNewGetDados():New(005,005,130,395,GD_UPDATE,"u_BSF100Valid()","AllwaysTrue",,,,900,"u_BSF100VCmp()",,,oDlgImp,aHeader,aCols)
		@ 140,010 BUTTON "Confirma" ACTION iif(u_BSF100Valid(),(nOpcc:=1,oDlgImp:End()),.F.) SIZE 040,012 PIXEL
		@ 140,050 BUTTON "Cancelar" ACTION oDlgImp:End() SIZE 040,012 PIXEL
		ACTIVATE MSDIALOG oDlgImp CENTERED
		If (nOpcc == 1)
			CD5->(dbSetOrder(4)) //CD5_FILIAL,CD5_DOC,CD5_SERIE,CD5_FORNEC,CD5_LOJA,CD5_ITEM
			aCols := aClone(oGetImp:aCols)
			For nLin := 1 to Len(aCols)
				If !GDDeleted(nLin)
					If CD5->(dbSeek(xFilial("CD5")+SF1->F1_doc+SF1->F1_serie+SF1->F1_fornece+SF1->F1_loja+GDFieldGet("CD5_ITEM",nLin)))
						Reclock("CD5",.F.)
					Else
						Reclock("CD5",.T.)
						CD5->CD5_filial := xFilial("CD5")
						CD5->CD5_doc    := SF1->F1_doc
						CD5->CD5_serie  := SF1->F1_serie
						CD5->CD5_fornec := SF1->F1_fornece
						CD5->CD5_loja   := SF1->F1_loja
						CD5->CD5_item   := GDFieldGet("CD5_ITEM",nLin)
					Endif
					CD5->CD5_espec  := SF1->F1_especie
					For nx := 1 to Len(aHeader)
						nPos := CD5->(FieldPos(aHeader[nx,2]))
						If (nPos > 0)
							CD5->(FieldPut(nPos,aCols[nLin,nx]))
						Endif
					Next nx
					If Empty(CD5->CD5_codexp)
						CD5->CD5_codexp := SF1->F1_fornece
					Endif
					If Empty(CD5->CD5_lojexp)
						CD5->CD5_lojexp := SF1->F1_loja
					Endif
					MsUnlock("CD5")
				Endif
			Next nLin		
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retorno variaveis utilizadas                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeader := aClone(aHSeg) ; aCols := aClone(aCSeg) ; N := nNSeg
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Flag para atualizar status da NF-e Classificada     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AliasInDic("ZGN")
	ZGN->(dbSetOrder(1)) ; SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+SF1->F1_fornece+SF1->F1_loja))
		If ZGN->(dbSeek(xFilial("ZGN")+"1"+SF1->F1_serie+SF1->F1_doc+SA2->A2_cgc))
			Reclock("ZGN",.F.)
			ZGN->ZGN_usucla := cUserName
			ZGN->ZGN_datcla := MsDate()
			ZGN->ZGN_horcla := Time()
			ZGN->ZGN_status := "3" //NF-e Classificada
			MsUnlock("ZGN")
		Endif
	Endif
Endif

Return lRetu

User Function BSF100Valid()
************************
LOCAL lRetu1 := .T.

Return lRetu1

User Function BSF100VCmp()
***********************
LOCAL lRetu1 := .T., ny, nColy, xVary
LOCAL cCampo := Upper(Alltrim(ReadVar()))
If (oGetImp:nAt == 1) //Linha 1            
	xVary := &(cCampo)
	nColy := oGetImp:oBrowse:nColPos
	For ny := 2 to Len(oGetImp:aCols)
		oGetImp:aCols[ny,nColy] := xVary
	Next ny
	If (cCampo $ "M->CD5_CODEXP/M->CD5_CODFAB")
		For ny := 2 to Len(oGetImp:aCols)
			If Empty(GDFieldGet("CD5_LOJEXP"))
				oGetImp:aCols[ny,GDFieldPos("CD5_LOJEXP")] := SA2->A2_loja
			Endif
			If Empty(GDFieldGet("CD5_LOJFAB"))
				oGetImp:aCols[ny,GDFieldPos("CD5_LOJFAB")] := SA2->A2_loja
			Endif
		Next ny
	Endif	
	oGetImp:oBrowse:Refresh()
Endif
Return lRetu1