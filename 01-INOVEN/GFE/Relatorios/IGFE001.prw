#INCLUDE "TOTVS.CH"
#Include "Protheus.ch"
#INCLUDE "COLORS.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH" 
#include 'parmtype.ch'
STATIC __cPrgNom

//--------------------------------------------------------------------------------------
/*/
Relatorio relaçao de frete

/*/
//---------------------------------------------------------------------------------------
User Function IGFE001()
	
	Local oReport	:= Nil
	Local cAlias	:= GetNextAlias()
	Private cNomPro := Substr( ProcName() , 3 )
	
	__cPrgNom := Substr( ProcName() , 3 ) + '__'
	
	SX1->( dbSetorder(1) )
	If ( !SX1->( MsSeek( __cPrgNom ) ) )
		FCriaPerg( __cPrgNom )
	EndIf	
	//--Chama pergunta
	If Pergunte( __cPrgNom , .T. )		
		oReport:= FExeQuery(cAlias)
		oReport:PrintDialog()
		(cAlias)->(DbCloseArea())
	EndIf	
	
Return(Nil)    
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FCriaPerg
Função utilizada para criar parametros

@author		.iNi Sistemas
@since     	19/16/17
@version  	P.11              
@param 		cPerg - Nome da pergunta
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FCriaPerg(cPerg)
	
	Local aRegs	 := {}
	//Local aParam := {}
	//Local cParam := ""
	Local xI	 := 0
	Local xJ	 := 0
	
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg := PadR(cPerg,10)

	AADD(aRegs,{cPerg,"01","Data De"	   	,"","","mv_ch1" ,"D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"02","Data Ate"		,"","","mv_ch2" ,"D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"03","Nota De"	   	,"","","mv_ch3" ,"C",09,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"04","Nota Ate"		,"","","mv_ch4" ,"C",09,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"05","Serie De"	   	,"","","mv_ch5" ,"C",03,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"06","Serie Ate"		,"","","mv_ch6" ,"C",03,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"07","Filial De"	   	,"","","mv_ch7" ,"C",04,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"08","Filial Ate"		,"","","mv_ch8" ,"C",04,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	
	
	For xI := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[xI,2])
			If RecLock("SX1",.T.)
				For xJ := 1 To Len(aRegs[xI])
					FieldPut(xJ,aRegs[xI,xJ])
				Next xJ
				MsUnlock()
			EndIf
		EndIf
	Next xI

Return(Nil)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FExeQuery
Função utilizada para buscar os dados

@author		.iNi Sistemas
@since     	11/11/15
@version  	P.11              
@param 		cAlias - Variável contendo a alias da query principal
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FExeQuery(cAlias)
	
    Local cQuery	:= ''
	Local oReport   := NIl
	Local oSection1	:= Nil
	Local aEstrut	:= {}
	Local xI		
	Local nHErp 	:= AdvConnection()
    //Local cAliasSE1 := RetSqlName("SE1")
    //Local cAliasSql := RetSqlName("SE1")  
	//Local cAliasSA1 := RetSqlName("SA1")
	Local cPar1		:= MV_PAR01
	Local cPar2		:= MV_PAR02
	Local cPar3		:= MV_PAR03
	Local cPar4		:= MV_PAR04
	Local cPar5		:= MV_PAR05
	Local cPar6		:= MV_PAR06
	Local cPar7		:= MV_PAR07
	Local cPar8		:= MV_PAR08
	//Local cPar9		:= MV_PAR09
	   
	oReport	:= TReport():New(cNomPro,OemToAnsi("Relatorio Frete "),,{|oReport| FGerRel(oReport,cAlias, nHErp)},OemToAnsi("Relatorio Frete"),.T.)
	oReport:nFontBody := 08
	oReport:SetDevice(4)
	oReport:nLeftMargin:= 0 
	
	oReport:HideParamPage() //Não mostrar parametros
    oReport:HideHeader(.T.)	//Não mostrar cabeçalho
    oReport:HideFooter(.T.)	//Não mostrar rodapé
/*    
    TCCONTYPE("TCPIP")
	_cNomBco := "MSSQL7/AUDIT_TRAIL"      
	_cSrvBco := "192.168.50.212"
	_nTcConn := TCLink(_cNomBco,_cSrvBco)
	If _nTcConn < 0
		MsgAlert(OemToAnsi('Não foi possivel conectar ao banco: '+ _cNomBco ))
		tcSetConn(nHErp)
		Return()
	EndIf
	
*/	
/* CAMPOS RETIRADOS
CASE WHEN GWU_DTENT <> ''	THEN cast(DATEDIFF(DAY,GWU_DTPENT,GWU_DTENT) AS VARCHAR(10))	ELSE '' END DATA_DIF, 
GW1_HRIMPL HORA,
GW1_CDDEST CODDEST,
cQuery +="                     CASE WHEN A1_MUN IN ('RIO BRANCO','MACEIO','MANAUS','MACAPA','SALVADOR','FORTALEZA','BRASILIA','VITORIA','GOIANIA','SAO LUIS','BELO HORIZONTE','CAMPO GRANDE','CUIABA','BELEM' "
cQuery +="					 ,'JOAO PESSOA','RECIFE','TERESINA','CURITIBA' ,'RIO DE JANEIRO','NATAL','PORTO VELHO','BOA VISTA','PORTO ALEGRE','FLORIANOPOLIS','ARACAJU','SAO PAULO','PALMAS') THEN 'CAPITAL'  "                                                                           
cQuery +="					 ELSE                                                                                           "
cQuery +="					                                                                  'INTERIOR/REG.METROP'         "                                                             
cQuery +="																					  END 'LOCALIZ.CIDADE',         "                                                             
cQuery +="																					  ISNULL(CASE WHEN A1_EST IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'NORDESTE' " 
cQuery +="																					  WHEN A1_EST IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'NORTE'    "
cQuery +="																					   WHEN A1_EST IN ('SP','MG','RJ','ES') THEN 'SUDESTE'  "      
cQuery +="																					   WHEN A1_EST IN ('PR','RS','SC') THEN 'SUL' "                
cQuery +="																					   WHEN A1_EST IN ('MS','TO','DF') THEN 'CENTRO OESTE'        END ,'')'REGIAO',  "
ISNULL(GWN_HRSAI,'') HORASAI,
*/

cQuery :=" select GW1_FILIAL FILIAL,GW1_NRDC NF,GW1_SERDC SERIE,GW1_DTEMIS EMISSAO,GWU_DTPENT PREV_ENT,GWU_DTENT ENTREGA, " 

cQuery +=" CASE WHEN GW3_SITFIS ='1' THEN 'NAO ENVIADO' WHEN GW3_SITFIS = '2' THEN 'PENDENTE' WHEN GW3_SITFIS = '3' THEN 'REJEITADO' "
cQuery +=" WHEN GW3_SITFIS = '4' THEN 'INTEGRADO' WHEN GW1_SIT = '5' THEN 'PENDENTE DESAT.' END 'STATUS_FISCAL', "

cQuery +=" CASE WHEN GW1_SIT ='1' THEN 'DIGITADO' WHEN GW1_SIT = '2' THEN 'BLOQUEADO' WHEN GW1_SIT = '3' THEN 'LIBERADO' "
cQuery +=" WHEN GW1_SIT = '4' THEN 'EMBARCADO' WHEN GW1_SIT = '5' THEN 'ENTREGUE' WHEN GW1_SIT = '6' THEN 'RETORNADO' WHEN GW1_SIT = '7' THEN 'CANCELADO' END 'STATUS', "
cQuery +=" F2_VALBRUT VALOR_MERC,ISNULL(A1_NOME,'') DESTINATARIO,ISNULL(A3_NOME, '')	VENDEDOR,ISNULL(A1_EST,'') ESTADO,ISNULL(A1_MUN,'') MUNICIPIO, "   
cQuery +=" ISNULL(F2_TPFRETE,'') AS TP_FRT,                              "
cQuery +=" CASE WHEN GW1_CDDEST =  '021500036' THEN 'DEVOLUÇÃO'          "
cQuery +=" ELSE  'VENDAS' END AS TIPO , ISNULL(GW1_QTVOL,0) QTDVOL,      "
cQuery +=" ISNULL(SA4.A4_NOME,'') NOME_TRANSP,ISNULL(VLFRETECALC,0) VLFRETECALC, "
cQuery +=" F2_ZCUBA CUBAGEM_NOTA, "
cQuery +=" F2_PBRUTO PESO_DECLARADO, "
cQuery +=" ISNULL(GW4_NRDF,'') NUMEROCTE,ISNULL(GW4_SERDF,'') SERIECTE,"
cQuery +=" ISNULL(GW4_DTEMIS,'') EMISSCTE,ISNULL(GW3_VLDF,0) FRETE_PAGO,ISNULL(GW3_QTVOL,0) VOLCTE,ISNULL(GW3_PESOR,0) PESO_TRANSP,"
cQuery +=" ISNULL(GW3_VOLUM,0) PESOCUBADO,ISNULL(GW3_QTDCS,0) QTDNOTAS,  ISNULL(GW3_TAXAS,0) TAXAS,ISNULL(GW3_FRPESO,0) FRETEPESO,  "
cQuery +=" ISNULL(GW3_FRVAL,0) FRETEVLALOR,                                                                                         "
cQuery +=" ISNULL(GW3_PEDAG,0) VLRPEDAGIO,ISNULL(GW3_TRBIMP,'') TIPTRIBT,ISNULL(GW3_PCIMP,0) ALQICMS,ISNULL(GW3_VLIMP,0) VLRICMS,ISNULL(GW3_VLPIS,0) VLRPIS,ISNULL(GW3_VLCOF,0) VLCOFINS,ISNULL(GW3_SITFIS,'') SITFISCAL,"
cQuery +=" ISNULL(GW3_USUAPR,'') USUARIOAP, ISNULL(GW3_HRAPR,'')HAPRO,ISNULL(GW3_DTAPR,'') DTAPR,ISNULL(GW1_NRROM,'') NROMANEIO,ISNULL(GW4_EMISDF,'') CNPJCTE,ISNULL(TCT.A4_COD,'') as COD_TRAN_CTE,  ISNULL(TCT.A4_NOME,'') as NOME_TRAN_CTE, "                                                                                       
cQuery +=" ISNULL(GWN_DTSAI,'') DTSAIDA, "
cQuery +=" ISNULL(GW3_NRFAT,'') NMFATURA,ISNULL(GW3_DTEMFA,'') DTEMISFAT       "
cQuery +=" FROM GW1010 GW1                                       "                                                                          
cQuery +=" LEFT JOIN GWU010 GWU ON GWU_NRDC = GW1_NRDC AND GWU_FILIAL = GW1_FILIAL "
cQuery +=" AND GWU.GWU_SERDC = GW1_SERDC AND GWU_SEQ = '01' AND GWU_CDTPDC = GW1_CDTPDC AND GWU.D_E_L_E_T_ = ''       "
cQuery +=" LEFT JOIN GW4010 GW4 ON GW4_NRDC = GW1_NRDC AND GW4_FILIAL = GW1_FILIAL "
cQuery +=" AND GW4_SERDC = GW4_SERDC AND GW4.D_E_L_E_T_ = ''       "
cQuery +=" LEFT JOIN GW3010 GW3 ON GW3_NRDF = GW4.GW4_NRDF AND GW3_SERDF =  GW4.GW4_SERDF AND GW3.D_E_L_E_T_ = '' AND GW4.GW4_EMISDF = GW3_EMISDF  "                       
cQuery +=" LEFT JOIN GU3010 GU3 ON GU3_CDEMIT = GW1_CDDEST AND GU3.D_E_L_E_T_ = ''"
cQuery +=" LEFT JOIN SA1010 SA1 ON GU3_IDFED = A1_CGC AND SA1.D_E_L_E_T_ = ''    "                                                         
cQuery +=" LEFT JOIN SF2010 SF2 ON F2_FILIAL = GW1_FILIAL AND F2_SERIE = GW1_SERDC AND F2_DOC = GW1_NRDC AND SF2.D_E_L_E_T_ = ''  "         
cQuery +=" LEFT JOIN SA4010 SA4 ON  F2_TRANSP = A4_COD AND SA4.D_E_L_E_T_ = ''         "                                                    
cQuery +=" left join SA4010 TCT on TCT.A4_CGC = GW3.GW3_EMISDF and TCT.D_E_L_E_T_ = ''  "                                                   
cQuery +=" LEFT JOIN GWN010 GWN ON GWN_NRROM = GW1_NRROM AND GWN.D_E_L_E_T_ = ''    "
cQuery +=" LEFT JOIN SA3010 SA3 ON A3_COD = F2_VEND1 AND SA3.D_E_L_E_T_ = '' "                                                     
cQuery +=" LEFT JOIN (SELECT SUM(GWM_VLFRET) VLFRETECALC,GWM_NRDC NDOC FROM GWM010 WHERE GWM010.D_E_L_E_T_ = '' AND GWM_TPDOC = '1' GROUP BY GWM_NRDC) CALC ON CALC.NDOC = GW1_NRDC "
cQuery +=" WHERE GW1_DTEMIS BETWEEN '"+Dtos(cPar1)+"' AND '"+Dtos(cPar2)+"' AND GW1_NRDC BETWEEN '"+cPar3+"' AND '"+cPar4+"'   AND GW1_SERDC BETWEEN '"+cPar5+"' AND '"+cPar6+"' "
cQuery +=" AND GW1_FILIAL BETWEEN '"+ cPar7 +"' AND '"+ cPar8 +"' "
cQuery +=" AND GW1.D_E_L_E_T_ = ''                  "
/*if cPar9 == 2  
	cQuery +=" AND GW1_CDDEST =  '021500036'   "
elseif cPar9 == 1
   cQuery += " AND GW1_CDDEST <> '021500036' "
endif 
*/
cQuery +=" AND GW1.D_E_L_E_T_ = ''                  "

cQuery +=" ORDER BY GW1_FILIAL,GW1_NRDC,GW1_DTEMIS "


		
	//--Cria uma tabela temporária com as informações da query				
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.) 
	//--Cria estrutura de acordo com os dados da query*/  
	TcSetField( cAlias, "EMISSAO" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "DTEMISFAT" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "DTSAIDA" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "EMISSCTE" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "DTAPR" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "ENTREGA" , "D", TamSx3( "GWU_DTENT") [1], TamSx3("GWU_DTENT") [2] )
	TcSetField( cAlias, "PREV_ENT" , "D", TamSx3( "GWU_DTPENT") [1], TamSx3("GWU_DTPENT") [2] )


	aEstrut := dbstruct(cAlias)
	oReport:HideParamPage() //Não mostrar parametros
    oReport:HideHeader(.T.)	//Não mostrar cabeçalho
    oReport:HideFooter(.T.)	//Não mostrar rodapé 

	oSection1 := TRSection():New(oReport,OemToAnsi("Relatorio Frete"),{cAlias})
	
	For xI := 1 To Len(aEstrut)
		//--Cria coluna a partir da estrutura
		TRCell():New(oSection1,OemToAnsi(aEstrut[xI,1]),cAlias,aEstrut[xI,1],,aEstrut[xI,3],,,"LEFT",,"LEFT",,,,,,.T.)	
		oSection1:Cell(OemToAnsi(aEstrut[xI,1])):Enable()
	Next xI
    //--Bordas
	oSection1:SetCellBorder("ALL",2,,.T.)
	oSection1:SetCellBorder("ALL",2,,.F.)

