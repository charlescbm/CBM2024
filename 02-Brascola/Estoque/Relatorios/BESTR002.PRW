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
!Modulo            ! EST - Estoque/Custos                                    !
+------------------+---------------------------------------------------------+
!Nome              ! BESTR002                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório do Seguro                                     !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 03/10/2013                                              !
+------------------+---------------------------------------------------------+
*/



User Function BESTR002()

Local oReport       
Local cPerg   := PADR("BESTR002",10)
Private aOrd:= {"Documento" , "Cliente" , "Data de Saída", "Valor Bruto"} //array de ordenação
Private cAlias := GetNextAlias()  
Private cOrdem := ""  
 
oReport := BESTR02A(cPerg)


U_BCFGA002("BESTR002")//Grava detalhes da rotina usada

BESTR02B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return  


//Montagem do Layout do Relatório 
Static Function BESTR02A(cPerg)
Local oReport
Local oSection1 
Local cTitulo := "Relatório do Seguro"
Local aTabelas:= {"SA1", "SF2"}


oReport:= TReport():New("BESTR002",cTitulo,cPerg,{|oReport| BESTR02C(oReport)},"Relatório do Seguro")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8  
oReport:ShowHeader()
          
           //TRSection():New( < oParent > , [ cTitle ] , [ uTable ] , [ aOrder ] , [ lLoadCells ] , [ lLoadOrder ] ) 
oSection1 := TRSection():New(   oReport   ,   cTitulo  ,  aTabelas  ,     aOrd   ,       .F.      ,        .F.     )  
oSection1:SetTotalInLine(.F.)

//FILIAL	MATRICULA	NOME	DEMISSAO	MESRESCISAO	AVISO_PREVIO	SALDO_RESC	REC_MESRESCISAO	REC_AVISO	REC_MULTA	TOTAL_RECOLHER

//TRCell():New(oSection1,cName            ,cAlias, cTitle        ,cPicture         ,nSize ,lPixel,bBlock,cAlign  ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New(oSection1,"FILIAL"         ,"SF2" , "Filial"    ,                ,  05  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DOCUMENTO"      ,"SF2" , "Documento" ,                ,  13  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"SERIE"          ,"SF2" , "Serie"     ,                ,  05  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"CLIENTE"        ,"SA1" , "Cliente"   ,                ,  40  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"MUNICIPIO"      ,"SA1" , "Municipio" ,                ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"ESTADO"         ,"SA1" , "Estado"    ,                ,  08  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"SAIDA"          ,"SF2" , "Saída"     ,                ,  15  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"VALBRUTO"       ,"SF2" , "ValorBruto", "@E 999,999.99",  20  ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )

//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("FILIAL"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DOCUMENTO"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SERIE"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("CLIENTE"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("MUNICIPIO"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("ESTADO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SAIDA"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VALBRUTO" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)



//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("FILIAL"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DOCUMENTO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SERIE"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("CLIENTE"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("MUNICIPIO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("ESTADO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SAIDA"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALBRUTO" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)


//TRFunction():New(         oCell               ,cName,cFunction,oBreak,cTitle,       cPicture      ,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)
TRFunction():New(oSection1:Cell("VALBRUTO")     , NIL ,  "SUM"  ,  NIL ,  ""  ,"@E 999,999,999.99"  ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )

dbSelectArea("SF2")
dbSetOrder(oReport:GetOrder()) 

Return oReport


Static Function BESTR02C(oReport)//PrintReport

Local oSection1 := oReport:Section(1)  
Private nOrdem  := oSection1:GetOrder()  

cData1:= ''
cData2:= '20491231'
cData3:= '19491231'
cData4:= '19491231'

If (nOrdem == 1  .And. MV_PAR03 = 1) //Ordem por: Documento Crescente
	cOrdem:= "% ORDER BY F2_DOC,F2_SERIE%"  
ElseIf (nOrdem == 1  .And. MV_PAR03 = 2)//Ordem por: Documento Decrescente
	cOrdem:= "% ORDER BY F2_DOC,F2_SERIE DESC%" 
ElseIf (nOrdem = 2  .And. MV_PAR03 = 1)//Ordem por: Cliente Crescente
	cOrdem:= "% ORDER BY A1_NOME, F2_DOC,F2_SERIE%" 
ElseIf (nOrdem = 2  .And. MV_PAR03 = 2)//Ordem por: Cliente Decrescente	
	cOrdem:= "% ORDER BY A1_NOME DESC, F2_DOC,F2_SERIE%" 
