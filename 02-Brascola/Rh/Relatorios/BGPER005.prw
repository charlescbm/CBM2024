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
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! GPE - Gest�o de Pessoal                                 !
+------------------+---------------------------------------------------------+
!Nome              ! BGPER005                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relat�rio de GRFC - Recolhimento Rescisorio do FGTS     !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 30/08/2013                                              !
+------------------+---------------------------------------------------------+
*/



User Function BGPER005()

Local oReport       
Local cPerg   := PADR("BGPER005",10)
Private aOrd:= {"Matricula" , "Nome" , "Data Demiss�o" , "Valor a Recolher"} //array de ordena��o
Private cAlias := GetNextAlias()  
Private cOrdem := ""  
 
oReport := BGPER05A(cPerg)


U_BCFGA002("BGPER005")//Grava detalhes da rotina usada

BGPER05B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return  


//Montagem do Layout do Relat�rio 
Static Function BGPER05A(cPerg)
Local oReport
Local oSection1 
Local cTitulo := "GRFC-Recolhimento Rescisorio do FGTS e da Contribui��o Social"
Local aTabelas:= {"SRA", "SRG", "SRR"}


oReport:= TReport():New("BGPER005",cTitulo,cPerg,{|oReport| BGPER05C(oReport)},"GRFC-Recolhimento Rescisorio do FGTS e da Contribui��o Social")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8  
oReport:ShowHeader()
          
           //TRSection():New( < oParent > , [ cTitle ] , [ uTable ] , [ aOrder ] , [ lLoadCells ] , [ lLoadOrder ] ) 
oSection1 := TRSection():New(   oReport   ,   cTitulo  ,  aTabelas  ,     aOrd   ,       .F.      ,        .F.     )  
oSection1:SetTotalInLine(.F.)

//FILIAL	MATRICULA	NOME	DEMISSAO	MESRESCISAO	AVISO_PREVIO	SALDO_RESC	REC_MESRESCISAO	REC_AVISO	REC_MULTA	TOTAL_RECOLHER

//TRCell():New(oSection1,cName            ,cAlias, cTitle        ,cPicture         ,nSize ,lPixel,bBlock,cAlign  ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New(oSection1,"FILIAL"         ,"SRA" , "Fil"          ,                ,  05  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"MATRICULA"      ,"SRA" , "Mat"          ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NOME"           ,"SRA" , "Nome"         ,                ,  40  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DEMISSAO"       ,"SRA" , "Demiss�o"     ,                ,  15  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"MESRESCISAO"    ,"   " , "MesResci"     , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"REC_MESRESCISAO","   " , "8%MesResci"   , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"AVISO_PREVIO"   ,"   " , "Av.Pv.Ind"    , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"REC_AVISO"      ,"   " , "8%Av.Pv.Ind"  , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"SALDO_RESC"     ,"   " , "SldoResc"     , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"REC_MULTA"      ,"   " , "MultaResc"    , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"TOTAL_RECOLHER" ,"   " , "TotRecolher"  , "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )


//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("FILIAL"          ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("MATRICULA"       ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NOME"            ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DEMISSAO"        ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("MESRESCISAO"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("REC_MESRESCISAO" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("AVISO_PREVIO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("REC_AVISO"       ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SALDO_RESC"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("REC_MULTA"       ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("TOTAL_RECOLHER"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)


//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("FILIAL"          ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("MATRICULA"       ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NOME"            ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DEMISSAO"        ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("MESRESCISAO"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("REC_MESRESCISAO" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("AVISO_PREVIO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("REC_AVISO"       ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SALDO_RESC"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("REC_MULTA"       ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("TOTAL_RECOLHER"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

