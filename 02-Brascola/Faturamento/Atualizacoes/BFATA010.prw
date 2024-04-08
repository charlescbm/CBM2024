#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "colors.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATA010 ºAutor  ³ Marcelo da Cunha   º Data ³  27/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para Liberacao de Desconto do Pedido de Venda     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                
User Function BFATA010()
*********************
PRIVATE oDlgDsc, oGetDsc, oBmp, nDescMax := 0, n010PPed, n010PIte, n010PLuc
PRIVATE c010Status, a010Status := {}, a010ColOri := {}, c010Pedido := Space(6), n010PerLuc := 0
PRIVATE cCadastro := OemToAnsi("Libera‡„o de Desconto do Pedidos de Venda"), n010PerOri := 0
PRIVATE oVerde := LoadBitmap(GetResources(),"BR_VERDE"), oVerme := LoadBitmap(GetResources(),"BR_VERMELHO")
PRIVATE oPreto := LoadBitmap(GetResources(),"BR_PRETO"), aObjects := {}, aSizeAut := {}, aInfo := {}, aPosObj := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Verifico se usuario possui acesso a rotina               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (!SuperGetMv("BR_ALNOVA",.F.,.F.)) //Parametro para ativar Alcada
	Help("",1,"BRASCOLA",,OemToAnsi("Rotina esta Desativada. Verificar parametro BR_ALNOVA."),1,0) 
	Return
Endif
nDescMax := 0
If (Alltrim(cUserName) $ SuperGetMv("BR_ALUSERM",.F.,""))
	nDescMax := 999
Else
	SA3->(dbSetOrder(7)) //UserID
	If !SA3->(dbSeek(xFilial("SA3")+__cUserID))
		Help("",1,"BRASCOLA",,OemToAnsi("Usuario sem acesso na rotina de liberacao."),1,0) 
		Return
	Endif
	If (SA3->A3_tipocad == "1") //Presidencia
		nDescMax := SuperGetMv("BR_ALDESCP",.F.,55)
	Elseif (SA3->A3_tipocad == "2") //Diretoria
		nDescMax := SuperGetMv("BR_ALDESCD",.F.,30)
	Elseif (SA3->A3_tipocad == "3") //Gerencial
		nDescMax := SuperGetMv("BR_ALDESCG",.F.,22)
	Elseif (SA3->A3_tipocad == "4") //Supervisao
		nDescMax := SuperGetMv("BR_ALDESCS",.F.,18)
	Elseif (SA3->A3_tipocad == "5") //Representante
		nDescMax := SuperGetMv("BR_ALDESCR",.F.,15)
	Endif
Endif
If (nDescMax <= 0)
	Help("",1,"BRASCOLA",,OemToAnsi("Usuario sem desconto maximo configurado."),1,0) 
	Return
Endif
   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Abertura da tebala de liberacao de descontos             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZ3")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Monto aHeader e aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; aRotina := {{"","",0,1},{"","",0,2},{"","",0,3}}
aadd(aHeader,{"","CHECKBOX","@BMP",2,00,,,"C",,"V"})
SX3->(dbSetOrder(1))
SX3->(dbSeek("SZ3",.T.))
While !SX3->(Eof()).and.(SX3->X3_arquivo == "SZ3")
	If (cNivel >= SX3->X3_nivel).and.X3Uso(SX3->X3_usado).and.(SX3->X3_browse == "S")
		aadd(aHeader,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,;
		SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT})
	Endif
	SX3->(dbSkip())
Enddo
n010PPed := GDFieldPos("Z3_PEDIDO",aHeader)
n010PIte := GDFieldPos("Z3_ITEM",aHeader)
n010PLuc := GDFieldPos("Z3_FLAGLUC",aHeader)
a010Status := {"T=Todos","B=Bloqueados","L=Liberados","R=Rejeitados"}
c010Status :=  Left(a010Status[2],1)
                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Monto tela para mostrar Pedidos Bloqueados               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  16, .T., .F. })
