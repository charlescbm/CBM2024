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
!Descricao         ! Relatório de Vendas por Região                              !
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

User Function BFATR012()

Local cPerg   := PADR("BFATR012",10)
Local oReport := Nil

U_BCFGA002("BFATR012")//Grava detalhes da rotina usada

BFATR12B(cPerg)

If Pergunte(cPerg,.T.)
	oReport := BFATR12A(cPerg)
	oReport:PrintDialog()
EndIf

Return

Static Function BFATR12A(cPerg)

Local oReport
Local oSection1
Local cTitulo1
              
cTitulo1 := ""
If (mv_par13 == 1)
	cTitulo1 := "Bonificação"
Elseif (mv_par13 == 2)
	cTitulo1 := "Promoção"
Elseif (mv_par13 == 3)
	cTitulo1 := "Bonificação por Valor de Pedido"
Endif

oReport:= TReport():New("BFATR012",cTitulo1,cPerg,{|oReport| BFATR12C(oReport)},"Impressão do Relatório de "+cTitulo1)
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 6

oSection1 := TRSection():New(oReport,cTitulo1,{"SC5", "SC6", "SB1", "SA3","ZZQ","ZZR"})  //Tabelas usadas na query

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

//TRCell():New(oSection1,cName         ,cAlias, cTitle        ,cPicture,nSize ,lPixel,bBlock,cAlign  ,lLineBreak,cHeaderAlign,lCellBreak,nColSpace,lAutoSize,nClrBack,nClrFore,lBold)
TRCell():New(oSection1,"EMISSAO"     ,"SC5" , "Emissão"     ,        ,  12  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_PROD"    ,"SB1" , "Cod.Prod"    ,        ,  9   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"DESCRICAO"   ,"SB1" , "Descricão"   ,        ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NUM_PED"     ,"SC6" , "Pedido"      ,        ,  7   ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"QTD_VENDA"   ,"SC6" , "Qtd_Venda"   ,        ,  3   ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"ENTREGA"     ,"SC5" , "Entrega"     ,        ,  10  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_CLI"     ,"SC6" , "Cliente"     ,        ,  9   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"LOJA"        ,"SC6" , "Loja"        ,        ,  3   ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NOME_CLI"    ,"SA1" , "Nome"        ,        ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"REGIAO"      ,"SA1" , "Região"      ,        ,  7   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"GRUPO"       ,"SA1" , "Grupo"       ,        ,  7   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"ESTADO"      ,"SA1" , "UF"          ,        ,  3   ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_VEND"    ,"SC5" , "Vendedor"    ,        ,  7   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NOME_VEND"   ,"SA3" , "NomeVend"    ,        ,  20  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"COD_REGRA"   ,"SC6" , "Regra"       ,        ,  7   ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"VAL_DESC"    ,"SC6" , "Val_Desc"    ,        ,  9   ,.F.   ,      ,"RIGHT" ,  .F.     , "RIGHT"    ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"PERC_DESC"   ,"SC6" , "Perc_Desc"   ,        ,  3   ,.F.   ,      ,"CENTER",  .F.     , "CENTER"   ,          ,   1     ,    .F.  ,        ,        ,     )
TRCell():New(oSection1,"NOME_REGRA"  ,"ZZQ" , "Nome_Regra"  ,        ,  30  ,.F.   ,      ,"LEFT"  ,  .F.     , "LEFT"     ,          ,   1     ,    .F.  ,        ,        ,     )



/*  --Poderia fazer assim para definir as propriedades em cima da Celula:
oSection1:Cell("EMISSAO"):SetSize(9)
oSection1:Cell("BONIFICADO"):SetSize(9)
oSection1:Cell("DESC_PROD"):SetSize(30)
oSection1:Cell("QTD_BONI"):SetSize(3)

oSection1:Cell("EMISSAO"):SetHeaderAlign("LEFT")
oSection1:Cell("BONIFICADO"):SetHeaderAlign("LEFT")

oSection1:Cell("C6_PRODUTO"):SetRowDiff(5)
*/


