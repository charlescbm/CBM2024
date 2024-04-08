#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TbiConn.ch"
/*
1,//�cAlias � Alias do arquivo                                                                �
2,//�cCampo � Campo que estabelece rela��o com a culuna de marca                              �
3,//�cCpo � Campo que se estiver vazio muda a cor da linha                                    �
4,//�aCampos � Array com os campos para montar o brow                                         �
5,//�lMarc � Flag para inicializar marcado ou n�o                                             �
6,//�cMarca � Marca obtida com a fun��o Getmark                                               �
7,//�cCtrlM � Fun��o para ser executada no Alt_M                                              �
8,//�lBotoes � Par�metro obsoleto                                                             �
9,//�cTopFun � Fun��o filtro para estabelecer o primeiro registro                             �
10,//�cTopFun � Fun��o filtro para estabelecer o �ltimo registro                              �
11,//�aCoord � Array com as coordenadas da MarkBrowse.                                        �
*/

User Function ConsNF()
**************************
//������������������������������������������������������Ŀ
//� Define Variaveis                                     �
//��������������������������������������������������������
Local cQuery
Local cQuery2
Local cQuery3
Local cQueryCria
Local cKeyTRB := ""
Local cPerg := U_CRIAPERG("TRNTR2_FRA")

Public lConsFirst:= .t.

Private aHeadSC6   := {}
Private _aCampos   := {}
Private _aTela     := {}
Private aCores     := {}
Private aRotina := {}					 
Private cCadastro := "Notas Fiscais Transferidas"

// Cleiton - 02/05/2008
Private cBlEst := "", cBloqueio := ""
// Cleiton

nOpcAuto := 3

IF PERGUNTE(cPerg)
	OKZANA()
ENDIF

Return



Static function OKZANA()
************************
Processa({ || CONZAN()}, "Aguarde",,.t.)

Return(nil)



Static Function CONZAN()
************************
Local cEst := "", cFin := ""
PRIVATE _aTela   := {}

aAdd( aRotina ,{"Pesquisar" ,"U_D116_FRA()"   ,0,1})
aAdd( aRotina ,{"Gera Relatorio", "U_Marca_FRA",0,3})
//aAdd( aRotina ,{"Sel. Cod. Barra", "U_CBMarca",0,3})
aAdd( aRotina ,{"Legenda"   ,"U_ZBRLeg_FRA"  ,0,4})

If Mv_Par01 == 1
	cFiltro := "<>''"
ElseIf Mv_Par01 == 2
	cFiltro := "=''"
EndIf

cQuery := "SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO,  F2_DTSAIDA "
cQuery += "FROM SF2010 WHERE  D_E_L_E_T_  <> '*'
cQuery += " AND F2_FILIAL = '"+XFILIAL("SF2")+"'"
cQuery += " AND F2_EMISSAO > '" + DtoS(dDataBase - 90) + "'"

If MV_Par01 == 1 .Or. MV_Par01 == 2
	cQuery += " AND F2_DTSAIDA "+CFILTRO
EndIf

If !Empty(MV_Par02)
	cQuery += " AND F2_TRANSP = '" + MV_Par02 + "' "
EndIf
cQuery += " ORDER BY F2_FILIAL, F2_DOC"


//��������������������������������������������������������������Ŀ
//� Cria Arquivo de Trabalho			            			 �
//����������������������������������������������������������������
          
aEstru:={} 

aAdd(aEstru, {"FILIAL" , "C", TAMSX3("F2_FILIAL")[1]  , 00})
aAdd(aEstru, {"CLIENTE", "C", TAMSX3("F2_CLIENTE")[1] , 00})
aAdd(aEstru, {"LOJA"   , "C", TAMSX3("F2_LOJA")[1]    , 00})
aAdd(aEstru, {"NOTA"   , "C", TAMSX3("F2_DOC")[1]     , 00})
aAdd(aEstru, {"SERIE"  , "C", TAMSX3("F2_SERIE")[1]   , 00})
aAdd(aEstru, {"TRANSP" , "C", TAMSX3("F2_TRANSP")[1]  , 00})
aAdd(aEstru, {"EMISSAO", "D", TAMSX3("F2_EMISSAO")[1] , 00})
aAdd(aEstru, {"SAIDA"  , "D", TAMSX3("F2_DTSAIDA")[1] , 00})
aAdd(aEstru, {"OK2"    , "C", TAMSX3("F2_OK2")[1]     , 00})  

