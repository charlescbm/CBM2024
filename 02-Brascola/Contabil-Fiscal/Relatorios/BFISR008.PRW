#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Relatório                                               !
+------------------+---------------------------------------------------------+
!Modulo            ! FIS - Relatório de Royalties  - Devoluções              !
+------------------+---------------------------------------------------------+
!Nome              ! BFISR008                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório Funcionários                                  !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 03/04/2014                                              !
+------------------+---------------------------------------------------------+
*/
User Function BFISR008()

Private oReport
Private cPerg   := PADR("BFISR008",10)

//Private aOrd:= {"Matricula" , "Nome" }
Private cAlias := GetNextAlias()

//Private cOrdem := ""

oReport := ReportDef(cPerg)


U_BCFGA002("BFISR008")

BFISR08B(cPerg)


If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return


//Funcao que ira fazer a montagem do Layout/Estrutura do Relatorio
Static Function ReportDef(cPerg)
Local oSection1
Local cTitulo := "Relatorio de Royalties  - Devoluções"
Local aTabelas:= {"SD1", "SB1", "SA1", "SF4"}


oReport:= TReport():New("BFISR008",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)

oReport:SetLandscape()

oReport:SetTotalInLine(.F.)

oReport:nFontBody := 8
oReport:ShowHeader()

oSection1 := TRSection():New(   oReport   ,   cTitulo  ,  aTabelas  ,     /*aOrd*/  ,       .F.      ,        .F.     )
oSection1:SetTotalInLine(.F.)

