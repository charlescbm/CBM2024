
//******************************************************Etapa 1: Declarac�o das Includes*************************************************************
#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch" 
#include "topconn.ch"                                                                                                                   
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Cliente   �Autor  �Marlon He           � Data �  02/27/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Relatorio dos clientes                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



//******************************************************Etapa 2: Fun��o Principal********************************************************************
User Function ClienteMar() 
     

Private oReport
Private cPerg :=  PADR("ClienteMar",10)

Private aOrd := {"codigo" , "nome" }
Private cAlias := GetNextAlias()    

Private cOrdem := ""
oReport := ReportDef(cPerg)
//U_BCFGA002 ("ClienteMar")

ClienteMar(cPerg)     

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf


Return
                                                                    
     

//********************************************Etapa 3: Fun��o para defini��o do layout do relatorio************************************************** 
Static Function ReportDef(cPerg)

Local oSecao
Local cTitulo := "Relatorio de Clientes"
Local aTabela := {"SA1"} 

oReport:= TReport():New("ClienteMar",cTitulo,cPerg,{|oReport| PrintReport(oReport)},cTitulo)

oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)    
oReport:nFontBody := 9    
oReport:ShowHeader()    
oSecao := TRSection():New(   oReport   ,   cTitulo  ,  aTabela  ,     aOrd   ,       .F.      ,        .F.     )  
oSecao:SetTotalInLine(.F.)

TRCell():New(oSecao,"CODIGO"         ,"SA1" , "Codigo"    ,                ,  10  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSecao,"CNPJ"           ,"SA1" , "CNPJ"      ,                ,  20  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSecao,"NOME"           ,"SA1" , "Nome"      ,                ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )

oSecao:Cell("CODIGO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSecao:Cell("CNPJ"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSecao:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)   

oSecao:Cell("CODIGO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSecao:Cell("CNPJ"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSecao:Cell("NOME"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

dbSelectArea("SA1")
dbSetOrder(oReport:GetOrder())


Return oReport
                                                       

//************************************************Etapa 4: Fun��o para impress�o do relatorio******************************************************** 
Static Function PrintReport(oReport)
   
Local oSecao := oReport:Section(1) 
Private nOrdem := oSecao:GetOrder()

If (nOrdem == 1  .And. MV_PAR05 = 1) 
	cOrdem:= "% ORDER BY A1_COD, A1_NOME%"  
ElseIf (nOrdem == 1  .And. MV_PAR05 = 2)
	cOrdem:= "% ORDER BY A1_COD, A1_NOME DESC%" 
ElseIf (nOrdem = 2  .And. MV_PAR05 = 1)
	cOrdem:= "% ORDER BY A1_NOME%" 
Else
	cOrdem:= "% ORDER BY A1_NOME DESC%" 
EndIf


oSecao:BeginQuery()

BeginSql alias "cAlias"
	SELECT A1_COD AS CODIGO, A1_CGC AS CNPJ, A1_NOME AS NOME	
	FROM %table:SA1% SA1 
	WHERE A1_COD BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%  
	AND A1_NOME BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%  
	AND SA1.%notDel% 
	%exp:cOrdem% 
EndSql


aQuery:= GetLastQuery()

oSecao:EndQuery()


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

	oSecao:Cell("CODIGO"):SetValue(cAlias->CODIGO)//Metodo SetValue: define o valor para a celula
	oSecao:Cell("CODIGO"):SetAlign("CENTER")//Metodo SetAlign: define o alinhamento da celula
	
	oSecao:Cell("CNPJ"):SetValue(cAlias->CNPJ)
	oSecao:Cell("CNPJ"):SetAlign("CENTER")
	
	oSecao:Cell("NOME"):SetValue(cAlias->NOME)
	oSecao:Cell("NOME"):SetAlign("LEFT")	

oSecao:PrintLine()

dbSelectArea("cAlias")   

cAlias->(dbSkip()  )
EndDo

oSecao:Finish()    

dbSelectArea('SA1')//seleciona novamente a tabela SA1010 - Clientes
dbSetOrder(1)

	
Return

//************************************************Etapa 5: Fun��o para defini��o dos parametros******************************************************
Static Function ClienteMar(cPerg)   
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
  PutSX1(cPerg , "01" , "Codico de"      , ""    , ""    , "mv_ch1" , "C" , TAMSX3("A1_COD")[1]   , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "02" , "Codigo ate"     , ""    , ""    , "mv_ch2" , "C" , TAMSX3("A1_COD")[1]   , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par02", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "03" , "CNPJ de"        , ""    , ""    , "mv_ch3" , "C" , TAMSX3("A1_CGC")[1]   , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par03", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "04" , "CNPJ ate"       , ""    , ""    , "mv_ch4" , "C" , TAMSX3("A1_CGC")[1]   , 0  , 0   , "G", ""   ,"SA1" , ""    , ""  , "mv_par04", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
  PutSX1(cPerg , "05" , "Tipo Ordem?"    , ""    , ""    , "mv_ch5" , "C" , 1                      , 0  , 0   , "C", ""   ,      , ""    , ""  , "mv_par05", "Crescente"   ,"      ","      ","    ","Decrecente" ,"      ","      ",""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")


Return