/*
SetBorder(uBorder,nWeight,nColor,lHeader)   - Define as bordas da célula.
uBorder	Tipo Caracter: "TOP"     ,"BOTTOM"  ,"LEFT"    ,"RIGHT"  ,"ALL"
Tipo Numérico: 1-Superior,2-Inferior,3-Esquerda,4-Direita,5-Todas
nWeight	Largura da borda
nColor	Cor da borda
lHeader	Aponta se é borda de cabeçalho
*/

//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("DESCRICAO" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NUM_PED"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("QTD_VENDA" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("ENTREGA"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("LOJA"      ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NOME_CLI"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("REGIAO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("GRUPO"     ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("ESTADO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_VEND"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NOME_VEND" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("COD_REGRA" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VAL_DESC"  ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("PERC_DESC" ):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("NOME_REGRA"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

//SetBorder(uBorder,nWeight,nColor,lHeader)
oSection1:Cell("EMISSAO"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_PROD"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DESCRICAO" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NUM_PED"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("QTD_VENDA" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("ENTREGA"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_CLI"   ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("LOJA"      ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NOME_CLI"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("REGIAO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("GRUPO"     ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("ESTADO"    ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_VEND"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NOME_VEND" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("COD_REGRA" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VAL_DESC"  ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("PERC_DESC" ):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("NOME_REGRA"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
Return oReport


Static Function BFATR12C(oReport)

Local cAlias := GetNextAlias(), cTipo
Local oSection1 := oReport:Section(1)
                                
cTipo := Space(1)
If (mv_par13 == 1) //Bonificacao
	cTipo := "%1%"
Elseif (mv_par13 == 2) //Promocao
	cTipo := "%2%"
Elseif (mv_par13 == 3) //Bonif.p/Vlr.Ped.
	cTipo := "%3%"
Endif

oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT SUBSTRING(C5_EMISSAO,7,2)+'/'+SUBSTRING(C5_EMISSAO,5,2)+'/'+SUBSTRING(C5_EMISSAO,1,4)EMISSAO,
	C6_PRODUTO COD_PROD,
	B1_DESC DESCRICAO,
	C6_NUM NUM_PED,
	C6_QTDVEN QTD_VENDA,
	SUBSTRING(C6_ENTREG,7,2)+'/'+SUBSTRING(C6_ENTREG,5,2)+'/'+SUBSTRING(C6_ENTREG,1,4)ENTREGA,
	C5_CLIENTE COD_CLI,
	A1_LOJA LOJA,
	A1_NOME NOME_CLI,
	A1_REGIAO REGIAO,
	A1_GRPVEN GRUPO,
	A1_EST ESTADO,
	C5_VEND1 COD_VEND,
	A3_NREDUZ NOME_VEND,
	C6_X_REGRA COD_REGRA,
	C6.C6_VALDESC VAL_DESC,
	C6.C6_DESCONT PERC_DESC,
	ZZQ_DESCRI NOME_REGRA
	FROM %table:SC5% C5, %table:SC6% C6, %table:SB1% B1, %table:SA1% A1, %table:SA3% A3, %table:ZZQ% ZZ
	WHERE C5.%notDel%
	AND C6.%notDel%
	AND A3.%notDel%
	AND C5_NUM = C6_NUM
	AND C5_FILIAL = C6_FILIAL
	AND C5_CLIENTE = C6_CLI
	AND C5_LOJACLI = C6_LOJA
	AND C6_PRODUTO = B1_COD
	AND C5_CLIENTE = A1_COD
	AND C5_LOJACLI = A1_LOJA
	AND C6_CLI = A1_COD
	AND C6_LOJA = A1_LOJA
	AND C5_VEND1 = A3_COD
	AND A1_VEND = A3_COD
	AND C6_X_REGRA = ZZQ_CODREG
	AND ZZQ_TIPO = %exp:cTipo%
	AND C5_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND A1_REGIAO BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND C6_X_REGRA BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%
	AND C5_VEND1 BETWEEN %exp:MV_PAR07% AND %exp:MV_PAR08%
	AND A1_GRPVEN BETWEEN %exp:MV_PAR09% AND %exp:MV_PAR10%
	AND C6_PRODUTO BETWEEN %exp:MV_PAR11% AND %exp:MV_PAR12%
	AND C6_X_REGRA <> ' '
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos


oSection1:EndQuery()
oSection1:Print()

Return

Static Function BFATR12B(cPerg)
//PutSx1(cGrupo,cOrdem,  cPergunt         ,cPerSpa,cPerEng,cVar      ,cTipo,      nTam               ,nDec,nPres,cGSC,cValid,cF3	,cGrpSxg,cPyme,cVar01	  ,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4, cDef05,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg , "01" , "Emissao de"      , ""    , ""    , "mv_ch1" , "D" , TAMSX3("C5_EMISSAO")[1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par01", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "02" , "Emissao ate"     , ""    , ""    , "mv_ch2" , "D" , TAMSX3("C5_EMISSAO")[1] , 0  , 0   , "G", ""   ,      , ""    , ""  , "mv_par02", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "03" , "Região de"       , ""    , ""    , "mv_ch3" , "C" , TAMSX3("A1_REGIAO")[1]  , 0  , 0   , "G", ""   ,"ACA" , ""    , ""  , "mv_par03", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "04" , "Região ate"      , ""    , ""    , "mv_ch4" , "C" , TAMSX3("A1_REGIAO")[1]  , 0  , 0   , "G", ""   ,"ACA" , ""    , ""  , "mv_par04", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "05" , "Regra de"        , ""    , ""    , "mv_ch5" , "C" , TAMSX3("C6_X_REGRA")[1] , 0  , 0   , "G", ""   ,"ACA" , ""    , ""  , "mv_par05", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "06" , "Regra ate"       , ""    , ""    , "mv_ch6" , "C" , TAMSX3("C6_X_REGRA")[1] , 0  , 0   , "G", ""   ,"ACA" , ""    , ""  , "mv_par06", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "07" , "Vendedor de"     , ""    , ""    , "mv_ch7" , "C" , TAMSX3("A3_COD")[1]     , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par07", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "08" , "Vendedor ate"    , ""    , ""    , "mv_ch8" , "C" , TAMSX3("A3_COD")[1]     , 0  , 0   , "G", ""   ,"SA3" , ""    , ""  , "mv_par08", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "09" , "Grupo de"        , ""    , ""    , "mv_ch9" , "C" , TAMSX3("A1_GRPVEN")[1]  , 0  , 0   , "G", ""   ,"ACY" , ""    , ""  , "mv_par09", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "10" , "Grupo ate"       , ""    , ""    , "mv_ch10", "C" , TAMSX3("A1_GRPVEN")[1]  , 0  , 0   , "G", ""   ,"ACY" , ""    , ""  , "mv_par10", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "11" , "Produto de"      , ""    , ""    , "mv_ch11", "C" , TAMSX3("C6_PRODUTO")[1] , 0  , 0   , "G", ""   ,"SB1" , ""    , ""  , "mv_par11", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "12" , "Produto ate"     , ""    , ""    , "mv_ch12", "C" , TAMSX3("C6_PRODUTO")[1] , 0  , 0   , "G", ""   ,"SB1" , ""    , ""  , "mv_par12", ""   ,""      ,""      ,""    ,""     ,""      ,""      ,""    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
PutSX1(cPerg , "13" , "Tipo Campanha"   , ""    , ""    , "mv_ch13", "N" , 1 , 0  , 0   , "C", ""   ,"" , ""    , ""  , "mv_par13", "Bonificacao"   ,""      ,""      ,""    ,"Promocao"     ,""      ,""      ,"Bonif.p/Vlr.Ped."    ,""      ,""      ,""    ,""      ,""      ,""     ,""      ,"")
Return
