#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TbiConn.ch"   
#INCLUDE "TOPCONN.CH"


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBFISR002()  บAutor  ณ Rodolfo Gaboardi  บ Data ณ  01/09/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Relatorio da Guia                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Livros Fiscais Brascola                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


User Function BFISR002() // NOME ROTINA ANTIGA Transfguia()
//**************************
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cQuery
Local cQuery2
Local cQuery3
Local cQueryCria
Local cKeyTRB := ""
Local cPerg := "TRANGUIA"//U_CRIAPERG("TRANGUIA")

Public lConsFirst:= .t.

Private aHeadSC6   := {}
Private _aCampos   := {}
Private _aTela     := {}
Private aCores     := {}
Private aRotina := {}					 
Private cCadastro := "Guia de notas fiscais que foram Pagas"

// Cleiton - 02/05/2008
Private cBlEst := "", cBloqueio := ""
// Cleiton

nOpcAuto := 3

IF PERGUNTE(cPerg)
	guia()
ENDIF

Return


Static function guia()
************************
Processa({ || CONGUIA()}, "Aguarde",,.t.)

Return(nil)


Static Function CONGUIA()
************************
Local cEst := "", cFin := ""
PRIVATE _aTela   := {}
Private acores   :={}

aAdd( aRotina ,{"Pesquisar" ,"U_DgPesqui()"   ,0,1})
//aAdd( aRotina ,{"Gera Relatorio", "U_gMarca",0,3})
aAdd( aRotina ,{"Grava Guia", "U_gMARCA",0,3})
aAdd( aRotina ,{"Legenda"   ,"U_gLeg"  ,0,4})

cQuery :=" SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO, A1_CGC,A1_MUN, F2_DTSAIDA,F2_X_DTGNR,F2_ICMSRET,F2_EST,F2_VALBRUT,0 DIFAL,F2_BRICMS "
cQuery +=" FROM SF2010,SA1010 WHERE  SF2010.D_E_L_E_T_  <> '*'                                                                                                     "
cQuery +=" AND F2_FILIAL = '"+XFILIAL("SF2")+"'"                                                                                                     "
cQuery +=" AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "                                                                    
//cQuery +=" AND F2_DUPL <> '' "
cQuery +=" AND F2_ICMSRET > 0 "
cQuery +=" AND A1_COD = F2_CLIENTE "
cQuery +=" AND A1_LOJA = F2_LOJA "
cQuery +=" AND SA1010.D_E_L_E_T_ = '' "
If !Empty(MV_Par03)
	cQuery += " AND F2_EST = '" + MV_Par03 + "' "
else
    cQuery += " AND F2_EST <> 'SC' "
ENDIF

If mv_par04 == 1
	cQuery += " AND F2_X_DTGNR = '' "
elseif mv_par04 == 2
	cQuery += " AND F2_X_DTGNR <> '' "
ENDIF

If Empty(MV_Par03) .OR. MV_Par03 == 'RS'

	cQuery +=" UNION  ALL "
	cQuery +=" SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO,A1_CGC,A1_MUN,  F2_DTSAIDA,F2_X_DTGNR, SUM( F2_ICMSRET) F2_ICMSRET,F2_EST,SUM(F2_VALBRUT)F2_VALBRUT,((SUM(D2_TOTAL)* 5)/100)DIFAL,SUM(F2_BRICMS) F2_BRICMS "
	cQuery +=" FROM SF2010,SD2010,SB1010,SA1010 WHERE  SF2010.D_E_L_E_T_  <> '*' AND SD2010.D_E_L_E_T_  <> '*' AND SB1010.D_E_L_E_T_  <> '*' AND SA1010.D_E_L_E_T_  <> '*' "
	cQuery +=" AND F2_FILIAL = '"+XFILIAL("SF2")+"'"
	cQuery +=" AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
   //	cQuery +=" AND F2_DUPL <> '' "
	cQuery +=" AND F2_DOC = D2_DOC
	cQuery +=" AND F2_SERIE = D2_SERIE
	cQuery +=" AND F2_FILIAL = D2_FILIAL
	cQuery +=" AND A1_COD = F2_CLIENTE "
	cQuery +=" AND A1_LOJA = F2_LOJA "
    cQuery +=" AND F2_EST = 'RS'
	cQuery +=" AND D2_COD = B1_COD
	cQuery +=" AND B1_DIFALRS = '1'
	cQuery +=" AND D2_ICMSRET = 0 
	If mv_par04 == 1
	cQuery += " AND F2_X_DTGNR = '' "
    elseif mv_par04 == 2
	cQuery += " AND F2_X_DTGNR <> '' "
    ENDIF
	cQuery +=" GROUP BY F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO,  F2_DTSAIDA,F2_X_DTGNR,F2_EST,A1_CGC,A1_MUN
