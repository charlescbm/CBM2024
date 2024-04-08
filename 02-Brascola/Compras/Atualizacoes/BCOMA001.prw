#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BCOMA001 �Autor  � Marcelo da Cunha   � Data �  11/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Centro de Custo x Gestor                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10/MP11                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BCOMA001()
*********************
PRIVATE aRotina := MenuDef(), cAlias := "SZ5"
PRIVATE cCadastro := OemToAnsi("Centro de Custo x Gestor")
dbSelectArea(cAlias)
mBrowse(6,1,22,75,cAlias)
Return                            
                            
User Function BCA001Man(cAlias,nReg,nOpcx)
**************************************
PRIVATE oDlgGes, oEncGes, oGetGes, aHdrGes, aColGes, aButtons
PRIVATE nOpcm, nLin, nPos, nx, nz, aTELA[0][0], aGETS[0], lVirtual:=.T.
PRIVATE aObjects, aSizeAut, aInfo, aPosObj, aStru, aCampos
PRIVATE l001Visual,l001Inclui,l001Altera,l001Exclui,n001Recno

//��������������������������������������������������������������Ŀ
//� Crio variavel para aumentar tamanho da fonte                 �
//����������������������������������������������������������������
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

//��������������������������������������������������������������Ŀ
//� Variaveis privadas                                           �
//����������������������������������������������������������������
aButtons := {} ; nOpcm := 0
l001Visual := (nOpcx==2) //Visualizar
l001Inclui := (nOpcx==3) //Incluir
l001Altera := (nOpcx==4) //Alteracao
l001Exclui := (nOpcx==5) //Excluir
INCLUI := l001Inclui
ALTERA := l001Altera

//��������������������������������������������������������������Ŀ
//� Carrego variaveis necessarias para o processamento           �
//����������������������������������������������������������������
dbSelectArea("SZ5")
n001Recno := 0
If (!l001Inclui)
	RegToMemory("SZ5",.F.,.F.)
	n001Recno := SZ5->(Recno())
	M->Z5_DESCRIC := Posicione("CTT",1,xFilial("CTT")+M->Z5_custo,"CTT_DESC01")
Else
	RegToMemory("SZ5",.T.)
Endif

//��������������������������������������������������������������Ŀ
//� Montagem do aHeader de cada GetDados                         �
//����������������������������������������������������������������
aCampos := {"Z5_CUSTO","Z5_DESCRIC"}
aHdrGes := u_GDVHeader("SZ5",.T.,NIL,NIL,aCampos)

//��������������������������������������������������������������Ŀ
//� Carregar dados do aCols de cada GetDados                     �
//����������������������������������������������������������������
aColGes := {}
If (!l001Inclui)
	SZ5->(dbSetOrder(1))
	SZ5->(dbSeek(xFilial("SZ5")+M->Z5_custo,.T.))
	While !SZ5->(Eof()).and.(xFilial("SZ5") == SZ5->Z5_filial).and.(SZ5->Z5_custo == M->Z5_custo)
		aadd(aColGes,Array(Len(aHdrGes)+1))
		nLin := Len(aColGes)
		For nx := 1 to Len(aHdrGes)
			nPos := SZ5->(FieldPos(aHdrGes[nx,2]))
			If (nPos > 0)
				aColGes[nLin,nx] := SZ5->(FieldGet(nPos))
			Else
				aColGes[nLin,nx] := CriaVar(aHdrGes[nx,2],.T.)
			Endif
		Next nx
		aColGes[nLin,Len(aHdrGes)+1] := .F.
		SZ5->(dbSkip())
	Enddo	
Endif
If (Len(aColGes) == 0)
	u_GDVZeraCols(@aHdrGes,@aColGes,.T.)
	nPos := GDFieldPos("Z5_SEQUEN",aHdrGes)
	If (Len(aColGes) >= 1).and.(nPos > 0)
		aColGes[1,nPos] := "01"
	Endif
Endif

//��������������������������������������������������������������Ŀ
//� Tela para consulta                                           �
//����������������������������������������������������������������
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0, 022, .T., .F. })
AAdd(aObjects,{  0, 378, .T., .T. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlgGes FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL

//��������������������������������������������������������������Ŀ
//� Cadastro da Rotina                                           �
//����������������������������������������������������������������
oSayCus  := u_GDVSay(oDlgGes,"oSayCus","Centro Custo:",005,aPosObj[1,1]+2)
oGetCus1 := u_GDVGet(oDlgGes,"M->Z5_CUSTO","M->Z5_CUSTO",050,aPosObj[1,1],50,,{|| .T. },,"CTT",{|| ExistCpo("CTT").and.ExistChav("SZ5",M->Z5_custo).and.B001AtuCus() })
oGetCus1:bWhen := {|| l001Inclui }
oGetCus2 := u_GDVGet(oDlgGes,"M->Z5_DESCRIC","M->Z5_DESCRIC",100,aPosObj[1,1],200,,{|| .T. })
oGetCus2:bWhen := {|| .F. }

//��������������������������������������������������������������Ŀ
//� Folder                                                       �
//����������������������������������������������������������������
oGetGes := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],iif(l001Inclui.or.l001Altera,GD_INSERT+GD_UPDATE+GD_DELETE,0),"u_BCA001LinOk()","u_BCA001TudOk()","+Z5_SEQUEN",,,,"u_BCA001ValCampo()",,,oDlgGes,aHdrGes,aColGes)
oGetGes:oBrowse:lUseDefaultColors := .F.
oGetGes:oBrowse:SetBlkBackColor({|| RGB(250,250,250) })

