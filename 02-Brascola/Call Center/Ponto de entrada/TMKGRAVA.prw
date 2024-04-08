#include "rwmake.ch"
#include "topconn.ch"
                  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TMKGRAVA �Autor  � Marcelo da Cunha   � Data �  25/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Enviar pesquisa de satisfacao quanto atendimento for       ���
���          � encerrado.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TMKGRAVA()
*********************
LOCAL lChvPesq := SUC->(FieldPos("UC_CHVPESQ")) > 0, lEnvPesq
LOCAL cChave := Space(32), cCodigo := Space(6), nSeed := 0

//������������������������������������������������������������������Ŀ
//� Verifico necessidade para envio da pesquisa de satisfacao.       �
//��������������������������������������������������������������������
If (lChvPesq).and.(Alltrim(SUC->UC_status) == "3").and.(SUC->UC_entidad == "SA1").and.;
	!(Left(SUC->UC_chave,8) $ "00000000") //N�o enviar para cliente nao identificado
	cCodigo := SUC->UC_codigo+Strzero(Aleatorio(999999,nSeed),6)
	cChave  := MD5(cCodigo,2)
	lEnvPesq:= GetMV("BR_000040").and.BVerifAssunto(SUC->UC_codigo)
	If (lEnvPesq).and.!Empty(cChave)
		dbSelectArea("SUC")
		Reclock("SUC",.F.)
		SUC->UC_chvpesq := cChave
		MsUnlock("SUC")
		If (SUC->UC_entidad == "SA1")
			SA1->(dbSetOrder(1))
			If SA1->(dbSeek(xFilial("SA1")+SUC->UC_chave))
				cTitulo := "Pesquisa de Satisfa��o do Chamado: "+SUC->UC_codigo
				cTexto  := "Em busca de melhor atende-lo a Brascola gostaria de solicitar sua opini�o com rela��o ao nosso atendimento.<br><br>"
				cTexto  += "Clique <a href='http://sistema.brascola.com.br:8085/portal/u_bweba001.apw?cCodigo="+SUC->UC_codigo+"&cChave="+SUC->UC_chvpesq+"'>AQUI</a> para responder a pesquisa.<br><br>" 
				cTexto  += "Atenciosamente,<br> "
				cTexto  += "Adm CAEC (Central de Atendimento Especial ao Cliente) "
				cEmail  := Alltrim(SA1->A1_email)
				If Empty(cEmail)
					cEmail  := "charlesm@brascola.com.br"
				Endif
				u_GDVWFAviso("PESQSA","100001",cTitulo,cTexto,cEmail)
			Endif
		Endif
	Endif
Endif

Return

Static Function BVerifAssunto(xCodigo)
**************************************
LOCAL lRetu := .T., cNAssunto := GetMV("BR_000035")
If !Empty(cNAssunto)
	SUD->(dbSetOrder(1))
	SUD->(dbSeek(xFilial("SUD")+xCodigo,.T.))
	While !SUD->(Eof()).and.(xFilial("SUD") == SUD->UD_filial).and.(SUD->UD_codigo == xCodigo)
		If (Alltrim(SUD->UD_assunto) $ cNAssunto)
			lRetu := .F.
			Exit
		Endif
		SUD->(dbSkip())
	Enddo
Endif
Return lRetu