ENDIF	
	cQuery += " ORDER BY F2_FILIAL, F2_DOC,F2_EMISSAO,F2_EST "



If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TRB"

TCSetField('TRB', "VALBRUT"  , "N",14,2) 

TCSetField('TRB', "F2_ICMSRET"  , "N",14,2) 

TCSetField('TRB', "DIFAL"  , "N",14,2) 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria Arquivo de Trabalho			            			 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//alterado por Valtenio RSAC         
aEstru:={}

aAdd(aEstru, {"FILIAL"      , "C", 02, 00})
aAdd(aEstru, {"CLIENTE"     , "C", 08, 00})
aAdd(aEstru, {"LOJA"        , "C", 04, 00})
aAdd(aEstru, {"NOTA"        , "C", 09, 00})
aAdd(aEstru, {"SERIE"       , "C", 03, 00})
aAdd(aEstru, {"TRANSP"      , "C", 06, 00})
aAdd(aEstru, {"Estado"      , "C", 02, 00})
aAdd(aEstru, {"EMISSAO"     , "D", 08, 00})
aAdd(aEstru, {"SAIDA"       , "D", 08, 00})
aAdd(aEstru, {"DTGUIAPAGA"  , "D", 08, 00}) 
aAdd(aEstru, {"VALMERC"     , "N", 10, 02})
aAdd(aEstru, {"VALGUIA"     , "N", 10, 02})
aAdd(aEstru, {"DIFALIQ"     , "N", 10, 02})
aAdd(aEstru, {"BCICMSOL"    , "N", 10, 02})
aAdd(aEstru, {"MUNIC   "    , "C", 15, 02})
aAdd(aEstru, {"CNPJ    "    , "C", 14, 02})
aAdd(aEstru, {"OK "         , "C", 01, 00})
_cArqTmp := CriaTrab(aEstru, .T.)


If Select("ARQT") > 0
	ARQT->(DbCloseArea())
EndIf

dbUseArea( .T.,,_cArqTmp, "ARQT", .F., .F. )
IndRegua("ARQT", Criatrab(,.f.), "FILIAL + NOTA",,, "Consultando...")     //Alterado Valtenio RSAC

//Fernando
dbSelectArea("TRB")
dbGoTop()
While !Eof()
	
	Reclock("ARQT",.T.)
	ARQT->Filial     := TRB->F2_Filial
	ARQT->Cliente    := TRB->F2_Cliente
	ARQT->Loja       := TRB->F2_Loja	
	ARQT->Nota       := TRB->F2_Doc    
	ARQT->Serie      := TRB->F2_Serie 
	ARQT->Transp     := TRB->F2_Transp
	ARQT->Emissao    := TRB->(StoD(F2_Emissao))
	ARQT->SAIDA      := TRB->(StoD(F2_DTSAIDA))
	ARQT->SAIDA    	 :=	TRB->(StoD(F2_DTSAIDA))
    ARQT->ESTADO     := TRB->F2_EST
    ARQT->DTGUIAPAGA := TRB->(StoD(F2_X_DTGNR))   	
	ARQT->VALMERC    := TRB->F2_VALBRUT
	ARQT->VALGUIA    :=	TRB->F2_ICMSRET
	ARQT->DIFALIQ    := TRB->DIFAL
	ARQT->BCICMSOL   := TRB->F2_BRICMS
	ARQT->MUNIC      := TRB->A1_MUN
    ARQT->CNPJ       := TRB->A1_CGC	
	ARQT->(MsUnLock())

	dbSelectArea("TRB")
	TRB->(DbSkip())	
