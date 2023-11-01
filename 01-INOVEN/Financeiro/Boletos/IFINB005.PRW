#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SCR0001  º Autor ³ Eduardo Clemente   º Data ³  14/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GERACAO DE BOLETOS
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

User Function IFINB005()	//Geracao de boletos

Private oDlg, oBtnSair, oBtnOk
Private oSerie, oNota1, oNota2                                                                                                   
cSerie   := "2  "
cNota1   := Space(09)
cNota2   := Space(09)   
             
nOk1 := 1
DEFINE FONT oFntbt NAME "Arial" SIZE 7 ,-12 BOLD
DEFINE MSDIALOG oDlg FROM 86,32 TO 300,450 TITLE "Parametros Geração/Impressão do Boleto" PIXEL OF oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

@ 013,015 SAY "Serie    : "   SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 013,70 MSGET oSerie      VAR cSerie  SIZE 20,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL

@ 033,015 SAY "Nota De  : " SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 033,70 MSGET oNota1      VAR cNota1  SIZE 20,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL

@ 053,015 SAY "Nota Até : " SIZE 60,10 OF oDlg  FONT oFntbt COLOR CLR_BLACK PIXEL
@ 053,070 MSGET oNota2    VAR cNota2   SIZE 20,10 OF oDlg FONT oFntbt COLOR CLR_BLACK PIXEL

@ 085,015 BUTTON "&Ok"   SIZE 40,14 PIXEL ACTION {|| nOk1 := 1,oDlg:End() }
@ 085,060 BUTTON "&Sair" SIZE 40,14 PIXEL ACTION {|| nOk1 := 2,oDlg:End() }

Activate MsDialog oDlg Center  	                    

If nOk1 == 2              
   Return()

Else
   //Processar quem nao tem banco informado no cadastro de cliente
   cBcodia := Getmv("MV_BCODIA")
   
   If cBcodia == "001"
      u_IFINB030(cNota1,cNota2,cSerie,.T.)
   ElseIf cBcodia == "341"
      u_IFINB010(cNota1,cNota2,cSerie,.T.)
   ElseIf cBcodia == "033"
      u_IFINB050(cNota1,cNota2,cSerie,.T.)
   ElseIf cBcodia == "237"
      u_IFINB020(cNota1,cNota2,cSerie,.T.)
   ElseIf cBcodia == "422"
      u_IFINB040(cNota1,cNota2,cSerie,.T.)
   Endif


   //Processar quem tem banco informado no cadastro de cliente
   If Select("TRBA1") > 0
      TRBA1->(DbCloseArea())
   EndIf
   cQuery := "SELECT A1_BCO1,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
   cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
   cQuery += " INNER JOIN "+RetSqlName("SF2")+" F2 ON F2_FILIAL = '" +xFilial("SF2")+ "' AND F2_DUPL = E1_NUM AND F2_PREFIXO = E1_PREFIXO AND F2_CLIENTE = E1_CLIENTE AND F2_LOJA = E1_LOJA " + CRLF
   cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_FILIAL = ' ' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA " + CRLF
   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF
   cQuery += "	 AND E1_PREFIXO     = '"+cSerie+"' AND E1_NUM BETWEEN '"+cNota1+"' AND '"+cNota2+"' " + CRLF
   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
   cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' " + CRLF
   cQuery += "	 AND F2_FIMP <> 'D' AND A1_BCO1 <> ' ' " + CRLF
   cQuery += "UNION ALL " + CRLF
   cQuery += "SELECT A1_BCO1,E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC " + CRLF
   cQuery += "FROM "+RetSqlName("SE1")+" SE1 " + CRLF 
   cQuery += "INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_FILIAL = ' ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA " + CRLF
   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF 
   cQuery += "	 AND E1_PREFIXO     = '"+cSerie+"' AND E1_NUM BETWEEN '"+cNota1+"' AND '"+cNota2+"' " + CRLF
   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') AND A1_BCO1 <> ' ' " + CRLF 
   cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' '  " + CRLF 
   cQuery += "   AND E1_NUM + E1_PREFIXO + E1_CLIENTE + E1_LOJA NOT IN (SELECT F2_DUPL + F2_PREFIXO + F2_CLIENTE + F2_LOJA " + CRLF
   cQuery += "   FROM "+RetSqlName("SF2")+" F2 " + CRLF 
   cQuery += "   WHERE F2_FILIAL = '" +xFilial("SF2")+ "' AND F2_DUPL = E1_NUM AND F2_PREFIXO = E1_PREFIXO " + CRLF 
   cQuery += "   AND F2_CLIENTE = E1_CLIENTE AND F2_LOJA = E1_LOJA " + CRLF
   cQuery += "   AND F2.D_E_L_E_T_ = ' ' AND F2_FIMP <> 'D' ) " + CRLF
   cQuery += "ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA"
   TcQuery cQuery New Alias "TRBA1"

   TRBA1->(dbGoTop())
   Do While !TRBA1->(Eof())
      If TRBA1->A1_BCO1 == "001"             
      u_IFINB030(TRBA1->E1_NUM,TRBA1->E1_NUM,TRBA1->E1_PREFIXO, .F.)
      ElseIf TRBA1->A1_BCO1 == "033"
      u_IFINB050(TRBA1->E1_NUM,TRBA1->E1_NUM,TRBA1->E1_PREFIXO, .F.)     
      ElseIf TRBA1->A1_BCO1 == "341"
      u_IFINB010(TRBA1->E1_NUM,TRBA1->E1_NUM,TRBA1->E1_PREFIXO, .F.)
      ElseIf TRBA1->A1_BCO1 == "237"
      u_IFINB020(TRBA1->E1_NUM,TRBA1->E1_NUM,TRBA1->E1_PREFIXO, .F.)
      ElseIf TRBA1->A1_BCO1 == "422"
      u_IFINB040(TRBA1->E1_NUM,TRBA1->E1_NUM,TRBA1->E1_PREFIXO, .F.)
      Endif 
      TRBA1->(dbSkip())
   Enddo


Endif
                 
Return()  
