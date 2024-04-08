#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT100TOK ³ Autor ³ Elias Reis            ³ Data ³ 30/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE que faz a verificacao final do documento                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MT100TOK()
Local aAreaAtu := GetArea()
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSF1 := SF1->(GetArea())
Local lRet    := .T.  
Private nCont := 1     
Private cParam := getmv("MV_PRXLOTE")

If Inclui .And.;
	AllTrim(FunName()) == "FINA050" .And.;
	M->E2_TIPO == "TX " .And.;
	Empty(M->E2_CODRET)
	
	Aviso(;
	OemToAnsi("Codigo Retencao"),;
	OemToAnsi("Informe o Codigo de Retenção Título!"),;
	{"Ok"},1,OemToAnsi("Codigo de Retenção");
	)
	
	lRet    := .F.
	
EndIf

/////validação para evitar erros no SPED FISCAL///////

If ACOLS[1][10] $ ('087')
	CESPECIE := 'NFS'
EndIf


While nCont <= len(aCols)
	
	Private cProduto :=  (aCols[nCont][2]) 
	Private cTipo := (aCols[nCont][78])  
	cParam := getmv("MV_PRXLOTE")
	//Private nX := 1
	
	DbSelectArea("SB1")
	DbSetOrder(1)

	If MsSeek(xFilial("SB1")+cProduto)
		If substr(cTipo,1,1) == "N" .and. Alltrim(SB1->B1_TIPO) $ '1*2*3*' .AND.  SB1->B1_RASTRO == 'L' // incluido por Charles para criar Lote Brascola   
			
			If nCont == 1
				Lote()
			Else
			
				For _x := 1 to nCont 
				//while nX  <= len(aCols) .and. Empty((aCols[nCont][38]))	
				
					If (aCols[nCont][2]) == (aCols[_x][2]) .And. (aCols[nCont][8]) == (aCols[_x][8])
						
						If (aCols[nCont][1]) == (aCols[_x][1])
							
							Lote()   
							
					    Else
						
							(aCols[nCont][38]) := (aCols[_x][38])
						    _x := nCont + 1 
						
						Endif
						
					Endif
					 
				Next _x 
					//_x := (_x + 1)
    				//dbSkip()		
				 //Enddo
				 
				If Empty(aCols[nCont][8])
					Lote()
				Endif
			
			Endif
			
		Endif	 
	EndIf
	
	lRet    := .T.
    nCont := (nCont + 1)
    dbSkip()
EndDo

RestArea(aAreaAtu)
RestArea(aAreaSD1)
RestArea(aAreaSF1)

Return(lRet)

// Gera novo lote Interno para item de entrada//
/////////////////////////////////////////////////

Static Function Lote()

cLote := ""
_cFilial:=xfilial("SD1")

cMes := strzero(MONTH(DDATABASE),2)
cAno := substr(alltrim(str(YEAR(DDATABASE))),3,2)

Do Case
	Case cMes = '01'
		cMes = 'A'
	Case cMes = '02'
		cMes = 'B'
	Case cMes = '03'
		cMes = 'C'
	Case cMes = '04'
		cMes = 'D'
	Case cMes = '05'
		cMes = 'E'
	Case cMes = '06
		cMes = 'F'
	Case cMes = '07'
		cMes = 'G'
	Case cMes = '08'
		cMes = 'H'
	Case cMes = '09'
		cMes = 'I'
	Case cMes = '10'
		cMes = 'J'
	Case cMes = '11'
		cMes = 'L'
	Case cMes = '12'
		cMes = 'M'
EndCase
cLote := 'N'+cAno+cMes+cParam

(aCols[nCont][38]) := cLote


dbselectarea("SX6")
dbsetorder(1)
dbseek(_cFilial+"MV_PRXLOTE")
if reclock("SX6",.F.)
	replace X6_CONTEUD with strzero(val(cParam)+1,4)
	msunlock()
EndIf
Return()
