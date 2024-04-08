Static aFormBatch:={}
Static __cFileLog
Static __aErrAuto	:= {}
Static __CtbFilVld		// Filial para validacao CTB
Static __aCache := {}

#INCLUDE "rwmake.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.CH"
#include "TbiCode.ch"
#include "TbiConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  RESTA09    บAutor  ณJeferson Simao      บ Data ณ 05/08/2008  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo do GKO                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 / Brascola / Importacao                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function AESTA09(aemp)
local lJob := .t.
Public __cUserId := "000001"
Private lRet := .T.

ConOut("> AESTA09 - Importa GKO... Inicio 1: "+Time())

//chamar desta maneira: U_CALLJOB("01",01"), U_CALLJOB("01",02")

RPCSetType(3)  // Nao utilizar licenca
Prepare Environment Empresa aemp[1] Filial aemp[2] Modulo "EST" Tables "SC7", "SF1", "SD1", "CTT", "SA2" ,"SA1", "SB1","SF4", "SB2", "SB3", "SB8", "SZG", "SZH", "SZI", "SE4", "SED"
fImportaGKO(lJob)

return(.T.)


User Function RESTA09()

	MsgRun( 'Executando Consulta', 'Aguarde...', {|| fImportaGKO(.f.) } )

return(.T.)


Static Function fImportaGKO(lJob)
Local cPerg := U_CriaPerg('ESTA09')
Local aRegs := {}
Private cEmail := "djeison.xavier@brascola.com.br;fernando.maia@brascola.com.br" 
//Private cEmail := "fernando.maia@brascola.com.br"
Private cProg  := 'ESTA09' 

//ConOut("> FIMPORTAGKO - Importa GKO... Inicio 2: "+Time())

if !lJob
	if !Pergunte(cPerg,.T.)
		return
	endif
endif

ExecRelEST(lJob)

/*
dbSelectArea("SZH")
dbSetOrder(2)
If dbSeek(xFilial("SZH")+cProg)
If SZH->ZH_ATIVO <> "S"
Return
Endif
Else
Return
Endif

cEmail		:= U_RWF003("ESTA09")
//cEmail := EXECBLOCK("BI005",.F.,.F.)
If Empty(cEmail)
Return
Endif

ExecRelEST(lJob)

Return
*/


Static Function ExecRelEST(lJob)
Local oExcelApp
Local cAlias	:= 'ESTA09'
Local cQuery	:= ''
Local _TMP		:= {}
Local _aCampos	:= {}
Local cTESCTR	:= "211"
Local cCCustCTR := "4351"
Local cProduto  := "6940025        "
Local cCondPAD	:= "004"
Local aReg 		:= {}
Local aItemNE	:= {}
Local aCabNE	:= {}
Local aErros	:= {}
Local lOk		:= .F.
Local cIDNC		:= ""
Local aBRParametros := {}

//ConOut("> EXECRELEST - Importa GKO... Inicio 3: "+Time())

aBRParametros := Separa(GetMV("BR_000042"),"/")




//  89219600
/*
SELECT DISTINCT A.IDNC,A.CDTIPONC,A.CDNC,A.CDSERIENC,A.TPPESSOATRANSP,A.CNPJCPFTRANSP,
A.DSIEDESTTRANSP,A.CDPARRESPFRETE, A.CNPJPARRESPFRETE,A.DTREGISTRONC,A.DTEMISSAONC,
A.CDNATUREZAOPERACAO,A.VRFRETEAPAGAR,A.VRDESCONTO,A.STSUBSTTRIBUTARIAICMS,A.DSUFORIGEM,
A.DSUFDESTINO,A.CDFATURA,A.TOTVRRATFRETECOBRADONC,B.CODIMPOSTO,B.VRBASECALIMPOSTO,
B.PCALIQUOTAIMPOSTO,B.VRIMPOSTO,B.TPTRIBICMS,B.TPTRIBUTACAO, C.CNPJCPFPARDESTREMET
FROM MERCURIO.GKOSCF.GKOSCF.INTNC700_CAB A, MERCURIO.GKOSCF.GKOSCF.INTNC720_IMP B,
MERCURIO.GKOSCF.GKOSCF.INTNC740_NF C
WHERE DTEMISSAONC > '20080701' AND A.IDNC = B.IDNC AND A.IDNC = C.IDNC
ORDER BY  CNPJCPFTRANSP,CDNC,CDSERIENC
*/