EndDo

/*DBSELECTAREA("TRB")
TRB->(DBGOTOP())
Do While TRB->( !Eof())
	DbSelectArea("ARQT")
	Append Blank
	
	Replace ARQT->Filial   		With TRB->F2_Filial
	Replace ARQT->Cliente  		With TRB->F2_Cliente
	Replace ARQT->Loja     		With TRB->F2_Loja	
	Replace ARQT->Nota     		With TRB->F2_Doc    
	Replace ARQT->Serie    		With TRB->F2_Serie 
	Replace ARQT->Transp   		With TRB->F2_Transp
	Replace ARQT->Emissao  		With TRB->(StoD(F2_Emissao))
	Replace ARQT->SAIDA    		With TRB->(StoD(F2_DTSAIDA))
	Replace ARQT->ESTADO        With TRB->F2_EST
	Replace ARQT->DTGUIAPAGA    With TRB->(StoD(F2_X_DTGNR))
	Replace ARQT->VALMERC       With TRB->F2_VALBRUT
	Replace ARQT->VALGUIA    	With TRB->F2_ICMSRET
	Replace ARQT->DIFALIQ       With TRB->DIFAL
	Replace ARQT->BCICMSOL     With TRB->F2_BRICMS
	Replace ARQT->MUNIC         With TRB->A1_MUN
	Replace ARQT->CNPJ          With TRB->A1_CGC
	
	ARQT->(MSUNLOCK())
	TRB->(DbSkip())
EndDo  */

cMarca   := GetMark(,"ARQT","OK")
_aTela   := {{"OK","","OK"},{"FILIAL","","FILIAL"},{"NOTA","","NOTA"},{"EMISSAO","","EMISSAO"},{"TRANSP","","TRANSP"},{"CLIENTE","","CLIENTE"},{"CNPJ","","CNPJ"},{"MUNIC","","MUNIC"},{"SAIDA","","SAIDA"},{"ESTADO","","ESTADO"},{"DTGUIAPAGA","","DTGUIAPAGA"},{"VALMERC","","VALMERC"},{"VALGUIA","","VALGUIA"},{"BCICMSOL","","BCICMSOL"},{"DIFALIQ","","DIFALIQ"}}

DBSELECTAREA("ARQT")
ARQT->(DBGOTOP())

//MarkBrowse("ARQT","FILIAL",,_aTela)

//IF MV_PAR01 = 2 .OR. MV_PAR01=3
//    MarkBrow("ARQT","OK2","SAIDA",_aTela,.F.,cMarca,,,,)
//ELSE


aCores := {}
Aadd(aCores,{"EMPTY(DTGUIAPAGA)" ,'ENABLE' })
Aadd(aCores,{"!EMPTY(DTGUIAPAGA)" ,'DISABLE'})


MarkBrow("ARQT","OK","DTGUIAPAGA",_aTela,.F.,cMarca,'u_MarkAll()',,,)   
//MarkBrow('SD3','D3_X_OK',,,lInverte,@cMarca,'u_MarkAll()',,,,'u_Mark2()')

//ENDIF
 
ARQT->(DbCloseArea())

Return


User Function gLeg()
**********************
Local aLegenda := {  {"BR_VERDE" ,"Guia a ser paga"},; //"Faturamento com Meio Magnetico"
                     {"BR_VERMELHO","Guia Paga"}}
                     
BrwLegenda("Status do Item",,aLegenda)		 //'Distribui็ใo das lojas'/Legenda

Return(.T.)
 


User Function gMarca()

Local aArea := GetArea()

If ApMsgYesNo("Confirma gravacao da Nota ?")
	dbSelectArea("ARQT")
	dbGoTop()
	While !Eof()
		If Empty(ARQT->OK)
			dbSelectArea("ARQT")			
			ARQT->(dbSkip())
			Loop
		EndIf
		      	   
		dbSelectArea("SF2")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek(ARQT->(Filial+Cliente+Loja+Nota+Serie))	
        //Gravar campo DTGNERE -Valtenio
		RecLock("SF2", .f.)
  		Replace SF2->F2_X_DTGNR With ddatabase
     	MsUnLock() 
     	///-----------------------------------
	     	Reclock("ARQT",.F.)
	      	If mv_par04 == 1
	        	ARQT->(DBDELETE()) 
	     	ElseIf mv_par04 == 3 
	        	ARQT->OK:=space(1)
	        	ARQT->DTGUIAPAGA:=DDATABASE  
	     	EndIf 
  			//Replace SF2->F2_X_DTGNR With ddatabase
	     	ARQT->(MsUnlock())
		EndIf
	
		dbSelectArea("ARQT")
    	ARQT->(dbSkip())
	EndDo
