#include "rwmake.ch"
#include "topconn.ch"
#include "inkey.ch"
                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATG005 ºAutor  ³ Marcelo da Cunha   º Data ³  25/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada no gatilho do campo C6_DESCONT para verificar º±±
±±º          ³ se o usuário pode colocar desconto acima do permitido.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATG005()
*********************
PRIVATE aAreaAtu := GetArea()
PRIVATE cTab     := AllTrim(M->C5_TABELA)
PRIVATE cCli     := AllTrim(M->C5_CLIENTE)
PRIVATE cTipo    := AllTrim(M->C5_TIPO)
PRIVATE cVend    := AllTrim(M->C5_VEND1)
PRIVATE cGrpCli  := Space(6), cCliente:= Space(6), _VEND := Space(6)
PRIVATE nUnit    := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN" })]
PRIVATE cProd    := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"})]
PRIVATE nQtd     := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })]
PRIVATE lNovaAlc := SuperGetMv("BR_ALNOVA",.F.,.F.) //Parametro para ativar Alcada
PRIVATE cFlagAlc := SuperGetMv("BR_ALFLAG",.F.,"") //Parametro para alterar flag para bloqueio
PRIVATE nDesPerm := GetMV("BR_000002") //Percentual máximo de desconto
PRIVATE cUsrDesc := GetMV("BR_000005") //Usuário com permissão para impor desconto maior que o percentual máximo
PRIVATE cUsuario := AllTrim(UsrRetName(RetCodUsr())) //Captura usuário logado.
PRIVATE nPosIte  := aScan(aHeader,{|m| Alltrim(m[2]) == "C6_ITEM"    }) // Posicao do Campo Item
PRIVATE nPosDes  := aScan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" }) // Posicao do Campo Desconto
PRIVATE nPosVDes := aScan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" }) // Posicao do Campo Valor Desconto
PRIVATE nPosBlq  := aScan(aHeader,{|m| Alltrim(m[2]) == "C6_X_BLDSC" }) // Posicao do Campo Bloqueio Desconto
PRIVATE nPosFlg  := aScan(aHeader,{|m| Alltrim(m[2]) == "C6_FLAGLUC" }) // Posicao do Campo Flag Lucro
PRIVATE nDescAtu := M->C6_DESCONT, nDescMax := 0, nDescPro := 0
PRIVATE lRetu    := .T., lPromo := .F., cFlag := Space(1)

//Chamo gatilho para calcular percentual
////////////////////////////////////////
cFlag := u_BXGatCusPed()
If !Empty(cFlag)
	aCols[N,nPosFlg] := cFlag
Endif

