/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKGERATXTบ Autor ณ Wanderley          บ Data ณ  25/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa a geracao do arquivo texto.                    บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EXPGKO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/      


/* Daniel Neves Pelegrinelli - 19 de Outubro de 2005
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAlteracao do Programa EXPGKO para criacao de TXT apos    ณ
//ณimpressao de relatorio de transferencia de tranportadora.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ENDDOC*/
User Function ExpGKO2()
    
Local cDia
Local cHora

Private cArqTxt
Private nHdl

Private cEOL    := "CHR(13)+CHR(10)"
   
   
                                                                                           
_cLocal := ALLTRIM(GETMV("BR_GKODIR") )


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o nome do arquivo texto e cria                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cDia := Dtoc(dDataBase)
	cDia := Subs(cDia,1,2)+Subs(cDia,4,2)+Subs(cDia,7,4)
	cHora := Time()
	cHora := Subs(cHora,1,2)+Subs(cHora,4,2)+Subs(cHora,7,2)
	
	cArqTxt := AllTrim(_cLocal)+If(Right(AllTrim(_cLocal),1)=="\","","\")+"FRDNE"+cDia+cHora+".TXT"
	nHdl    := fCreate(cArqTxt)
	
	
	



	If Empty(cEOL)
		cEOL := CHR(13)+CHR(10)
	Else
		cEOL := Trim(cEOL)
		cEOL := &cEOL
	Endif
	
	
	
	
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
		Return
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa a regua de processamento                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	
	cQrSF2 := "SELECT * "   +cEOL
	cQrSF2 += "FROM "+RetSqlName("SF2")+"  "+cEOL
	cQrSF2 += "WHERE F2_OK2 <>  SPACE(4) AND "+RetSqlName("SF2")+".D_E_L_E_T_ <> '*' "+cEOL
	cQrSF2 += " ORDER BY F2_DOC, F2_SERIE "+cEOL
	dBUseArea(.T.,"TOPCONN",TcGenQry(,,cQrSF2),"TM2",.F.,.F.)

	Processa({|| RunCont2() },"Processando...")
//EndIf
  
DBCLOSEAREA("TM2")
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ Wanderley          บ Data ณ  25/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EXPGKO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont2

Local nTamLin, cLin, cCpo
Local lCabec := .F.
Local cEndEnt
Local cBaiEnt
Local cCidEnt
Local cEstEnt
Local cCepEnt
Local cTipFre
Local nPesoBru
Local nPesoLiq
Local aRetInfo := {}
Local nFrete := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria perguntas                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Set Century on

 
ProcRegua(RecCount()-Recno()) // Numero de registros a processar

nTamLin := 99
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ณ
//ณ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ณ
//ณ string dentro de outra string.                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// cabecalho
cCpo := PADR("000",03)              	// Registro Header
cLin := Stuff(cLin,01,03,cCpo)
cCpo := PADR("INTDNE",10)				// Nome Interface
cLin := Stuff(cLin,04,10,cCpo)
cCpo := PADR("5.0a",06)					// Versใo GKO
cLin := Stuff(cLin,14,06,cCpo)
cCpo := PADR("BRASCOLA LTDA",40)		// Remetente do arquivo
cLin := Stuff(cLin,20,40,cCpo)
cCpo := PADR("GKO Frete",40)        	// Destinatario do arquivo
cLin := Stuff(cLin,60,40,cCpo)

U_GravaLin2(nHdl, cLin)


//While SF2->F2_DOC >= mv_par01 .and. SF2->F2_DOC <= mv_par02
DbSelectArea("TM2")   
DBGOTOP("TM2")
WHILE !EOF() 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua                                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	IncProc()
	
	nFrete := TM2->F2_FRETE
	
	nTamLin := 216
	cLin    := Space(nTamLin)+cEOL 			// Limpa cLin
	
	DbselectArea("SA1") // Localiza cliente
	DbSetOrder(1)
	IF DBSEEK( XFILIAL("SA1") + TM2->F2_CLIENTE + TM2->F2_LOJA)
		// Linha detalhe do cliente
		cCpo := PADR("100",03)
		cLin := Stuff(cLin,01,03,cCpo)			// Fixo 100 - Cliente
		cCpo := PADR("A",01)
		cLin := Stuff(cLin,04,01,cCpo)			// Fixo A
		cCpo := PADR(SA1->A1_CGC,15)
		cLin := Stuff(cLin,05,15,cCpo)			// CGC do Cliente
		cCpo := PADR("2",01)
		cLin := Stuff(cLin,20,01,cCpo)			// Parc.Comercial - Cliente - Fixo "2"
		cCpo := PADR(SA1->A1_COD,06)
		cLin := Stuff(cLin,21,06,cCpo)			// Codigo do Cliente
		cCpo := PADR(" ",08)
		cLin := Stuff(cLin,27,08,cCpo)			// Posiciona proximo campo - Fixo space(8)
		cCpo := PADR(SA1->A1_NOME,40)
		cLin := Stuff(cLin,35,40,cCpo)		   	// Razao Social do Cliente
		cCpo := PADR(Subs(SA1->A1_END,1,40),40)
		cLin := Stuff(cLin,75,40,cCpo)			// Endereco do Cliente
		cCpo := PADR(Subs(SA1->A1_BAIRRO,1,20),20)
		cLin := Stuff(cLin,115,20,cCpo)			// Bairro do Cliente
		cCpo := PADR(Subs(SA1->A1_MUN,1,20),20)
		cLin := Stuff(cLin,135,20,cCpo)			// Cidade do Cliente
		cCpo := PADR(SA1->A1_EST,02)
		cLin := Stuff(cLin,165,02,cCpo)			// Estado do Cliente
		cCpo := PADR(SA1->A1_CEP,08)
		cLin := Stuff(cLin,167,08,cCpo)			// CEP do Cliente
		cCpo := PADR(" ",08)
		cLin := Stuff(cLin,175,08,cCpo)			// Cod.Zona Transporte - Fixo space(8)
		cCpo := PADR(Iif(SA1->A1_PESSOA=="F","1","2"),01)
		cLin := Stuff(cLin,183,01,cCpo)			// Tipo de Pessoa - 1=Fisica 2=Juridica
		cCpo := PADR(Subs(SA1->A1_INSCR,1,15),15)
		cLin := Stuff(cLin,184,15,cCpo)			// Inscricao Estadual
		cCpo := PADR(Subs(SA1->A1_INSCRM,1,15),15)
		cLin := Stuff(cLin,200,15,cCpo)			// Inscricao Municipal
		cCpo := PADR(Iif(SA1->A1_TIPO=="F","0","1"),01) // Se for Consumidor Final, nใo ้ contribuinte.
		cLin := Stuff(cLin,214,01,cCpo)			// Cont.ICMS 0-Nao 1-Sim
		cCpo := "0"
		cLin := Stuff(cLin,215,01,cCpo)			// Regime de Credito de ICMS 0-Nao
		cCpo := "0"
		cLin := Stuff(cLin,216,01,cCpo)			// Elimina Referencias Externas 0-Nao
		
		U_GravaL2(nHdl, cLin)
		
		nTamLin := 430
		cLin    := Space(nTamLin)+cEOL 			// Limpa cLin
		
		cEndEnt := SA1->A1_ENDENT
		cBaiEnt := SA1->A1_BAIRROE
		cCidEnt := SA1->A1_MUNE
		cEstEnt := SA1->A1_ESTE
		cCepEnt := SA1->A1_CEPE
		cTipFre := SA1->A1_TPFRET
		
	ENDIF
	
	DbSelectArea("TM2")
	
	aRetInfo := U_RetInfo2()
	
	// Linha Header da NF
	cCpo := PADR("140",03)
	cLin := Stuff(cLin,01,03,cCpo)			// Fixo 140 - Header NF
	cCpo := PADR("A",01)
	cLin := Stuff(cLin,04,01,cCpo)			// Fixo A
	cCpo := PADR("1",01)
	cLin := Stuff(cLin,05,01,cCpo)			// Tipo de Documento 1-Nota Fiscal
	cCpo := PADR("1",01)
	cLin := Stuff(cLin,06,01,cCpo)			// Emitente da NF - Brascola
	cCpo := PADR("000002",06)
	cLin := Stuff(cLin,07,06,cCpo)			// Codigo da Brascola no Cadastro de Emitente - Fixo 000002
	cCpo := Space(08)
	cLin := Stuff(cLin,13,08,cCpo)			// Posiciona proximo campo - Fixo space(8)
	cCpo := PADR(TM2->F2_DOC,06)
	cLin := Stuff(cLin,21,06,cCpo)			// Numero da Nota Fiscal
	cCpo := Space(06)
	cLin := Stuff(cLin,27,06,cCpo)			// Posiciona proximo campo
	cCpo := PADR(TM2->F2_SERIE,03)
	cLin := Stuff(cLin,33,03,cCpo)			// Serie da NF
	//cCpo := PADR(DTOC(TMP->F2_EMISSAO),10)
	cCpo := PADR(SUBSTR(TM2->F2_EMISSAO,7,2)+"/"+SUBSTR(TM2->F2_EMISSAO,5,2)+"/"+SUBSTR(TM2->F2_EMISSAO,1,4),10)
	cLin := Stuff(cLin,36,10,cCpo)			// Data da Emissao da NF
  //	cCpo := PADR(DTOC(TMP->F2_DTSAIDA),10) 
 	cCpo := PADR(SUBSTR(TM2->F2_DTSAIDA,7,2)+"/"+SUBSTR(TM2->F2_DTSAIDA,5,2)+"/"+SUBSTR(TM2->F2_DTSAIDA,1,4),10)
	cLin := Stuff(cLin,46,10,cCpo)			// Data de Embarque
	cCpo := PADR("2",01)
	cLin := Stuff(cLin,56,01,cCpo)			// Tipo de Nota 1-Entrada 2-Saida
	cCpo := PADR("2",01)
	cLin := Stuff(cLin,57,01,cCpo)			// Parc.Comercial - Cliente
	cCpo := PADR(TM2->F2_CLIENTE,06)
	cLin := Stuff(cLin,58,06,cCpo)			// Codigo do Emitente
	cCpo := PADR(" ",08)
	cLin := Stuff(cLin,64,08,cCpo)			// Posiciona Proximo Campo
	cCpo := PADR(cEndEnt,40)
	cLin := Stuff(cLin,72,40,cCpo)			// End.Entrega Cliente
	cCpo := PADR(cBaiEnt,20)
	cLin := Stuff(cLin,112,20,cCpo)			// Bairro Entrega Cliente
	cCpo := PADR(cCidEnt,30)
	cLin := Stuff(cLin,132,30,cCpo)			// Cidade Entrega Cliente
	cCpo := PADR(cEstEnt,02)
	cLin := Stuff(cLin,162,02,cCpo)			// Estado Entrega Cliente
	cCpo := PADR(cCEPEnt,08)
	cLin := Stuff(cLin,164,08,cCpo)			// CEP Entrega Cliente
	cCpo := Space(08)
	cLin := Stuff(cLin,172,08,cCpo)			// Cod.Zona Transporte
	cCpo := Space(12)
	cLin := Stuff(cLin,180,12,cCpo)			// Nro.Docto.Negociacao de Frete
	cCpo := PADR(aRetInfo[1],04)
	cLin := Stuff(cLin,192,04,cCpo)			// Tipo de Nota Fiscal
	cCpo := Space(10)
	cLin := Stuff(cLin,196,10,cCpo)			// Cod.Equipamento(truck, bau, etc)
	cCpo := Space(04)
	cLin := Stuff(cLin,206,04,cCpo)			// Cod.Embalagem
	cCpo := "1"                             // Meio de transporte 1-Viario, 2-etc...
	// Deixar fixo "1" at้ 2a.ordem - Hernane 26/04/05
	cLin := Stuff(cLin,210,01,cCpo)			// Via de Transporte conf.Tabela Magnus
	cCpo := Space(03)
	cLin := Stuff(cLin,211,03,cCpo)			// Posiciona Proximo Campo
	cCpo := Padr(SUBSTR(TM2->F2_VEND1,2,6),05)
	cLin := Stuff(cLin,214,05,cCpo)			// Codigo do Representante
	cCpo := Space(05)
	cLin := Stuff(cLin,219,05,cCpo)			// Cod.Territ๓rio
	cCpo := Space(10)
	cLin := Stuff(cLin,224,10,cCpo)			// Ident.Embarque - Bco at้ segunda ordem
	cCpo := Space(10)
	cLin := Stuff(cLin,234,10,cCpo)			// Romaneio
	cCpo := Padr(SUBSTR(TM2->F2_TRANSP,2,5),15)
	cLin := Stuff(cLin,244,15,cCpo)			// Codigo Transportadora
	cCpo := Padr(Iif(cTipFre=="C","1","2"),01)
	cLin := Stuff(cLin,259,01,cCpo)			// Frete 1=CIF, 2=Fob
	cCpo := Padr(TM2->F2_REDESP,15)
	cLin := Stuff(cLin,260,15,cCpo)			// Transp.Redespacho
	cCpo := Space(15)
	cLin := Stuff(cLin,275,15,cCpo)			// Ref.Transp.Redespacho
	cCpo := "1"                             // Fixo "1" at้ 2a.Ordem (Atualmente nใo existe outra forma - Hernane - 26/04/05
	cLin := Stuff(cLin,290,01,cCpo)			// Frete Redespacho 1=Cif, 2=Fob
	cCpo := Space(12)
	cLin := Stuff(cLin,291,12,cCpo)			// Nro.Docto.vinculado somente se <> NF
	cCpo := Space(03)
	cLin := Stuff(cLin,303,03,cCpo)			// Serie docto vinculado
	cCpo := Padr(aRetInfo[2],06)
	cLin := Stuff(cLin,306,06,cCpo)			// Nat.Operacao
	cCpo := "0"
	cLin := Stuff(cLin,312,01,cCpo)			// Frete Isento de ICMS 0=Nao, 1=Sim
	cCpo := "0"                             // Fixo "0" - Provisorio - Hernane - 26/04/05
	cLin := Stuff(cLin,313,01,cCpo)			// Cred.ICMS s/Frete 0=Nao, 1=Sim
	cCpo := "1"                             // Fixo "1" - Provisorio - Hernane - 26/04/05
	cLin := Stuff(cLin,314,01,cCpo)			// Subst.Trib.s/frete 0=Nao, 1=Sim
	cCpo := PADR(Iif(SA1->A1_TIPO=="F","1","0"),01) // Se consumidor final ้ "1"
	cLin := Stuff(cLin,315,01,cCpo)			// Dest.Mercadoria 0=Normal, 1=Uso-consumo
	cCpo := Space(15)
	cLin := Stuff(cLin,316,15,cCpo)			// Peso Bruto - manter branco
	cCpo := Space(15)
	cLin := Stuff(cLin,331,15,cCpo)			// Peso Cubado - manter branco
	cCpo := Space(15)
	cLin := Stuff(cLin,346,15,cCpo)			// Peso Liquido - manter branco
	cCpo := Space(06)
	cLin := Stuff(cLin,361,06,cCpo)			// Qtde Volumes
	cCpo := Space(15)
	cLin := Stuff(cLin,367,15,cCpo)			// Valores nao inclusos nos itens
	cCpo := Space(10)
	cLin := Stuff(cLin,382,10,cCpo)			// Moeda em que estaa expressos os valores
	cCpo := "0"
	cLin := Stuff(cLin,392,01,cCpo)			// Entrega urgente 0=Nao, 1=Sim
	cCpo := "0"
	cLin := Stuff(cLin,393,01,cCpo)			// Frete diferenciado 0=Nao, 1=Sim
	cCpo := Space(10)
	cLin := Stuff(cLin,394,10,cCpo)			// Data de entrega somente para NF Entrada
	cCpo := Space(15)
	cLin := Stuff(cLin,404,15,cCpo)			// Responsavel p/ frete
	cCpo := Space(10)
	cLin := Stuff(cLin,419,10,cCpo)			// Data tabela de preco do frete - Branco
	cCpo := "0"
	cLin := Stuff(cLin,429,01,cCpo)			// Exclui itens antes de importar 0=Nใo, 1=Sim
	cCpo := "0"
	cLin := Stuff(cLin,430,01,cCpo)			// Exclui ref.Externas antes de importar 0=Nใo, 1=Sim
	
	U_GravaL2(nHdl, cLin)
	
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2")+TM2->F2_DOC+TM2->F2_SERIE)
	Do While xFilial("TM2")+TM2->F2_DOC+TM2->F2_SERIE == xFilial("TM2")+SD2->D2_DOC+SD2->D2_SERIE
		nTamLin := 137
		cLin    := Space(nTamLin)+cEOL 			// Limpa cLin
		// Linha Material
		cCpo := PADR("150",03)
		cLin := Stuff(cLin,001,03,cCpo)			// Fixo 150 - Material
		cCpo := PADR("A",01)
		cLin := Stuff(cLin,04,01,cCpo)			// Fixo A
		DbSelectArea("SB1")
		DbSetOrder(1)
		If DbSeek(xFilial("SB1")+SD2->D2_COD)
			cCpo := Padr(Subs(SB1->B1_DESC,1,40),40)
			nPesoBru := SB1->B1_PESBRU
			nPesoLiq := SB1->B1_PESO
		Else
			cCpo := Space(40)
		EndIf
		DbselectArea("SD2")
		cLin := Stuff(cLin,005,40,cCpo)			// Descricao do Material
		cCpo := Padr(SD2->D2_COD,20)
		cLin := Stuff(cLin,045,20,cCpo)			// Cod.Item
		cCpo := "0000"							// Fixo "0000" por nใo existir Familia Comercial - Hernane - 26/04/05
		cLin := Stuff(cLin,065,04,cCpo)			// Familia Comercial
		cCpo := Space(68)
		cLin := Stuff(cLin,069,68,cCpo)			// Resto do Registro
		
		U_GravaL2(nHdl, cLin)
		
		nTamLin := 171
		cLin    := Space(nTamLin)+cEOL 			// Limpa cLin
		
		// Linha Item da Nota
		cCpo := "160"
		cLin := Stuff(cLin,001,03,cCpo)			// Fixo 160 - Item da Nota
		cCpo := PADR("A",01)
		cLin := Stuff(cLin,04,01,cCpo)			// Fixo A
		cCpo := PADR("1",01)
		cLin := Stuff(cLin,05,01,cCpo)			// Emitente da NF - Brascola
		cCpo := "000002"
		cLin := Stuff(cLin,06,06,cCpo)			// Cod.Brascola Cad.Emitente
		cCpo := Space(8)
		cLin := Stuff(cLin,12,08,cCpo)			// Posiciona proximo campo
		cCpo := PADR(SD2->D2_DOC,06)
		cLin := Stuff(cLin,20,06,cCpo)			// Numero da Nota Fiscal
		cCpo := Space(06)
		cLin := Stuff(cLin,26,06,cCpo)	     	// Posiciona proximo campo
		cCpo := PADR(SD2->D2_SERIE,03)
		cLin := Stuff(cLin,32,03,cCpo)			// Serie NF
		cCpo := PADR(SD2->D2_ITEM,03)
		cLin := Stuff(cLin,35,03,cCpo)			// Item NF
		cCpo := PADR(SD2->D2_COD,20)
		cLin := Stuff(cLin,38,20,cCpo)			// Codigo Item
		//		cCpo := PADR(StrZero(SD2->D2_TOTAL*100,12),12)
		IF nFrete > 0
			//cCpo := PADR(StrZero((SD2->D2_TOTAL+nFrete)*100,12),12) - Daniel - Alterado apos usuario Calos req. val. total 
			cCpo := PADR(StrZero((SD2->D2_VALBRUT)*100,12),12)
			nFrete := 0
		ELSE
			//cCpo := PADR(StrZero((SD2->D2_TOTAL+nFrete)*100,12),12)
			cCpo := PADR(StrZero((SD2->D2_VALBRUT)*100,12),12)  
		ENDIF
		cLin := Stuff(cLin,58,12,cCpo)			// Valor total do item
		cCpo := PADR(StrZero(nPesoBru*100*SD2->D2_QUANT,15),15)
		cLin := Stuff(cLin,70,15,cCpo)			// Peso Bruto Total do Item
		cCpo := Space(15)
		cLin := Stuff(cLin,85,15,cCpo)			// Peso Cubado - Bco
		cCpo := PADR(StrZero(nPesoLiq*100*SD2->D2_QUANT,15),15)
		cLin := Stuff(cLin,100,15,cCpo)			// Peso liquido total do item.
		cCpo := Space(04)
		cLin := Stuff(cLin,115,04,cCpo)			// Nro.Volumes do item - Verficar???
		cCpo := Space(10)
		cLin := Stuff(cLin,119,10,cCpo)			// Vlr.Cubagem - Bco
		cCpo := PADR(SD2->D2_CONTA,15)
		cLin := Stuff(cLin,129,15,cCpo)			// Conta Contabil
		cCpo := PADR(SD2->D2_CCUSTO,10)
		cLin := Stuff(cLin,144,10,cCpo)			// Centro de Custo
		cCpo := StrZero(Val(Subs(StrZero(SD2->D2_QUANT*1000000,15),1,11)),15)
		//		cCpo := PADR(StrZero(SD2->D2_QUANT,15,6),15)
		cLin := Stuff(cLin,154,15,cCpo)			// quantidade faturada do item
		cCpo := PADR(SD2->D2_UM,03)
		cLin := Stuff(cLin,169,03,cCpo)			// Unidade de medida do item
		
		U_GravaL2(nHdl, cLin)
		
		DbSelectArea("SD2")
		dbSkip()
	EndDo
	
	DbSelectArea("TM2")
	DbSkip()
	
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ณ
//ณ cao anterior.                                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

fClose(nHdl)
//Close(oGeraTxt)

MsgStop("Arquivo Gerado com sucesso no diretorio " +alltrim( _cLocal) + ", por favor, verificar!!" )

Set Century off

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GravaL2 บ Autor ณ Wanderley          บ Data ณ  25/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria as perguntas novas para o GKO                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EXPGKO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GravaL2(nHdl, cLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ณ
//ณ linha montada.                                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	Endif
Endif

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetInfo   บ Autor ณ Wanderley          บ Data ณ  26/04/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna Tipo da Nota e CFOP a partir de uma regra determi- บฑฑ
ฑฑบ          ณ nada                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EXPGKO                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RetInfo2()

Local aArea := GetArea()
Local cTipo := Space(04)

DbSelectArea("SD2")
DbSetOrder(3)
If DbSeek(xFilial("SD2")+TM2->F2_DOC+TM2->F2_SERIE)
	If 	Subs(SD2->D2_CF,1,2) == "51"  .or.;
		Subs(SD2->D2_CF,1,2) == "54"  .or.;
		Subs(SD2->D2_CF,1,3) == "550" .or.;
		Subs(SD2->D2_CF,1,2) == "61"  .or.;
		Subs(SD2->D2_CF,1,2) == "64"  .or.;
		Subs(SD2->D2_CF,1,3) == "650"
		cTipo := "VDA "
	//EndIf
	ElseIf 	Subs(SD2->D2_CF,1,3) == "515" .or.;
		Subs(SD2->D2_CF,1,3) == "615"
		cTipo := "TRF "
	//EndIf
	ElseIf 	SD2->D2_CF == "5911" .or.;
		SD2->D2_CF == "6911" .or.;
		SD2->D2_CF == "7949"
		cTipo := "AMT "
	//EndIf
	ElseIf 	SD2->D2_CF == "5910" .or.;
		SD2->D2_CF == "6910" .or.;
		SD2->D2_CF == "7910"
		cTipo := "BON "
	Else             
	cTipo := "VDA "
	EndIf
	
	/* Regra de Brinde abolida provisoriamente. Segue como estava no Magnus:
	If 	SD2->D2_CF == "5910A" .or.;
	SD2->D2_CF == "5910B" .or.;
	SD2->D2_CF == "6910A".or.;
	SD2->D2_CF == "6910B"
	cTipo := "BRIN"
	EndIf
	*/
EndIf

RestArea(aArea)

Return({cTipo,SD2->D2_CF})