Return(oReport) 
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FGerRel
Função utilizada para criar tabela temporaria a partir do resultado da query 

@author		Dental Sorria [.iNi Sistemas]
@since     	19/06/17
@version  	P.11              
@param 		oReport - Variavel contendo o objeto TREPORT
@param 		cAlias 	- Variável contendo a alias da query principal
@param 		cQuery 	- Query com as informações 
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FGerRel(oReport,cAlias, nHErp)
	
	Local nTotal := 0
	
	//--Vai para topo da tabela
	(cAlias)->(dbGoTop())
	//--Percorre toda a tabela e vai armazenando o numero de registros encontrados na variavel nTotal
	(cAlias)->(dbEval({|| nTotal++})) 
	If nTotal > 0
		(cAlias)->(dbGoTop())		
		Processa({|lEnd| FImpRel(oReport,cAlias, nTotal, nHErp)})
	Else
		ApMsgAlert(OemToAnsi("Não foram encontradas tabelas para os parametros selecionados! Favor verificar."),"Arquivo Vazio")
		tcSetConn(nHErp)
	EndIf
	
Return(Nil)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FImpRel
Função realiza impressão do relatório utilizando os metodos do TReport

@author		Deltal Sorria [.iNi Sistemas]
@since     	19/06/17
@version  	P.11              
@param 		oReport - Variavel contendo o objeto TREPORT
@param 		cAlias 	- Variável contendo a alias da query principal
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FImpRel(oReport,cAlias,nTotal, nHErp)
	
	Local oSec1:= oReport:Section(1)
	Local nCont:= 1

	oReport:PrintText(OemToAnsi("Relatorio frete"),,900)
	oReport:SkipLine()
	
	ProcRegua(nTotal)    
	(cAlias)->(dbGoTop())  
	//--Realiza impressão das informações
	Do While !(cAlias)->(EoF())
		If oReport:Cancel()
			Exit
		EndIf
		IncProc("Processando Registro: "+ AllTrim(str(nCont)) +' de: '+Alltrim(Str(nTotal)))
		oReport:StartPage()
		oReport:IncMeter()
		oSec1:Init()

		//Cubagem
		SF2->(dbSetOrder(1))
		SF2->(DbSeek((cAlias)->FILIAL+(cAlias)->NF+(cAlias)->SERIE)) 
		//if empty(SF2->F2_ZCUBA)
		if empty((cAlias)->CUBAGEM_NOTA)

			nCuba := 0
			SD2->( dbSetOrder(3) )
			SD2->( dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA) )
			While SD2->( !Eof() .And. xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA == SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) )
				SB1->(dbSetOrder(1))
				SB1->(msSeek(xFilial('SB1') + SD2->D2_COD))
				nCuba += Round(SD2->D2_QUANT * SB1->B1_XALTURA * SB1->B1_XLARG * SB1->B1_XCOMPR,5)   	
				//nCuba += Round(SD2->D2_QUANT * SB1->B1_XVOL,4)   	

				//--Grava dados do calculo da cubagem
				cSQL := " UPDATE "+RetSqlName("SD2")+" "
				cSql += " SET D2_XALTURA = "+alltrim(str(SB1->B1_XALTURA))
				cSql += ", D2_XLARG = "+alltrim(str(SB1->B1_XLARG))
				cSql += ", D2_XCOMPR = "+alltrim(str(SB1->B1_XCOMPR))
				cSql += ", D2_XVOL = "+alltrim(str(SB1->B1_XVOL))
				cSQL += " WHERE D2_FILIAL = '"+xFilial("SD2")+"'"
				cSQL += " AND D2_DOC = '"+SF2->F2_DOC+"'"
				cSQL += " AND D2_SERIE = '"+SF2->F2_SERIE+"'"
				cSQL += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"'"
				cSQL += " AND D2_LOJA = '"+SF2->F2_LOJA+"'"
				cSQL += " AND D2_ITEM = '"+SD2->D2_ITEM+"'"
				TCSqlExec(cSql)

				SD2->( dbSkip() )
			EndDo
			//recLock('SF2',.F.)
			//SF2->F2_ZCUBA := nCuba
			//SF2->(msUnlock())

			//--Apaga o numero do pedido na condição negociada	
			cSQL := " UPDATE "+RetSqlName("SF2")+" "
			cSql += " SET F2_ZCUBA = "+alltrim(str(nCuba))
			cSQL += " WHERE F2_FILIAL = '"+(cAlias)->FILIAL+"'"
			cSQL += " AND F2_DOC = '"+(cAlias)->NF+"'"
			cSQL += " AND F2_SERIE = '"+(cAlias)->SERIE+"'"
			TCSqlExec(cSql)

			oSec1:Cell("CUBAGEM_NOTA"):SetBlock({|| nCuba })

		endif


		oSec1:PrintLine(,,.T.)


		(cAlias)->(dbSkip())
		nCont++
	EndDo
	//--Finaliza Seção
	oSec1:Finish()
	tcSetConn(nHErp)
	
Return(Nil)
