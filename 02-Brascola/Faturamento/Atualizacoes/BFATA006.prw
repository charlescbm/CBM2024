/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! BFATA006                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Cadastro Al�ada de Vendas                               !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO AFONSO ERZINGER JUNIOR                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 05/01/2010                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "topconn.ch"
#include "totvs.ch"
#include "protheus.ch"

User Function BFATA006()

Local oFont   := TFont():New("Arial",0,-16,,.T.,,,,,.F.,.F.)
Private aSize := MsAdvSize()

Private aHeader := {}
Private aCols   := {}
Private nUsado  := 0         

U_BCFGA002("BFATA006")//Grava detalhes da rotina usada

dbSelectArea("SX3")
dbSetOrder(1)
dbGoTop()
dbSeek("SA3")       
While !Eof() .and. SX3->X3_ARQUIVO == "SA3"
	
	If !ALLTRIM(SX3->X3_CAMPO) $ 'A3_COD/A3_NOME/A3_PERDESC'
		dbSelectArea("SX3")
		SX3->(dbSkip())
		Loop
	EndIf
	
	If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
		nUsado++
		Aadd(aHeader,{Trim(X3Titulo()),;
		ALLTRIM(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		"",;
		SX3->X3_TIPO,;
		"",;
		"" })
	
	EndIf
	
	dbSelectArea("SX3")
	SX3->(DbSkip())
EndDo

aCols:={Array(nUsado+1)}
aCols[1,nUsado+1] := .F.
For _ni:=1 to nUsado
	aCols[1,_ni] := CriaVar(aHeader[_ni,2])
Next _ni

nMargSup := aSize[7] //linha
nMargInf := aSize[6] //linha
nMargEsq := 0 //coluna
nMargDir := aSize[5] //coluna

DEFINE MSDIALOG oDlgVend TITLE "[BFATA006] - Hierarquia de Vendas" From nMargSup - 50, nMargEsq TO 480, nMargDir Pixel //of oMainWnd
                                       
//======================== Arvore com a estrutura ========================//
oGrpTree  := tGroup():New(080,005,230,190,"Estrutura de Vendas",oDlgVend,CLR_HBLUE,,.T.)

//Cria a Tree
oTree := DbTree():New(090,010,225,185,oGrpTree,,,.T.)
oTree:bChange   := { ||  }
oTree:bLClicked := { ||  }

//======================== Browse com os vendedores ========================//

oGrpVend  := tGroup():New(080,200,230,(aSize[5]/2),"Vendedores",oDlgVend,CLR_HBLUE,,.T.)

oBrwVend := MsNewGetDados():New(090,205,210,(aSize[5]/2)-5, GD_INSERT+GD_UPDATE+GD_DELETE,,,,{"A3_COD","A3_NOME","A3_PERDESC"},,9999,,,, oGrpVend, aHeader, aCols)

oBtnSair := tButton():New(235,(aSize[5]/2)-40,'Sair'      ,oDlgVend, {|| oDlgVend:End() },40,12,,,,.T.,,,, { ||  },,)

ACTIVATE MSDIALOG oDlgVend CENTERED

Return