//TRFunction():New(         oCell                  ,cName,cFunction,oBreak,cTitle,       cPicture      ,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)
TRFunction():New(oSection1:Cell("MESRESCISAO")     , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )
TRFunction():New(oSection1:Cell("REC_MESRESCISAO") , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )
TRFunction():New(oSection1:Cell("AVISO_PREVIO")    , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )
TRFunction():New(oSection1:Cell("REC_AVISO")       , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )
TRFunction():New(oSection1:Cell("SALDO_RESC")      , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )
TRFunction():New(oSection1:Cell("REC_MULTA")       , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )
TRFunction():New(oSection1:Cell("TOTAL_RECOLHER")  , NIL ,  "SUM"  ,  NIL ,  ""  ,    "@E 999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )

dbSelectArea("SRA")
dbSetOrder(oReport:GetOrder()) 

Return oReport


Static Function BGPER05C(oReport)//PrintReport

Local oSection1 := oReport:Section(1)  
Private nOrdem  := oSection1:GetOrder()  



If (nOrdem == 1  .And. MV_PAR05 = 1) //Ordem por: Matricula Crescente
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,SRA.RA_MAT ASC,SRA.RA_DEMISSA%"  
ElseIf (nOrdem == 1  .And. MV_PAR05 = 2)//Ordem por: Matricula Decrescente
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,SRA.RA_MAT DESC,SRA.RA_DEMISSA%" 
ElseIf (nOrdem = 2  .And. MV_PAR05 = 1)//Ordem por: Nome Crescente
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,SRA.RA_NOME ASC,SRA.RA_MAT ASC,SRA.RA_DEMISSA%" 
ElseIf (nOrdem = 2  .And. MV_PAR05 = 2)//Ordem por: Nome Decrescente	
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,SRA.RA_NOME DESC,SRA.RA_MAT DESC,SRA.RA_DEMISSA%"	
ElseIf (nOrdem = 3  .And. MV_PAR05 = 1)//Ordem por: Demissao Crescente
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,SRA.RA_DEMISSA ASC,SRA.RA_MAT ASC%" 
ElseIf (nOrdem = 3  .And. MV_PAR05 = 2)//Ordem por: Demissao Decrescente	
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,SRA.RA_DEMISSA DESC,SRA.RA_MAT DESC%"
ElseIf (nOrdem = 4  .And. MV_PAR05 = 1)//Ordem por: Valor Crescente
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,TOTAL_RECOLHER ASC,SRA.RA_MAT ASC%"
Else
	cOrdem:= "% ORDER BY SRA.RA_FILIAL,TOTAL_RECOLHER DESC,SRA.RA_MAT DESC%"//Ordem por: Valor Decrescente
EndIf
     
oSection1:BeginQuery()

BeginSql alias "cAlias"
	SELECT SRA.RA_FILIAL AS FILIAL, SRA.RA_MAT AS MATRICULA, SRA.RA_NOME AS NOME,SRA.RA_DEMISSA AS DEMISSAO,
	ROUND(SUM(CASE WHEN RR_PD IN ('775','776') THEN RR_VALOR ELSE
	(CASE WHEN RR_PD IN ('141','175') THEN RR_VALOR * -1 ELSE 0	END) END),2) AS MESRESCISAO,
	ROUND(SUM(CASE WHEN RR_PD IN ('141','175') THEN RR_VALOR END),2) AS AVISO_PREVIO,
	ROUND(SUM(CASE WHEN RR_PD IN ('733','734','739') THEN RR_VALOR END),2) AS SALDO_RESC,
	ROUND((SUM(CASE WHEN RR_PD IN ('775','776') THEN RR_VALOR ELSE
	(CASE WHEN RR_PD IN ('141','175') THEN RR_VALOR * -1 ELSE 0 END) END)*0.08),2) AS REC_MESRESCISAO,
	ROUND((SUM(CASE WHEN RR_PD IN ('141','175') THEN RR_VALOR END)*0.08),2) AS REC_AVISO,
	ROUND((SUM(CASE WHEN RR_PD IN ('733','734','739') THEN RR_VALOR END)*0.50),2) AS REC_MULTA,
	ROUND(((SUM(CASE WHEN RR_PD IN ('775','776') THEN RR_VALOR ELSE (CASE WHEN RR_PD IN ('141','175') THEN	RR_VALOR * -1 ELSE 0 END) END)*0.08)+
	(SUM(CASE WHEN RR_PD IN ('141','175') THEN RR_VALOR END)*0.08)+(SUM(CASE WHEN RR_PD IN ('733','734','739') THEN RR_VALOR END)*0.50)),2) AS TOTAL_RECOLHER
	FROM %table:SRA% SRA, %table:SRG% SRG, %table:SRR% SRR
	WHERE SRR.%notDel%
	AND SRA.%notDel%
	AND SRG.%notDel%
	AND SRR.RR_MAT = SRA.RA_MAT
	AND SRR.RR_FILIAL = SRA.RA_FILIAL
	AND SRR.RR_FILIAL = SRG.RG_FILIAL
	AND SRR.RR_MAT = SRG.RG_MAT
	AND SRA.RA_SITFOLH = 'D'
	AND SRG.RG_TIPORES = '01'
	AND SRR.RR_PD IN ('141','175','733','734','739','775','776')
	AND SRA.RA_FILIAL = %xfilial:SRA%
	AND SRA.RA_MAT BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND SRA.RA_DEMISSA BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND SRG.RG_RESCDIS NOT IN  ('1','2','3','4')
	AND SRG.RG_DTGERAR = SRR.RR_DATA
	AND RG_DATADEM = RG_DTGERAR
	GROUP BY SRA.RA_FILIAL,SRA.RA_MAT, SRA.RA_NOME, SRA.RA_DEMISSA, SRG.RG_RESCDIS  
	%exp:cOrdem%
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informa��es da query, util para visualizar na aba Comandos


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

	//seta os conte�dos nos campos
	oSection1:Cell("FILIAL"):SetValue(cAlias->FILIAL)
	oSection1:Cell("FILIAL"):SetAlign("CENTER")
	
	oSection1:Cell("MATRICULA"):SetValue(cAlias->MATRICULA)
	oSection1:Cell("MATRICULA"):SetAlign("CENTER")
	
	oSection1:Cell("NOME"):SetValue(cAlias->NOME)
	oSection1:Cell("NOME"):SetAlign("LEFT")
	
	oSection1:Cell("DEMISSAO"):SetValue(STOD(cAlias->DEMISSAO))
	oSection1:Cell("DEMISSAO"):SetAlign("CENTER")
	
	oSection1:Cell("MESRESCISAO"):SetValue(cAlias->MESRESCISAO)
	oSection1:Cell("MESRESCISAO"):SetAlign("RIGHT")
	
	oSection1:Cell("AVISO_PREVIO"):SetValue(cAlias->AVISO_PREVIO)
	oSection1:Cell("AVISO_PREVIO"):SetAlign("RIGHT")
	
	oSection1:Cell("SALDO_RESC"):SetValue(cAlias->SALDO_RESC)
	oSection1:Cell("SALDO_RESC"):SetAlign("RIGHT")
	
	oSection1:Cell("REC_MESRESCISAO"):SetValue(cAlias->REC_MESRESCISAO)
	oSection1:Cell("REC_MESRESCISAO"):SetAlign("RIGHT")
	
	oSection1:Cell("REC_AVISO"):SetValue(cAlias->REC_AVISO)
	oSection1:Cell("REC_AVISO"):SetAlign("RIGHT")   
	
	oSection1:Cell("REC_MULTA"):SetValue(cAlias->REC_MULTA)
	oSection1:Cell("REC_MULTA"):SetAlign("RIGHT")
	                                               
	oSection1:Cell("TOTAL_RECOLHER"):SetValue(cAlias->TOTAL_RECOLHER)
	oSection1:Cell("TOTAL_RECOLHER"):SetAlign("RIGHT")
	
	oSection1:PrintLine()
	
	dbSelectArea("cAlias")
	cAlias->(dbSkip())

EndDo
oSection1:Finish() 
dbSelectArea('SRA') 
dbSetOrder(1)

Return



Static Function BGPER05B(cPerg)
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg , "01" , "Matricula de"     , ""    , ""    , "mv_ch1" , "C" , TAMSX3("RA_MAT")[1]     , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "02" , "Matricula ate"    , ""    , ""    , "mv_ch2" , "C" , TAMSX3("RA_MAT")[1]     , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par02", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "03" , "Demissao de"      , ""    , ""    , "mv_ch3" , "D" , TAMSX3("RA_DEMISSA")[1] , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par03", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "04" , "Demissao ate"     , ""    , ""    , "mv_ch4" , "D" , TAMSX3("RA_DEMISSA")[1] , 0  , 0   , "G", ""   ,"SRA" , ""    , ""  , "mv_par04", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
//PutSX1(cPerg , "05" , "Ordena��o?"       , ""    , ""    , "mv_ch5" , "C" , 1                       , 0  , 0   , "C", ""   ,      , ""    , ""  , "mv_par05", "Matricula"   ,"      ","      ","    ","Nome"       ,"      ","      ","Data Demiss�o",""      ,""      ,"Valor Recolher"  ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "05" , "Tipo Ordem?"      , ""    , ""    , "mv_ch5" , "C" , 1                       , 0  , 0   , "C", ""   ,      , ""    , ""  , "mv_par05", "Crescente"   ,"      ","      ","    ","Decrecente" ,"      ","      ",""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
Return

