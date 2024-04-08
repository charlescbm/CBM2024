#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TopConn.ch"

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

/*
aAdd( aRotina ,{"Pesquisar"      ,"U_D116Pesqui()",0,1,0,.F.})   
aAdd( aRotina ,{"Gera Relatorio" ,"U_Marca"       ,0,2,0,NIL})
aAdd( aRotina ,{"Sel. Cod. Barra","U_CBMarca"     ,0,3,0,NIL})
aAdd( aRotina ,{"Legenda"        ,"U_ZBRLeg"      ,0,4,0,NIL})  */   

     

aRotina := { { OemToAnsi("Pesquisar")       ,"U_D116Pesqui()" , 0 , 1,0,.F.},;
           {   OemToAnsi("Gera Relatorio")  ,"U_Marca"        , 0 , 2,0,NIL},;
           {   OemToAnsi("Sel. Cod. Barra") ,"U_CBMarca"      , 0 , 3,0,NIL},;
           {   OemToAnsi("Legenda")         ,"U_ZBRLeg"       , 0 , 4,0,NIL}}



If Mv_Par01 == 1 .and. Empty(Mv_Par03) 
	 Mv_Par03:= dDatabase
EndIf

cQuery := "SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO,  F2_DTSAIDA "
cQuery += "FROM " + RetSqlName("SF2") + " WHERE  D_E_L_E_T_  <> '*'
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

aAdd(aEstru, {"FILIAL" , "C", TAMSX3("F2_FILIAL")[1], 00})
aAdd(aEstru, {"CLIENTE", "C", TAMSX3("F2_CLIENTE")[1], 00})
aAdd(aEstru, {"LOJA"   , "C", TAMSX3("F2_LOJA")[1], 00})
aAdd(aEstru, {"NOTA"   , "C", TAMSX3("F2_DOC")[1], 00})
aAdd(aEstru, {"SERIE"  , "C", TAMSX3("F2_SERIE")[1], 00})
aAdd(aEstru, {"TRANSP" , "C", TAMSX3("F2_TRANSP")[1], 00})
aAdd(aEstru, {"EMISSAO", "D", TAMSX3("F2_EMISSAO")[1], 00})
aAdd(aEstru, {"SAIDA"  , "D", TAMSX3("F2_DTSAIDA")[1], 00})
aAdd(aEstru, {"OK2"    , "C", TAMSX3("F2_OK2")[1], 00})
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


dbSelectArea("TRB")
dbGoTop()
While !Eof()
	
	Reclock("ARQT",.T.)
	ARQT->Filial  := TRB->F2_Filial
	ARQT->Cliente := TRB->F2_Cliente
	ARQT->Loja    := TRB->F2_Loja	
	ARQT->Nota    := TRB->F2_Doc    
	ARQT->Serie   := TRB->F2_Serie 
	ARQT->Transp  := TRB->F2_Transp
	ARQT->Emissao := TRB->(StoD(F2_Emissao))
	ARQT->SAIDA   := TRB->(StoD(F2_DTSAIDA))	
	ARQT->(MsUnLock())

	dbSelectArea("TRB")
	TRB->(DbSkip())	
EndDo

cMarca   := GetMark(,"ARQT","OK2")   

_aTela   := {{"OK2","","OK2"} ,{"FILIAL","","FILIAL"},{"NOTA","","NOTA"},{"EMISSAO","","EMISSAO"},{"TRANSP","","TRANSP"},{"CLIENTE","","CLIENTE"},{"SAIDA","","SAIDA"}}

dbSelectArea("ARQT")
dbGoTop()
         

IF MV_PAR01 == 2 .OR. MV_PAR01 == 3   
  //MarkBrow(cAlias,cCampo,  cCpo , aCampo, lInvert , cMarca , cCtrlM , uPar8 , cExpIni , cExpFim , cAval , bParBloco , cExprFilTop , uPar14 , aColors , uPar16 , uPar17 , uPar18 , lShowAmb) 
    MarkBrow("ARQT","OK2" ,"SAIDA",_aTela ,.F., cMarca,,,,)
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

dbSelectArea("ARQT")
dbGoTop()
While !Eof()
	
	If !Empty(ARQT->OK2)
		dbSelectArea("SF2")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek(ARQT->(Filial + Cliente + Loja + Nota + Serie))
			RecLock("SF2",.F.)                    
		    SF2->F2_OK2 := ARQT->OK2
		    SF2->(MsUnLock()) 
		EndIf
	EndIf
	
	dbSelectArea("ARQT")
    ARQT->(DbSkip())