TRCell():New(oSection1,"FILIAL"       ,"SD1" , "FILIAL"    ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DOCUMENTO"    ,"SD1" , "DOCUMENTO" ,                ,  20  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"SERIE"        ,"SD1" , "SERIE"     ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NF_ORI"       ,"SF4" , "NF_ORI"    ,                ,  30  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"SERIE_ORI"    ,"SD1" , "SERIE_ORI" ,                ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DATADG"       ,"SD1" , "DATADG"    ,                ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"F4_CF"        ,"SB1" , "F4_CF"     ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VALDESC"   ,"SD1" , "D1_VALDESC",                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_PICM"      ,"SD1" , "D1_PICM"   ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_PROD"     ,"SD1" , "COD_PROD"  ,                ,  40  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DESC_PROD"    ,"SD1" , "DESC_PROD" ,                ,  40  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"GRUPO_PROD"   ,"SD1" , "GRUPO_PROD",                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_QUANT"     ,"SD1" , "D1_QUANT"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VUNIT"     ,"SD1" , "D1_VUNIT"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_TOTAL"     ,"SD1" , "D1_TOTAL"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI","SD1" , "TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI" ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VALICM"    ,"SD1" , "D1_VALICM" ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VALIMP5"   ,"SD1" , "D1_VALIMP5",                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VALIMP6"   ,"SD1" , "D1_VALIMP6",                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_ICMSRET"   ,"SA1" , "D1_ICMSRET",                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VALIPI"    ,"SA1" , "D1_VALIPI" ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D1_VALFRE"    ,"SA1" , "D1_VALFRE" ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"IMPOSTOS"     ,"   " , "IMPOSTOS"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )

oSection1:Cell("FILIAL"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DOCUMENTO" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SERIE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NF_ORI"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SERIE_ORI" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DATADG"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("F4_CF"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VALDESC"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_PICM"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DESC_PROD" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("GRUPO_PROD"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_QUANT"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VUNIT"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_TOTAL"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VALICM" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VALIMP5"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VALIMP6"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_ICMSRET"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VALIPI" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D1_VALFRE" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("IMPOSTOS"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

oSection1:Cell("FILIAL"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DOCUMENTO" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SERIE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NF_ORI"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SERIE_ORI" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DATADG"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("F4_CF"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VALDESC"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_PICM"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DESC_PROD" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("GRUPO_PROD"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_QUANT"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VUNIT"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_TOTAL"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VALICM" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VALIMP5"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VALIMP6"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_ICMSRET"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VALIPI" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D1_VALFRE" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("IMPOSTOS"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)


//TRFunction():New(         oCell               ,cName,cFunction,oBreak,cTitle,       cPicture      ,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)
//TRFunction():New(oSection1:Cell("VALBRUTO")     , NIL ,  "SUM"  ,  NIL ,  ""  ,"@E 999,999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )

dbSelectArea("SD1")

dbSetOrder(oReport:GetOrder())

Return oReport

     

Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()

BeginSql alias "cAlias"
	
	SELECT D1_FILIAL FILIAL,D1_DOC DOCUMENTO, D1_SERIE SERIE, D1_NFORI NF_ORI, D1_SERIORI SERIE_ORI,
	SUBSTRING(D1_DTDIGIT,7,2)+'/'+SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4) AS DATADG,
	F4_CF,SD1.D1_VALDESC, SD1.D1_PICM,D1_COD COD_PROD, B1_DESC DESC_PROD, B1_GRUPO GRUPO_PROD,
	D1_QUANT,D1_VUNIT,D1_TOTAL,'' TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI,
	D1_VALICM,D1_VALIMP5, D1_VALIMP6, D1_ICMSRET, D1_VALIPI,D1_VALFRE, ''IMPOSTOS 
	FROM %table:SD1% SD1, %table:SB1% SB1, %table:SF4% SF4
	WHERE SD1.%notDel% and B1_TIPO = '3'AND D1_DTDIGIT BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02% AND D1_COD = B1_COD AND D1_TES = F4_CODIGO
	ORDER BY SUBSTRING(D1_DTDIGIT,7,2)+'/'+SUBSTRING(D1_DTDIGIT,5,2)+'/'+SUBSTRING(D1_DTDIGIT,1,4)
	
EndSql


aQuery:= GetLastQuery()

oSection1:EndQuery()

oSection1:Init()

oSection1:SetHeaderSection(.T.)

DbSelectArea('cAlias')
dbGoTop()

oReport:SetMeter(cAlias->(RecCount()))

While cAlias->(!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	
	oReport:IncMeter()
	                        
	
	oSection1:Cell("FILIAL"):SetValue(cAlias->FILIAL)
	oSection1:Cell("FILIAL"):SetAlign("CENTER")
	
	oSection1:Cell("DOCUMENTO"):SetValue(cAlias->DOCUMENTO)
	oSection1:Cell("DOCUMENTO"):SetAlign("CENTER")
	
	oSection1:Cell("SERIE"):SetValue(cAlias->SERIE)
	oSection1:Cell("SERIE"):SetAlign("LEFT")
	
	oSection1:Cell("NF_ORI"):SetValue(cAlias->NF_ORI)
	oSection1:Cell("NF_ORI"):SetAlign("LEFT")
	
	oSection1:Cell("SERIE_ORI"):SetValue(cAlias->SERIE_ORI)
	oSection1:Cell("SERIE_ORI"):SetAlign("LEFT")
	
	oSection1:Cell("DATADG"):SetValue(cAlias->DATADG)
	oSection1:Cell("DATADG"):SetAlign("CENTER")
	
	oSection1:Cell("F4_CF"):SetValue(cAlias->F4_CF)
	oSection1:Cell("F4_CF"):SetAlign("LEFT")
	
	oSection1:Cell("D1_VALDESC"):SetValue(cAlias->D1_VALDESC)
	oSection1:Cell("D1_VALDESC"):SetAlign("LEFT")
	
	oSection1:Cell("D1_PICM"):SetValue(cAlias->D1_PICM)
	oSection1:Cell("D1_PICM"):SetAlign("CENTER")
	
	oSection1:Cell("COD_PROD"):SetValue(cAlias->COD_PROD)
	oSection1:Cell("COD_PROD"):SetAlign("LEFT")
	
	oSection1:Cell("DESC_PROD"):SetValue(cAlias->DESC_PROD)
	oSection1:Cell("DESC_PROD"):SetAlign("CENTER")
	
	oSection1:Cell("GRUPO_PROD"):SetValue(cAlias->GRUPO_PROD)
	oSection1:Cell("GRUPO_PROD"):SetAlign("LEFT")
	
	oSection1:Cell("D1_QUANT"):SetValue(cAlias->D1_QUANT)
	oSection1:Cell("D1_QUANT"):SetAlign("LEFT")
	
	oSection1:Cell("D1_VUNIT"):SetValue(cAlias->D1_VUNIT)
	oSection1:Cell("D1_VUNIT"):SetAlign("CENTER")
	
	oSection1:Cell("D1_TOTAL"):SetValue(cAlias->D1_TOTAL)
	oSection1:Cell("D1_TOTAL"):SetAlign("CENTER")
	
	oSection1:Cell("TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI"):SetValue(cAlias->TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI)
	oSection1:Cell("TTL_COM_DESC_MENOS_ST_MENOS_FR_MENOS_IPI"):SetAlign("CENTER")
	
	oSection1:Cell("D1_VALICM"):SetValue(cAlias->D1_VALICM)
	oSection1:Cell("D1_VALICM"):SetAlign("CENTER")
	
	oSection1:Cell("D1_VALIMP5"):SetValue(cAlias->D1_VALIMP5)
	oSection1:Cell("D1_VALIMP5"):SetAlign("CENTER")
	
	oSection1:Cell("D1_VALIMP6"):SetValue(cAlias->D1_VALIMP6)
	oSection1:Cell("D1_VALIMP6"):SetAlign("CENTER")
	
	oSection1:Cell("D1_ICMSRET"):SetValue(cAlias->D1_ICMSRET)
	oSection1:Cell("D1_ICMSRET"):SetAlign("CENTER")
	
	oSection1:Cell("D1_VALIPI"):SetValue(cAlias->D1_VALIPI)
	oSection1:Cell("D1_VALIPI"):SetAlign("CENTER")
	
	oSection1:Cell("D1_VALFRE"):SetValue(cAlias->D1_VALFRE)
	oSection1:Cell("D1_VALFRE"):SetAlign("CENTER")
	
	oSection1:Cell("IMPOSTOS"):SetValue(cAlias->IMPOSTOS)
	oSection1:Cell("IMPOSTOS"):SetAlign("CENTER")
	
	oSection1:PrintLine()
	
	dbSelectArea("cAlias")
	
	cAlias->(dbSkip())
	
EndDo

oSection1:Finish()

dbSelectArea('SD1')
dbSetOrder()
Return



Static Function BFISR08B(cPerg)
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg , "01" , "Data de"      , ""    , ""    , "mv_ch1" , "D" , TAMSX3("D1_DTDIGIT")[1] , 0  , 0   , "G", ""   ,"SD1" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "02" , "Data ate"     , ""    , ""    , "mv_ch2" , "D" , TAMSX3("D1_DTDIGIT")[1] , 0  , 0   , "G", ""   ,"SD1" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")

Return

