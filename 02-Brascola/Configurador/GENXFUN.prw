#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � Fun��es  � Biblioteca de fun��es gen�ricas                              ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � SendMail � Fun��o para envio de e-mail                                  ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 15.09.04 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: e-mail do destinat�rio                                           ���
���             � ExpC2: assunto do e-mail                                                ���
���             � ExpC3: texto do e-mail                                                  ���
���             � ExpC4: anexos do e-mail                                                 ���
���             � ExpL1: exibe mensagem de envio                                          ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL2: .T. - envio realizado                                            ���
���             �        .F. - n�o enviado                                                ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function SendMail(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)

Local lRet	:= .T.
Local cCadastro			:= "Envio de e-mail"
Private cMailServer		:= GetMv("MV_RElSERV")
Private cMailConta		:= GetMv("MV_RELACNT")
Private cMailSenha		:= GetMv("MV_RELPSW")
Private cMailDestino	:= If( ValType(cMailDestino) != "U" , cMailDestino,  "" )
Private lMensagem		:= If( ValType(lMensagem)    != "U" , lMensagem,  .T. )

// Efetua valida��es
If Empty(cMailDestino)
	MailAviso(cCadastro,"Conta(s) de e-mail de destino(s) n�o informada. Envio n�o realizado.","Falta informa��o",lMensagem)
	lRet	:= .F.
EndIf

If Empty(cAssunto)
	MailAviso(cCadastro,"Assunto do e-mail n�o informado. Envio n�o realizado.","Falta informa��o",lMensagem)
	lRet	:= .F.
EndIf

If Empty(cTexto)
	MailAviso(cCadastro,"Texto do e-mail n�o informado. Envio n�o realizado.","Falta informa��o",lMensagem)
	lRet	:= .F.
EndIf

If lRet
	If lMensagem
		Processa({|| lRet := SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)})
	Else
		lRet := SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)
	EndIf
EndIf

Return(lRet)

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � SendMail2� Fun��o complementar para envio do e-mail                     ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 15.09.04 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: e-mail do destinat�rio                                           ���
���             � ExpC2: assunto do e-mail                                                ���
���             � ExpC3: texto do e-mail                                                  ���
���             � ExpC4: anexos do e-mail                                                 ���
���             � ExpL1: exibe mensagem de envio                                          ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL2: .T. - envio realizado                                            ���
���             �        .F. - n�o enviado                                                ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function SendMail2(cMailDestino,cAssunto,cTexto,cAnexos,lMensagem)

Local lConexao				:= .F.
Local lEnvio				:= .F.
Local lDesconexao			:= .F.
Local lRet					:= .F.
Local cAssunto				:= If( ValType(cAssunto) != "U" , cAssunto , "" )
Local cTexto				:= If( ValType(cTexto)   != "U" , cTexto   , "" )
Local cAnexos				:= If( ValType(cAnexos)  != "U" , cAnexos  , "" )
Local cErro_Conexao		:= ""
Local cErro_Envio			:= ""
Local cErro_Desconexao	:= ""
Local cCadastro			:= "Envio de e-mail"
Local lSmtpAuth			:= GetMV("MV_RELAUTH",,.F.)

If lMensagem
	IncProc("Conectando-se ao servidor de e-mail...")
EndIf

//������������������������������������������������������Ŀ
//� Executa conexao ao servidor mencionado no parametro. �
//��������������������������������������������������������
Connect Smtp Server cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lConexao

//����������������������������������������������������������������������������������Ŀ
//| Se configurado, efetua a autenticacao                                            |
//������������������������������������������������������������������������������������
If ( lSmtpAuth )
	//	lAutOk := MailAuth(cMailCtaAut,cMailSenha)
	lAutOk := MailAuth(GetMv("MV_RELACNT"),GetMv("MV_RELAPSW"))
Else
	lAutOk := .T.
EndIf

If !lConexao
	GET MAIL ERROR cErro_Conexao
	MailAviso(cCadastro,"Nao foi poss�vel estabelecer conex�o com o servidor - "+cErro_Conexao,"Sem Conex�o",lMensagem)
	lRet := .F.
EndIf

If lMensagem
	IncProc("Enviando e-mail...")
EndIf

//����������������������������Ŀ
//� Executa envio da mensagem. �
//������������������������������
If !Empty(cAnexos)
	Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT ATTACHMENT cANEXOS RESULT LenVIO
Else
	Send Mail From cMAILCONTA to cMAILDESTINO SubJect cASSUNTO BODY cTEXTO FORMAT TEXT RESULT LenVIO
EndIf

If !lEnvio
	Get Mail Error cErro_Envio
	MailAviso(cCadastro,"N�o foi poss�vel enviar a mensagem - "+cErro_Envio,"Falha de envio",lMensagem)
	lRet := .F.
EndIf

If lMensagem
	IncProc("Desconectando-se do servidor de e-mail...")
EndIf

//��������������������������������������Ŀ
//� Executa disconexao ao servidor SMTP. �
//����������������������������������������
DisConnect Smtp Server Result lDesconexao

If !lDesconexao
	Get Mail Error cErro_Desconexao
	MailAviso(cCadastro,"N�o foi poss�vel desconectar-se do servidor - "+cErro_Desconexao,"Descone��o",lMensagem)
	lRet := .F.
EndIf

Return(lRet)


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MAILAVISO �Autor  �Paulo Fernandes     � Data �  11/12/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para exibir aviso ou usar o conout para gravar no    ���
���          �Console.log                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function MailAviso(cCadastro,cTexto,cTitulo,lMensagem)
If lMensagem
	Aviso(	cCadastro,cTexto,{"&Ok"},,cTitulo)
Else
	Conout(	"Aviso do SendMail : Chamado pela FUNNAME() " + PROCNAME(4) + " - " + cTexto)
Endif

Return
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � CriaSX1  � Fun��o para verificar e criar grupos de perguntas            ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 15.09.04 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpA1: array com os conte�dos do arquivo de perguntas (SX1).            ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/

User Function CriaSx1(aRegs)

