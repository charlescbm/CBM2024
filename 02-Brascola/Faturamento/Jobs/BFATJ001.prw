#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATJ001 ºAutor  ³ Marcelo da Cunha   º Data ³  06/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow de clientes inativos por 90 e 180 dias            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATJ001()
*********************  
LOCAL oProcess := Nil, nConta := 0
LOCAL cVend1:=Space(6), cSuper1:=Space(6), cGeren1:=Space(6), nx
LOCAL cEmail1, cEmail2, cEmail3, cNome1, cNome2, cNome3, nDias := 0
LOCAL cTitHis, cObsAdi, cVenInt := "V0010S" //Adm Vendas
LOCAL cCodProc 	:= "Clientes Inativos"
LOCAL cDescProc	:= "Clientes Inativos"
LOCAL cHTMLModelo	:= "", cSubject := ""
LOCAL cFromName	:= "Workflow -  BRASCOLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do Ambiente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetEnv("01","01","","","FAT","",{"SA1","SA3","SF2"})
dData := MsDate()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Clientes Inativos 90/120 dias  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                   
For nx := 1 to 2

	If (nx == 1) //90 Dias
		nDias := 90
	Elseif (nx == 2) //180 Dias
		nDias := 180
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busco Clientes Inativos 90/120 dias  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                   
	cQuery := "SELECT A1.A1_VEND,A1.A1_COD,A1.A1_LOJA,A1.A1_NOME,A1.A1_EST,A1.A1_CONTATO, "
	cQuery += "ISNULL((SELECT MAX(F2.F2_EMISSAO) FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_='' " 
	cQuery += "AND F2.F2_FILIAL='"+xFilial("SF2")+"' AND F2.F2_CLIENTE=A1.A1_COD AND F2.F2_LOJA=A1.A1_LOJA AND F2.F2_DUPL<>''),'') MM_ULTCOM, "
	cQuery += "ISNULL((SELECT MAX(F2.F2_VALBRUT) FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_='' " 
	cQuery += "AND F2.F2_FILIAL='"+xFilial("SF2")+"' AND F2.F2_CLIENTE=A1.A1_COD AND F2.F2_LOJA=A1.A1_LOJA AND F2.F2_DUPL<>''),0) MM_VALCOM "
	cQuery += "FROM "+RetSqlName("SA1")+" A1 WHERE A1.D_E_L_E_T_='' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' AND A1.A1_VEND NOT IN ('"+cVenInt+"') " 
	If (nx == 1) //90 Dias
		cQuery += "AND ISNULL((SELECT SUM(F2.F2_VALBRUT) VALBRUT FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_='' AND F2.F2_FILIAL='"+xFilial("SF2")+"' " 
		cQuery += "         AND F2.F2_CLIENTE=A1.A1_COD AND F2.F2_LOJA=A1.A1_LOJA AND F2.F2_DUPL<>'' AND F2.F2_EMISSAO>'"+dtos(MsDate()-nDias)+"'),0) = 0 "
	Elseif (nx == 2) //120 Dias
		cQuery += "AND ISNULL((SELECT SUM(F2.F2_VALBRUT) VALBRUT FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_='' AND F2.F2_FILIAL='"+xFilial("SF2")+"' " 
		cQuery += "         AND F2.F2_CLIENTE=A1.A1_COD AND F2.F2_LOJA=A1.A1_LOJA AND F2.F2_DUPL<>'' AND F2.F2_EMISSAO>'"+dtos(MsDate()-nDias)+"'),0) = 0 "
	Endif
	////////////////////////////////////
	//cQuery += "AND A1.A1_MSBLQL<>'1' "
	////////////////////////////////////
	cQuery += "ORDER BY A1_VEND,MM_VALCOM DESC,A1_NOME "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"                                              
	TCSetField("MAR","MM_ULTCOM","D",08,0)
	
	SA1->(dbSetOrder(1))
	SA3->(dbSetOrder(1))
	dbSelectArea("MAR")
	While !MAR->(Eof())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifico quando usuario foi incluido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA1")       
		If SA1->(dbSeek(xFilial("SA1")+MAR->A1_cod+MAR->A1_loja))
			If (nx == 2)
				dDatCli := ctod("//")
				If !Empty(SA1->A1_userlga)
				   dDatCli := ctod(FWLeUserLg("A1_USERLGA",2))
				Else
				   dDatCli := ctod(FWLeUserLg("A1_USERLGI",2))
				Endif
				If !Empty(dDatCli).and.(dDatCli >= (dData-nDias)) //Nao gerar WF para clientes cadastrados a menos de 180 dias
					MAR->(dbSkip())
					Loop
				Endif		
			Endif
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Processo de Workflow ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSuper1:= Space(6) ; cEmail1 := ""
		cVend1 := MAR->A1_vend ; cNome1 := ""
		If SA3->(dbSeek(xFilial("SA3")+cVend1))
			cNome1 := Alltrim(SA3->A3_nome)
			If (SA3->A3_msblql != "1") //Nao Esta bloqueado
				cEmail1 := Alltrim(SA3->A3_email)
			Endif
			cSuper1:= iif(!Empty(SA3->A3_super),SA3->A3_super,SA3->A3_geren)
			If Empty(cSuper1)
				cSuper1 := 	cVend1
			Endif                             
			If (SA3->A3_tipocad != "5")
				MAR->(dbSkip())
				Loop
			Endif
		Endif     
		cHTMLModelo	:= "\workflow\wfinativos.htm"
		cSubject	:= "WORKFLOW:Cliente Inativos por "+Alltrim(Str(nDias))+" dias do Representante "+cVend1+" "+cNome1+" | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
		If (oProcess != Nil)
			oProcess:Free()
		Endif
		oProcess	:= TWFProcess():New(cCodProc,cDescProc)
		oProcess:NewTask(cDescProc,cHTMLModelo)
		oProcess:oHtml:ValByName("Data",	dDataBase)
		oProcess:oHtml:ValByName("Hora",	Alltrim(Time()))
		oProcess:oHtml:ValByName("Tempo",Alltrim(Str(nDias)))                                      
		If (nx == 1)
			oProcess:oHtml:ValByName("Observacao","Obs.: Caso o cliente nao possua venda em <b>30 dias</b>, o cliente sera automaticamente transferido para outro representante.")
		Elseif (nx == 2)                                                                                             
			If SA3->(dbSeek(xFilial("SA3")+cVenInt))
				oProcess:oHtml:ValByName("Observacao","Obs.: Os clientes listados foram transferidos para o representante "+Alltrim(SA3->A3_cod)+" "+Alltrim(SA3->A3_nome)+".")
			Else
				oProcess:oHtml:ValByName("Observacao","&nbsp;")
			Endif
		Endif
		If !Empty(cVend1)
			oProcess:oHtml:ValByName("Representante",Alltrim(cVend1)+"-"+Alltrim(cNome1))
		Else
			oProcess:oHtml:ValByName("Representante","< SEM REPRESENTANTE >")
		Endif
	                
		nConta := 0
		dbSelectArea("MAR")
		While !MAR->(Eof()).and.(MAR->A1_vend == cVend1)
		   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Bloquear cliente e transferir para adm vendas ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         If (nx == 2).and.SA1->(dbSeek(xFilial("SA1")+MAR->A1_cod+MAR->A1_loja))
         	cTitHis := "ALTERACAO AUTOMATICA REPRESENTANTE (180 DIAS)"
         	//cObsAdi := "CLIENTE BLOQUEADO E ALTERADO VENDEDOR "+SA1->A1_vend+" PARA "+cVenInt
         	cObsAdi := "ATUALIZADO NÃO"
         	Reclock("SA1",.F.)
         	SA1->A1_status := "N" //Bloqueado
         	//SA1->A1_vendant := SA1->A1_vend
         	//SA1->A1_vend := cVenInt
         	MsUnlock("SA1")                     
         	u_GDVHInclui("SA1",cTitHis,cObsAdi,,.T.,.T.)
         Endif
		   AAdd( oProcess:oHtml:ValByName("Item.cli")  , MAR->A1_cod+"/"+MAR->A1_loja )
	   	AAdd( oProcess:oHtml:ValByName("Item.nome") , MAR->A1_nome )
		   AAdd( oProcess:oHtml:ValByName("Item.est")  , MAR->A1_est )
	   	AAdd( oProcess:oHtml:ValByName("Item.con")  , MAR->A1_contato )
	   	AAdd( oProcess:oHtml:ValByName("Item.ult")  , dtoc(MAR->MM_ultcom) )
	   	AAdd( oProcess:oHtml:ValByName("Item.val")  , Transform(MAR->MM_valcom,"@E 999,999,999.99") )
	   	nConta++
	   	If (nConta > 500)
				oProcess:oHtml:ValByName("Continua","Mais de 500 clientes... continua em outro e-mail.")
	   		Exit
	   	Endif
			MAR->(dbSkip())
		Enddo
		If (nConta <= 500)
			oProcess:oHtml:ValByName("Continua","&nbsp;")
		Endif
	   		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza Processo Workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess:ClientName(cUserName)
		oProcess:cTo := "" ; oProcess:cCC := ""   
		If !Empty(cVend1)
			cEmail1 := u_BXFormatEmail(cEmail1)
			If !Empty(cEmail1)
				oProcess:cTo := cEmail1
			Endif
			If (cVend1 != cSuper1)
				If SA3->(dbSeek(xFilial("SA3")+cSuper1)).and.!Empty(SA3->A3_email)
					oProcess:cCC += iif(!Empty(oProcess:cCC),";","")+Alltrim(SA3->A3_email)
					cGeren1 := SA3->A3_geren
					If (cGeren1 != cSuper1)
						If SA3->(dbSeek(xFilial("SA3")+cGeren1)).and.!Empty(SA3->A3_email)
							oProcess:cCC += iif(!Empty(oProcess:cCC),";","")+Alltrim(SA3->A3_email)
						Endif
					Endif
				Endif
			Endif
		Else 
			cEmail1 := ""
			cQuery1 := "SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 "
			cQuery1 += "WHERE A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+xFilial("SA3")+"' "
			cQuery1 += "AND A3.A3_MSBLQL <> '1' AND A3.A3_EMAIL <> '' AND A3.A3_TIPOCAD = '3' "
			cQuery1 += "ORDER BY A3_COD "
			cQuery1 := ChangeQuery(cQuery1)
			If (Select("MSA3") <> 0)
				dbSelectArea("MSA3")
				dbCloseArea()
			Endif
			TCQuery cQuery1 NEW ALIAS "MSA3"
			dbSelectArea("MSA3")
			While !MSA3->(Eof())
				cEmail1 += Alltrim(MSA3->A3_email)+";"
				MSA3->(dbSkip())
			Enddo
			cEmail1 := u_BXFormatEmail(cEmail1)
			If !Empty(cEmail1)
				oProcess:cTo := cEmail1
			Endif                 
		Endif
		If (nx == 2).and.!Empty(cVenInt).and.SA3->(dbSeek(xFilial("SA3")+cVenInt))
			oProcess:cCC += iif(!Empty(oProcess:cCC),";","")+Alltrim(SA3->A3_email)
		Endif          
		//oProcess:cTo := ""
		//oProcess:cCC := "marcelo@goldenview.com.br"
		oProcess:cSubject := cSubject
		oProcess:cFromName:= cFromName
		oProcess:Start()
		oProcess:Finish()
		
		//nConta++
		//If (nConta > 5)
		//	Exit
		//Endif
		
		dbSelectArea("MAR")
	Enddo

Next nx

If (Select("MSA3") <> 0)
	dbSelectArea("MSA3")
	dbCloseArea()
Endif
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return