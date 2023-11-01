#INCLUDE "TOTVS.CH"
STATIC __cPrgNom
//--------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function IEXPR020()
	
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
	Local nHErp 	:= AdvConnection()
    //Local cAliasSE1 := RetSqlName("SE1")
    //Local cAliasSql := RetSqlName("SF2")
	//Local cAliasSA1 := RetSqlName("SA1")
	Local cPar1		:= MV_PAR01
	Local cPar2		:= MV_PAR02
	Local cPar3		:= MV_PAR03
	Local cPar4		:= MV_PAR04
	Local cPar5		:= MV_PAR05
	Local cPar6		:= MV_PAR06
	Local cPar7		:= MV_PAR07
	Local cPar8		:= MV_PAR08
	Local xI
	
	U_ITECX010("IEXPR020","Relatorio de Notas")//Grava detalhes da rotina usada
	   
	oReport	:= TReport():New(cNomPro,OemToAnsi("Relatorio de Notas "),,{|oReport| FGerRel(oReport,cAlias, nHErp)},OemToAnsi("Relatorio de Notas"),.T.)
	oReport:nFontBody := 10
	oReport:SetDevice(6)
	oReport:nLeftMargin:= 0 
	
	oReport:HideParamPage() //Não mostrar parametros
    oReport:HideHeader(.T.)	//Não mostrar cabeçalho
    oReport:HideFooter(.T.)	//Não mostrar rodapé

	cQuery :="SELECT F2_EMISSAO EMISSAO, F2_DOC NF, F2_SERIE SERIE, F2_CLIENTE, F2_LOJA LOJA, F3_DTCANC DTCANC, F3_CODRSEF RET_SEFAZ, F3_DESCRET DESC_SEFAZ 
	cQuery += "FROM "+RetSqlName("SF2")+" F2, "+RetSqlName("SF3")+" F3   "
	cQuery +=" WHERE F2.D_E_L_E_T_ = '*'   "
	cQuery +=" AND F3.D_E_L_E_T_ <> '*'   "
	cQuery +=" AND F2_EMISSAO BETWEEN '"+Dtos(cPar1)+"' AND '"+Dtos(cPar2)+"'   "
	cQuery +=" AND F2_DOC  BETWEEN '"+ cPar3 +"' AND '"+ cPar4 +"'   "
	cQuery +=" AND F2_FILIAL BETWEEN '"+ cPar7 +"' AND '"+ cPar8 +"'   "
	cQuery +=" AND F2_SERIE BETWEEN '"+ cPar5 +"' AND '"+ cPar6 +"' "   "
	cQuery +=" AND F2_FILIAL = F3_FILIAL   "
	cQuery +=" AND F2_DOC = F3_NFISCAL   "
	cQuery +=" AND F2_SERIE = F3_SERIE   "
	cQuery +=" AND F2_CLIENTE = F3_CLIEFOR   "
	cQuery +="ORDER BY 1"
	
	//--Cria uma tabela temporária com as informações da query				
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.) 
	//--Cria estrutura de acordo com os dados da query*/  
	TcSetField( cAlias, "EMISSAO" , "D", TamSx3( "F2_EMISSAO") [1], TamSx3("F2_EMISSAO") [2] )
	TcSetField( cAlias, "DTCANC" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "DTSAIDA" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "EMISSCTE" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )
	TcSetField( cAlias, "DTAPR" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )

	aEstrut := (cAlias)->(dbstruct())
	oReport:HideParamPage() //Não mostrar parametros
    oReport:HideHeader(.T.)	//Não mostrar cabeçalho
    oReport:HideFooter(.T.)	//Não mostrar rodapé 

	oSection1 := TRSection():New(oReport,OemToAnsi("Relatorio de Notas"),{cAlias})
	
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

	oReport:PrintText(OemToAnsi("Relatorio de Notas"),,900)
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
		oSec1:PrintLine(,,.T.)
		(cAlias)->(dbSkip())
		nCont++
	EndDo
	//--Finaliza Seção
	oSec1:Finish()
	tcSetConn(nHErp)
	
Return(Nil)