Local aAreaAnt	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ			:= 0
Local nY			:= 1

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(aRegs[nY,1]+aRegs[nY,2])
//	If !MsSeek(aRegs[nY,1]+(space(10 -len(rtrim(aRegs[nY,1]))))+aRegs[nY,2])

//	If !MsSeek(aRegs[nY,1]+(space(Len(SX1->X1_GRUPO) -len(rtrim(aRegs[nY,1]))))+aRegs[nY,2])
//	cPergVolta:= AllTrim(cPergAux) + Space(Len(SX1->X1_GRUPO)-Len(AllTrim(cPergAux)))
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return(Nil)

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RetCombo � Retorna o conte�do do combo de um campo                      ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 15.09.04 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1: campo que cont�m o combo                                         ���
���             � ExpC2: conte�do do campo a ser retornado                                ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpC3: descri��o do combo                                               ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RetCombo(cCampo, cChave)

Local aSx3Box	:= RetSx3Box( Posicione("SX3", 2, cCampo, "X3CBox()" ),,, 1 )

Return AllTrim( aSx3Box[aScan( aSx3Box, { |aBox| aBox[2] = cChave } )][3] )




/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   � VerRot   � Autor � Jaime Wikanski            �Data�04.11.2002���
����������������������������������������������������������������������������͹��
���Descricao  � Verifica se estou na rotina desejada                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function VerRot(cRotina)
//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                     						  		 	 �
//���������������������������������������������������������������������������
Local nActive   	:= 1
Local lExecRot 	:= .F.

//�������������������������������������������������������������������������Ŀ
//� Verifica a origem da rotina               								       �
//���������������������������������������������������������������������������
While !(PROCNAME(nActive)) == ""
	If Alltrim(Upper(PROCNAME(nActive))) $ Alltrim(Upper(cRotina))
		lExecRot := .T.
		Exit
	Endif
	nActive++
Enddo

Return(lExecRot)



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � QryArr   �Autor  � Silvio Cazela      � Data � 21/06/2001  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para rodar uma Query e retornar como Array          ���
�������������������������������������������������������������������������͹��
���Parametros� cQuery - Query SQL a ser executado                         ���
���Retorno   � aTrb   - Array com o conteudo da Query                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function QryArr(cQuery)

//��������������������������������������������������������������������������ͻ
//� Gravacao do Ambiente Atual e Variaveis para Utilizacao                   �
//�������������������������������������������������������������Silvio Cazelaͼ
Local aRet    := {}
Local aRet1   := {}
Local nRegAtu := 0
Local x       := 0

//��������������������������������������������������������������������������ͻ
//� Ajustes e Execucao da Query                                              �
//�������������������������������������������������������������Silvio Cazelaͼ
//cQuery := ChangeQuery(cQuery)
TCQUERY cQuery NEW ALIAS "_TRB"

//��������������������������������������������������������������������������ͻ
//� Montagem do Array para Retorno                                           �
//�������������������������������������������������������������Silvio Cazelaͼ
DbSelectArea("_TRB")
aRet1   := Array(fcount())
nRegAtu := 1

While !eof()
	For x:=1 to fcount()
		aRet1[x] := FieldGet(x)
	Next
	AADD(aRet,aclone(aRet1))
	DbSkip()
	nRegAtu += 1
Enddo

//��������������������������������������������������������������������������ͻ
//� Encerra Query e Retorna Ambiente                                         �
//�������������������������������������������������������������Silvio Cazelaͼ
DbSelectArea("_TRB")
_TRB->(DbCloseArea())

Return(aRet)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � VldHelp  � Autor � Marcos Eduardo Rocha  � Data �22/03/2005 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Checa a regra e exibe o Help no caso de retorno falso       ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico - Usada em validacoes SX3                          ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function VldHelp(cRegra,cHelp)

lReturn := &cRegra
If !lReturn
	Aviso("Aviso",OemToAnsi(cHelp),{"&Ok"})
EndIf

Return lReturn



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � MVALTPAR � Rotina para efetuar altera��o em par�metros                  ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 21.01.05 � Martinho                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 16.01.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � xx/xx/xx - Consultor - Descricao.                                       ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function MVALTPAR()

Local oDlgTit
//Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualiza��o do Par�metro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""

Local aRegs     := {}
Local cPerg     := U_CriaPerg("ALTPAR")

Private cParam	:= ""//"MV_DATAFIS"


aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro","","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
//  aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro"    ,"","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
lValidPerg(aRegs)
Pergunte(cPerg,.T.)

Do Case
	Case mv_par01==1
		cParam := "MV_DATAFIN"
		dbSelectArea("SE1")
		_cFilial := xFilial("SE1")
		SE1->(dbCloseArea())
	Case mv_par01==2
		cParam := "MV_DATAFIS"
		dbSelectArea("SF1")
		_cFilial := xFilial("SF1")
		SF1->(dbCloseArea())
		
EndCase

cTitulo	:= "Atualiza��o do Par�metro "+AllTrim(cParam) + " da Filial " + _cFilial

dbSelectArea("SX6")
dbSetOrder(1)
If !MsSeek(_cFilial+cParam)
	Aviso(	cTitulo,;
	"O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",;
	{"&Ok"},,;
	"Par�metro: "+AllTrim(cParam) )
Else
	cTexto1		:= SX6->X6_DESCRIC
	cTexto2		:= SX6->X6_DESC1
	cTexto3		:= SX6->X6_DESC2
	cTipo	    := SX6->X6_TIPO
	
	If   cTipo == "D"
		uConteudo	:= SToD(AllTrim(SX6->X6_CONTEUDO))
		
	ElseIf cTipo == "N"
		uConteudo	:= Val(AllTRim(SX6->X6_CONTEUDO))
	Else
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)
	EndIf
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuPar(uConteudo,cTipo), oDlgTit:End())
DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)


******************************************************************************************************
Static Function AtuPar(uConteudo)
******************************************************************************************************

dbSelectArea("SX6")
Reclock("SX6",.F.)

If cTipo == "D"
	SX6->X6_CONTEUD := DToS(uConteudo)
ElseIf cTipo == "N"
	SX6->X6_CONTEUD := Str(uConteudo)
