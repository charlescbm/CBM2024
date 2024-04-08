#include "rwmake.ch"
#include "topconn.ch"
#include "folder.ch"        
#include "font.ch"
#include "colors.ch"
#include "msgraphi.ch"
#include "protheus.ch"
#include "goldenview.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BFAG011  �Autor  � Marcelo da Cunha   � Data �  01/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � GDView Faturamento                                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
        
//Fernando: 26/03/14 - Referente chamado nr.: 6539
User Function GDVUltDtMoeda()
**************************
LOCAL dRetu := MsDate()
SM2->(dbSetOrder(1))
SM2->(dbSeek(dtos(dRetu),.T.))
While !SM2->(Bof())
 If (SM2->M2_moeda2 > 0)
  dRetu := SM2->M2_data
  Exit
 Endif
 SM2->(dbSkip(-1))
Enddo
Return dRetu