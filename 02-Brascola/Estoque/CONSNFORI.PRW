#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TbiConn.ch"
/*
1,//³cAlias – Alias do arquivo                                                                ³
2,//³cCampo – Campo que estabelece relação com a culuna de marca                              ³
3,//³cCpo – Campo que se estiver vazio muda a cor da linha                                    ³
4,//³aCampos – Array com os campos para montar o brow                                         ³
5,//³lMarc – Flag para inicializar marcado ou não                                             ³
6,//³cMarca – Marca obtida com a função Getmark                                               ³
7,//³cCtrlM – Função para ser executada no Alt_M                                              ³
8,//³lBotoes – Parâmetro obsoleto                                                             ³
9,//³cTopFun – Função filtro para estabelecer o primeiro registro                             ³
10,//³cTopFun – Função filtro para estabelecer o último registro                              ³
11,//³aCoord – Array com as coordenadas da MarkBrowse.                                        ³
*/

User Function TransfTela()
**************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cQuery
Local cQuery2
Local cQuery3
Local cQueryCria
Local cKeyTRB := ""
Local cPerg := U_CRIAPERG("TRNTR2")

Public lConsFirst:= .t.

Private aHeadSC6   := {}
Private _aCampos   := {}
Private _aTela     := {}
Private aCores     := {}
Private aRotina := {}					 
Private cCadastro := "Notas Fiscais Transferidas"
Private cNumNFAux := Space(09)

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

aAdd( aRotina ,{"Pesquisar" ,"U_D116Pesqui()"   ,0,1})
aAdd( aRotina ,{"Gera Relatorio", "U_Marca",0,3})
aAdd( aRotina ,{"Sel. Cod. Barra", "U_CBMarca",0,3})
aAdd( aRotina ,{"Legenda"   ,"U_ZBRLeg"  ,0,4})

/*
If Mv_Par01 == 1
	cFiltro := "<>''"
ElseIf Mv_Par01 == 2
	cFiltro := "=''"
EndIf
*/


If Mv_Par01 == 1 .and. Empty(Mv_Par03) 
	 Mv_Par03:= Database
EndIf


cQuery := "SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO,  F2_DTSAIDA "
cQuery += "FROM SF2020 WHERE  D_E_L_E_T_  <> '*'
cQuery += " AND F2_FILIAL = '"+XFILIAL("SF2")+"'"
cQuery += " AND F2_EMISSAO > '" + DtoS(dDataBase - 90) + "'"

If MV_Par01 == 1
	cQuery += " AND F2_DTSAIDA = '" + DtoS(MV_PAR03) + "'"
ElseIf MV_Par01 == 2 
	cQuery += " AND F2_DTSAIDA = '' "
EndIf                                 

If MV_Par04 == 1
	cQuery += " AND F2_FLAGROM = '1'"
ElseIf MV_Par04 == 2 
	cQuery += " AND F2_FLAGROM = '' "
EndIf                                 
       

If !Empty(MV_Par02)
	cQuery += " AND F2_TRANSP = '" + MV_Par02 + "' "
EndIf
cQuery += " ORDER BY F2_FILIAL, F2_DOC"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho			            			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
          
aEstru:={}

aAdd(aEstru, {"FILIAL" , "C", 02, 00})
aAdd(aEstru, {"CLIENTE", "C", 06, 00})
aAdd(aEstru, {"LOJA"   , "C", 02, 00})
aAdd(aEstru, {"NOTA"   , "C", 09, 00})
aAdd(aEstru, {"SERIE"  , "C", 03, 00})
aAdd(aEstru, {"TRANSP" , "C", 06, 00})
aAdd(aEstru, {"EMISSAO", "D", 08, 00})
aAdd(aEstru, {"SAIDA"  , "D", 08, 00})
aAdd(aEstru, {"OK2"    , "C", 01, 00})
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



User Function ZBRLeg()
**********************
Local aLegenda := {  {"BR_VERDE" ,"Item em Aberto ou Parcial"},; //"Faturamento com Meio Magnetico"
                     {"BR_VERMELHO","Item Faturado"}}
                     
BrwLegenda("Status do Item",,aLegenda)		 //'Distribuição das lojas'/Legenda

Return(.T.)