Else
	SX6->X6_CONTEUD	:= AllTrim(uConteudo)
Endif
MsUnlock()

Return(Nil)


//*************************************************
//  ALTERA PARAMETRO DA DADTA LIMITE FATURAMENTO
//  Rodolfo Gaboardi 19/11/2007
//**************************************************

User Function MVPFAT()

Local oDlgTit
Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualiza��o do Par�metro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""
local _cCodFil := "  "
Local aRegs     := {}
//Local cPerg     := "ALTPAR"



//aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro","","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
//  aAdd(aRegs,{"ALTPAR","01","Parametro a ser alterado?","","","mv_ch1","N",1,0,0,"C","","mv_par01","Financeiro"    ,"","","","","Livros Fiscais","","","","","","","","","","","","","","","","","","","","","","","","",""})
//lValidPerg(aRegs)
//Pergunte(cPerg,.T.)

cParam := "BR_DATAFAT"
//_cCodFil:= ''
dbSelectArea("SF2")
_cFilial := xFilial("SF2")
SF2->(dbCloseArea())


If  (AllTrim(Upper(cUsername)) $ Upper(GetMv("BR_000025")))
	
	cTitulo	:= "Atualiza��o do Par�metro "+AllTrim(cParam) + " da Filial " + _cFilial
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !MsSeek(_cFilial+cParam)
		Aviso(	cTitulo,;
		"O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",;
		{"&Ok"},,;
		"Par�metro: "+AllTrim(cParam) )
	Else
		cTexto1		:= SX6->X6_DESCRIC
		cTexto2		:= SX6->X6_DESC1
		cTexto3		:= SX6->X6_DESC2
		cTipo	    := SX6->X6_TIPO
		
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)
		
	EndIf
	
	DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
	@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
	DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
	DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
	ACTIVATE MSDIALOG oDlgTit CENTERED
else
	
	Aviso(	"Altera��o da data Limite Faturamento",;
	"Usu�rio sem acesso � esta rotina! Contate o Administrador do sistema.",;
	{"&Continua"},,;
	"Parametro BR_000025")
	
endif

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)


******************************************************************************************************
Static Function AtuParf(uConteudo)
******************************************************************************************************
dbSelectArea("SX6")
Reclock("SX6",.F.)

SX6->X6_CONTEUD := (alltrim(uConteudo))

MsUnlock()

return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �U_AXTABELA� Autor �                       � Data � 04/02/98 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Edicao da tabela cTabela do SX5                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Avis Rent a Car                                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AxTabela(cTabela)

Private NOPCX,NUSADO,AHEADER,ACOLS,ARECNO
Private _CCODFIL,_CCHAVE,_CDESCRI,NQ,_NITEM,NLINGETD
Private CTITULO,AC,AR,ACGD,CLINHAOK,CTUDOOK
Private LRETMOD2,N

//���������������������������������Ŀ
//� Opcao de acesso para o Modelo 2 �
//�����������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx    := 3
nUsado   := 0
aHeader  := {}
aCols    := {}
aRecNo   := {}
_cTabela := cTabela // Defina aqui a Tabela para edicao

//�����������������������������Ŀ
//� Posiciona a filial corrente �
//�������������������������������

_cCodFil := xFilial("")

//������������������Ŀ
//� Montando aHeader �
//��������������������
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SX5")
While !Eof() .And. (X3_ARQUIVO == "SX5")
	If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL
		If AllTrim(X3_CAMPO) $ "X5_DESCRI*X5_CHAVE"
			nUsado:=nUsado+1
			Aadd(aHeader,{ AllTrim(x3_titulo), x3_campo, x3_Picture,;
			x3_tamanho, x3_decimal, x3_Valid ,;
			x3_usado, x3_tipo, x3_arquivo, x3_context } )
		EndIf
	EndIf
	dbSkip()
End

//����������������������������������������������������������Ŀ
//� Posiciona o Cabecalho da Tabela a ser editada (_cTabela) �
//������������������������������������������������������������
dbSelectArea("SX5")
dbSetOrder(1)

//�������������������������������������Ŀ
//� Cabecalho da tabela, filial � vazio �
//���������������������������������������
If !dbSeek(xFilial("")+"00"+_cTabela)
	Help(" ",1,"RFATAA21")
	MsgStop("Cadastrar Cabecalho da Tabela")
	Return
EndIf
_cChave  := AllTrim(SX5->X5_CHAVE)
_cDescri := SubStr(SX5->X5_DESCRI,1,35)

//��������������������������������������������������������������������������Ŀ
//� Montando aCols - Posiciona os itens da tabela conforme a filial corrente �
//����������������������������������������������������������������������������
dbSeek(_cCodFil+_cTabela)
While !Eof() .And. SX5->X5_FILIAL == _cCodFil .And. SX5->X5_TABELA==_cTabela
	Aadd(aCols ,Array(nUsado+1))
	Aadd(aRecNo,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]  := FieldGet(FieldPos(aHeader[nQ,2]))
		aRecNo[Len(aCols),nQ] := FieldGet(FieldPos(aHeader[nQ,2]))
	Next
	aRecNo[Len(aCols),nUsado+1] := RecNo()
	aCols[Len(aCols),nUsado+1]  := .F.
	dbSelectArea("SX5")
	dbSkip()
EndDo

_nItem := Len(aCols)
If Len(aCols)==0
	Aadd(aCols,Array(nUsado+1))
	For nQ:=1 to nUsado
		aCols[Len(aCols),nQ]:= CriaVar(FieldName(FieldPos(aHeader[nQ,2])))
	Next
	aCols[Len(aCols),nUsado+1] := .F.
EndIf

//���������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2 �
//�����������������������������������
nLinGetD:=0

//������������������Ŀ
//� Titulo da Janela �
//��������������������
cTitulo := _cDescri

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
Aadd(aC,{"_cChave" ,{15,10} ,"Tabela"   ,"@!"," ","",.f.})
Aadd(aC,{"_cDescri",{15,58} ,"Descricao","@!"," ","",.f.})

//��������������������������������������������������������������Ŀ
//� Nao utiliza o rodape, apesar de passar para Modelo 2         �
//����������������������������������������������������������������
aR:={}

//����������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2 �
//������������������������������������������������
aCGD:={44,5,118,315}

//������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2 �
//��������������������������������������
cLinhaOk:= "(!Empty(aCols[n,2]) .Or. aCols[n,3])"
cTudoOk := "AllwaysTrue()"

//��������������������Ŀ
//� Chamada da Modelo2 �
//����������������������
lRetMod2 := .F.
N        := 1
lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{"X5_CHAVE","X5_DESCRI"})

If lRetMod2
	
	Begin Transaction
	
	dbSelectAre("SX5")
	dbSetOrder(1)
	For n := 1 to Len(aCols)
		If aCols[n,Len(aHeader)+1] == .T.
			//����������������������������������������������������������Ŀ
			//� Filial e Chave e a chave indepEndente da descricao		 �
			//� que pode ter sido alterada               					 �
			//������������������������������������������������������������
			If dbSeek(_cCodFil+_cTabela+aCols[n,1])
				RecLock("SX5",.F.,.T.)
				dbDelete()
				MsUnlock()
			EndIf
		Else
			If dbSeek(xFilial("SF2")+_cTabela+aCols[n,1])
				If aCols[n,2] != SX5->X5_DESCRI
					RecLock("SX5",.F.)
					SX5->X5_CHAVE  := aCols[n,1]
					SX5->X5_DESCRI := aCols[n,2]
					MsUnlock()
				EndIf
			Else
				If _nItem >= n
					dbGoto(aRecNo[n,3])
					RecLock("SX5",.F.)
					SX5->X5_CHAVE := aCols[n,1]
					SX5->X5_DESCRI:= aCols[n,2]
					MsUnlock()
				ElseIf (!Empty(aCols[n,1]))
					RecLock("SX5",.T.)
					SX5->X5_FILIAL := _cCodFil
					SX5->X5_TABELA := _cTabela
					SX5->X5_CHAVE  := aCols[n,1]
					SX5->X5_DESCRI := aCols[n,2]
					MsUnlock()
				EndIf
			EndIf
		EndIf
	Next
	
	End Transaction
EndIf

Return





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VISX5    � Autor � Elias Reis         � Data �  26/10/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para visualizacao da Tabela SX5                     ���
���          � Solicitada pelo Setor Fiscal - Telma                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function VISX5

Private cCadastro := "Cadastro de . . ."
Private aRotina := { {"Pesquisar","AxPesqui",0,1} }
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SX5"

dbSelectArea("SX5")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse(6,1,22,75,cString)

Return

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � ProcExcel� Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de Faturamento por Produto                           ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function ProcExcel(cAlias)

Local oExcelApp
Local cArqTmp		:= CriaTrab( Nil,.F.)
Local cNomArqDes 	:= ""
Local cDirDocs   	:= MsDocPath()
Local cPath			:= AllTrim(GetTempPath())

dbSelectArea( cAlias )

