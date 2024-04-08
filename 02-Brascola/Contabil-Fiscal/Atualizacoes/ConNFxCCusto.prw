#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONNFXCCUSTO บAutor  ณThiago (Onsten)  บ Data ณ  05/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta NF x CCusto                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Brascola                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
 
User Function CONNFXCC()
************************
Public lSaiu       := .f.
Public nItensIni   := 0
Private cCadastro  := "Consulta a Contas a Pagar"
Private aHeader	   := {} 
Private aCols      := {}
Private cDelFunc   := ".T." 
Private cString    := "SE2"
Private nUsado     := 0
Private cNumNF     := Space(6)
Private cSerNF     := Space(3)
Private cFornec    := Space(6)
Private cLoja      := Space(2)
Private cDescFor   := Space(40)
Private _oDlg

lSaiu:= .f.

While !lSaiu
	cNumNF  := Space(6)
	cSerNF  := Space(3)
	cFornec := Space(6)
	cLoja   := Space(2)
	cDescFor:= Space(40)

	Define MsDialog _oDlg Title "Consulta - Contas a Pagar" From C(001),C(001) To C(140),C(395) Pixel
	@ C(002),C(003) Jpeg File "\\netuno\Protheus\Protheus_Data\SystemProducao\lgrl02.bmp"  Size C(030),C(008) Pixel NOBORDER   Of _oDlg
	@ C(014),C(003) To C(050),C(195) LABEL ""                                                  Pixel                                 Of _oDlg
	@ C(021),C(005) Say "Titulo / Prefixo:"+Space(26)+"/"  Size C(335),C(007) COLOR CLR_BLACK  Pixel                                 Of _oDlg
	@ C(020),C(040) MsGet cNumNF                           Size C(030),C(007) COLOR CLR_BLACK  Pixel  Picture "@!"                   Of _oDlg
	@ C(020),C(075) MsGet cSerNF                           Size C(008),C(007) COLOR CLR_BLACK  Pixel  Picture "@!"                   Of _oDlg
	@ C(036),C(005) Say "Fornec./ Loja:"                   Size C(035),C(007) COLOR CLR_BLACK  Pixel                                 Of _oDlg
	@ C(035),C(040) MsGet cFornec                F3 "SA2"  Size C(035),C(007) COLOR CLR_BLACK  Pixel  Picture "@!"  Valid VerFor()   Of _oDlg
	@ C(035),C(075) MsGet cLoja                            Size C(013),C(007) COLOR CLR_BLACK  Pixel  Picture "@!"  Valid VerFor()   Of _oDlg
	@ C(035),C(088) MsGet cDescFor                         Size C(100),C(007) COLOR CLR_BLACK  Pixel  Picture "@!"  When .f.         Of _oDlg
	@ C(055),C(006) Button "&Consulta"                     Size C(039),C(012) Action(Ver_NF()) Pixel                                 Of _oDlg   
	Define SButton From C(055),C(170) Type 1 Action (SaiTela() ,_oDlg:End()) Enable      Pixel                                 Of _oDlg 
	Activate MsDialog _oDlg Centered 
EndDo
	
Return



Static Function Ver_NF()
************************
If Empty(cNumNF)
	MsgBox("Favor informar Numero de Tํtulo!!")  
	Return .f.
EndIf

cAliasAnt:= Alias()

dbSelectArea("SZO")
dbSetOrder(1)
MsSeek(xFilial("SZO")+AllTrim(__cUserId))
If !Found()
	MsgBox("Usuแrio nใo autorizado a realizar esse tipo de consulta. Verifique suas permiss๕es com o depto de Custos.")
	DbSelectArea(cAliasAnt)
	Return
EndIf

DbSelectArea("SE2")
DbSetOrder(6)
MsSeek(xFilial("SE2")+cFornec+cLoja+cSerNF+cNumNF)
If !Found()
	MsgBox("Tํtulo nใo encontrado!!!")
	DbSelectArea(cAliasAnt)
	Return .f.
EndIf

If Upper(SubStr(AllTrim(SZO->ZO_CCUSTO),1,6))<>"ZZZZZZ"
   	cVarAux1:= AllTrim(SZO->ZO_CCUSTO)
   	cVarAux1:= StrTran(cVarAux1,"'","")  
   	cVarAux1:= StrTran(cVarAux1,",","*")
      	
	If !(Alltrim(SE2->E2_CCD)$cVarAux1)
		MsgBox("Usuario sem permissใo para consultar essa tํtulo. Centro de custo divergente.")
		DbSelectArea(cAliasAnt)
		Return .f.
   	EndIf
EndIf

nRecno:= SE2->(Recno())
nOpca := 0
nOpc  := 2

nOpca := AxVisual("SE2", nRecno, nOpc,,)

DbSelectArea(cAliasAnt)

cNumNF  := Space(6)
cSerNF  := Space(3)
cFornec := Space(6)
cLoja   := Space(2)
cDescFor:= Space(40)

Return .t.



Static Function VerFor()
************************
cAliasAnt:= Alias()

DbSelectArea("SA2")
DbSetOrder(1)
If MsSeek(xFilial("SA2")+cFornec+cLoja)
	cDescFor:= SA2->A2_NREDUZ
Else
	cDescFor:= Space(30)
EndIf

_oDlg:Refresh()

DbSelectArea(cAliasAnt)

Return .t.



Static Function SaiTela()
*************************
lSaiu:=.t.

Return.t.



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function C(nTam)                                                         
***********************
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     

	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ                                               
	//ณTratamento para tema "Flat"ณ                                               
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         

Return Int(nTam)