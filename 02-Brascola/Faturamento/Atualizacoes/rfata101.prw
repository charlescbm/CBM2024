#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA10   � Autor � Elias Reis         � Data �  21/07/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa que atualiza a tabela de preco 021, com o valor do���
���          � campo B2_VFIM / B2_QFIM   JOINVILLE                        ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFATA101()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := U_CriaPerg("FATA10")
Private oLeTxt
Private aRegs   := {}
Private cString := ""

//Private cArqLog := "\Protheus\Protheus_Data\SystemProducao\TabPreco.log"
//Private cArqLog := "\\server_erp\Protheus\Protheus_data\SystemProducao\TabPreco.log
//Private cArqLog := "\\server_erp\Protheus\Protheus_teste\System\TabPreco.log
Private _nValor := 0

if SM0->M0_CODFIL <> '01'
	MsgInfo("Essa Rotina So Podera Ser Processada Em Matriz - Joinville!","Atencao")
	return
endif

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 390,460 DIALOG oLeTxt TITLE OemToAnsi("Atualiza��o de Tabelas de Pre�o")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa far� a atualiza��o das tabelas de pre�os "
//@ 18,018 Say " constantes no parametro BR_000007 " + GetMV("BR_000007",.F.,"") + ", "
@ 18,018 Say " com os dados dos campos B2_VFIM / B2_QFIM "


@ 26,198 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 40,198 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
//@ 54,198 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �             ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt
//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  05/05/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont
//Local cTabela := If(mv_par01 = 1,'020','021')//GetMV("BR_000007",.F.,"")

Local cTabela := '028'
Local aTabela := {}

//ddata:=MV_PAR02

cMF := GETMV("MV_ULMES")
//cMes := StrZero(MontH(ddata), 2)


//Arescento este caracter para que o loo consiga resumir todas as tabelas
If !AllTrim(Substr(cTabela,Len(cTabela)-1,1))=="/"
	cTabela += "/"
EndIf

While Len(cTabela) > 1
	nPos := At("/",cTabela)
	aAdd(aTabela,SubStr(cTabela,1,nPos-1))
	cTabela := AllTrim(SubsTr(cTabela,nPos+1,Len(cTabela)))
EndDo

For i:=1 To Len(aTabela)
	GravaTab(aTabela[i])
Next

Close(oLeTxt)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � GravaTab � Autor � AP6 IDE            � Data �             ���
�������������������������������������������������������������������������͹��
���Descri��o � Esta funcao atualiza a tabela recebida como parametro da   ���
���          � rotina                                                     ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GravaTab(cTabela)

Local aAreaAtu := GetArea()
Local aAreaDA1 := DA1->(GetArea())
Local aAreaSB2 := SB2->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local _nB1QE   := 0

dbSelectArea("DA1")
dbGotop()
dbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO

ProcRegua(800)//Numero de registros a processar

//GravaLog(1)

If msSeek(xFilial()+cTabela)
	While !Eof() .And. DA1->DA1_CODTAB == cTabela
		IncProc("Processando o produto : " + DA1->DA1_CODTAB + " / " + DA1->DA1_CODPRO )
		
		// Variavel que, nos casos de amostra, pode reduzir o custo-medio de caixas para unidades da caixa
		_nB1QE   := 1
		
		//Variavel que permite ou nao a alteracao da tabela de precos
		_lAltera := .T.
		
		_nValor := 0
		
		//Armazena o codigo do produto, convertendo, quando for um produto de amostra
		If SubStr(DA1->DA1_CODPRO,1,1)=="A"
			cProduto := "0"+SubStr(DA1->DA1_CODPRO,2,14)
		Else
			cProduto := DA1->DA1_CODPRO
		EndIf
		
		
		
		if DA1->DA1_CODTAB == '028'
			
			//Localiza o produto, para calculo do Custo
			/*
			dbSelectArea("SB2")
			dbSetOrder(1)//SB2->B2_FILIAL+SB2->B2_COD+B2_LOCAL
			If msSeek(xFilial("SB2")+cProduto+"40")
			If SB2->(B2_QFIM>0 .And. B2_VFIM1>0)
			_nValor := SB2->B2_VFIM1 / SB2->B2_QFIM / _nB1QE
			_nvalor := (_nvalor /(100-17))*100   //100-icms 17
			Else
			_nValor := SB2->B2_CM1 / _nB1QE
			_nValor :=  (_nvalor /(100-17))*100
			EndIf
			endif
			
			if substr(dtos(MV_PAR02),5,2)== '02'
			_DTATU:=DTOS(LASTDAY(MV_PAR02 - 25))
			ELSE
			_DTATU:=DTOS(LASTDAY(MV_PAR02 - 30))
			ENDIF
			*/
			
			dbSelectArea("SB9")
			dbGotop()
			dbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DATA
			
			SB9->(DBSEEK(XFILIAL("SB9")+DA1->DA1_CODPROD+'40'+dtos(cMF)))
			
			
			//cMes:=MONTH(LASTDAY(MV_PAR02-26))
			
			
			//cMes:= StrZero(cMes, 2)
			cCampo := "SB9->B9_CM1"
			IF &cCampo > 0
				_nValor :=(&cCampo/(100-12))*100
			else
				SB2->(msSeek(xFilial("SB2")+cProduto+"40"))
				_cValor:=SB2->B2_CMFIM1
				_nValor := (_cValor/(100-12))*100
				
			endif
			
			
			
			
			_lAltera := If(_nValor<0,.F.,.T.)
			
		Endif
		
		If _lAltera
			//Atualiza o log aqui, para pegar os valores anterior e o atual
			//GravaLog(3)
			
			//Atualizacao da base de dados
			dbSelectArea("DA1")
			RecLock("DA1",.F.)
			DA1->DA1_PRCVEN := _nValor
			DA1->(MsUnlock())
		EndIf
		
		dbSelectArea("DA1")
		dbSkip()
		
	EndDo
	
EndIf

RestArea(aAreaAtu)
RestArea(aAreaDA1)
RestArea(aAreaSB2)

Return