EndDo
         
U_TransTra()

Return

// Thiago
User Function CBMarca()
*********************
Local cAlias := Alias(), nRecno := ARQT->(Recno())
Local lEnd:= .t.
Private _oDlg

lConsFirst:= .t.

While lEnd     

//10/01/13: Fernando	
//If len(cNumNFAux) == 9
	//cNumNFAux:= Space(09)  
//Else
	cNumNFAux:= Space(12)
//EndIf

	
	//monta tela para leitura do codigo de barra
	Define MSDialog _oDlg From 5, 5 To 15, 40 Title "Codigo de Barras"
	@ 02,002 Say "Serie/N.Fiscal: "  Size 30,44 Of _oDlg FONT _oDlg:oFont  
	
	//10/01/13: Fernando	
	//If len(cNumNFAux) == 9
	   //	@ 02,008 MSGet cNumNFAux Size 40,10  Valid GetCBarra(M->cNumNFAux) Of _oDlg FONT _oDlg:oFont 
   //	Else
		@ 02,008 MSGet cNumNFAux Size 40,13  Valid GetCBarra(M->cNumNFAux) Of _oDlg FONT _oDlg:oFont
   //	EndIf
	
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


/////LOCALIZA A NOTA PARA ATUALIZAR A DATA EMBARQUE - CABECALHO NOTA FISCAL////
///////////////////////////////////////////////////////
     
 	 	DBSELECTAREA("SF2") 
   		dbSetOrder(1)   
   		
   		//10/01/13: Fernando 
   		cNumNFAux:=  Alltrim(cNumNFaux)			
		If len(cNumNFAux) == 9 
   			lAchou:= dbSeek(XFILIAL("SF2")+SUBSTR(cNumNFAux,4,7)+'   '+SUBSTR(cNumNFAux,1,3))
        Else
        	lAchou:= dbSeek(XFILIAL("SF2")+SUBSTR(cNumNFAux,4,9)+SUBSTR(cNumNFAux,1,3))
        EndIf
        
	  	//If	dbSeek(XFILIAL("SF2")+SUBSTR(cNumNFAux,4,9)+SUBSTR(cNumNFAux,1,3))
	  	 If lAchou   
	  	    RecLock("SF2",.F.)
	    	SF2->F2_DTSAIDA := DDatabase
	       	//SF2->F2_FLAGROM := '*'
	   	    SF2->( MSUNLOCK() )   
	   	    
			_cQuery := "UPDATE " + RetSqlName("SE1")"
			_cQuery += " SET    E1_DTSAIDA = '"+ dtos(DDatabase) + "'" 
			_cQuery += " FROM " + RetSqlName("SE1")
			_cQuery += " WHERE  D_E_L_E_T_ = ''"
			_cQuery += "   AND E1_NUM = '" + SF2->F2_DOC + "'"
			_cQuery += "   AND E1_PREFIXO = '" + SF2->F2_SERIE + "'"
			_cQuery += "   AND E1_FILIAL = '" + SF2->F2_FILIAL + "'"
			
			_Ret 	:= TcSqlExec( _cQuery )     
	   	          
	  	      	    
	   		DBSELECTAREA("SA1") 
   	  		dbSetOrder(1) 
  	   		dbSeek('  '+ALLTRIM(SF2->F2_CLIENTE)+ALLTRIM(SF2->F2_LOJA)) 
	  	       If SA1->A1_GERAETQ == '1'
	  	         		  	        	    
	            	U_etbnf(cNumNFAux) 
			   	    
			   Endif
              
        Endif

/////LOCALIZA A NOTA PARA ATUALIZAR A DATA EMBARQUE - CABECALHO NOTA FISCAL////
///////////////////////////////////////////////////////
      /*
 	 	DBSELECTAREA("SD2") 
   		dbSetOrder(12)   
   		
	   	If	dbSeek(XFILIAL("SD2")+SUBSTR(cNumNFAux,4,7)+'   '+SUBSTR(cNumNFAux,1,3))
	  	    
	  	    RecLock("SD2",.F.)
	    	SD2->D2_DTSAIDA := DDatabase
	   	    SD2->( MSUNLOCK() )         
	  	    
        Endif	    
	   */ 
	Else
	    MsgAlert(" Item da Nota Fiscal não encontrada!!")
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