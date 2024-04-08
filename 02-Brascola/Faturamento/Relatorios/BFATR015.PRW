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
!Nome              ! BFATR015                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de Carteira de Clientes                       !
+------------------+---------------------------------------------------------+
!Autor             ! MARLON AUGUSTO HEIBER  - TESTE                          !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 21/02/2013                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"     

User Function BFATR015()

Local cPerg   := PADR("BFATR015",10)
Local oReport := BFATR15A(cPerg)

U_BCFGA002("BFATR015")//Grava detalhes da rotina usada

BFATR15B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function BFATR15A(cPerg)

Local oReport
Local oSection1

oReport:= TReport():New("BFATR015","Relatório de Carteira de Clientes",cPerg,{|oReport| BFATR15C(oReport)},"Impressão do Relatório de Carteira de Clientes")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8
     
oSection1 := TRSection():New(oReport,"Relatório de Carteira de Clientes",{"SA1", "SA3"})  //Tabelas usadas na query

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
  TRCell():New(oSection1,"COD_CLI"     ,"SA1" , "COD_CLIENTE" ,                 ,  14  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )  
  TRCell():New(oSection1,"CLIENTE"     ,"SA1" , "CLIENTE"     ,                 ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"CNPJ"        ,"SA1" , "CNPJ"        ,                 ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"COD_VENDE"   ,"SA1" , "COD_VENDEDOR",                 ,  16  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"VENDEDOR"    ,"SA3" , "VENDEDOR"    ,                 ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )   
                      
                      
                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("COD_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("CLIENTE"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.) 
 oSection1:Cell("CNPJ"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("COD_VENDE" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("VENDEDOR"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 

                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("COD_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("CLIENTE"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.) 
 oSection1:Cell("CNPJ"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("COD_VENDE" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("VENDEDOR"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.) 
 
    
//TRFunction():New(         oCell         ,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)  
//TRFunction():New(oSection1:Cell("VALOR"), NIL ,  "SUM"  ,  NIL ,  NIL ,    NIL ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )  
//TRFunction():New(oSection1:Cell("VALOR"),     , "COUNT" ,      ,      ,        ,        ,   .T.     ,     .F.  ,   .F.  , oSection1,          ,        ,         ) 
Return oReport


Static Function BFATR15C(oReport)

Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT A1_COD AS COD_CLI,A1_NOME AS CLIENTE,A1_CGC AS CNPJ,A1_VEND AS COD_VENDE,A3_NOME AS VENDEDOR
	FROM %table:SA1% A1, %table:SA3% A3
	WHERE A1.%notDel%
	AND A1_VEND = A3_COD
	AND A1_COD BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND A1_VEND BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	ORDER BY A1_COD	
EndSql


aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos     

oSection1:EndQuery()
oSection1:Print()     

Return

Static Function BFATR15B(cPerg)
  //PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
  	PutSX1(cPerg , "01" , "Cliente de"      , ""    , ""    , "mv_ch1" , "C" , TAMSX3("A1_COD")[1]     , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par01", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "02" , "Cliente ate"     , ""    , ""    , "mv_ch2" , "C" , TAMSX3("A1_COD")[1]     , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par02", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
    PutSX1(cPerg , "03" , "Vendedor de"     , ""    , ""    , "mv_ch3" , "C" , TAMSX3("A3_COD")[1]     , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par03", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "04" , "Vendedor ate"    , ""    , ""    , "mv_ch4" , "C" , TAMSX3("A3_COD")[1]     , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par04", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
 
Return
