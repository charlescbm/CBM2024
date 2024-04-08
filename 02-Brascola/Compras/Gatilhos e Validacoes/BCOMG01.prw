#INCLUDE "RWMAKE.CH"  
#INCLUDE 'TOPCONN.CH'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BCOMG01  �Autor  �Charles Medeiros   � Data �  11/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para validar Fornecedor autorizado a vender Produto ���
���          �   verifica tabela SA5 Produto x Fornecedor - Campo A5_SITU ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BCOMG01(LRet)

Local lRet     := .t.
Local cCodFor  := CA120FORN   
Local cCodLog  := CA120Loj
Local cCodPro  := ''

//������������������������������������������������������������������������Ŀ
//�            Posiciona no vendedor correspondente ao usuario             �
//��������������������������������������������������������������������������
DbSelectArea('SA5')
DbSetOrder(2)  

If SA5->(DbSeek(xFilial("SA5")+(M->C7_PRODUTO+cCodFor+cCodLog)))  
	
	If SA5->A5_SITU == 'D'  
		lRet := .f.
		MsgStop ("Produto n�o Autorizado para esse Fornecedor. Verificar com Laborat�rio") 
	Endif
	
Endif	
	
	
Return(lRet)