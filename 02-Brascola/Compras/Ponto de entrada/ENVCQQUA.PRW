#INCLUDE "RWMAKE.CH"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � EnvCQQua � Autor � Marcos Eduardo Rocha     � Data � 05/09/05 ���
����������������������������������������������������������������������������Ĵ��
��� Rotina : MATA103 - Documento de entrada.                                 ���
��� Fun��o : Ponto de Entrada para nao enviar ao Almxarifado de CQ as        ���
���          entradas especificadas.                                         ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function EnvCqQua()       

Local lRet

//If SA2->A2_COD          $ ( "000004*000003" ) .And. SM0->M0_CODFIL $ ( "01*" )
//   lRet:= .f.
If ( SM0->M0_CODFIL $ "03*04" )// .And. SA2->A2_COD $ ( "000002" )  .And. SB1->B1_TIPO = '3' 
   lRet:= .f.
/*ElseIf ( SM0->M0_CODFIL $ "01" ) .And. SB1->B1_TIPO = '4' 
   lRet:= .f.
ElseIf ( SM0->M0_CODFIL $ "01" ) .And. Substr( SB1->B1_COD, 8, 2 ) <> '5' .And. SA2->A2_COD $ GETMV("BR_000046")
   lRet:= .f.
ElseIf SF1->F1_ESPECIE = 'NFTBR'
   lRet:= .f.
*/
ElseIf ( SA2->A2_EST = 'EX' ) .And. ( SB1->B1_TIPOCQ = 'Q' )
   lRet:= .f.	   
ElseIf( SM0->M0_CODFIL $ "01" )
   lRet:= .t.
Else
   lRet:= .f.
Endif

Return( lRet ) 