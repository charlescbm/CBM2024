#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RFATM01  � Autor � Marcos Eduardo Rocha  � Data � 16/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Job para Liberacao de Pedidos                              ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFATM01(lAuto)
*************************
LOCAL aAreaAtu  := GetArea()
LOCAL cCadastro	:= OemToAnsi("Liberacao de Pedidos/Estoque")
LOCAL nProcessa	:= 3, lJob := .T.
LOCAL lAuto := If(lAuto == NIL,{.F.},lAuto)

RPCSetType(3)
RpcSetEnv("01","01","","","FAT","",{"SA1","SB2","SB8","SC5","SC6","SC9"})

ConOut("-----------------------------------------------")
ConOut("> Inicio de Liberacao de Pedidos/Estoque "+Time())
ConOut("> U_RFATM01A: Job Liberacao de Pedidos...")
U_RFATM01A() //Job Liberacao de Pedidos
ConOut("> U_RFATM02A: Job Liberacao de Estoque...")
U_RFATM02A() //Job Liberacao de Estoque
MsUnlockAll() //Destravo todos os registros
dbCloseAll() //Fecho todas as areas abertas
ConOut("> Fim de Liberacao de Pedidos/Estoque "+Time())
ConOut("-----------------------------------------------")

RESET ENVIRONMENT
RestArea(aAreaAtu)

Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa � RFATM01A � Autor � Marcos Eduardo Rocha � Data �  16/06/06  ���
�������������������������������������������������������������������������͹��
���Desc.    � Processa liberacao                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFATM01A()
*********************
LOCAL lEnd := .F.

//������������������������������������������������������Ŀ
//� Transfere locais para a liberacao                    �
//��������������������������������������������������������
PRIVATE lTransf := .F.  //1
//������������������������������������������������������Ŀ
//� Libera Parcial pedidos de vendas                     �
//��������������������������������������������������������
PRIVATE lLiber := .F.  ///1
//������������������������������������������������������Ŀ
//� Sugere quantidade liberada                           �
//��������������������������������������������������������
PRIVATE lSugere := .T.  //1

//�����������������������������������������������������������������������Ŀ
//� Chama a pergunta padrao para os casos de criacao de parametros novos. �
//�������������������������������������������������������������������������
Pergunte("MTALIB",.F.)

//������������������������������������������������������������������������Ŀ
//� mv_par01 Ordem Processmento ?  Ped.+Item /Dt.Entrega+Ped.+Item         �
//� mv_par02 Pedido de          ?                                          �
//� mv_par03 Pedido ate         ?                                          �
//� mv_par04 Cliente de         ?                                          �
//� mv_par05 Cliente ate        ?                                          �
//� mv_par06 Dta Entrega de     ?                                          �
//� mv_par07 Dta Entrega ate    ?                                          �
//� mv_par08 Liberar            ? Credito/Estoque Credito                  �
//��������������������������������������������������������������������������
mv_par01 := 2
mv_par02 := "      "
mv_par03 := "999999"
mv_par04 := Space(8)
mv_par05 := "ZZZZZZZZ"
mv_par06 := (dDataBase-160)
mv_par07 := (dDataBase+10)  
mv_par08 := 1
mv_par09 := ''
mv_par10 := 'ZZ'
mv_par11 := ''
mv_par12 := 1

ConOut("> U_RFATM01A: Inicio de Liberacao de Pedidos "+Time())

lMSErroAuto := .F. ; lMSHelpAuto := .F.
Processa({|lEnd| a440Proces("","",1	,@lEnd)},,,.T.)     

ConOut("> U_RFATM01A: Final da Liberacao de Pedidos "+Time())

cEmail    := "charles.medeiros@brascola.com.br;kcarbonera@brascola.com.br"
cAssunto  := "Liberacao de Pedidos em Joinville realizado as "+Time()
cTexto    := "Liberacao de Pedidos em Joinville ( Filial 01 ) realizado as "+Time()
/*
 //COMENTADO POR CHARLES PARA NAO GERAR E-MAIL DE 30 EM 30 MINUTOS.
If U_SendmAIL(cEmail,cAssunto,cTexto,"",.F.)
   ConOut("--------------------------------------------------")
   ConOut("  Enviado e-mail - Liberacao de Pedidos ")
 	ConOut("--------------------------------------------------")
Else
   ConOut("--------------------------------------------------")
	ConOut("  Problema no envio de e-mail - Liberacao de Pedidos ")
   ConOut("--------------------------------------------------")
EndIf	
*/
Return