EndIf

RestArea(aArea)

Return .T.

/* 13.01.2012 - Fernando:  Colocado trecho da fun็ใo gMarca() em comentแrio para utilizar o alterado acima pelo Paulo Afonso RSAC
// Cleiton
//-------------------
User Function gMarca()
*********************
Local cAlias := Alias(), nRecno := ARQT->(Recno())
Local ltrue  := .f.
ARQT->(DbGoTop())

If MsgYesNo("Confirma gravacao da Nota ?")
   ltrue:=.t.
endif   

Do While ARQT->(!Eof())
	
	
	IF EMPTY(ARQT->OK)
	   ARQT->(DBSKIP())
	   LOOP
	ENDIF   
	   
	   
	DbSelectArea("SF2")
	DbSetOrder(2)
	DbSeek(ARQT->(Filial + Cliente + Loja + Nota + Serie))
	
	
	if ltrue
	
		While !RecLock("SF2", .f.)
		EndDo
          
  		Replace SF2->F2_X_DTGNR With ddatabase
     
     	MsUnLock()
   
     	dbselectarea("ARQT")
     	RECLOCK("ARQT",.F.)
     	
     	if mv_par04 == 1
        	ARQT->(DBDELETE()) 
     	elseIF mv_par04 == 3 
        	ARQT->OK:=space(1)
        	ARQT->DTGUIAPAGA:=DDATABASE  
     	ENDIF
     
     	//ARQT->OK:=space(1)
     	ARQT->(MSUNLOCK())
 else
 	    dbselectarea("ARQT")
     	RECLOCK("ARQT",.F.)
     	
     	ARQT->OK:=space(1)
        
     	ARQT->(MSUNLOCK())
  endif  
    
    ARQT->(DbSkip())
EndDo  
         
DbSelectArea("ARQT")

DbGoTo(nRecno)

DbSelectArea(cAlias)
//U_Cont()

Return .t.   */       



//User Function Cont()
//**********************
//U_TransTra(cMarca)

//Return(.T.)	      


// Thiago
/*
User Function CBMarca()
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
	    MsgAlert("Nota Fiscal nใo encontrada!!")
		//lRet:= .f.
	EndIf
	
	_oDlg:End()
EndIf
	
Return lRet



/*
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณD116Pesquiบ Autor ณ AP6 IDE               บ Data ณ  02/08/06บฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Pesquisas pelos index's abertos                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ DURES116                                                   ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DgPesqui()
**************************
Local cAlias,cCampo,cIndex,cKey,cOrd
Local nReg,nI,nOpca:=0
Local oDlg,oCbx,lRet := .T.
Local aOrd := { }

DBSELECTAREA("ARQT")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSalva a Integridade dos Dados                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAlias  := ALIAS()

AADD(aOrd," "+"NOTA")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processa Choices dos Campos do Banco de Dados          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
Return .t.//(MsgYesNo(OemToAnsi("Confirma Seleo?"),OemToAnsi("Ateno")))			//"Confirma Seleo?"###"Ateno"    


User Function MarkAll()

Local aAreaAnt	:= GetArea()
Local lMarca	:=  NIL

DbSelectArea('ARQT')
dbGotop()
While !Eof() 
	If	(lMarca == NIL)
		lMarca := (ARQT->OK == cMarca)
	EndIf
	
	dbselectarea("ARQT")
    RECLOCK("ARQT",.F.)
     	
	    ARQT->OK:=If( lMarca," ",cMarca )
        
    ARQT->(MSUNLOCK())
  
	DbSkip()
EndDo

MarkBRefresh()

RestArea(aAreaAnt)

Return NIL