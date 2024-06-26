#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M440SC9I  �Autor  �Daniel Pelegrinelli � Data �  10/17/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclui o Campo C9_X_LBFIN para controle de credito apos li- ���
���          �beracao.                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA440C9()
**********************
LOCAL cAlias := GetArea()
LOCAL cTes := ''

If AllTrim(FunName()) $ "MATA440/MATA410"
	IF (SC5->(dbseek(xfilial("SC5")+SC9->C9_PEDIDO)))
		If !SC5->C5_TIPO $ ('B/D')
			IF !SC5->C5_CONDPAG $ ('098/099/097/017')
				cTes := SC6->C6_tes
				If !ALLTRIM(SF4-> F4_CF) $ GETMV("BR_CFBON")
					RecLock("SC9",.F.)
					C9_BLCRED := '01'
					SC9->(MsUnLock())
				Endif
			Endif
		Endif
	Endif
Endif

////////////////////////////////////////
// 10/03/2014 - Marcelo ////////////////
////////////////////////////////////////
M440VerPed()
////////////////////////////////////////

RestArea(cAlias)

Return                                  

Static Function M440VerPed()
**************************
LOCAL cTitulo, cTexto, cEmail, cQuery

If (SC6->C6_qtdemp < 0)
	cTitulo := "[MTA440C9] Registro com Problema: "+SC9->C9_pedido+SC9->C9_item
	cTexto  := "Pedido "+SC9->C9_pedido+" item "+SC9->C9_item+" com saldo empenhado no C6_QTDEMP menor que ZERO.<br>"
	cTexto  += "C6_NUM+C6_ITEM: "+SC6->C6_num+SC6->C6_item+"<br>"
	cTexto  += "C6_QTDVEN: "+Alltrim(Transform(SC6->C6_qtdven,PesqPict("SC6","C6_QTDVEN")))+"<br>"
	cTexto  += "C6_QTDEMP: "+Alltrim(Transform(SC6->C6_qtdemp,PesqPict("SC6","C6_QTDEMP")))+"<br>"
	cTexto  += "C9_QTDLIB: "+Alltrim(Transform(SC9->C9_qtdlib,PesqPict("SC9","C9_QTDLIB")))+"<br>"
	cEmail  := "charlesm@brascola.com.br;marcelo@goldenview.com.br;fmaia@brascola.com.br"
	u_GDVWFAviso("PEDLIB","100001",cTitulo,cTexto,cEmail)
Endif

//Verifico todas as liberacoes do item
//////////////////////////////////////                                                                       
cQuery := "SELECT SUM(C9_QTDLIB) C9_QTDLIB,SUM(CASE WHEN C9_BLEST='' AND C9_BLCRED='' THEN C9_QTDLIB ELSE 0 END) C9_QTDEMP "  
cQuery += "FROM "+RetSqlName("SC9")+" C9 WHERE C9.D_E_L_E_T_ = '' AND C9.C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery += "AND C9.C9_PEDIDO = '"+SC9->C9_pedido+"' AND C9.C9_ITEM = '"+SC9->C9_item+"' "
If (Select("MSC9") <> 0)
	dbSelectArea("MSC9")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MSC9"
dbSelectArea("MSC9")
If !MSC9->(Eof())
	If (SC6->C6_qtdemp > MSC9->C9_qtdemp)
		cTitulo := "[MTA440C9] Registro com Problema: "+SC9->C9_pedido+SC9->C9_item
		cTexto  := "Pedido "+SC9->C9_pedido+" item "+SC9->C9_item+" possui quantidade empenhada maior que o pedido.<br>"
		cTexto  += "C6_NUM+C6_ITEM: "+SC6->C6_num+SC6->C6_item+"<br>"
		cTexto  += "C6_QTDVEN: "+Alltrim(Transform(SC6->C6_qtdven,PesqPict("SC6","C6_QTDVEN")))+"<br>"
		cTexto  += "C6_QTDEMP: "+Alltrim(Transform(SC6->C6_qtdemp,PesqPict("SC6","C6_QTDEMP")))+"<br>"
		cTexto  += "C9_QTDLIB: "+Alltrim(Transform(MSC9->C9_qtdlib,PesqPict("SC9","C9_QTDLIB")))+"<br>"
		cTexto  += "C9_QTDEMP: "+Alltrim(Transform(MSC9->C9_qtdemp,PesqPict("SC9","C9_QTDLIB")))+"<br>"
		cEmail  := "charlesm@brascola.com.br;marcelo@goldenview.com.br;fmaia@brascola.com.br"
		u_GDVWFAviso("PEDLIB","100002",cTitulo,cTexto,cEmail)
	Endif
	If (MSC9->C9_qtdlib > SC6->C6_qtdven)
		cTitulo := "[MTA440C9] Registro com Problema: "+SC9->C9_pedido+SC9->C9_item
		cTexto  := "Pedido "+SC9->C9_pedido+" item "+SC9->C9_item+" possui quantidade liberada maior que o pedido.<br>"
		cTexto  += "C6_NUM+C6_ITEM: "+SC6->C6_num+SC6->C6_item+"<br>"
		cTexto  += "C6_QTDVEN: "+Alltrim(Transform(SC6->C6_qtdven,PesqPict("SC6","C6_QTDVEN")))+"<br>"
		cTexto  += "C6_QTDEMP: "+Alltrim(Transform(SC6->C6_qtdemp,PesqPict("SC6","C6_QTDEMP")))+"<br>"
		cTexto  += "C9_QTDLIB: "+Alltrim(Transform(MSC9->C9_qtdlib,PesqPict("SC9","C9_QTDLIB")))+"<br>"
		cTexto  += "C9_QTDEMP: "+Alltrim(Transform(MSC9->C9_qtdemp,PesqPict("SC9","C9_QTDLIB")))+"<br>"
		cEmail  := "charlesm@brascola.com.br;marcelo@goldenview.com.br;fmaia@brascola.com.br"
		u_GDVWFAviso("PEDLIB","100003",cTitulo,cTexto,cEmail)
	Endif
Endif
If (Select("MSC9") <> 0)
	dbSelectArea("MSC9")
	dbCloseArea()
Endif

Return