//Seleciona tabela de preços
////////////////////////////
If !(cCli $ GetMv("BR_000004")).and.!(cTipo $ "B/D")
	dbSelectArea("DA1")
	DA1->(dbSetOrder(1))
	If DA1->(dbSeek(xFilial("DA1")+cTab+cProd)) //Posiciona na tabela de preço x produto
		nPrcTab := DA1->DA1_PRCVEN //Captura o preço da tabela de preços
		nUnitNov:= nPrcTab
	Endif

	//Seleciona tabela de clientes
	//////////////////////////////
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+cCli)) //Posiciona o Cliente selecionado no pedido
		cGrpCli  := SA1->A1_GRPVEN //Grupo de clientes
		cCliente := SA1->A1_COD
		_VEND    := SA1->A1_VEND
		_GRPREP  := SA1->A1_REGIAO
	Endif
     
	//Query nas tabelas de Regra de Bonificacao
	///////////////////////////////////////////
	_cQuery1 := " SELECT ZZR_DESCPR,ZZQ_DESCRI,ZZQ_CODPRO,ZZQ_CODREG FROM "+RetSQLName("ZZR")+" ZZR , "+RetSQLName("ZZQ")+" ZZQ "
	_cQuery1 += " WHERE ZZQ.D_E_L_E_T_ <> '*' AND ZZR.D_E_L_E_T_ <> '*' AND ZZR_CODPRO = '"+cProd+"' AND ZZR_CODPRO = ZZQ_CODPRO AND ZZR_CODREG = ZZQ_CODREG "
	_cQuery1 += " AND ZZQ_TIPO = '2' AND (ZZQ.ZZQ_GRPVEN = '"+cGrpCli+"' OR ZZQ.ZZQ_GRPVEN='"+Space(Len(ZZQ->ZZQ_GRPVEN))+"') AND "
	_cQuery1 += " (ZZQ.ZZQ_CODTAB = '"+cTab+"' OR ZZQ.ZZQ_CODTAB='"+Space(Len(ZZQ->ZZQ_CODTAB))+"') "
	_cQuery1 += " AND (ZZQ.ZZQ_CODCLI = '"+cCliente+"' OR ZZQ.ZZQ_CODCLI='"+Space(Len(ZZQ->ZZQ_CODCLI))+"') "
	If !Empty(_GRPREP)
		_cQuery1 += "AND (ZZQ.ZZQ_REG1 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG2 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG3 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG4 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG5 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG6 = '"+_GRPREP+"' OR ZZQ_REG7 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG1 = '' AND ZZQ.ZZQ_REG2 = '' AND ZZQ.ZZQ_REG3 = '' AND ZZQ.ZZQ_REG4 = '' AND ZZQ.ZZQ_REG5 = '' AND ZZQ.ZZQ_REG6 = '' AND ZZQ_REG7  = '' ) "
	Endif
	_cQuery1 += " AND (ZZQ_VEND1 = '' OR ZZQ_VEND1 = '"+_VEND+"') "
	_cQuery1 += " AND ZZR_QTDMIN <= '"+STR(nQtd)+"'   AND ZZR_QTDMAX >= '"+STR(nQtd)+"' "
	_cQuery1 += " AND (ZZQ_DATDE <= '"+DTOS(DDATABASE)+"' AND ZZQ_DATATE >= '"+DTOS(DDATABASE)+"') "
	If (Select("QUERY1") > 0)
		QUERY1->(dbCloseArea())
	Endif
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery1),"QUERY1",.T.,.T.)
	dbSelectArea("QUERY1")
	QUERY1->(dbGotop())
	If !QUERY1->(Eof())
		lPromo := .T.
		If !(cCli $ GetMv("BR_000004")).and.!(cTipo $ "B/D")
			MsgAlert("Produto "+Alltrim(cProd)+" esta cadastrado na promoção."+QUERY1->ZZQ_CODREG+" "+Alltrim(QUERY1->ZZQ_DESCRI)+" desconto maximo permitido ate "+Alltrim(Str(QUERY1->ZZR_DESCPR))+"%")
			If (M->C6_DESCONT > QUERY1->ZZR_DESCPR)
				MsgStop("Desconto não permitido! Deve ser menor que "+Alltrim(Str(QUERY1->ZZR_DESCPR))+"%")
				lRetu := .F.  
				A410MultT() //Refaz o cálculo, esta opção esta no Valid do campo C6_DESCONT
			Else
				aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_X_REGRA" })] := QUERY1->ZZQ_CODREG
				lRetu :=.t.      
				A410MultT() //Refaz o cálculo, esta opção esta no Valid do campo C6_DESCONT
			Endif
		Else
			aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_X_REGRA" })] := Space(6)
		  	lPromo := .F.
		Endif
	Endif
	dbSelectArea("QUERY1")
	QUERY1->(dbCloseArea())
      
	//Verifico se deve tratar pela nova alcada
	//////////////////////////////////////////
	If (!lNovaAlc)
		If (nDescAtu > nDesPerm).and.!(cUsuario $ cUsrDesc).and.(!lPromo)
			MsgStop("Desconto não permitido! Deve ser menor que "+Alltrim(Str(nDesPerm))+"%")
			M->C6_DESCONT := 0
			M->C6_VALDESC := 0
			aCols[n,nPosDes] := 0
			aCols[n,nPosVDes]:= 0  
			GetDRefresh()
			SetFocus(oGetDad:oBrowse:hWnd) //Atualizacao por linha
	    	oGetDad:Refresh()
			A410MultT() //Refaz o cálculo, esta opção esta no Valid do campo C6_DESCONT
			lRetu := .F.
		Endif
	Else //Nova rotina de alcada de vendas
		If (lRetu).and.(nPosBlq > 0).and.!(cUserName $ SuperGetMv("BR_ALUSERM",.F.,""))
			aCols[n,nPosBlq] := "L" //Sem Bloqueio
			dbSelectArea("SA3")
			SA3->(dbSetOrder(7)) //UserID
			If !SA3->(dbSeek(xFilial("SA3")+__cUserID))
				SA3->(dbSetOrder(1)) //Codigo
				If !SA3->(dbSeek(xFilial("SA3")+M->C5_vend1))
					Help("",1,"BRASCOLA",,OemToAnsi("Usuario/Representante nao cadastrado!"),1,0)
					lRetu := .F.
				Endif
			Endif
			If (lRetu)
				nDescMax := 0
				If (SA3->A3_tipocad == "1") //Presidencia
					nDescMax := SuperGetMv("BR_ALDESCP",.F.,55)
				Elseif (SA3->A3_tipocad == "2") //Diretoria
					nDescMax := SuperGetMv("BR_ALDESCD",.F.,30)
				Elseif (SA3->A3_tipocad == "3") //Gerencial
					nDescMax := SuperGetMv("BR_ALDESCG",.F.,22)
				Elseif (SA3->A3_tipocad == "4") //Supervisao
					nDescMax := SuperGetMv("BR_ALDESCS",.F.,18)
				Elseif (SA3->A3_tipocad == "5") //Representante
					nDescMax := SuperGetMv("BR_ALDESCR",.F.,15)
				Endif
				nDescPro := 0
				SZ3->(dbSetOrder(1))                                                     
				If SZ3->(dbSeek(xFilial("SZ3")+M->C5_num+aCols[n,nPosIte])).and.!Empty(SZ3->Z3_datapro)
					nDescPro := SZ3->Z3_descpro
				Endif
				If ((nDescPro == 0).or.(nDescAtu > nDescPro))
					If (nDescAtu > SuperGetMv("BR_ALDESCP",.F.,55))
						Help("",1,"BRASCOLA",,OemToAnsi("Percentual de desconto nao permitido!"),1,0)
						lRetu := .F.
					Elseif (nDescAtu > nDescMax).or.(!Empty(cFlagAlc).and.(aCols[n,nPosFlg] $ cFlagAlc))
						aCols[n,nPosBlq] := "B" //Com Bloqueio
						Help("",1,"BRASCOLA",,OemToAnsi("Representante sem desconto autorizado. Item sera enviado para aprovação!"),1,0)
					Endif
				Endif
			Endif
		Endif
	Endif
	
Endif
RestArea(aAreaAtu)

Return lRetu