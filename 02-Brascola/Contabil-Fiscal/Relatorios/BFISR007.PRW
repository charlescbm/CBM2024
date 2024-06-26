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
!Modulo            ! FIS - Relatório de Royalties                            !
+------------------+---------------------------------------------------------+
!Nome              ! BFISR007                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório Funcionários                                  !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 03/04/2014                                              !
+------------------+---------------------------------------------------------+
*/


User Function BFISR007()

Private oReport   
Private cPerg   := PADR("BFISR007",10)  
                                       
//Private aOrd:= {"Matricula" , "Nome" } 
Private cAlias := GetNextAlias()  

//Private cOrdem := ""
 
oReport := ReportDef(cPerg)


U_BCFGA002("BFISR007")

BFISR07B(cPerg) 
         

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return  


//Funcao que ira fazer a montagem do Layout/Estrutura do Relatorio 
Static Function ReportDef(cPerg)
Local oSection1 
Local cTitulo := "Relatorio de Royalties"
Local aTabelas:= {"SD2", "SB1", "SA1", "SF4"}



oReport:= TReport():New("BFISR007",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)
                                                                                         

oReport:SetLandscape()
                       
oReport:SetTotalInLine(.F.) 
                   

oReport:nFontBody := 8 
oReport:ShowHeader()
      
      
oSection1 := TRSection():New(   oReport   ,   cTitulo  ,  aTabelas  ,     /*aOrd*/   ,       .F.      ,        .F.     )  
oSection1:SetTotalInLine(.F.)



TRCell():New(oSection1,"FILIAL"         ,"SD2" , "FILIAL"    ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DOCUMENTO"      ,"SD2" , "DOCUMENTO" ,                ,  20  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"SERIE"          ,"SD2" , "SERIE"     ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"F4_CF"          ,"SF4" , "F4_CF"     ,                ,  30  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"EMISSAO"        ,"SD2" , "EMISSAO"   ,                ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_PROD"       ,"SD2" , "COD_PROD"  ,                ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DES_PROD"       ,"SB1" , "DES_PROD"  ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D2_PRUNIT"      ,"SD2" , "D2_PRUNIT" ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D2_QUANT"       ,"SD2" , "D2_QUANT"  ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D2_TOTAL"       ,"SD2" , "D2_TOTAL"  ,                ,  40  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D2_VALBRUT"     ,"SD2" , "D2_VALBRUT",                ,  40  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D2_DESCON"      ,"SD2" , "D2_DESCON" ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"BASE_ICM"       ,"SD2" , "BASE_ICM"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )  
TRCell():New(oSection1,"ICM_RET"        ,"SD2" , "ICM_RET"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"VAL_ICM"        ,"SD2" , "VAL_ICM"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"VAL_COF"        ,"SD2" , "VAL_COF"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"VAL_PIS"        ,"SD2" , "VAL_PIS"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"VAL_IPI"        ,"SD2" , "VAL_IPI"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"D2_VALFRE"      ,"SD2" , "D2_VALFRE" ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_CLI"        ,"SA1" , "COD_CLI"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NOME_CLI"       ,"SA1" , "NOME_CLI"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"EST_CLI"        ,"SA1" , "EST_CLI"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )                     
TRCell():New(oSection1,"IMPOSTOS"       ,"   " , "IMPOSTOS"  ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )

//FILIAL	DOCUMENTO	SERIE	F4_CF	EMISSAO	COD_PROD	DES_PROD	D2_PRUNIT	D2_QUANT	D2_TOTAL	
//D2_VALBRUT	D2_DESCON	BASE_ICM	ICM_RET	VAL_ICM	VAL_COF	VAL_PIS	VAL_IPI	D2_VALFRE	COD_CLI	NOME_CLI	EST_CLI	IMPOSTOS

