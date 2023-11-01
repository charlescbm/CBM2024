#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³Andreza Favero      º Data ³  11/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada nas linhas da nf de entrada para checar a  º±±
±±º          ³necessidade de digitacao do centro de custo.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico 			                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ 05.01.07 - Elias Reis - Verifica se o usuario consta no    º±±
±±º          ³            parametro BR_000014, para permitir digitacao    º±±
±±º          ³            de  documentos que geram financeiro sem um      º±±
±±º          ³            pedido de compras                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//DESENVOLVIDO POR INOVEN


User Function Mt100lok()

Local aArea		:= GetArea()
Local lOk		:= .t.
Local cProduto	:= ""
Local cCCusto	:= ""
Local cRateio	:= ""
Local nQuant	:= 0
Local cAlmox	:= ''
Local cLote 	:= ''
Local cConta	:= " "
Local cTes		:= ''
Local lAtuEst	:= .f.
//Local lGeraDup := .f.

If !alltrim(funname()) == 'MATA103'
	return .t.
endif


If !(aCols[n,Len(aHeader)+1])  // testa se a linha esta deletada
	
	cProduto	:= BuscAcols("D1_COD")
	cCCusto		:= BuscAcols("D1_CC")
	cRateio		:= BuscAcols("D1_RATEIO")
	nQuant		:= BuscAcols("D1_QUANT")
	cAlmox		:= BuscAcols("D1_LOCAL")
	cLote 		:= BuscAcols("D1_LOTECTL")
	cConta		:= " "
	cTes		:= BuscAcols("D1_TES")
	dDtFabr		:= BuscAcols("D1_DFABRIC")
	dDtVali		:= BuscAcols("D1_DTVALID")
	
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nao e permitida a entrada de produto PA com quantidade fracionada.³
	//³Incluido em 15/12/05 por Andreza Favero                           ³
	//³                                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	SF4->(DbSetOrder(1))
	
	If SF4->(MsSeek(xFilial("SF4")+cTes))
		If SF4->F4_ESTOQUE == "S"
			lAtuEst	:= .t.
		Else
			lAtuEst	:= .f.
		EndIf
	EndIf

	SB1->(dbSetOrder(1))
	SB1->(msSeek(xFilial("SB1") + cProduto))
	/*
	If SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "N" .AND. SB1->B1_ORIGEM == "1" .And. cUfOrig == "EX" 
		nPos1 := ascan(aHeader,{|m| alltrim(m[2]) == "D1_LOCAL" })
		aCols[n,nPos1]:= '90'
		//Aviso(	"Documento de entrada",;
		//"Produtos do tipo PA (Produto Acabado) com quantidade fracionada so podem ser adquiridos no almoxarifado "+Alltrim(cLocFrac)+" . Verifique!" ,;
		//{"&Ok"},,;
		//"Produto: "+AllTrim(cProduto) )
		lOk	:= .T.
	ELSEIF ( SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "N" .AND. SB1->B1_ORIGEM == "2" ) .Or. ( cUfOrig <> "EX" .And. lAtuEst .AND. substr(cTipo,1,1) == "N" )  
		nPos1 := ascan(aHeader,{|m| alltrim(m[2]) == "D1_LOCAL" })
		aCols[n,nPos1]:= '80'
		lOk	:= .T.
	ELSEIF SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "D" 
		nPos1 := ascan(aHeader,{|m| alltrim(m[2]) == "D1_LOCAL" })
		aCols[n,nPos1]:= '04'
		lOk	:= .T.
	ELSEIF SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "B"  .AND. cTes == '476' 
		nPos1 := ascan(aHeader,{|m| alltrim(m[2]) == "D1_LOCAL" })
		aCols[n,nPos1]:= '05'
		lOk	:= .T.
	EndIf
	*/

	//If lAtuEst .and. SB1->B1_TIPO $ 'ME' .AND.  EMPTY(cLote) .AND. SB1->B1_RASTRO == 'L' //substr(cTipo,1,1) == "N" 
	If lAtuEst .and. SB1->B1_TIPO $ 'ME' .AND. (EMPTY(cLote) .or. empty(dDtFabr) .or. empty(dDtVali))
		//msgalert("Para a entrada de Materia Prima/Produto Acabado informar o Campo lote e a Data de Validade. Verifique!")
		msgalert("Para a entrada de Materia Prima/Produto Acabado informar os Campos:"+chr(13)+chr(10)+"Lote, Data de Fabricacao e a Data de Validade. Verifique!")
		lOk	:= .f.
	EndIf
ENDIF	
	
RestArea(aArea)

Return(lOk) 
