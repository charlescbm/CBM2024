#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

#Define CRLF CHR(13)+CHR(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460FIM   �Autor  �Daniel Pelegrinelli � Data �  10/17/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclui o Grupo de Cliente no Cabecalho da Nota Fiscal de    ���
���          �Saida - pendencia n. 53 rev. 16082005                       ���
�������������������������������������������������������������������������Ĵ��
���Altera��es� 01.11.05 - Almir Bandina - efetuar o c�lculo da quantidade ���
���          �            de volumes e peso de acordo com regra definida  ���
���          �            pela Brascola. (Esse processo era feito no ponto���
���          �            de entrada M460MARK e ficava errado quando eram ���
���          �            geradas mais de uma nota fiscal para o mesmo    ���
���          �            pedido.                                         ���
���          � 07.11.05 - Almir Bandina - efetuar a atualiza��o do campo  ���
���          �            C5_QTDPEN ap�s a gera��o da nota fiscal em      ���
���          �            substitui��o ao programa QGLIBERA, fun��o       ���
���          �            ExecAtuParc que rodava para todas as notas      ���
���          � 11.05.06 - Elias Reis - Alteracao para o sistema considerar���
���          �            mais 1 volume, no caso de a qtde vendida superar���
���          �            a qtde por embalagem. O excedente e considerado ���
���          �            mais um volume na nota fiscal.                  ���
���          � 16.05.06 - Elias Reis - Alteracao para o sistema gravar em ���
���          �            SF3 os valores referentes a Base de ICMS e valor���
���          �            de ICMS referente ao frete, e o valor de ISENTAS���
���          �            de icms, seguindo orientacao do setor fiscal.   ���
���          � 27.11.07 - Paulo Fernandes - Alteracao para gerar arquivo  ���
���          �            txg, campos separados por ";" da Nota Fiscal    ���
���          �            para o cliente XXXXXX, TES poder de terceiros   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function M460FIM()

Local _xAlias	:= GetArea()
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSF3	:= SF3->(GetArea())
Local _cCli		:= SF2->F2_CLIENTE                                                      
Local _cLoja	:= SF2->F2_LOJA
Local _cNumNF	:= SF2->F2_DOC
Local _cSerieNF	:= SF2->F2_SERIE
Local _cTes		:= SD2->D2_TES
Local _cGrup	:= ""
Local cQrSA1	:= ""
Local cQry		:= ""							// 01.11.05 - Almir Bandina
Local nQtdVol	:= 0							// 01.11.05 - Almir Bandina
Local cPedAnt	:= " "						// 01.11.05 - Almir Bandina
Local aPedidos	:= {}							// 07.11.05 - Almir Bandina
Local nLoop		:= 0							// 07.11.05 - Almir Bandina

// Define o grupo de venda a que o cliente pertence
cQrSA1 := "SELECT A1_GRPVEN,A1_COD "  
cQrSA1 += "FROM "+RetSqlName("SA1")+"  " 
cQrSA1 += "WHERE A1_COD = '"+_cCli+"' AND  A1_LOJA = '"+_cLoja+"' "
cQrSA1 += " AND "+RetSqlName("SA1")+".D_E_L_E_T_ <> '*' " 

dBUseArea(.T.,"TOPCONN",TcGenQry(,,cQrSA1),"SA1X",.F.,.F.)

dbgotop("SA1X")
_cGrup := SA1X->A1_GRPVEN
DBCLOSEAREA("SA1X")


// 01.11.05 - Almir Bandina - Calcula o peso e quantidade de volumes para a nota fiscal
cQry	:= " SELECT SD2.D2_COD,SB1.B1_QTDEMB,SD2.D2_PEDIDO,SUM(SD2.D2_QUANT) AS D2_QUANT, SC5.C5_CONDPAG"
cQry	+= " FROM "+RetSqlName("SD2")+" SD2 (NOLOCK),"+RetSqlName("SB1")+" SB1 (NOLOCK),"+RetSqlName("SC5")+" SC5 (NOLOCK)"
cQry	+= " WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"'"
cQry	+= " AND SD2.D2_DOC = '"+SF2->F2_DOC+"'"
cQry	+= " AND SD2.D2_SERIE = '"+SF2->F2_SERIE+"'"
cQry	+= " AND SD2.D_E_L_E_T_ <> '*'"
cQry	+= " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQry	+= " AND SB1.B1_COD = SD2.D2_COD"
cQry	+= " AND SB1.D_E_L_E_T_ <> '*'"
cQry	+= " AND SC5.C5_FILIAL = SD2.D2_FILIAL"
cQry	+= " AND SC5.C5_NUM = SD2.D2_PEDIDO"
cQry	+= " AND SC5.D_E_L_E_T_ <> '*'"
cQry	+= " GROUP BY SD2.D2_COD,SB1.B1_QTDEMB,SD2.D2_PEDIDO,SC5.C5_CONDPAG"
cQry	+= " ORDER BY SD2.D2_PEDIDO,SD2.D2_COD"

If Select("M460FIMA") > 0
	dbSelectArea("M460FIMA")
	dbCloseArea()
EndIf

//MemoWrite("\QUERYSYS\M460FIMA.SQL",cQry)
TCQUERY cQry NEW ALIAS "M460FIMA"

dbSelectArea("M460FIMA")
dbGotop()
While !Eof()

	//04.01.12 - Fernando: colocou bloco em coment�rio
	/*If M460FIMA->C5_AMOSTRA $ "2/N/5/6"    .AND.  SF2->F2_EST <> 'EX'
		// Calcula a quantidade de volumes		
		nQtdVol += Round(Int(M460FIMA->D2_QUANT / If(Empty(M460FIMA->B1_QTDEMB), 1, M460FIMA->B1_QTDEMB)),0)
		//Se a qtde de algum item for superior a qnte por embalagem, ele incrementa mais 1 volume
		//referente ao excedente da embalagem
		//Caso de pistolas		
		nQtdVol += IIF(M460FIMA->D2_QUANT % If(Empty(M460FIMA->B1_QTDEMB), 1, M460FIMA->B1_QTDEMB) > 0,1,0)
	Else
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+M460FIMA->D2_PEDIDO)
		If M460FIMA->D2_PEDIDO != cPedAnt
			nQtdVol	+= SC5->C5_VOLUME1
			cPedAnt	:= M460FIMA->D2_PEDIDO
		EndIf
	EndIf*/
	  
	//04.01.12 - Fernando: adicionou este trecho de c�digo 

	
		dbSelectArea("SC5")
		dbSetOrder(1)   
			
	If M460FIMA->C5_CONDPAG $ "099"
		MsSeek(xFilial("SC5")+M460FIMA->D2_PEDIDO)
		If M460FIMA->D2_PEDIDO != cPedAnt
			nQtdVol	+= SC5->C5_VOLUME1
			cPedAnt	:= M460FIMA->D2_PEDIDO
		EndIf       
	
	Else                                                
	
	     nQtdVol += Round(Int(M460FIMA->D2_QUANT / If(Empty(M460FIMA->B1_QTDEMB), 1, M460FIMA->B1_QTDEMB)),0)
		 nQtdVol += IIF(M460FIMA->D2_QUANT % If(Empty(M460FIMA->B1_QTDEMB), 1, M460FIMA->B1_QTDEMB) > 0,1,0)
		    
    Endif

	// 07.11.05 - Almir Bandina - Alimenta array com os pedidos contantes na nota fiscal
	If aScan(aPedidos, M460FIMA->D2_PEDIDO) == 0
		aAdd(aPedidos, M460FIMA->D2_PEDIDO)
	EndIf

	dbSelectArea("M460FIMA")
	dbSkip()
EndDo

// Fecha o arquivo tempor�rio
dbSelectArea("M460FIMA")
dbCloseArea()

// Atualiza os campos no cabe�alho da nota fiscal
dbSelectArea("SF2")
RecLock("SF2",.F.)
	//SF2->F2_X_GRPVD	:= _cGrup
	SF2->F2_VOLUME1	:= nQtdVol
MsUnlock()


/*
// 07.11.05 - Almir Bandina 
// Atualiza o cabe�alho do pedido de venda com a quantidade ainda pendente de entrega
If Len(aPedidos)>0
For nLoop := 1 To Len(aPedidos)

/// PARA ATIVAR A FUNCAO AC_QTDPEN() ABAIXO, APENAS COLOQUE UM ".T." NO LUGAR DO ".F."
/// DESSA FORMA A ROTINA NAO IRA MAIS PASSAR PELO BLOCO SEGUINTE E UTILIZARA SOMENTE A FUNCAO "AC_QTDPEN"
IF .T.
	U_AC_QTDPEN("","",aPedidos[nLoop])
ELSE
	// Monta a query para pesquisar a quantidade pendente do pedido
	cQry	:= " SELECT ISNULL(SUM(SC6.C6_QTDVEN - SC6.C6_QTDENT ),0) AS QTDSDO"
	cQry	+= " FROM "+RetSqlName("SC6")+" SC6"
	cQry	+= " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
	cQry	+= " AND SC6.C6_NUM = '"+aPedidos[nLoop]+"'"
	cQry	+= " AND SC6.C6_BLQ = ' '"
	cQry	+= " AND SC6.D_E_L_E_T_ <> '*'"
	// Checa se o arquivo esta aberto
	If Select("M460FIMB") > 0
		dbSelectArea("M460FIMB")
		dbCloseArea()
	EndIf
	TCQUERY cQry NEW ALIAS "M460FIMB"
	If M460FIMB->QTDSDO > 0
		dbSelectArea("SC5")
		dbSetOrder(1)
		If MsSeek(xFilial("SC5")+aPedidos[nLoop])
			RecLock("SC5",.F.)
				SC5->C5_QTDPEN	:= M460FIMB->QTDSDO
			MsUnlock()
		EndIf
	EndIf
	dbSelectArea("M460FIMB")
	dbCloseArea()
ENDIF	
Next nLoop
EndIf

*/


//***********************************************************************************************************
//Funcao para gravacao de dados especificos na tabela SF3                                                   *
//***********************************************************************************************************

/*// RODOLFO 08/04/09 NAO � NECESSARIO COBRAR ICMS DO FRETE
If SA1->A1_CALCSUF$"S/I" .And. !Empty(SA1->A1_SUFRAMA) .And. SF2->F2_FRETE > 0 

	// Atualiza os campos no cabe�alho da nota fiscal
	dbSelectArea("SF3")
	dbSetOrder(1) //F3_FILIAL+DTOS(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA+F3_CFO+STR(F3_ALIQICM,5,2)
	
	If MsSeek(xFilial()+DTos(SF2->F2_EMISSAO)+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,.T.)
	
		While !Eof() .And.;
	  		SF3->F3_FILIAL 			== SF2->F2_FILIAL .AND.;
	  		DTos(SF3->F3_EMISSAO) 	== DTos(SF3->F3_ENTRADA) .AND.;
	 		SF3->F3_NFISCAL      	== SF3->F3_NFISCAL .AND.;
	 		SF3->F3_SERIE 				== SF2->F2_SERIE.AND.;
	 		SF3->F3_CLIEFOR 			== SF2->F2_CLIENTE .AND.;
	  		SF3->F3_LOJA 				== SF2->F2_LOJA
		
			If SF3->F3_BASEICM + SF3->F3_VALICM == 0 .AND. SubsTr(SF3->F3_CFO,2,3)$"109/110/401/403"
				RecLock("SF3",.F.)
				SF3->F3_BASEICM += SF3->F3_DESPESA
				SF3->F3_VALICM  += SF3->F3_DESPESA * 0.07 
				SF3->F3_ALIQICM := If(SF3->F3_ALIQICM==0, 7, SF3->F3_ALIQICM :=SF3->F3_ALIQICM)

				//ESTA LINHA DIMINUI DA COLUNA ISENTAS O VALOR DA BASE DE CALCULO DO ICMS
				SF3->F3_ISENICM := SF3->F3_ISENICM - SF3->F3_BASEICM 
				SF3->F3_REPROC  := 'N' 	
				MsUnlock()		
			EndIf
		
		dbSkip()		
		Enddo
	EndIf
EndIf

*/

//***********************************************************************************************************
//Funcao para gravacao do portador em clientes que n�o aceitam determinados bancos                          *
//Esta funcao avalia se, no SA1, foi determinado algum banco! Em caso positivo,                             * 
//atribui um portador as duplicatas geradas por esta nota fiscal, de forma que estas                        *
//duplicatas n�o sejam enviadas a um banco qualquer, e sim, a um banco especifico do cliente                *
//***********************************************************************************************************

If !SF2->F2_TIPO$'D/B'  //Se for uma nota para clientes
  // If   !empty(SA1->A1_BCO1) //Se existir um banco especifico informado!SA1->A1_BCO1==Space(3)

  cBCO1:= Posicione( 'SA1', 1, xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA, 'A1_BCO1' )	
//  cBCO1:= Posicione( 'SC5', 1, xFilial('SC5') + SF2->F2_DOC + SF2->F2_SERIE, 'C5_BANCO' )	  
  
  If !Empty( cBCO1 )
      cQuery:= " UPDATE " + RetSQLName("SE1") + " SET E1_PORTADO = '" + cBCO1 + "'"     //       ='500' "
      cQuery+= " WHERE E1_FILIAL  ='" + SF2->F2_FILIAL + "'"
      cQuery+= " AND   E1_NUM     ='" + SF2->F2_DOC    + "'"
      cQuery+= " AND   E1_PREFIXO ='" + SF2->F2_SERIE  + "'"
   	  nRet:= TcSQLExec(cQuery)

   	  //Envia uma confirma��o ao financeiro a respeito desta modificacao
      cMailDest:= "financeiro@brascola.com.br"   	  
      cAssunto := SF2->F2_DOC + " - Altera��o do portador de duplicatas"
      cArqDest := ""

   	  If nRet==0
   	  	 cMensagem := "Alterado o portador da duplicata mencionada, para o portador 500, dado a preferencia do cliente por banco espec�fico."
   	  Else  //Se deu algo de errado no acerto, envia um email de alerta ao financeiro
   	  	 cMensagem := "Problema na altera��o da duplicata mencionada, para o portador 500 (preferencia do cliente por banco espec�fico)."   	  
   	  EndIf                                                                               

      //U_SendMail(cMailDest,cAssunto,cMensagem,cArqDest,.f.)   	  

   EndIf

EndIf




//�����������������������������������������������������������������Ŀ
//�Atualiza Carteira de Cliente Inativo - Marcelo Alcantara 19/03/07�
//�������������������������������������������������������������������
//U_RTMKA01(SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_VEND1)


/*
//M460GeraNF(_cCli, _cLoja, _cNumNF, _cSerieNF, _cTes)
IF SF2->F2_FILIAL = '04'
   geraguia()
ENDIF
*/
RestArea(aAreaSC5)
RestArea(aAreaSF3)
RestArea(_xAlias)

Return()  

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460GeraNF�Autor  �Paulo Fernandes     � Data �  27/11/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Caso o Codigo do cliente igual ao parametro BC_CODCLI e TES ���
���          �igual ao parametro BC_CODTES, gera um arquivo texto conforme���
���          �lay-out com os dados da NF.								  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function M460GeraNF(_cCli, _cLoja, _cNumNF, _cSerieNF, _cTes)
Local _aArea		:= GetArea()											// Salva area corrente
Local _aAreaSF2		:= SF2->(GetArea())									// Salva area SF2
Local _aAreaSD2		:= SD2->(GetArea())									// Salva area SD2
Local _aAreaSA1		:= SA1->(GetArea())									// Salva area SA1
Local _cBC_CODCLI	:= ""													// Codigo do Cliente no parametro BC_CODCLI
Local _cBC_CODTES	:= ""													// Codigo do TES no parametro BC_CODTES
Local _cNomeArq		:= "NF" + _cNumNF + ".TXT"								// Nome do arquivo gerado
Local _aStruct		:= {}													// Array com a estrutura(Campos) do arq. de trabalho
Local _cBuffer		:= ""													// Contem o formato do registro
Local _nHandle		:= 0													// Handle do arquivo
Local _cArquivo		:= ""													// Arquivo temporario
Local _cStart		:= GetSrvProfString( 'STARTPATH', '' )
Local _cPath		:= AllTrim(GetTempPath())
Local _cQuery		:= "" 													// Sentenca SQL
Local _nSumQtd		:= 0													// Total das quantidades dos itens

// criacao de parametro sx6
If !ExisteSX6("BR_000026")
	CriarSX6("BR_000026", "C","Codigo do Cliente NF",'07230202')
EndIf
If !ExisteSX6("BR_000027")
	CriarSX6("BR_000027", "C","Codigo do TES NF",'686')
EndIf

// Verifica se cliente-loja e tes corresponte aos parametros
If _cCli + _cLoja <> GetMV("BR_000026") .Or. _cTes <> GetMV("BR_000027")
	Return
Endif

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Cria arquivo temporario para gravacao dos dados da NF conforme lay-out   ���
���          																���
���Lay-Out do arquivo														���
���		Registro tipo 001 - identificacao do cliente/arquivo				���
���			nome do campo    formato  tamanho   Conteudo					���
���         ident.Registro		C		3		001							���
���         finalidade			C		1		0=Armazenagem/Separacao		���
���          									1=Nota de Retorno			���
���     Registro tipo 002 - Identificacao da Nota Fiscal					���
���			ident.Registro		C		3		002							���
���			Numero da NF		C		6									���
���			CNPJ Emissor NF		C		14									���
���			Serie NF			C		3									���
���			Data de emissao		C		8		DDMMAAAA					���
���			CFOP				C		5									���
���			Tipo Documento		C		1		1=Nota Armazenagem;			���
���												2=Nota Venda/Pedido			���
���												3=Nota Retirada Estoque		���
���		Registro tipo 003 - Identificacao dos itens da NF/Pedido			���
���			Ident. Registro		C		3		003							���
���			Codigo Produto		C		15									���
���			Quantidade			N		9,3		99999,999					���
���			Percentual ICMS		N		5,2		99,99						���
���			Valor do Item		N		15,2	999999999999,99				���
���			Numero do Lote		C		10									���
���			Validade Lote		C		8		DDMMAAAA					���
���			Nr.Nota Entrada		C		6		Nota de Entrada Armazem		���		
���			Codigo da UM		C		3									���
���		Registro tipo 004 - Identificacao do cliente destino da mercadoria	���
���			Ident.Registro		C		3		004							���
���			CNPJ				C		14									���
���			Razao Social		C		40									���
���			Endereco			C		40									���
���			Bairro				C		20									���
���			Cidade				C		40									���
���			UF					C		2									���
���			CEP					C		8									���
���			Inscr.Estadual		C		14									���
���			Fone				C		15									���
���			Observacao			C		80									���
���		Registro tipo 007 - Totalizacao da Nota Fiscal						���
���			Ident.Registro		C		3									���
���			Total Quantidade	N		8,3									���
���			Total Peso Liquido	N		8,3									���
���			Total Peso Bruto	N		8,3									���
���			Valor Total Nota	N		18,2								���
���			Valor Base ICMS		N		18,2								���
���			Percentual ICMS		N		5,2									���
���			Valor do ICMS		N		18,2								���
���          																���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

// CRIACAO DO ARQUIVO TEXTO A SER GERADO
_cBuffer   := ""
_nHandle   := 0
_cArquivo  := CriaTrab(,.F.)
	
// gera o arquivo em formato .CSV
_cArquivo += ".CSV"
_nHandle := FCreate("\\TERRA\DALLOGIS\ENVIO\" + _cArquivo)
	
If _nHandle == -1
	MsgStop("Erro na criacao do arquivo exportacao da NF na estacao local. Contate o administrador do sistema")
	Return
EndIf
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���		Registro tipo 001 - identificacao do cliente/arquivo				���
���			nome do campo    formato  tamanho   Conteudo					���
���         ident.Registro		C		3		001							���
���         finalidade			C		1		0=Armazenagem/Separacao		���
���          									1=Nota de Retorno			���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
_cBuffer:="001;0"+CRLF

FWrite(_nHandle, _cBuffer)
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���     Registro tipo 002 - Identificacao da Nota Fiscal					���
���			ident.Registro		C		3		002							���
���			Numero da NF		C		6									���
���			CNPJ Emissor NF		C		14									���
���			Serie NF			C		3									���
���			Data de emissao		C		8		DDMMAAAA					���
���			CFOP				C		5									���
���			Tipo Documento		C		1		1=Nota Armazenagem;			���
���												2=Nota Venda/Pedido			���
���												3=Nota Retirada Estoque		���
���          									1=Nota de Retorno			���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
_cConvData:=DTOC(SF2->F2_EMISSAO)
_cConvData:=StrTran(_cConvData,"/","")
_cConvData:=Substr(_cConvData,1,4)+"20"+SubStr(_cConvData,5,2)
_cBuffer:="002;" + _cNumNF + ";" + AllTrim(SM0->M0_CGC) + ";" + AllTrim(_cSerieNF) + ";" + _cConvData + ";" 
_cBuffer+=AllTrim(SD2->D2_CF) + ";1" + CRLF

FWrite(_nHandle, _cBuffer)
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���		Registro tipo 003 - Identificacao dos itens da NF/Pedido			���
���			Ident. Registro		C		3		003							���
���			Codigo Produto		C		15									���
���			Quantidade			N		9,3		99999,999					���
���			Percentual ICMS		N		5,2		99,99						���
���			Valor do Item		N		15,2	999999999999,99				���
���			Numero do Lote		C		10									���
���			Validade Lote		C		8		DDMMAAAA					���
���			Nr.Nota Entrada		C		6		Nota de Entrada Armazem		���		
���			Codigo da UM		C		3									���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
_cQuery:="SELECT D2_COD, D2_QUANT, D2_PICM, D2_PRCVEN, D2_TOTAL, D2_LOTECTL, D2_DTVALID, D2_NFORI, D2_SERIORI, D2_UM"
_cQuery+="  FROM " + RetSqlName("SD2")
_cQuery+=" WHERE D2_FILIAL = '" + xFilial("SD2") + "'"
_cQuery+="   AND D2_DOC = '" + _cNumNF + "'"
_cQuery+="   AND D2_SERIE = '" + _cSerieNF + "'"
_cQuery+="   AND D2_CLIENTE = '" + _cCli + "'"
_cQuery+="   AND D2_LOJA = '" + _cLoja + "'"
_cQuery+="   AND D_E_L_E_T_ = ' '"

TcQuery _cQuery New Alias "TSD2"
TcSetField("TSD2","D2_QUANT","N",16,6)
TcSetField("TSD2","D2_PICM","N",5,2)
TcSetField("TSD2","D2_TOTAL","N",14,2)
TcSetField("TSD2","D2_PRCVEN","N",14,2)
TcSetField("TSD2","D2_DTVALID","D",8,0)                                   

_nSumQtd:=0

TSD2->(dbGoTop())
While TSD2->(!EOF())
	_cConvData:=""
	If !Empty(TSD2->D2_DTVALID)
		_cConvData:=DTOC(TSD2->D2_DTVALID)
		_cConvData:=StrTran(_cConvData,"/","")
		_cConvData:=Substr(_cConvData,1,4)+"20"+SubStr(_cConvData,5,2)
	Endif
	_cBuffer:="003;" + AllTrim(TSD2->D2_COD) + ";" + _ToXlsFormat(TSD2->D2_QUANT) + ";" + _ToXlsFormat(TSD2->D2_PICM)
	_cBuffer+=";" + _ToXlsFormat(TSD2->D2_PRCVEN) + ";" + AllTrim(TSD2->D2_LOTECTL)
	_cBuffer+=";" + _cConvData + ";" + AllTrim(TSD2->D2_NFORI) + ";" + TSD2->D2_UM + CRLF

	_nSumQtd+=TSD2->D2_QUANT
	
	FWrite(_nHandle, _cBuffer)
	
	TSD2->(dbSkip())
End

TSD2->(dbCloseArea())

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���		Registro tipo 004 - Identificacao do cliente destino da mercadoria	���
���			Ident.Registro		C		3		004							���
���			CNPJ				C		14									���
���			Razao Social		C		40									���
���			Endereco			C		40									���
���			Bairro				C		20									���
���			Cidade				C		40									���
���			UF					C		2									���
���			CEP					C		8									���
���			Inscr.Estadual		C		14									���
���			Fone				C		15									���
���			Observacao			C		80									���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+_cCli+_cLoja))

