#include "rwmake.ch"
#include "topconn.ch"

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA04  � Autor �                       � Data �   /  /    ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Valida o Cliente Digitado                                   ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function EFATA04()
********************
Local lRetu := .T., cCodRep
Local aArea := GetArea()
Local aAmbSA1 := SA1->(GetArea())

//�������������������������������������Ŀ
//� Valido cliente digitado.            �
//���������������������������������������
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRep := u_BXRepLst("FIL") //Lista dos Representantes
	If !Empty(cCodRep)
		SA1->(dbSetOrder(1))
		If SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli)).and.!(Alltrim(SA1->A1_vend) $ cCodRep)
			Help("",1,"BRASCOLA",,OemToAnsi("Cliente nao faz parte da carteira do representante!"),1,0) 
			Return (lRetu := .F.)
		Endif
	Else
		Help("",1,"BRASCOLA",,OemToAnsi("Representante nao possui acesso no cadastro de clientes!"),1,0) 
		Return (lRetu := .F.)
	Endif
Endif

//�������������������������������������Ŀ
//� Valido status do cadastro cliente   �
//���������������������������������������
If ((INCLUI).or.(ALTERA)).and.!(M->C5_tipo $ "BD")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli)).and.(SA1->A1_status == "N")
		Help("",1,"BRASCOLA",,OemToAnsi("Cadastro do cliente esta desatualizado!"),1,0) 
		Return (lRetu := .F.)		
	Endif
Endif

//�������������������������������������Ŀ
//� Valida e Ajusta a Numeracao do SC5. �
//���������������������������������������
If (INCLUI)
	lTrocado := .F.
	dbSelectArea("SC5")
	dbSetOrder(1)
	While dbSeek(xFilial("SC5")+M->C5_NUM)
		ConfirmSX8()
		M->C5_NUM := GetSxeNum("SC5","C5_NUM")
		lTrocado := .T.
	EndDo
	If lTrocado
		MsgBox(OemToAnsi("Aten��o !! Atualizado o Numero de Pedido !"))
	EndIf
EndIf


//Valida Filial x Cliente     //THIAGO em 11/05/11
If lRetu .And. M->C5_TIPO<>"B"
	/*
	NORTE     : 'AC','AM','AP','PA','RO','RR','TO'
	NORDESTE  : 'AL','BA','CE','MA','PB','PE','PI','RN','SE'
	CENTROESTE: 'DF','GO','MS','MT'
	SUDESTE   : 'ES','MG','RJ','SP'
	SUL       : 'PR','RS','SC'
	*/
	
	cEstCli := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE,"A1_EST")
	cGrpRep := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND ,"A3_GRPREP")
   	//cUserLib:= AllTrim(GetMV("BR_000095"))//Fernando
	
	//04.01.12: Fernando > colocado em comentario trecho de c�digo
	/*
	//IGNORAR
   	If (!M->C5_AMOSTRA$ "1-3")
		
		If !(Alltrim(SubStr(cUsuario,7,15))$cUserLib)	// Grupo ADM Vendas
			
			If (!M->C5_CLIENTE$"")  // Clientes BRASCOLA
				
				If xFilial("SC5")=="01" //Matriz-SBC            

					If SA3->A3_COD $ "000118-000477-000511-000713-000528-000726-000768-000832-000163-000387-000418-000573-000586-000596-000641-000746-000750-000751-000770-000777-000792-000817-000824-000825-002029-002024-000833-000164-000826-000068-000769-000503-022000-025000-027000"
						MsgAlert("Aten��o!, Para esse representante n�o pode ser incluido pedido na Matriz. Favor incluir pela filial FRANCA !")
						lRetu:= .f. 			
					Endif				
				ElseIf xFilial("SC5")=="02" //Novo Hamburgo
					lRetu:= .f.
					MsgAlert("Aten��o!, o pedido n�o pode ser implantado para este cliente nessa filial. Verifique.")
					
				ElseIf xFilial("SC5")=="03" //Franca
					
					If !(SA3->A3_COD) $ "000118-000477-000511-000713-000528-000726-000768-000832-000163-000387-000418-000573-000586-000596-000641-000746-000750-000751-000770-000777-000792-000817-000824-000825-002029-002024-000833-000164-000826-000068-000769-000503-022000-025000-027000"
						MsgAlert("Aten��o!, Para esse representante n�o pode ser incluido pedido na filial de Franca. Favor incluir pela MATRIZ !")
						lRetu:= .f. 			
					Endif
					
				ElseIf xFilial("SC5")=="04"  
				
					lRetu:= .f.
					MsgAlert("Aten��o!, o pedido n�o pode ser implantado para este cliente nessa filial. Verifique.")
												
				EndIf
				
			EndIf
		EndIf
 		
	ElseIf xFilial("SC5") <> "01" //Matriz
		
		MsgAlert(OemToAnsi("Aten��o !! Pedidos de Amostra e Reposi��o devem ser Implantados na Matriz !"))
		lRetu:= .f.
		
	Endif*/
	
EndIf


SA1->(RestArea(aAmbSA1))
RestArea(aArea)

Return(lRetu)