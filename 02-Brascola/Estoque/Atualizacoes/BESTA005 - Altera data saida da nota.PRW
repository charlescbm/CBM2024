#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA005         AUTOR:                          DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Criar programa para altera��o da data de sa�da da nota fiscal de 
sa�da ( F2_DTSAIDA ). Este programa deve solicitar por par�metro a data a 
ser preenchida no campo F2_DTSAIDA. Em seguida abrir a tela. Para usar o 
leitor de c�digo de barras conforme programa Consnfori.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BESTA005()

Local cPerg := U_CRIAPERG("ALTDTSAI")
Private cCadastro := "Notas Fiscais Transferidas"
Private cNumNFAux := Space(09)

ValPergunte(cPerg)

If Pergunte(cPerg)
	Processa({ || CONDtSai()}, "Aguarde",,.t.)
EndIf

Return


Static Function CONDtSai()
**************************
Private cNumNFAux:= Space(12)
Private lEnd     := .t.
Private _oDlg

While lEnd 
	cNumNFAux:= Space(12)
	
	Define MSDialog _oDlg From 5, 5 To 15, 40 Title "Codigo de Barras"
	@ 002,002 Say "Serie/N.Fiscal: "     Size 30,44                                   Of _oDlg FONT _oDlg:oFont
	@ 002,011 MSGet cNumNFAux            Size 40,10  Valid GetCdBar(M->cNumNFAux)     Of _oDlg FONT _oDlg:oFont
	@ 005,023 BUTTON "&Sair"  	         Size 40,10  Action (lEnd:=.f.,_oDlg:End())   Of _oDlg FONT _oDlg:oFont
	Activate MSDialog _oDlg Centered
EndDo	

Return



Static Function GetCdBar(cNumNFAux)
************************************
Local lRet:= .t.

dbSelectArea("SF2")
dbSetOrder(1)
//If dbSeek(XFILIAL("SF2")+SUBSTR(cNumNFAux,4,9)+'   '+SUBSTR(cNumNFAux,1,3))
If dbSeek(XFILIAL("SF2")+SUBSTR(cNumNFAux,4,9)+SUBSTR(cNumNFAux,1,3)) //Fernando: 16/01/13
    RecLock("SF2",.f.)
    SF2->F2_DTSAIDA:= mv_par01
    MsUnlock()
    
    MsgBox("Data de Saida da NF: "+Alltrim(cNumNFAux)+ " alterada para "+DtoC(mv_par01)+". ")
Else
    MsgAlert("Nota Fiscal n�o encontrada!!")
EndIf

Return lRet



Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:={}
//          Grupo/Ordem/Pergunta/                  Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01      /Cnt01/Var02/Def02    /Cnt02/Var03/Def03    /Cnt03/Var04/Def04    /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture
aAdd(aRegs,{cPerg,"01" ,"Nova Data Saida  ?","","","mv_ch1","D" ,8      ,0      ,0     ,"G",""   ,"mv_par01","","",""   ,""   ,""   ,"","","" ,""   ,""   ,"","","" ,""   ,""   ,"","","" ,""   ,""   ,"","","" ,""    ,""   ,""   ,""     ,""   ,"" ,""})

For i:=1 to Len(aRegs)
	If ! DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	EndIf
Next

Return