_cBuffer:="004;" + AllTrim(SA2->A2_CGC) + ";" + AllTrim(SA2->A2_NOME) + ";" + AllTrim(SA2->A2_END) + ";" + AllTrim(SA2->A2_BAIRRO)
_cBuffer+=";" + AllTrim(SA2->A2_MUN) + ";" + AllTrim(SA2->A2_EST) + ";" + AllTrim(SA2->A2_CEP) + ";" + AllTrim(SA2->A2_INSCR)
_cBuffer+=";" + AllTrim(SA2->A2_TEL) + ";" + CRLF

FWrite(_nHandle, _cBuffer)

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���		Registro tipo 007 - Totalizacao da Nota Fiscal						���
���			Ident.Registro		C		3									���
���			Total Quantidade	N		8,3									���
���			Total Peso Liquido	N		8,3									���
���			Total Peso Bruto	N		8,3									���
���			Valor Total Nota	N		18,2								���
���			Valor Base ICMS		N		18,2								���
���			Percentual ICMS		N		5,2									���
���			Valor do ICMS		N		18,2								���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
_cBuffer:="007;" + _ToXlsFormat(_nSumQtd) + ";" + _ToXlsFormat(SF2->F2_PLIQUI) + ";"
_cBuffer+=_ToXlsFormat(SF2->F2_PBRUTO) + ";" + _ToXlsFormat(SF2->F2_VALMERC) + ";" 
_cBuffer+=_ToXlsFormat(SF2->F2_BASEICM) + ";" + _ToXlsFormat(Round((SF2->F2_VALICM/SF2->F2_BASEICM)*100,2)) + ";" 
_cBuffer+=_ToXlsFormat(SF2->F2_VALICM) + CRLF