// Cleiton
//-------------------
User Function Marca()
*********************
Local cAlias := Alias(), nRecno := ARQT->(Recno())

ARQT->(DbGoTop())
Do While ARQT->(!Eof())
	DbSelectArea("SF2")
	DbSetOrder(2)
	DbSeek(ARQT->(Filial + Cliente + Loja + Nota + Serie))
	
	Do While !RecLock("SF2", .f.)
	EndDo
                        
    Replace SF2->F2_OK2 With ARQT->OK2
    MsUnLock()
    
    ARQT->(DbSkip())
EndDo  
         
DbSelectArea("ARQT")
DbGoTo(nRecno)

DbSelectArea(cAlias)
U_Conta1()

Return .t.          



User Function Conta1()
**********************
//U_TransTra(cMarca)

U_TransTra()

Return(.T.)	      


// Thiago
User Function CBMarca()
*********************
Local cAlias := Alias(), nRecno := ARQT->(Recno())
Local lEnd:= .t.
Private _oDlg

lConsFirst:= .t.

While lEnd 
	cNumNFAux:= Space(09)
	
	//monta tela para leitura do codigo de barra
	Define MSDialog _oDlg From 5, 5 To 15, 40 Title "Codigo de Barras"
	@ 02,002 Say "Serie/N.Fiscal: "  Size 30,44                                    Of _oDlg FONT _oDlg:oFont
	@ 02,008 MSGet cNumNFAux         Size 40,10  Valid GetCBarra(M->cNumNFAux)     Of _oDlg FONT _oDlg:oFont
//	Define SButton "teste" From 050,010  Action (lEnd:=.f.,_oDlg:End())  Enable Of _oDlg	    
//	@ 050,010 BUTTON "_Sair"     SIZE 040,015   ACTION  Fecha()
	@ 005,008 BUTTON "ETIQUETA"         Size 40,10  Action (etbnf())     Of _oDlg FONT _oDlg:oFont
	@ 005,020 BUTTON "SAIR"  	        Size 40,10  Action (lEnd:=.f.,_oDlg:End())     Of _oDlg FONT _oDlg:oFont
	//Define SButton From 050,100      Type 1 Action (lEnd:=.f.,_oDlg:End())  Enable Of _oDlg
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


/////LOCALIZA A NOTA PARA ATUALIZAR A DATA EMBARQUE////
///////////////////////////////////////////////////////
     
 	 	DBSELECTAREA("SF2") 
   		dbSetOrder(1)   
   		
	   	If	dbSeek(XFILIAL("SF2")+SUBSTR(cNumNFAux,4,7)+'   '+SUBSTR(cNumNFAux,1,3))
	  	    
	  	    RecLock("SF2",.F.)
	    	SF2->F2_DTSAIDA := DDatabase
	       //	SF2->F2_FLAGROM := '*'
	   	    SF2->( MSUNLOCK() )         
	  	    
	  	    
	   		DBSELECTAREA("SA1") 
   	  		dbSetOrder(1) 
  	   		dbSeek('  '+ALLTRIM(SF2->F2_CLIENTE)+ALLTRIM(SF2->F2_LOJA)) 
	  	       If SA1->A1_GERAETQ == '1'
	  	         		  	        	    
	            	U_etbnf(cNumNFAux) 
			   	    
			   Endif
              
        Endif
	    
	    
	Else
	    MsgAlert("Nota Fiscal não encontrada!!")
		//lRet:= .f.
	EndIf
	
	_oDlg:End()
EndIf
	
Return lRet



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³D116Pesquiº Autor ³ AP6 IDE               º Data ³  02/08/06º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisas pelos index's abertos                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ DURES116                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function D116Pesqui()
**************************
Local cAlias,cCampo,cIndex,cKey,cOrd
Local nReg,nI,nOpca:=0
Local oDlg,oCbx,lRet := .T.
Local aOrd := { }

DBSELECTAREA("ARQT")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Salva a Integridade dos Dados                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias  := ALIAS()

AADD(aOrd," "+"NOTA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa Choices dos Campos do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
Return .t.//(MsgYesNo(OemToAnsi("Confirma Sele‡„o?"),OemToAnsi("Aten‡„o")))			//"Confirma Sele‡„o?"###"Aten‡„o"   