AAdd(aObjects,{  0, 350, .T., .T. })
AAdd(aObjects,{  0,  12, .T., .F. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlgDsc TITLE cCadastro FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF GetWndDefault() PIXEL
@ aPosObj[1,1]+1,005 SAY "Mostrar:" SIZE 60,10 OF oDlgDsc PIXEL 
@ aPosObj[1,1],030 COMBOBOX c010Status ITEMS a010Status VALID BF010Atualiza() SIZE 60,10 PIXEL OF oDlgDsc 
@ aPosObj[1,1]+1,105 SAY "Pedido:" SIZE 50,10 OF oDlgDsc PIXEL 
@ aPosObj[1,1],130 GET c010Pedido SIZE 50,10 OF oDlgDsc PIXEL 
@ aPosObj[1,1],210 BUTTON "Atualizar" SIZE 50,12 ACTION BF010Atualiza() OF oDlgDsc PIXEL
@ aPosObj[1,1],260 BUTTON "Pedido"    SIZE 50,12 ACTION BF010Pedido() OF oDlgDsc PIXEL
@ aPosObj[1,1],310 BUTTON "Analise"   SIZE 50,12 ACTION BF010Analise() OF oDlgDsc PIXEL
@ aPosObj[1,1],360 BUTTON "Legenda"   SIZE 50,12 ACTION BF010Legend() OF oDlgDsc PIXEL
@ aPosObj[1,1],410 BUTTON "Fechar"    SIZE 50,12 ACTION oDlgDsc:End() OF oDlgDsc PIXEL
oGetDsc := MsNewGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgDsc,aHeader,aCols)
oGetDsc:oBrowse:lUseDefaultColors := .F.
oGetDsc:oBrowse:SetBlkBackColor({|| B010CorBrw(oGetDsc:aHeader,oGetDsc:aCols,oGetDsc:nAt) })
@ aPosObj[3,1],005 BITMAP oBmp RESNAME "PMSTASK6" OF oDlgDsc SIZE 20,10 PIXEL NOBORDER
@ aPosObj[3,1],015 SAY "IDEAL" SIZE 60,10 OF oDlgDsc PIXEL 
@ aPosObj[3,1]+2,035 BITMAP oBmp RESNAME "PMSTASK4" OF oDlgDsc SIZE 20,10 PIXEL NOBORDER
@ aPosObj[3,1],045 SAY "BOM" SIZE 60,10 OF oDlgDsc PIXEL 
@ aPosObj[3,1]+2,065 BITMAP oBmp RESNAME "PMSTASK5" OF oDlgDsc SIZE 20,10 PIXEL NOBORDER
@ aPosObj[3,1],075 SAY "ATENCAO!" SIZE 60,10 OF oDlgDsc PIXEL 
@ aPosObj[3,1]+2,110 BITMAP oBmp RESNAME "PMSTASK1" OF oDlgDsc SIZE 20,10 PIXEL NOBORDER
@ aPosObj[3,1],120 SAY "COM RESTRICOES" SIZE 60,10 OF oDlgDsc PIXEL COLOR CLR_HRED 
BF010Atualiza() //Atualizo Browse
ACTIVATE MSDIALOG oDlgDsc CENTERED

Return               

Static Function BF010Atualiza()
***************************
LOCAL lRetu1 := .T., cQuery1 := "", cFilRep1 := "", aCols1 := {}, nn, nPos1, nPos2 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se pedido esta liberado por desconto            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT Z3.R_E_C_N_O_ MRECSZ3,C6.R_E_C_N_O_ MRECSC6 "
cQuery1 += "FROM "+RetSqlName("SZ3")+" Z3,"+RetSqlName("SC6")+" C6 "
cQuery1 += "WHERE Z3.D_E_L_E_T_ = '' AND Z3.Z3_FILIAL = '"+xFilial("SZ3")+"' "
cQuery1 += "AND C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery1 += "AND C6.C6_NUM = Z3.Z3_PEDIDO AND C6.C6_ITEM = Z3.Z3_ITEM "
cQuery1 += "AND Z3.Z3_DESCONT <= "+Alltrim(Str(nDescMax))+" "
If (Left(c010Status,1) == "B")
	cQuery1 += "AND C6.C6_X_BLDSC = 'B' "
Elseif (Left(c010Status,1) == "L") 
	cQuery1 += "AND C6.C6_X_BLDSC = 'L' "
Elseif (Left(c010Status,1) == "R") 
	cQuery1 += "AND C6.C6_X_BLDSC = 'R' "
Endif
If !Empty(c010Pedido)
	cQuery1 += "AND Z3.Z3_PEDIDO = '"+c010Pedido+"' "
Endif
cFilRep1 := u_BXRepLst("SQL")   
If !Empty(cFilRep1)
	cQuery1 += "AND Z3.Z3_VEND IN ("+cFilRep1+") "
Endif
cQuery1 += "ORDER BY Z3.Z3_PEDIDO,Z3.Z3_ITEM "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSZ3") <> 0)
	dbSelectArea("MSZ3")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSZ3"
SZ3->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
dbSelectArea("MSZ3")
While !MSZ3->(Eof())
	SZ3->(dbGoto(MSZ3->MRECSZ3))
	SC6->(dbGoto(MSZ3->MRECSC6))
	aadd(aCols1,Array(Len(oGetDsc:aHeader)+1))
	nPos1 := Len(aCols1)
	If (SC6->C6_x_bldsc == "L") //Liberado
		aCols1[nPos1,1] := oVerde
	Elseif (SC6->C6_x_bldsc == "B") //Bloqueado
		aCols1[nPos1,1] := oVerme
	Elseif (SC6->C6_x_bldsc == "R") //Rejeitado
		aCols1[nPos1,1] := oPreto
	Endif
	For nn := 2 to Len(oGetDsc:aHeader) 
		nPos2 := SZ3->(FieldPos(oGetDsc:aHeader[nn,2]))
		If (nPos2 > 0)
			aCols1[nPos1,nn] := SZ3->(FieldGet(nPos2))
		Endif
	Next nn
	aCols1[nPos1,Len(oGetDsc:aHeader)+1] := .F.
	MSZ3->(dbSkip())	
Enddo
If (Select("MSZ3") <> 0)
	dbSelectArea("MSZ3")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo MsNewGetDados                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetDsc:aCols := aClone(aCols1)
oGetDsc:oBrowse:Refresh()

Return lRetu1

Static Function BF010Pedido()
**************************
If (Len(oGetDsc:aCols) > 0).and.(oGetDsc:nAt > 0)
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+oGetDsc:aCols[oGetDsc:nAt,n010PPed]))
		u_E410VISU("SC5",SC5->(Recno()),2)
	Endif
Endif
Return