FWrite(_nHandle, _cBuffer)

//fecha arq. texto.
FClose(_nHandle)

FRename( "\\TERRA\DALLOGIS\ENVIO\" + _cArquivo, "\\TERRA\DALLOGIS\ENVIO\" + _cNomeArq )

RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSA1)
RestArea(_aArea)

Return
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �ToXlsForm� Autor �  Adriano Ueda          � Data � 19/05/2005 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o para formato um valor para exportar para um arquivo   ���
���          � .CSV                                                         ���
���������������������������������������������������������������������������Ĵ��
���Par�metros� xValue - valor a ser formato                                 ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � O valor formatado (em string) para a grava��o no arquivo.    ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � PMSA100, SIGAPMS                                             ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function _ToXlsFormat(xValue,cCampoSX3)
Local cComboSX3
Local aAreaSX3
Local aArea
Local nTamCpo
Local nPos
If cCampoSX3 <> Nil
	nPos := aScan(__aComboSX3,{|x| x[1] == cCampoSX3})
	If nPos > 0
		cComboSX3 := __aComboSX3[nPos,2]
		nTamCpo	 := __aComboSX3[nPos,3]
	Else
		aArea	:= GetArea()
		aAreaSX3:= SX3->(GetArea())
		dbSelectArea("SX3")
		dbSetOrder(2)
		If MsSeek(cCampoSX3)
			cComboSX3:= X3cBox()
			nTamCpo	:= X3_TAMANHO
			aAdd(__aComboSX3,{cCampoSX3,cComboSX3,nTamCpo})
		EndIf
		RestArea(aAreaSX3)
		RestArea(aArea)
	EndIf
