#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  16/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BGPER001


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cArq,cInd
Local cString := "TRB"
Local aStru := {}
Private cPerg       := "TMP"
Private oGeraTxt

aAdd(aStru,{"TPREG","N",1,0})
aAdd(aStru,{"MAT","N",8,0})
aAdd(aStru,{"CPF","N",9,0})
aAdd(aStru,{"FILIAL","N",4,0})
aAdd(aStru,{"CONTROLE","N",2,0})
aAdd(aStru,{"CAPACIDA","N",1,0})
aAdd(aStru,{"TPMOVIME","N",1,0})
aAdd(aStru,{"NOMEFUNC","C",70,0})
aAdd(aStru,{"ENDRESID","C",40,0})
aAdd(aStru,{"NUMRESID","C",7,0})
aAdd(aStru,{"COMPRESID","C",20,0})
aAdd(aStru,{"BAIRRO","C",20,0})
aAdd(aStru,{"CEP","N",5,0})
aAdd(aStru,{"SFXOCEP","N",3,0})
aAdd(aStru,{"DDDFONE","N",4,0})
aAdd(aStru,{"FONE","N",8,0})
aAdd(aStru,{"DDDFAX","N",4,0})
aAdd(aStru,{"FAX","N",8,0})
aAdd(aStru,{"ENDERCOR","C",40,0})
aAdd(aStru,{"NRENDCOR","C",7,0})
aAdd(aStru,{"COMPENDC","C",20,0})
aAdd(aStru,{"BAIRROCO","C",20,})
aAdd(aStru,{"CEPCORR","N",5,})
aAdd(aStru,{"SXOCEPCO","N",3,})
aAdd(aStru,{"OCUPACAO","N",5,})
aAdd(aStru,{"NASC","N",8,})
aAdd(aStru,{"NATURALI","C",30,})
aAdd(aStru,{"UFNASC","C",2,})
aAdd(aStru,{"SEXO","N",1,})
aAdd(aStru,{"PAI","C",40,})
aAdd(aStru,{"MAE","C",40,})
aAdd(aStru,{"BRAESTRA","N",1,})
aAdd(aStru,{"NACIONAL","C",20,})
aAdd(aStru,{"ESTCIVIL","N",1,})
aAdd(aStru,{"TPDOCUM","C",20,})
aAdd(aStru,{"NUMDOC","C",15,})
aAdd(aStru,{"EMISSAO","N",8,})
aAdd(aStru,{"ORGEMISS","C",20,})
aAdd(aStru,{"EMPRESA","C",40,})
aAdd(aStru,{"CARGO","C",40,})
aAdd(aStru,{"RENDA","C",40,})
aAdd(aStru,{"TMPSERV","N",4,})
aAdd(aStru,{"ENDEMP","C",40,})
aAdd(aStru,{"NRCEPEMP","N",5,})
aAdd(aStru,{"SXCEPEMP","N",3,})
aAdd(aStru,{"CONJUGE","C",40,})


