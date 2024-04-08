
#Include "rwmake.ch"
#Include "topconn.CH"        

User Function etbnf(cNumNFAux)    
**********************    

SetPrvt("CPERG,CCOMBO,AITENS,VQETIQ,VCODIGO,VNFISCAL")
SetPrvt("VLOTE,VDESC,VFORNEC,VLOTEFOR,VQUANT,VDTAREC")
SetPrvt("VCONF,VDTAVAL,VSAIR,_CPORTA,_SALIAS,AREGS")
SetPrvt("I,J,qQetiq,nQtdeEmb,nQtdeNF,vFornec,vLoja,cNumNFd ,cNumNFa,cSerie,cTranspa,cTranspd")
 
cMonta  := "1"
aItens1 := {"1","2","3","4","5"}
cTipo   := Space(01)
Aviso   := Space(50)
vDesc   := Space(30)
vCodigo := Space(30)
Descli  := Space(30)
cNumNF  := Space(09)
cNumNFd := Space(09)
cNumNFa := Space(09)
cTranspa:=Space(06)
cTranspd:= Space(06)
cBarra  := Space(08)
cBarra2 := Space(08)
vSair   := .f.
VQetiq  := 001
qQetiq  := 0
VQuant  := 0
vQtpc   := 0
nQtdeEmb:= 0
nQtdeNF := 0
vFornec := Space(06)
vLoja   := Space(02)

private cNumNFd := Space(09)
private cNumNFa := Space(09) 
private cTranspa := space(06)
private cTranspd := space(06)
private cSerie  := Space(03)
private VQetiq  := 001   
private  nOrdem
Private nTotReg	:= 0  
     

If Alltrim(Funname()) == "TRANSFTELA" 
	//10/01/13: Fernando	
	//If len(cNumNFAux) == 9 
		//cNumNFd := SUBSTR(cNumNFAux,4,7)
		//cNumNFa := SUBSTR(cNumNFAux,4,7)
	//Else
		cNumNFd := SUBSTR(cNumNFAux,4,9) 
		cNumNFa := SUBSTR(cNumNFAux,4,9)
	//EndIf
	cSerie := SUBSTR(cNumNFAux,1,3)  
	cTranspd := ''
	cTranspa := 'ZZZZZZZZZ'
	
	Impetiq()
	
	Return

Else
		
	While vSair==.f.
	   @ 003,001 To 380,280 Dialog oDlg1 Title "ETIQUETA  NF"
	   @ 005,003 To 030,120
	   @ 014,005 Say "Quantidade:"                                                                     
	  
	   @ 014,040 Get VQetiq                   Size 015,20 Picture "999"  
	  // @ 014,100 Say "Porta:"
	  // @ 014,120 ComboBox cCombo Items aItens Size 030,50   
	   
	   @ 040,005 Say "Nt.Fiscal de :"
	   @ 040,040 Get  cNumNFd                    Size 020,20 Picture "@R XXXXXXXXX"   Valid Verif_Nota(cNumNFd)
	   @ 055,005 Say "Nt.Fiscal ate:"
	   @ 055,040 Get  cNumNFa                     SIZE 20,20 Pict "@!"            Valid Verif_Nota(cNumNFa)
	   
	   @ 075,005 Say "Serie:"
	   @ 075,040 Get cSerie                      Size 020,20 Picture "@R XXX"   //Valid Verif_Nota(cNumNF) 
	   
	   
	   @ 100,005 Say "Trasportadora de :"
	   @ 100,060 Get  cTranspd                     Size 020,20 Picture "@R XXXXXX"  F3("SA4")
	   @ 120,005 Say "Trasportadora ate:"
	   @ 120,060 Get  cTranspa                     SIZE 20,20 Pict "@!"            F3("SA4")
	   
	   
	   @ 150,005 Button "_Imprimir"              Size 025,15 Action Impetiq()
	   @ 150,080 Button "_Sair"                  Size 025,15 Action Sair()
	   Activate Dialog oDlg1 Centered
	EndDo
	
Return

	

Endif


Static Function Impetiq()
**********************