Static Function BF010Legend()
**************************
LOCAL aCores := {{"ENABLE","Item com Desconto Liberado"},{"DISABLE","Item com Desconto Bloqueado"},{"BR_PRETO","Item com Desconto Rejeitado"}}
BrwLegenda(cCadastro,"Legenda",aCores)
Return      

Static Function BF010Analise()
***************************
PRIVATE oDlgAna, oGetAna, oBmpStaA, oBmpStaB, cPedAna := Space(6)
PRIVATE oTotAna, cTotal := "", oPedStaB, cPedStaB := ""
PRIVATE nPAnaIte, nPAnaPro, nPAnaQtd, nPAnaPrc, nPAnaVal, nPAnaDsc, nPAnaBlq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Valido Pedido de Venda                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(oGetDsc:aCols) > 0).and.(oGetDsc:nAt > 0)
	cPedAna := oGetDsc:aCols[oGetDsc:nAt,n010PPed]
Endif
If Empty(cPedAna)
	Help("",1,"BRASCOLA",,OemToAnsi("Selecionar um pedido para teste!"),1,0)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Monto aHeader e aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {}
aadd(aHeader,{"","C6_X_STATU","@BMP",2,00,,,"C",,"V"})
SB1->(dbSetOrder(1)) ; SC5->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+cPedAna,.T.))
cSeek  := xFilial("SC6")+SC5->C5_NUM
bWhile := {|| C6_FILIAL+C6_NUM }
FillGetDados(2,"SC6",1,cSeek,bWhile,/*{{bCond,NIL,NIL}}*/,{"CHECKBOX"},/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,/*{|| AfterCols(cArqQry) }*/,/*bBeforeCols*/,/*bAfterHeader*/,"SC6")
If (Len(aCols) <= 0)
	Return
Endif
nPAnaIte := GDFieldPos("C6_ITEM")
nPAnaPro := GDFieldPos("C6_PRODUTO")
nPAnaQtd := GDFieldPos("C6_QTDVEN")  
nPAnaPrc := GDFieldPos("C6_PRCVEN")  
nPAnaVal := GDFieldPos("C6_VALOR")   
nPAnaDsc := GDFieldPos("C6_DESCONT")  
nPAnaBlq := GDFieldPos("C6_X_BLDSC")  
For nx := 1 to Len(aCols)
	If (aCols[nx,nPAnaBlq] == "L") //Liberado
		aCols[nx,1] := oVerde
	Elseif (aCols[nx,nPAnaBlq] == "B") //Bloqueado
		aCols[nx,1] := oVerme
	Elseif (aCols[nx,nPAnaBlq] == "R") //Rejeitado
		aCols[nx,1] := oPreto
	Endif
Next nx
a010ColOri := aClone(aCols)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Crio variaveis de memoria para funcoes padrao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC5")
RegToMemory("SC5",.F.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Monto tela para mostrar Analise de Pedidos               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  16, .T., .F. })
AAdd(aObjects,{  0,  16, .T., .F. })
AAdd(aObjects,{  0, 350, .T., .T. })
AAdd(aObjects,{  0,  12, .T., .F. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlgAna TITLE cCadastro+" - Analise" FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  OF GetWndDefault() PIXEL
@ aPosObj[1,1],005 SAY "Pedido: "+cPedAna SIZE 60,10 OF oDlgAna PIXEL COLOR CLR_GREEN
@ aPosObj[1,1],085 SAY oTotAna VAR cTotal SIZE 90,10 OF oDlgAna PIXEL COLOR CLR_GREEN
@ aPosObj[1,1],165 SAY "Cliente: "+SC5->C5_cliente+"/"+SC5->C5_lojacli+" - "+Alltrim(Posicione("SA1",1,xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,"A1_NOME")) SIZE 300,10 OF oDlgAna PIXEL COLOR CLR_GREEN
@ aPosObj[2,1],005 BUTTON "Libera Item"   SIZE 50,12 ACTION BF010LibRej(1) OF oDlgAna PIXEL
@ aPosObj[2,1],055 BUTTON "Libera Pedido" SIZE 50,12 ACTION BF010LibRej(2) OF oDlgAna PIXEL
@ aPosObj[2,1],105 BUTTON "Rejeita Item"  SIZE 50,12 ACTION BF010LibRej(3) OF oDlgAna PIXEL
@ aPosObj[2,1],155 BUTTON "Proposta Pedido"  SIZE 50,12 ACTION BF010AnaProp() OF oDlgAna PIXEL
@ aPosObj[2,1],205 BUTTON "Legenda"   SIZE 50,12 ACTION BF010Legend() OF oDlgAna PIXEL
@ aPosObj[2,1],255 BUTTON "Fechar" SIZE 50,12 ACTION oDlgAna:End() OF oDlgAna PIXEL
oGetAna := MsNewGetDados():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],GD_UPDATE,"AllwaysTrue","AllwaysTrue",,{"C6_DESCONT"},,,"u_BF010CmpAna",,,oDlgAna,aHeader,aCols)
PRIVATE oGetDad := oGetAna
oGetAna:oBrowse:lUseDefaultColors := .F.
oGetAna:oBrowse:SetBlkBackColor({|| B010CorBrw(oGetAna:aHeader,oGetAna:aCols,oGetAna:nAt) })
@ aPosObj[4,1]+2,005 BITMAP oBmpStaA RESNAME "PMSTASK6" OF oDlgAna SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],015 SAY "IDEAL" SIZE 60,10 OF oDlgAna PIXEL 
@ aPosObj[4,1]+2,035 BITMAP oBmpStaA RESNAME "PMSTASK4" OF oDlgAna SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],045 SAY "BOM" SIZE 60,10 OF oDlgAna PIXEL 
@ aPosObj[4,1]+2,065 BITMAP oBmpStaA RESNAME "PMSTASK5" OF oDlgAna SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],075 SAY "ATENCAO!" SIZE 60,10 OF oDlgAna PIXEL 
@ aPosObj[4,1]+2,110 BITMAP oBmpStaA RESNAME "PMSTASK1" OF oDlgAna SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],120 SAY "COM RESTRICOES" SIZE 60,10 OF oDlgAna PIXEL COLOR CLR_HRED
@ aPosObj[4,1]+2,240 BITMAP oBmpStaB RESNAME "PMSTASK6" OF oDlgAna SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],250 SAY oPedStaB VAR cPedStaB SIZE 120,10 OF oDlgAna PIXEL           
BF010CalcAna(@n010PerOri)
ACTIVATE MSDIALOG oDlgAna CENTERED
                                 