if lJob
	cQuery := " SELECT DISTINCT A.IDNC,A.CDTIPONC,A.CDNC,A.CDSERIENC,A.TPPESSOATRANSP,A.CNPJCPFTRANSP, "
	cQuery += " A.DSIEDESTTRANSP,A.CDPARRESPFRETE, A.CNPJPARRESPFRETE,A.DTREGISTRONC,A.DTEMISSAONC, "
	cQuery += " A.CDNATUREZAOPERACAO,A.VRFRETEAPAGAR,A.VRDESCONTO,A.STSUBSTTRIBUTARIAICMS,A.DSUFORIGEM, "
	cQuery += " A.DSUFDESTINO,A.CDFATURA,A.TOTVRRATFRETECOBRADONC,A.DSCHAVEACESSO,B.CODIMPOSTO,B.VRBASECALIMPOSTO, "
	cQuery += " B.PCALIQUOTAIMPOSTO,B.VRIMPOSTO,B.TPTRIBICMS,B.TPTRIBUTACAO, C.CNPJCPFPARDESTREMET "
	cQuery += " FROM MERCURIO.GKOSCF.GKOSCF.INTNC700_CAB A, MERCURIO.GKOSCF.GKOSCF.INTNC720_IMP B, "
	cQuery += " MERCURIO.GKOSCF.GKOSCF.INTNC740_NF C "   
	//cQuery += " WHERE (DTEMISSAONC >= '20080901' OR A.DTREGISTRONC >= '20080901') AND A.IDNC = B.IDNC AND A.IDNC = C.IDNC "
	cQuery += " WHERE A.IDNC = B.IDNC AND A.IDNC = C.IDNC  "  
	//*cQuery += " AND A.CNPJCPFTRANSP >= '78815958000128' AND  A.CNPJCPFTRANSP <= '78815958000128'
	//*cQuery += " AND A.CNPJCPFTRANSP >= '83083428000172' AND  A.CNPJCPFTRANSP <= '83083428000172' 
	//*cQuery += " AND A.CNPJCPFTRANSP >= '79942140000643' AND  A.CNPJCPFTRANSP <= '79942140000643'
	//*cQuery += " AND A.CNPJCPFTRANSP >= '61105060000163' AND  A.CNPJCPFTRANSP <= '61105060000163' 
	//cQuery += " AND A.CNPJCPFTRANSP >= '79422648000106' AND  A.CNPJCPFTRANSP <= '79422648000106'
	cQuery += " ORDER BY  CNPJCPFTRANSP,CDNC,CDSERIENC "      
	ConOut("> EXECRELEST - query 1... Inicio 4: "+Time())
	