aDados 		:= {}
nVolume 	:= 0
aDadosTmp	:= {}
cQuery 		:= ""
nQtde		:= 0 

//cCodigo:= AllTrim(SB1->B1_COD)
cLote  := " "

cQuery := " SELECT F2_FILIAL, A1_NOME, F2_DOC, F2_SERIE, F2_VOLUME1, F2_ESPECI1, A1_END, " + Chr(13)
cQuery += " A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, D2_COD, B1_DESC, " + Chr(13)
cQuery += " B1_QTDEMB, SUM(D2_QUANT) D2_QUANT ,F2_TRANSP" + Chr(13)
cQuery += " FROM "+RetSQLName("SF2") + " SF2, " + RetSQLName("SD2") + " SD2, " + Chr(13)
cQuery += RetSQLName("SA1") + " SA1, " + RetSQLName("SB1") + " SB1 " + Chr(13)
cQuery += " WHERE  " + Chr(13)
cQuery += "     F2_FILIAL = '" + xFilial("SF2") + "'" + Chr(13)
cQuery += " AND F2_DOC >= '" +cNumNFd+"'" + Chr(13)
cQuery += " AND F2_DOC <= '" +cNumNFa+"'" + Chr(13)
cQuery += " AND F2_SERIE = '" +cSerie+"'" + Chr(13)
cQuery += " AND F2_TRANSP >= '" +cTranspd+"'" + Chr(13)
cQuery += " AND F2_TRANSP <= '" +cTranspa+"'" + Chr(13)
cQuery += " AND F2_TIPO = 'N' " + Chr(13)
cQuery += " AND SF2.D_E_L_E_T_ = '' " + Chr(13)
cQuery += " AND A1_COD = F2_CLIENTE " + Chr(13)
cQuery += " AND A1_LOJA = F2_LOJA " + Chr(13)

//Campo que verifica se o cliente dispensa impressao de etiquetas
cQuery  += " AND A1_GERAETQ <> '2' " + Chr(13)

cQuery += " AND SA1.D_E_L_E_T_ = '' " + Chr(13)
cQuery += " AND D2_FILIAL = F2_FILIAL " + Chr(13)
cQuery += " AND D2_DOC = F2_DOC " + Chr(13)
cQuery += " AND D2_SERIE = F2_SERIE " + Chr(13)
cQuery += " AND SD2.D_E_L_E_T_ = '' " + Chr(13)
cQuery += " AND B1_COD = D2_COD " + Chr(13)
cQuery += " AND SB1.D_E_L_E_T_ = '' " + Chr(13)
/*
//Filtra os pedidos de amostra
cQuery += " AND (	SELECT COUNT(*) " + Chr(13)
cQuery += " 		FROM " + RetSQLName("SC5") + " SC5, " + RetSQLName("SC6") + " SC6 " + Chr(13)
cQuery += " 		WHERE " + Chr(13)
cQuery += "         C6_NOTA = F2_DOC " + Chr(13)
cQuery += "         AND C6_FILIAL = F2_FILIAL " + Chr(13)
cQuery += "     	AND C5_FILIAL = C6_FILIAL " + Chr(13)
cQuery += "			AND C5_NUM = C6_NUM " + Chr(13)
cQuery += "			AND C5_AMOSTRA IN ('1','S') " + Chr(13)
cQuery += "			AND SC5.D_E_L_E_T_ = '' " + Chr(13)
cQuery += "			AND SC6.D_E_L_E_T_ = '' ) = 0 " + Chr(13)
*/
cQuery += " GROUP BY  F2_FILIAL, F2_SERIE, A1_NOME, F2_DOC, F2_VOLUME1, F2_ESPECI1, " + Chr(13)
cQuery += " A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, D2_COD, B1_DESC, B1_QTDEMB ,F2_TRANSP" + Chr(13)
cQuery += " ORDER BY F2_FILIAL,F2_TRANSP,F2_VOLUME1,F2_DOC, F2_SERIE, D2_COD " + Chr(13)

If Select("TRB")>0
	TRB->(dbCloseArea())
EndIf

