#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT110TOK � Autor � Fernando              � Data � 13/03/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PE que faz valida��o ao confirmar SC                       ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT110TOK()

Local lRet    := .T.         

//��������������������������������������������������������������Ŀ
//| Abertura do ambiente    
//����������������������������������������������������������������


/////verifica se o C�digo do Comprador foi selecionado/////
If Empty(cCodCompr) 
   /*Help(cHelp,nLinha, cTitulo, uPar4,cMensagem,nLinMen,nColMen)
    Parametros
   	cHelp    : Nome da Rotina chamadora do help. (sempre branco)
	nLinha   : N�mero da linha da rotina chamadora. (sempre 1)
	cTitulo  : T�tulo do help
	uPar4    : Sempre NIL
	cMensagem: Mensagem a ser exibida para o Help.
	nLinMen  : N�mero de linhas da Mensagem. (relativa � janela)
	nColMen  : N�mero de colunas da Mensagem. (relativa � janela)
   */
	Help("",1,"BRASCOLA",,OemToAnsi("Favor informar Comprador no Cabe�alho da Solicita��o"),1,0 )
	lRet := .F.
End        

Return(lRet)
