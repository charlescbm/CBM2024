//******************************************************Etapa 1: Declaracão das Includes*************************************************************
#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch" 
#include "topconn.ch"                                                                                                                   
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Comicao   ºAutor  ³Marlon Heiber       º Data ³  10/03/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³   Relatorio de comicao dos vendedores                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



//******************************************************Etapa 2: Função Principal********************************************************************
User Function COMICAO() 
     

Private oReport
Private cPerg :=  PADR("COMICAO",10)

Private aOrd := {"comicao" , "nome" }
Private cAlias := GetNextAlias()    

Private cOrdem := ""
oReport := ReportDef(cPerg)
//U_BCFGA002 ("COMICAO")

ClienteMar(cPerg)     

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf


Return
                                                                    
     

//********************************************Etapa 3: Função para definição do layout do relatorio************************************************** 
Static Function ReportDef(cPerg)

Local oSecao
Local cTitulo := "Relatorio de Comicao de Vendedores"
Local aTabela := {"SA3"} 

oReport:= TReport():New("COMICAO",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)

oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)    
oReport:nFontBody := 9    
oReport:ShowHeader()    
oSecao := TRSection():New(   oReport   ,   cTitulo  ,  aTabela  ,     aOrd   ,       .F.      ,        .F.     )  
oSecao:SetTotalInLine(.F.)

TRCell():New(oSecao,"COMICAO"        ,"SA3" , "COMICAO"   ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSecao,"CNPJ"           ,"SA3" , "CNPJ"      ,                ,  20  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSecao,"NOME"           ,"SA3" , "Nome"      ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )

oSecao:Cell("COMICAO"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSecao:Cell("CNPJ"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSecao:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)   

oSecao:Cell("COMICAO"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSecao:Cell("CNPJ"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSecao:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

dbSelectArea("SA3")
dbSetOrder(oReport:GetOrder())


Return oReport
                                                       

//************************************************Etapa 4: Função para impressão do relatorio******************************************************** 
Static Function PrintReport(oReport)
   
Local oSecao := oReport:Section(1) 
Private nOrdem := oSecao:GetOrder()

If (nOrdem == 1  .And. MV_PAR05 = 1) 
	cOrdem:= "% ORDER BY A3_COMIS, A3_NOME%"  
ElseIf (nOrdem == 1  .And. MV_PAR05 = 2)
	cOrdem:= "% ORDER BY A3_COMIS, A3_NOME DESC%" 
ElseIf (nOrdem = 2  .And. MV_PAR05 = 1)
	cOrdem:= "% ORDER BY A3_NOME%" 
Else
	cOrdem:= "% ORDER BY A3_NOME DESC%" 
EndIf


oSecao:BeginQuery()

BeginSql alias "cAlias"
	SELECT A3_COMIS AS COMICAO, A3_CGC AS CNPJ, A3_NOME AS NOME	
	FROM %table:SA3% SA3 
	WHERE A3_COMIS BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%  
	AND A3_NOME BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%  
	AND SA3.%notDel% 
	%exp:cOrdem% 
EndSql

aQuery:= GetLastQuery()

oSecao:EndQuery()
//em comandos, poe break poit depois do aQuery e digita aQuery[2] e da um Enter assim que o break poit passar, assim sera possivel ver a query


oSecao:Init()   

oSecao:SetHeaderSection(.T.)

DbSelectArea('cAlias')   

dbGoTop()

oReport:SetMeter(cAlias->(RecCount())  )

While cAlias->(!Eof())
	If oReport:Cancel()  
	Exit
	EndIf	
	
oReport:IncMeter()	

	oSecao:Cell("COMICAO"):SetValue(cAlias->COMICAO)//Metodo SetValue: define o valor para a celula
	oSecao:Cell("COMICAO"):SetAlign("CENTER")//Metodo SetAlign: define o alinhamento da celula
	
	oSecao:Cell("CNPJ"):SetValue(cAlias->CNPJ)
	oSecao:Cell("CNPJ"):SetAlign("CENTER")
	
	oSecao:Cell("NOME"):SetValue(cAlias->NOME)
	oSecao:Cell("NOME"):SetAlign("LEFT")	

oSecao:PrintLine()

dbSelectArea("cAlias")   

cAlias->(dbSkip()  )
EndDo

oSecao:Finish()    

dbSelectArea('SA3')//seleciona novamente a tabela SA1010 - Clientes
dbSetOrder(1)

	
Return

//************************************************Etapa 5: Função para definição dos parametros******************************************************
Static Function ClienteMar(cPerg)   
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
  PutSX1(cPerg , "01" , "Comicao de"     , ""    , ""    , "mv_ch1" , "N" , TAMSX3("A3_COMIS")[1] , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "02" , "Comicao ate"    , ""    , ""    , "mv_ch2" , "N" , TAMSX3("A3_COMIS")[1] , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par02", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "03" , "CNPJ de"        , ""    , ""    , "mv_ch3" , "C" , TAMSX3("A3_CGC")[1]   , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par03", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "04" , "CNPJ ate"       , ""    , ""    , "mv_ch4" , "C" , TAMSX3("A3_CGC")[1]   , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par04", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "05" , "Tipo Ordem?"    , ""    , ""    , "mv_ch5" , "C" , 1                      , 0  , 0   , "C", ""   ,      , ""    , ""  , "mv_par05", "Crescente"   ,"      ","      ","    ","Decrecente" ,"      ","      ",""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")


Return