oSection1:Cell("FILIAL"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DOCUMENTO" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SERIE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("F4_CF"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DES_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D2_PRUNIT" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
oSection1:Cell("D2_QUANT"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D2_TOTAL"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)   
oSection1:Cell("D2_VALBRUT"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D2_DESCON" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("BASE_ICM"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("ICM_RET"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VAL_ICM"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VAL_COF"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VAL_PIS"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VAL_IPI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("D2_VALFRE" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
oSection1:Cell("NOME_CLI"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("EST_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)   
oSection1:Cell("IMPOSTOS"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

oSection1:Cell("FILIAL"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DOCUMENTO" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SERIE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("F4_CF"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DES_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D2_PRUNIT" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
oSection1:Cell("D2_QUANT"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D2_TOTAL"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)   
oSection1:Cell("D2_VALBRUT"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D2_DESCON" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("BASE_ICM"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("ICM_RET"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VAL_ICM"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VAL_COF"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VAL_PIS"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VAL_IPI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("D2_VALFRE" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
oSection1:Cell("NOME_CLI"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("EST_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)   
oSection1:Cell("IMPOSTOS"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
  



//TRFunction():New(         oCell               ,cName,cFunction,oBreak,cTitle,       cPicture      ,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)
//TRFunction():New(oSection1:Cell("VALBRUTO")     , NIL ,  "SUM"  ,  NIL ,  ""  ,"@E 999,999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )

dbSelectArea("SD2") 

dbSetOrder(oReport:GetOrder())

Return oReport 
             


Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()


BeginSql alias "cAlias"
	
	SELECT D2_FILIAL FILIAL, D2_DOC DOCUMENTO, D2_SERIE SERIE, F4_CF,
	SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4) EMISSAO,
	D2_COD COD_PROD,
	B1_DESC DES_PROD,
	D2_PRUNIT,
	D2_QUANT,
	D2_TOTAL,
	D2_VALBRUT,
	D2_DESCON,
	D2_BASEICM BASE_ICM,
	D2_ICMSRET ICM_RET,
	D2_VALICM VAL_ICM,
	D2_VALIMP5 VAL_COF,
	D2_VALIMP6 VAL_PIS,
	D2_VALIPI VAL_IPI,
	D2_VALFRE,
	A1_COD COD_CLI,
	A1_NOME NOME_CLI,
	A1_EST EST_CLI,
	'' IMPOSTOS
	FROM %table:SD2% SD2, %table:SB1% SB1, %table:SA1% SA1, %table:SF4% SF4
	WHERE SD2.%notDel%
	AND B1_TIPO = '3'
	AND D2_TES = SF4.F4_CODIGO
	AND D2_COD = B1_COD
	AND D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND D2_CLIENTE = A1_COD
	AND D2_LOJA = A1_LOJA
	ORDER BY SUBSTRING(D2_EMISSAO,7,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+SUBSTRING(D2_EMISSAO,1,4)
	
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
	
	oSection1:Cell("F4_CF"):SetValue(cAlias->F4_CF)
	oSection1:Cell("F4_CF"):SetAlign("LEFT")
	  
	oSection1:Cell("EMISSAO"):SetValue(STOD(cAlias->EMISSAO))
	oSection1:Cell("EMISSAO"):SetAlign("CENTER") 
	
	oSection1:Cell("COD_PROD"):SetValue(cAlias->COD_PROD)
	oSection1:Cell("COD_PROD"):SetAlign("LEFT") 
	
	oSection1:Cell("DES_PROD"):SetValue(cAlias->DES_PROD)
	oSection1:Cell("DES_PROD"):SetAlign("LEFT")
	
	oSection1:Cell("D2_PRUNIT"):SetValue(cAlias->D2_PRUNIT)
	oSection1:Cell("D2_PRUNIT"):SetAlign("CENTER")
	
	oSection1:Cell("D2_QUANT"):SetValue(cAlias->D2_QUANT)
	oSection1:Cell("D2_QUANT"):SetAlign("LEFT")   

	oSection1:Cell("D2_TOTAL"):SetValue(cAlias->D2_TOTAL)
	oSection1:Cell("D2_TOTAL"):SetAlign("CENTER")
	
	oSection1:Cell("D2_VALBRUT"):SetValue(cAlias->D2_VALBRUT)
	oSection1:Cell("D2_VALBRUT"):SetAlign("LEFT")      
	
	oSection1:Cell("D2_DESCON"):SetValue(cAlias->D2_DESCON)
	oSection1:Cell("D2_DESCON"):SetAlign("LEFT")     
	
	oSection1:Cell("BASE_ICM"):SetValue(cAlias->BASE_ICM)
	oSection1:Cell("BASE_ICM"):SetAlign("CENTER")   
	
	oSection1:Cell("ICM_RET"):SetValue(cAlias->ICM_RET)
	oSection1:Cell("ICM_RET"):SetAlign("CENTER")
	
	oSection1:Cell("VAL_ICM"):SetValue(cAlias->VAL_ICM)
	oSection1:Cell("VAL_ICM"):SetAlign("CENTER")
	         
	oSection1:Cell("VAL_COF"):SetValue(cAlias->VAL_COF)
	oSection1:Cell("VAL_COF"):SetAlign("CENTER")
	
	oSection1:Cell("VAL_PIS"):SetValue(cAlias->VAL_PIS)
	oSection1:Cell("VAL_PIS"):SetAlign("CENTER")
	
	oSection1:Cell("VAL_IPI"):SetValue(cAlias->VAL_IPI)
	oSection1:Cell("VAL_IPI"):SetAlign("CENTER")   
	
	oSection1:Cell("D2_VALFRE"):SetValue(cAlias->D2_VALFRE)
	oSection1:Cell("D2_VALFRE"):SetAlign("CENTER")
	
	oSection1:Cell("COD_CLI"):SetValue(cAlias->COD_CLI)
	oSection1:Cell("COD_CLI"):SetAlign("CENTER")
	
	oSection1:Cell("NOME_CLI"):SetValue(cAlias->NOME_CLI)
	oSection1:Cell("NOME_CLI"):SetAlign("CENTER")

	oSection1:Cell("EST_CLI"):SetValue(cAlias->EST_CLI)
	oSection1:Cell("EST_CLI"):SetAlign("CENTER")
	
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



Static Function BFISR07B(cPerg)
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg , "01" , "Data de"      , ""    , ""    , "mv_ch1" , "D" , TAMSX3("D2_EMISSAO")[1] , 0  , 0   , "G", ""   ,"SD2" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "02" , "Data ate"     , ""    , ""    , "mv_ch2" , "D" , TAMSX3("D2_EMISSAO")[1] , 0  , 0   , "G", ""   ,"SD2" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")

Return