BF010Atualiza() //Atualizo Browse

Return

User Function BF010CmpAna()
************************
LOCAL lRetu := .T.
If (oGetAna:aCols[oGetAna:nAt,nPAnaBlq] != "B")
	Help("",1,"BRASCOLA",,OemToAnsi("Item nao esta bloqueado!"),1,0) 
	Return (lRetu := .F.)
Endif
oGetAna:aCols[oGetAna:nAt,nPAnaDsc] := M->C6_descont
BF010CalcAna()
Return lRetu

Static Function BF010CalcAna(x010PerOri)
************************************
LOCAL aRetu:={}, aProdutos:={}, nValLuc:=0, nPrcNov:=0, nPerLuc:=0, nTotal1:=0, nn
For nn := 1 to Len(oGetAna:aCols)
	aadd(aProdutos,{oGetAna:aCols[nn,nPAnaPro],oGetAna:aCols[nn,nPAnaQtd],oGetAna:aCols[nn,nPAnaPrc],oGetAna:aCols[nn,nPAnaDsc]})
	nTotal1 += oGetAna:aCols[nn,nPAnaVal]
Next nn
If (Len(aCols) <= 0)
	Return
Endif
u_BRAXCUS(SC5->C5_tabela,aProdutos,,@aRetu)
For nn := 1 to Len(aRetu[2])
	nValLuc += aRetu[2,nn,GDFieldPos("MM_VALLUC",aRetu[1])]
	nPrcNov += aRetu[2,nn,GDFieldPos("MM_PRCNOV",aRetu[1])]
Next nn
If (nPrcNov != 0)
	nPerLuc := (nValLuc/nPrcNov)*100
Endif
oTotAna:cCaption := "Total Pedido: "+Alltrim(TransForm(nTotal1,PesqPict("SC6","C6_VALOR"))) 
oTotAna:Refresh()
If (nPerLuc >= 40)
	oBmpStaB:cResName := "PMSTASK6"
	oPedStaB:cCaption := "PEDIDO "+cPedAna+" IDEAL"
Elseif (nPerLuc >= 20).and.(nPerLuc < 40)
	oBmpStaB:cResName := "PMSTASK4"
	oPedStaB:cCaption := "PEDIDO "+cPedAna+" BOM"
Elseif (nPerLuc >= 0).and.(nPerLuc < 20)
	oBmpStaB:cResName := "PMSTASK5"
	oPedStaB:cCaption := "PEDIDO "+cPedAna+" ATENCAO!"
Elseif (nPerLuc < 0)
	oBmpStaB:cResName := "PMSTASK1"
	oPedStaB:cCaption := "PEDIDO "+cPedAna+" COM RESTRICOES"
Endif       
If (x010PerOri != Nil)
	n010PerOri := nPerLuc
Endif
n010PerLuc := nPerLuc
oBmpStaB:Refresh()
oPedStaB:Refresh()
Return

Static Function BF010LibRej(xOpca)
*******************************
PRIVATE oDlgLib, oBmp, cObsLib := "", nOpcLib := 0, cPedLib := Space(6), cIteLib := Space(2)
PRIVATE cCadLib := "", cItem := "", nQtdVen := 0, nValor := 0, nDescon := 0, aItens := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Verifico se o item ja foi liberado                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
cPedLib := cPedAna
If Empty(cPedLib).or.(Len(oGetAna:aCols) <= 0)
	Return
Endif
If (xOpca == 2) //Libera por Pedido
	For nx := 1 to Len(oGetAna:aCols)
		If (oGetAna:aCols[nx,GDFieldPos("C6_X_BLDSC",oGetAna:aHeader)] == "B")
			aadd(aItens,oGetAna:aCols[nx,GDFieldPos("C6_ITEM",oGetAna:aHeader)])
		Endif
	Next nx
Elseif (oGetAna:aCols[oGetAna:nAt,GDFieldPos("C6_X_BLDSC",oGetAna:aHeader)] == "B") //Libera/Rejeita por Item
	aadd(aItens,oGetAna:aCols[oGetAna:nAt,GDFieldPos("C6_ITEM",oGetAna:aHeader)])
Endif
If (Len(aItens) <= 0)
	If (xOpca != 3)
		Help("",1,"BRASCOLA",,OemToAnsi("Sem itens para liberaçã!"),1,0) 
		Return
	Else
		Help("",1,"BRASCOLA",,OemToAnsi("Sem itens para rejeição!"),1,0) 
		Return
	Endif
