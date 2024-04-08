# INCLUDE "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ EFATA06  ³ Autor ³ Sergio Lacerda        ³ Data ³ 20/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para validacao de quem pode alterar a data de Entrega³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³    ALETERADO PARA PERMITIR SOMENTE INCLUSAO DE PEDIDOS COM  ³±± 
±±             DATA MENOR QUE 60 DIAS                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER FUNCTION EFATA06()

Local lRet:= .T.
//nPos1       := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ENTREG"  })
dbSelectArea("SA3")
dbSetOrder(7)
If dbSeek(xFilial("SA3")+__cUserId)

       _grpven:=POSICIONE("SA1",1,XFILIAL("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_GRPVEN")

   		/* 07.01.12 -> Fernando: colocado trecho de código em comentário
   		//	IF A3_TIPO <> 'I' .AND. M->C5_ENTREGA > DDATABASE + 90
	    IF A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '03' .AND.  (M->C5_ENTREGA > DDATABASE + 200) .AND. M->C5_AMOSTRA == '6'     // ALTERADO POR RODOLFO A PEDIDO DA ANDREIA ADM
	        lRet := .F.   
	     ELSEIF A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '03' .AND.  (M->C5_ENTREGA > STOD('20110630')) .AND. M->C5_AMOSTRA <> '6'     // ALTERADO POR RODOLFO A PEDIDO DA ANDREIA ADM   
	       	lRet := .F.   
	     elseIF A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '01*08*02*03*04' .and. (M->C5_ENTREGA > DDATABASE + 60 .OR.  M->C5_ENTREGA < DDATABASE + 5 ) .AND. !_grpven $ '000023*000014'
	 	   //elseIF A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '01*08*02*04' .and. (M->C5_ENTREGA > STOD('20100830') .OR.  M->C5_ENTREGA < DDATABASE + 10 ) .AND. !_grpven $ '000023*000014' 
	 	    lRet := .F.                                                                                  
	 	 elseIF A3_TIPO $ 'I*E' .and. _grpven $ '000023*000014' .AND.  (M->C5_ENTREGA > DDATABASE + 200) .AND. M->C5_AMOSTRA == '6' 
	 	    lRet := .F.
	 	 elseIF A3_TIPO $ 'I*E' .and. _grpven $ '000023*000014' .AND.  (M->C5_ENTREGA > STOD('20110630')) .AND. M->C5_AMOSTRA <> '6'   
	     	lRet := .F.
	     EndIf*/
		If A3_TIPO $ 'I*E' .AND. SM0->M0_CODFIL $ '01*03' .and. (M->C5_ENTREGA > DDATABASE + 60 ) .AND. !_grpven $ '000004'//Grupo de Clientes(Calcados:000004)
	 	   lRet := .F.
	 	EndIf 
	   
EndIf
dbSetOrder(1)
/*
IF lret = .t.
   For n:=1 to len(acols)
       acols[n,nPos1] := M->C5_ENTREGA
   next 
endif
*/
IF lRet == .F.
   	MSGBOX("Usuario sem permissao para utilizar mais de 60 dias na data de entrega ou a data de entrega deve ser maior que 7 dias" )
   	//MSGBOX("Usuario sem permissao para utilizar a data de entrega > 30/08/2010 ou a data de entrega deve ser maior que 10 dias")
EndIf


RETURN(lRet)