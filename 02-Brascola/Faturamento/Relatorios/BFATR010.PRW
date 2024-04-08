/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! BFATR009                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório Cliente por Região                            !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 22/11/2012                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function BFATR009()

Local cPerg   := PADR("BFATR009",10)
Local oReport := BFATR9A(cPerg)
Static cBlq:= ""


BFATR9B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return



Static Function BFATR9A(cPerg)

Local oReport
Local oSection1




oReport:= TReport():New("BFATR009","Clientes por Região",cPerg,{|oReport| BFATR9C(oReport)},"Impressão do Relatório Clientes por Região")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 10
     


oSection1 := TRSection():New(oReport,"Clientes por Região: ",{"SA1"})


/*  
TRCell():New(oSection1,cName,cAlias,cTitle,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
cName		    Nome da célula
cAlias		    Tabela utilizada pela célula
cTitle	    	Título da célula
cPicture    	Máscara da célula
nSize	    	Tamanho da célula
lPixel	    	Aponta se o tamanho foi informado em pixel
bBlock	    	Bloco de código com o retorno do campo
cAlign	    	Alinhamento da célula. "LEFT", "RIGHT" e "CENTER"
lLineBreak	    Quebra linha se o conteúdo estourar o tamanho do campo
cHeaderAlign	Alinhamento do cabeçalho da célula. "LEFT", "RIGHT" e "CENTER"
lCellBreak   	Compatibilidade - Não utilizado
nColSpace    	Espaçamento entre as células
lAutoSize   	Ajusta o tamanho da célula com base no tamanho da página e as Informações impressas
nClrBack    	Cor de fundo da célula
nClrFore    	Cor da fonte da célula
lBold	    	Imprime a fonte em negrito 
 */

//TRCell():New(oSection1,cName      ,cAlias, cTitle        ,cPicture,nSize,lPixel,bBlock,cAlign,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
  TRCell():New(oSection1,"A1_COD"   ,"SA1" , "Codigo"      ,        ,     ,.F.   ,      ,"LEFT",  .F.     , "LEFT"     ,          ,   5     ,    .T.  ,        ,        ,     )
  TRCell():New(oSection1,"A1_LOJA"  ,"SA1" , "Loja"        ,        ,  5  ,.F.   ,      ,"LEFT",  .F.     , "LEFT"     ,          ,   5     ,    .T.  ,        ,        ,     )
  TRCell():New(oSection1,"A1_NOME"  ,"SA1" , "Razão Social",        ,     ,.F.   ,      ,"LEFT",  .F.     , "LEFT"     ,          ,   5     ,    .T.  ,        ,        ,     )  
  TRCell():New(oSection1,"A1_CGC"   ,"SA1" , "CNPJ"        ,        ,  20 ,.F.   ,      ,"LEFT",  .F.     , "LEFT"     ,          ,   5     ,    .T.  ,        ,        ,     ) 
  TRCell():New(oSection1,"A1_REGIAO","SA1" , "Região"      ,        ,  7  ,.F.   ,      ,"LEFT",  .F.     , "LEFT"     ,          ,   5     ,    .T.  ,        ,        ,     )
  


/*
SetBorder(uBorder,nWeight,nColor,lHeader)   - Define as bordas da célula.
uBorder	Tipo Caracter: "TOP"     ,"BOTTOM"  ,"LEFT"    ,"RIGHT"  ,"ALL"
        Tipo Numérico: 1-Superior,2-Inferior,3-Esquerda,4-Direita,5-Todas
nWeight	Largura da borda
nColor	Cor da borda
lHeader	Aponta se é borda de cabeçalho
*/

                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
oSection1:Cell("A1_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("A1_LOJA"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("A1_NOME"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
oSection1:Cell("A1_CGC"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("A1_REGIAO"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)     


                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
oSection1:Cell("A1_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("A1_LOJA"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("A1_NOME"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
oSection1:Cell("A1_CGC"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("A1_REGIAO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

Return oReport



Static Function BFATR9C(oReport)

Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT	A1_COD, A1_LOJA, A1_NOME, A1_REGIAO, A1_CGC,
	CASE WHEN (A1_MSBLQL = 1) THEN
		'SIM'
 	ELSE
		'NAO'
 	END AS A1_MSBLQL
	FROM %table:SA1% SA1
	WHERE SA1.A1_FILIAL = %xfilial:SA1%
	AND SA1.%notDel%
	AND SA1.A1_COD BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND SA1.A1_REGIAO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND SA1.A1_MSBLQL = %exp:MV_PAR05%
	ORDER BY 3 ASC
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos     


oSection1:EndQuery()
oSection1:Print()     

Return

Static Function BFATR9B(cPerg)
  //PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng  	,cVar    ,cTipo,nTam,nDec,nPres,cGSC,cValid		,cF3	, cGrpSxg,cPyme	,cVar01		,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03		,cDefSpa3,cDefEng3 , cDef04		,cDefSpa4,cDefEng4, cDef05		,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSX1(cPerg, "01", "Cliente de"         , "", "", "mv_ch1", "C", TAMSX3("A1_COD")[1]     , 0, 0, "G", "","SA1", "", "", "mv_par01", ""   ,"","","",""   ,"","","","","","","","","","","")
	PutSX1(cPerg, "02", "Cliente ate"        , "", "", "mv_ch2", "C", TAMSX3("A1_COD")[1]     , 0, 0, "G", "","SA1", "", "", "mv_par02", ""   ,"","","",""   ,"","","","","","","","","","","")
	PutSX1(cPerg, "03", "Região de"          , "", "", "mv_ch3", "C", TAMSX3("ACA_GRPREP")[1] , 0, 0, "G", "","ACA", "", "", "mv_par03", ""   ,"","","",""   ,"","","","","","","","","","","")
	PutSX1(cPerg, "04", "Região ate"         , "", "", "mv_ch4", "C", TAMSX3("ACA_GRPREP")[1] , 0, 0, "G", "","ACA", "", "", "mv_par04", ""   ,"","","",""   ,"","","","","","","","","","","")
	PutSX1(cPerg, "05", "Bloqueado?"         , "", "", "mv_ch5", "C", 1                       , 0, 0, "G", "",     , "", "", "mv_par05", "Sim","","","","Não","","","","","","","","","","","")
Return