EndIf

Do Case
	Case ValType(xValue) == "C"
		If cComboSX3<>Nil .And. !Empty(cComboSX3)
			aX3cBox	:= RetSx3Box(cComboSX3,Nil,Nil,nTamCpo)
			nPos := Ascan(aX3cBox,{|x| xValue $ x[2]})
			If nPos > 0
				xValue := aX3cBox[nPos][3]
				xValue := StrTran(xValue, Chr(34), Chr(34) + Chr(34))
				xValue := AllTrim(xValue)
			Else
				xValue := StrTran(xValue, Chr(34), Chr(34) + Chr(34))
				xValue := Chr(34) + AllTrim(xValue) + Chr(34)
			EndIf
		EndIf
	Case ValType(xValue) == "N"
		xValue := Strtran(AllTrim(Str(xValue)),".",",")
	Case ValType(xValue) == "D"
		xValue := DToC(xValue)
	Case ValType(xValue) == "L"
		xValue := If(xValue, ".T.", ".F.")
	Case ValType(xValue) == "U"
		xValue := ""
	OtherWise
		xValue := ""
EndCase

Return( AllTrim(xValue) )


/******************************************************************/
                      //Gera Guia ICmsst
/*******************************************************************/

static function Geraguia()

local aArea:=getarea()
Local cSavAlias:= Alias()


