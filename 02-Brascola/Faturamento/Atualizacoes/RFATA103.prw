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

User Function RFATA103()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg   := U_CriaPerg("FAT103")
Private oLeTxt
Private aRegs   := {}  
Private cString := ""

//Private cArqLog := "\Protheus\Protheus_Data\SystemProducao\TabPreco.log"
//Private cArqLog := "\\netuno\Protheus\Protheus_data\SystemProducao\TabPreco.log   
//Private cArqLog := "\\netuno\Protheus\Protheus_teste\System\TabPreco.log
Private _nValor := 0

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 390,460 DIALOG oLeTxt TITLE OemToAnsi("Atualiza��o de Tabelas de Pre�o")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa far� a atualiza��o das tabelas de pre�os "
//@ 18,018 Say " constantes no parametro BR_000007 " + GetMV("BR_000007",.F.,"") + ", " 
@ 18,018 Say " com os dados dos campos B2_VFIM / V2_QFIM "


@ 26,198 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 40,198 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 54,198 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)


//Aadd(aRegs,{cPerg,"01","Deprecia��o de  ?"      ,"      ?"       ,"","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//Aadd(aRegs,{cPerg,"02","Deprecia��o at� ?"      ,"      ?"       ,"","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//u_CriaSX1(aRegs)

//lValidPerg(aRegs)


//funcao que chama uma tela com os Parametros da Rotina

//If !Pergunte(cPerg,.T.)
  //	Return
//EndIf

Activate Dialog oLeTxt Centered    

Return

/*/
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

Local cTabela := '  ' 
Local aTabela := {}                      



IF MV_PAR01 = 1
   cTabela := '028'
ENDIF

   
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

GravaLog(1)

If msSeek(xFilial()+cTabela)

	While !Eof() .And. DA1->DA1_CODTAB == cTabela
	
		IncProc("Processando o produto : " + DA1->DA1_CODTAB + " / " + DA1->DA1_CODPRO )
		
		// Variavel que, nos casos de amostra, pode reduzir o custo-medio de caixas para unidades da caixa
		_nB1QE   := 1

		//Variavel que permite ou nao a alteracao da tabela de precos
		_lAltera := .T.
		
		//Armazena o codigo do produto, convertendo, quando for um produto de amostra
		If SubStr(DA1->DA1_CODPRO,1,1)=="A"
			cProduto := "0"+SubStr(DA1->DA1_CODPRO,2,14)
		Else
			cProduto := DA1->DA1_CODPRO
		EndIf
            
if DA1->DA1_CODTAB == '028'
	         
	        sb1->(dbSeek(xFilial("SB1")+cProduto))
	        cloc:=SB1->B1_LOCPAD
	    	//Localiza o produto, para calculo do Custo		
		     dbSelectArea("SB2") 
		     dbSetOrder(1)//SB2->B2_FILIAL+SB2->B2_COD+B2_LOCAL		
	         If msSeek(xFilial("SB2")+cProduto+cloc)
		        
		
			    If SB2->(B2_QFIM>0 .And. B2_VFIM1>0)
				_nValor := SB2->B2_VFIM1 / SB2->B2_QFIM / _nB1QE
			    Else
				_nValor := SB2->B2_CM1 / _nB1QE
			    EndIf
	     	    
		    endif
		
       GravaLog(2)
      _lAltera := If(_nValor<=0,.F.,.T.)

 endif		
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

//Atualiza o log de finalizacao do processo
//GravaLog(3)

RestArea(aAreaAtu)
RestArea(aAreaDA1)
RestArea(aAreaSB2)

Return  



/*/ 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � GravaLog � Autor � AP5 IDE            � Data �  05/05/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Esta funcao grava um log, de acordo com a varavel recebida ���
���          � , que pode ser o inicio do processo, ou meio, ou final.    ���
���          � 1-Inicio, 2-Processo, 3-Fim                                ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function GravaLog(nOp)

If nOp==1 //Inicio
	u_mGrvLog(cArqLog,, Repl("-",80))
	u_mGrvLog(cArqLog,, " Inicio da execu��o da rotina de Atualiza��o da Tabela de Precos - RFATA10")
	u_mGrvLog(cArqLog,, " Inicio Data   : "+DtoC(Date()) + "  - Hora: "+Time())           
	u_mGrvLog(cArqLog,, " Tabela  Produto         Vlr.Anterior   Vlr.Atual  ")
ElseIf nOp==2 //Processo
  	u_mGrvLog(cArqLog,, " "+DA1->DA1_CODPRO+DA1->DA1_CODTAB+Transform(DA1->DA1_PRCVEN,"@E 9999,999.99")+SPACE(13)+Transform(_nValor,"@E 9999.999,99"))
ElseIf nOp==3	//Final 
  //	u_mGrvLog(cArqLog,, " Foram atualizados " + AllTrim(Str(nQtdReg)) + " Registros da Tabela de Precos")	
	u_mGrvLog(cArqLog,, " Fim Data   : "+DtoC(Date()) + "  - Hora: "+Time())
EndIf                                              	

Return
*/
/*

Local aAreaAtu := GetArea()
Local aAreaDA1 := DA1->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
Local _nB1QE	:= 0 

dbSelectArea("DA1")
dbGotop()
dbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO

ProcRegua(800)//Numero de registros a processar 

If msSeek(xFilial()+cTabela)

	While !Eof() .And. DA1->DA1_CODTAB == cTabela
	
		IncProc("Processando o produto : " + DA1->DA1_CODTAB + " / " + DA1->DA1_CODPRO )
		
		//Armazena o codigo do produto, convertendo, quando for um produto de amostra		
		If SubStr(DA1->DA1_CODPRO,1,1)=="A"
			cProduto := "0"+SubStr(DA1->DA1_CODPRO,2,14)
		Else
			cProduto := DA1->DA1_CODPRO
		EndIf

		//Armazena o valor do campo B1_QE, para os produtos de amostra
		If DA1->DA1_CODTAB == '012'           
		
			dbSelectArea("SB1")
			dbSetOrder(1)
			If MsSeek(xFilial()+DA1->DA1_CODPRO)
				_nB1QE := If(SB1->B1_QE<=0,1,SB1->B1_QE)
			Endif
		EndIf

	
		//Localiza o produto, para calculo do Custo		
		dbSelectArea("SB2") 
		dbSetOrder(1)//SB2->B2_FILIAL+SB2->B2_COD+B2_LOCAL		
		If msSeek(xFilial()+cProduto+"40")
		
			nCusto := 0
			
			If SB2->B2_QFIM > 0
				nCusto := If(DA1->DA1_CODTAB=='012',(SB2->B2_VFIM1/SB2->B2_QFIM)/_nB1QE,SB2->B2_VFIM1/SB2->B2_QFIM)
			Else
				nCusto := If(DA1->DA1_CODTAB=='012',SB2->B2_CM1/_nB1QE,SB2->B2_CM1)
			EndIf 
			
			//Somente atualiza se o custo for positivo
			If nCusto>0
				dbSelectArea("DA1")
				RecLock("DA1",.F.)
				DA1->DA1_PRCVEN := nCusto
				MsUnlock()						
			EndIf

		EndIf
	   
		dbSelectArea("DA1")
		dbSkip()
	EndDo

EndIf

RestArea(aAreaAtu)
RestArea(aAreaDA1)
RestArea(aAreaSB2)