cArq := CriaTrab(aStru,.T.)
dbUseArea(.T.,,cArq,cString,.T.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say "                                                            "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  16/02/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTxt

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

Private nHdl    := fCreate(mv_par01)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������

Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  16/02/12   ���
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

Local nTamLin, cLin, cCpo


//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� programa.  Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

dbSelectArea(cString)
dbGoTop()

ProcRegua(RecCount()) // Numero de registros a processar

While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	IncProc()
	
	//�����������������������������������������������������������������ͻ
	//� Lay-Out do arquivo Texto gerado:                                �
	//�����������������������������������������������������������������͹
	//�Campo           � Inicio � Tamanho                               �
	//�����������������������������������������������������������������Ķ
	//� REGISTRO     � 01  � 01                                �
	//� MATRICULA     � 02  � 09                                �
	//� CPF     � 10  � 18                                �
	//� FILIAL     � 19  � 22                                �
	//�����������������������������������������������������������������ͼ
	
	nTamLin := 50
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	cCpo	:= ""
	//���������������������������������������������������������������������Ŀ
	//� Substitui nas respectivas posicioes na variavel cLin pelo conteudo  �
	//� dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     �
	//� string dentro de outra string.                                      �
	//�����������������������������������������������������������������������
	
	cCpo := Str(->TPREG,1,0)
	cLin := Stuff(cLin,01,01,cCpo)
	cCpo := Str(->MAT,8,0)
	cLin := Stuff(cLin,02,09,cCpo)
	cCpo := Str(->CPF,9,0)
	cLin := Stuff(cLin,10,18,cCpo)
	cCpo := Str(->FILIAL,4,0)
	cLin := Stuff(cLin,19,22,cCpo)
	cCpo := Str(->CONTROLE,2,0)
	cLin := Stuff(cLin,23,24,cCpo)
	cCpo := Str(->CAPACIDA,1,0)
	cLin := Stuff(cLin,25,25,cCpo)
	cCpo := Str(->TPMOVIME,1,0)
	cLin := Stuff(cLin,26,26,cCpo)
	cCpo := Str(->NOMEFUNC,70,0)
	cLin := Stuff(cLin,27,96,cCpo)
	cCpo := Str(->ENDRESID,40,0)
	cLin := Stuff(cLin,97,136,cCpo)
	cCpo := Str(->NUMRESID,7,0)
	cLin := Stuff(cLin,137,143,cCpo)
	cCpo := Str(->COMPRESID,20,0)
	cLin := Stuff(cLin,144,163,cCpo)
	cCpo := Str(->BAIRRO,20,0)
	cLin := Stuff(cLin,164,183,cCpo)
	cCpo := Str(->CEP,5,0)
	cLin := Stuff(cLin,184,188,cCpo)
	cCpo := Str(->SFXOCEP,3,0)
	cLin := Stuff(cLin,189,191,cCpo)
	cCpo := Str(->DDDFONE,4,0)
	cLin := Stuff(cLin,192,195,cCpo)
	cCpo := Str(->FONE,8,0)
	cLin := Stuff(cLin,196,203,cCpo)
	cCpo := Str(->DDDFAX,4,0)
	cLin := Stuff(cLin,204,207,cCpo)
	cCpo := Str(->FAX,8,0)
	cLin := Stuff(cLin,208,215,cCpo)
	cCpo := Str(->ENDERCOR,40,0)
	cLin := Stuff(cLin,216,255,cCpo)
	cCpo := Str(->NRENDCOR ,7,0)
	cLin := Stuff(cLin,256,262,cCpo)
	cCpo := Str(->COMPENDC,20,0)
	cLin := Stuff(cLin,263,282,cCpo)
	cCpo := Str(->BAIRROCO,20,0)
	cLin := Stuff(cLin,283,302,cCpo)
	cCpo := Str(->CEPCORR,5,0)
	cLin := Stuff(cLin,303,307,cCpo)
	cCpo := Str(->SXOCEPCO,3,0)
	cLin := Stuff(cLin,308,310,cCpo)
	cCpo := Str(->OCUPACAO,5,0)
	cLin := Stuff(cLin,311,315,cCpo)
	cCpo := Str(->NASC,8,0)
	cLin := Stuff(cLin,316,323,cCpo)
	cCpo := Str(->NATURALI,30,0)
	cLin := Stuff(cLin,324,353,cCpo)
	cCpo := Str(->UFNASC,2,0)
	cLin := Stuff(cLin,354,355,cCpo)
	cCpo := Str(->SEXO,1,0)
	cLin := Stuff(cLin,356,356,cCpo)
	cCpo := Str(->PAI,40,0)
	cLin := Stuff(cLin,357,396,cCpo)
	cCpo := Str(->MAE,40,0)
	cLin := Stuff(cLin,397,436,cCpo)
	cCpo := Str(->BRAESTRA,1,0)
	cLin := Stuff(cLin,437,437,cCpo)
	cCpo := Str(->NACIONAL,20,0)
	cLin := Stuff(cLin,438,457,cCpo)
	cCpo := Str(->ESTCIVIL,1,0)
	cLin := Stuff(cLin,458,458,cCpo)
	cCpo := Str(->TPDOCUM,20,0)
	cLin := Stuff(cLin,459,478,cCpo)
	cCpo := Str(->NUMDOC,15,0)
	cLin := Stuff(cLin,479,493,cCpo)
	cCpo := Str(->EMISSAO,8,0)
	cLin := Stuff(cLin,494,501,cCpo)
	cCpo := Str(->ORGEMISS,20,0)
	cLin := Stuff(cLin,502,521,cCpo)
	cCpo := Str(->EMPRESA,40,0)
	cLin := Stuff(cLin,522,561,cCpo)
	cCpo := Str(->CARGO,40,0)
	cLin := Stuff(cLin,562,601,cCpo)
	cCpo := Str(->RENDA,40,0)
	cLin := Stuff(cLin,602,616,cCpo)
	cCpo := Str(->TMPSERV,4,0)
	cLin := Stuff(cLin,617,620,cCpo)
	cCpo := Str(->ENDEMP,40,0)
	cLin := Stuff(cLin,621,660,cCpo)
	cCpo := Str(->NRCEPEMP,5,0)
	cLin := Stuff(cLin,661,665,cCpo)
	cCpo := Str(->SXCEPEMP,3,0)
	cLin := Stuff(cLin,666,668,cCpo)
	cCpo := Str(->CONJUGE,40,0)
	cLin := Stuff(cLin,669,708,cCpo)
	
	//���������������������������������������������������������������������Ŀ
	//� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
	//� linha montada.                                                      �
	//�����������������������������������������������������������������������
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	dbSkip()
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oGeraTxt)

Return