Endif
SZ3->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
For nx := 1 to Len(aItens)
	If !SZ3->(dbSeek(xFilial("SZ3")+cPedLib+aItens[nx]))
		Return
	Endif
	If !Empty(SZ3->Z3_datalib)
		Help("",1,"BRASCOLA",,OemToAnsi("Pedido/Item "+SZ3->Z3_pedido+SZ3->Z3_item+" ja foi liberado/rejeitado!"),1,0) 
		Loop
	Endif
	If !SC6->(dbSeek(xFilial("SC6")+SZ3->Z3_pedido+SZ3->Z3_item))
		Help("",1,"BRASCOLA",,OemToAnsi("Pedido/Item "+SZ3->Z3_pedido+SZ3->Z3_item+" nao foi encontrado!"),1,0) 
		Loop
	Elseif (SC6->C6_bloquei != "02").or.(SC6->C6_x_bldsc == "L")
		Help("",1,"BRASCOLA",,OemToAnsi("Pedido/Item "+SZ3->Z3_pedido+SZ3->Z3_item+" ja esta liberado!"),1,0) 
		Loop
	Endif
	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek(xFilial("SB1")+SC6->C6_produto))
		Help("",1,"BRASCOLA",,OemToAnsi("Produto  "+SC6->C6_produto+" nao encontrado!"),1,0) 
		Loop
	Endif
	cItem += SC6->C6_item+"/"
	nQtdVen += SC6->C6_qtdven
	nValor  += SC6->C6_valor
	nDescon := SC6->C6_descont
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Rotina para liberar o item posicionado                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
cObsLib := Space(200)
If (xOpca == 1)
	cCadLib := "Liberação do Item do Pedido de Venda"
Elseif (xOpca == 2)
	cCadLib := "Liberação do Pedido de Venda"
Elseif (xOpca == 2)
	cCadLib := "Rejeição do Item do Pedido de Venda"
Endif
DEFINE MSDIALOG oDlgLib FROM 000,000 TO 200,560 TITLE OemToAnsi(cCadLib) Of oMainWnd PIXEL
@ 008,010 SAY "Pedido: "+SC6->C6_num SIZE 60,10 PIXEL COLOR CLR_GREEN
@ 008,060 SAY "Item: "+cItem SIZE 60,10 PIXEL COLOR CLR_GREEN
@ 008,120 SAY "Produto: "+Alltrim(SC6->C6_produto)+" - "+Alltrim(SB1->B1_desc) SIZE 200,10 PIXEL COLOR CLR_GREEN
@ 020,010 SAY "Cliente: "+SZ3->Z3_cliente+"/"+SZ3->Z3_loja+"-"+Alltrim(SZ3->Z3_nomcli) SIZE 180,10 PIXEL COLOR CLR_GREEN
@ 032,010 SAY "Quantidade: "+Transform(nQtdVen,PesqPict("SC6","C6_QTDVEN")) SIZE 60,10 PIXEL COLOR CLR_GREEN 
@ 032,080 SAY "Valor Total: "+Transform(nValor,PesqPict("SC6","C6_VALOR")) SIZE 60,10 PIXEL COLOR CLR_GREEN
If (xOpca != 2)
	@ 032,150 SAY "Desconto: "+Transform(nDescon,PesqPict("SC6","C6_DESCONT"))+"%" SIZE 60,10 PIXEL COLOR CLR_GREEN
Endif
@ 044,010 SAY "Observacao: " SIZE 50,10 PIXEL COLOR CLR_BLUE
@ 042,045 GET cObsLib SIZE 200,012 PIXEL 
@ 070,010 BUTTON OemToAnsi(iif(xOpca!=3,"Liberar","Rejeitar")) SIZE 50,10 PIXEL ACTION iif(u_BF010ValLib(xOpca),(nOpcLib:=xOpca,Close(oDlgLib)),)
@ 070,060 BUTTON OemToAnsi("Fechar")  SIZE 50,10 PIXEL ACTION Close(oDlgLib)
If (xOpca != 2).and.(SC6->(FieldPos("C6_FLAGLUC")) > 0)
	If (SC6->C6_flagluc == "A")     
		@ 072,130 BITMAP oBmp RESNAME "PMSTASK6" OF oDlgLib SIZE 20,10 PIXEL NOBORDER
		@ 070,140 SAY "ITEM DO PEDIDO "+SC6->C6_num+" IDEAL" SIZE 180,10 PIXEL COLOR CLR_BLUE
	Elseif (SC6->C6_flagluc == "B")    
		@ 072,130 BITMAP oBmp RESNAME "PMSTASK4" OF oDlgLib SIZE 20,10 PIXEL NOBORDER
		@ 070,140 SAY "ITEM DO PEDIDO "+SC6->C6_num+" BOM" SIZE 180,10 PIXEL COLOR CLR_BLUE
	Elseif (SC6->C6_flagluc == "C")    
		@ 072,130 BITMAP oBmp RESNAME "PMSTASK5" OF oDlgLib SIZE 20,10 PIXEL NOBORDER
		@ 070,140 SAY "ITEM DO PEDIDO "+SC6->C6_num+" ATENCAO!" SIZE 180,10 PIXEL COLOR CLR_BLUE
	Elseif (SC6->C6_flagluc == "D")                                  
		@ 072,130 BITMAP oBmp RESNAME "PMSTASK1" OF oDlgLib SIZE 20,10 PIXEL NOBORDER
		@ 070,140 SAY "ITEM DO PEDIDO "+SC6->C6_num+" COM RESTRICOES" SIZE 180,10 PIXEL COLOR CLR_HRED
	Endif