_cArqTmp := CriaTrab(aEstru, .T.)


If Select("ARQT") > 0
	ARQT->(DbCloseArea())
EndIf

dbUseArea( .T.,,_cArqTmp, "ARQT", .F., .F. )
IndRegua("ARQT", Criatrab(,.f.), "FILIAL + NOTA",,, "Consultando...")


If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)


DBSELECTAREA("TRB")
TRB->(DBGOTOP())
Do While TRB->( !Eof())
	DbSelectArea("ARQT")
	Append Blank
	
	Replace ARQT->Filial   With TRB->F2_Filial
	Replace ARQT->Cliente  With TRB->F2_Cliente
	Replace ARQT->Loja     With TRB->F2_Loja	
	Replace ARQT->Nota     With TRB->F2_Doc    
	Replace ARQT->Serie    With TRB->F2_Serie 
	Replace ARQT->Transp   With TRB->F2_Transp
	Replace ARQT->Emissao  With TRB->(StoD(F2_Emissao))
	Replace ARQT->SAIDA    With TRB->(StoD(F2_DTSAIDA))
	ARQT->(MSUNLOCK())
	TRB->(DbSkip())
EndDo

cMarca   := GetMark(,"ARQT","OK2")
_aTela   := {{"OK2","","OK2"},{"FILIAL","","FILIAL"},{"NOTA","","NOTA"},{"EMISSAO","","EMISSAO"},{"TRANSP","","TRANSP"},{"CLIENTE","","CLIENTE"},{"SAIDA","","SAIDA"}}

DBSELECTAREA("ARQT")
ARQT->(DBGOTOP())

//MarkBrowse("ARQT","FILIAL",,_aTela)

IF MV_PAR01 = 2 .OR. MV_PAR01=3
    MarkBrow("ARQT","OK2","SAIDA",_aTela,.F.,cMarca,,,,)
ELSE
    MarkBrow("ARQT","OK2",,_aTela,.F.,cMarca,,,,)
ENDIF
 
ARQT->(DbCloseArea())

Return



User Function ZBRLeg_FRA()
**********************
Local aLegenda := {  {"BR_VERDE" ,"Item em Aberto ou Parcial"},; //"Faturamento com Meio Magnetico"
                     {"BR_VERMELHO","Item Faturado"}}
                     
BrwLegenda("Status do Item",,aLegenda)		 //'Distribui��o das lojas'/Legenda

Return(.T.)



// Cleiton
//-------------------
User Function Marca_FRA()
*********************
Local cAlias := Alias(), nRecno := ARQT->(Recno())

ARQT->(DbGoTop())
Do While ARQT->(!Eof())
	DbSelectArea("SF2")
	DbSetOrder(2)
	if DbSeek(ARQT->(Filial + Cliente + Loja + Nota + Serie))
		
		//Do While !RecLock("SF2", .f.)
		//EndDo
		
		RecLock("SF2", .f.)
		
		Replace SF2->F2_OK2 With ARQT->OK2
		MsUnLock()
		
		ARQT->(DbSkip())
	Endif
EndDo  

         
DbSelectArea("ARQT")
DbGoTo(nRecno)

DbSelectArea(cAlias)
U_Conta1_FRA()

Return .t.          



User Function Conta1_FRA()
**********************
U_TransFra(cMarca)

Return(.T.)	      


// Thiago
User Function CBMarca_FRA()
*********************
Local cAlias := Alias(), nRecno := ARQT->(Recno())
Local cNumNFAux:= Space(12)
Local lEnd:= .t.
Private _oDlg

lConsFirst:= .t.

