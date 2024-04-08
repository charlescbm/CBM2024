# INCLUDE "RWMAKE.CH"
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA16  � Autor � Rodolfo Gabioardi      � Data � 23/09/08 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para validacao de quem pode alterar a data de Entrega���
��������������������������������������������������������������������������Ĵ��
���                          ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function EFATA17()

Local lRet:= .T.
LOCAL aArea:= GetArea()
                                                                  
DBSELECTAREA("DA1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("DA1")+M->C5_TABELA+m->c6_produto)
   IF DA1->DA1_ATIVO == '2'
       lRet:= .F.
   ENDIF
ENDIF
       
If lRet == .F.
	MsgBox(OemToAnsi("Produto Bloqueado ,esta  fora de linha."))
EndIf

IF SUBSTR(M->C6_PRODUTO,1,1) <> 'A' .AND. M->C5_CONDPAG ==' '
	MsgBox(OemToAnsi("Condicao de Pagamento invalida ,utilizada so para amostra"))
    lRet := .F.
endif
    
Return(lRet)