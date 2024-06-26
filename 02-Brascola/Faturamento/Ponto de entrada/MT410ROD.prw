#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "colors.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410ROD �Autor  � Marcelo da Cunha   � Data �  07/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para adicionar funcao para tratamento da  ���
���          � rentabilidade.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410ROD()
**********************              
LOCAL aParam := paramixb, lFlagLuc := SuperGetMv("BR_FLAGLUC",.F.,.F.)
                          
If (lFlagLuc)
	If (!INCLUI).and.(!ALTERA).and.(Type("oGetD") == "O")
		oGetDad := oGetD
	Endif
	If (Type("oGetDad") == "O").and.(oGetDad != Nil).and.(oGetDad:oBrowse:lUseDefaultColors)
		oGetDad:oBrowse:lUseDefaultColors := .F.
		oGetDad:oBrowse:SetBlkBackColor({|| u_BPE410ROD(aHeader,aCols,N) })
		oGetDad:oBrowse:Refresh() 
		oDlgA := oGetDad:oWnd
		If (ValType(oDlgA) == "O").and.(oDlgA != Nil)
			@ (oGetDad:oBrowse:nClientHeight)+22,005 BITMAP oBmp RESNAME "PMSTASK6" OF oDlgA SIZE 20,10 PIXEL NOBORDER
			@ (oGetDad:oBrowse:nClientHeight)+20,015 SAY "IDEAL" SIZE 60,10 OF oDlgA PIXEL 
			@ (oGetDad:oBrowse:nClientHeight)+22,035 BITMAP oBmp RESNAME "PMSTASK4" OF oDlgA SIZE 20,10 PIXEL NOBORDER
			@ (oGetDad:oBrowse:nClientHeight)+20,045 SAY "BOM" SIZE 60,10 OF oDlgA PIXEL 
			@ (oGetDad:oBrowse:nClientHeight)+22,065 BITMAP oBmp RESNAME "PMSTASK5" OF oDlgA SIZE 20,10 PIXEL NOBORDER
			@ (oGetDad:oBrowse:nClientHeight)+20,075 SAY "ATENCAO!" SIZE 60,10 OF oDlgA PIXEL 
			@ (oGetDad:oBrowse:nClientHeight)+22,110 BITMAP oBmp RESNAME "PMSTASK1" OF oDlgA SIZE 20,10 PIXEL NOBORDER
			@ (oGetDad:oBrowse:nClientHeight)+20,120 SAY "COM RESTRICOES" SIZE 60,10 OF oDlgA PIXEL COLOR CLR_HRED 
			If (!INCLUI)
				@ (oGetDad:oBrowse:nClientHeight)+20,210 BITMAP oBmp RESNAME "BR_VERDE" OF oDlgA SIZE 20,10 PIXEL NOBORDER
				@ (oGetDad:oBrowse:nClientHeight)+20,220 SAY "Item em Aberto" SIZE 80,10 OF oDlgA PIXEL 
				@ (oGetDad:oBrowse:nClientHeight)+20,260 BITMAP oBmp RESNAME "BR_CINZA" OF oDlgA SIZE 20,10 PIXEL NOBORDER
				@ (oGetDad:oBrowse:nClientHeight)+20,270 SAY "Item Parcialmente Entregue" SIZE 80,10 OF oDlgA PIXEL 
				@ (oGetDad:oBrowse:nClientHeight)+20,340 BITMAP oBmp RESNAME "BR_VERMELHO" OF oDlgA SIZE 20,10 PIXEL NOBORDER
				@ (oGetDad:oBrowse:nClientHeight)+20,350 SAY "Item Totalmente Entregue" SIZE 80,10 OF oDlgA PIXEL 
			Endif
		Endif
	Endif
Endif
Eval(aParam[1],aParam[2],IIF(aParam[4]!=0,aParam[3],aParam[5]),aParam[4],aParam[5])

Return

User Function BPE410ROD(xHeader,xCols,xAt)
**************************************
LOCAL nRetu := RGB(250,250,250)
LOCAL	nPLuc := GDFieldPos("C6_FLAGLUC",xHeader)
LOCAL	nPSta := GDFieldPos("C6_X_STATU",xHeader)
LOCAL	nPIte := GDFieldPos("C6_ITEM",xHeader)
If (nPLuc > 0)
	If (xCols[xAt,nPLuc] == "D") //Vermelho
		nRetu := RGB(250,190,190)
	Elseif (xCols[xAt,nPLuc] == "C") //Amarelo
		nRetu := RGB(245,245,180)
	Elseif (xCols[xAt,nPLuc] == "B") //Verde
		nRetu := RGB(150,245,190)
	Elseif (xCols[xAt,nPLuc] == "A") //Azul
		nRetu := RGB(150,210,250)	
	Endif
Endif
If (nPSta > 0).and.(nPIte > 0).and.(!INCLUI)    
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+M->C5_num+xCols[xAt,nPIte],.T.))
	If (SC6->C6_qtdent >= SC6->C6_qtdven).or.(SC6->C6_blq == "R ")
		aCols[xAt,nPSta] := LoadBitMap(GetResources(),"BR_VERMELHO")
	Elseif (SC6->C6_qtdent == 0)
		aCols[xAt,nPSta] := LoadBitMap(GetResources(),"BR_VERDE")
	Else
		aCols[xAt,nPSta] := LoadBitMap(GetResources(),"BR_CINZA")
	Endif
Endif
Return nRetu

User Function M410VIS()
********************
_SetOwnerPrvt("oGetD",Nil)
Return