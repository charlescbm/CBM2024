# INCLUDE "RWMAKE.CH"
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA07  � Autor � Sergio Lacerda        � Data � 20/05/2005���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para validacao de quem pode alterar a data de Entrega���
��������������������������������������������������������������������������Ĵ��
���Observacao�alerado por Rodolfo para nao permitir digitar data de entrega
��              mais que 60 dias                                           ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function EFATA07()

Local lRet:= .T.

dbSelectArea("SA3")
dbSetOrder(7)
If dbSeek(xFilial("SA3")+__cUserId) 

 _grpven:=POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_GRPVEN")
   
//Fernando: 07.01.12: colocado trecho em comentario
   /*	//If A3_TIPO <> 'I' .AND. M->C6_ENTREG > DDATABASE + 90  
	  IF A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '03' .AND. M->C6_ENTREG >  DDATABASE + 200 .AND. M->C5_AMOSTRA = '6' .and. M->C5_EMISSAO > '20101201' .AND. M->C5_EMISSAO < '20101231' 
	     lRet := .F.
	  
	  ELSEIF A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '03' .AND. M->C6_ENTREG >  STOD('20110630') .AND. M->C5_AMOSTRA <> '6'
	     lRet := .F.
	  
	  elseif  A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $  '04*02*01*08' .AND. (M->C6_ENTREG >  DDATABASE + 60 .OR.  M->C6_ENTREG < DDATABASE + 5 ) .and. !_grpven $ '000023*000014'
	 //    elseif  A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $  '04*02*01*08' .AND. (M->C6_ENTREG > STOD('20100830') .OR.  M->C6_ENTREG < DDATABASE + 10 ) .and. !_grpven $ '000023*000014' 
	     lRet := .F.
	  elseif  A3_TIPO $ 'I*E' .and. _grpven $ '000023*000014' .AND. M->C6_ENTREG >  DDATABASE + 200 .AND. M->C5_AMOSTRA == '6'
	     lRet := .F.
	 // IF A3_TIPO $ 'I*E' .AND. M->C6_ENTREG >  stod('20090119')
	 elseif  A3_TIPO $ 'I*E' .and. _grpven $ '000023*000014' .AND. M->C6_ENTREG >  STOD('20110630') .AND. M->C5_AMOSTRA <> '6'
	     lRet := .F.
	 EndIf  */  
	 //Fernando: 07.01.12 adicionado este trecho
	 If  A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $  '04*02*01*08' .AND. (M->C6_ENTREG >  DDATABASE + 60 .OR.  M->C6_ENTREG < DDATABASE + 5 ) .and. !_grpven $ '000004'
	     lRet := .F.
	 EndIf
EndIf
dbSetOrder(1)

If lRet == .F.
   MsgBox(OemToAnsi("Usu�rio sem permiss�o para utilizar mais de 60 dias na data de entrega  ou a data de entrega deve ser  menor que 5 dias"))
   //MsgBox(OemToAnsi("Usu�rio sem permiss�o para utilizar data de entrega > 30/08/10"))
EndIf

Return(lRet)