//MemoWrite("\QUERYSYS\ETQBRAS.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
TRB->( dbEval({||nTotReg++},,{||!Eof()}))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//SetRegua(nTotReg)

dbSelectArea("TRB")
dbGoTop()
While !EOF()
   
	cChave := TRB->(F2_FILIAL+F2_DOC+F2_SERIE)
	
	//Verifica se desconsidera as notas fiscais com mais de 200 volumes
	If TRB->F2_VOLUME1 > 500
		If !MsgBox(	"Nota Fiscal : "+RTRIM(TRB->F2_DOC)+Chr(13)+Chr(10)+;
						" Deseja Imprimir? ",;
						"Quantidade Alta de Etiquetas: " + Str(TRB->F2_VOLUME1,4),;
						"YESNO",2)
			While !Eof() .And. cChave==TRB->(F2_FILIAL+F2_DOC+F2_SERIE)
				dbskip()
				Loop
			EndDo
		Endif
	EndIf
	    
	
	//Remove os espacos duplos e caracteres especiais do endereco

	cA1NOME  	:= TRB->A1_NOME
	cF2DOC		:= TRB->F2_DOC
	cF2ESPECI1	:= TRB->F2_ESPECI1
	cA1END 		:= TRB->A1_END
	cA1MUN 		:= TRB->A1_MUN
	cA1EST		:= TRB->A1_EST
	cA1CEP		:= TRB->A1_CEP
	cA1BAIRRO	:= TRB->A1_BAIRRO

	While	AT("  ",cA1NOME) 		> 0 .Or.;
			AT("  ",cF2DOC) 		> 0 .Or.;
			AT("  ",cF2ESPECI1) 	> 0 .Or.;
			AT("  ",cA1END)  		> 0 .Or.;
			AT("  ",cA1MUN)	  	    > 0 .Or.;
			AT("  ",cA1EST) 		> 0 .Or.;
			AT("  ",cA1CEP) 		> 0 .Or.;
			AT("  ",cA1BAIRRO) 	> 0
						
			cA1NOME  	:= StrTran(cA1NOME,		"  "," ")
			cF2DOC		:= StrTran(cF2DOC,		"  "," ")
			cF2ESPECI1	:= StrTran(cF2ESPECI1,	"  "," ")
			cA1END 		:= StrTran(cA1END,		"  "," ")
			cA1MUN 		:= StrTran(cA1MUN,		"  "," ")
			cA1EST		:= StrTran(cA1EST,		"  "," ")
			cA1CEP		:= StrTran(cA1CEP,		"  "," ")
			cA1BAIRRO	:= StrTran(cA1BAIRRO,	"  "," ")
	EndDo 

	cA1NOME 	:= u_DelChResp(AllTrim(cA1NOME))
	cF2DOC 		:= u_DelChResp(AllTrim(cF2DOC))
	cF2ESPECI1 	:= u_DelChResp(AllTrim(cF2ESPECI1))		
	cA1END 		:= u_DelChResp(AllTrim(cA1END))
	cA1MUN 		:= u_DelChResp(AllTrim(cA1MUN))
	cA1EST 		:= u_DelChResp(AllTrim(cA1EST))
	cA1CEP 		:= u_DelChResp(AllTrim(cA1CEP))
	cA1BAIRRO 	:= u_DelChResp(AllTrim(cA1BAIRRO))				
	
	//Insere os dados de produto e descricao em um array temporario na quantidade de volumes do item
	dbSelectArea("TRB")
	While !Eof() .And. cChave == TRB->(F2_FILIAL+F2_DOC+TRB->F2_SERIE)//ALTERADO FERNANDO: 17/02/12  - cChave := TRB->(F2_FILIAL+F2_DOC+F2_SERIE)
			nQtde := Int(TRB->D2_QUANT / IIF(TRB->B1_QTDEMB==0,1,TRB->B1_QTDEMB))
			If (TRB->D2_QUANT % IIF(TRB->B1_QTDEMB==0,1,TRB->B1_QTDEMB)) > 0
				nQtde ++
			EndIf
			nVolume += nQtde
			For nLoop := 1 To nQtde 
				aAdd(aDadosTmp,{AllTrim(TRB->D2_COD) +"/"+SubS(AllTrim(TRB->B1_DESC),1,20)})
			Next
		dbSkip()
	EndDo
	
	//Aqui, insere os dados em um outro array, que nao e temporario para gravar os valores do volume
	For nLoop := 1 To Len(aDadosTmp)
		
		aAdd(aDados,{	AllTrim(cA1NOME),;
							"Nota Fiscal :" + cF2DOC,;
							"Nr Embalagem: "+ Alltrim(str(nLoop))+" / "+Alltrim(Str(Len(aDadosTmp))),;
							"Especie: "					+ AllTrim(cF2ESPECI1),;
							AllTrim(cA1END),;
							AllTrim(cA1MUN)			+ "   -   " + AllTrim(cA1EST),;
							AllTrim(cA1CEP)		+ "   -   " + AllTrim(cA1BAIRRO),;
							aDadosTmp[nLoop][1]})
	Next		
		
	nVolume 		:= 0
	aDadosTmp 	:= {}
		
