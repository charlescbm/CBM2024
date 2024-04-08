#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณETQBRAS   บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEtiquetas Brascola                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ETQBRAS()

// Declara็ใo de variaveis	

Private cString        := "SF2"
Private aStru          := {}
Private aOrd           := {}
Private CbTxt          := ""
Private cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2         := "de acordo com os parametros informados pelo usuario."
Private cDesc3         := "ETIQUETA BRASCOLA"
Private cPict          := ""
Private lEnd           := .F.
Private lAbortPrint    := .F.
Private limite         := 132
Private tamanho        := "M"
Private nomeprog       := "ETQBRAS"
Private nTipo          := 15
Private aReturn        := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey       := 0
Private cPerg          := U_CriaPerg("ETQ1")
Private titulo         := "Etiqueta Brascola"
Private nLin           := 80
Private Cabec1         := ""
Private Cabec2         := ""
Private cbtxt          := Space(10)
Private cbcont         := 00
Private CONTFL         := 01
Private m_pag          := 01
Private imprime        := .T.
Private wnrel          := "ETQBRAS"

// Carrega / Cria parametros
aRegs    := {}
aAdd(aRegs,{cPerg,"01","Num. Nota        ?"," "," ","mv_ch1","C", 09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{cPerg,"02","Ate o Num. Nota  ?"," "," ","mv_ch2","C", 09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{cPerg,"03","Serie da Nota    ?"," "," ","mv_ch3","C", 03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})	
	
dbSelectArea("SX1")
For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif 
Next

Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,/*aOrd*/,.F.,Tamanho,,.F.)

SetDefault(aReturn,cString)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aDados 		:= {}
Local nVolume 		:= 0
Local aDadosTmp	:= {}
Local cQuery 		:= ""
Local nTotReg		:= 0
Local nQtde			:= 0 

cQuery := " SELECT F2_FILIAL, A1_NOME, F2_DOC, F2_SERIE, F2_VOLUME1, F2_ESPECI1, A1_END, " + Chr(13)
cQuery += " A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, D2_COD, B1_DESC, " + Chr(13)
cQuery += " B1_QTDEMB, SUM(D2_QUANT) D2_QUANT " + Chr(13)
cQuery += " FROM "+RetSQLName("SF2") + " SF2, " + RetSQLName("SD2") + " SD2, " + Chr(13)
cQuery += RetSQLName("SA1") + " SA1, " + RetSQLName("SB1") + " SB1 " + Chr(13)
cQuery += " WHERE  " + Chr(13)
cQuery += "     F2_FILIAL = '" + xFilial() + "'" + Chr(13)
cQuery += " AND F2_DOC >= '" + mv_par01+"'" + Chr(13)
cQuery += " AND F2_DOC <= '" + mv_par02+"'" + Chr(13)
cQuery += " AND F2_SERIE = '" + mv_par03+"'" + Chr(13)
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

//Filtra os pedidos de amostra
/*cQuery += " AND (	SELECT COUNT(*) " + Chr(13)
cQuery += " 		FROM " + RetSQLName("SC5") + " SC5, " + RetSQLName("SC6") + " SC6 " + Chr(13)
cQuery += " 		WHERE " + Chr(13)
cQuery += "          C6_NOTA = F2_DOC " + Chr(13) 
cQuery += " AND         C6_SERIE = F2_SERIE " + Chr(13)   
cQuery += "     	AND C5_FILIAL = C6_FILIAL " + Chr(13) 
cQuery += "     	AND F2_FILIAL = C6_FILIAL " + Chr(13)
cQuery += "			AND C5_NUM = C6_NUM " + Chr(13)
//cQuery += "			AND C5_AMOSTRA IN ('1','S') " + Chr(13)
cQuery += "			AND SC5.D_E_L_E_T_ = '' " + Chr(13)
cQuery += "			AND SC6.D_E_L_E_T_ = '' ) = 0 " + Chr(13)*/

cQuery += " GROUP BY  F2_FILIAL, F2_SERIE, A1_NOME, F2_DOC, F2_VOLUME1, F2_ESPECI1, " + Chr(13)
cQuery += " A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, D2_COD, B1_DESC, B1_QTDEMB " + Chr(13)
cQuery += " ORDER BY F2_FILIAL, F2_DOC, F2_SERIE, D2_COD " + Chr(13)

If Select("TRB")>0
	TRB->(dbCloseArea())
EndIf

//MemoWrite("\QUERYSYS\ETQBRAS.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
TRB->( dbEval({||nTotReg++},,{||!Eof()}))
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ SETREGUA -> Indica quantos registros serao processados para a regua ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SetRegua(nTotReg)

dbSelectArea("TRB")
dbGoTop()
While !EOF()
   
	cChave := TRB->(F2_FILIAL+F2_DOC+F2_SERIE)
   
	//Verifica se desconsidera as notas fiscais com mais de 200 volumes
	If TRB->F2_VOLUME1 > 200
		If !MsgBox(	"Nota Fiscal : "+TRB->F2_DOC+Chr(13)+Chr(10)+;
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
			AT("  ",cA1MUN)	  	> 0 .Or.;
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

	While !Eof() .And. cChave == TRB->(F2_FILIAL+F2_DOC+TRB->F2_SERIE)
			nQtde := Int(TRB->D2_QUANT / IIF(TRB->B1_QTDEMB==0,1,TRB->B1_QTDEMB))
			If (TRB->D2_QUANT % IIF(TRB->B1_QTDEMB==0,1,TRB->B1_QTDEMB)) > 0
				nQtde ++
			EndIf
			nVolume += nQtde
			For nLoop := 1 To nQtde 
				aAdd(aDadosTmp,{AllTrim(TRB->D2_COD) + "/ " + SubS(AllTrim(TRB->B1_DESC),1,23)})
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


For nLoop := 1 to ( 3 - Len(aDados) % 3)
	aAdd(aDados,{"","","","","","","","",})
Next nLoop 

Imprime(aDados)

Return  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณImpetq    บ Autor ณ AP6 IDE            บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Imprime(aDados)

nLin := 0

For nLoop := 1 To Len(aDados) Step 3 

	@  nLin,000 Psay aDados[nLoop + 0][1]
	@  nLin,041 Psay aDados[nLoop + 1][1]
	@  nLin,081 Psay aDados[nLoop + 2][1]

	nLin++                           
	
	@  nLin,000 Psay aDados[nLoop + 0][2]
	@  nLin,041 Psay aDados[nLoop + 1][2]
	@  nLin,081 Psay aDados[nLoop + 2][2]

	nLin++
	
	@  nLin,000 Psay aDados[nLoop + 0][3]
	@  nLin,041 Psay aDados[nLoop + 1][3]
	@  nLin,081 Psay aDados[nLoop + 2][3]

	nLin++
	
	@  nLin,000 Psay aDados[nLoop + 0][4]
	@  nLin,041 Psay aDados[nLoop + 1][4]
	@  nLin,081 Psay aDados[nLoop + 2][4]

	nLin++
	
	@  nLin,000 Psay aDados[nLoop + 0][5]
	@  nLin,041 Psay aDados[nLoop + 1][5]
	@  nLin,081 Psay aDados[nLoop + 2][5]

	nLin++
	
	@  nLin,000 Psay aDados[nLoop + 0][6]
	@  nLin,041 Psay aDados[nLoop + 1][6]
	@  nLin,081 Psay aDados[nLoop + 2][6]

	nLin++
	
	@  nLin,000 Psay aDados[nLoop + 0][7]
	@  nLin,041 Psay aDados[nLoop + 1][7]
	@  nLin,081 Psay aDados[nLoop + 2][7]

	nLin++				
	
	@  nLin,000 Psay aDados[nLoop + 0][8]
	@  nLin,041 Psay aDados[nLoop + 1][8]
	@  nLin,081 Psay aDados[nLoop + 2][8]

	nLin++				
	nLin++	

Next

Return