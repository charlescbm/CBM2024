#include "protheus.ch"
#include "topconn.ch"

// *********************************************************************** //
// INOJ010 - Job para importar e processar XML (CTE) pelas rotinas GFE     //
// @copyright (c) 2024-02-15 > Marcelo da Cunha > INOVEN                   //
// *********************************************************************** //

User Function INOJ010()
	********************
	LOCAL nFile := 0, cLCKFile := "", cMsg := ""
	SET DATE FORMAT TO "DD/MM/YYYY"

	// Controle de Semaforo
	cLCKFile := Lower("\semaforo\inoj010.lck")
	If ((nFile := FCreate(cLCKFile)) == -1)
		FWLogMsg("INFO",nil,"INOJ010",nil,nil,nil,"Não foi possivel gerar o arquivo "+cLCKFile+". Verifique se algum processo ficou preso - "+Time(),nil,nil,nil)
		Return (.F.)
	Endif
	cMsg := "INOJ010 - Thread ID: "+Alltrim(Str(ThreadID()))+" - Data: "+dtoc(MsDate())+" - Hora: "+Time()
	FWrite(nFile,cMsg,Len(cMsg))

	RPCSetType(3)
	RPCSetEnv("01","0102","","","GFE","INOJ010",{"GU3"})
	FWLogMsg("INFO",nil,"INOJ010",nil,nil,nil,"INOJ010 - INI - Importacao e Processamento GFE - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)

	// Importacao dos CTE's pendentes
	StartJob("u_IJ010Pend",GetEnvServer(),.T.,cEmpAnt,cFilAnt)
	// Processamento dos CTE's
	StartJob("u_IJ010Proc",GetEnvServer(),.T.,cEmpAnt,cFilAnt)
	// Efetivar lançamento dos documentos de frete
	StartJob("u_IJ010Lanc",GetEnvServer(),.T.,cEmpAnt,cFilAnt)

	FWLogMsg("INFO",nil,"INOJ010",nil,nil,nil,"INOJ010 - FIM - Importacao e Processamento GFE - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)

	// Fecho controle de semaforo
	If (nFile != -1)
		FClose(nFile)
		FErase(cLCKFile)
	Endif

Return

User Function IJ010Pend(xEmp,xFil)
	******************************
	LOCAL cQry, cAls
	SET DATE FORMAT TO "DD/MM/YYYY"
	RPCSetType(3)
	RPCSetEnv(xEmp,xFil,"","","GFE","IJ010Pend",{"GW3","SF1"})
	FWLogMsg("INFO",nil,"IJ010Pend",nil,nil,nil,"IJ010Pend - "+xEmp+xFil+" - Abrindo Arquivos - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
	cQry := "SELECT GW3.R_E_C_N_O_ MRECGW3 FROM "+RetSqlName("GW3")+" GW3 (NOLOCK) "
	cQry += "WHERE GW3.D_E_L_E_T_ = '' AND GW3_FILIAL = '"+xFilial("GW3")+"' "
	cQry += "AND (GW3_SITREC = '2' OR GW3_SITFIS = '2') "
	cQry += "ORDER BY 1 "
	cAls := GDVDB():query(cQry)
	GW3->(dbSetOrder(1)) ; SF1->(dbSetOrder(1))
	dbSelectArea(cAls)
	While !(cAls)->(Eof())
		GW3->(dbGoto((cAls)->MRECGW3))
		If (GW3->GW3_sitrec == "2") //Pendente
			Reclock("GW3",.F.)
			GW3->GW3_sitrec := iif(hasInvoice(),"4","1")
			MsUnlock("GW3")
		Endif
		If (GW3->GW3_sitfis == "2") //Pendente
			Reclock("GW3",.F.)
			GW3->GW3_sitfis := iif(hasInvoice(),"4","1")
			MsUnlock("GW3")
		Endif
		(cAls)->(dbSkip())
	Enddo
	FWLogMsg("INFO",nil,"IJ010Pend",nil,nil,nil,"IJ010Pend - "+xEmp+xFil+" - Status Atualizado - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
	RpcClearEnv()
Return

Static Function hasInvoice()
	*************************
	LOCAL lRetu := .F., aForLoj := {}, cQry, cAls
	aForLoj := GFEA055GFL(GW3->GW3_emisdf) //Retornar Fornecedor e Loja
	cQry := "SELECT COUNT(*) M_CONTA FROM "+RetSqlName("SF1")+" SF1 (NOLOCK) "
	cQry += "WHERE SF1.D_E_L_E_T_ = '' AND F1_FILIAL = '"+xFilial("SF1")+"' "
	cQry += "AND F1_DOC = '"+GW3->GW3_nrdf+"' AND F1_SERIE = '"+GW3->GW3_serdf+"' "
	cQry += "AND F1_FORNECE = '"+aForLoj[1]+"' AND F1_LOJA = '"+aForLoj[2]+"' "
	cQry += "AND F1_ESPECIE IN ('CTE','CTR','CTA') "
	cAls := GDVDB():query(cQry)
	If !(cAls)->(Eof()).and.((cAls)->M_CONTA > 0)
		lRetu := .T.
	Endif
	GDVDB():queryEnd(cAls)
Return lRetu

User Function IJ010Proc(xEmp,xFil)
	******************************
	LOCAL cDirImp := "", cDirBkp := ""
	SET DATE FORMAT TO "DD/MM/YYYY"
	RPCSetType(3)
	RPCSetEnv(xEmp,xFil,"","","GFE","IJ010Proc",{"GXH","GW1","GW3","GWN"})
	FWLogMsg("INFO",nil,"IJ010Proc",nil,nil,nil,"IJ010Proc - "+xEmp+xFil+" - Abrindo Arquivos - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
	//Configuro diretorio de importacao
	cDirImp := "\EDI\CTE\" ; cDirBkp := ""
	/*
	If !Empty(cDirImp)
		cDirBkp := GetMV("MV_XMLDIR")
		PutMV("MV_XMLDIR",cDirImp)
	Endif
	*/
	FWLogMsg("INFO",nil,"IJ010Proc",nil,nil,nil,"IJ010Proc - "+xEmp+xFil+" - Importacao dos arquivos "+cDirImp+" - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
	GFEA118IMP() //Chamado da rotina de importação do GFE
	/*
	If !Empty(cDirBkp)
		PutMV("MV_XMLDIR",cDirBkp)
	Endif
	*/
	RpcClearEnv()
Return

User Function IJ010Lanc(xEmp,xFil)
	*******************************
	LOCAL cQry, cAls
	SET DATE FORMAT TO "DD/MM/YYYY"
	RPCSetType(3)
	RPCSetEnv(xEmp,xFil,"","","GFE","IJ010Lanc",{"GXH","GW1","GW3","GWN"})
	FWLogMsg("INFO",nil,"IJ010Lanc",nil,nil,nil,"IJ010Lanc - "+xEmp+xFil+" - Abrindo Arquivos - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
	If (GU3->(FieldPos("GU3_XALANC")) == 0)
		FWLogMsg("INFO",nil,"IJ010Lanc",nil,nil,nil,"IJ010Lanc - "+xEmp+xFil+" - Criar o campo GU3_XALANC - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
		Return
	Endif
	//////////////////////////////
	cQry := "SELECT GW3.R_E_C_N_O_ MRECGW3,GU3_XAFILI FROM "+RetSqlName("GW3")+" GW3 (NOLOCK),"+RetSqlName("GU3")+" GU3 (NOLOCK) "
	cQry += "WHERE GW3.D_E_L_E_T_ = '' AND GW3_FILIAL = '"+xFilial("GW3")+"' "
	cQry += "AND GU3.D_E_L_E_T_ = '' AND GU3_FILIAL = '"+xFilial("GU3")+"' "
	cQry += "AND GW3_EMISDF = GU3_CDEMIT AND GW3_SIT IN ('3','4') AND GW3_DTENT >= '"+dtos(MsDate()-60)+"' "
	cQry += "AND (GW3_SITFIS IN ('1','3') OR GW3_SITREC IN ('1','3')) AND GU3_XALANC = 'S' "
	cQry += "ORDER BY GW3.R_E_C_N_O_ "
	cAls := GDVDB():query(cQry)
	GW3->(dbSetOrder(1))
	dbSelectArea(cAls)
	While !(cAls)->(Eof())
		GW3->(dbGoto((cAls)->MRECGW3))
		FWLogMsg("INFO",nil,"IJ010Lanc",nil,nil,nil,"IJ010Lanc - "+xEmp+xFil+" - Lancamento do CTE "+Alltrim(GW3->GW3_nrdf)+" - "+dtoc(MsDate())+" "+Time(),nil,nil,nil)
		dbSelectArea("GW3")
		If (GW3->GW3_sit $ "3/4") //Verifica se o documento está aprovado
			If (GW3->GW3_sitfis $ "1/3") //Fiscal
				GFEA065XF(.T.)
			Endif
			If (GW3->GW3_sitrec $ "1/3") //Recebimento
				GFEA065XC(.T.)
			EndIf
		EndIf
		(cAls)->(dbSkip())
	Enddo
	GDVDB():queryEnd(cAls)
	RpcClearEnv()
Return