EndDo


/*For nLoop := 1 to ( 3 - Len(aDados) % 3)
	aAdd(aDados,{"","","","","","","","","",""})
Next nLoop    */

Impetnf(aDados)

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³Impetq    º Autor ³ AP6 IDE            º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
   

Static Function Impetnf(aDados)

nLin := 0

cTipoBar := 'MB07' //128
  
//MSCBPRINTER("S500-6" ,"LPT1",Nil,040,.f.,,,,)     //VERFICAR MODELO DA iMPRESSORA
cPorta    := "LPT1"
//MSCBPRINTER("S500-8",cPorta,,,.f.,,,,) 

//MSCBPrinter( [ cModelPrt ] [ cPorta ] [ nDensidade ] [ nTamanho ] [ lSrv ] [ nPorta ] [ cServer ] [ cEnv ] [ nMemoria ] [ cFila ] [ lDrvWin ] [ cPathSpool ] )
 MSCBPRINTER(     "S500-6" ,   "LPT1" ,       Nil    ,     040    ,   .F.  ,          ,           ,        ,            ,         ,     .T.    ,               )   
 //alterado o Parametro lDrvWin, onde este indica que vai ser utilizado o Driver da impressora instalada no windows.
/*
Zebra: S400, S600, S500-6, Z105S-6, Z16S-6, S300, S500-8,
 
Z105S-8, Z160S-8, Z140XI, Z90XI e Z170ZI.

*/
MSCBCHKStatus(.F.)    
      
For nLoop := 1 To Len(aDados)
	
	MSCBBEGIN(1,4)
	
	NLIN := 6
	MSCBSAY(06,NLIN,substr(aDados[nLoop + 0][1],1,35),"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,aDados[nLoop + 0][2],"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,aDados[nLoop + 0][3],"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,aDados[nLoop + 0][4],"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,aDados[nLoop + 0][5],"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,aDados[nLoop + 0][6],"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,aDados[nLoop + 0][7],"N","C","18,18")
	NLIN:=NLIN+5
	MSCBSAY(06,NLIN,substr(aDados[nLoop + 0][8],1,33),"N","C","18,18")
	
	MSCBEND()
	
Next(nLoop) 

MSCBCLOSEPRINTER()
Return 	    


DbSelectArea("SA2")
DbSetOrder(1)
MsSeek(xfilial()+SD1->D1_FORNECE+SD1->D1_LOJA)


cTipoBar := 'MB07' //128

//MSCBPrinter( [ cModelPrt ] [ cPorta ] [ nDensidade ] [ nTamanho ] [ lSrv ] [ nPorta ] [ cServer ] [ cEnv ] [ nMemoria ] [ cFila ] [ lDrvWin ] [ cPathSpool ] )
  MSCBPRINTER(     "S500-6" ,  _cPorta ,       Nil    ,     040    ,   .F.  ,          ,           ,        ,            ,         ,           ,               )   


//MSCBCHKStatus(.f.)    
VQetiq:=int(nQtdeNF/nQtdeEmb)


       
MSCBBEGIN(VQetiq,4) 
MSCBBOX(7.5,5.5,97.5,69.5,3)