else
	cQuery := " SELECT DISTINCT A.IDNC,A.CDTIPONC,A.CDNC,A.CDSERIENC,A.TPPESSOATRANSP,A.CNPJCPFTRANSP, "
	cQuery += " A.DSIEDESTTRANSP,A.CDPARRESPFRETE, A.CNPJPARRESPFRETE,A.DTREGISTRONC,A.DTEMISSAONC, "
	cQuery += " A.CDNATUREZAOPERACAO,A.VRFRETEAPAGAR,A.VRDESCONTO,A.STSUBSTTRIBUTARIAICMS,A.DSUFORIGEM, "
	cQuery += " A.DSUFDESTINO,A.CDFATURA,A.TOTVRRATFRETECOBRADONC,A.DSCHAVEACESSO,B.CODIMPOSTO,B.VRBASECALIMPOSTO, "
	cQuery += " B.PCALIQUOTAIMPOSTO,B.VRIMPOSTO,B.TPTRIBICMS,B.TPTRIBUTACAO, C.CNPJCPFPARDESTREMET "
	cQuery += " FROM MERCURIO.GKOSCF.GKOSCF.INTNC700_CAB A, MERCURIO.GKOSCF.GKOSCF.INTNC720_IMP B, "
	cQuery += " MERCURIO.GKOSCF.GKOSCF.INTNC740_NF C "
	//cQuery += " WHERE (DTEMISSAONC >= '20080901' OR A.DTREGISTRONC >= '20080901') AND A.IDNC = B.IDNC AND A.IDNC = C.IDNC "
	cQuery += " WHERE A.IDNC = B.IDNC AND A.IDNC = C.IDNC  "
	cQuery += " AND A.CNPJCPFTRANSP >= '"+MV_PAR01+"' AND  A.CNPJCPFTRANSP <='"+MV_PAR02+"' "
	cQuery += " AND A.CDNC >= '"+MV_PAR03+"' AND A.CDNC <= '"+MV_PAR04+"' "
	cQuery += " ORDER BY  CNPJCPFTRANSP,CDNC,CDSERIENC "
	ConOut("> EXECRELEST - query 2... Inicio 4: "+Time())
endIF
cQuery := ChangeQuery(cQuery)
//dbUseArea( .T.,'TOPCONN', TcGenQry(,, cQuery ), cAlias,  .T., .T. )
ConOut("> EXECRELEST - query fim... Inicio 5: "+Time())
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .T. )

ConOut("> EXECRELEST - query fim... Inicio 6: "+Time())
//MemoWrite("\QUERYSYS\RESTA09.SQL",cQuery)