Copy To &(cDirDocs+"\"+cArqTmp+".XLS") VIA "DBFCDXADS"

CpyS2T( cDirDocs+"\"+cArqTmp+".XLS" , cPath, .T. )

Ferase(cDirDocs+"\"+cArqTmp+".XLS")
//Copy To &(cDestino)

If ApOleClient( 'MsExcel' )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArqTmp+".XLS" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	oExcelApp:Destroy()
	
Else
	MsgStop(OemToAnsi("Microsoft Excel N�o Instalado"))
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �QryExcel  �Autor  � Jaime Wikanski     � Data � 21/06/2001  ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para rodar uma Query e retornar como Array          ���
�������������������������������������������������������������������������͹��
���Parametros� cQuery - Query SQL a ser executado                         ���
���Retorno   � aTrb   - Array com o conteudo da Query                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function QryExcel(lColuna,nBrancos,cQuery1,cQuery2,cQuery3,cQuery4,cQuery5,cQuery6,cQuery7,cQuery8,cQuery9,cQuery10)

//��������������������������������������������������������������������������ͻ
//� Gravacao do Ambiente Atual e Variaveis para Utilizacao                   �
//�������������������������������������������������������������Silvio Cazelaͼ
Local aRet    		:= {}
Local aRet1   		:= {}
Local aVazio 		:= {}
Local nRegAtu	 	:= 0
Local x       		:= 0
Local cQuery		:= ""
Local aEstru		:= {}
Local nX				:= 0
Local cVarEval		:= ""
Default nBrancos	:= 0
Default cQuery1	:= ""
Default cQuery2	:= ""
Default cQuery3	:= ""
Default cQuery4	:= ""
Default cQuery5	:= ""
Default cQuery6	:= ""
Default cQuery7	:= ""
Default cQuery8	:= ""
Default cQuery9	:= ""
Default cQuery10	:= ""
/*
Default cQuery11	:= ""
Default cQuery12	:= ""
Default cQuery13	:= ""
Default cQuery14	:= ""
Default cQuery15	:= ""
Default cQuery16	:= ""
Default cQuery17	:= ""
Default cQuery18	:= ""
Default cQuery19	:= ""
Default cQuery20	:= ""
Default cQuery21	:= ""
Default cQuery22	:= ""
Default cQuery23	:= ""
Default cQuery24	:= ""
Default cQuery25	:= ""
Default cQuery26	:= ""
Default cQuery27	:= ""
Default cQuery28	:= ""
Default cQuery29	:= ""
Default cQuery30	:= ""
Default cQuery31	:= ""
Default cQuery32	:= ""
Default cQuery33	:= ""
Default cQuery34	:= ""
Default cQuery35	:= ""
Default cQuery36	:= ""
Default cQuery37	:= ""
Default cQuery38	:= ""
Default cQuery39	:= ""
Default cQuery40  := "" */
Default lColuna	:= .T.

//�������������������������������������������������Ŀ
//�Monta a query com as diversas parcelas informadas�
//���������������������������������������������������
/*
For nX := 1 to 10 //40
cVarEval := "cQuery"+AllTrim(Str(nX))
cQuery += &(cVarEval) + Space(1)
Next
*/
cQuery := cQuery1 + Space(1) + cQuery2 + Space(1) + cQuery3 + Space(1) + cQuery4 + Space(1) + cQuery5 + Space(1) + ;
cQuery6 + Space(1) + cQuery7 + Space(1) + cQuery8 + Space(1) + cQuery9 + Space(1) + cQuery10 + Space(1)

//��������������������������������������������������������������������������ͻ
//� Ajustes e Execucao da Query                                              �
//�������������������������������������������������������������Silvio Cazelaͼ
//cQuery := ChangeQuery(cQuery)
If Select("_TRB") > 0
	DbSelectArea("_TRB")
	DbCloseArea()
Endif
TCQUERY cQuery NEW ALIAS "_TRB"

//��������������������������������������������������������������������������ͻ
//� Adiciona no array de retorno o cabecalho                                 �
//�������������������������������������������������������������Silvio Cazelaͼ
If lColuna
	aEstru := _TRB->(DbStruct())
	AADD(aRet,Array(Len(aEstru)))
	For nX := 1 to Len(aEstru)
		aRet[1,nX] := aEstru[nX,1]
	Next nX
Endif

//=MsGetArray(A1;siga("U_QRYEXCEL";T;"SELECT * FROM SE4010"))
//��������������������������������������������������������������������������ͻ
//� Montagem do Array para Retorno                                           �
//�������������������������������������������������������������Silvio Cazelaͼ
DbSelectArea("_TRB")
aRet1   := Array(fcount())
nRegAtu := 1

While !eof()
	For x:=1 to fcount()
		aRet1[x] := FieldGet(x)
	Next
	AADD(aRet,aclone(aRet1))
	DbSkip()
	nRegAtu += 1
Enddo

//����������������������������������������������������Ŀ
//�Insere linhas em branco depois do resultado da query�
//������������������������������������������������������
If nBrancos > 0
	aEstru := _TRB->(DbStruct())
	
	For nX := 1 to Len(aEstru)
		aAdd(aVazio,"")
	Next
	
	For nX := nRegAtu to nBrancos
		AADD(aRet,aclone(aVazio))
	Next
EndIf

//��������������������������������������������������������������������������ͻ
//� Encerra Query e Retorna Ambiente                                         �
//�������������������������������������������������������������Silvio Cazelaͼ
DbSelectArea("_TRB")
_TRB->(DbCloseArea())

Return(aRet)




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidaCpo �Autor  �Elias Reis          � Data �  25/04/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa que recebe o conteudo de um parametro, e verifica  ���
���          �se o usuario esta contido neste parametro. em caso negativo ���
���          �exibe uma mensagem, com o conteudo passado no 2 parametro.  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function ValidaCpo(cParam,cMens)

Local lRet  := .T.
Local aDados:= {}
Local cUser := SuperGetMV(cParam,.F.,"0")

//aDados := PswRet()

//If !Alltrim(aDados[1,2])$cUser
If !Alltrim(cUsername)$cUser
	MsgStop("Usuario ["+Alltrim(cUsername)+"] sem autorizacao para : " + chr(10) +;
	cMens + "!" +chr(10)+ "Contate os usuarios : " + cUser)
	lRet := .F.
EndIf

Return(lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GENXFUN   �Autor  �Microsiga           � Data �  05/18/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION RINDEX(cAlias)

LOCAL CONT := 0

DBSELECTAREA("SIX")
DBSETORDER(1)
IF DBSEEK(cAlias)
	WHILE !EOF() .AND. ALLTRIM(INDICE) == ALLTRIM(cAlias)
		CONT++
		DBSKIP()
	ENDDO
ENDIF

RETURN(CONT)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuCFO    �Autor  �Elias Reis          � Data �  13/10/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao disparada pelo campo C5_CLIENTE, que atualiza o CFOP���
���          � no aCols quanto acontecer uma mudanca de cliente!          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AtuCFO()

Local nPosCfo := 0
Local nPosTES := 0
Local cTES    := ""
Local aAreaSF4:= SF4->(GetArea())
Local aAreaSA1:= SA1->(GetArea())
Local aAreaSA2:= SA2->(GetArea())
Local lEncontrou := .F.

nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF" )})
nPosTES := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_TES")})

If !M->C5_TIPO $ "B/D
	dbSelectArea("SA1")
	dbSetOrder(1)
	lEncontrou := If(MsSeek(xFilial("SA1")+M->C5_CLIENTE),.T.,.F.)
Else
	dbSelectArea("SA2")
	dbSetOrder(1)
	lEncontrou := If(MsSeek(xFilial("SA2")+M->C5_CLIENTE),.T.,.F.)
EndIf

For ni := 1 To Len(aCols)
	
	dbSelectArea("SF4")
	dbSetOrder(1)
	
	cTES    := aCols[ni,nPosTES]
	
	If nPosCfo > 0 .And. MsSeek(xFilial("SF4")+cTes) .And. lEncontrou
		aDadosCfo := {}
		aAdd(aDadosCfo,{"OPERNF"	,"S"})
		aAdd(aDadosCfo,{"TPCLIFOR"	,If(!M->C5_TIPO $ "B/D", SA1->A1_TIPO , SA2->A2_TIPO)})
		aAdd(aDadosCfo,{"UFDEST"  	,If(!M->C5_TIPO $ "B/D", SA1->A1_EST  , SA2->A2_EST)})
		aAdd(aDadosCfo,{"INSCR"   	,If(!M->C5_TIPO $ "B/D", SA1->A1_INSCR, SA2->A2_INSCR)})
		aCols[ni][nPosCfo] := MaFisCfo( ,SF4->F4_CF,aDadosCfo )
	EndIf
	
Next

RestArea(aAreaSF4)
RestArea(aAreaSA1)
RestArea(aAreaSA2)

Return(.T.)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LOGLIBPV � Autor � Elias Reis            � Data � 30/09/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para gravacao do Log de Liberacao de Credito.       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function LOGLIBPV(cParam)

Local aAreaPA3	:= PA3->(GetArea())



If ((cParam = "MTA450I") .Or.;	//An.Credito Pedido 		(Item ou Lib.Total)
	(cParam = "MTA456I") )		  	//Liberac Cred.Estoque	(Item ou Lib.Total)
	
	
	DBSELECTAREA("SC9")
	DBSETORDER(1)
	MSSEEK(XFILIAL("SC9")+SC9->C9_PEDIDO)
	
	WHILE !EOF() .AND. SC6->C6_NUM = C9_PEDIDO
	
	  DBSELECTAREA("SC6")
	  DBSETORDER(1)
	  MSSEEK(XFILIAL("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM)
	  
	  dbSelectArea("PA3")
      DBSETORDER(1)
      If dbSeek(xFilial("PA3")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN)
		 RecLock("PA3",.F.)
	  ELSE
		RecLock("PA3",.T.)
		PA3->PA3_FILIAL	:= SC6->C6_FILIAL
		PA3->PA3_PEDIDO	:= SC6->C6_NUM
		PA3->PA3_ITEM	:= SC6->C6_ITEM
		PA3->PA3_SEQUEN	:= SC9->C9_SEQUEN
	ENDIF
	PA3->PA3_CODCLI	:= SC5->C5_CLIENTE
	PA3->PA3_NOMECL	:= SC5->C5_NOMECLI
	PA3->PA3_QTDEP		:= SC6->C6_QTDVEN
	PA3->PA3_QTDEL		:= SC9->C9_QTDLIB
	PA3->PA3_DATAL		:= dDatabase
	PA3->PA3_USER		:= Alltrim(cUsername)
	PA3->PA3_VLITEM	:= SC9->C9_QTDLIB * SC9->C9_PRCVEN
	PA3->PA3_ORIGEM	:= cParam
	PA3->(MsUnLock())
	DBSELECTAREA("SC9")
	SC9->(DBSKIP())
  ENDDO
ElseIf (cParam = "MTA450T") 		//An.Credito Pedido - Automatico
	
	If (LEN(SC9->C9_BLCRED) = 0)	//se esta condicao = True, e porque liberou
		
		If dbSeek(xFilial("PA3")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_SEQUEN)
			RecLock("PA3",.F.)
		ELSE
			RecLock("PA3",.T.)
			PA3->PA3_FILIAL	:= SC6->C6_FILIAL
			PA3->PA3_PEDIDO	:= SC6->C6_NUM
			PA3->PA3_ITEM		:= SC6->C6_ITEM
			PA3->PA3_SEQUEN	:= SC9->C9_SEQUEN
		ENDIF
		PA3->PA3_CODCLI	:= SC5->C5_CLIENTE
		PA3->PA3_NOMECL	:= SC5->C5_NOMECLI
		PA3->PA3_QTDEP		:= SC6->C6_QTDVEN
		PA3->PA3_QTDEL		:= SC9->C9_QTDLIB
		PA3->PA3_DATAL		:= dDatabase
		PA3->PA3_USER		:= Alltrim(cUsername)
		PA3->PA3_VLITEM	:= SC9->C9_QTDLIB * SC9->C9_PRCVEN
		PA3->PA3_ORIGEM	:= cParam
		PA3->(MsUnLock())
	EndIf
	
EndIf

dbCloseArea()

Return(Nil)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FilCTT_X1� Autor � Elias Reis            � Data � 11/07/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao que preenche automaticamente o C.Cuso/to nos parame-���
���          � tros dos relatorio CTBR360/CTBR400 impedindo que usuarios  ���
���Observacao� vejam gastos de C.Custo diferente do c.custo ao qual ele   ���
���          � pertence, conf. os 4 ultimos caraceres do depto do usuario ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FilCTT_X1()
Local aUser  := {}
Local cCampo := ""

PswOrder(2)

If PswSeek(cUsername,.t.)
	aUser := PswRet() // Retorna vetor com informacoes do usuario
EndIf

cCampo := AllTrim(aUser[1,13])

//1352*1353/1352*1353/1352*1353
cInicio := Substr(cCampo,01,4)
cFim    := Substr(cCampo,06,4)

If Len(AllTrim(cCampo))>0
	
	If FunName()=='CTBR360'
		If  mv_par05 < cInicio .Or.  mv_par05 > cFim
			mv_par05 := cInicio
		EndIf
		
		If  mv_par06 < cInicio .Or.  mv_par06 > cFim
			mv_par06 := cFim
		EndIf
	ElseIF FunName()=='CTBR400'
		If  mv_par13 < cInicio .Or.  mv_par13 > cFim
			mv_par13 := cInicio
		EndIf
		
		If  mv_par14 < cInicio .Or.  mv_par14 > cFim
			mv_par14 := cFim
		EndIf
	EndIf
	
EndIf

Return .T.



User Function RetEAN(cProduto)

Local cQuery   := ""
Local cCodEAN  := Space(15)
Local aAreaAtu := GetArea()

cQuery := " SELECT TOP 1 B1_COD "
cQuery += " FROM "+RetSQLName("SG1")+" SG1, "+RetSQLName("SB1")+" SB1 "
cQuery += " WHERE
cQuery += "     G1_FILIAL = '01'"
cQuery += " AND G1_COD='"+cProduto+"'"
cQuery += " AND G1_COMP=B1_COD "
cQuery += " AND SG1.D_E_L_E_T_='' "
cQuery += " AND SB1.D_E_L_E_T_='' "
cQuery += " AND B1_TIPO = 'EM' "
cQuery += " ORDER BY G1_COD, G1_COMP "

MemoWrite("\QUERYSYS\TESTE.SQL",cQuery)
If Select("RETEAN")>0
	dbSelectArea("RETEAN")
	RETEAN->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "RETEAN"

If Select("RETEAN")>0
	cCodEAN := RETEAN->B1_COD
EndIf

RETEAN->(dbCloseArea())

RestArea(aAreaAtu)

Return(cCodEAN)

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraCSV� Autor � Cleiton                  � Data � 20/03/2008 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Geracao de CSV                                      ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function GeraCSV(cAlias, lExcel)

Private _cDirDocs := MsDocPath()
Private cArqTxt   := _cDirDocs + "\" + CriaTrab("", .f.)
Private nHdl      := fCreate(cArqTxt)
Private cEOL      := CHR(13)+CHR(10)
Private cTexto    := ""

lExcel  		  := Iif(lExcel == Nil, .t., lExcel)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

dbSelectArea( cAlias )
DbGoTop()

aStru  := DbStruct()
cTexto := ""
For nCont := 1 To FCount()
	cTexto += FieldName(nCont) + ";"
Next

cTexto += cEOL
fWrite(nHdl,cTexto)

Do While !Eof()
	cTexto := ""
	For nCont := 1 To FCount()
		nPos := aScan(aStru, {|x| AllTrim(x[1]) = AllTrim(FieldName(nCont))})
		
		If aStru[nPos, 2] == "N"
			cPict  := Repl("9", aStru[nPos, 3])
			If aStru[nPos, 4] > 0
				cPict += "." + Repl("9", aStru[nPos, 4])
			EndIf
			
			cTexto += Transform(FieldGet(nCont), "@E" + cPict) + ";"
		ElseIf aStru[nPos, 2] == "D"
			cTexto += DtoC(FieldGet(nCont)) + ";"
		Else
			cTexto += AllTrim(FieldGet(nCont)) + ";"
		EndIf
	Next
	
	cTexto += cEOL
	fWrite(nHdl,cTexto)
	
	dbSkip()
EndDo

fClose(nHdl)
fRename(cArqTxt, cArqTxt + ".csv")


If lExcel .And. ApOleClient( 'MsExcel' )
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqTxt + ".csv" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	//oExcelApp:Destroy()
ElseIf lExcel
	MsgStop(OemToAnsi("Microsoft Excel N�o Instalado"))
EndIf

Return cArqTxt + ".csv"


//********************** ALTERA��O DE PARAMETROS PARA REL. REAL X OR�ADO
USER FUNCTION MVPARDRE
Local oDlgTit
Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualiza��o do Par�metro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""
local _cCodFil := "  "
Local aRegs     := {}

_cFilial:=xfilial("SX6")

_cCtrlMv:=0

WHILE .T.
	_cCtrlMv:=_cCtrlMv+1
	
	do case
		case _cCtrlMv=1
			cParam := 'BR_ORCDIR'
		case _cCtrlMv=2
			cParam := 'BR_ORCIND'
		case _cCtrlMv=3
			cParam := 'BR_ORCADM'
		case _cCtrlMv=4
			cParam := 'BR_ORCCOM'
		case _cCtrlMv=5
			cParam := 'BR_ORCMKT'
		Otherwise
			exit
	endcase
	
	cTitulo	:= "Atualiza��o do Par�metro "+AllTrim(cParam) + " da Filial " + _cFilial
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !MsSeek(_cFilial+cParam)
		Aviso(	cTitulo,;
		"O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",;
		{"&Ok"},,;
		"Par�metro: "+AllTrim(cParam) )
	Else
		cTexto1		:= SX6->X6_DESCRIC
		cTexto2		:= SX6->X6_DESC1
		cTexto3		:= SX6->X6_DESC2
		cTipo	    := SX6->X6_TIPO
		
		uConteudo	:= SX6->X6_CONTEUDO    //AllTrim(SX6->X6_CONTEUDO)
	EndIf
	

	DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
	@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 037,135 GET uConteudo SIZE 110,10 OF oDlgTit PIXEL

	DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
	DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
	ACTIVATE MSDIALOG oDlgTit CENTERED

ENDDO
U_ZANAPAR()	
RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)


user function ZANAPAR()

_cCtrlMv:=0

WHILE .T.
	_cCtrlMv:=_cCtrlMv+1
	
	do case
		case _cCtrlMv=1
			cParam1 := 'BR_ORCDIR1'
		case _cCtrlMv=2
			cParam1 := 'BR_ORCIND1'
		case _cCtrlMv=3
			cParam1 := 'BR_ORCADM1'
		case _cCtrlMv=4
			cParam1 := 'BR_ORCCOM1'
		case _cCtrlMv=5
			cParam1 := 'BR_ORCMKT1'
		Otherwise
			exit
	endcase
	
	cTitulo1	:= "Atualiza��o do Par�metro "+AllTrim(cParam1) + " da Filial " + _cFilial
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !MsSeek(_cFilial+cParam1)
		Aviso(	cTitulo1,;
		"O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",;
		{"&Ok"},,;
		"Par�metro: "+AllTrim(cParam1) )
	Else
		cTexto11		:= SX6->X6_DESCRIC
		cTexto21		:= SX6->X6_DESC1
		cTexto31		:= SX6->X6_DESC2
		cTipo1		    := SX6->X6_TIPO
		
		uConteudo1		:= SX6->X6_CONTEUDO    //AllTrim(SX6->X6_CONTEUDO)
	EndIf
	

	DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlgTit1 TITLE cTitulo1 FROM 0,0 TO 160,500 OF oMainWnd PIXEL
	@ 003,007 SAY cTexto11 OF oDlgTit1 PIXEL FONT oFont COLOR CLR_HBLUE
	@ 013,007 SAY cTexto21 OF oDlgTit1 PIXEL FONT oFont COLOR CLR_HBLUE
	@ 023,007 SAY cTexto31 OF oDlgTit1 PIXEL FONT oFont COLOR CLR_HBLUE
	@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit1 PIXEL FONT oFont COLOR CLR_HBLUE
	@ 037,135 GET uConteudo1 SIZE 110,10 OF oDlgTit1 PIXEL

	DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit1 PIXEL ACTION(AtuParf(uConteudo1,cTipo1), oDlgTit1:End())
	DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit1 PIXEL ACTION(oDlgTit1:End())
	ACTIVATE MSDIALOG oDlgTit1 CENTERED

ENDDO

RETURN


// Cleiton - 04/12/2008
// Valida a existencia do campo na tabela envolvida
//----------------------------------
User Function ValCpo(cAlias, cCampo)
//----------------------------------
aAlias := GetArea()

DbSelectArea(cAlias)
For nC := 1 To FCount()
	If Upper(AllTrim(FieldName(nC))) == Upper(AllTrim(cCampo))
		RestArea(aAlias)
		Return .t.
	EndIf
Next

RestArea(aAlias)
Return .f.



//Thiago - 16-09-2009
//Preenche o 'cPerg' com espa�os de acordo com o tamanho do campo X1_GRUPO

//Exemplo: cPerg:= U_CriaPerg("MTR450")
 
User Function CriaPerg(cPergAux)
***********************
Local cPergVolta:= ""

cPergVolta:= AllTrim(cPergAux) + Space(Len(SX1->X1_GRUPO)-Len(AllTrim(cPergAux)))

Return(cPergVolta)                                      







//*************************************************
//  ALTERA PARAMETRO TABELA DE PRE�O ATIVA
//  Rodolfo Gaboardi 19/11/2007
//**************************************************

User Function MVTAT()

Local oDlgTit
Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualiza��o do Par�metro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""
local _cCodFil := "  "
Local aRegs     := {}

cParam := "BR_000087"
//_cCodFil:= ''


	cTitulo	:= "Atualiza��o do Par�metro "+AllTrim(cParam)
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !MsSeek(space(2)+alltrim(cParam))
		Aviso(	cTitulo,;
		"O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",;
		{"&Ok"},,;
		"Par�metro: "+AllTrim(cParam) )
	Else
		cTexto1		:= SX6->X6_DESCRIC
		cTexto2		:= SX6->X6_DESC1
		cTexto3		:= SX6->X6_DESC2
		cTipo	    := SX6->X6_TIPO
		
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)
		
	EndIf
	
	DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
	@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
	DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
	DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
	ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)


//*************************************************
//  ALTERA PARAMETRO TABELA DE PRE�O ATIVA
//  Rodolfo Gaboardi 19/11/2007
//**************************************************

User Function MVTATFR()

Local oDlgTit
Local cParam	:= ""//"MV_DATAFIS"
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""//"Atualiza��o do Par�metro "+AllTrim(cParam)
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""
local _cCodFil := "  "
Local aRegs     := {}

cParam := "BR_000089"
//_cCodFil:= ''


	cTitulo	:= "Atualiza��o do Par�metro "+AllTrim(cParam)
	
	dbSelectArea("SX6")
	dbSetOrder(1)
	If !MsSeek(space(2)+alltrim(cParam))
		Aviso(	cTitulo,;
		"O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",;
		{"&Ok"},,;
		"Par�metro: "+AllTrim(cParam) )
	Else
		cTexto1		:= SX6->X6_DESCRIC
		cTexto2		:= SX6->X6_DESC1
		cTexto3		:= SX6->X6_DESC2
		cTipo	    := SX6->X6_TIPO
		
		uConteudo	:= AllTrim(SX6->X6_CONTEUDO)
		
	EndIf
	
	DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
	@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
	@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
	DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
	DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
	ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)

//**********************************************************
//*   Informa a tabela do pedido de exporta��o que devera  *
//*   ser bloqueado.                                       *
//**********************************************************
User Function BR000090()

Local oDlgTit
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""
local _cCodFil	:= "  "
Local aRegs     := {} 
Local cParam	:= 'BR_000090'

cTitulo:= "Atualiza��o do Par�metro " + AllTrim(cParam)

DbSelectArea("SX6")
DbSetOrder(1)

If !MsSeek( Space(2) + alltrim(cParam) )
	Aviso(	cTitulo, "O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",	{"&Ok"},, "Par�metro: " + AllTrim(cParam) )
	Return(Nil)
Else
	cTexto1:= SX6->X6_DESCRIC
	cTexto2:= SX6->X6_DESC1
	cTexto3:= SX6->X6_DESC2
	cTipo  := SX6->X6_TIPO
	
	uConteudo:= SX6->X6_CONTEUDO
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)
//**********************************************************
//*  Informa qeum podera liberar os pedidos de exporta��o  *
//*  bloqueados.                                           *
//**********************************************************
User Function BR000091()

Local oDlgTit
Local aAreaAtu	:= GetArea()
Local aAreaSX6	:= SX6->(GetArea())
Local cTitulo	:= ""
Local cTexto1	:= ""
Local cTexto2	:= ""
Local cTexto3	:= ""
Local uConteudo	:= ""
local _cCodFil	:= "  "
Local aRegs     := {} 
Local cParam	:= 'BR_000091'

cTitulo:= "Atualiza��o do Par�metro " + AllTrim(cParam)

DbSelectArea("SX6")
DbSetOrder(1)

If !MsSeek( Space(2) + alltrim(cParam) )
	Aviso(	cTitulo, "O par�metro informado n�o foi localizado no cadastro! Contate o Administrador.",	{"&Ok"},, "Par�metro: " + AllTrim(cParam) )
	Return(Nil)
Else
	cTexto1:= SX6->X6_DESCRIC
	cTexto2:= SX6->X6_DESC1
	cTexto3:= SX6->X6_DESC2
	cTipo  := SX6->X6_TIPO
	
	uConteudo:= SX6->X6_CONTEUDO
EndIf

DEFINE FONT oFont NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlgTit TITLE cTitulo FROM 0,0 TO 160,500 OF oMainWnd PIXEL
@ 003,007 SAY cTexto1 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 013,007 SAY cTexto2 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 023,007 SAY cTexto3 OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 040,007 SAY "Informe o novo conte�do para o par�metro:" OF oDlgTit PIXEL FONT oFont COLOR CLR_HBLUE
@ 037,135 GET uConteudo Valid(!Empty(uConteudo)) SIZE 110,10 OF oDlgTit PIXEL
DEFINE SBUTTON oBut2 FROM 060,175 TYPE 1 ENABLE OF oDlgTit PIXEL ACTION(AtuParf(uConteudo,cTipo), oDlgTit:End())
DEFINE SBUTTON oBut3 FROM 060,215 TYPE 2 ENABLE OF oDlgTit PIXEL ACTION(oDlgTit:End())
ACTIVATE MSDIALOG oDlgTit CENTERED

RestArea(aAreaSX6)
RestArea(aAreaAtu)

Return(Nil)