/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! GPE - Gestão de Pessoal                                 !
+------------------+---------------------------------------------------------+
!Nome              ! BFATR016                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de CBO de Funcionários                      !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 24/04/2013                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"     

User Function BFATR016()

Local cPerg   := PADR("BFATR016",10)
Local oReport := BFATR16A(cPerg)

U_BCFGA002("BFATR016")//Grava detalhes da rotina usada

BFATR16B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function BFATR16A(cPerg)

Local oReport
Local oSection1

oReport:= TReport():New("BFATR016","Relatório de CBO de Funcionários",cPerg,{|oReport| BFATR16C(oReport)},"Impressão de Relatório de CBO de Funcionários")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8
     
oSection1 := TRSection():New(oReport,"Relatório de CBO de Funcionários",{"SRA", "SRJ"})  //Tabelas usadas na query

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
  TRCell():New(oSection1,"FILIAL"      ,"SRA" , "Filial"      ,                 ,  02  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"MATRICULA"   ,"SRA" , "Matricula"   ,                 ,  08  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"NOME"        ,"SRA" , "Nome"        ,                 ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )  
  TRCell():New(oSection1,"CC"          ,"SRA" , "C.Custo"     ,                 ,  08  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"FUNCAO"      ,"SA1" , "Função"      ,                 ,  08  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     ) 
  TRCell():New(oSection1,"DESCFUNC"    ,"SRJ" , "Desc. Func"  ,                 ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"CBO"         ,"SRJ" , "C.B.O"       ,                 ,  08  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
     
                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("FILIAL"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("MATRICULA"):SetBorder("BOTTOM",1,CLR_BLACK,.T.) 
 oSection1:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("CC"       ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("FUNCAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("DESCFUNC" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("CBO"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)


                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("FILIAL"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("MATRICULA"):SetBorder("BOTTOM",1,CLR_BLACK,.F.) 
 oSection1:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("CC"       ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("FUNCAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("DESCFUNC" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("CBO"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
    
//TRFunction():New(         oCell         ,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)  
//TRFunction():New(oSection1:Cell("VALOR"), NIL ,  "SUM"  ,  NIL ,  NIL ,    NIL ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )  
//TRFunction():New(oSection1:Cell("VALOR"),     , "COUNT" ,      ,      ,        ,        ,   .T.     ,     .F.  ,   .F.  , oSection1,          ,        ,         ) 
Return oReport


Static Function BFATR16C(oReport)

Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery() 
   
BeginSql alias cAlias
	SELECT RA_FILIAL AS FILIAL, RA_MAT AS MATRICULA, RA_NOME AS NOME, 
	RA_CC AS CC, RA_CODFUNC AS FUNCAO, RJ_DESC AS DESCFUNC, RJ_CODCBO AS CBO 
	FROM %table:SRA% RA, %table:SRJ% RJ
	WHERE RA.%notDel%
	AND RJ.%notDel% 
	AND RA_FILIAL = %xfilial:SRA%
	AND RA_FILIAL = RJ_FILIAL 
	AND RA_CODFUNC = RJ_FUNCAO
	AND RA_SITFOLH <> 'D'  
	AND RA_MAT BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	ORDER BY RA_NOME
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos     

oSection1:EndQuery()
oSection1:Print()     

Return

Static Function BFATR16B(cPerg)
  //PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSX1(cPerg , "01" , "Matricula de"     , ""    , ""    , "mv_ch1" , "C" , TAMSX3("RA_MAT")[1]     , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par01", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "02" , "Matricula ate"    , ""    , ""    , "mv_ch2" , "C" , TAMSX3("RA_MAT")[1]     , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par02", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
    Return
