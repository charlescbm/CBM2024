#Include "Protheus.ch"
#Include "topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SHBD004  º Autor ³ Eduardo Clemente   º Data ³  27/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gera agrupamento de titulos                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//DESENVOLVIDO POR INOVEN

User Function IFINX010()

Private oDlg, oBtnSair, oBtnOk
Private oBanco, oAgencia, oConta, oNome    
cBanco   := Space(03)
cAgencia := Space(05)
cConta   := Space(12)   
cDesatu  := Space(30)
cBante   := Getmv("MV_BCODIA")
             
nOk1 := 1
DEFINE FONT oFntbt NAME "Arial" SIZE 7 ,-12 BOLD
DEFINE MSDIALOG oDlg FROM 86,32 TO 300,450 TITLE "- Selecionar Banco do Dia - Boletos -" PIXEL OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS
@ 013,015 SAY "Banco Anterior : " SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 013,70 MSGET oBanco    VAR cBante When .F. SIZE 20,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL
dbSelectArea("SA6")
dbSeek(xFilial("SA6")+cBante)
cDescri := SA6->A6_NOME
@ 013,110 MSGET oNome     VAR cDescri When .F. SIZE 100,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL


@ 035,015 SAY "Banco Atual: " SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 035,070 MSGET oBanco    VAR cBanco   SIZE 20,10 OF oDlg FONT oFntbt COLOR CLR_BLACK F3 "SA6" PIXEL

@ 050,015 SAY "Agencia    : " SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 050,070 MSGET oAgencia    VAR cAgencia   SIZE 30,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL

@ 065,015 SAY "C/Corrente : " SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 065,070 MSGET oConta     VAR cConta   SIZE 50,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL

@ 085,015 BUTTON "&Ok"   SIZE 40,14 PIXEL ACTION {|| nOk1 := 1,oDlg:End() }
@ 085,060 BUTTON "&Sair" SIZE 40,14 PIXEL ACTION {|| nOk1 := 2,oDlg:End() }

Activate MsDialog oDlg Center  	                    

If nOk1 == 2              
   Return()
Endif   

dbSelectArea("SX6")
PutMv("MV_BCODIA",cBanco)    // Atualiza parametro da sequencia do bordero
PutMv("MV_AGEDIA",cAgencia)    // Atualiza parametro da sequencia do bordero
PutMv("MV_CONDIA",cConta)    // Atualiza parametro da sequencia do bordero

Return()