ACTIVATE MSDIALOG oDlgGes ON INIT EnchoiceBar(oDlgGes,{|| iif(u_BCA001TudOk(),(nOpcm:=1,oDlgGes:End()),) },{|| (nOpcm:=0,oDlgGes:End()) },,aButtons)
If (nOpcm == 1).and.!Empty(M->Z5_custo)
	aHeader := aClone(oGetGes:aHeader)
	aCols := aClone(oGetGes:aCols)
	If (l001Inclui).or.(l001Altera)
		dbSelectArea("SZ5")
		SZ5->(dbSetOrder(1))
		For nx := 1 to Len(aCols)
			If !(aCols[nx,Len(aCols[nx])])
				If SZ5->(dbSeek(xFilial("SZ5")+M->Z5_custo+GDFieldGet("Z5_SEQUEN",nx)))
					Reclock("SZ5",.F.)
				Else
					Reclock("SZ5",.T.)
					SZ5->Z5_filial := xFilial("SZ5")
					SZ5->Z5_custo  := M->Z5_custo
					SZ5->Z5_descric:= M->Z5_descric
					SZ5->Z5_sequen := GDFieldGet("Z5_SEQUEN",nx)
				Endif
				For nz := 2 to Len(aHeader)
					nPos := SZ5->(FieldPos(aHeader[nz,2]))
					If (nPos > 0).and.!(aHeader[nz,2] $ "Z5_CUSTO/Z5_SEQUEN")
						SZ5->(FieldPut(nPos,aCols[nx,nz]))
					Endif
				Next nz
				MsUnlock("SZ5")
			Else
				If SZ5->(dbSeek(xFilial("SZ5")+M->Z5_custo+GDFieldGet("Z5_SEQUEN",nx)))
					Reclock("SZ5",.F.)
					SZ5->(dbDelete())
					MsUnlock("SZ5")
			   Endif
			Endif
		Next nx
	Elseif (l001Exclui)
		dbSelectArea("SZ5")
		SZ5->(dbSetOrder(1))
		SZ5->(dbSeek(xFilial("SZ5")+M->Z5_custo,.T.))
		While !SZ5->(Eof()).and.(xFilial("SZ5") == SZ5->Z5_filial).and.(SZ5->Z5_custo == M->Z5_custo)
			Reclock("SZ5",.F.)
			SZ5->(dbDelete())
			MsUnlock("SZ5")
			SZ5->(dbSkip())
		Enddo
	Endif	
Endif

Return

User Function BCA001LinOk()
************************
LOCAL lRetu := .T., na
aHeader := aClone(oGetGes:aHeader)
aCols := aClone(oGetGes:aCols)
For na := 1 to Len(aCols)
	If (na != oGetGes:nAt).and.!(aCols[na,Len(aCols[na])]).and.(GDFieldGet("Z5_CODUSU",na) == GDFieldGet("Z5_CODUSU",oGetGes:nAt))
		Help("",1,"BRASCOLA",,OemToAnsi("Gestor "+GDFieldGet("Z5_CODUSU",oGetGes:nAt)+" j� cadastrado!"),1,0) 
		Return (lRetu := .F.)
	Endif
Next na
Return lRetu

User Function BCA001TudOk()
************************
LOCAL lRetu := .T.
If Empty(M->Z5_custo)
	Help("",1,"BRASCOLA",,OemToAnsi("Favor informar o Centro de Custo!"),1,0) 
	Return (lRetu := .F.)
Endif
Return lRetu 

User Function BCA001ValCampo()
**************************
LOCAL lRetu := .T., cCampo1 := Upper(Alltrim(ReadVar()))
LOCAL nPos1 := GDFieldPos("Z5_NOMUSU",oGetGes:aHeader)
If (cCampo1 == "M->Z5_CODUSU").and.(nPos1 > 0)
	oGetGes:aCols[oGetGes:nAt,nPos1] := UsrFullName(M->Z5_codusu)
	oGetGes:oBrowse:Refresh()
Endif
Return lRetu

User Function BCA001Email(xCusto)
*********************************
LOCAL cRetu := ""
SZ5->(dbSetOrder(1))
SZ5->(dbSeek(xFilial("SZ5")+xCusto,.T.))
While !SZ5->(Eof()).and.(xFilial("SZ5") == SZ5->Z5_filial).and.(SZ5->Z5_custo == xCusto)
	If (SZ5->Z5_msblql != "1") //Bloqueado
		cRetu += Alltrim(UsrRetMail(SZ5->Z5_codusu))+";"
	Endif
	SZ5->(dbSkip())
Enddo
Return cRetu

Static Function B001AtuCus()
*************************
LOCAL lRetu := .T.
M->Z5_DESCRIC := Space(TamSX3("Z5_DESCRIC")[1])
CTT->(dbSetOrder(1))
If CTT->(dbSeek(xFilial("CTT")+M->Z5_custo))
	M->Z5_DESCRIC := CTT->CTT_desc01
	oGetCus2:cText := M->Z5_DESCRIC
Endif
If (oGetCus2 != Nil)
	oGetCus2:Refresh()
Endif
Return lRetu 

Static Function MenuDef()                   
**********************
PRIVATE aRotina := {{ OemToAnsi("Pesquisar"),"AxPesqui"    , 0 , 1,0,.F.},;
	               { OemToAnsi("Visualizar") ,"u_BCA001Man" , 0 , 2,0,NIL},;
	               { OemToAnsi("Incluir")    ,"u_BCA001Man" , 0 , 3,0,NIL},;
                  { OemToAnsi("Alterar")    ,"u_BCA001Man" , 0 , 4,0,NIL},;
	               { OemToAnsi("Excluir")    ,"u_BCA001Man" , 0 , 5,0,NIL} }
Return(aRotina) 