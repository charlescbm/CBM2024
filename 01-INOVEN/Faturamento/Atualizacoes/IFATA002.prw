#INCLUDE "Protheus.ch"    
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TLGA005  ºAutor  ³Microsiga           º Data ³  11/30/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFATA002()
	Local oWndRes	:= Nil 
	Local oSay1 	:= NIl
	Local nOpc		:= 0
	Local bTOKWnd 	:= {|| nOpc:= 1, oWndRes:End() }	
	Local bEndWnd 	:= {|| oWndRes:End() }	
	Local aWndSiz 	:= Array( 0 )
	Local aPosObj 	:= Array( 0 )
	Local nValor	:= 0
	Local nDifSize  := 0	
	Local oFont37N	:= TFont():New( "MS Sans Serif",0,-16,,.T.,0,,700,.F.,.F.,,,,,, )
	Local cCadastro	:= "INFORMAR N. DIAS A PRORROGAR "
	Local cDescri := "Prorrogar Dt. Saida NF"
	
	U_ITECX010("IFATA002","Prorrogar DATA SAIDA NF.")//Grava detalhes da rotina usada
	
	aSize 	:= MsAdvSize()
	aWndSiz := MsAdvSize(.F.)
	
	nDifSize := 0
	If ( aSize[ 5 ] - 80 ) > 600
		nDifSize := aSize[ 5 ] - 80 - 600
	EndIf
	
	aWndSiz[ 3 ] -= 40 + nDifSize / 2	
	aWndSiz[ 4 ] -= 40
	
	aWndSiz[ 5 ]:= aWndSiz[ 5 ] / 4
	aWndSiz[ 6 ] / 4
	
	aPosObj := MsObjGetPos(aWndSiz[3]-aWndSiz[1],315,{{000,000,007,160,010,010,060,145,020,012,045,020,132,300}})

	DEFINE MSDIALOG oWndRes TITLE cCadastro FROM aWndSiz[7],0 TO aPosObj[1,13],aPosObj[1,14] OF oMainWnd PIXEL STYLE nOR(WS_VISIBLE,WS_POPUP)
							
		// DEFINE TITULO DA TELA
		@ aPosObj[1,1],aPosObj[1,2] SAY oSay1 PROMPT cCadastro SIZE aPosObj[1,4],aPosObj[1,3] OF oWndRes COLORS 16777215, 5126199 HTML PIXEL
	    
		TGroup():New(aPosObj[1,5],aPosObj[1,6],aPosObj[1,7],aPosObj[1,8],,oWndRes,CLR_BLACK,CLR_WHITE,.T.,.F. )	
			
		TSay():New( aPosObj[1,9],aPosObj[1,10],{|| 'N.Dias '},,,oFont37N,.F.,.F.,.F.,.T.,CLR_GREEN,CLR_WHITE,400,025,,,,,,.T.)
				
		TGet():New( aPosObj[1,9],aPosObj[1,10]+55,{|u| If(PCount()>0,nValor:=u,nValor)},,050,008 ,"@E 99",,CLR_BLACK,CLR_WHITE,oFont37N,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nValor",,)  
		
		TButton():New(aPosObj[1,11],aPosObj[1,12],"OK",,bTOKWnd,050,010,,,.T.,.T.,,,,,,)
		TButton():New(aPosObj[1,11],aPosObj[1,12]+60,"SAIR",,bEndWnd,050,010,,,.T.,.T.,,,,,,)
                                                                               
	ACTIVATE MSDIALOG oWndRes CENTER ON INIT ( oWndRes:lEscClose := .F. )

	If nOpc == 1
		PutMv('TG_NDIASAI',nValor)
	EndIf

Return( Nil )
