#include "mntr675.ch"
#INCLUDE "PROTHEUS.CH"

#DEFINE _nVERSAO 20 //Versao do fonte
/*/                                         
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MNTR675  ³ Autor ³ NG Informatica        ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ordem de Servico de Manutencao  (REFEITO 07/08/02 - In cio)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico  (BMNTR002)                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/                                                             
User Function BMNTR002(lVPERG,cDEPLANO,cATEPLANO,aMATOS,nTipo,avMatSX1,nRecOs)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena variaveis p/ devolucao (NGRIGHTCLICK) 				  		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aNGBEGINPRM := NGBEGINPRM(_nVERSAO)

Local vVETHORAS  := {}
Local cString    := "STJ"
Local lPERGUN    := If(lVPERG = Nil .Or. lVPERG == .T. ,.t.,.f.)
Local cGru675    := 'MNT675'+Space(Len(sx1->x1_grupo)-6)
Local cdesc1     := STR0001 //"Emissao de Ordem de Servico de Manutencao. O Usuario pode selecionar"
Local cdesc2     := STR0002 //"quais os campos que deverao ser mostrados na O.S., bem como informar"
Local cdesc3     := STR0003 //"parametros de selecao para a impressao."
Local wnrel      := "BMNTR002"

Local cBARRAS    := If(isSRVunix(),"/","\")
Local cRootPath  := Alltrim(GetSrvProfString("RootPath",cBARRAS))
Local cStartPath := AllTrim(GetSrvProfString("StartPath",cBARRAS))
Local cDirExeTh  := cRootPath+cStartPath 
Local aArea

Private aReturn  := {STR0004, 1,STR0005, 2, 2, 1, "",1} //"Zebrado"###"Administracao"
Private nLastKey := 0
Private Tamanho  := "P"
Private cPerg    := "MNT675"
Private Titulo   := STR0006 //"Ordem De Servico De Manutencao"
Private lSEQSTF  := If(NGVerify("STF"),.T.,.F.)
Private lSEQSTJ  := If(NGVerify("STJ"),.T.,.F.)
Private lSEQSTL  := If(NGVerify("STL"),.T.,.F.)
Private oPrint
Private oDlgC,nTImpr,nOpca := 0
Private lUSATAR := If(FindFunction("NGUSATARPAD"),NGUSATARPAD(),.f.)
Private nB1 := TAMSX3("B1_COD")[1]-15
Private aMatSX1  := avMatSX1 
Private lQuebra := .F.

Default nRecOs := 0
oFontPN := TFont():New("Courier New",10,10,,.T.,,,,.F.,.F.)
oFontMN := TFont():New("Courier New",15,15,,.T.,,,,.F.,.F.)
oFontGN := TFont():New("Courier New",17,17,,.T.,,,,.F.,.F.)

/*
  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ Variaveis utilizadas para parametros                         ³
  ³ mv_par01     // De  Plano de Manutencao                      ³
  ³ mv_par02     // Ate Plano de manutencao                      ³
  ³ mv_par03     // Lista Descricao do Bem   S/N                 ³
  ³ mv_par04     // Lista Detalhes do Bem    S/N                 ³
  ³ mv_par05     // Lista Descricao Manut.   S/N                 ³
  ³ mv_par06     // Lista Descricao Etapas   S/N                 ³
  ³ mv_par07     // De  Centro de Custo                          ³
  ³ mv_par08     // Ate Centro de Custo                          ³
  ³ mv_par09     // De  Centro de Trabalho                       ³
  ³ mv_par10     // Ate Centro de Trabalho                       ³
  ³ mv_par11     // De  Area de Manutencao                       ³
  ³ mv_par12     // Ate Area de Manutencao                       ³
  ³ mv_par13     // De  Ordem de Servico                         ³
  ³ mv_par14     // Ate Ordem de Servico                         ³
  ³ mv_par15     // De  Data de Manutencao                       ³
  ³ mv_par16     // Ate Data de manutencao                       ³
  ³ mv_par17     // Classificacao (Ordem,Servico/Bem,            ³
  ³                 Centro Custos,Data da O.S,Servico/Bem Pai)   ³
  ³ mv_par18     // Lista descr. da O.S  (Nao, Sim)              ³
  ³ mv_par19     // Lista pecas de reposicao(Nao,Sim)            ³
  ³ mv_par20     // Lista Banco do Conhecimento(Nao, Sim)        ³
  ³ mv_par21     // Banco do Conhecimento(Da OS, Da Manutencao,  ³
  ³              // Ambos)                                       ³
  ³ mv_par22     // Tipo de Impressao (Em Disco, Via Spool)      ³
  ³ mv_par23     // Lista Opcoes da Etapa ? (Sim, Nao)           ³
  ³ mv_par24     // Imprimir Localizacao : (Sim, Nao)				  ³
  ³ mv_par25     // Imprimir O.S. ? : (Liberada, Pendente, Todas)³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/ 

U_MNT675SX1(cPerg)

cLogo := cStartPath+"LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP" // Empresa+Filial
If !File(cLogo)
	If File(cStartPath+"LGRL"+SM0->M0_CODIGO+".BMP")
		cLogo := cStartPath+"LGRL"+SM0->M0_CODIGO+".BMP" // Empresa
	ElseIf File(cDIREXETH+"LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP")
		cLogo := cDIREXETH+"LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
	ElseIf File(cDIREXETH+"LGRL"+SM0->M0_CODIGO+".BMP")
		cLogo := cDIREXETH+"LGRL"+SM0->M0_CODIGO+".BMP"
	ElseIf File("LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP")
		cLogo := "LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
	ElseIf File("LGRL"+SM0->M0_CODIGO+".BMP")
		cLogo := "LGRL"+SM0->M0_CODIGO+".BMP"
	ElseIf File("\SIGAADV\LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP")
		cLogo := "\SIGAADV\LGRL"+SM0->M0_CODIGO+SM0->M0_CODFIL+".BMP"
	ElseIf File("\SIGAADV\LGRL"+SM0->M0_CODIGO+".BMP")
		cLogo := "\SIGAADV\LGRL"+SM0->M0_CODIGO+".BMP"
	Endif
Endif

vVetMvP := NGSALVAMVPA()

If nTipo = Nil
	DEFINE MSDIALOG oDlgC FROM 00,00 TO 150,350 TITLE STR0088 PIXEL
    
	oPnlPai := TPanel():New(00,00,,oDlgC,,,,,,320,200,.F.,.F.)
		oPnlPai:Align := CONTROL_ALIGN_ALLCLIENT
		
	@ 005,007 TO 60,175 LABEL STR0091 of oPnlPai Pixel

	@ 015,012 RADIO oRad VAR nTImpr ITEMS STR0092+" "+STR0089,STR0092+" "+STR0090,; //"Padrao"+"Normal"###"Padrao"+"Grafico"
                                         STR0093+" "+STR0089,STR0093+" "+STR0090 of SIZE 60,10 of oPnlPai Pixel //"Completa"+"Normal"###"Completa"+"Grafico"

	Activate MsDialog oDlgC On Init EnchoiceBar(oDlgC,{|| nOPCA := 1,oDlgC:End()},{||oDlgC:End()}) Centered

	If nOpca == 0
		Return
	Endif
Else
	nTImpr := nTipo
Endif


lperg := Pergunte(cPerg,If((nTImpr = 2 .Or. nTImpr = 4) .And. lPERGUN,.T.,.F.), Nil, Nil, Nil, lPERGUN, Nil)

If !IsInCallStack("MNTA265")
   	If ValType(nRecOs) == "N" .And. nRecOs > 0
		aArea := STJ->(GetArea())
		
		dbSelectArea("STJ")
		dbGoTo(nRecOs)
		
		aMATSX1 := 	{{'01',stj->tj_plano},{'02',stj->tj_plano},;
					 {'07',stj->tj_ccusto},{'08',stj->tj_ccusto},;
					 {'09',stj->tj_centrab},{'10',stj->tj_centrab},;
					 {'11',stj->tj_codarea},{'12',stj->tj_codarea},;
					 {'13',STJ->TJ_ORDEM},{'14',STJ->TJ_ORDEM},;
					 {'15',STJ->TJ_DTMPINI},{'16',STJ->TJ_DTMPINI},;
					 {'24',1},{'25',3}}
					 
		RestArea(aArea)
  	EndIf
EndIf

If nTImpr = 2 .Or. nTImpr = 4
	
	If !lperg .And. lPERGUN
		Return
	Endif
	
	oPrint  := TMSPrinter():New(OemToAnsi(STR0006))
	limpbol := oPrint:Setup()
	oPrint:SetPortrait() // Normal
	
	If !limpbol
		Return
	Endif

	Processa({ |lEnd| U_RW675IMP(oPrint,cDEPLANO,cATEPLANO,aMATOS,nRecOs)},STR0067)//"Aguarde... verificando alteracoes.."
Else
	If lPERGUN
		wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
	Else
		wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,"")
	Endif
	
	If nLastKey = 27
		Set Filter To
		DbSelectArea("STI")
		Return
	EndIf
	
	SetDefault(aReturn,cString)
 	RptStatus({|lEnd| R675Imp(@lEnd,wnRel,titulo,tamanho,cDEPLANO,cATEPLANO,aMATOS,nRecOS)},titulo)
Endif

NGRETAUMVPA(vVetMvP)

DbSelectArea("STI")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve variaveis armazenadas (NGRIGHTCLICK)                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
NGRETURNPRM(aNGBEGINPRM)

Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RW675Imp ³ Autor ³ NG Informatica Ltda   ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RW675Imp(oPrint,cDEPLANO,cATEPLANO,aMATOS,nRecOS)
Local cCONDICAO := If(cDEPLANO = Nil,'stj->tj_situaca == "L" .And. stj->tj_termino == "N"',;
                     If(MV_PAR25==1,'stj->tj_situaca == "L".And. stj->tj_termino == "N"',;
                     If(MV_PAR25==2,'stj->tj_situaca == "P".And. stj->tj_termino == "N"',;
                     'stj->tj_situaca <> "C".And. stj->tj_termino == "N"')))
Local xk := 0,xz := 0,nContador := 0
Local cLoc
Local lIdent := .F.
Local nContLinha := 1
Local nLinha := 0
Local lPrimStl := .T.
Private aBenseP  := {}
Private       li := 4000 ,m_pag := 1
Private nINDSTQ  := 1 
Private aVETINR  := {} 
Private cSEQWHI  := If(lSEQSTL,"STL->TL_SEQRELA = '0  '","STL->TL_SEQUENC = 0")
Private cSEQSTL  := If(lSEQSTL,"0  ",Str(0,2))

Default nRecOs := 0

If aMatSX1 <> Nil
   NGMVPARSX1(cPerg,aMatSX1)
Endif

cCONDICAO += ' .And. stj->tj_ccusto >= MV_PAR07 .And. stj->tj_ccusto <= MV_PAR08 .And. ';
             +'stj->tj_centrab >= MV_PAR09 .And. stj->tj_centrab <= MV_PAR10 .And. ';
             +'stj->tj_codarea >= MV_PAR11 .And. stj->tj_codarea <= MV_PAR12 .And.';
             +'stj->tj_ordem >= MV_PAR13 .And. stj->tj_ordem <= MV_PAR14 .And. ';
             +'stj->tj_dtmpini >= MV_PAR15 .And. stj->tj_dtmpini <= MV_PAR16'

aDBFR675 := {{"ORDEM"   ,"C", 06,0},;
             {"PLANO"   ,"C", 06,0},;
             {"SERVICO" ,"C", 06,0},;
             {"CODBEM"  ,"C", 16,0},;
             {"CCUSTO"  ,"C", Len(STJ->TJ_CCUSTO),0},;
             {"DATAOS"  ,"D", 08,0},;
             {"DIFFDT"  ,"N", 08,0},;
             {"BEMPAI"  ,"C", 16,0}}

If MV_PAR17 = 1      //Ordem
   vIND675 := {"ORDEM"}
ElseIf MV_PAR17 = 2  //Servico/Bem 
   vIND675 := {"SERVICO+CODBEM"}
ElseIf MV_PAR17 = 3  //Centro Custo 
   vIND675 := {"CCUSTO"}
ElseIf MV_PAR17 = 4  //Data da O.S.
   vIND675 := {"Dtos(DATAOS)"}
Else                 // Servico/Bem Pai
   vIND675 := {"SERVICO+BEMPAI"}
EndIf    
                  
cARQTR675 := NGCRIATRB(aDBFR675,vIND675,"TRB675")

If FindFunction("NGSEQETA")
   nINDSTQ := NGSEQETA("STQ",nINDSTQ)
EndIf 

lSEQETA := .F. 
DbSelectArea("STQ")
If FieldPos("TQ_SEQETA") > 0
   lSEQETA := .T.
EndIf 

If cDEPLANO == Nil .and. nRecOS == 0
	DbSelectArea("STI")
	DbSetOrder(01)
	DbSeek(xFilial("STI")+MV_PAR01)
	DbSelectArea("STJ")
	DbSetOrder(03)
	DbSeek(xFilial("STJ")+MV_PAR01,.T.)
	ProcRegua(LastRec())
	While !Eof() .And. STJ->TJ_FILIAL == xFilial("STJ") .And.;
		STJ->TJ_PLANO >= MV_PAR01 .And. STJ->TJ_PLANO <= MV_PAR02
		IncProc()
		If &(cCONDICAO)
			MNTRW675GTRB()
		EndIf
		DbSelectArea("STJ")
		DbSkip()
	End
Elseif cDEPLANO == Nil .and. nRecOS <> 0
	dbSelectArea("STJ")
	dbGoTo(nRecOS)
	MNTRW675GTRB()	
Else
	DbSelectArea("STJ")
	DbSetOrder(03)
	DbSeek(xFilial("STJ")+cDEPLANO,.T.)
	ProcRegua(LastRec())
	While !Eof() .And. STJ->TJ_FILIAL == xFilial("STJ") .And.;
		STJ->TJ_PLANO <= cATEPLANO
		
		IncProc()
		If &(cCONDICAO)
			
			nPosOs := aSCAN(aMATOS, {|x| x[1]+x[2] == STJ->TJ_PLANO+STJ->TJ_ORDEM})
			If nPosOs > 0
				nDiff := nil
				If Len(aMATOS[nPosOs]) >= 3
					nDiff := aMATOS[nPosOs,3] //Indica a quantidade de dias que as datas da OS serão deslocadas
				Endif
				MNTRW675GTRB( nDiff )
			EndIf
			
		EndIf
		DbSelectArea("STJ")
		DbSkip()
	End
EndIf

DbSelectArea("TRB675")   
DbGotop()
ProcRegua(LastRec())
While !Eof()
   IncProc()
   
   nPaG := 0
   DbSelectArea("STJ")
   DbSetOrder(01)
   If DbSeek(xFilial("STJ")+TRB675->ORDEM+TRB675->PLANO)  

      DbSelectArea("STF")
      DbSetOrder(01)
      cSEQSTF := If(lSEQSTF,STJ->TJ_SEQRELA,STR(STJ->TJ_SEQUENC,3))
      DbSeek(xFilial('STF')+STJ->TJ_CODBEM+STJ->TJ_SERVICO+cSEQSTF)

      MNTW675Somal(oPrint)

      MNTW675Somal(oPrint)
      oPrint:Say(li,900,STR0068,oFonTMN)

      MNTW675Somal(oPrint)
      MNTW675Somal(oPrint)
      oPrint:Line(li,15,li,2335)
      cLoc := NGLocComp(STJ->TJ_CODBEM,'1')
      If cLoc <> AllTrim(STJ->TJ_CODBEM)
      	lIdent := .T.
      Else
      	lIdent := .F.
      EndIf	
		If lIdent .And. MV_PAR24 == 1
			cLoc := STR0104+": "+cLoc //"Localização"
			While Len(cLoc) > 0
				oPrint:Say(li,15,SubStr(cLoc,1,077),oFontPN)
				cLoc := SubStr(cLoc,078)
				cLoc := If(!Empty(cLoc),Space(Len(STR0104+": ")),"")+cLoc //"Localização"
				MNTW675Somal(oPrint)
			EndDo
		EndIf
       If STJ->TJ_TIPOOS $ "B/M"
    		oPrint:Say(li,015,"Bem......:"+Space(1)+STJ->TJ_CODBEM;
    				+Space(21-len(STJ->TJ_CODBEM))+NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_NOME'),oFonTPN)


			cPlaca := NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_PLACA')
			If !Empty(cPlaca)
	         MNTW675Somal(oPrint)
		      oPrint:Say(li,15,"Placa....:"+Space(1)+cPlaca,oFonTPN)
			Endif

         oPrint:Say(li,2020,STR0009+" "+NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_PRIORID'),oFonTPN)
         nAtual := ST9->(Recno())
         If !Empty(TRB675->BEMPAI)
            MNTW675Somal(oPrint)

            oPrint:Say(li,15,SubStr(STR0010,2,Len(STR0010))+" "+TRB675->BEMPAI;
            		+Space(21-len(TRB675->BEMPAI))+NGSEEK('ST9',TRB675->BEMPAI,1,'ST9->T9_NOME'),oFonTPN)
            DbSelectArea("ST9")
            dbGoTo(nAtual)
         Endif
      Else
      	 oPrint:Say(li,015,"Código...:"+Space(1)+STJ->TJ_CODBEM;
    				+Space(21-len(STJ->TJ_CODBEM));
    				+NGSEEK('TAF',"X2"+SubStr(STJ->TJ_CODBEM,1,3),7,"SubStr(TAF_NOMNIV,1,40)"),oFonTPN)
         oPrint:Say(li,2020,STR0009+" "+NGSEEK('TQB',STJ->TJ_CODBEM,1,'TQB->TQB_PRIORI'),oFonTPN)
      Endif
      If !Empty(ST9->T9_LOCAL)
	      MNTW675Somal(oPrint)
      	oPrint:Say(li,015,STR0105,oFonTPN) //"Local....:"
      	oPrint:Say(li,315,ST9->T9_LOCAL,oFonTPN)
      EndIf
	      MNTW675Somal(oPrint)
         oPrint:Say(li,15,SubStr(STR0011,2,Len(STR0011))+Space(1)+STJ->TJ_CCUSTO;
                +Space(21-len(STJ->TJ_CCUSTO))+NGSEEK('SI3',STJ->TJ_CCUSTO,1,'SI3->I3_DESC'),oFonTPN)

      MNTW675Somal(oPrint)
      If !Empty(STJ->TJ_CENTRAB)
	      oPrint:Say(li,15,SubStr(STR0012,2,Len(STR0012))+Space(1)+STJ->TJ_CENTRAB;
    	            +Space(21-len(STJ->TJ_CENTRAB))+NGSEEK('SHB',STJ->TJ_CENTRAB,1,'SHB->HB_NOME'),oFonTPN)
      EndIf

      If STJ->TJ_TIPOOS $ "B/M"
	     If mv_par04 = 1 
	        lPrimeiro := .F.
	        dbSelectArea("STB")
	        dbSetOrder(01)
	        dbSeek(xFilial('STB')+ST9->T9_CODBEM)
	        While !Eof() .And. STB->TB_CODBEM = ST9->T9_CODBEM  .And.;
	           STB->TB_FILIAL == xFilial('STB')
               MNTW675Somal(oPrint)
               If !lPrimeiro
                  lPrimeiro = .T.
                  oPrint:Say(li,15,STR0013,oFonTPN)
	           EndIf
					
					oPrint:Say(li,15,Space(Len(STR0013))+;
						   Space(1) + PADR(NGSEEK('TPR',STB->TB_CARACTE,1,'TPR->TPR_NOME'),40," ")+;
               			   Space(2) + PADL(STB->TB_DETALHE,TAMSX3("TB_DETALHE")[1]," ")+;
               			   Space(1) + STB->TB_UNIDADE,oFonTPN)
					
               dbSelectArea("STB")
	           dbSkip()
	        End
	     EndIf

         // Impressao da Linha de Descricao
         If mv_par03 = 1 
            U_NGMEMORW675(STR0014,ST9->T9_DESCRIC,300,70,.T.)
         EndIf
      EndIf

		nLinha := li
		lQuebra := .F.
		For nContLinha := 1 to 5
			MNTW675Somal(oPrint)
		Next
		If lQuebra
	      oPrint:Say(li,900,STR0070,oFonTMN)
	  	Else
			li := nLinha
	      MNTW675Somal(oPrint)
	      MNTW675Somal(oPrint)
	      oPrint:Say(li,900,STR0070,oFonTMN)
		EndIf
  		MNTW675Somal(oPrint)
		MNTW675Somal(oPrint)

      oPrint:Line(li,15,li,2335)

      oPrint:Say(li,15,SubStr(STR0016,2,Len(STR0016))+" "+STJ->TJ_SERVICO;
                +"  "+NGSEEK('ST4',STJ->TJ_SERVICO,1,'SubStr(ST4->T4_NOME,1,35)'),oFonTPN)

      If STJ->TJ_TIPOOS $ "B/M"
         oPrint:Say(li,1650,STR0017+"  "+Dtoc(STJ->TJ_DTULTMA),oFonTPN)
      Endif

      MNTW675Somal(oPrint)

      oPrint:Say(li,15,SubStr(STR0018,2,Len(STR0018))+" ";
         +If(lSEQSTJ,STJ->TJ_SEQRELA,Str(STJ->TJ_SEQUENC,3)),oFonTPN)

      If STJ->TJ_TIPOOS $ "B/M"
         oPrint:Say(li,500,STR0019,oFonTPN)
      EndIf

      lPrinNom := .f.

      If NGCADICBASE('T4_TERCEIR','A','ST4',.F.)
         DbselectArea("ST4")
         DbSetOrder(01)
         If DbSeek(xFilial("ST4")+STJ->TJ_SERVICO)
            If ST4->T4_TERCEIR = "S"
               lPOSR1 := NGCADICBASE('TJ_POSCPR1','A','STJ',.F.)
               lPOSR2 := NGCADICBASE('TJ_POSCPR2','A','STJ',.F.)

               If lPOSR1 .Or. lPOSR2
                  If !Empty(STJ->TJ_POSCPR1)
                     oPrint:Say(li,850,STR0057+" "+STR0058+" 1 "+STR0059;
                     +"  "+Str(STJ->TJ_POSCPR1,12),oFonTPN)
                     lPrinNom := .t.

                  ElseIf !Empty(STJ->TJ_POSCPR2)
                     oPrint:Say(li,850,STR0057+" "+STR0058+" 1 "+STR0059;
                     +"  "+Str(STJ->TJ_POSCPR2,12),oFonTPN)
                     lPrinNom := .t.
                  Endif
               Endif
            Endif
         Endif
      Endif

      DbSelectArea("STF")
      DbSetOrder(01)
      DbSeek(XFILIAL('STF')+STJ->TJ_CODBEM+STJ->TJ_SERVICO+cSEQSTF)
      If !lPrinNom .And. STJ->TJ_TIPOOS $ "B/M"
         oPrint:Say(li,890,STF->TF_NOMEMAN,oFonTPN)
      EndIf
      If STJ->TJ_PLANO == "000000"
			oPrint:Say(li,890," "+STR0115,oFonTPN) 
      Endif

      MNTW675Somal(oPrint)

      oPrint:Say(li,15,SubStr(STR0020,2,Len(STR0020))+" "+STJ->TJ_CODAREA;
                +"  "+NGSEEK('STD',STJ->TJ_CODAREA,1,'STD->TD_NOME'),oFonTPN)

      If STJ->TJ_TIPOOS $ "B/M"
         If STF->TF_TIPACOM $ "CAF"
            oPrint:Say(li,1550,STR0021+" "+Str(STF->TF_CONMANU,6),oFonTPN)
         EndIf
      EndIf

      MNTW675Somal(oPrint)

      oPrint:Say(li,15,SubStr(STR0022,2,Len(STR0022))+" "+STJ->TJ_TIPO;
                +"  "+NGSEEK('STE',STJ->TJ_TIPO,1,'STE->TE_NOME'),oFonTPN)

      MNTW675Somal(oPrint)

      oPrint:Say(li,15,SubStr(STR0065,1,Len(STR0065))+" "+STF->TF_DOCTO,oFonTPN)
      
      If STJ->TJ_TIPOOS $ "B/M"
         MNTW675Somal(oPrint)
         oPrint:Say(li,15  ,SubStr(STR0023,2,Len(STR0023))+" "+Str(STF->TF_TEPAANT,3),oFonTPN)
         oPrint:Say(li,700 ,STF->TF_UNPAANT,oFonTPN)
         oPrint:Say(li,800 ,Dtoc(STJ->TJ_DTPPINI),oFonTPN)
         oPrint:Say(li,1000 ,STJ->TJ_HOPPINI,oFonTPN)

         oPrint:Say(li,1400,STR0024+"  "+Str(STF->TF_TEPADEP,3),oFonTPN)
         oPrint:Say(li,1750,STF->TF_UNPADEP,oFonTPN)
         oPrint:Say(li,1950,Dtoc(STJ->TJ_DTPPFIM),oFonTPN)
         oPrint:Say(li,2150,STJ->TJ_HOPPFIM,oFonTPN)

         // Linha da descricao da manutencao
         If mv_par05 == 1
            U_NGMEMORW675(STR0014,STF->TF_DESCRIC,300,70,.T.)
         EndIf                                            
         
      EndIf

      aARTAREFAS := {}

      DbSelectArea("STL")
      DbSetOrder(03)
      DbSeek(XFILIAL('STL')+STJ->TJ_ORDEM+STJ->TJ_PLANO+cSEQSTL)

      While !Eof() .And. Xfilial("STL") == STL->TL_FILIAL .And.;
         STJ->TJ_ORDEM == STL->TL_ORDEM .And. STJ->TJ_PLANO == STL->TL_PLANO;
         .AND. If(lSEQSTL,STL->TL_SEQRELA == "0  ",STL->TL_SEQUENC = 0)
	         
         nPOS := Ascan(aARTAREFAS,{|x| x[1] == stl->tl_tarefa})
         If nPOS = 0
            Aadd(aARTAREFAS,{stl->tl_tarefa,stl->tl_dtinici,stl->tl_hoinici,;
                             stl->tl_dtfim,stl->tl_hofim})
         Else
            If stl->tl_dtinici < aARTAREFAS[nPOS][2]
               aARTAREFAS[nPOS][2] := stl->tl_dtinici
               aARTAREFAS[nPOS][3] := stl->tl_hoinici
            ElseIf stl->tl_dtinici == aARTAREFAS[nPOS][2] .And. stl->tl_hoinici < aARTAREFAS[nPOS][3]
               aARTAREFAS[nPOS][3] := stl->tl_hoinici
            EndIf

            If STL->TL_DTFIM > aARTAREFAS[nPOS][4]
               aARTAREFAS[nPOS][4] := stl->tl_dtfim
               aARTAREFAS[nPOS][5] := stl->tl_hofim
            ElseIf stl->tl_dtfim == aARTAREFAS[nPOS][4] .And. stl->tl_hofim > aARTAREFAS[nPOS][5]
               aARTAREFAS[nPOS][5] := stl->tl_hofim
            EndIf
         Endif
         DbSelectArea("STL")
         Dbskip()
      End
      
		aARETAPAS := {}
		DbSelectArea("STQ")
		DbSetOrder(01)
		DbSeek(XFILIAL('STQ')+STJ->TJ_ORDEM+STJ->TJ_PLANO)
		While !Eof() .And. Xfilial("STQ") = STQ->TQ_FILIAL .And.;
			STQ->TQ_ORDEM == STJ->TJ_ORDEM .And. STQ->TQ_PLANO == STJ->TJ_PLANO
			Aadd(aARETAPAS,{stq->tq_tarefa,stq->tq_etapa,stq->tq_seqeta})
			If Empty(aARTAREFAS)
				Aadd(aARTAREFAS,{STQ->TQ_TAREFA,STJ->TJ_DTMPINI,STJ->TJ_HOMPINI,;
				STJ->TJ_DTMPFIM,STJ->TJ_HOMPFIM })
			EndIf	
			DbSkip()
		End

      MNTW675Somal(oPrint)

      For xk := 1 To Len(aARTAREFAS)

			nLinha := li
			lQuebra := .F.
			For nContLinha := 1 to 5
				MNTW675Somal(oPrint)
			Next
			If lQuebra
	         oPrint:Say(li,900,STR0051,oFonTMN)
	   	Else
		      li := nLinha
	         MNTW675Somal(oPrint)
	         MNTW675Somal(oPrint)
	         oPrint:Say(li,900,STR0051,oFonTMN)
			EndIf
         MNTW675Somal(oPrint)
         MNTW675Somal(oPrint)

         oPrint:Line(li,15,li,2335)

         MNTW675Somal(oPrint)

         oPrint:Say(li,15 ,SubStr(STR0026,2,Len(STR0026))+" "+aARTAREFAS[xk,1],oFonTPN)
         oPrint:Say(li,550,STR0027+" "+Dtoc(aARTAREFAS[xk,2]+TRB675->DIFFDT)+" "+aARTAREFAS[xk,3],oFonTPN)

         oPrint:Say(li,1600,STR0028+" "+Dtoc(aARTAREFAS[xk,4]+TRB675->DIFFDT)+" "+aARTAREFAS[xk,5],oFonTPN)

         MNTW675Somal(oPrint)

         oPrint:Say(li,550 ,STR0029,oFonTPN)
         oPrint:Say(li,1600,STR0028,oFonTPN)

         MNTW675Somal(oPrint)

         If Alltrim(aARTAREFAS[xk][1]) == "0"
            oPrint:Say(li,20,STR0030,oFonTPN)
         Else
            If !lUSATAR
               oPrint:Say(li,20,NGSEEK('ST5',STJ->TJ_CODBEM+STJ->TJ_SERVICO+;
                                     If (lSEQSTJ,STJ->TJ_SEQRELA,Str(STJ->TJ_SEQUENC,3))+;
                                     aARTAREFAS[xk][1],1,'T5_DESCRIC'),oFonTPN)
            Else
               lCORRET := If(Val(stj->tj_plano) = 0,.t.,.f.)
               oPrint:Say(li,20,NGNOMETAR(STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA,;
                                          aARTAREFAS[xk][1]),oFonTPN)
            Endif
         EndIf

         If MV_PAR06 == 1      // mostra etapas da tarefa
            DbSelectArea("STQ")
            DbSetOrder(nINDSTQ)
            If DbSeek(XFILIAL('STQ')+STJ->TJ_ORDEM+STJ->TJ_PLANO+aARTAREFAS[xk][1])

               MNTW675Somal(oPrint)
               MNTW675Somal(oPrint)
               oPrint:Say(li,900,STR0071,oFonTMN)
               MNTW675Somal(oPrint)
	            MNTW675Somal(oPrint)               

               oPrint:Line(li,20,li,2330)

               While !Eof() .And. Xfilial("STQ") = STQ->TQ_FILIAL .And.;
                  STQ->TQ_ORDEM == STJ->TJ_ORDEM .And.;
                  STQ->TQ_PLANO == STJ->TJ_PLANO .And.;
                  STQ->TQ_TAREFA == aARTAREFAS[xk][1]

                 	U_NGWIMPETAPA(stq->tq_ok,stq->tq_etapa)
						
                  // Deletar as etapas da array aARETAPAS
                  nPOS2 := Ascan(aARETAPAS,{|x| x[1] == stq->tq_tarefa .And. x[2] == stq->tq_etapa})
                  If nPOS2 > 0
                     Adel(aARETAPAS,nPOS2)
                     Asize(aARETAPAS,Len(aARETAPAS)-1)
                  Endif
                  DbSelectArea("STQ")
                  DbSkip()
               End
            EndIf
         EndIf
         
         nLinha := li
         lQuebra := .F.
			For nContLinha := 1 to 3
				MNTW675Somal(oPrint)
			Next
			
         DbSelectArea("STL")
         DbSetOrder(03)
         DbSeek(XFILIAL('STL')+STJ->TJ_ORDEM+STJ->TJ_PLANO+cSEQSTL+aARTAREFAS[xk][1])
         While !Eof() .And. Xfilial("STL") = STL->TL_FILIAL .And.;
            STJ->TJ_ORDEM == STL->TL_ORDEM .And. STJ->TJ_PLANO == STL->TL_PLANO;
            .And. &(cSEQWHI) .And. STL->TL_TAREFA == aARTAREFAS[xk][1]
            If lPrimStl
				If lQuebra
					oPrint:Say(li,900,STR0072,oFonTMN)
			   	Else
			        li := nLinha
			        MNTW675Somal(oPrint)
			        MNTW675Somal(oPrint)
			        oPrint:Say(li,900,STR0072,oFonTMN)
				EndIf
		        MNTW675Somal(oPrint)
		        MNTW675Somal(oPrint)
					
				oPrint:Line(li,20,li,2330)
		   		MNTW675Somal(oPrint)
					
				oPrint:Say(li,12,STR0033,oFonTPN)
				oPrint:Say(li,780,STR0094,oFonTPN)
				oPrint:Say(li,1460,STR0107,oFonTPN)
				oPrint:Say(li,1760,STR0087,oFonTPN)
				oPrint:Say(li,1893,STR0108,oFonTPN)
				oPrint:Say(li,1993,STR0109,oFonTPN)
				oPrint:Say(li,2208,STR0110,oFonTPN)
					
	      	   MNTW675Somal(oPrint)
	      	   lPrimStl := .F.
	    	   EndIf
	
            MNTW675Somal(oPrint)

            aTIPNOM := NGNOMINSUM(stl->tl_tiporeg,stl->tl_codigo,30)
            If Len(aTIPNOM) > 0
               oPrint:Say(li,12,Substr(aTIPNOM[1][1],1,4),oFonTPN)
            Endif

            oPrint:Say(li,148,STL->TL_CODIGO,oFonTPN)
            
            vVETHORAS := NGTQUATINS(STL->TL_CODIGO,STL->TL_TIPOREG,STL->TL_USACALE,;
                                    STL->TL_QUANTID,STL->TL_TIPOHOR,STL->TL_DTINICI,;
                                    STL->TL_HOINICI,STL->TL_DTFIM,STL->TL_HOFIM,STL->TL_UNIDADE)
            nQTDHORAS := vVETHORAS[1]

			oPrint:Say(li,780,aTIPNOM[1][2],oFonTPN)
			oPrint:Say(li,1460 ,Dtoc(STL->TL_DTINICI+TRB675->DIFFDT),oFonTPN)
			oPrint:Say(li,1760 ,STL->TL_HOINICI,oFonTPN)
			oPrint:Say(li,1893,Str(STL->TL_QUANREC,3),oFonTPN)
			If STL->TL_TIPOREG <> "P"
			   oPrint:Say(li,1940,Str(NGRHODSEXN(nQTDHORAS,"D"),9,2),oFonTPN)
			Else
			   oPrint:Say(li,1940,Str(nQTDHORAS,9,2),oFonTPN)
			EndIf    
			oPrint:Say(li,2208,STL->TL_UNIDADE,oFonTPN)

            If !Empty(STL->TL_OBSERVA)
               MNTW675Somal(oPrint)
               U_NGMEMORW675(Space(2)+STR0066,STL->TL_OBSERVA,450,60,.T.)
               MNTW675Somal(oPrint)
            Endif
            DbSelectArea("STL")
            DbSkip()
         End
         lPrimStl := .T.
      Next xk
      
      // Imprime as etapas nao relacionadas com insumos
      If MV_PAR06 == 1      // mostra etapas da tarefa
         If Len(aARETAPAS) > 0
            nLinha := li
	         lQuebra := .F.
				For nContLinha := 1 to 5
					MNTW675Somal(oPrint)
				Next
				If lQuebra
	            oPrint:Say(li,700,STR0071+" "+STR0073+" "+STR0072,oFonTMN)
		   	Else
		         li := nLinha
		         MNTW675Somal(oPrint)
		         MNTW675Somal(oPrint)
	            oPrint:Say(li,700,STR0071+" "+STR0073+" "+STR0072,oFonTMN)
				EndIf
	         MNTW675Somal(oPrint)
	         MNTW675Somal(oPrint)
            
            oPrint:Line(li,10,li,2335)
            aARCLASS := If(lSEQETA,Asort(aARETAPAS,,,{|x,y| x[1]+x[3]+x[2] < y[1]+y[3]+y[2]}),;
                                   Asort(aARETAPAS,,,{|x,y| x[1]+x[2] < y[1]+y[2]}))
            cAUXTAR := 'XXXXXX'
            For xz := 1 To Len(aARCLASS)
               If cAUXTAR <> aARCLASS[xz][1]
                  MNTW675Somal(oPrint)
                  oPrint:Say(li,15 ,STR0051,oFonTPN)
                  oPrint:Say(li,200,aARCLASS[xz,1],oFonTPN)

                  If !lUSATAR
                     oPrint:Say(li,380,If(Alltrim(aARCLASS[xz,1]) == "0",STR0030,;
                                          NGSEEK('ST5',STJ->TJ_CODBEM+STJ->TJ_SERVICO;
                                          +If(lSEQSTJ,STJ->TJ_SEQRELA,Str(STJ->TJ_SEQUENC,3))+;
                                          aARCLASS[xz,1],1,'ST5->T5_DESCRIC')),oFonTPN)
                  Else
                     lCORRET := If(Val(stj->tj_plano) = 0,.t.,.f.)
                     oPrint:Say(li,380,NGNOMETAR(STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA,;
                                                 aARCLASS[xz][1]),oFonTPN)
                  Endif
               Endif
               cAUXTAR := aARCLASS[xz][1]
               U_NGWIMPETAPA("  ",aARCLASS[xz][2])
            Next xz
         Endif
      Endif

      // Impressao da Linha de Descricao da O.S
      If mv_par18 = 2  
         MNTW675Somal(oPrint)
         MNTW675Somal(oPrint)
         oPrint:Line(li,10,li,2335)

         cOBSERVA := If(NGCADICBASE('TJ_MMSYP','A','STJ',.F.),;
                        NGMEMOSYP(STJ->TJ_MMSYP),STJ->TJ_OBSERVA)
         nCol := 500
         nTOs := 65

         #IFDEF SPANISH
            nCol := 700
            nTOs := 50
         #ENDIF    
      
         U_NGMEMORW675(STR0052,cOBSERVA,nCol,nTOs,.T.)  //"Descricao da O.S:"
      EndIf

      If mv_par19 = 2 .And. STJ->TJ_TIPOOS $ "B/M"
         dbselectarea("STJ") 
         nINDESTJ := IndexOrd()
         nRECNSTJ := Recno()
         aAPESCAR := NGPEUTIL(stj->tj_codbem)
         DbselectArea("STJ")
         DbsetOrder(nINDESTJ)
         DbGoto(nRECNSTJ)
         If Len(aAPESCAR) > 0
            MNTW675Somal(oPrint)
            MNTW675Somal(oPrint)
            oPrint:Say(li,900,STR0074,oFonTMN)// "Peças de Reposição"
            MNTW675Somal(oPrint) // inc linha
			MNTW675Somal(oPrint)
            oPrint:Line(li,10,li,2335)
            MNTW675Somal(oPrint)

			oPrint:Say(li,15,STR0085,oFonTPN) //"Codigo"
			oPrint:Say(li,880,STR0094,oFonTPN) //"Descricao"
			MNTW675Somal(oPrint)
			oPrint:Say(li,1030,STR0098,oFonTPN) //"Dt.U.Uso"
			oPrint:Say(li,1260,STR0099,oFonTPN) //"Contador"
			oPrint:Say(li,1540,STR0100,oFonTPN) //"Proxima"
			oPrint:Say(li,1780,STR0101,oFonTPN) //"Dt.Prox."
			
            For xk := 1 To Len(aAPESCAR)
               MNTW675Somal(oPrint)
               oPrint:Say(li,15 ,aAPESCAR[xk,1],oFonTPN)
               oPrint:Say(li,880,Substr(NGSEEK("SB1",aAPESCAR[xk,1],1,"B1_DESC"),1,24),oFonTPN)
					MNTW675Somal(oPrint)
               If !Empty(aAPESCAR[xk,2])
                  oPrint:Say(li,1030,Dtoc(aAPESCAR[xk,2]),oFonTPN)
               Endif

               If !Empty(aAPESCAR[xk,4])
                  oPrint:Say(li,1240,Str(aAPESCAR[xk,4],9),oFonTPN)
               Endif

               If !Empty(aAPESCAR[xk,6])
                  oPrint:Say(li,1500,Str(aAPESCAR[xk,6],9),oFonTPN)
               Endif

               If !Empty(aAPESCAR[xk,8])
                  oPrint:Say(li,1780,Dtoc(aAPESCAR[xk,8]),oFonTPN)
               Endif

               If !Empty(aAPESCAR[xk,5]) .Or. !Empty(aAPESCAR[xk,7]) .Or.;
                  !Empty(aAPESCAR[xk,9])
                  MNTW675Somal(oPrint)
                  oPrint:Say(li,500,STR0055,oFonTPN)

                  If !Empty(aAPESCAR[xk,5])
                     oPrint:Say(li,1250,Str(aAPESCAR[xk,5],9),oFonTPN)
                  Endif
                  If !Empty(aAPESCAR[xk,7])
                     oPrint:Say(li,1500,Str(aAPESCAR[xk,7],9),oFonTPN)
                  Endif
                  If !Empty(aAPESCAR[xk,9])
                  oPrint:Say(li,1780,Dtoc(aAPESCAR[xk,9]),oFonTPN)
                  Endif
               Endif
            Next xk
         Endif

         Dbselectarea("STJ") 
         DbSetOrder(nINDESTJ)
         Dbgoto(nRECNSTJ)

      Endif

    
		nLinha := li
		lQuebra := .F.
		For nContLinha := 1 to 5
			MNTW675Somal(oPrint)
		Next
		If lQuebra
			oPrint:Say(li,900,STR0075,oFonTMN)
   	Else
         li := nLinha
         MNTW675Somal(oPrint)
         MNTW675Somal(oPrint)
         oPrint:Say(li,900,STR0075,oFonTMN)
		EndIf
		MNTW675Somal(oPrint)
		MNTW675Somal(oPrint)

      oPrint:Line(li,10,li,2335)
      MNTW675Somal(oPrint)
      oPrint:Say(li,15 ,SubStr(STR0041,2,Len(STR0041)-2),oFonTPN)

      For nContador := 1 to 5
         MNTW675Somal(oPrint)
         oPrint:Say(li,15,"____________   ____________________   _____________________   __________________",oFonTPN)
      Next

      If nTImpr = 4
         DbSelectArea("TPL")
         DbSetOrder(01)
         If DbSeek(XFILIAL('TPL')+STJ->TJ_ORDEM)
            cTitSX3 := 'sx3->x3_titulo'
            #IFDEF SPANISH
               cTitSX3 := 'sx3->x3_titspa'
            #ELSE
               #IFDEF ENGLISH
                  cTitSX3 := 'sx3->x3_titeng'
               #ENDIF
            #ENDIF

            MNTW675Somal(oPrint)
            MNTW675Somal(oPrint)
            oPrint:Say(li,800,NGSX2NOME("TPL"),oFonTMN)

            MNTW675Somal(oPrint)
            oPrint:Line(li,10,li,2335)

            oPrint:Say(li,  15,NGSEEKDIC("SX3","TPL_CODMOT",2,cTitSX3),oFonTPN)
            oPrint:Say(li, 250,NGSEEKDIC("SX3","TPL_DESMOT",2,cTitSX3),oFonTPN)
            oPrint:Say(li,1480,SubStr(NGSEEKDIC("SX3","TPL_DTINIC",2,cTitSX3),1,8),oFonTPN)
            oPrint:Say(li,1730,STR0087,oFonTPN)
            oPrint:Say(li,1900,NGSEEKDIC("SX3","TPL_DTFIM" ,2,cTitSX3),oFonTPN)
            oPrint:Say(li,2150,STR0087,oFonTPN)

            DbSelectArea("TPL")
            While !Eof() .And. Xfilial("TPL") = TPL->TPL_FILIAL .And.;
               TPL->TPL_ORDEM == STJ->TJ_ORDEM
               MNTW675Somal(oPrint)
               oPrint:Say(li,  15,TPL->TPL_CODMOT,oFonTPN)
               oPrint:Say(li, 250,SubStr(NGSEEK("TPJ",TPL->TPL_CODMOT,1,'TPJ_DESMOT'),1,35),oFonTPN)
               oPrint:Say(li,1480,Dtoc(TPL->TPL_DTINIC),oFonTPN)
               oPrint:Say(li,1730,TPL->TPL_HOINIC,oFonTPN)
               oPrint:Say(li,1900,Dtoc(TPL->TPL_DTFIM) ,oFonTPN)
               oPrint:Say(li,2150,TPL->TPL_HOFIM ,oFonTPN)
               DbSelectArea("TPL")
               DbSkip()
           End
         Endif
      Endif


      MNTW675Somal(oPrint)
      MNTW675Somal(oPrint)
      oPrint:Line(li,10,li,2335)
      MNTW675Somal(oPrint)
      MNTW675Somal(oPrint)

      oPrint:Say(li,15 ,SubStr(STR0042,2,Len(STR0042)-2),oFonTPN)

      MNTW675Somal(oPrint)

      oPrint:Say(li,15 ,SubStr(STR0043,2,Len(STR0043)-2),oFonTPN)
 
      If mv_par20 == 2 //Lista banco do conhecimento = Sim 
         If STJ->TJ_PLANO == '000000'
            NgDocPrint("STJ",xFilial("STJ"),STJ->TJ_ORDEM,MV_PAR22)
         Else 
            If mv_par21 == 1  //Da Os
               NgDocPrint("STJ",xFilial("STJ"),STJ->TJ_ORDEM,MV_PAR22)
            ElseIf mv_par21 == 2 //Da Manutencao
               NgDocPrint("STF",xFilial("STF"),STJ->TJ_CODBEM+STJ->TJ_SERVICO+ (IIf(NgVerify("STJ"),STJ->TJ_SEQRELA,Str(STJ->TJ_SEQUENC,3))),MV_PAR22)
            Else  //Ambos
               NgDocPrint("STF",xFilial("STF"),STJ->TJ_CODBEM+STJ->TJ_SERVICO+ (IIf(NgVerify("STJ"),STJ->TJ_SEQRELA,Str(STJ->TJ_SEQUENC,3))),MV_PAR22)
               NgDocPrint("STJ",xFilial("STJ"),STJ->TJ_ORDEM,MV_PAR22)
            EndIf    
         EndIf
      EndIf
     
   EndIf

   DbSelectArea("TRB675")

   dbSkip()
   li := 4000

End

//Deleta o arquivo temporario fisicamente 
NGDELETRB("TRB675",cARQTR675)    

oPrint:EndPage()
RetIndex('STJ')
Set Filter To
DbSetOrder(01)  

If MV_PAR22 = 1 //Em Disco
	oPrint:Preview()
Else // Via Spool
	oPrint:Print()
Endif 

Return NIL

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MNTW675SomaL³ Autor ³ In cio Luiz Kolling   ³ Data ³28/05/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha,Cabecalho e Salto de Pagina                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MNTRW675GTRB( nDiffDias )
DbSelectArea("TRB675")
TRB675->(DbAppend())
TRB675->ORDEM   := STJ->TJ_ORDEM
TRB675->PLANO   := STJ->TJ_PLANO
TRB675->SERVICO := STJ->TJ_SERVICO
TRB675->CODBEM  := STJ->TJ_CODBEM
TRB675->CCUSTO  := STJ->TJ_CCUSTO
TRB675->DATAOS  := STJ->TJ_DTMPINI
If ValType(nDiffDias) == "N"
	TRB675->DIFFDT := nDiffDias
Endif
nPosBP := aSCAN(aBenseP,{|x| x[1] == TRB675->CODBEM})
If nPosBP = 0
	TRB675->BEMPAI := NGBEMPAI(TRB675->CODBEM)
	Aadd(aBenseP,{TRB675->CODBEM,TRB675->BEMPAI})
Else
	TRB675->BEMPAI := aBenseP[nPosBP,2]
Endif
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NGWIMPETAPA³ Autor ³ NG Informatica Ltda   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime a etapas                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function NGWIMPETAPA(cVOK,cVETAPA)
If Empty(cVOK)
	MNTW675Somal(oPrint)
	oPrint:Say(li,20,cVETAPA,oFonTPN)
	DbSelectArea("TPA")
	DbSetOrder(01)
	DbSeek(xFilial('TPA')+cVETAPA)
	U_NGMEMOEW675(TPA->TPA_DESCRI,200,75)
	If MV_PAR23 == 1
		U_MNT675OPE(oPrint,cVETAPA)
	EndIf
EndIf
Return .t.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NGMEMOEW675³ Autor ³In cio Luiz Kolling    ³ Data ³29/05/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime campo memo etapa                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function NGMEMOEW675(cDESCRI,nCOLU,nTAM)
Local linhacorrente
nLinhasMemo := MLCOUNT(cDESCRI,nTAM)
For LinhaCorrente := 1 To nLinhasMemo
	If !Empty((MemoLine(cDESCRI,nTAM,LinhaCorrente)))
		oPrint:Say(li,nCOLU,(MemoLine(cDESCRI,nTAM,LinhaCorrente)),oFonTPN)
		MNTW675Somal(oPrint)
	EndIf
Next LinhaCorrente
Return .t.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NGMEMORW675³ Autor ³In cio Luiz Kolling    ³ Data ³13/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime campo memo ( especifica p/ mntr675 )                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function NGMEMORW675(cTITULO,cDESCRI,nCOLU,nTAM,lSOMLI)
Local lPrimeiro := .T.
Local lSOMEILI  := lSOMLI,linhacorrente
nLinhasMemo := MLCOUNT(cDESCRI,nTAM)
For LinhaCorrente := 1 To nLinhasMemo
	If !Empty((MemoLine(cDESCRI,nTAM,LinhaCorrente)))
		If lSOMEILI
			MNTW675Somal(oPrint)
			lSOMEILI := .t.
		Else
			If Len(Alltrim(MemoLine(cDESCRI,nTAM,LinhaCorrente))) > 0
				MNTW675Somal(oPrint)
			Endif
		Endif
		If lPrimeiro
			If !Empty(cTITULO)
				oPrint:Say(li,15 ,cTITULO,oFonTPN)
			Endif
			lPrimeiro := .F.
		EndIf
		oPrint:Say(li,nCOLU,(MemoLine(cDESCRI,nTAM,LinhaCorrente)),oFonTPN)
	EndIf
Next
Return .t.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MNTW675SomaL³ Autor ³ In cio Luiz Kolling   ³ Data ³28/05/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha,Cabecalho e Salto de Pagina                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Static Function MNTW675Somal(oPrint)
Private cNomFil  := SM0->M0_FILIAL

li += 50
If li > 3400//3200
	lQuebra := .T.
	li := 100
	nPaG ++
	oPrint:EndPage()
	oPrint:StartPage()
	oPrint:Box(li,10,3300,2335)
	li += 20
	//
	If File(cLogo)
		oPrint:SayBitMap(li,40,cLogo,250,73)
	EndIf
	
	//
	oPrint:Say(li,380,STR0006+"  "+STJ->TJ_ORDEM,oFonTMN)
	
	oPrint:Say(li-10,1880,cNomFil,oFonTPN)
	oPrint:Say(li+45,2050,STR0076+" "+Str(nPag,2),oFonTPN)
	
	If !Empty(stj->tj_solici)
		Li += 90
		oPrint:Say(li,15,STR0056+"  "+STJ->TJ_SOLICI+Space(5)+STR0095+; //"Solicitante: "
		SubStr(UsrRetName(NGSEEK('TQB',STJ->TJ_SOLICI,1,'TQB->TQB_CDSOLI')),1,15))
		Li += 60
		oPrint:Say(li,15,STR0096+; //"Dt.Solic.: "
		DtoC(NGSEEK('TQB',STJ->TJ_SOLICI,1,'TQB->TQB_DTABER'))+;
		Space(4)+STR0097+; //"Hr.Solic.: "
		NGSEEK('TQB',STJ->TJ_SOLICI,1,'TQB->TQB_HOABER'),oFonTPN)
	Endif
	
	Li += 100
	oPrint:Say(li,15  ,"SIGA/BMNTR002",oFonTPN)
	
	oPrint:Say(li,360 ,STR0044+" "+Dtoc(STJ->TJ_DTMPINI+TRB675->DIFFDT)+" "+STJ->TJ_HOMPINI,oFonTPN)
	oPrint:Say(li,1100,STR0045+" "+Dtoc(STJ->TJ_DTMPFIM+TRB675->DIFFDT)+" "+STJ->TJ_HOMPFIM,oFonTPN)
	oPrint:Say(li,1690,STR0046+" "+Dtoc(Date())+" "+SubStr(Time(),1,5),oFonTPN)
	
	Li += 60
	oPrint:Say(li,15  ,SubStr(STR0047,2,Len(STR0047))+" "+STJ->TJ_PLANO,oFonTPN)
	
	If STJ->TJ_TIPOOS $ "B/M"
		oPrint:Say(li,1690,STR0048+" "+STJ->TJ_PRIORID,oFonTPN)
	EndIf
	
	Li += 50
	oPrint:Say(li,15,SubStr(STR0049,2,Len(STR0049))+" "+;
	NGSEEK('STI',STJ->TJ_PLANO,1,'SubStr(STI->TI_DESCRIC,1,39)'),oFonTPN)
	
	If NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_TEMCONT') <> "N"
		Li += 50
		oPrint:Say(li,15,"1º "+STR0021+AllTrim(Str(STJ->TJ_POSCONT)),oFonTPN)  //"Contador:"   
		If NGIFDBSEEK("TPE",STJ->TJ_CODBEM,1) 
			Li += 50
			oPrint:Say(li,15,"2º "+STR0021+AllTrim(Str(STJ->TJ_POSCON2)),oFonTPN) //"Contador:"    
		EndIf
	EndIf	
	
	Li += 100
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ R675Imp  ³ Autor ³ NG Informatica Ltda   ³ Data ³ 13.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Chamada do Relat¢rio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R675Imp(lEnd,wnRel,titulo,tamanho,cDEPLANO,cATEPLANO,aMATOS,nRecOS)
Local cRodaTxt   := ""
Local nCntImpr   := 0,xk,xz,ncontador, nPosOs
Local cSitOs     := If(MV_PAR25==1,'stj->tj_situaca == "L"',If(MV_PAR25==2,'stj->tj_situaca == "P"',;
					'stj->tj_situaca <> "C"'))
Local cCONDICAO  := cSitOs + ' .And. stj->tj_termino == "N" .And. ';
                   +'stj->tj_ccusto >= MV_PAR07 .And. stj->tj_ccusto <= MV_PAR08 .And. ';
                   +'stj->tj_centrab >= MV_PAR09 .And. stj->tj_centrab <= MV_PAR10 .And. ';
                   +'stj->tj_codarea >= MV_PAR11 .And. stj->tj_codarea <= MV_PAR12 .And.';
                   +'stj->tj_ordem >= MV_PAR13 .And. stj->tj_ordem <= MV_PAR14 .And. ';
                   +'stj->tj_dtmpini >= MV_PAR15 .And. stj->tj_dtmpini <= MV_PAR16'
Local aBenseP    := {}
Local lIdent := .F.
Local lPrimSTL := .T.
Private       li := 80 ,m_pag := 1
Private nomeprog := "BMNTR002"
Private ntipo    := IIF(aReturn[4]==1,15,18)
Private nINDSTQ  := 1 
Private aVETINR  := {}
Private cNomFil  := SM0->M0_FILIAL

Default nRecOs := 0
 
If aMatSX1 <> Nil
	NGMVPARSX1(cPerg,aMatSX1)
Endif

aDBFR675 := {{"ORDEM"   ,"C", 06,0},;
             {"PLANO"   ,"C", 06,0},;
             {"SERVICO" ,"C", 06,0},;
             {"CODBEM"  ,"C", 16,0},;
             {"CCUSTO"  ,"C", Len(STJ->TJ_CCUSTO),0},;
             {"DATAOS"  ,"D", 08,0},;
             {"DIFFDT"  ,"N", 08,0},;
             {"BEMPAI"  ,"C", 16,0}}

If MV_PAR17 = 1      //Ordem
	vIND675 := {"ORDEM"}
ElseIf MV_PAR17 = 2  //Servico/Bem
	vIND675 := {"SERVICO+CODBEM"}
ElseIf MV_PAR17 = 3  //Centro Custo
	vIND675 := {"CCUSTO"}
ElseIf MV_PAR17 = 4  //Data da O.S.
	vIND675 := {"Dtos(DATAOS)"}
Else                 // Servico/Bem Pai
	vIND675 := {"SERVICO+BEMPAI"}
EndIf 
                  
cARQTR675 := NGCRIATRB(aDBFR675,vIND675,"TRB675")

If FindFunction("NGSEQETA")
   nINDSTQ := NGSEQETA("STQ",nINDSTQ)
EndIf 

Store " " To Cabec1,Cabec2

If cDEPLANO == Nil .and. nRecOS == 0
	
	DbSelectArea("STI")
	DbSetOrder(01)
	DbSeek(xFilial("STI")+MV_PAR01)
	DbSelectArea("STJ")
	DbSetOrder(03)
	DbSeek(xFilial("STJ")+MV_PAR01,.T.)
	SetRegua(LastRec())
	While !Eof() .And. STJ->TJ_FILIAL == xFilial("STJ") .And.;
		STJ->TJ_PLANO >= MV_PAR01 .And. STJ->TJ_PLANO <= MV_PAR02 
		
		IncRegua()
		If &(cCONDICAO)
			DbSelectArea("TRB675")
			TRB675->(DbAppend())
			TRB675->ORDEM   := STJ->TJ_ORDEM
			TRB675->PLANO   := STJ->TJ_PLANO
			TRB675->SERVICO := STJ->TJ_SERVICO
			TRB675->CODBEM  := STJ->TJ_CODBEM
			TRB675->CCUSTO  := STJ->TJ_CCUSTO
			TRB675->DATAOS  := STJ->TJ_DTMPINI
			
			nPosBP := aSCAN(aBenseP,{|x| x[1] == TRB675->CODBEM})
			If nPosBP = 0
				TRB675->BEMPAI := NGBEMPAI(TRB675->CODBEM)
				Aadd(aBenseP,{TRB675->CODBEM,TRB675->BEMPAI})
			Else
				TRB675->BEMPAI := aBenseP[nPosBP,2]
			Endif
			
		EndIf
		DbSelectArea("STJ")
		DbSkip()
	End
Elseif cDEPLANO == Nil .and. nRecOS <> 0
	dbSelectArea("STJ")
	dbGoTo(nRecOS)
	DbSelectArea("TRB675")
	TRB675->(DbAppend())
	TRB675->ORDEM   := STJ->TJ_ORDEM
	TRB675->PLANO   := STJ->TJ_PLANO
	TRB675->SERVICO := STJ->TJ_SERVICO
	TRB675->CODBEM  := STJ->TJ_CODBEM
	TRB675->CCUSTO  := STJ->TJ_CCUSTO
	TRB675->DATAOS  := STJ->TJ_DTMPINI
	
	nPosBP := aSCAN(aBenseP,{|x| x[1] == TRB675->CODBEM})
	If nPosBP = 0
		TRB675->BEMPAI := NGBEMPAI(TRB675->CODBEM)
		Aadd(aBenseP,{TRB675->CODBEM,TRB675->BEMPAI})
	Else
		TRB675->BEMPAI := aBenseP[nPosBP,2]
	Endif 
Else
	
	cCONDICAO := '(stj->tj_situaca == "L" .Or. stj->tj_situaca == "P") .And. stj->tj_termino == "N" .And. ';
	+'stj->tj_ccusto >= MV_PAR07 .And. stj->tj_ccusto <= MV_PAR08 .And. ';
	+'stj->tj_centrab >= MV_PAR09 .And. stj->tj_centrab <= MV_PAR10 .And. ';
	+'stj->tj_codarea >= MV_PAR11 .And. stj->tj_codarea <= MV_PAR12 .And.';
	+'stj->tj_ordem >= MV_PAR13 .And. stj->tj_ordem <= MV_PAR14 .And. ';
	+'stj->tj_dtmpini >= MV_PAR15 .And. stj->tj_dtmpini <= MV_PAR16'
	
	DbSelectArea("STJ")
	DbSetOrder(03)
	DbSeek(xFilial("STJ")+cDEPLANO,.T.)
	SetRegua(LastRec())
	While !Eof() .And. STJ->TJ_FILIAL == xFilial("STJ") .And.;
		STJ->TJ_PLANO <= cATEPLANO
		
		IncRegua()
		If &(cCONDICAO)
			
			nPosOs := aSCAN(aMATOS, {|x| x[1]+x[2] == STJ->TJ_PLANO+STJ->TJ_ORDEM})
			If nPosOs > 0
				DbSelectArea("TRB675")
				TRB675->(DbAppend())
				TRB675->ORDEM   := STJ->TJ_ORDEM
				TRB675->PLANO   := STJ->TJ_PLANO
				TRB675->SERVICO := STJ->TJ_SERVICO
				TRB675->CODBEM  := STJ->TJ_CODBEM
				TRB675->CCUSTO  := STJ->TJ_CCUSTO
				TRB675->DATAOS  := STJ->TJ_DTMPINI
				If Len(aMATOS[nPosOs]) >= 3
					If ValType(aMATOS[nPosOs,3]) == "N" //Indica a quantidade de dias que as datas da OS serão deslocadas
						TRB675->DIFFDT := aMATOS[nPosOs,3]
					Endif
				Endif
				
				nPosBP := aSCAN(aBenseP,{|x| x[1] == TRB675->CODBEM})
				If nPosBP = 0
					TRB675->BEMPAI := NGBEMPAI(TRB675->CODBEM)
					Aadd(aBenseP,{TRB675->CODBEM,TRB675->BEMPAI})
				Else
					TRB675->BEMPAI := aBenseP[nPosBP,2]
				Endif
			EndIf
			
		EndIf
		DbSelectArea("STJ")
		DbSkip()
	End
	
EndIf  
DbSelectArea("TRB675")   
DbGotop()
SetRegua(LastRec())
While !Eof()
	
	IncRegua()
	DbSelectArea("STJ")
	DbSetOrder(01)
	If DbSeek(xFilial("STJ")+TRB675->ORDEM+TRB675->PLANO)
		DbSelectArea("STF")
		DbSetOrder(01)
		DbSeek(xFilial('STF')+STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA)
		
		U_SomaR765()
		@ Li,000 Psay STR0008 //"|------------------------------Bem/Localização---------------------------------|"
		U_SomaR765()
		
		cLoc := NGLocComp(STJ->TJ_CODBEM,'1')
      If cLoc <> AllTrim(STJ->TJ_CODBEM)
      	lIdent := .T.
      Else
      	lIdent := .F.
      EndIf	 
		If lIdent .And. MV_PAR24 == 1
			cLoc := STR0104+": "+cLoc //"Localização"
			While Len(cLoc) > 0
				@ LI,000 PSAY "|"+SubStr(cLoc,1,077)
				@ Li,079 Psay "|"
				cLoc := SubStr(cLoc,078)
				cLoc := If(!Empty(cLoc),Space(Len(STR0104+": ")),"")+cLoc //"Localização"
				U_SomaR765()
			EndDo
		EndIf
		@ Li,000 Psay "|Código...:" 
		@ Li,012 Psay STJ->TJ_CODBEM Picture "@!S(39)"		
		If STJ->TJ_TIPOOS $ "B/M"								
			@ Li,029 Psay NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_NOME') Picture "@!S(39)"
			@ Li,069 Psay STR0009 //"Prior.:"
			@ Li,076 Psay NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_PRIORID')
			@ Li,079 Psay "|"
			
			cPlaca := NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_PLACA')
			If !Empty(cPlaca)
     			// Linha da Placa
				U_SomaR765()
				@ Li,000 Psay "|Placa....:"
				@ Li,012 Psay cPlaca
				@ Li,079 Psay "|"
			Endif

			
			nAtual := ST9->(Recno())
			If !Empty(TRB675->BEMPAI)
				U_SomaR765()
				@ Li,000 Psay STR0010 //"|Pai......:"
				@ Li,012 Psay TRB675->BEMPAI
				@ Li,029 Psay NGSEEK('ST9',TRB675->BEMPAI,1,'ST9->T9_NOME') Picture "@!S(39)"
				@ Li,079 Psay "|"
			EndIf
			DbSelectArea("ST9")
			dbGoTo(nAtual)
		Else
			@ Li,029 Psay NGSEEK("TAF","X2"+Substr(STJ->TJ_CODBEM,1,3),7,"SUBSTR(TAF_NOMNIV,1,40)") Picture "@!S(39)"
			@ Li,069 Psay STR0009 //"Prior.:"
			@ Li,076 Psay NGSEEK('TQB',STJ->TJ_CODBEM,1,'TQB->TQB_PRIORI')
			@ Li,079 Psay "|"
		EndIf
		If !Empty(ST9->T9_LOCAL)
	      U_SomaR765()
      	@ Li,000 Psay STR0106 //"|Local....:"
      	@ Li,012 Psay ST9->T9_LOCAL
      	@ Li,079 Psay "|"
      EndIf
		DbSeek(xFilial('STF')+STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA)
		
		// Linha do Centro de Custo
		U_SomaR765()
		@ Li,000 Psay STR0011 //"|C.Custo..:"
		@ Li,012 Psay STJ->TJ_CCUSTO
		@ Li,033 Psay NGSEEK('SI3',STJ->TJ_CCUSTO,1,'SI3->I3_DESC')
		@ Li,079 Psay "|"
		
		// Linha do Centro de Trabalho
		U_SomaR765()
		@ Li,000 Psay STR0012 //"|C.Trab...:"
		@ Li,012 Psay STJ->TJ_CENTRAB
		@ Li,022 Psay NGSEEK('SHB',STJ->TJ_CENTRAB,1,'SHB->HB_NOME')
		@ Li,079 Psay "|"
		
		If STJ->TJ_TIPOOS $ "B/M"
			// Impressao da Linha de Detalhes
			If mv_par04 = 1
				lPrimeiro := .F.
				dbSelectArea("STB")
				dbSetOrder(01)
				dbSeek(xFilial('STB')+ST9->T9_CODBEM)
				While !Eof() .And. STB->TB_CODBEM = ST9->T9_CODBEM  .And.;
					STB->TB_FILIAL == xFilial('STB')
					
					U_SomaR765()
					@ Li,000 Psay "|"
					If !lPrimeiro
						@ Li,001 Psay STR0013 //"Detalhes.:"
					EndIf
					lPrimeiro = .T.
					@ Li,012 Psay NGSEEK('TPR',STB->TB_CARACTE,1,'TPR->TPR_NOME')//Substr(NGSEEK('TPR',STB->TB_CARACTE,1,'TPR->TPR_NOME'),1,25)
					@ Li,060 Psay STB->TB_DETALHE //043
					@ Li,076 Psay STB->TB_UNIDADE //061
					@ Li,079 Psay "|"
					dbSelectArea("STB")
					dbSkip()
				End
			EndIf
			
			// Impressao da Linha de Descricao
			If mv_par03 = 1
				U_NGMEMOR675(STR0014,ST9->T9_DESCRIC,12,56,.T.)
			EndIf
		EndIf
		
		U_SomaR765()
		@ Li,000 Psay STR0015 //"|---------------------------------Manutencao-----------------------------------|"
		
		// Linha do Servico
		U_SomaR765()
		@ Li,000 Psay STR0016 //"|Servico..:"
		@ Li,012 Psay STJ->TJ_SERVICO
		@ Li,020 Psay NGSEEK('ST4',STJ->TJ_SERVICO,1,'Substr(ST4->T4_NOME,1,35)')
		If STJ->TJ_TIPOOS $ "B/M"
			@ Li,057 Psay STR0017 //"Manut.Ant.:"
			@ Li,069 Psay STJ->TJ_DTULTMA Picture '99/99/9999'
		EndIf
		@ Li,079 Psay "|"
		
		U_SomaR765()
		@ Li,000 Psay STR0018 //"|Sequencia:"
		
		@ Li,012 Psay STJ->TJ_SEQRELA  Picture "@!"
		If STJ->TJ_TIPOOS $ "B/M"
			@ Li,20 Psay STR0019 //"Nome Manut..:"
		EndIf
		
		lPrinNom := .f.
		
		DbselectArea("ST4")
		If FieldPos("T4_TERCEIR") > 0
			DbSetOrder(01)
			If DbSeek(xFilial("ST4")+STF->TF_SERVICO)
				If ST4->T4_TERCEIR = "S"
					DbselectArea("STJ")
					If FieldPos("TJ_POSCPR1") > 0 .Or. FieldPos("TJ_POSCPR2") > 0
						If !Empty(STJ->TJ_POSCPR1)
							@ Li,032 Psay STR0057+" "+STR0058+" 1 "+STR0059
							@ Li,067 Psay STJ->TJ_POSCPR1 Picture "999999999999"
							lPrinNom := .t.
						ElseIf !Empty(STJ->TJ_POSCPR2)
							@ Li,032 Psay STR0057+" "+STR0058+" 2 "+STR0059
							@ Li,067 Psay STJ->TJ_POSCPR2 Picture "999999999999"
							lPrinNom := .t.
						Endif
					Endif
				Endif
			Endif
		Endif
		
		If !lPrinNom .And. STJ->TJ_TIPOOS $ "B/M"
			@ Li,034 Psay STF->TF_NOMEMAN
		EndIf
		If STJ->TJ_PLANO == "000000"
			@ Li,034 Psay " "+STR0115
		Endif
		@ Li,079 Psay "|"
		
		// Linha da Area de Manutencao
		U_SomaR765()
		@ Li,000 Psay STR0020 //"|Area.....:"
		@ Li,012 Psay STJ->TJ_CODAREA
		@ Li,020 Psay NGSEEK('STD',STJ->TJ_CODAREA,1,'STD->TD_NOME')
		
		If STJ->TJ_TIPOOS $ "B/M"
			If STF->TF_TIPACOM = "C" .OR. STF->TF_TIPACOM = "A" .OR. STF->TF_TIPACOM = "F"
				@ Li,061 Psay STR0021 //"Contador:"
				@ Li,071 Psay STF->TF_CONMANU Picture "@E 999999"
			EndIf
		EndIf
		@ Li,079 Psay "|"
		
		// Linha de Tipo de Manutencao
		U_SomaR765()
		@ Li,000 Psay STR0022 //"|Tipo.....:"
		@ Li,012 Psay STJ->TJ_TIPO
		@ Li,020 Psay NGSEEK('STE',STJ->TJ_TIPO,1,'STE->TE_NOME')
		@ Li,079 Psay "|"
		
		If !Empty(STF->TF_DOCTO)
			U_SomaR765()
			@ Li,000 Psay STR0065 //"|NºProced.:"
			@ Li,012 Psay STF->TF_DOCTO
			@ Li,079 Psay "|"
		EndIf
		
		If STJ->TJ_TIPOOS $ "B/M"
			// linha de informacao das paradas necessarias
			U_SomaR765()
			@ Li,000 Psay STR0023 //"|Parada...: Antes:"
			@ Li,019 Psay STF->TF_TEPAANT Picture "@E 999"
			@ Li,023 Psay STF->TF_UNPAANT
			@ Li,025 Psay STJ->TJ_DTPPINI
			@ Li,036 Psay STJ->TJ_HOPPINI
			@ Li,046 Psay STR0024 //"Depois:"
			@ Li,054 Psay STF->TF_TEPADEP Picture "@E 999"
			@ Li,058 Psay STF->TF_UNPADEP
			@ Li,060 Psay STJ->TJ_DTPPFIM
			@ Li,071 Psay STJ->TJ_HOPPFIM
			@ Li,079 Psay "|"
			
			// Linha da descricao da manutencao
			If mv_par05 == 1
				U_NGMEMOR675(STR0014,STF->TF_DESCRIC,12,56,.T.)
			EndIf
			
		EndIf
		
		aARTAREFAS := {}
		DbSelectArea("STL")
		DbSetOrder(03)
		DbSeek(XFILIAL('STL')+STJ->TJ_ORDEM+STJ->TJ_PLANO+"0  ")
		
		While !Eof() .And. Xfilial("STL") == STL->TL_FILIAL .And.;
			STJ->TJ_ORDEM == STL->TL_ORDEM .And. STJ->TJ_PLANO == STL->TL_PLANO;
			.AND. STL->TL_SEQRELA == "0  "
			
			nPOS := Ascan(aARTAREFAS,{|x| x[1] == stl->tl_tarefa})
			If nPOS = 0
				Aadd(aARTAREFAS,{stl->tl_tarefa,stl->tl_dtinici,stl->tl_hoinici,;
				stl->tl_dtfim,stl->tl_hofim})
			Else
				If stl->tl_dtinici < aARTAREFAS[nPOS][2]
					aARTAREFAS[nPOS][2] := stl->tl_dtinici
					aARTAREFAS[nPOS][3] := stl->tl_hoinici
				ElseIf stl->tl_dtinici == aARTAREFAS[nPOS][2] .And. stl->tl_hoinici < aARTAREFAS[nPOS][3]
					aARTAREFAS[nPOS][3] := stl->tl_hoinici
				EndIf
				
				If STL->TL_DTFIM > aARTAREFAS[nPOS][4]
					aARTAREFAS[nPOS][4] := stl->tl_dtfim
					aARTAREFAS[nPOS][5] := stl->tl_hofim
				ElseIf stl->tl_dtfim == aARTAREFAS[nPOS][4] .And. stl->tl_hofim > aARTAREFAS[nPOS][5]
					aARTAREFAS[nPOS][5] := stl->tl_hofim
				EndIf
			Endif
			DbSelectArea("STL")
			Dbskip()
		End
		
		aARETAPAS := {}
		DbSelectArea("STQ")
		DbSetOrder(01)
		DbSeek(XFILIAL('STQ')+STJ->TJ_ORDEM+STJ->TJ_PLANO)
		While !Eof() .And. Xfilial("STQ") = STQ->TQ_FILIAL .And.;
			STQ->TQ_ORDEM == STJ->TJ_ORDEM .And. STQ->TQ_PLANO == STJ->TJ_PLANO
			
			Aadd(aARETAPAS,{stq->tq_tarefa,stq->tq_etapa,stq->tq_seqeta})
			If Empty(aARTAREFAS)
				Aadd(aARTAREFAS,{STQ->TQ_TAREFA,STJ->TJ_DTMPINI,STJ->TJ_HOMPINI,;
				STJ->TJ_DTMPFIM,STJ->TJ_HOMPFIM })
			EndIf	
			DbSkip()
		End
		
		For xk := 1 To Len(aARTAREFAS)
			U_SomaR765()
			@ Li,000 Psay STR0025 //"|----------------------------------Tarefa--------------------------------------|"
			U_SomaR765()
			@ Li,000 Psay STR0026 //"|Codigo:"
			@ Li,009 Psay aARTAREFAS[xk][1]    Picture "@!"
			@ Li,017 Psay STR0027 //"Previsao Inicio..:"
			@ Li,035 Psay aARTAREFAS[xk][2]+TRB675->DIFFDT    Picture '99/99/9999'
			@ Li,047 Psay aARTAREFAS[xk][3]    Picture '99:99'
			@ Li,055 Psay STR0028  //"Fim..:"
			@ Li,061 Psay aARTAREFAS[xk][4]+TRB675->DIFFDT    Picture '99/99/9999'
			@ Li,073 Psay aARTAREFAS[xk][5]    Picture '99:99'
			@ Li,079 Psay "|"
			U_SomaR765()
			@ Li,000 Psay "|"
			@ Li,017 Psay STR0029 //"Real     Inicio..:"
			@ Li,055 Psay STR0028 //"Fim..:"
			@ Li,079 Psay "|"
			
			If Alltrim(aARTAREFAS[xk][1]) == "0"
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,002 Psay STR0030 //"Sem Especificacao De Tarefa"
				@ Li,079 Psay "|"
			Else
				U_SomaR765()
				@ Li,000 Psay "|"
				If !lUSATAR
					@ Li,002 Psay NGSEEK('ST5',STJ->TJ_CODBEM+STJ->TJ_SERVICO+;
					STJ->TJ_SEQRELA+aARTAREFAS[xk][1],1,'T5_DESCRIC') Picture "!@"
				Else
					lCORRET := If(Val(stj->tj_plano) = 0,.t.,.f.)
					@ Li,002 Psay NGNOMETAR(STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA,;
					aARTAREFAS[xk][1]) Picture "!@"
				Endif
				@ Li,079 Psay "|"
			EndIf
			
			If MV_PAR06 == 1      // mostra etapas da tarefa
				DbSelectArea("STQ")
				DbSetOrder(nINDSTQ)
				DbSeek(XFILIAL('STQ')+STJ->TJ_ORDEM+STJ->TJ_PLANO+aARTAREFAS[xk][1])
				If Found()
					U_SomaR765()
					@ Li,000 Psay STR0031 //"|   -------------------------------Etapas-----------------------------------   |"
				EndIf
				
				While !Eof() .And. Xfilial("STQ") = STQ->TQ_FILIAL .And.;
					STQ->TQ_ORDEM == STJ->TJ_ORDEM .And.;
					STQ->TQ_PLANO == STJ->TJ_PLANO .And.;
					STQ->TQ_TAREFA == aARTAREFAS[xk][1]
					
					U_NGIMPETAPA(stq->tq_ok,stq->tq_etapa)
					
					// Deletar as etapas da array aARETAPAS
					nPOS2 := Ascan(aARETAPAS,{|x| x[1] == stq->tq_tarefa .And. x[2] == stq->tq_etapa})
					If nPOS2 > 0
						Adel(aARETAPAS,nPOS2)
						Asize(aARETAPAS,Len(aARETAPAS)-1)
					Endif
					DbSelectArea("STQ")
					DbSkip()
				End
			EndIf
			
			DbSelectArea("STL")
			DbSetOrder(03)
			DbSeek(XFILIAL('STL')+STJ->TJ_ORDEM+STJ->TJ_PLANO+"0  "+aARTAREFAS[xk][1])
			While !Eof() .And. Xfilial("STL") = STL->TL_FILIAL .And.;
				STJ->TJ_ORDEM == STL->TL_ORDEM .And. STJ->TJ_PLANO == STL->TL_PLANO;
				.And. STL->TL_SEQRELA == "0  ";
				.And. STL->TL_TAREFA == aARTAREFAS[xk][1]
				If lPrimSTL
					U_SomaR765()
					@ Li,000 Psay "|"
					@ Li,079 Psay "|"
					U_SomaR765()
					@ Li,000 Psay STR0032 //"|   -------------------------------Insumos----------------------------------   |"
					U_SomaR765()
					@ Li,000 Psay STR0082+Space(10+nB1)+STR0094+Space(48-nB1)+"|" //"|Nome     Codigo"###"Descricao"
					U_SomaR765()
					@ Li,000 Psay STR0083 //"|                      Dt.Prev.  hora    Qtd  Consumo  Uni  Qtd  Consumo  Uni  |"
					lPrimSTL := .F.
				EndIf
				
				U_SomaR765()
				@ Li,000 Psay "|"
				aTIPNOM := NGNOMINSUM(stl->tl_tiporeg,stl->tl_codigo,30)
				If Len(aTIPNOM) > 0
					@ Li,001 Psay Substr(aTIPNOM[1][1],1,4)
				Endif
				
				@ Li,006 Psay stl->tl_codigo Picture '@!'
				If Len(aTIPNOM) > 0
					@ Li,022+(nB1) Psay aTIPNOM[1][2]
				Endif
				@ Li,079 Psay "|"
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,021 Psay STL->TL_DTINICI+TRB675->DIFFDT Picture '99/99/9999'
				@ Li,033 Psay STL->TL_HOINICI Picture '99:99'
				@ Li,039 Psay STL->TL_QUANREC Picture '999'
				
				vVETHORAS := NGTQUATINS(STL->TL_CODIGO,STL->TL_TIPOREG,STL->TL_USACALE,;
				STL->TL_QUANTID,STL->TL_TIPOHOR,STL->TL_DTINICI,;
				STL->TL_HOINICI,STL->TL_DTFIM,STL->TL_HOFIM,STL->TL_UNIDADE)
				nQTDHORAS := vVETHORAS[1]
				
				If STL->TL_TIPOREG <> "P"
					@ Li,043 Psay NGRHODSEXN(nQTDHORAS,"D") Picture '@E 999999.99'
				Else
					@ Li,043 Psay nQTDHORAS Picture '@E 999999.99'
				EndIf
				@ Li,054 Psay STL->TL_UNIDADE
				@ Li,079 Psay "|"
				If !Empty(STL->TL_OBSERVA)
					U_SomaR765()
					@ Li,000 Psay "|"
					@ Li,079 Psay "|"
					U_NGMEMOR675(Space(5)+STR0066,STL->TL_OBSERVA,21,55,.T.)
					U_SomaR765()
					@ Li,000 Psay "|"
					@ Li,079 Psay "|"
				Endif
				DbSelectArea("STL")
				DbSkip()
			End
			lPrimSTL := .T.
		Next xk
		
		// Imprime as etapas nao relacionadas com insumos
		If MV_PAR06 == 1      // mostra etapas da tarefa
			If Len(aARETAPAS) > 0
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,079 Psay "|"
				U_SomaR765()
				@ Li,000 Psay STR0050
				
				aARCLASS := Asort(aARETAPAS,,,{|x,y| x[1]+x[3]+x[2] < y[1]+y[3]+y[2]})
				
				cAUXTAR  := 'XXXXXX'
				For xz := 1 To Len(aARCLASS)
					If cAUXTAR <> aARCLASS[xz][1]
						U_SomaR765()
						@ Li,000 Psay "|"
						@ Li,001 Psay STR0051
						@ Li,008 Psay aARCLASS[xz][1]
						
						If !lUSATAR
							@ Li,015 Psay If(Alltrim(aARCLASS[xz][1]) == "0",STR0030,;
							NGSEEK('ST5',STJ->TJ_CODBEM+STJ->TJ_SERVICO+;
							STJ->TJ_SEQRELA+aARCLASS[xz][1],1,'ST5->T5_DESCRIC'))
						Else
							lCORRET := If(Val(stj->tj_plano) = 0,.t.,.f.)
							@ Li,015 Psay NGNOMETAR(STJ->TJ_CODBEM+STJ->TJ_SERVICO+STJ->TJ_SEQRELA,;
							aARCLASS[xz][1]) Picture "!@"
						Endif
						
						@ Li,079 Psay "|"
					Endif
					cAUXTAR := aARCLASS[xz][1]
					U_NGIMPETAPA("  ",aARCLASS[xz][2])
				Next xz
			Endif
		Endif
		// Impressao da Linha de Descricao da O.S
		If mv_par18 = 2
			U_SomaR765()
			@ Li,000 Psay "|"
			@ Li,079 Psay "|"
			U_SomaR765()
			@ Li,000 Psay "|------------------------------------------------------------------------------|"
			dbSelectArea("STJ")
			dbSetOrder(STJ->(INDEXORD()))
			cOBSERVA := If(FieldPos('TJ_MMSYP') > 0,NGMEMOSYP(STJ->TJ_MMSYP),If(FieldPos('TJ_OBSERVA')>0,STJ->TJ_OBSERVA," "))
			
			#IFDEF SPANISH
				U_NGMEMOR675(STR0052,cOBSERVA,24,55,.T.,"TJ_OBSERVA")  //"Descripcion de la O.S:"
			#ELSE
				U_NGMEMOR675(STR0052,cOBSERVA,19,58,.T.,"TJ_OBSERVA")  //"Descricao da O.S:"
			#ENDIF
			
		EndIf
		
		If mv_par19 = 2 .And. STJ->TJ_TIPOOS $ "B/M"
			dbselectarea("STJ")
			nINDESTJ := IndexOrd()
			nRECNSTJ := Recno()
			aAPESCAR := NGPEUTIL(stj->tj_codbem)
			DbselectArea("STJ")
			DbsetOrder(nINDESTJ)
			DbGoto(nRECNSTJ)
			If Len(aAPESCAR) > 0
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,079 Psay "|"
				
				U_SomaR765()
				@ Li,000 Psay STR0053 //"|-----------------------------Pecas de Reposicao-------------------------------|"
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,001 Psay STR0085+Space(10+nB1)+STR0094  //"Codigo"###"Descricao"
				@ Li,079 Psay "|"
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,034 Psay STR0098+Space(4)+STR0099+Space(4)+STR0100+Space(4)+STR0101  //"Dt.U.Uso"###"Contador"###"Proxima"###"Dt.Prox."
				@ Li,079 Psay "|"
				For xk := 1 To Len(aAPESCAR)
					U_SomaR765()
					@ Li,000 Psay "|"
					@ Li,001 Psay aAPESCAR[xk,1] Picture "@!"
					//@ Li,017 Psay Substr(NGSEEK("SB1",aAPESCAR[xk,1],1,"B1_DESC"),1,24)
					@ Li,017+(nB1) Psay Substr(NGSEEK("SB1",aAPESCAR[xk,1],1,"B1_DESC"),1,24)
					@ Li,079 Psay "|"
					U_SomaR765()
					@ Li,000 Psay "|"
					If !Empty(aAPESCAR[xk,2])
						@ Li,034 Psay aAPESCAR[xk,2] Picture "99/99/9999"
					Endif
					
					If !Empty(aAPESCAR[xk,4])
						@ Li,045 Psay aAPESCAR[xk,4] Picture "999999999"
					Endif
					
					If !Empty(aAPESCAR[xk,6])
						@ Li,056 Psay aAPESCAR[xk,6] Picture "999999999"
					Endif
					
					If !Empty(aAPESCAR[xk,8])
						@ Li,069 Psay aAPESCAR[xk,8] Picture "99/99/9999"
					Endif
					@ Li,079 Psay "|"
					
					If !Empty(aAPESCAR[xk,5]) .Or. !Empty(aAPESCAR[xk,7]) .Or.;
						!Empty(aAPESCAR[xk,9])
						U_SomaR765()
						@ Li,000 Psay "|"
						@ Li,025 Psay STR0055 //"Segundo Contador"
						If !Empty(aAPESCAR[xk,5])
							@ Li,045 Psay aAPESCAR[xk,5] Picture "999999999"
						Endif
						If !Empty(aAPESCAR[xk,7])
							@ Li,056 Psay aAPESCAR[xk,7] Picture "999999999"
						Endif
						If !Empty(aAPESCAR[xk,9])
							@ Li,069 Psay aAPESCAR[xk,9] Picture "99/99/99"
						Endif
						@ Li,079 Psay "|"
					Endif
				Next xk
			Endif
			
			Dbselectarea("STJ")
			DbSetOrder(nINDESTJ)
			Dbgoto(nRECNSTJ)
			
		Endif
		
		U_SomaR765()
		@ Li,000 Psay "|"
		@ Li,079 Psay "|"
		U_SomaR765()
		@ Li,000 Psay STR0040 //"|--------------------------------Ocorrencias-----------------------------------|"
		U_SomaR765()
		@ Li,000 Psay STR0084 //"| Tarefa   Ocorrencia            Causa                  Solucao                |"
		
		For nContador := 1 to 5
			U_SomaR765()
			@ Li,000 Psay "| ______   ___________________   ____________________   ___________________    |"
		Next
		
		If nTImpr = 3
			DbSelectArea("TPL")
			DbSetOrder(01)
			If DbSeek(XFILIAL('TPL')+STJ->TJ_ORDEM)
				cTitSX3 := 'sx3->x3_titulo'
				#IFDEF SPANISH
					cTitSX3 := 'sx3->x3_titspa'
				#ELSE
					#IFDEF ENGLISH
						cTitSX3 := 'sx3->x3_titeng'
					#ENDIF
				#ENDIF
				
				@ Li,000 Psay "|"
				@ Li,079 Psay "|"
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,079 Psay "|"
				
				U_SomaR765()
				@ Li,000 Psay STR0086 //"|------------------------------Motivo de atraso--------------------------------|"
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,002 Psay NGSEEKDIC("SX3","TPL_CODMOT",2,cTitSX3)
				@ Li,010 Psay NGSEEKDIC("SX3","TPL_DESMOT",2,cTitSX3)
				@ Li,051 Psay SubStr(NGSEEKDIC("SX3","TPL_DTINIC",2,cTitSX3),1,8)
				@ Li,060 Psay STR0087
				@ Li,066 Psay SubStr(NGSEEKDIC("SX3","TPL_DTFIM" ,2,cTitSX3),1,8)
				@ Li,076 Psay STR0087+"|"
				
				DbSelectArea("TPL")
				While !Eof() .And. Xfilial("TPL") = TPL->TPL_FILIAL .And.;
					TPL->TPL_ORDEM == STJ->TJ_ORDEM
					U_SomaR765()
					@ Li,000 Psay "|"
					@ Li,002 Psay TPL->TPL_CODMOT Picture "!@"
					@ Li,009 Psay SubStr(NGSEEK("TPJ",TPL->TPL_CODMOT,1,'TPJ_DESMOT'),1,35)
					@ Li,050 Psay TPL->TPL_DTINIC Picture "99/99/99"
					@ Li,059 Psay TPL->TPL_HOINIC Picture "99:99"
					@ Li,065 Psay TPL->TPL_DTFIM  Picture "99/99/99"
					@ Li,074 Psay TPL->TPL_HOFIM  Picture "99:99"
					@ Li,079 Psay "|"
					DbSelectArea("TPL")
					DbSkip()
				End
				U_SomaR765()
				@ Li,000 Psay "|"
				@ Li,079 Psay "|"
			Endif
		Endif
		U_SomaR765()
		@ Li,000 Psay "|------------------------------------------------------------------------------|"
		U_SomaR765()
		@ Li,000 Psay "|"
		@ Li,079 Psay "|"
		U_SomaR765()
		@ Li,000 Psay STR0042 //"|  Manutencao.: ____/____/____               Contador..: _____________ Fim.:   |"
		//U_SomaR765()
		@ Li,000 Psay "|"
		@ Li,079 Psay "|"
		U_SomaR765()
		@ Li,000 Psay STR0043 //"|  Data.......: ____/____/____               Assinatura: ______________________|"
		U_SomaR765()
		@ Li,000 Psay Replicate("-",80)
		
		If ExistBlock("MNTR6751")
			ExecBlock("MNTR6751",.F.,.F.)
		EndIf
		
		U_SomaR765()
		
		li := 80
	Endif
	
	If mv_par20 = 2
		If aReturn[5] = 2
			If STJ->TJ_PLANO = '000000'
				NgDocPrint("STJ",xFilial("STJ"),STJ->TJ_ORDEM)
			Else
				NgDocPrint("STF",xFilial("STF"),STJ->TJ_CODBEM+STJ->TJ_SERVICO+ (IIf(NgVerify("STJ"),STJ->TJ_SEQRELA,Str(STJ->TJ_SEQUENC,3))))
			EndIf
		EndIf
	EndIf
	dbSelectArea("TRB675")
	dbSkip()
End

//Deleta o arquivo temporario fisicamente 
NGDELETRB("TRB675",cARQTR675)    

RetIndex("STJ")
Set Filter To
Set device to Screen

DbSelectArea("STJ")
DbSetOrder(01)

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return NIL

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NGIMPETAPA³ Autor ³ NG Informatica Ltda   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime a etapas                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function NGIMPETAPA(cVOK,cVETAPA)
If Empty(cVOK)
	U_SomaR765()
	@ Li,000 Psay "|"
	@ Li,002 Psay cVETAPA
	DbSelectArea("TPA")
	DbSetOrder(01)
	DbSeek(xFilial('TPA')+cVETAPA)
	U_NGMEMOR675(' ',TPA->TPA_DESCRI,9,65,.F.)
	If MV_PAR23 == 1
		U_MNT675NOP(cVETAPA)
	EndIf
EndIf
Return .t.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³NGMEMOR675³ Autor ³In cio Luiz Kolling    ³ Data ³13/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Imprime campo memo ( especifica p/ mntr675 )                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function NGMEMOR675(cTITULO,cDESCRI,nCOLU,nTAM,lSOMLI,cCAMPO)
Local lPrimeiro := .T.
Local lSOMEILI  := lSOMLI,linhacorrente
Default cCAMPO := ""//Varáivel para saber qual campo está sendo impresso, utilizado para tratamento especial do TJ_OBSERVA
//Verifica se TJ_OBSERVA para tratamento especial em detrimento das O.S. MultiEmpresa
If Trim(Upper(cCAMPO)) == "TJ_OBSERVA" .AND. (nAt:= AT(CHR(13),cDESCRI)) > 0
	//Verifica se deve pular linha antes de imprimir
	If lSOMEILI
		U_SomaR765()
		@ Li,000 Psay "|"
	Endif
	If !Empty(cTITULO)
		@ Li,001 Psay cTITULO
	Endif
	lSOMEILI := .F.
	nIni:= 1
	//Verifica se ainda existem quebras
	While AT(CHR(13),SubStr(cDESCRI,nIni)) > 0
		While nIni < nAT
			//Verifica se existem 2 quebras seguidas
			If(AT(CHR(10),Substr(cDESCRI,nIni,1)) > 0,nIni += 1,)
			//Verifica o pedaco a ser impresso
			If (nAT-nIni) < nTAM
				cLine := Substr(cDESCRI,nIni,nAT-nIni)
			Else
				cLine := Substr(cDESCRI,nIni,nTAM)
			Endif
			//Pula Linha
			If lSOMEILI .and. !Empty(cLine)
				U_SomaR765()
				@ Li,000 Psay "|"
			Endif
			//Imprime da ultima quebra até a próxima e pula de linha
			If nAT > 0 .and. AllTrim(Substr(cDESCRI,nIni,(nAT-1)-nIni)) <> CHR(10)
				@ li,nCOLU Psay cLine
			Endif
			nIni += nTAM
			If !Empty(cLine)
				@ Li,079 Psay "|"
			Endif
			lSOMEILI := .t.
		End
		nIni:= nAt+1
		nAt:= nAt + AT(CHR(13),SubStr(cDESCRI,nIni))
	End
	If(AT(CHR(10),Substr(cDESCRI,nIni,1)) > 0,nIni += 1,)
	While nIni <= Len(cDESCRI)
		If !Empty(Substr(cDESCRI,nIni,nTAM))
			If lSOMEILI
				U_SomaR765()
				@ Li,000 Psay "|"
			Endif
			If Substr(cDESCRI,nIni) <> CHR(10)
				@ li,nCOLU Psay Substr(cDESCRI,nIni,nTAM)
			Endif
			@ Li,079 Psay "|"
		EndIf
		lSOMEILI := .t.
		nIni += nTAM
	End
Else
	nLinhasMemo := MLCOUNT(cDESCRI,nTAM)
	For LinhaCorrente := 1 To nLinhasMemo
		If !Empty((MemoLine(cDESCRI,nTAM,LinhaCorrente)))
			If lSOMEILI
				U_SomaR765()
				@ Li,000 Psay "|"
			Endif
			If lPrimeiro
				If !Empty(cTITULO)
					@ Li,001 Psay cTITULO
				Endif
				lPrimeiro := .F.
			EndIf
			@ Li,nCOLU Psay (MemoLine(cDESCRI,nTAM,LinhaCorrente))
			@ Li,079 Psay "|"
			lSOMEILI := .t.
		EndIf
	Next
Endif
Return .t.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³ U_SomaR765 ³ Autor ³ NG Informatica Ltda   ³ Data ³   /06/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³ Incrementa Linha e Controla Salto de Pagina                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function SomaR765()
Li++
If Li > 58
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,,,cLogo)
	
	@ Li  ,000 Psay "--------------------------------------------------------------------------------"
	Li += 1
	@ Li,000 Psay "|"
	@ Li,001 Psay cNomFil
	@ Li,038 Psay STR0006+":" //"Ordem De Servico De Manutencao"
	@ Li,073 Psay STJ->TJ_ORDEM
	@ Li,079 Psay "|"
	
	If !Empty(stj->tj_solici)
		Li += 1
		@ Li,000 Psay "|"
		@ Li,042 Psay STR0056 // "Solicitacao de Servico"
		@ Li,073 Psay STJ->TJ_SOLICI
		@ Li,079 Psay "|"
		Li += 1
		@ Li,000 Psay "|"
		@ Li,001 Psay STR0095 //"Solicitante: "
		@ Li,015 Psay SubStr(UsrRetName(NGSEEK('TQB',STJ->TJ_SOLICI,1,'TQB->TQB_CDSOLI')),1,15)
		@ Li,033 Psay STR0096 //"Dt.Solic.: "
		@ Li,045 Psay DtoC(NGSEEK('TQB',STJ->TJ_SOLICI,1,'TQB->TQB_DTABER'))
		@ Li,057 Psay STR0097 //"Hr.Solic.: "
		@ Li,068 Psay NGSEEK('TQB',STJ->TJ_SOLICI,1,'TQB->TQB_HOABER')
		@ Li,079 Psay "|"
	Endif
	
	Li += 1
	@ Li,000 Psay "|SIGA/BMNTR002"
	@ Li,014 Psay STR0044 //"Inicio:"
	@ Li,022 Psay STJ->TJ_DTMPINI+TRB675->DIFFDT Picture '99/99/9999'
	@ Li,034 Psay STJ->TJ_HOMPINI Picture '99:99'
	@ Li,040 Psay STR0045 //"Fim:"
	@ Li,045 Psay STJ->TJ_DTMPFIM+TRB675->DIFFDT Picture '99/99/9999'
	@ Li,056 Psay STJ->TJ_HOMPFIM Picture '99:99'
	@ Li,063 Psay "Emis.:"
	@ Li,069 Psay dDataBase
	@ Li,079 Psay "|"
	Li += 1
	@ Li,000 Psay STR0047 //"|Execucao: Inicio: ____/____/____ __:__ Plano:"
	@ Li,047 Psay STJ->TJ_PLANO
	If STJ->TJ_TIPOOS $ "B/M"
		@ Li,055 Psay STR0048 //"Prioridade Manut.:"
		@ Li,074 Psay STJ->TJ_PRIORID
	EndIf
	@ Li,079 Psay "|"
	Li += 1
	@ Li,000 Psay STR0049 //"|          Fim...: ____/____/____ __:__"
	@ Li,040 Psay  NGSEEK('STI',STJ->TJ_PLANO,1,'SubStr(STI->TI_DESCRIC,1,39)')
	@ Li,079 Psay "|"
	Li += 1
	@ Li,000 Psay "|"  
	If NGSEEK('ST9',STJ->TJ_CODBEM,1,'ST9->T9_TEMCONT') <> "N"
		@ Li,001 Psay "1º "+STR0021 //"Contador:"   
		@ Li,013 Psay STJ->TJ_POSCONT
		If NGIFDBSEEK("TPE",STJ->TJ_CODBEM,1)       
			@ Li,079 Psay "|"
			Li += 1      
			@ Li,000 Psay "|"  
			@ Li,001 Psay "2º "+STR0021 //"Contador:"
			@ Li,013 Psay STJ->TJ_POSCON2
		EndIf
	EndIf	
	@ Li,079 Psay "|"
	Li := Prow()+1
Endif

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MNT675OPE   ³ Autor ³ In cio Luiz Kolling   ³ Data ³02/12/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Impressao das opcoes da etapa grafica                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function MNT675OPE(oPrint,cVETAP)
If NGIFDBSEEK("TPC",cVETAP,1)
	MNTW675Somal(oPrint)
	oPrint:Say(li-55,900,NGSX2NOME("TPC"),oFonTMN)
	oPrint:Line(li,150,li,2000)
	oPrint:Say(li,150 ,NGRETTITULO("TPC_OPCAO") ,oFonTMN)
	oPrint:Say(li,700 ,NGRETTITULO("TPC_TIPRES"),oFonTMN)
	oPrint:Say(li,1100 ,NGRETTITULO("TPC_CONDOP"),oFonTMN)
	oPrint:Say(li,1550,NGRETTITULO("TPC_CONDIN"),oFonTMN)
	
	While !Eof() .And. TPC->TPC_FILIAL = Xfilial("TPC") .And. TPC->TPC_ETAPA = cVETAP
		MNTW675Somal(oPrint)
		oPrint:Say(li,150  ,TPC->TPC_OPCAO,oFonTPN)
		oPrint:Say(li,700 ,NGRETSX3BOX("TPC_TIPRES",TPC->TPC_TIPRES),oFonTPN)
		oPrint:Say(li,1100 ,NGRETSX3BOX("TPC_CONDOP",TPC->TPC_CONDOP),oFonTPN)
		oPrint:Say(li,1550,TPC->TPC_CONDIN,oFonTPN)
		DbsKip()
	End
	MNTW675Somal(oPrint)
Endif
Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o   ³MNT675NOP   ³ Autor ³ In cio Luiz Kolling   ³ Data ³02/12/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o³Impressao das opcoes da etapa normal                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MNTR675                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
User Function MNT675NOP(cVETAP)

Local cAuxTIPRES := "", cAuxCONDOP := "", cAuxCONDIN := ""

If NGIFDBSEEK("TPC",cVETAP,1)
	U_SomaR765()
	@ Li,000 Psay "|"
	@ Li,005 Psay "---------------------"+NGSX2NOME("TPC")+"--------------------"
	@ Li,079 Psay "|"
	U_SomaR765()
	@ Li,000 Psay "|"
	@ Li,005 Psay NGRETTITULO("TPC_OPCAO")
	@ Li,022 Psay NGRETTITULO("TPC_TIPRES")
	@ Li,040 Psay NGRETTITULO("TPC_CONDOP")
	@ Li,060 Psay NGRETTITULO("TPC_CONDIN")
	@ Li,079 Psay "|"
	
	While !Eof() .And. TPC->TPC_FILIAL = Xfilial("TPC") .And. TPC->TPC_ETAPA = cVETAP
		U_SomaR765()
		
		cAuxTIPRES := Alltrim(NGRETSX3BOX("TPC_TIPRES",TPC->TPC_TIPRES))
		If Empty(cAuxTIPRES)
			cAuxTIPRES := " "
		EndIf
		
		cAuxCONDOP := Alltrim(NGRETSX3BOX("TPC_CONDOP",AllTrim(TPC->TPC_CONDOP)))
		If Empty(cAuxCONDOP)
			cAuxCONDOP := " "
		EndIf
		
		cAuxCONDIN := Alltrim(TPC->TPC_CONDIN)
		If Empty(cAuxTIPRES)
			cAuxCONDIN := " "
		EndIf
		
		@ Li,000 Psay "|"
		@ Li,005 Psay TPC->TPC_OPCAO Picture "@!"
		@ Li,022 Psay cAuxTIPRES     Picture "@!"
		If !Empty(TPC->TPC_CONDOP)
			@ Li,040 Psay cAuxCONDOP  Picture "@!"
		Endif
		If !Empty(TPC->TPC_CONDIN)
			@ Li,060 Psay cAuxCONDIN  Picture "@!"
		Endif
		@ Li,079 Psay "|"
		DbsKip()
	End
	U_SomaR765()
	@ Li,000 Psay "|"
	@ Li,079 Psay "|"
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNT675SX1 ºAutor  ³Bruno Souza         º Data ³  12/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz criacao do SX1 do relatorio                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MNTR675                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MNT675SX1(cPerg)
Local aArea    := GetArea()
Local cGru675  := 'MNT675'+Space(Len(sx1->x1_grupo)-6)
Local ValPar01 := "If(empty(mv_par01),.t.,ExistCpo('STI',mv_par01))"

DbSelectArea("SX1")
DbSetOrder(1)

If dbSeek("MNT675"+Space(4)+"01") .And. (AllTrim(SX1->X1_VALID) <> ValPar01)
   RecLock("SX1",.f.)
   SX1->X1_VALID := ValPar01
   SX1->X1_CNT01   := ""
   SX1->(MsUnLock())
Endif


If dbSeek("MNT675"+Space(4)+"01") .And. (AllTrim(SX1->X1_PERGUNT) <> STR0113)
   RecLock("SX1",.f.)
   SX1->X1_PERGUNT := STR0113
   SX1->(MsUnLock())
   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"01.","Informe a partir de qual Plano de Manutenção deve constar no relatório. Pressione a tecla [F3]+[Enter] para selecionar um Plano de Manutenção ou deixe em branco para selecionar a partir do primeiro disponivel.",.T.)
Else   
   If SX1->X1_HELP <> "."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"01."
	  NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"01.","Informe a partir de qual Plano de Manutenção deve constar no relatório. Pressione a tecla [F3]+[Enter] para selecionar um Plano de Manutenção ou deixe em branco para selecionar a partir do primeiro disponivel.",.T.)
   EndIf	
Endif

If dbSeek("MNT675"+Space(4)+"02") .And. (AllTrim(SX1->X1_PERGUNT) <> STR0114)
	If NGSX1ORDEM("02",1,"MNT675")
		If !dbSeek("MNT675"+Space(4)+"02") 
		   RecLock("SX1",.T.)
		   SX1->X1_GRUPO   := "MNT675"
		   SX1->X1_ORDEM   := "02"
		   SX1->X1_PERGUNT := STR0114
		   SX1->X1_PERSPA  := STR0114
		   SX1->X1_PERENG  := STR0114
		   SX1->X1_VARIAVL := "MV_CH2"
		   SX1->X1_TIPO    := "C"
		   SX1->X1_TAMANHO := 06
		   SX1->X1_GSC     := "G"
		   SX1->X1_VALID   := "If(atecodigo('STI',mv_par01,mv_par02),.t.,.f.)"
		   SX1->X1_VAR01   := "mv_par02"
		   SX1->X1_CNT01   := "ZZZZZZ"
		   SX1->X1_F3      := "STI"
		   SX1->X1_PYME    := "N"
		   MsUnLock("SX1")
		   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"02.","Informe até qual Plano de Manutenção deve constar no relatório. Pressione a tecla [F3] para selecionar um Plano de Manutenção ou digite ZZZZZZ neste campo e o acima em branco para considerar todos os Planos de Manutenção.",.T.)
		Else   
			If SX1->X1_HELP <> "."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"02."
   				NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"02.","Informe até qual Plano de Manutenção deve constar no relatório. Pressione a tecla [F3] para selecionar um Plano de Manutenção ou digite ZZZZZZ neste campo e o acima em branco para considerar todos os Planos de Manutenção.",.T.)
   			EndIf
		EndIf
	EndIf
Endif

If dbSeek("MNT675"+Space(4)+"20") .And. Empty(SX1->X1_PERSPA)
   RecLock("SX1",.F.)
   dbDelete()
   MsUnlock("SX1")
EndIf  

If Dbseek("MNT675"+Space(4)+"05") .AND. ((Alltrim(SX1->X1_PERGUNT) <> STR0111) .OR. (Alltrim(SX1->X1_PERSPA) <> STR0111) .OR. (Alltrim(SX1->X1_PERENG) <> STR0111))
   RecLock("SX1",.F.)
   SX1->X1_PERGUNT := STR0111 //"Lista Descr. Manut. ?"  
   SX1->X1_PERSPA  := STR0111 //"Lista Descr. Manut. ?"
   SX1->X1_PERENG  := STR0111 //"Lista Descr. Manut. ?"
   SX1->(MsUnLock())
Endif  

aArea := GetArea()
lCons := .F.
dbSelectArea("SXB")
dbSetOrder(1)
If dbSeek("STJPLA")
	lCons := .T.
Endif
RestArea(aArea)
If Dbseek(cGru675+"13") .AND. SX1->X1_F3 <> "STJPLA" .and. lCons
   RecLock("SX1",.F.)
   SX1->X1_F3   := "STJPLA"
   SX1->(MsUnLock())
Endif
If Dbseek(cGru675+"14") .AND. SX1->X1_F3 <> "STJPLA" .and. lCons
   RecLock("SX1",.F.)
   SX1->X1_F3   := "STJPLA"
   SX1->(MsUnLock())
Endif
If Dbseek(cGru675+"17") .And. Alltrim(SX1->X1_DEF05) <> "Serviço/Bem Pai" .OR. Alltrim(SX1->X1_DEFSPA5) <> "Servicio/Bien Principal" .OR. Alltrim(SX1->X1_DEFENG5) <> "Parent Service/Asset"
   RecLock("SX1",.f.)
   SX1->X1_DEF05   := "Serviço/Bem Pai"
   SX1->X1_DEFSPA5 := "Servicio/Bien Principal"
   SX1->X1_DEFENG5 := "Parent Service/Asset"
   SX1->(MsUnLock())
Endif
If !Dbseek("MNT675"+Space(4)+"20")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := "MNT675"
   SX1->X1_ORDEM   := "20"
   SX1->X1_PERGUNT := "Lista Banco Conhecimento?"  
   SX1->X1_PERSPA  := "¿Lista Base Conocimiento?"
   SX1->X1_PERENG  := "List knowledge base?"
   SX1->X1_VARIAVL := "mv_chj"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Nao" 
   SX1->X1_DEFSPA1 := "No"  
   SX1->X1_DEFENG1 := "No"
   SX1->X1_DEF02   := "Sim"
   SX1->X1_DEFSPA2 := "Si"
   SX1->X1_DEFENG2 := "Yes"
   SX1->X1_VAR01   := "mv_par20"
   SX1->(MsUnLock())
Endif
If !Dbseek(cGru675+"21")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := "MNT675"
   SX1->X1_ORDEM   := "21"
   SX1->X1_PERGUNT := "Banco do Conhecimento ?"  
   SX1->X1_PERSPA  := "¿Base do Conocimiento?"
   SX1->X1_PERENG  := "Knowledge Bank?" 
   SX1->X1_VARIAVL := "mv_chl"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01
   SX1->X1_PRESEL  := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Da OS" 
   SX1->X1_DEFSPA1 := "De la OS"
   SX1->X1_DEFENG1 := "Of SO"
   SX1->X1_DEF02   := "Da Manutencao"
   SX1->X1_DEFSPA2 := "Del Mantenimiento"
   SX1->X1_DEFENG2 := "Of Maintenance"
   SX1->X1_DEF03   := "Ambos"
   SX1->X1_DEFSPA3 := "Ambos"
   SX1->X1_DEFENG3 := "Both"
   SX1->X1_VAR01   := "mv_par21" 
   SX1->(MsUnLock())
   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"21.","Se no campo acima foi escolhido 'Sim'"+chr(13)+chr(10)+"informe a origem do Banco do Conhecimento.",.T.)
Else
	If SX1->X1_HELP <> "."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"21."
	   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"21.","Se no campo acima foi escolhido 'Sim'"+chr(13)+chr(10)+"informe a origem do Banco do Conhecimento.",.T.)
	Endif
Endif 
If !Dbseek(cGru675+"22")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := "MNT675"
   SX1->X1_ORDEM   := "22"
   SX1->X1_PERGUNT := "Tipo de Impressao ?"  
   SX1->X1_PERSPA  := "¿Tipo de Impresion ?"  
   SX1->X1_PERENG  := "Printing Type ?"  
   SX1->X1_VARIAVL := "mv_chm"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01
   SX1->X1_PRESEL  := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Em Disco" 
   SX1->X1_DEFSPA1 := "En Disco" 
   SX1->X1_DEFENG1 := "To Disk" 
   SX1->X1_DEF02   := "Via Spool"
   SX1->X1_DEFSPA2 := "Via Spool"
   SX1->X1_DEFENG2 := "Via Spool" 
   SX1->X1_VAR01   := "mv_par22"
   SX1->(MsUnLock())
   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"22.","Informe o tipo de impressão:"+chr(13)+chr(10)+"- Em disco"+chr(13)+chr(10)+"- Via spool",.T.)
Else
	If SX1->X1_HELP <> "."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"22."
		NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"22.","Informe o tipo de impressão:"+chr(13)+chr(10)+"- Em disco"+chr(13)+chr(10)+"- Via spool",.T.)
	Endif
Endif
If !dbSeek(cGru675+"23")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cPerg
   SX1->X1_ORDEM   := "23"
   SX1->X1_PERGUNT := STR0102 //"Lista Opções da Etapa ?"
   SX1->X1_PERSPA  := STR0102 //"Lista Opções da Etapa ?"
   SX1->X1_PERENG  := STR0102 //"Lista Opções da Etapa ?"
   SX1->X1_VARIAVL := "MV_CHN"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01
   SX1->X1_PRESEL  := 1
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "NaoVazio()"
   SX1->X1_DEF01   := STR0063 //"Sim"
   SX1->X1_DEFSPA1 := STR0063 //"Sim"
   SX1->X1_DEFENG1 := STR0063 //"Sim"
   SX1->X1_DEF02   := STR0062 //"Não"
   SX1->X1_DEFSPA2 := STR0062 //"Não"
   SX1->X1_DEFENG2 := STR0062 //"Não"
   SX1->X1_VAR01   := "MV_PAR23"
   MsUnLock("SX1")
   
   NGHelp("."+cPerg+"23.",STR0103+Chr(13)+Chr(10)+"- "+STR0063+Chr(13)+Chr(10)+"- "+STR0062) //"Define se o relatório irá listar as opções das etapas:"###"Sim"###"Nao"
Else
	If SX1->X1_HELP <> "."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"23."
	   NGHelp("."+cPerg+"23.",STR0103+Chr(13)+Chr(10)+"- "+STR0063+Chr(13)+Chr(10)+"- "+STR0062) //"Define se o relatório irá listar as opções das etapas:"###"Sim"###"Nao"
	Endif
EndIf
If !dbSeek(cGru675+"24")
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cGru675
   SX1->X1_ORDEM   := "24"
   SX1->X1_PERGUNT := "Imprimir Localização ?"
   SX1->X1_PERSPA  := "Imprimir Localização ?"
   SX1->X1_PERENG  := "Imprimir Localização ?"
   SX1->X1_VARIAVL := "MV_CHO"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01 
   SX1->X1_PRESEL  := 0
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Sim"
   SX1->X1_DEFSPA1 := "Si"
   SX1->X1_DEFENG1 := "Yes"
   SX1->X1_DEF02   := "Nao"
   SX1->X1_DEFSPA2 := "No"
   SX1->X1_DEFENG2 := "No"
   SX1->X1_VAR01   := "MV_PAR24"
   SX1->X1_PYME    := "N"
   SX1->X1_HELP    := ".MNT67524."
   MsUnLock("SX1") 
   
   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"24.","Informe se deve imprimir a localização:"+chr(13)+chr(10)+"- Sim"+chr(10)+"- Não",.T.)
Else
	If SX1->X1_HELP <> "."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"24."
		NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"24.","Informe se deve imprimir a localização:"+chr(13)+chr(10)+"- Sim"+chr(10)+"- Não",.T.)
	Endif
EndIf
If dbSeek(cGru675+"23") .And. SX1->X1_PERGUNT <> STR0102 //"Lista Opções da Etapa ?"
   RecLock("SX1",.f.)
   Dbdelete()
   SX1->(MsUnLock())
Endif
If !dbSeek(cGru675+"25") .Or. SX1->X1_PERGUNT <> STR0116
   RecLock("SX1",.T.)
   SX1->X1_GRUPO   := cGru675
   SX1->X1_ORDEM   := "25"
   SX1->X1_PERGUNT := STR0116
   SX1->X1_PERSPA  := STR0116
   SX1->X1_PERENG  := STR0116
   SX1->X1_VARIAVL := "MV_CHP"
   SX1->X1_TIPO    := "N"
   SX1->X1_TAMANHO := 01 
   SX1->X1_PRESEL  := 3
   SX1->X1_GSC     := "C"
   SX1->X1_VALID   := "naovazio()"
   SX1->X1_DEF01   := "Liberada"
   SX1->X1_DEFSPA1 := "Liberada"
   SX1->X1_DEFENG1 := "Liberada"
   SX1->X1_DEF02   := "Pendente"
   SX1->X1_DEFSPA2 := "Pendente"
   SX1->X1_DEFENG2 := "Pendente"
   SX1->X1_DEF03   := "Todas"
   SX1->X1_DEFSPA3 := "Todas"
   SX1->X1_DEFENG3 := "Todas"
   SX1->X1_VAR01   := "MV_PAR25"
   SX1->X1_PYME    := "N"
   SX1->X1_HELP    := ".MNT67525."
   MsUnLock("SX1")
   NgHelp("."+cPerg+Space(Len(SX1->X1_GRUPO)-Len(cPerg))+"25.","Informe que tipo de O.S. deve ser impressa:"+chr(13)+chr(10)+"- Liberada"+chr(10)+"- Pendente"+chr(10)+"- Todas",.T.)  
EndIf

RestArea(aArea)

Return .T.