Endif
ACTIVATE MSDIALOG oDlgLib CENTERED
If (nOpcLib == 1).or.(nOpcLib == 2).or.(nOpcLib == 3)
	SZ3->(dbSetOrder(1))
	For nx := 1 to Len(aItens)
		If SZ3->(dbSeek(xFilial("SZ3")+cPedLib+aItens[nx]))
			Reclock("SZ3",.F.)
			SZ3->Z3_datalib := MsDate()
			SZ3->Z3_horalib := Time()
			SZ3->Z3_userlib := cUserName
			SZ3->Z3_obslib  := cObsLib
			MsUnlock("SZ3")
			If SC6->(dbSeek(xFilial("SC6")+SZ3->Z3_pedido+SZ3->Z3_item))
				Reclock("SC6",.F.)
				SC6->C6_bloquei := Space(Len(SC6->C6_bloquei))
				SC6->C6_x_bldsc := iif(nOpcLib!=3,"L","R") //Liberado ou Rejeitado
				MsUnlock("SC6")
				nPItem := GDFieldPos("C6_ITEM",oGetAna:aHeader)
				nLinha := aScan(oGetAna:aCols, { |x| x[nPItem] == SC6->C6_item })
				If (nLinha > 0)
					If (GDFieldPos("C6_BLOQUEI",oGetAna:aHeader) > 0)
						oGetAna:aCols[nLinha,GDFieldPos("C6_BLOQUEI",oGetAna:aHeader)] := SC6->C6_bloquei
					Endif
					If (GDFieldPos("C6_X_BLDSC",oGetAna:aHeader) > 0)
						oGetAna:aCols[nLinha,GDFieldPos("C6_X_BLDSC",oGetAna:aHeader)] := SC6->C6_x_bldsc
						If (SC6->C6_x_bldsc == "L") //Liberado
							oGetAna:aCols[nLinha,1] := oVerde
						Elseif (SC6->C6_x_bldsc == "B") //Bloqueado
							oGetAna:aCols[nLinha,1] := oVerme
						Elseif (SC6->C6_x_bldsc == "R") //Rejeitado
							oGetAna:aCols[nLinha,1] := oPreto
						Endif
					Endif				
				Endif
				B010AvalBlq(SZ3->Z3_pedido)
				If (SC6->C6_x_bldsc == "R")
					SC5->(dbSeek(xFilial("SC5")+SC6->C6_num,.T.))
					If Empty(SC5->C5_pedexp).and.Empty(SC6->C6_reserva).and.!(SC6->C6_blq$"R #S ")
						BF010AvResRep() //Enviar aviso para representante sobre item eliminado
						MaResDoFat(,.T.,.T.)
					Endif
				Endif                        
			Endif
		Endif
	Next nx        
	oGetAna:oBrowse:Refresh()
	BF010CalcAna(@n010PerOri) //Atualizo Tela de Analise
	BF010Atualiza() //Atualizo Browse
Endif

Return 

User Function BF010ValLib(xOpca)
*****************************
LOCAL lRetu := .T.
If Empty(cObsLib)
	Help("",1,"BRASCOLA",,OemToAnsi("Informar a observacao para "+iif(xOpca!=3,"liberacao","rejeicao")+"!"),1,0)
	Return (lRetu := .F.)
Elseif (xOpca != 3).and.!MsgYesNo("Confirma liberação do desconto ? ")
	Return (lRetu := .F.)
Elseif (xOpca == 3).and.!MsgYesNo("Confirma rejeição do desconto ? ")
	Return (lRetu := .F.)
Endif
Return (lRetu)
                                    
Static Function B010AvalBlq(xPedido)
********************************
LOCAL cQuery1 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se pedido esta liberado por desconto            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT COUNT(*) M_CONTA FROM "+RetSqlName("SC6")+" (NOLOCK) "
cQuery1 += "WHERE D_E_L_E_T_ = '' AND C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery1 += "AND C6_NUM = '"+xPedido+"' AND C6_BLQ <> 'R' AND C6_X_BLDSC = 'B' "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MLIB") <> 0)
	dbSelectArea("MLIB")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MLIB"
If !MLIB->(Eof()).and.(MLIB->M_CONTA == 0)
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+xPedido))
		Reclock("SC5",.F.)
		SC5->C5_blq := Space(Len(SC5->C5_blq)) //Desbloqueio por Regra
		MsUnlock("SC5")
		INCLUI := .F. ; ALTERA := .T.
		If ExistBlock("M410STTS")
			ExecBlock("M410STTS",.F.,.F.)
		Endif
	Endif
Endif
If (Select("MLIB") <> 0)
	dbSelectArea("MLIB")
	dbCloseArea()
Endif

Return

