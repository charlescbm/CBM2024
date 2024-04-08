/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Modulo            ! MT - Call Center                                       !
+------------------+---------------------------------------------------------+
!Nome              ! BMTKR001                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! E-mail com a relação das comissões pagas ao vendedor    !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMÕES DA MAIA		                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 26/01/2012                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"
#define DMPAPER_A4 9

User Function BMTKR001()
	local oReport
	local cPerg := PadR('BMTKR001',10) 
	Private cAlias := GetNextAlias()  
	
	PergAtend(cPerg)//executa a função que cria as perguntas 

	If Pergunte(cPerg,.T.)
		oReport := reportDef()
		oReport:printDialog()
	EndIf 
 
Return
  
//Montagem do Layout do Relatório 
Static function reportDef()
	local oReport
	Local oSection1
	local cTitulo := 'Relação de Atendimentos'
 
	oReport := TReport():New('BMTKR001', cTitulo, , {|oReport| PrintReport(oReport)},"Este relatorio ira imprimir a relacao de atendimentos.")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()
 
	oSection1 := TRSection():New(oReport,"Filial",{"cAlias"})
	oSection1:SetTotalInLine(.F.)
	
 	TRCell():New(oSection1, "UC_CODIGO"	, "cAlias", 'Atendimento',PesqPict('SUC',"UC_CODIGO") ,TamSX3("UC_CODIGO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "UC_DATA"	, "cAlias", 'Data Atend' ,PesqPict('SUC',"UC_DATA")   ,TamSX3("UC_DATA")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "UD_ASSUNTO", "cAlias", 'Assunto'    ,PesqPict('SUD',"UD_ASSUNTO"),TamSX3("UD_ASSUNTO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "X5_DESCRI"	, "cAlias", 'Descricao'  ,PesqPict('SX5',"X5_DESCRI") ,TamSX3("X5_DESCRI")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "UD_OCORREN", "cAlias", 'Ocorrencia' ,PesqPict('SUD',"UD_OCORREN"),TamSX3("UD_OCORREN")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "U9_DESC"	, "cAlias", 'Descricao'  ,PesqPict('SU9',"U9_DESC")   ,TamSX3("U9_DESC")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "UD_SOLUCAO", "cAlias", 'Acao'       ,PesqPict('SUD',"UD_SOLUCAO"),TamSX3("UD_SOLUCAO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "UD_OPERADO", "cAlias", 'Operado'  	 ,PesqPict('SUD',"UD_OPERADO") ,TamSX3("UD_OPERADO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "NOME"   	, "cAlias", 'Nome'  	 ,/*PesqPict('SB1',"B1_TIPO") ,TamSX3("B1_TIPO")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "STATUS"	, "cAlias", 'Status'	 ,/*PesqPict('SUD',"UD_STATUS") ,TamSX3("UD_STATUS")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():new(oSection1, "UD_DATA"   , "cAlias", 'Data'	     ,PesqPict('SUD',"UD_DATA")   ,TamSX3("UD_DATA")[1]+1,/*lPixel*/,/*{|| code-block de impressao }*/)
 
	//oBreak := TRBreak():New(oSection1,oSection1:Cell("UC_CODIGO"),,.F.)
 
return (oReport)
 

//Geração do relatório
Static Function PrintReport(oReport)
	Local oSection1 := oReport:Section(1)
 
	Private cUsuario:= "" //Variável para armazenar o operador conforme retorno da Query do campo UD_OPERADO

	oSection1:BeginQuery() 
	
	//Verifica qual o Status selecionado no parametro e faz o filtro para a query
	If (MV_PAR05 == 3)//Ambos  
		cFilStatus = "1','2"
	Else
		If (MV_PAR05 == 2)//Atendimento Encerrado 
			cFilStatus = "2','2" 
		Else
			cFilStatus = "1','1" //Atendimento Pendente
		EndIf
	EndIf
	
	//Geração da query 
	BeginSql alias "cAlias"
		SELECT UC_CODIGO, UC_DATA, UD_ASSUNTO, X5_DESCRI,  UD_OCORREN, U9_DESC,
	           UD_SOLUCAO, UD_OPERADO, UD_STATUS, UD_DATA 
		FROM %table:SUC% UC, %table:SUD% UD, %table:SX5% X5, %table:SU9% U9    
		WHERE 
			UD.%notDel% AND
			UC.%notDel% AND 
			U9.%notDel% AND
			UC_CODIGO = UD_CODIGO AND 
			UC_FILIAL = UD_FILIAL AND
			UD_FILIAL = X5_FILIAL AND
	   		X5_TABELA = 'T1' AND
			UD_ASSUNTO = X5_CHAVE AND
			UD_OCORREN = U9_CODIGO AND
			UC_DATA BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% AND
   			UD_OPERADO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04% AND
			UD_STATUS IN (%exp:cFilStatus%)
   		ORDER BY UC_DATA, UC_CODIGO, UD_OPERADO
	EndSql                                                                                                        
                                      
	aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos    

	oSection1:EndQuery()
	
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)
 
	DbSelectArea('cAlias')
	dbGoTop()
	oReport:SetMeter(cAlias->(RecCount()))

	
	While cAlias->(!Eof())
		
		//Variável para armazenar o operador conforme retorno da Query do campo UD_OPERADO
		cUsuario:= UsrFullName(cAlias->UD_OPERADO) 
		
		If oReport:Cancel()
			Exit
		EndIf

		oReport:IncMeter()

		//seta os conteúdos nos campos
		oSection1:Cell("UC_CODIGO"):SetValue(cAlias->UC_CODIGO)
		oSection1:Cell("UC_CODIGO"):SetAlign("CENTER")
 
		oSection1:Cell("UC_DATA"):SetValue(cAlias->UC_DATA)
		oSection1:Cell("UC_DATA"):SetAlign("CENTER")
 
		oSection1:Cell("UD_ASSUNTO"):SetValue(cAlias->UD_ASSUNTO)
		oSection1:Cell("UD_ASSUNTO"):SetAlign("CENTER")
 
		oSection1:Cell("X5_DESCRI"):SetValue(cAlias->X5_DESCRI)
		oSection1:Cell("X5_DESCRI"):SetAlign("LEFT")
 
		oSection1:Cell("UD_OCORREN"):SetValue(cAlias->UD_OCORREN)
		oSection1:Cell("UD_OCORREN"):SetAlign("LEFT")
 
		oSection1:Cell("U9_DESC"):SetValue(cAlias->U9_DESC)
		oSection1:Cell("U9_DESC"):SetAlign("LEFT")
 
		oSection1:Cell("UD_SOLUCAO"):SetValue(cAlias->UD_SOLUCAO)
		oSection1:Cell("UD_SOLUCAO"):SetAlign("LEFT")
 
		oSection1:Cell("UD_OPERADO"):SetValue(cAlias->UD_OPERADO)
		oSection1:Cell("UD_OPERADO"):SetAlign("LEFT")
 
		oSection1:Cell("NOME"):SetValue(cUsuario)//seta o conteudo para o campo NOME buscando o valor da variavel
		oSection1:Cell("NOME"):SetAlign("LEFT")
		oSection1:Cell("NOME"):SetSize(40)   
		
	    //Seta o conteúdo da variável cStatus conforme resultado da query no campo UD_STATUS
		If (cAlias->UD_STATUS == "1")
			cStatus:= "Pendente"
		Else
			cStatus:= "Encerrado"
		EndIf

		oSection1:Cell("STATUS"):SetValue(cStatus)
		oSection1:Cell("STATUS"):SetAlign("LEFT") 
		oSection1:Cell("STATUS"):SetSize(10) 
		
		oSection1:Cell("UD_DATA"):SetValue(cAlias->UD_DATA)
		oSection1:Cell("UD_DATA"):SetAlign("LEFT")
 
		oSection1:PrintLine()
 
		dbSelectArea("cAlias")
		cAlias->(dbSkip())
	EndDo
	oSection1:Finish()
Return 

//Função responsavel em criar os parametros no SX1010
Static Function PergAtend(cPerg)
	//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng  	,cVar    ,cTipo,nTam,nDec,nPres,cGSC,cValid		,cF3	, cGrpSxg,cPyme	,cVar01		,  cDef01   ,cDefSpa1,cDefEng1,cCnt01, cDef02    ,cDefSpa2,cDefEng2,cDef03 ,cDefSpa3,cDefEng3 , cDef04		,cDefSpa4,cDefEng4, cDef05		,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSX1(cPerg, "01", "Data de"      , "", "", "mv_ch1", "D", TAMSX3("UC_DATA")[1] , 0, 0, "G", "",      , "", ""             , "mv_par01", "        ","      ","      ","    ","         ","      ","      ","     ",""     ,"","","","","","","")
	PutSX1(cPerg, "02", "Data ate"     , "", "", "mv_ch2", "D", TAMSX3("UC_DATA")[1] , 0, 0, "G", "",      , "", ""             , "mv_par02", "        ","      ","      ","    ","         ","      ","      ","     ",""     ,"","","","","","","")
    //PutSX1(cPerg, "03", "Operador"     , "", "", "mv_ch3", "C", 99                   , 0, 0, "G", "","US2" , "", ""             , "mv_par03", "        ","      ","      ","    ","         ","      ","      ","     ",""     ,"","","","","","","")
    PutSX1(cPerg, "03", "Operador de"  , "", "", "mv_ch3", "C", 6                    , 0, 0, "G", "","US2" , "", "", "mv_par03", "        ","","","","         ","","","",""     ,"","","","","","","")
	PutSX1(cPerg, "04", "Operador ate" , "", "", "mv_ch4", "C", 6                    , 0, 0, "G", "","US2" , "", "", "mv_par04", "        ","","","","         ","","","",""     ,"","","","","","","")
	PutSX1(cPerg, "05", "Status?"      , "", "", "mv_ch5", "C", 1                    , 0, 0, "C", "",      , "", ""             , "mv_par05", "Pendente","      ","      ","    ","Encerrado","      ","      ","Ambos","","","","","","","","")
Return  


