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
!Nome              ! BFATR013                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de Vendas por Estado                          !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 01/02/2013                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"     

User Function BFATR013()

Local cPerg   := PADR("BFATR013",10)
Local oReport := BFATR13A(cPerg)

U_BCFGA002("BFATR013")//Grava detalhes da rotina usada

BFATR13B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function BFATR13A(cPerg)

Local oReport
Local oSection1

oReport:= TReport():New("BFATR013","Vendas por Estado",cPerg,{|oReport| BFATR13C(oReport)},"Impressão do Relatório de Vendas por Estado")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8
     
oSection1 := TRSection():New(oReport,"Vendas por Estado",{"SA1", "SF2", "SD2"})  //Tabelas usadas na query

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

//TRCell():New(oSection1,cName         ,cAlias, cTitle        ,cPicture         ,nSize ,lPixel,bBlock,cAlign  ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
  TRCell():New(oSection1,"EMISSAO"     ,"SF2" , "Emissão"     ,                 ,  10  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"NOTAFISCAL"  ,"SF2" , "NotaFiscal"  ,                 ,  11  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"CODIGO"      ,"SA1" , "Código"      ,                 ,  9   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )  
  TRCell():New(oSection1,"LOJA"        ,"SA1" , "Loja"        ,                 ,  4   ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     ) 
  TRCell():New(oSection1,"CLIENTE"     ,"SA1" , "Cliente"     ,                 ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"EST"         ,"SF2" , "UF"          ,                 ,  2   ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"VEND"        ,"SF2" , "Vendedor"    ,                 ,  9   ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"VALOR"       ,"SF2" , "Valor"       ,"@E 9,999,999.99",  12  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
     
                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("NOTAFISCAL"):SetBorder("BOTTOM",1,CLR_BLACK,.T.) 
 oSection1:Cell("CODIGO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("CLIENTE"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("LOJA"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("VEND"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("UF"        ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("VALOR"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  

                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("NOTAFISCAL"):SetBorder("BOTTOM",1,CLR_BLACK,.F.) 
 oSection1:Cell("CODIGO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("CLIENTE"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("LOJA"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("VEND"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("UF"        ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("VALOR"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
    
//TRFunction():New(         oCell         ,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)  
  TRFunction():New(oSection1:Cell("VALOR"), NIL ,  "SUM"  ,  NIL ,  NIL ,    NIL ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )  
//TRFunction():New(oSection1:Cell("VALOR"),     , "COUNT" ,      ,      ,        ,        ,   .T.     ,     .F.  ,   .F.  , oSection1,          ,        ,         ) 
Return oReport


Static Function BFATR13C(oReport)

Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery() 

BeginSql alias cAlias
	SELECT F2_EMISSAO AS EMISSAO, F2_DOC AS NOTAFISCAL,
	F2_CLIENTE AS CODIGO, A1_NOME AS CLIENTE, A1_LOJA AS LOJA,
	F2_VEND1 AS VEND, F2_EST AS EST, F2_VALBRUT AS VALOR
	FROM %table:SF2% F2, %table:SD2% D2, %table:SA1% A1
	WHERE F2.%notDel%
	AND D2.%notDel%
	AND F2_FILIAL = D2_FILIAL
	AND F2_DOC = D2_DOC
	AND F2_CLIENTE = A1_COD
	AND F2_LOJA = A1_LOJA
	AND F2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND F2_CLIENTE BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND F2_VEND1 BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
	AND F2_EST BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
	GROUP BY F2_DOC,F2_EMISSAO, F2_CLIENTE, F2_VEND1, F2_EST, F2_VALBRUT,A1_NOME,A1_LOJA
	ORDER BY F2_EMISSAO, F2_DOC,F2_VEND1
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos     

oSection1:EndQuery()
oSection1:Print()     

Return

Static Function BFATR13B(cPerg)
  //PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSX1(cPerg , "01" , "Emissao de"      , ""    , ""    , "mv_ch1" , "D" , TAMSX3("F2_EMISSAO")[1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par01", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "02" , "Emissao ate"     , ""    , ""    , "mv_ch2" , "D" , TAMSX3("F2_EMISSAO")[1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par02", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "03" , "Cliente de"      , ""    , ""    , "mv_ch3" , "C" , TAMSX3("A1_COD")[1]     , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par03", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "04" , "Cliente ate"     , ""    , ""    , "mv_ch4" , "C" , TAMSX3("A1_COD")[1]     , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par04", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
    PutSX1(cPerg , "05" , "Vendedor de"     , ""    , ""    , "mv_ch5" , "C" , TAMSX3("A3_COD")[1]     , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par05", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "06" , "Vendedor ate"    , ""    , ""    , "mv_ch6" , "C" , TAMSX3("A3_COD")[1]     , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par06", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
    PutSX1(cPerg , "07" , "UF de"           , ""    , ""    , "mv_ch7" , "C" , TAMSX3("F2_EST")[1]     , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par07", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "08" , "UF ate"          , ""    , ""    , "mv_ch8" , "C" , TAMSX3("F2_EST")[1]     , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par08", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
Return