tcSetField( cAlias, 'IdNC','N',15,)
tcSetField( cAlias, 'CdTipoNC','C',4,)
tcSetField( cAlias, 'CdNC','C',12,)
tcSetField( cAlias, 'CdSerieNC','C',5,)
tcSetField( cAlias, 'TpPessoaTransp','N',1,)
tcSetField( cAlias, 'CNPJCPFTransp','N',14,)
tcSetField( cAlias, 'DsIEDestTransp','C',15,)
tcSetField( cAlias, 'CdParRespFrete','C',14,)
tcSetField( cAlias, 'CNPJParRespFrete','N',14,)
tcSetField( cAlias, 'DtRegistroNC','N',10,)
tcSetField( cAlias, 'DTEMISSAONC','N',10,)
tcSetField( cAlias, 'CdNaturezaOperacao','C',6,)
tcSetField( cAlias, 'VRFRETEAPAGAR','N',15,2)
tcSetField( cAlias, 'VrDesconto','N',15,2)
tcSetField( cAlias, 'StSubstTriburariaIcms','C',1,)
tcSetField( cAlias, 'DsUFOrigem','C',2,)
tcSetField( cAlias, 'DsUFDestino','C',2,)
tcSetField( cAlias, 'CdFatura','C',12,)
tcSetField( cAlias, 'TotVrRatFreteCobradoNC','N',15,2)
tcSetField( cAlias, 'CODIMPOSTO','N',3,)
tcSetField( cAlias, 'VRBASECALIMPOSTO','N',15,2)
tcSetField( cAlias, 'PCALIQUOTAIMPOSTO','N',8,2)
tcSetField( cAlias, 'VRIMPOSTO','N',15,2)
tcSetField( cAlias, 'TPTRIBICMS','C',2,)
tcSetField( cAlias, 'TPTRIBUTACAO ','C',2,)
tcSetField( cAlias, 'CNPJCPFPARDESTREMET','N',14,)   
tcSetField( cAlias, 'DSCHAVEACESSO','C',44,) //Fernando
cMessage := ""
DBSELECTAREA(cAlias)
(cAlias)->(DBGOTOP())
WHILE !(cAlias)->(EOF())
	//cTESCTR	:= cTESCTR
	//cCCustCTR	:= cCCustCTR
	//cProduto	:= cProduto
	cChave		:= (cAlias)->DSCHAVEACESSO   
	cEspecie     := 'CTR'
	
	//FERNANDO: 12/06/13
	If !Empty(cChave)
		cEspecie:= 'CTE'
	EndIf	                    
	
	cCTR		:= (cAlias)->CdNC
	cCTRN       := ALLTRIM((cAlias)->CdNC)
	IF LEN(cCTRN) <= 9
		cCTRN:= STRZERO(val(cCTRN),9)
	ELSE
		cCTRN:=RIGHT(cCTRN,9)
	ENDIF
	
	cSerie		:= UPPER(SUBSTR((cAlias)->CdSerieNC,1,1))
	if cSerie <> "U"
		cSerie := (cAlias)->CdSerieNC
		if Alltrim(cSerie) == "180"
			cSerie := "U"
		Endif
	endif
	
	//	cSerie := "Z"  //usar apenas em teste
	
	cDestinoCTR := SUBSTR(ALLTRIM(STRZERO((cAlias)->CNPJCPFPARDESTREMET,14)),1,8)
	
	IF cDestinoCTR == '61105060' //transferencia
		cProduto	:= PADR(aBRParametros[3],15)
		cTESCTR		:= aBRParametros[4]
	Else //venda
		cProduto	:= PADR(aBRParametros[1],15)
		cTESCTR		:= aBRParametros[2]
	Endif
	
	if (cAlias)->(CODIMPOSTO) == 8
		(cAlias)->(DBSKIP())
		LOOP
	ENDIF
	
	
	
	DbSelectArea("SA2")
	SA2->(DbSetOrder(3))
	cCNPJCTR := STRZERO((cAlias)->CNPJCPFTransp,14)
	
	//IF cCNPJCTR ==  "78815958000128"
	//	cCNPJCTR := "78815958000632"
	//Endif
	
	If SA2->(dbSeek(xFilial("SA2")+Alltrim(cCNPJCTR)))
		cForneceCTR	:= SA2->A2_COD
		cLojaCTR	:= SA2->A2_LOJA
		cCondCTR	:= SA2->A2_COND
		cNReduzCTR	:= SA2->A2_NREDUZ
		cNatureza	:= SA2->A2_NATUREZ
		cCCustCTR	:= ""
		
		if SB1->(dbSeek(xFilial("SB1")+cProduto))
			cPrdDesc	:= SB1->B1_DESC
			cCCustCTR   := SB1->B1_CC
		endif
		
		if SA2->A2_MSBLQL == '1'
			cMessage += "O fornecedor "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR+" esta bloqueado."
			AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"O fornecedor "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR+" esta bloqueado."})
			(cAlias)->( dbSkip() )
			Loop
		endif
		///validar cc incorreto
		/*
		if Empty(Alltrim(cCCustCTR))
		cMessage += "Centro de custo nใo cadastrado/invalido para o produto: "+Alltrim(cProduto)+". "
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Centro de custo nใo cadastrado para o produto: "+Alltrim(cProduto)})
		(cAlias)->( dbSkip() )
		Loop
		else
		if CTT->(dbSeek(xFilial("CTT")+cCCustCTR))
		if CTT->CTT_BLOQ == '1'
		cMessage += "O centro de custo "+Alltrim(cCCustCTR)+" cadastrado no produto "+Alltrim(cProduto)+" esta bloqueado."
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"O centro de custo "+Alltrim(cCCustCTR)+" cadastrado no produto "+Alltrim(cProduto)+" esta bloqueado."})
		(cAlias)->( dbSkip() )
		Loop
		endif
		else
		cMessage += "Centro de custo "+cCCustCTR+" ้ invalido para o produto: "+Alltrim(cProduto)
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Centro de custo "+cCCustCTR+" ้ invalido para o produto: "+Alltrim(cProduto)})
		(cAlias)->( dbSkip() )
		Loop
		endif
		endif
		*/
		if !Empty(Alltrim(cCCustCTR))
			if CTT->(dbSeek(xFilial("CTT")+cCCustCTR))
				if CTT->CTT_BLOQ == '1'
					cMessage += "O centro de custo "+Alltrim(cCCustCTR)+" cadastrado no produto "+Alltrim(cProduto)+" esta bloqueado."
					AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"O centro de custo "+Alltrim(cCCustCTR)+" cadastrado no produto "+Alltrim(cProduto)+" esta bloqueado."})
					(cAlias)->( dbSkip() )
					Loop
				endif
			else
				cMessage += "Centro de custo "+cCCustCTR+" ้ invalido para o produto: "+Alltrim(cProduto)
				AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Centro de custo "+cCCustCTR+" ้ invalido para o produto: "+Alltrim(cProduto)})
				(cAlias)->( dbSkip() )
				Loop
			endif
		endif
		
		
		if Empty(Alltrim(cCondCTR))
			cMessage += "Condicao de pagamento nใo cadastrada para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR
			AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Condicao de pagamento nใo cadastrada para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR})
			(cAlias)->( dbSkip() )
			Loop
		else
			if SE4->(dbSeek(xFilial("SE4")+cCondCTR))
				if Upper(SE4->E4_STATUS) == 'I'
					cMessage += "A condicao de pagamento "+Alltrim(cCondCTR)+" cadastrada no fornecedor "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR+" esta inativa."
					AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"A condicao de pagamento "+Alltrim(cCondCTR)+" cadastrada no fornecedor "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR+" esta inativa."})
					(cAlias)->( dbSkip() )
					Loop
				endif
			else
				cMessage += "A condicao de pagamento "+Alltrim(cCondCTR)+"  ้ invalida para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR
				AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"A condicao de pagamento "+Alltrim(cCondCTR)+"  ้ invalida para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR})
				(cAlias)->( dbSkip() )
				Loop
			endif
		endif
		/*
		if Empty(Alltrim(cNatureza))
		cMessage += "Natureza nใo cadastrada para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Natureza nใo cadastrada para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR})
		(cAlias)->( dbSkip() )
		Loop
		else
		if SE4->(dbSeek(xFilial("SED")+cNatureza))
		
		if Upper(SED->ED_BLQ) == '1'
		cMessage += "A natureza "+Alltrim(cNatureza)+" cadastrada no fornecedor "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR+" esta bloqueada."
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"A natureza "+Alltrim(cNatureza)+" cadastrada no fornecedor "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR+" esta bloqueada."})
		(cAlias)->( dbSkip() )
		Loop
		endif
		
		else
		cMessage += "A natureza "+Alltrim(cNatureza)+"  ้ invalida para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"A natureza "+Alltrim(cNatureza)+"  ้ invalida para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR})
		(cAlias)->( dbSkip() )
		Loop
		endif
		endif
		*/
		DbSelectArea("SED")
		SED->(DbSetOrder(1))
		
		cNatureza := Alltrim(cNatureza)
		if !Empty(Alltrim(cNatureza))
			if !SED->(dbSeek(xFilial("SED")+cNatureza))
				cMessage += "A natureza "+Alltrim(cNatureza)+"  ้ invalida para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR
				AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"A natureza "+Alltrim(cNatureza)+"  ้ invalida para o fornecedor: "+cForneceCTR+"/"+cLojaCTR+" - "+cNReduzCTR})
				(cAlias)->( dbSkip() )
				Loop
			endif
		endif
		
	Else
		cMessage += ("Fornecedor:"+Alltrim((cAlias)->CNPJCPFTransp)+" nใo cadastrado.")
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Fornecedor:"+Alltrim((cAlias)->CNPJCPFTransp)+" nใo cadastrado."})
		(cAlias)->( dbSkip() )
		Loop
	Endif
	cEmissaoCTR := ALLTRIM(STR((cAlias)->DTEMISSAONC))
	cEmissaoCTR := Substr(cEmissaoCTR,7,2)+"/"+Substr(cEmissaoCTR,5,2)+"/"+Substr(cEmissaoCTR,1,4)
	dEmissaoCTR := CTOD(cEmissaoCTR)
	
	if dEmissaoCTR < CTOD("01/01/2011")
		cMessage += ("Emissao "+DTOS(dEmissaoCTR)+" nใo cadastrada.")
		AADD(aErros,{Alltrim(cCNPJCTR),cCTR+"/"+cSerie,"Emissao "+DTOS(dEmissaoCTR)+" nใo cadastrada."})
		(cAlias)->( dbSkip() )
		Loop
	endif
	
	nIDNC		:= (cAlias)->IDNC
	nIcm    	:= (cAlias)->PCALIQUOTAIMPOSTO
	nValIcm		:= (cAlias)->VRIMPOSTO
	nQtde   	:= 1
	nUnitar 	:= (cAlias)->VRFRETEAPAGAR
	nTotal		:= Round(nQtde * nUnitar,2)
	aReg := {}
	aItemNE := {}
	
	
	AAdd(aReg, {"D1_COD"	,cProduto	, NIL})
	AAdd(aReg, {"D1_TES"	,cTESCTR    , NIL})
	//AAdd(aReg, {"D1_LOTECTL",""    		, NIL})
	AAdd(aReg, {"D1_CC"		,cCCustCTR	, NIL})
	AAdd(aReg, {"D1_QUANT"	,nQtde 		, NIL})
	AAdd(aReg, {"D1_PICM"	,nIcm 		, NIL})
	AAdd(aReg, {"D1_VUNIT"	,nUnitar	, NIL})
	AAdd(aReg, {"D1_TOTAL"	,nTotal		, NIL})
	AAdd(aReg, {"D1_VALICM"	,nValIcm	, NIL})
	aAdd(aItemNE,aReg)
	(cAlias)->( dbSkip() )
	
	if cCNPJCTR <> STRZERO((cAlias)->CNPJCPFTransp,14) .OR. cCTR <> (cAlias)->CdNC .OR. cSerie <> (cAlias)->CdSerieNC
		dbSelectArea('SF1')
		sf1->(dbSetOrder(1)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		//	if sf1->(dbSeek(xFilial("SF1")+(cCTRN)+SUBSTR(cSerie,1,3)+SUBSTR(cForneceCTR,1,6)+SUBSTR(cLojaCTR,1,2)))
		if sf1->(dbSeek(xFilial("SF1")+substr(cCTRN,1,6)+space(3)+PADR(cSerie,3)+PADR(cForneceCTR,6)+PADR(cLojaCTR,2)))
			//if sf1->(dbSeek(xFilial("SF1")+PADR(cCTR,6)+PADR(cSerie,3)+PADR(cForneceCTR,6)+PADR(cLojaCTR,2)))
			lOk := .T.
			cMessage += "O conhecimento: " + cCTR + " ja estava lan็ado. Esse registro nใo sera re-importado."
			AADD(aErros,{cCNPJCTR,cCTR+"/"+cSerie,"O conhecimento: " + cCTR + " ja estava lan็ado. Esse registro nใo sera re-importado."})
		Else
			aCabNE := {}
			AADD(aCabNE,{"F1_DOC"		,substr(cCTRN,1,9),NIL})
			AADD(aCabNE,{"F1_SERIE"		,SUBSTR(cSerie,1,3),NIL})
			AADD(aCabNE,{"F1_TIPO"		,'N'		,NIL})
			AADD(aCabNE,{"F1_FORMUL"	,'N'		,NIL})
			AADD(aCabNE,{"F1_EMISSAO"	,dEmissaoCTR,NIL})
			AADD(aCabNE,{"F1_FORNECE"	,cForneceCTR,NIL})
			AADD(aCabNE,{"F1_LOJA"		,cLojaCTR	,NIL})
			AADD(aCabNE,{"F1_FRETE"		,0.00		,NIL})
			AADD(aCabNE,{"F1_COND"		,cCondCTR	,NIL})
			//AADD(aCabNE,{"F1_ESPECIE"	,'CTE'		,NIL})
			AADD(aCabNE,{"F1_ESPECIE"	,cEspecie   ,NIL}) //Fernando: 12/06/13  
			AADD(aCabNE,{"F1_CHVNFE"	,cChave		,NIL}) //Fernando
			//AADD(aCabNE,{"F1_NATUREZA"	,'22006'	,NIL})
			//A103NATURE := '22006'
			//CNATUREZA := '22006' //21201
			lMSErroAuto := .F.
			lMSHelpAuto := .F.
			//	PROXNUM(.T.)
			Begin Transaction
			MSExecAuto({|x,y,z| MATA103(x,y,z)},aCabNE,aItemNE,3)  //chama rotina automatica
			//	MsgBox("Inclui "+cCTR)//+cMessage)
			If lMsErroAuto
				//				MostraErro("\cprova\","erro_rESTA09.txt")
				cMessage += "Erro no processo automatico. Entrar em contato com TI."
				AADD(aErros,{cCNPJCTR,cCTR+"/"+cSerie,"O conhecimento: " + cCTR + "Erro no processo automatico. Entrar em contato com TI."})
				lOkArquivo := .f.
				DisarmTransaction()
				//break
			Endif
			End Transaction
			If !lMSErroAuto
				//Excluir registros do GKO
				lOk	:= .T.
			Else
				cBody := MemoRead(NomeAutoLog())
				//Gravalog()
				//cAnexos:="\cprova\erro_rESTA09.txt"
				cEmail := "djeison.xavier@brascola.com.br;fernando.maia@brascola.com.br"    
				//cEmail := "fernando.maia@brascola.com.br"
				cNomArqErro := NomeAutoLog()
				cNomNovArq := "\cprova\RFATM5050PCD.##R"
				If MsErase(cNomNovArq)
					__CopyFile(cNomArqErro,cNomNovArq)
				EndIf
				MsErase(cNomArqErro)
				cAnexos := cNomNovArq
				MostraErro("\cprova\erro_rESTA09.txt")
				U_SendMail(cEmail,"Inconsistencias Imp Gko",cBody,cAnexos,.T.)
				lMsErroAuto := .f.
			Endif
		Endif
		if lOk
			IF EMPTY(cIDNC)
				cIDNC	+= "('"+ALLTRIM(STR(nIDNC))+"'"
			ELSE
				cIDNC	+= ",'"+ALLTRIM(STR(nIDNC))+"'"
			ENDIF
		Endif
		
		
	EndIF
	lOk := .F.
ENDDO
cIDNC := cIDNC+")"
//MsgBox("Exclui "+cIDNC)//+cMessage)
(cAlias)->( dbCloseArea() )
cDelSQL := "DELETE FROM MERCURIO.GKOSCF.GKOSCF.INTNC700_CAB WHERE IDNC IN "+cIDNC+";"+chr(13)+chr(10)
cDelSQL += "DELETE FROM MERCURIO.GKOSCF.GKOSCF.INTNC720_IMP WHERE IDNC IN "+cIDNC+";"+chr(13)+chr(10)
cDelSQL += "DELETE FROM MERCURIO.GKOSCF.GKOSCF.INTNC740_NF  WHERE IDNC IN "+cIDNC+";"+chr(13)+chr(10)
cDelSQL += "DELETE FROM MERCURIO.GKOSCF.GKOSCF.INTNC750_CTA WHERE IDNC IN "+cIDNC+";"+chr(13)+chr(10)
TCSQLEXEC(cDelSQL)
//MemoWrite("\QUERYSYS\TESTE06.TXT",cDelSQL)

If !Empty (aErros)
	fMailTo(aErros)
Endif  

ConOut("> Concluido Processo de Importa็ใo do GKO: "+Time())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaInconบAutor  ณRogerio Nagy        บ Data ณ  02/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia inconsistencias encontradas por e-mail               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Brascola                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fMailTo(aMensagem)

Local _cServer := GetMV("MV_RELSERV")   	// Servidor
Local _cConta  := GetMV("MV_RELACNT")   	// Conta
Local _cPass   := GetMV("MV_RELPSW")   	// Senha da conta
Local _cResp   := cEmail//'jeferson.simao@brascola.com.br'		// Responsavel pelas inconsistencias do certificado
Local _cBody	:= " "
Local _cBody1	:= ""
Local _cErro 	:= ""
Local lOk 		:= .t.
Local lSegEmail	:= .F.
Local _aBody	:= {}

_cBody	:= '<html><head><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">'
_cBody	+= '<meta name="GENERATOR" content="Microsoft FrontPage Express 2.0">'
_cBody	+= '<title>Alerta sobre Conhecimentos de Frete</title>'
_cBody	+= '</head><body bgcolor="#FFFFFF">'
//_cBody	+= '<form action="mailto:%WFMailTo%" method="POST" name="FrontPage_Form1">'
_cBody	+= '    <p><font size="2" color="#0000FF" face="Verdana"><b>Alerta sobre Conhecimentos de Frete</b></font></p>'
_cBody	+= '    <table border="1" width=100%>'
_cBody	+= '        <tr>'
_cBody	+= '            <td bgcolor="#99CCFF"><font size="2" face="Arial"><b>CNPJ</b></font></td>'
_cBody	+= '            <td bgcolor="#99CCFF"><font size="2" face="Arial"><b>Conhecimento</b></font></td>'
_cBody	+= '            <td bgcolor="#99CCFF"><font size="2" face="Arial"><b>Alerta</b></font></td>'
_cBody	+= '        </tr>'
_j := 1
AADD(_aBody,"")
_aBody[_j] := _cBody
For _i := 1 To Len(aMensagem) //1048551
	//	MemoWrite("\testejef.txt",STR(_i))
	if _i == 3000 .OR. _i == 6000 .OR. _i == 9000 .OR. _i == 12000
		_j:= _j+1
		AADD(_aBody,"")
		_aBody[_j] := _cBody
	Endif
	_aBody[_j]	+= '        <tr>'
	_aBody[_j]	+= '            <td><font size="2" face="Arial">'+aMensagem[_i][1]+'</font></td>'
	_aBody[_j]	+= '            <td><font size="2" face="Arial">'+aMensagem[_i][2]+'</font></td>'
	_aBody[_j]	+= '            <td><font size="2" face="Arial">'+aMensagem[_i][3]+'</font></td>'
	_aBody[_j]	+= '        </tr>'
Next _i
//_cBody	+= '</table></html>'



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia e-mail para aviso de Inconsistencia                        ณ
//ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPass RESULT lOk

If lOk .AND. Len(aMensagem) > 0
	//Envio de e-mail HTML
	For _i := 1 To len(_aBody)
		SEND MAIL FROM _cConta ;
		TO _cResp ;
		SUBJECT 'Alerta sobre Conhecimentos de Frete '+Alltrim(STR(_i)) ;
		BODY _aBody[_i]+'</table></html>' ;
		RESULT lOk
		If !lOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgInfo(cError,OemToAnsi("Erro no envio de e-mail"))
		EndIf
	Next _i
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	MsgInfo(cError,OemToAnsi("Erro na conexใo com o servidor de e-mail"))
EndIf

DISCONNECT SMTP SERVER

Return .t.