Static Function BF010AnaProp()
***************************
LOCAL cCodProc 	:= "Nova Proposta para Pedido", nTotal1 := 0, nTotal2 := 0, lBlq := .F.
LOCAL cDescProc	:= "Nova Proposta para Pedido"+M->C5_num, cEmail1 := "", cSubject := ""
LOCAL cHTMLModelo	:= "\workflow\wfanaprop.htm", cFromName := "Workflow -  BRASCOLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se existe item bloqueado        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SZ3->(dbSetOrder(1))
SZ3->(dbSeek(xFilial("SZ3")+M->C5_num,.T.))
While !SZ3->(Eof()).and.(xFilial("SZ3") == SZ3->Z3_filial).and.(SZ3->Z3_pedido == M->C5_num)
   If Empty(SZ3->Z3_datalib)
   	lBlq := .T.
   	Exit
   Endif
   SZ3->(dbSkip())
Enddo
If (!lBlq)
	Help("",1,"BRASCOLA",,OemToAnsi("Sem itens bloqueados!"),1,0) 
	Return (lRetu := .F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Confirma envio da proposta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA3->(dbSetOrder(1)) ; SA3->(dbSetOrder(1)) ; SB1->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli,.T.))
SA3->(dbSeek(xFilial("SA3")+M->C5_vend1,.T.))
If !MsgYesNo("> Enviar Nova Proposta do Pedido "+M->C5_num+" para o representante "+Alltrim(SA3->A3_nome)+" ? ","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Montagem do Workflow de Nova Proposta                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cSubject		:= "WORKFLOW:Nova Proposta para Pedido "+M->C5_num+" | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Pedido"  , M->C5_num )
oProcess:oHtml:ValByName("Cliente" , Alltrim(M->C5_cliente)+"/"+Alltrim(M->C5_lojacli)+"-"+Alltrim(SA1->A1_nome) )
oProcess:oHtml:ValByName("Repres"  , Alltrim(M->C5_vend1)+"-"+Alltrim(SA3->A3_nome) )
aHeader := aClone(oGetAna:aHeader)
For nn := 1 to Len(oGetAna:aCols)
	cStatus := ""
	If (oGetAna:aCols[nn,GDFieldPos("C6_X_BLDSC")] == "L") 
		cStatus := "Liberado"
	Elseif (oGetAna:aCols[nn,GDFieldPos("C6_X_BLDSC")] == "B")
		cStatus := "Bloqueado"
	Elseif (oGetAna:aCols[nn,GDFieldPos("C6_X_BLDSC")] == "R")
		cStatus := "Rejeitado"
	Endif	
	SB1->(dbSeek(xFilial("SB1")+oGetAna:aCols[nn,GDFieldPos("C6_PRODUTO")],.T.))
	SC6->(dbSeek(xFilial("SC6")+M->C5_num+oGetAna:aCols[nn,GDFieldPos("C6_ITEM")],.T.))
   AAdd( oProcess:oHtml:ValByName("Item.status")  , cStatus )
  	AAdd( oProcess:oHtml:ValByName("Item.item")    , oGetAna:aCols[nn,GDFieldPos("C6_ITEM")]    )
   AAdd( oProcess:oHtml:ValByName("Item.produto") , oGetAna:aCols[nn,GDFieldPos("C6_PRODUTO")] )
  	AAdd( oProcess:oHtml:ValByName("Item.descri")  , Alltrim(SB1->B1_desc) )
  	AAdd( oProcess:oHtml:ValByName("Item.qtdven")  , Transform(oGetAna:aCols[nn,GDFieldPos("C6_QTDVEN")]  ,PesqPict("SC6","C6_QTDVEN")) )
  	AAdd( oProcess:oHtml:ValByName("Item.prcven")  , Transform(oGetAna:aCols[nn,GDFieldPos("C6_PRCVEN")]  ,PesqPict("SC6","C6_PRCVEN")) )
  	AAdd( oProcess:oHtml:ValByName("Item.valor")   , Transform(SC6->C6_valor  ,PesqPict("SC6","C6_VALOR"))   )
  	AAdd( oProcess:oHtml:ValByName("Item.descont") , Transform(SC6->C6_descont,PesqPict("SC6","C6_DESCONT")) )
  	AAdd( oProcess:oHtml:ValByName("Item.valprop") , Transform(oGetAna:aCols[nn,GDFieldPos("C6_VALOR")]   ,PesqPict("SC6","C6_VALOR"))   )
  	AAdd( oProcess:oHtml:ValByName("Item.descpro") , Transform(oGetAna:aCols[nn,GDFieldPos("C6_DESCONT")] ,PesqPict("SC6","C6_DESCONT")) )
  	If (SC6->C6_flagluc == "A")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#96D2FA" )
  	Elseif (SC6->C6_flagluc == "B")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#96F5BE" )
  	Elseif (SC6->C6_flagluc == "C")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#F5F5B4" )
  	Elseif (SC6->C6_flagluc == "D")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#FABEBE" )
	Endif
  	If (oGetAna:aCols[nn,GDFieldPos("C6_FLAGLUC")] == "A")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#96D2FA" )
  	Elseif (oGetAna:aCols[nn,GDFieldPos("C6_FLAGLUC")] == "B")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#96F5BE" )
  	Elseif (oGetAna:aCols[nn,GDFieldPos("C6_FLAGLUC")] == "C")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#F5F5B4" )
  	Elseif (oGetAna:aCols[nn,GDFieldPos("C6_FLAGLUC")] == "D")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#FABEBE" )
	Endif
	nTotal1 += SC6->C6_valor
	nTotal2 += oGetAna:aCols[nn,GDFieldPos("C6_VALOR")]
	If SZ3->(dbSeek(xFilial("SZ3")+SC6->C6_num+SC6->C6_item)).and.(oGetAna:aCols[nn,GDFieldPos("C6_DESCONT")] != SC6->C6_descont)
		Reclock("SZ3",.F.)
		SZ3->Z3_datapro := MsDate()
		SZ3->Z3_horapro := Time()
		SZ3->Z3_userpro := cUserName
		SZ3->Z3_descpro := oGetAna:aCols[nn,GDFieldPos("C6_DESCONT")]
		MsUnlock("SZ3")
	Endif	
Next nn       
AAdd( oProcess:oHtml:ValByName("Item.status")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.item")    , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.produto") , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.descri")  , "<b>TOTAL:</b>" )
AAdd( oProcess:oHtml:ValByName("Item.qtdven")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.prcven")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.valor")   , "<b>"+Transform(nTotal1,PesqPict("SC6","C6_VALOR"))+"</b>" )
AAdd( oProcess:oHtml:ValByName("Item.descont") , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.valprop") , "<b>"+Transform(nTotal2,PesqPict("SC6","C6_VALOR"))+"</b>" )
AAdd( oProcess:oHtml:ValByName("Item.descpro") , "&nbsp;" )
If (n010PerOri > 40)
 	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#96D2FA" )
Elseif ((n010PerOri >= 20).and.(n010PerOri < 40))
  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#96F5BE" )
Elseif ((n010PerOri >= 0).and.(n010PerOri < 20))
  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#F5F5B4" )
Elseif (n010PerOri < 0)
  	AAdd( oProcess:oHtml:ValByName("Item.corlin1")   , "#FABEBE" )
Endif
If (n010PerLuc > 40)
 	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#96D2FA" )
Elseif ((n010PerLuc >= 20).and.(n010PerLuc < 40))
  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#96F5BE" )
Elseif ((n010PerLuc >= 0).and.(n010PerLuc < 20))
  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#F5F5B4" )
Elseif (n010PerLuc < 0)
  	AAdd( oProcess:oHtml:ValByName("Item.corlin2")   , "#FABEBE" )
Endif
cEmail1 := ""
PswOrder(2)
If PswSeek(cUsername,.T.)
	cEmail1 := PswRet(1)[1,14]
Endif
cEmail1 := u_BXFormatEmail(cEmail1)
oProcess:cTo := cEmail1 //Email dos Gestores
If !Empty(SA3->A3_email)
	oProcess:cTo += iif(!Empty(oProcess:cTo),";","")+Alltrim(SA3->A3_email)
Endif
//oProcess:cTo := "charlesm@brascola.com.br;marcelo@goldenview.com.br"
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Finish()

Return

Static Function BF010AvResRep()
****************************
LOCAL cCodProc 	:= "Pedido Eliminado por Residuo", cEmail1 := ""
LOCAL cDescProc	:= "Item "+SC6->C6_item+" do Pedido "+SC6->C6_num+" foi Eliminado por Residuo"
LOCAL cHTMLModelo	:= "\workflow\wfavresrep.htm", cFromName	:= "Workflow -  BRASCOLA"
LOCAL cSubject		:= "WORKFLOW:Item "+SC6->C6_item+" do Pedido "+SC6->C6_num+" foi Eliminado por Residuo | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Data",	dDataBase)
oProcess:oHtml:ValByName("Hora",	Alltrim(Time()))
oProcess:oHtml:ValByName("Motivo","Motivo: "+Alltrim(SZ3->Z3_obslib))
cEmail1 := ""
SA3->(dbSetOrder(1))
If SA3->(dbSeek(xFilial("SA3")+SC5->C5_vend1))
	cEmail1 := Alltrim(SA3->A3_email)
	oProcess:oHtml:ValByName("Vend",Alltrim(SA3->A3_cod)+"-"+Alltrim(SA3->A3_nome))