MSCBLineH(7.5,31.5,97.5,3) //1Linhas HORIZONTAIS
MSCBLineH(7.5,42.5,97.5,3) //2
MSCBLineH(05,55,97.5,3) //3


//MSCBLineV(59,03,94,3) //Linhas Horizontais   

MSCBSAY(08,05,'VOSS AUTOMOTIVE',"R","0","023,023")
MSCBSAY(10,10,'PART:',"R","B","010,010")
MSCBSAY(22,14,ALLTRIM(SB1->B1_COD),"R","0","025,026")
MSCBSAY(22,19,ALLTRIM(SUBSTR(SB1->B1_DESC,1,30)),"R","0","09,010")
MSCBSAYBAR(22,26,cCodigo ,"R","MB07",08,.F.,.F.,.F.,,2,1)
MSCBSAY(10,29.5,'Supplier:'  ,"R","B","010,010")
MSCBSAY(28,29.5,SA2->A2_COD+'/'+SA2->A2_LOJA+' - '+SA2->A2_NREDUZ,"R","0","09,09")
MSCBSAY(10,35,'Qty',"R","B","010,010")
MSCBSAYBAR(22,40,AllTrim(Str(nQtdeEmb)),"R","MB07",06,.F.,.F.,.F.,,2,1)
MSCBSAY(40,52,Transform(nQtdeEmb,"@E 999,999.99")+SB1->B1_UM,"R","0","024,024")
MSCBSAY(10,46,'Lot:',"R","B","010,010")
MSCBSAY(22,46,RTRIM(SD1->D1_DOC)+'/'+SD1->D1_SERIE,"R","0","09,09")
MSCBSAYBAR(22,54,RTRIM(SD1->D1_DOC)+SD1->D1_SERIE,"R","MB07",08,.F.,.F.,.F.,,2,2)
MSCBSAY(76,22,'DATE:',"R","B","010,010")
MSCBSAY(85,55,DTOC(DDATABASE),"R","0","09,09")
MSCBSAY(10,59,'ID:',"R","B","010,010")

MSCBSAY(22,59,ALLTRIM(SD1->D1_DOC+SD1->D1_SERIE+SA2->A2_COD+SA2->A2_LOJA),"R","0","030,020")
MSCBSAYBAR(22,65,RTRIM(SD1->D1_DOC)+SD1->D1_SERIE+SA2->A2_COD+SA2->A2_LOJA ,"R","MB07",08,.F.,.F.,.F.,,2,2)
//MSCBSAY(16,69,"Lote","R","B","010,010")
//MSCBSAY(08,71,cLote ,"R","0","040,040")
MSCBEND()
MSCBCLOSEPRINTER()


Return 	    
   

Static Function Sair()
********************
Close(oDlg1)                                                                   
vSair := .t.

Return


Static Function Verif_Prod(vCodigo)
*******************************
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial()+vCodigo)
If !Found()
   	MsgAlert('Cod.Produto nao encontrado!!','Atenção!')
	Return .f.
EndIf

DbSelectArea("SD1")
DbSetOrder(2)
DbSeek(xFilial()+SB1->B1_COD+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
If !Found()
   	MsgAlert('Produto nao encontrado na Nota Fiscal informada!!','Atenção!')
	Return .f.
EndIf 

nQtdeItNF:= 0

While !Eof() .And. xFilial("SD1")+SB1->B1_COD+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
	nQtdeItNF+= SD1->D1_QUANT
	DbSkip()
EndDo

DbSkip(-1)

VDesc   := SB1->B1_DESC
nQtdeEmb:= IIf(Empty(SB1->B1_QE), SD1->D1_QUANT, SB1->B1_QE)
nQtdeNF := nQtdeItNF //SD1->D1_QUANT

Return .T.
      

Static Function Verif_Nota(cNotaF)
******************************
DbSelectArea("SF2")
DbSetOrder(1)
DbSeek(xFilial()+cNotaF)

If !Found()
   	MsgAlert('Nota fiscal nao encontrada!!','Atenção!')
	Return .T.
EndIf

Return .T.