//�Gravacao do ICMS ST - Imposto Retido(ICR)                               �
//��������������������������������������������������������������������������
If SF2->F2_ICMSRET > 0 .And. cPaisLoc=="BRA"
    //lGRec     := Iif(ValType(MV_PAR18)<>"N",.F.,(mv_par18==1))
    //lTit      := Iif(ValType(MV_PAR17)<>"N",.F.,(mv_par17==1))
	//������������������������������������������������������������������������������������������Ŀ
	//�Gera Guia de Recolhimento ou Titulo ICMS no Contas a pagar quando nao for do mesmo Estado �
	//�e que o Estado Destino nao possuir IE no parametro da substituicao tributaria             �                                           
	//��������������������������������������������������������������������������������������������
	//IF !lGRec
    If (GetMV("MV_ESTADO")<>SF2->F2_EST .And. Empty(IESubTrib(SF2->F2_EST)) .AND. SF2->F2_FILIAL = '04')
		nVlrIcmST :=SF2->F2_ICMSRET                
		nMes      := Month(SF2->F2_EMISSAO) 
		nAno      := Year(SF2->F2_EMISSAO) 
		aDatas    := DetDatas(nMes,nAno,3,1)
		dDtIni    := aDatas[1]
		dDtFim    := aDatas[2]
		dDtVenc   := DataValida(aDatas[2]+1,.t.)
		nTamNF    := Len(SF2->F2_DOC)
		//LancCont := (MV_PAR03==1)
    	dbselectarea("SF6")
    	Reclock("SF6",.T.)
    	SF6->F6_FILIAL := SF2->F2_FILIAL
    
    	dbSelectArea("SX5")
		SX5->(dbSetOrder(1))
		If SX5->( dbSeek(xFilial()+"53"+"ICMS"))
	  		_cNumero	:= SX5->X5_DESCRI
    	ENDIF
        
    	cNumero	:=	Soma1(Substr(X5Descri(),1,nTamNF),nTamNF)
    
    
    	SF6->F6_NUMERO  :='ICM'+ALLTRIM(_cNumero)
    	SF6->F6_EST     := SF2->F2_EST
    	SF6->F6_TIPOIMP := '3'
    	SF6->F6_VALOR   := nVlrIcmST
    	SF6->F6_DTARREC := DDATABASE 
    	SF6->F6_MESREF	:= nMes
    	SF6->F6_ANOREF	:= nAno
    	SF6->F6_DTVENC	:= dDtVenc   
    	sf6->F6_CODREC  := '100099'
    	SF6->F6_DOC     := SF2->F2_DOC
    	SF6->F6_SERIE   := SF2->F2_SERIE
    	SF6->F6_CLIFOR  := SF2->F2_CLIENTE 
    	SF6->F6_LOJA    := SF2->F2_LOJA
    	SF6->F6_OPERNF  := '2' 
    	SF6->F6_TIPODOC := SF2->F2_TIPO 
    	SF6->F6_CNPJ    := SM0->M0_CGC 
    	SF6->(MSUNLOCK())
 	Endif
 ENDIF
//Endif

dbSelectArea(cSavAlias)

Restarea(aArea)

Return



