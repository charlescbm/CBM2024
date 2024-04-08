#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE STR0002 "Nota Fiscal"
#DEFINE STR0003 "Série"
#DEFINE STR0004 "Codigo"
#DEFINE STR0005	"Descricao"
#DEFINE STR0008 "Resultado da Consulta"
#DEFINE STR0009 "NF"
#DEFINE STR0010 "Mensagem"
#DEFINE STR0011 "Consultar Novo Protocolo?"
#DEFINE STR0012 "Consultando Protocolo"
#DEFINE STR0013 "Aguarde..."


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
!Nome              ! BFISR006                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório de Vendas por Estado                          !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/08/2013                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"     

User Function BFISR006()

Local cPerg   := PADR("BFISR006",10)
Local oReport := BFISR06A(cPerg)

U_BCFGA002("BFISR006")//Grava detalhes da rotina usada

BFISR06B(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function BFISR06A(cPerg)

Local oReport
Local oSection1

oReport:= TReport():New("BFISR006","Relação Protocolo",cPerg,{|oReport| BFISR06C(oReport)},"Impressão do Relatório de Protocolo NFE Sefaz")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8
     
oSection1 := TRSection():New(oReport,"Relação Protocolo",{"SF2", "SD2"})  //Tabelas usadas na query

//TRCell():New(oSection1,cName         ,cAlias, cTitle        ,cPicture         ,nSize ,lPixel,bBlock,cAlign  ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
  TRCell():New(oSection1,"NOTAFISCAL"  ,"SF2" , "NotaFiscal"  ,                 ,  20  ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"EMISSAO"     ,"SF2" , "Emissão"     ,                 ,  25  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )  
  TRCell():New(oSection1,"CNPJ"        ,"SF2" , "Cnpj"        ,                 ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )  
  TRCell():New(oSection1,"PROTOCOLO"   ,"SF2" , "Protocolo"   ,                 ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  //TRCell():New(oSection1,"CHAVE"       ,"SF2" , "Chave"       ,                 ,  100 ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"CODIGO"      ,"SA1" , "Código"      ,                 ,  15  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )  
  TRCell():New(oSection1,"CLIENTE"     ,"SA1" , "Cliente"     ,                 ,  60  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
  TRCell():New(oSection1,"LOJA"        ,"SA1" , "Loja"        ,                 ,  8   ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     ) 
  

                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("NOTAFISCAL"):SetBorder("BOTTOM",1,CLR_BLACK,.T.) 
 oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("CNPJ"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("PROTOCOLO" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 //oSection1:Cell("CHAVE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.) 
 oSection1:Cell("CODIGO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)  
 oSection1:Cell("CLIENTE"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
 oSection1:Cell("LOJA"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

                       //SetBorder(uBorder,nWeight,nColor,lHeader) 
 oSection1:Cell("NOTAFISCAL"):SetBorder("BOTTOM",1,CLR_BLACK,.F.) 
 oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("CNPJ"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("PROTOCOLO" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 //oSection1:Cell("CHAVE"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("CODIGO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)  
 oSection1:Cell("CLIENTE"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
 oSection1:Cell("LOJA"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
    
//TRFunction():New(         oCell         ,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent   ,bCondition,lDisable,bCanPrint)  
//TRFunction():New(oSection1:Cell("VALOR"), NIL ,  "SUM"  ,  NIL ,  NIL ,    NIL ,   NIL  ,   .F.     ,     .T.  ,   .F.  , oSection1,          ,        ,         )  
//TRFunction():New(oSection1:Cell("VALOR"),     , "COUNT" ,      ,      ,        ,        ,   .T.     ,     .F.  ,   .F.  , oSection1,          ,        ,         ) 
Return oReport


Static Function BFISR06C(oReport)

Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery() 

BeginSql alias cAlias
	SELECT F2_DOC AS NOTAFISCAL, F2_EMISSAO AS EMISSAO, F2_CODNFE AS PROTOCOLO,
	F2_CLIENTE AS CODIGO, A1_NOME AS CLIENTE, A1_LOJA AS LOJA, A1_CGC AS CNPJ	
	FROM %table:SF2% F2, %table:SD2% D2, %table:SA1% A1
	WHERE F2.%notDel%
	AND D2.%notDel%
	AND F2_FILIAL = D2_FILIAL
	AND F2_DOC = D2_DOC
	AND F2_CLIENTE = A1_COD
	AND F2_LOJA = A1_LOJA
	AND F2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND F2_DOC BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND F2_SERIE = %exp:MV_PAR05%
	GROUP BY F2_DOC,F2_EMISSAO, F2_CODNFE, F2_CLIENTE, A1_NOME,A1_LOJA, A1_CGC
	ORDER BY F2_EMISSAO, F2_DOC
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos     

oSection1:EndQuery()
oSection1:Print()     

Return

Static Function BFISR06B(cPerg)
  //PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSX1(cPerg , "01" , "Emissao de"      , ""    , ""    , "mv_ch1" , "D" , TAMSX3("F2_EMISSAO")[1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par01", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "02" , "Emissao ate"     , ""    , ""    , "mv_ch2" , "D" , TAMSX3("F2_EMISSAO")[1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par02", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "03" , "Nota Fiscal de"  , ""    , ""    , "mv_ch3" , "C" , TAMSX3("F2_DOC")    [1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par03", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
	PutSX1(cPerg , "04" , "Nota Fiscal ate" , ""    , ""    , "mv_ch4" , "C" , TAMSX3("F2_DOC")    [1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par04", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
    PutSX1(cPerg , "05" , "Série"           , ""    , ""    , "mv_ch5" , "C" , TAMSX3("F2_SERIE")  [1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par05", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
Return

/*  Exemplo Web Service
Static Function PROTInfo()

Local aPerg			:= {}
Local aResult		:= {}

Local bPROTSearch

Local cXML

Local cError		:= ""
Local cWarning		:= ""

Local cMensagem
Local cResultado

Local oWSPROT
Local oXML

LOCAL lRetu1 := .F., aAutoDanfe, cFilePrint, cFileXML
LOCAL cIdEnt, aIndArq := {}, oDanfe, oSetup, nHRes := 0, nVRes := 0
LOCAL aDevice := {}, nDevice, cTitulo, cTexto, cEmail, cCopia, aAnexo
LOCAL cTempPath := GetTempPath(), cServPath := MsDocPath(), cNFes := ""
LOCAL lContinua := .F.

Local cURL := PadR(GetNewPar("MV_SPEDURL","http://"),250)

BEGIN SEQUENCE

aAdd( aPerg , { 1 , STR0002 , Space(9) , "999999999" , ".T." , "" , ".T." ,9 , .T. } )
aAdd( aPerg , { 1 , STR0003 , Space(3) , "999"       , ".T." , "" , ".T." ,3 , .T. })


IF ParamBox( @aPerg , "Parametros" , NIL , NIL , NIL , .T. )
	cIdEnt := u_BXGetIdEnt()
	
	oWSPROT 		          := WSNFeSBRA():New()
	oWSPROT:cUSERTOKEN        := "TOTVS"
	oWSPROT:cID_ENT           := cIdEnt
	oWSPROT:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
	oWSPROT:cIdInicial        := MV_PAR02+MV_PAR01
	oWSPROT:cIdFinal          := MV_PAR02+MV_PAR01
	oWSPROT:dDataDe           := ctod("01/01/1980")
	oWSPROT:dDataAte          := ctod("31/12/2049")
	oWSPROT:cCNPJDESTInicial  := Replicate(" ",14)
	oWSPROT:cCNPJDESTFinal    := Replicate("z",14)
	oWSPROT:nDiasparaExclusao := 0
	lOk                       := oWSPROT:RETORNAFX()
	oRetorno                  := oWSPROT:oWsRetornaFxResult
	
	If lOk
		For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
			oXml := oRetorno:OWSNOTAS:OWSNFES3[nX]
			oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
			cXML := ""
			If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U"
				cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
			ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
				cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)
			Else
				cCNPJDEST := ""
			EndIf
			
			If !Empty(oXml:oWSNFe:cProtocolo)
				cProtocol:= oXml:oWSNFe:cProtocolo
				cNotaIni := oXml:cID
				cIdflush := cNotaIni
				cNFes    := cNFes+cNotaIni+CRLF
				cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")
				cModelo  := cChvNFe
				cModelo  := StrTran(cModelo,"NFe","")
				cModelo  := StrTran(cModelo,"CTe","")
				cModelo  := SubStr(cModelo,21,02)
				Do Case
					Case cModelo == "57"
						cPrefixo := "CTe"
					OtherWise
						cPrefixo := "NFe"
				EndCase
			EndIf
			
			If oXml:OWSNFECANCELADA <>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
				cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
				cNotaIni := oXml:cID
				cIdflush := cNotaIni
				cNFes := cNFes+cNotaIni+CRLF
			EndIf
		Next nX
		
	EndIf
EndIf
END SEQUENCE

Return      */