ElseIf (nOrdem = 3  .And. MV_PAR03 = 1)//Ordem por: Data Saída Crescente
	cOrdem:= "% ORDER BY F2_DTSAIDA, F2_DOC,F2_SERIE%" 
ElseIf (nOrdem = 3  .And. MV_PAR03 = 2)//Ordem por: Data Saída Decrescente	
	cOrdem:= "% ORDER BY F2_DTSAIDA DESC, F2_DOC,F2_SERIE%"		
ElseIf (nOrdem = 4  .And. MV_PAR03 = 1)//Ordem por: Valor Crescente
	cOrdem:= "% ORDER BY F2_VALBRUT, F2_DOC,F2_SERIE%"
Else
	cOrdem:= "% ORDER BY F2_VALBRUT DESC, F2_DOC,F2_SERIE%"//Ordem por: Valor Decrescente
EndIf
     
oSection1:BeginQuery() 

BeginSql alias "cAlias"
	SELECT SF2.F2_FILIAL AS FILIAL,SF2.F2_DOC AS DOCUMENTO, SF2.F2_SERIE AS SERIE, SA1.A1_NOME AS CLIENTE, SA1.A1_MUN AS MUNICIPIO, 
	SA1.A1_EST AS ESTADO, SF2.F2_DTSAIDA AS SAIDA, SF2.F2_VALBRUT AS VALBRUTO 
	FROM %table:SF2% SF2, %table:SA1% SA1
	WHERE SF2.%notDel% 
    AND SF2.F2_DTSAIDA NOT IN (%exp:cData1%,%exp:cData2%,%exp:cData3%,%exp:cData4%)
	AND SF2.F2_DTSAIDA BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%  
	AND SF2.F2_CLIENTE = SA1.A1_COD   
	AND SF2.F2_LOJA = SA1.A1_LOJA
	%exp:cOrdem%
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos


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

	//seta os conteúdos nos campos
	oSection1:Cell("FILIAL"):SetValue(cAlias->FILIAL)
	oSection1:Cell("FILIAL"):SetAlign("CENTER")
	
	oSection1:Cell("DOCUMENTO"):SetValue(cAlias->DOCUMENTO)
	oSection1:Cell("DOCUMENTO"):SetAlign("CENTER")
	
	oSection1:Cell("SERIE"):SetValue(cAlias->SERIE)
	oSection1:Cell("SERIE"):SetAlign("CENTER")
	  
	oSection1:Cell("CLIENTE"):SetValue(cAlias->CLIENTE)
	oSection1:Cell("CLIENTE"):SetAlign("LEFT") 
	
	oSection1:Cell("MUNICIPIO"):SetValue(cAlias->MUNICIPIO)
	oSection1:Cell("MUNICIPIO"):SetAlign("LEFT") 
	
	oSection1:Cell("ESTADO"):SetValue(cAlias->ESTADO)
	oSection1:Cell("ESTADO"):SetAlign("LEFT")
	
	oSection1:Cell("SAIDA"):SetValue(STOD(cAlias->SAIDA))
	oSection1:Cell("SAIDA"):SetAlign("CENTER")
	
	oSection1:Cell("VALBRUTO"):SetValue(cAlias->VALBRUTO)
	oSection1:Cell("VALBRUTO"):SetAlign("RIGHT")
	
	
	oSection1:PrintLine()
	
	dbSelectArea("cAlias")
	cAlias->(dbSkip())

EndDo
oSection1:Finish() 
dbSelectArea('SF2') 
dbSetOrder(1)

Return



Static Function BESTR02B(cPerg)
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01       ,cDefSpa1,cDefEng1,cCnt01, cDef02      ,cDefSpa2,cDefEng2,cDef03         ,cDefSpa3,cDefEng3,cDef04            ,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg , "01" , "Saída de"           , ""    , ""    , "mv_ch1" , "D" , TAMSX3("F2_DTSAIDA")[1] , 0  , 0   , "G", ""   ,"SF2" , ""    , ""  , "mv_par01", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "02" , "Saída ate"          , ""    , ""    , "mv_ch2" , "D" , TAMSX3("F2_DTSAIDA")[1] , 0  , 0   , "G", ""   ,"SF2" , ""    , ""  , "mv_par02", ""            ,""      ,""      ,""    ,""           ,""      ,""      ,""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "03" , "Tipo Ordem?"        , ""    , ""    , "mv_ch3" , "C" , 1                       , 0  , 0   , "C", ""   ,      , ""    , ""  , "mv_par03", "Crescente"   ,"      ","      ","    ","Decrecente" ,"      ","      ",""             ,""      ,""      ,""                ,""      ,""      ,""     ,""      ,"")
Return