While lEnd 
	cNumNFAux:= Space(12)
	
	//monta tela para leitura do codigo de barra
	Define MSDialog _oDlg From 5, 5 To 14, 50 Title "Codigo de Barras"
	@ 02,002 Say "Serie/N.Fiscal: "  Size 30,44                                    Of _oDlg FONT _oDlg:oFont
	@ 02,008 MSGet cNumNFAux         Size 40,10  Valid GetCBarra(M->cNumNFAux)     Of _oDlg FONT _oDlg:oFont
	Define SButton From 050,149      Type 1 Action (lEnd:=.f.,_oDlg:End())  Enable Of _oDlg
	Activate MSDialog _oDlg Centered
EndDo	

DbSelectArea("ARQT")
DbGoTo(nRecno)

DbSelectArea(cAlias)

Return .t.

          
//Thiago
Static Function GetCBarra(cNumNFAux)
************************************
//procura a nota no TRAB1 e faz a marca
Local lRet:= .t.

dbSelectArea("ARQT")

If !Empty(cNumNFAux)
	If lConsFirst
		cIndex01:=CriaTrab(nil,.f.)
		cKey01  := "SERIE+NOTA"
		
		IndRegua("ARQT",cIndex01,cKey01,,,OemToAnsi("Selecionando Registros..."))
		dbSetOrder(1)
		dbGotop()
		lConsFirst:= .f.
	EndIf
		
	If dbSeek(cNumNFAux)
	    RecLock("ARQT",.f.)
	    ARQT->OK2:= cMarca
	    MsUnlock()
	    
	    SysRefresh()
	Else
	    MsgAlert("Nota Fiscal n�o encontrada!!")
		//lRet:= .f.
	EndIf
	
	_oDlg:End()
EndIf
	
Return lRet



/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �D116Pesqui� Autor � AP6 IDE               � Data �  02/08/06���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Pesquisas pelos index's abertos                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � DURES116                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function D116_FRA()
**************************
Local cAlias,cCampo,cIndex,cKey,cOrd
Local nReg,nI,nOpca:=0
Local oDlg,oCbx,lRet := .T.
Local aOrd := { }

DBSELECTAREA("ARQT")
//����������������������������������������������������������������������Ŀ
//�Salva a Integridade dos Dados                                         �
//������������������������������������������������������������������������
cAlias  := ALIAS()

AADD(aOrd," "+"NOTA")

//��������������������������������������������������������Ŀ
//� Processa Choices dos Campos do Banco de Dados          �
//����������������������������������������������������������
cOrd := aOrd[1]
cCampo:=SPACE(40)
For ni:=1 to Len(aOrd)
	aOrd[nI] := OemToAnsi(aOrd[nI])
Next
If IndexOrd() >= Len(aOrd)
	cOrd := aOrd[Len(aOrd)]
ElseIf IndexOrd() <= 1
	cOrd := aOrd[1]
Else
	cOrd := aOrd[IndexOrd()]
Endif

DEFINE MSDIALOG oDlg FROM 5, 5 TO 14, 50 TITLE OemToAnsi("Pesquisa") 
@ 0.6,1.3 COMBOBOX oCBX VAR cOrd ITEMS aOrd  SIZE 165,44 OF oDlg FONT oDlg:oFont
@ 2.1,1.3 MSGET cCampo SIZE 165,10
DEFINE SBUTTON FROM 055,122   TYPE 1 ACTION (nOpca := 1,D116OK(),oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 055,149.1 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

If nOpca == 0
	lRet := .F.
Endif

nReg := RecNo()

If lRet
	cIndex1:=CriaTrab(nil,.f.)
	DBSELECTAREA("ARQT")
	cKey   := "NOTA"
	IndRegua("ARQT",cIndex1,cKey,,,OemToAnsi("Selecionando Registros..."))
	#IFNDEF TOP
		dbSetIndex(cIndex1+OrdBagExt())
	#ENDIF 
	
	dbSetOrder(1)
	dbGotop()
	lRet := IIf(dbSeek(Trim(cCampo),.T.),.T.,.F.)
	If  !lRet
		Go nReg
		Help(" ",1,"PESQ01")
	EndIf
Endif

Return lRet     


Static Function D116OK() //ok da pesquisa
************************
Return .t.//(MsgYesNo(OemToAnsi("Confirma Sele��o?"),OemToAnsi("Aten��o")))			//"Confirma Sele��o?"###"Aten��o"   