Else
	oProcess:oHtml:ValByName("Vend","&nbsp;")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AAdd( oProcess:oHtml:ValByName("Item.ped") , SC6->C6_num+"/"+SC6->C6_item )
AAdd( oProcess:oHtml:ValByName("Item.cli") , Substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,"A1_NOME"),1,20) )
AAdd( oProcess:oHtml:ValByName("Item.pro") , Alltrim(SC6->C6_produto)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1")+SC6->C6_produto,"B1_DESC")) )
AAdd( oProcess:oHtml:ValByName("Item.qtd") , Transform(SC6->C6_qtdven-SC6->C6_qtdent,PesqPict("SC6","C6_QTDVEN")) )
AAdd( oProcess:oHtml:ValByName("Item.val") , Transform((SC6->C6_qtdven-SC6->C6_qtdent)*SC6->C6_prcven,PesqPict("SC6","C6_VALOR")) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:ClientName(cUserName)
cEmail1 := u_BXFormatEmail(cEmail1)
If !Empty(cEmail1)
	oProcess:cTo := cEmail1
Else
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
//oProcess:cTo := "charlesm@brascola.com.br;marcelo@goldenview.com.br"
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return

Static Function B010CorBrw(xHeader,xCols,xAt)
****************************************
LOCAL nRetu := RGB(250,250,250)
LOCAL	nPLuc := GDFieldPos("Z3_FLAGLUC",xHeader)
If (nPLuc == 0)
	nPLuc := GDFieldPos("C6_FLAGLUC",xHeader)
Endif
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
Return nRetu