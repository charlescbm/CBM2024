#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "JPEG.CH"
      
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥MapaOper  ∫Autor  ≥Thiago (Onsten)     ∫ Data ≥  09/03/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Gera Mapa Operacional para consulta e impress„o             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥Especifico Brascola                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
     
User Function MapaOper()
************************
Public lSaiu       := .f.
Private cCadastro  := "Gera Mapa Operacional para consulta"
Private aHeader	   := {} 
Private aCols      := {}
Private cDelFunc   := ".T." 
Private cString    := "SD2"
Private cPerg      := U_CriaPerg("MAPOPERAC")
Private dDataDe    := CtoD("  /  /  ") 
Private dDataAte   := CtoD("  /  /  ") 
Private aPFolders  := {"M A P A","BLOQ. ESTOQUE","BLOQ. CR…DITO"}
Private nUsado     := 0
Private	nTotal     := 0
Private _cFilial   := ""
Private _cSituacao := ""
Private _cMesAtual := ""
Private _cVencido  := ""
Private _cGeraFat  := ""
Private _cPrinCli  := ""
Private _cFabric   := ""
Private nTotal11   := 0                      
Private nTotal12   := 0
Private nQPedNFat2 := 0                      
Private nVTotNFat2 := 0
Private nQPedNFat3 := 0                      
Private nVTotNFat3 := 0
Private oTotal11 
Private oTotal12 
Private oQPedNFat2 
Private oVTotNFat2 
Private oQPedNFat3 
Private oVTotNFat3 
Private oGetDados 
Private oGetDad2
Private oGetDad3
Private	oTotal1     
Private	oTotal2
Private _oDlg
Private oGetPedAbe
Private _oDlgPA

 
nUsado := 14
aHeader:= {}                                                                     
aAdd(aHeader,{"Produto"          ,"TP_CODIGO"  ,"@!"                 ,10,0,""                           , "", "C","SB1","" } )
aAdd(aHeader,{"DescriÁ„o"        ,"TP_DESCRI"  ,"@!"                 ,30,0,""                           , "", "C",""   ,"" } )
aAdd(aHeader,{"Saldo PV"         ,"TP_SALDOPV" ,"@E 999,999,999.99"  ,14,2,"U_AtuPVEst(1,M->TP_SALDOPV)", "", "N",""   ,"" } )
aAdd(aHeader,{"Saldo Vlr"        ,"TP_SALDOVL" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Qtde Ped."        ,"TP_QTDEPED" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"PV c/ Estoque"    ,"TP_PVESTOQ" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Estoque Dispon"   ,"TP_ESTDISP" ,"@E 999,999,999.99"  ,14,2,"U_AtuPVEst(2,M->TP_ESTDISP)", "", "N",""   ,"" } )
aAdd(aHeader,{"Estq Disp Vl"     ,"TP_ESTDI40" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Ordem ProduÁ„o"   ,"TP_ORDPROD" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Ordem Valoriz."   ,"TP_ORDVALO" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Maior Fat."       ,"TP_MAIORFT" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Media Fat."       ,"TP_MEDIAFT" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Fat.Mes Atual"    ,"TP_FATMESA" ,"@E 999,999,999.99"  ,14,2,""                           , "", "N",""   ,"" } )
aAdd(aHeader,{"Curva ABC"        ,"TP_CURVABC" ,"@!"                 ,09,0,""                           , "", "C",""   ,"" } )

aHeader2:= {}                                                                     
aAdd(aHeader2,{"Pedido"          ,"TP_20A"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader2,{"Representante"   ,"TP_20B"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader2,{"Cliente"         ,"TP_20C"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader2,{"Produto"         ,"TP_20D"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader2,{"Quantidade"      ,"TP_20E"     ,"@E 999,999,999.99"  ,14,2,""                           , "", "N","   ","" } )
aAdd(aHeader2,{"Valor"           ,"TP_20F"     ,"@E 999,999,999.99"  ,14,2,""                           , "", "N","   ","" } )
aAdd(aHeader2,{"SituaÁ„o"        ,"TP_20G"     ,"@!"                 ,20,0,""                           , "", "C","   ","" } )
aAdd(aHeader2,{"Entrega"         ,"TP_20H"     ,"@!"                 ,08,0,""                           , "", "D","   ","" } )
aAdd(aHeader2,{"Atraso"          ,"TP_20I"     ,"@E 999,999,999"     ,10,0,""                           , "", "N","   ","" } )

aHeader3:= {}                                                                     
aAdd(aHeader3,{"Pedido"          ,"TP_30A"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader3,{"Representante"   ,"TP_30B"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader3,{"Cliente"         ,"TP_30C"     ,"@!"                 ,10,0,""                           , "", "C","   ","" } )
aAdd(aHeader3,{"Entrega"         ,"TP_30D"     ,"@!"                 ,08,0,""                           , "", "D","   ","" } )
aAdd(aHeader3,{"Total"           ,"TP_30E"     ,"@E 999,999,999.99"  ,14,2,""                           , "", "N","   ","" } )
aAdd(aHeader3,{"Atraso"          ,"TP_30F"     ,"@E 999,999,999"     ,10,0,""                           , "", "N","   ","" } )
aAdd(aHeader3,{"Obs.An·lise Fin.","TP_30G"     ,"@!"                 ,30,0,""                           , "", "C","   ","" } )
aAdd(aHeader3,{"Alerta Adm.Canc.","TP_30H"     ,"@!"                 ,30,0,""                           , "", "C","   ","" } )
  

_aFilial  := {"Tudo","Matriz-SBC","Novo Hamburgo","Franca","Joinville"}  //k
_aSituacao:= {"Tudo","Liberado","B - Blq Fin","P - Em Aberto","C - Blq Reg Coml","R - Residuo"} 
_aMesAtual:= {"Tudo","Mes Atual","Futuro"} //k
_aVencido := {"Tudo","Vencidos","Nao Vencidos"}
_aGeraFat := {"Tudo","Sim","N„o"} //k
_aPrinCli := {"Tudo","Martins"}   //k
_aFabric  := {"Tudo","Sim","N„o"}
_cFilial  := _aFilial[1]
_cSituacao:= _aSituacao[1]
_cMesAtual:= _aMesAtual[1]
_cVencido := _aVencido[1]
_cGeraFat := _aGeraFat[1]
_cPrinCli := _aPrinCli[1]
_cFabric  := _aFabric[1]

ValPergunte(cPerg)    //valida pergunta

Pergunte(cPerg ,.f.)  //carrega pergunta 
 
lSaiu:= .f.

While !lSaiu
	aCols     := {}
 	aCols2    := {}
	aCols3    := {}
	aMatOk    := {} //"TP_SALDOPV","TP_SALDOVL","TP_QTDEPED","TP_PVESTOQ","TP_ESTDISP","TP_ESTDI40","TP_ORDPROD","TP_ORDVALO","TP_MAIORFT","TP_MEDIAFT","TP_FATMESA"}
	aMatOk2   := {}	
	aMatOk3   := {}	  
	
	Define MsDialog _oDlg Title "Mapa Operacional" From C(001),C(001) To C(428),C(600)                        Pixel
	Define FONT oFnt  NAME "Arial"  Size 05,14      //5,15
	Define FONT oFnt2 NAME "Tahoma" Size 08,15 BOLD 
	  
	oPFolders:= TFolder():New(C(065),C(002),aPFolders,{},_oDlg,,,,.T.,.F.,C(297),C(130),)
	oPFolders:aDialogs[1]:oFont := _oDlg:oFont
	oPFolders:aDialogs[2]:oFont := _oDlg:oFont
	oPFolders:aDialogs[3]:oFont := _oDlg:oFont

	@ C(002),C(002) Jpeg File "\\server_erp\Protheus\Protheus_Data\SystemProducao\lgrl02.bmp"  Size C(060),C(010) Pixel NOBORDER   Of _oDlg
	@ C(014),C(003) To C(061),C(220) LABEL " Filtros "                                                        Pixel            Of _oDlg

	@ C(021),C(015) Say "Filial:"                         Size C(035),C(007) COLOR CLR_BLACK                  Pixel            Of _oDlg
	@ C(031),C(015) Say "Mes Atual:"                      Size C(035),C(007) COLOR CLR_BLACK                  Pixel            Of _oDlg
	@ C(041),C(015) Say "Vencido:"                        Size C(035),C(007) COLOR CLR_BLACK                  Pixel            Of _oDlg
	@ C(021),C(130) Say "Gera Faturamento:"               Size C(035),C(007) COLOR CLR_BLACK                  Pixel            Of _oDlg
	@ C(031),C(130) Say "Princ. Clientes:"                Size C(035),C(007) COLOR CLR_BLACK                  Pixel            Of _oDlg
	@ C(041),C(130) Say "Fabricado:"                      Size C(035),C(007) COLOR CLR_BLACK                  Pixel            Of _oDlg
	@ C(020),C(050) ComboBox _cFilial   Items _aFilial    Size C(045),C(007)                                  Pixel            Of _oDlg
	@ C(030),C(050) ComboBox _cMesAtual Items _aMesAtual  Size C(045),C(007)                                  Pixel            Of _oDlg
	@ C(040),C(050) ComboBox _cVencido  Items _aVencido   Size C(045),C(007)                                  Pixel            Of _oDlg
	@ C(020),C(170) ComboBox _cGeraFat  Items _aGeraFat   Size C(045),C(007)                                  Pixel            Of _oDlg
	@ C(030),C(170) ComboBox _cPrinCli  Items _aPrinCli   Size C(045),C(007)                                  Pixel            Of _oDlg
	@ C(040),C(170) ComboBox _cFabric   Items _aFabric    Size C(045),C(007)                                  Pixel            Of _oDlg
	@ C(050),C(170) Button "&Mais par‚metros..."          Size C(044),C(009) Action(Pergunte(cPerg,.t.))      Pixel            Of _oDlg
	@ C(031),C(236) Button "&Gera Consulta"               Size C(050),C(015) Action(GeraCons())               Pixel            Of _oDlg
      
	// Pasta 'Mapa'
	@ C(3.5),C(003) Say "Total Saldo VLR: "               Size C(085),C(007) COLOR CLR_BLACK                  Pixel            Of oPFolders:aDialogs[1] 
	@ C(3.5),C(130) Say "Total PV c/ Estq:"               Size C(085),C(007) COLOR CLR_BLACK                  Pixel            Of oPFolders:aDialogs[1] 
	@ C(3.5),C(040) Say oTotal11  Var nTotal11            Size C(045),C(007) COLOR CLR_BLACK                  Pixel            Of oPFolders:aDialogs[1]  Picture "@E 999,999,999"  FONT oFnt2
	@ C(3.5),C(168) Say oTotal12  Var nTotal12            Size C(045),C(007) COLOR CLR_BLACK                  Pixel            Of oPFolders:aDialogs[1]  Picture "@E 999,999,999"  FONT oFnt2
//	@ C(006),C(040) MsGet oTotal11  Var nTotal11          Size C(045),C(007) COLOR CLR_BLACK                  Pixel When .f.   Of oPFolders:aDialogs[1]  Picture "@E 999,999,999" 
//	@ C(006),C(168) MsGet oTotal12  Var nTotal12          Size C(045),C(007) COLOR CLR_BLACK                  Pixel When .f.   Of oPFolders:aDialogs[1]  Picture "@E 999,999,999" 
	oGetDados:= MsNewGetDados():New(C(012), C(003), C(100), C(295), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "",  aMatOk, 1, 9999, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", oPFolders:aDialogs[1] ,aHeader, aCols)
	@ C(104),C(005) Button "&Pedidos em Aberto"           Size C(040),C(012) Action(PedAber())                Pixel            Of oPFolders:aDialogs[1] 
	@ C(104),C(058) Button "&Ordens de ProduÁ„o"          Size C(040),C(012) Action(OrdProd())                Pixel            Of oPFolders:aDialogs[1] 
	
	//Pasta Bloq.Estoque
	@ C(007),C(005) Say "Qtde de pedidos n„o faturados:"  Size C(085),C(007) COLOR CLR_BLACK                  Pixel            Of oPFolders:aDialogs[2] 
	@ C(007),C(130) Say "Valor total n„o faturado:"       Size C(085),C(007) COLOR CLR_BLACK                  Pixel            Of oPFolders:aDialogs[2] 
	@ C(006),C(067) MsGet oQPedNFat2  Var nQPedNFat2      Size C(030),C(007) COLOR CLR_BLACK                  Pixel When .f.   Of oPFolders:aDialogs[2]  Picture "@E 999,999,999" 
	@ C(006),C(180) MsGet oVTotNFat2  Var nVTotNFat2      Size C(040),C(007) COLOR CLR_BLACK                  Pixel When .f.   Of oPFolders:aDialogs[2]  Picture "@E 999,999,999" 
	oGetDad2:= MsNewGetDados():New(C(018), C(003), C(115), C(295), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "",  aMatOk2, 0, 9999, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", oPFolders:aDialogs[2] ,aHeader2, aCols2)
	                
	//Pasta Bloq.CrÈdito
	@ C(007),C(005) Say "Qtde de pedidos n„o faturados:"  Size C(085),C(007) COLOR CLR_BLACK                 Pixel            Of oPFolders:aDialogs[3] 
	@ C(007),C(130) Say "Valor total n„o faturado:"       Size C(085),C(007) COLOR CLR_BLACK                 Pixel            Of oPFolders:aDialogs[3] 
	@ C(006),C(067) MsGet oQPedNFat3  Var nQPedNFat3      Size C(030),C(007) COLOR CLR_BLACK                 Pixel When .f.   Of oPFolders:aDialogs[3]  Picture "@E 999,999,999" 
	@ C(006),C(180) MsGet oVTotNFat3  Var nVTotNFat3      Size C(040),C(007) COLOR CLR_BLACK                 Pixel When .f.   Of oPFolders:aDialogs[3]  Picture "@E 999,999,999" 
	oGetDad3:= MsNewGetDados():New(C(018), C(003), C(115), C(295), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "",  aMatOk3, 0, 9999, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", oPFolders:aDialogs[3] ,aHeader3, aCols3)

	Define SButton From C(200),C(245) Type 6 Action (ImprMapa())             Enable                          Pixel            Of _oDlg 
	Define SButton From C(200),C(275) Type 2 Action (SaiTela() ,_oDlg:End()) Enable                          Pixel            Of _oDlg 
	Activate MsDialog _oDlg Centered 

EndDo
	
Return
 
                                                                                                                 

Static Function GeraCons()
**************************
Processa({ || ConsMapa()}, "Aguarde... ",,.F.)
                        
Return
 
    

Static Function ConsMapa()
**************************
Local _lRet  := .t.
Local _cQuery:= ""
Local _cCFOP := ""
Local _cProdAux:= ""

If SubStr(_cMesAtual,1,1)=="T"  
	dDataDe   := FirstDay(dDataBase)   
	dDataAte  := StoD(SubStr(DtoS(dDataBase),1,4)+"1231")
ElseIf SubStr(_cMesAtual,1,1)=="M"  //Mes Atual
	dDataDe   := FirstDay(dDataBase)   
	dDataAte  := dDataBase 
ElseIf SubStr(_cMesAtual,1,1)=="F"  //Futuro
	dDataDe   := dDataBase   
	dDataAte  := StoD(SubStr(DtoS(dDataBase),1,4)+"1231")
EndIf

nTotal11   := 0                      
nTotal12   := 0
nQPedNFat2 := 0                      
nVTotNFat2 := 0
nQPedNFat3 := 0                      
nVTotNFat3 := 0
                       
cSituAux   := mv_par01  // TLBCAR


_cQuery := "SELECT CODPROD," 
_cQuery += "       SUM(TOTPEDABE)  AS TOTPEDABE, "
_cQuery += "       SUM(QTDPEDABE)  AS QTDPEDABE, "
_cQuery += "       SUM(QTDPEDIDO)  AS QTDPEDIDO, "
_cQuery += "       SUM(SLD_ATU)    AS SLD_ATU,   "
_cQuery += "       SUM(SLD_ATU40)  AS SLD_ATU40, "
_cQuery += "       SUM(VAL_ATU)    AS VAL_ATU,   "
_cQuery += "       SUM(PROGR)      AS PROGR,     "
_cQuery += "       SUM(REPORTA)    AS REPORTA,   "
_cQuery += "       SUM(MAX_FAT)    AS MAX_FAT,   "
_cQuery += "       SUM(QTD_FAT)    AS QTD_FAT,   "
_cQuery += "       SUM(BRUT_FAT)   AS BRUT_FAT,  "
_cQuery += "       SUM(QTD_TOT)    AS QTD_TOT    " 
_cQuery += "FROM (  "

//PED_ABERTO:
_cQuery += "SELECT C6_PRODUTO AS CODPROD,      "
_cQuery += "       SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) AS TOTPEDABE, "
_cQuery += "       SUM((C6_QTDVEN-C6_QTDENT)) AS QTDPEDABE, "
_cQuery += "       COUNT(C6_NUM) AS QTDPEDIDO, "
_cQuery += "       0 AS SLD_ATU,   "
_cQuery += "       0 AS SLD_ATU40, "
_cQuery += "       0 AS VAL_ATU,   "
_cQuery += "       0 AS PROGR,     "
_cQuery += "       0 AS REPORTA,   "
_cQuery += "       0 AS MAX_FAT,   "
_cQuery += "       0 AS QTD_FAT,   "
_cQuery += "       0 AS BRUT_FAT,  "
_cQuery += "       0 AS QTD_TOT    "
_cQuery += "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
_cQuery += "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' " 
If SubStr(AllTrim(_cFilial),1,1)<>"T"  //Filtra filial
	If SubStr(AllTrim(_cFilial),1,1)=="M"
		cFilialAx:= "01"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="N"
		cFilialAx:= "02"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="F"
		cFilialAx:= "03"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="J"
		cFilialAx:= "04"
	EndIf
	
	_cQuery += "  AND C5_FILIAL = '"+cFilialAx+"' " 
EndIf

_cQuery += "  AND C5_FILIAL=C6_FILIAL    " 
_cQuery += "  AND C5_NUM=C6_NUM          " 
_cQuery += "  AND C5_CLIENTE=A1_COD      " 
_cQuery += "  AND C5_LOJACLI=A1_LOJA     " 
_cQuery += "  AND C5_VEND1=SA3.A3_COD    "     
_cQuery += "  AND (C6_QTDVEN-SC6.C6_QTDENT) > 0"
_cQuery += "  AND C6_PRODUTO BETWEEN '"+MV_PAR06+"' AND '"+ MV_PAR07 + "' "
_cQuery += "  AND C5_CLIENTE BETWEEN '"+MV_PAR02+"' AND '"+ MV_PAR04 + "' "
_cQuery += "  AND C5_LOJACLI BETWEEN '"+MV_PAR03+"' AND '"+ MV_PAR05 + "' "
_cQuery += "  AND C5_TIPO='N'            "
_cQuery += "  AND C6_TES=F4_CODIGO       "

//revendo filtro das situaÁoes.. pois os outros filtros nao estavam funcionando corretamente
If SubStr(cSituAux,1,1)<>"T" 
	If SubStr(cSituAux,2,1)=="L" //Liberados
	EndIf	

	If SubStr(cSituAux,2,1)=="B" //Bloq Financ
	EndIf	

	If SubStr(cSituAux,2,1)=="C" //Bloq Regra Coml
	EndIf	

	If SubStr(cSituAux,2,1)=="A" //Em Aberto
	EndIf	

	If SubStr(cSituAux,2,1)=="R" //Residuo
		_cQuery += " AND C6_BLQ='R' " 	
	Else	
		_cQuery += " AND C6_BLQ<>'R' " 	
	EndIf	
EndIf	
 

If Upper(SubStr(AllTrim(_cGeraFat),1,1))<>"T"  //Filtra filial
	_cQuery += "  AND F4_DUPLIC='"+Upper(SubStr(AllTrim(_cGeraFat),1,1))+"'"
EndIf
_cQuery += "  AND A3_MSBLQL<>'1'   "
_cQuery += "GROUP BY C6_PRODUTO " 

_cQuery += " UNION ALL " 

//SALDO_PROD
_cQuery += "SELECT SB2.B2_COD AS CODPROD,"
_cQuery += "       0 AS TOTPEDABE,       "
_cQuery += "       0 AS QTDPEDABE,       "
_cQuery += "       0 AS QTDPEDIDO,       "
_cQuery += "       SUM(SB2.B2_QATU)  AS SLD_ATU, "
_cQuery += "       SUM(CASE WHEN B2_LOCAL = '40' THEN SB2.B2_QATU ELSE 0 END) AS SLD_ATU40, "
_cQuery += "       SUM(SB2.B2_VATU1)  AS VAL_ATU, "
_cQuery += "       0 AS PROGR,    "
_cQuery += "       0 AS REPORTA,  "
_cQuery += "       0 AS MAX_FAT,  "
_cQuery += "       0 AS QTD_FAT,  "
_cQuery += "       0 AS BRUT_FAT, "
_cQuery += "       0 AS QTD_TOT   "
_cQuery += "FROM SB2020 SB2 , SB1020 SB1 "
_cQuery += "WHERE SB2.D_E_L_E_T_ = '' " 
_cQuery += "  AND SB1.D_E_L_E_T_ = '' "
If SubStr(AllTrim(_cFilial),1,1)<>"T"  //Filtra filial
	If SubStr(AllTrim(_cFilial),1,1)=="M"
		cFilialAx:= "01"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="N"
		cFilialAx:= "02"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="F"
		cFilialAx:= "03"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="J"
		cFilialAx:= "04"
	EndIf
	
	_cQuery += "  AND SB2.B2_FILIAL = '"+cFilialAx+"' " 
EndIf
_cQuery += "  AND SB2.B2_LOCAL = '"+mv_par08+"' "
_cQuery += "  AND SB1.B1_COD = SB2.B2_COD "
_cQuery += "  AND SB1.B1_TIPO = 'PA' "
_cQuery += "  AND SB1.B1_COD BETWEEN '"+MV_PAR06+"' AND '"+ MV_PAR07 + "' "
_cQuery += "GROUP BY SB2.B2_COD "

_cQuery += " UNION ALL " 
//ORD_PRODUCAO
_cQuery += "SELECT SC2.C2_PRODUTO AS CODPROD, "
_cQuery += "       0 AS TOTPEDABE, "
_cQuery += "       0 AS QTDPEDABE, "
_cQuery += "       0 AS QTDPEDIDO, "
_cQuery += "       0 AS SLD_ATU,   "
_cQuery += "       0 AS SLD_ATU40, "
_cQuery += "       0 AS VAL_ATU,   "
_cQuery += "       SUM(SC2.C2_QUANT) AS PROGR, "
//_cQuery += "       SUM(SD3.D3_QUANT) AS REPORTA, "
_cQuery += "       ISNULL(SUM(SC2.C2_QUANT*SB2.B2_CM1),0) AS REPORTA, "
_cQuery += "       0 AS MAX_FAT,   "
_cQuery += "       0 AS QTD_FAT,   "
_cQuery += "       0 AS BRUT_FAT,  "
_cQuery += "       0 AS QTD_TOT    "
_cQuery += " FROM "+ RETSQLNAME("SC2") + " SC2 "
_cQuery += "   INNER JOIN "+ RETSQLNAME("SB1") + " SB1 ON SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SC2.C2_PRODUTO"
_cQuery += "   INNER JOIN "+ RETSQLNAME("SBM") + " SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ''"
//_cQuery += "   LEFT  JOIN "+ RETSQLNAME("SD3") + " SD3 ON SD3.D_E_L_E_T_ = '' AND SD3.D3_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AND SD3.D3_COD = SC2.C2_PRODUTO "
_cQuery += "   LEFT  JOIN "+ RETSQLNAME("SB2") + " SB2 ON SB2.D_E_L_E_T_ = '' AND SB2.B2_FILIAL = SC2.C2_FILIAL AND SB2.B2_COD = SC2.C2_PRODUTO AND SB2.B2_LOCAL = SC2.C2_LOCAL "
_cQuery += " WHERE SC2.D_E_L_E_T_ = '' "      
_cQuery += "   AND C2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
_cQuery += "   AND C2_PRODUTO BETWEEN '"+MV_PAR06+"' AND '"+ MV_PAR07 + "' "
_cQuery += " GROUP BY SC2.C2_PRODUTO "

_cQuery += " UNION ALL " 
 
//FATURAMENTO POR PROD
_cQuery += "SELECT SD2.D2_COD AS CODPROD, "
_cQuery += "       0 AS TOTPEDABE, "
_cQuery += "       0 AS QTDPEDABE, "
_cQuery += "       0 AS QTDPEDIDO, "
_cQuery += "       0 AS SLD_ATU,   "
_cQuery += "       0 AS SLD_ATU40, "
_cQuery += "       0 AS VAL_ATU,   "
_cQuery += "       0 AS PROGR,     "
_cQuery += "       0 AS REPORTA,   "
_cQuery += "       0 AS MAX_FAT,   "
_cQuery += "       SUM(D2_QUANT) AS QTD_FAT, "
_cQuery += "       SUM(D2_VALBRUT) AS BRUT_FAT, "
_cQuery += "       SUM(D2_TOTAL) AS QTD_TOT "
_cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SF4")+" SF4"
_cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
_cQuery += "   AND SD2.D2_COD BETWEEN '"+MV_PAR06+"' AND '"+ MV_PAR07 + "' "
_cQuery += "   AND SD2.D2_TIPO NOT IN ('D','B')"
_cQuery += "   AND SD2.D_E_L_E_T_ = ' ' "
If SubStr(AllTrim(_cFilial),1,1)<>"T"  //Filtra filial
	If SubStr(AllTrim(_cFilial),1,1)=="M"
		cFilialAx:= "01"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="N"
		cFilialAx:= "02"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="F"
		cFilialAx:= "03"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="J"
		cFilialAx:= "04"
	EndIf

	_cQuery += "   AND SD2.D2_FILIAL = '"+cFilialAx+"' " 
EndIf
If SubStr(AllTrim(_cPrinCli),1,1)<>"T"
	_cQuery += "  AND F2_CLIENTE IN ('000588','053568','065130','110033','110932','111256') "  //MARTINS
EndIf	
_cQuery += "   AND SF2.F2_CLIENTE BETWEEN '"+MV_PAR02+"' AND '"+ MV_PAR04 + "' "
_cQuery += "   AND SF2.F2_LOJA BETWEEN '"+MV_PAR03+"' AND '"+ MV_PAR05 + "' "
_cQuery += "   AND SF2.F2_FILIAL = SD2.D2_FILIAL "
_cQuery += "   AND SF2.F2_DOC = SD2.D2_DOC       "
_cQuery += "   AND SF2.F2_SERIE = SD2.D2_SERIE   "
_cQuery += "   AND SF2.D_E_L_E_T_ = ' '          "
_cQuery += "   AND SD2.D2_TP = 'PA'              "
_cQuery += "   AND SB1.B1_COD = SD2.D2_COD       "
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '          "
_cQuery += "   AND SBM.BM_GRUPO = SB1.B1_GRUPO   "
_cQuery += "   AND SBM.D_E_L_E_T_ = ' '          "
_cQuery += "   AND SF4.F4_CODIGO = SD2.D2_TES    "
If Upper(SubStr(AllTrim(_cGeraFat),1,1))<>"T"  //Filtra filial
	_cQuery += "  AND F4_DUPLIC='"+Upper(SubStr(AllTrim(_cGeraFat),1,1))+"'"
EndIf
_cQuery += "   AND SF4.D_E_L_E_T_ = ' '"
_cQuery += " GROUP BY SD2.D2_COD "

_cQuery += " UNION ALL " 
  
// MAIOR FATURAMENTO POR PROD
_cQuery += "SELECT SD2.D2_COD AS CODPROD,"
_cQuery += "       0 AS TOTPEDABE,       "
_cQuery += "       0 AS QTDPEDABE,       "
_cQuery += "       0 AS QTDPEDIDO,       "
_cQuery += "       0 AS SLD_ATU,         "
_cQuery += "       0 AS SLD_ATU40,       "
_cQuery += "       0 AS VAL_ATU,         "
_cQuery += "       0 AS PROGR,           "
_cQuery += "       0 AS REPORTA,         "
_cQuery += "       MAX(D2_VALBRUT) AS MAX_FAT, "
_cQuery += "       0 AS QTD_FAT,  "
_cQuery += "       0 AS BRUT_FAT, "
_cQuery += "       0 AS QTD_TOT   "
_cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBM")+" SBM, "+RetSqlName("SF4")+" SF4"
_cQuery += " WHERE SD2.D2_EMISSAO BETWEEN '" + SubStr(DtoS(dDataDe),1,4)+"0101" + "' AND '" + DtoS(dDataAte)+ "' "  //inicio do ano ateh data hj
_cQuery += "   AND SD2.D2_COD BETWEEN '"+MV_PAR06+"' AND '"+ MV_PAR07 + "' "
_cQuery += "   AND SD2.D2_TIPO NOT IN ('D','B')"
_cQuery += "   AND SD2.D_E_L_E_T_ = ' ' "
If SubStr(AllTrim(_cFilial),1,1)<>"T"  //Filtra filial
	If SubStr(AllTrim(_cFilial),1,1)=="M"
		cFilialAx:= "01"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="N"
		cFilialAx:= "02"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="F"
		cFilialAx:= "03"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="J"              
		cFilialAx:= "04"
	EndIf
     
	_cQuery += "   AND SD2.D2_FILIAL = '"+cFilialAx+"' " 
EndIf
If SubStr(AllTrim(_cPrinCli),1,1)<>"T"
	_cQuery += "  AND F2_CLIENTE IN ('000588','053568','065130','110033','110932','111256') "  //MARTINS
EndIf	
_cQuery += "   AND SF2.F2_CLIENTE BETWEEN '"+MV_PAR02+"' AND '"+ MV_PAR04 + "' "
_cQuery += "   AND SF2.F2_LOJA BETWEEN '"+MV_PAR03+"' AND '"+ MV_PAR05 + "' "
_cQuery += "   AND SF2.F2_FILIAL = SD2.D2_FILIAL "
_cQuery += "   AND SF2.F2_DOC = SD2.D2_DOC       "
_cQuery += "   AND SF2.F2_SERIE = SD2.D2_SERIE   "
_cQuery += "   AND SF2.D_E_L_E_T_ = ' '          "
_cQuery += "   AND SD2.D2_TP = 'PA'              "
_cQuery += "   AND SB1.B1_COD = SD2.D2_COD       "
_cQuery += "   AND SB1.D_E_L_E_T_ = ' '          "
_cQuery += "   AND SBM.BM_GRUPO = SB1.B1_GRUPO   "
_cQuery += "   AND SBM.D_E_L_E_T_ = ' '          "
_cQuery += "   AND SF4.F4_CODIGO = SD2.D2_TES    "
_cQuery += "   AND F4_DUPLIC='S'                 "
_cQuery += "   AND SF4.D_E_L_E_T_ = ' '          "
_cQuery += " GROUP BY SD2.D2_COD                 "

_cQuery += " ) AGRUPA " 

_cQuery += "GROUP BY CODPROD  "
_cQuery += "ORDER BY TOTPEDABE DESC , CODPROD  "

TCQUERY _cQuery NEW ALIAS "TRB"
 


//PEDIDOS  B L O Q U E A D O S

_cQuery := "SELECT C9_PEDIDO, "
_cQuery += "       C5_VEND1,  "
_cQuery += "       C9_CLIENTE," 
_cQuery += "       C9_LOJA,   "
_cQuery += "       C9_PRODUTO," 
_cQuery += "       C9_ENTREG, "
_cQuery += "       SUM( (CASE WHEN NOT(C9_BLEST='  ' AND C9_BLEST<>'10') THEN C9_QTDLIB ELSE 0 END) ) AS 'EST_QTDE',                                   "
_cQuery += "       SUM( (CASE WHEN NOT(C9_BLEST='  ' AND C9_BLEST<>'10') THEN C9_PRCVEN*C9_QTDLIB ELSE 0 END) ) AS 'EST_VALOR',                        "
_cQuery += "       SUM( (CASE WHEN NOT(C9_BLCRED='  ' AND C9_BLCRED<>'09' AND C9_BLCRED<>'10') THEN C9_QTDLIB ELSE 0 END) ) AS 'CRED_QTDE',            "
_cQuery += "       SUM( (CASE WHEN NOT(C9_BLCRED='  ' AND C9_BLCRED<>'09' AND C9_BLCRED<>'10') THEN C9_PRCVEN*C9_QTDLIB ELSE 0 END) ) AS 'CRED_VALOR'  "
_cQuery += "FROM SC9020 SC9, SC5020 SC5          "
_cQuery += "WHERE SC9.D_E_L_E_T_ = ''            "
_cQuery += "  AND SC9.C9_FILIAL=SC5.C5_FILIAL    "
_cQuery += "  AND SC9.C9_PEDIDO=SC5.C5_NUM       "
_cQuery += "  AND SC9.C9_CLIENTE=SC5.C5_CLIENTE  "
_cQuery += "  AND SC9.C9_LOJA=SC5.C5_LOJACLI     "
_cQuery += "  AND SC9.C9_CLIENTE BETWEEN '"+MV_PAR02+"' AND '"+ MV_PAR04 + "' "
_cQuery += "  AND SC9.C9_LOJA BETWEEN '"+MV_PAR03+"' AND '"+ MV_PAR05 + "' "
_cQuery += "  AND SC5.C5_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
//_cQuery += "  AND SC9.C9_DATALIB BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
_cQuery += "  AND SC5.D_E_L_E_T_ = ''  "
If SubStr(AllTrim(_cFilial),1,1)<>"T"  //Filtra filial
	If SubStr(AllTrim(_cFilial),1,1)=="M"
		cFilialAx:= "01"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="N"
		cFilialAx:= "02"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="F"
		cFilialAx:= "03"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="J"
		cFilialAx:= "04"
	EndIf
	_cQuery += "  AND C9_FILIAL = '"+cFilialAx+"' " 
EndIf
If SubStr(AllTrim(_cPrinCli),1,1)<>"T"
	_cQuery += "  AND C9_CLIENTE IN ('000588','053568','065130','110033','110932','111256') "  //MARTINS
EndIf	
_cQuery += "GROUP BY C9_PEDIDO, C5_VEND1, C9_CLIENTE, C9_LOJA, C9_PRODUTO, C9_ENTREG "
_cQuery += "ORDER BY C9_ENTREG "

TCQUERY _cQuery NEW ALIAS "TRBLOQ"


DbSelectArea("TRB")
DbGoTop()

ProcRegua(RecCount())

DbGoTop()
  
If !Eof()  
	oGetDados:aCols:= {}
	cDescrAux:= ""

	While !Eof()	
		IncProc("Gerando MAPA...   "+TRB->CODPROD)
		
		cDescrAux:= Posicione("SB1",1,xFilial("SB1")+TRB->CODPROD,"B1_DESC")
        
		If SubStr(cDescrAux,1,1)<>"#"
			aAdd(oGetDados:aCols,{SubStr(TRB->CODPROD,1,10),;                                           // codigo
								  cDescrAux,;                                                           // descriÁao
			 					  TRB->QTDPEDABE ,;                                                     // saldo pv
								  TRB->TOTPEDABE,;				                                        // saldo vlr
								  TRB->QTDPEDIDO,;				                                        // qtde pedido
								  Iif(TRB->SLD_ATU > TRB->QTDPEDABE,TRB->TOTPEDABE,TRB->VAL_ATU) ,; 	// pv com estoque  
								  TRB->SLD_ATU,;				                                        // estoq disponivel  
								  TRB->VAL_ATU,;				                                        // estoq disp arm 40         .
								  TRB->PROGR,;	  			                                            // ordem prod
								  TRB->REPORTA,;				                                        // ordem valorizada
								  TRB->MAX_FAT,;				                                        // maior fat
								  Posicione("SB3",1,xFilial("SB3")+TRB->CODPROD,"B3_MEDIA"),;	        // media fat
		 						  TRB->BRUT_FAT,;				                                        // fat mes atual
					              Space(8)+Iif(!Empty(SB3->B3_CLASSE),SB3->B3_CLASSE,'-'),;             // curva abc
							      .F.})                                                                 // d_e_l_e_t_e_d_

			nTotal11+= TRB->TOTPEDABE                      
			nTotal12+= Iif(TRB->SLD_ATU > TRB->QTDPEDABE,TRB->TOTPEDABE,TRB->VAL_ATU)
		EndIf
		 
		DbSkip()
	EndDo              
	
	oTotal11:Refresh()
	oTotal12:Refresh()

	oGetDados:Refresh()

	oPFolders:aDialogs[1]:Refresh()

Else
    MsgBox("InformaÁıes n„o encontradas! Verifique filtro/par„metros.")
EndIf


//CARREGAR OS BLOQUEADOS POR ESTOQUE E CREDITO

DbSelectArea("TRBLOQ")
DbGoTop()

ProcRegua(RecCount())

DbGoTop()
  
If !Eof()  
	oGetDad2:aCols:={}
	oGetDad3:aCols:={}
	nQPedNFat2:= 0 
	nVTotNFat2:= 0
	nQPedNFat3:= 0 
	nVTotNFat3:= 0

	While !Eof()	
		If TRBLOQ->EST_QTDE<>0 

		    IncProc("Gerando PEDIDOS BLOQUEADOS... ")

			aAdd(oGetDad2:aCols,{TRBLOQ->C9_PEDIDO,; 
								 TRBLOQ->C5_VEND1,;
			 					 TRBLOQ->C9_CLIENTE+'/'+TRBLOQ->C9_LOJA,;
								 TRBLOQ->C9_PRODUTO,;
								 TRBLOQ->EST_QTDE  ,;
								 TRBLOQ->EST_VALOR ,; 
								 "" ,;	//situacao
								 StoD(TRBLOQ->C9_ENTREG) ,;	
								 Iif( StoD(TRBLOQ->C9_ENTREG) >= dDataBase,0 , dDataBase-StoD(TRBLOQ->C9_ENTREG) )  ,;//DIAS EM ATRASO
							      .F.})              // d_e_l_e_t_e_d_
							                                            
			nQPedNFat2++
			nVTotNFat2+= TRBLOQ->EST_VALOR
		EndIf

		If TRBLOQ->CRED_QTDE<>0 

			aAdd(oGetDad3:aCols,{TRBLOQ->C9_PEDIDO,; 
								 TRBLOQ->C5_VEND1,;
			 					 TRBLOQ->C9_CLIENTE+'/'+TRBLOQ->C9_LOJA,;
								 StoD(TRBLOQ->C9_ENTREG) ,;	
								 TRBLOQ->CRED_VALOR ,; 
								 Iif( StoD(TRBLOQ->C9_ENTREG) >= dDataBase,0 , dDataBase-StoD(TRBLOQ->C9_ENTREG) )  ,;              //DIAS EM ATRASO
								  "" ,;	//obs analise financeira
								  "" ,;	//alerta adm canc.
							      .F.})              // d_e_l_e_t_e_d_
		
			nQPedNFat3++
			nVTotNFat3+= TRBLOQ->CRED_VALOR
		EndIf
		
		
		
		DbSkip()
	EndDo
	
Else
    MsgBox("InformaÁıes n„o encontradas! Verifique filtro/par„metros.")
EndIf


oQPedNFat2:Refresh()
oVTotNFat2:Refresh()
    
oQPedNFat3:Refresh()
oVTotNFat3:Refresh()

oGetDad2:Refresh()
oPFolders:aDialogs[2]:Refresh()

oGetDad3:Refresh()
oPFolders:aDialogs[3]:Refresh()

DbSelectArea("TRB")
DbCloseArea()

DbSelectArea("TRBLOQ")
DbCloseArea()

 
Return 
 


User Function AtuPVEst(nModeAux,nValAux)
****************************************

If nModeAux==1     //foi ativado pelo 'Saldo PV'
	oGetDados:aCols[n][6] :=  Iif(oGetDados:aCols[n][7] > nValAux, oGetDados:aCols[n][4], oGetDados:aCols[n][8]) // atualiza pv com estoque  
	
ElseIf nModeAux==2 //foi ativado pelo 'Estoq.Disponivel'
	oGetDados:aCols[n][6] :=  Iif(nValAux > oGetDados:aCols[n][3], oGetDados:aCols[n][4], oGetDados:aCols[n][8]) // atualiza pv com estoque  

EndIf

oGetDados:Refresh()


Return .t.


 
Static Function PedAber()
*************************
Local cQuery := ""
Local aHeaderPA:= {} 
Local aCols  := {}
Local nX     := oGetDados:nat
Local cCodAux:= oGetDados:aCols[nX,1]
Local cDesAux:= oGetDados:aCols[nX,2]
Local nPedAbe:= oGetDados:aCols[nX,3]

If nPedAbe <= 0
	MsgAlert("N„o existem pedidos em aberto para esse produto!")
	Return
EndIf	
    
aAdd(aHeaderPA,{"Num.Pedido"     ,"TP_NUMPED"  ,"@!"                 ,06,0,"" , "", "C","   ","" } )
aAdd(aHeaderPA,{"Item"           ,"TP_ITEM"    ,"@!"                 ,04,0,"" , "", "C",""   ,"" } )
aAdd(aHeaderPA,{"Cliente/Loja"   ,"TP_CLIENTE" ,"@!"                 ,09,0,"" , "", "C","   ","" } )
aAdd(aHeaderPA,{"Nome"           ,"TP_NOMECLI" ,"@!"                 ,15,0,"" , "", "C",""   ,"" } )
aAdd(aHeaderPA,{"Qtde Aberto"    ,"TP_QTDEABE" ,"@E 999,999,999.99"  ,14,2,"" , "", "N",""   ,"" } )
aAdd(aHeaderPA,{"Valor Aberto"   ,"TP_VALABE"  ,"@E 999,999,999.99"  ,14,2,"" , "", "N",""   ,"" } )
aAdd(aHeaderPA,{"Emissao"        ,"TP_EMISSA"  ,"@!"                 ,08,0,"" , "", "D",""   ,"" } )
aAdd(aHeaderPA,{"Entrega"        ,"TP_ENTREGA" ,"@!"                 ,08,0,"" , "", "D",""   ,"" } )
aAdd(aHeaderPA,{"Representante"  ,"TP_REPRES"  ,"@!"                 ,15,0,"" , "", "C","   ","" } )
aAdd(aHeaderPA,{"Grupo Cli"      ,"TP_GRUPOC"  ,"@!"                 ,06,0,"" , "", "C",""   ,"" } )

//PED_ABERTO:
cQuery := "SELECT C5_NUM AS NUMPED, "
cQuery += "       C6_ITEM AS ITEM , "
cQuery += "       C6_ENTREG AS ENTREGA, "
cQuery += "       C5_EMISSAO AS EMISSAO, "
cQuery += "       C5_CLIENTE AS CLIENTE, "
cQuery += "       C5_LOJACLI AS LOJA, "
cQuery += "       C5_VEND1 AS REPRES, "
cQuery += "       A1_GRPVEN AS GRUPOVEN, "
cQuery += "       A1_NREDUZ AS NOMECLI, "
cQuery += "       SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) AS TOTPEDABE, "
cQuery += "       SUM((C6_QTDVEN-C6_QTDENT)) AS QTDPEDABE "
cQuery += "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery += "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' " 
If SubStr(AllTrim(_cFilial),1,1)<>"T"  //Filtra filial
	If SubStr(AllTrim(_cFilial),1,1)=="M"
		cFilialAx:= "01"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="N"
		cFilialAx:= "02"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="F"
		cFilialAx:= "03"
	ElseIf SubStr(AllTrim(_cFilial),1,1)=="J"
		cFilialAx:= "04"
	EndIf
	
	cQuery += "  AND C5_FILIAL = '"+cFilialAx+"' " 
EndIf
cQuery += "  AND C5_FILIAL=C6_FILIAL" 
cQuery += "  AND C5_NUM=C6_NUM" 
cQuery += "  AND C5_CLIENTE=A1_COD" 
cQuery += "  AND C5_LOJACLI=A1_LOJA" 
cQuery += "  AND C5_VEND1=SA3.A3_COD"     
cQuery += "  AND C6_QTDVEN>SC6.C6_QTDENT" 
cQuery += "  AND C6_ENTREG BETWEEN '"+DtoS(dDataDe+1)+"' AND '"+DtoS(LastDay(dDataAte)+1)+"'"
cQuery += "  AND C6_PRODUTO = '"+ cCodAux +"' "
cQuery += "  AND C5_TIPO='N'"
cQuery += "  AND C6_BLQ<>'R'" 
cQuery += "  AND C6_TES=F4_CODIGO"
If Upper(SubStr(AllTrim(_cGeraFat),1,1))<>"T"  //Filtra filial
	cQuery += "  AND F4_DUPLIC='"+Upper(SubStr(AllTrim(_cGeraFat),1,1))+"'"
EndIf
cQuery += "  AND A3_MSBLQL<>'1' "
cQuery += "GROUP BY C5_NUM,C6_ITEM,C6_ENTREG,C5_EMISSAO, C5_CLIENTE, C5_LOJACLI, C5_VEND1, A1_GRPVEN, A1_NREDUZ  "
 
cQuery += "ORDER BY 4,1,2 "

TCQUERY cQuery NEW ALIAS "TRBPA"

DbSelectArea("TRBPA")
DbGoTop()

aColsPA:= {}
aMatPOk:= {}


While !Eof()
	aAdd(aColsPA,{TRBPA->NUMPED ,; 
				  TRBPA->ITEM   ,;
				  TRBPA->CLIENTE+"/"+TRBPA->LOJA ,;
				  TRBPA->NOMECLI ,;
				  TRBPA->QTDPEDABE,;
	 			  TRBPA->TOTPEDABE,;
				  StoD(TRBPA->EMISSAO),;
				  StoD(TRBPA->ENTREGA),;
				  Posicione("SA3",1,xFilial("SA3")+TRBPA->REPRES,"A3_NREDUZ") ,;
				  TRBPA->GRUPOVEN ,;
				 .F.}) //d_e_l_e_t_e_d_
	DbSkip()
EndDo              


Define MsDialog _oDlgPA Title "Pedidos em Aberto" From C(001),C(001) To C(335),C(365)               Pixel

@ C(005),C(005) Say "Produto: "+Alltrim(cCodAux)+" - "+cDesAux  Size C(300),C(007) COLOR CLR_HBLUE  Pixel  Of _oDlgPA

oGetPedAbe:= MsNewGetDados():New(C(015), C(003), C(140), C(180), 2, "AllwaysTrue", "AllwaysTrue", "",  aMatPOk, 0, 9999, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", _oDlgPA ,aHeaderPA, aCols)

oGetPedAbe:aCols:= aColsPA
oGetPedAbe:Refresh()

Define SButton From C(147),C(160) Type 1 Action (_oDlgPA:End())				   Enable               Pixel  Of _oDlgPA
Define SButton From C(147),C(130) Type 6 Action (ImprPedAb(cCodAux,cDesAux))   Enable               Pixel  Of _oDlgPA 

Activate MsDialog _oDlgPA Centered 


DbSelectArea("TRBPA")
DbCloseArea()


Return



Static Function ImprPedAb(cCodAux,cDesAux)
******************************************
Local cCadastro	:= "Pedidos em Aberto - Mapa Operacional"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := "Mapa Operacional"
Local cPict     := ""
Local cString   := ""
Private Titulo  := "Pedidos em Aberto - "+Alltrim(cCodAux)
Private nLin    := 99
Private Imprime := .T.
Private aOrd    := {}
Private Cabec1  := "Pedido/Item  C l i e n t e                   Qtde Aberto    Valor Aberto   Emissao   Entrega  Representante    Grupo Cli"
Private Cabec2  := ""
//                  999999/99    999999/99 - XXXXXXXXXXXXXXX  999.999.999,99  999.999.999.99  99/99/99  99/99/99  XXXXXXXXXXXXXXX   XXXXXX 
//                  0         1         2         3         4         5         6         7         8         9        10        11        12        13  
//                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
Private lEnd         := .F. 
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "PEDABEMAP"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PEDABEMAP"
Private aRegs        := {}

wnrel:= SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

Processa({ ||U_ProcPedMapa(cCodAux,cDesAux)}, "Pedidos em Aberto - Mapa Operacional",,.t.)


Return(Nil)


 
User Function ProcPedMapa(cCodAux,cDesAux)
***************************
//Impressao
 
For nZ:= 1 to Len(oGetPedAbe:aCols)
	IncProc("Imprimindo...  "+StrZero(nZ,9))

	If lAbortPrint
		@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	If nLin > 60
		nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

		@ ++nLin, 000 PSay "PRODUTO: "+cCodAux+" - "+cDesAux
		nLin++
	EndIf

	@ ++nLin, 000 PSay  oGetPedAbe:aCols[nZ, 1]+"/"+oGetPedAbe:aCols[nZ, 2]
	@   nLin, 013 PSay  oGetPedAbe:aCols[nZ, 3]+" - "+SubStr(oGetPedAbe:aCols[nZ, 4],1,15)
	@   nLin, 042 PSay  oGetPedAbe:aCols[nZ, 5]               Picture "@E 999,999,999.99"
	@   nLin, 058 PSay  oGetPedAbe:aCols[nZ, 6]               Picture "@E 999,999,999.99"
	@   nLin, 074 PSay  oGetPedAbe:aCols[nZ, 7]
	@   nLin, 084 PSay  oGetPedAbe:aCols[nZ, 8]
	@   nLin, 094 PSay  oGetPedAbe:aCols[nZ, 9]
	@   nLin, 112 PSay  oGetPedAbe:aCols[nZ,10]
Next
 
@ ++nLin, 000 PSay __PrtFatLine()
 

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()


Return




 
Static Function OrdProd()
*************************
Local cQuery := ""
Local aHeaderOP:= {} 
Local aCols  := {}
Local oGetOP
Local _oDlgOP
Local nX     := oGetDados:nat
Local cCodAux:= oGetDados:aCols[nX,1]
Local cDesAux:= oGetDados:aCols[nX,2]
Local nOrdPro:= oGetDados:aCols[nX,9]
 
If nOrdPro <= 0
	MsgAlert("N„o existem ordens de produÁ„o para esse produto!")
	Return
EndIf	

aAdd(aHeaderOP,{"Num.OP"         ,"TP_NUMOP"    ,"@!"                 ,15,0,"" , "", "C","   ","" } )
aAdd(aHeaderOP,{"Emissao"        ,"TP_OPEMISS"  ,"@!"                 ,08,0,"" , "", "D",""   ,"" } )
aAdd(aHeaderOP,{"Programado"     ,"TP_PROGR"    ,"@E 999,999,999.99"  ,14,2,"" , "", "N",""   ,"" } )
aAdd(aHeaderOP,{"Valor"          ,"TP_REPORTA"  ,"@E 999,999,999.99"  ,14,2,"" , "", "N",""   ,"" } )

 
cQuery := "SELECT SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AS NR_OP , "
cQuery += "       SC2.C2_EMISSAO AS EMISSAO ,"
cQuery += "       SC2.C2_OBS , "
cQuery += "       SC2.C2_TPOP AS TIPO ,"
cQuery += "       SUM(SC2.C2_QUANT) AS PROGR, "
cQuery += "       ISNULL(SUM(SC2.C2_QUANT*SB2.B2_CM1),0) AS REPORTA, "
cQuery += "       SC2.C2_DATPRF AS PREV_ENT , "
cQuery += "       SC2.C2_DATRF AS DT_REFIM "
cQuery += " FROM "+ RETSQLNAME("SC2") + " SC2 "
cQuery += "   INNER JOIN "+ RETSQLNAME("SB1") + " SB1 ON SB1.B1_TIPO = 'PA' AND SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SC2.C2_PRODUTO"
cQuery += "   INNER JOIN "+ RETSQLNAME("SBM") + " SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ''"
//cQuery += "   LEFT  JOIN "+ RETSQLNAME("SD3") + " SD3 ON SD3.D_E_L_E_T_ = '' AND SD3.D3_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AND SD3.D3_COD = SC2.C2_PRODUTO "
cQuery += "   LEFT  JOIN "+ RETSQLNAME("SB2") + " SB2 ON SB2.D_E_L_E_T_ = '' AND SB2.B2_FILIAL = SC2.C2_FILIAL AND SB2.B2_COD = SC2.C2_PRODUTO AND SB2.B2_LOCAL = SC2.C2_LOCAL "
cQuery += " WHERE SC2.D_E_L_E_T_ = '' "      
cQuery += "   AND C2_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte)+ "' "
cQuery += "   AND C2_PRODUTO = '"+ cCodAux +"' "
cQuery += " GROUP BY SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN, SC2.C2_OBS , SC2.C2_TPOP, SC2.C2_PRODUTO, SC2.C2_EMISSAO , SC2.C2_DATRF, SC2.C2_DATPRF"
cQuery += " ORDER BY SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN, SC2.C2_EMISSAO"

TCQUERY cQuery NEW ALIAS "TRBOP"

DbSelectArea("TRBOP")
DbGoTop()

aColsOP:= {}
aMatOPOk:= {}
 
While !Eof()
	aAdd(aColsOP,{TRBOP->NR_OP,;
				  StoD(TRBOP->EMISSAO),;
				  TRBOP->PROGR,;
	 			  TRBOP->REPORTA,;
				 .F.}) //d_e_l_e_t_e_d_
	DbSkip()
EndDo              

     
Define MsDialog _oDlgOP Title "Ordens de ProduÁ„o" From C(001),C(001) To C(335),C(365)      Pixel

@ C(005),C(005) Say "Produto: "+Alltrim(cCodAux)+" - "+cDesAux  Size C(300),C(007) COLOR CLR_HBLUE  Pixel  Of _oDlgOP

oGetOP:= MsNewGetDados():New(C(015), C(003), C(140), C(180), 2, "AllwaysTrue", "AllwaysTrue", "",  aMatOPOk, 0, 9999, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", _oDlgOP ,aHeaderOP, aCols)

oGetOP:aCols:= aColsOP
oGetOP:Refresh()

Define SButton From C(147),C(160) Type 1 Action (_oDlgOP:End()) Enable                     Pixel  Of _oDlgOP

Activate MsDialog _oDlgOP Centered 


DbSelectArea("TRBOP")
DbCloseArea()

Return


 
Static Function ImprMapa()
**************************
Local cCadastro	:= "Mapa Operacional"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := "Mapa Operacional"
Local cPict     := ""
Local cString   := ""
Private Titulo  := "Mapa Operacional"
Private nLin    := 99
Private Imprime := .T.
Private aOrd    := {}
Private Cabec1  := "Produto     DescriÁ„o                                 Saldo PV      Saldo Vlr      Qtde Ped.   PV c/ Estoq.        Estoque      Estq Disp          Ordem      Ord.Prod.     Maior Fat.     Media Fat.        Fat.Mes  Curva"
Private Cabec2  := "                                                                                                                Disponivel          40          ProduÁ„o       Valoriz.                                        Atual   ABC "
//                  9999999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999.999.999,99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99 999.999.999.99    X
//                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Private lEnd         := .F. 
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "MAPAOPER"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "MAPAOPER"
Private aRegs        := {}

wnrel:= SetPrint(cString,wnrel,"",Titulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

Processa({ ||U_ProcMapaOp()}, "Mapa Operacional",,.t.)


Return(Nil)


 
User Function ProcMapaOp()
**************************
//Impressao

For nZ:= 1 to Len(oGetDados:aCols)
	IncProc("Imprimindo...  "+StrZero(nZ,9))

	If lAbortPrint
		@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	If nLin > 60
		nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	
	@ ++nLin, 000 PSay  SubStr(oGetDados:aCols[nZ, 1],1,10)
	@   nLin, 012 PSay  SubStr(oGetDados:aCols[nZ, 2],1,35)
	@   nLin, 048 PSay  oGetDados:aCols[nZ, 3]               Picture "@E 999,999,999.99"
	@   nLin, 063 PSay  oGetDados:aCols[nZ, 4]               Picture "@E 999,999,999.99"
	@   nLin, 078 PSay  oGetDados:aCols[nZ, 5]               Picture "@E 999,999,999.99"
	@   nLin, 093 PSay  oGetDados:aCols[nZ, 6]               Picture "@E 999,999,999.99"
	@   nLin, 108 PSay  oGetDados:aCols[nZ, 7]               Picture "@E 999,999,999.99"
	@   nLin, 123 PSay  oGetDados:aCols[nZ, 8]               Picture "@E 999,999,999.99"
	@   nLin, 138 PSay  oGetDados:aCols[nZ, 9]               Picture "@E 999,999,999.99"
	@   nLin, 153 PSay  oGetDados:aCols[nZ,10]               Picture "@E 999,999,999.99"
	@   nLin, 168 PSay  oGetDados:aCols[nZ,11]               Picture "@E 999,999,999.99"
	@   nLin, 183 PSay  oGetDados:aCols[nZ,12]               Picture "@E 999,999,999.99"
	@   nLin, 198 PSay  oGetDados:aCols[nZ,13]               Picture "@E 999,999,999.99"
	@   nLin, 216 PSay  AllTrim(oGetDados:aCols[nZ,14])      Picture "@!"
Next
 
@ ++nLin, 000 PSay __PrtFatLine()
 

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()

  
Return


 
Static Function SaiTela()
*************************
lSaiu:=.t.

Return.t.






User Function fParMapa()
************************
Local MvPar
Local cTitulo:=""
Local MvParDef:=""
Local lTipoRet:= .T.
Private aSit:={}

l1Elem := .F.  //Iif(l1Elem = Nil , .F. , .T.)

Default lTipoRet := .T.

cAlias := Alias() 					 // Salva Alias Anterior

If lTipoRet
	MvPar:=&(Alltrim(ReadVar()))	 // Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())		 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIf

cTitulo := "SituaÁıes - Mapa"

aSit:= {"T - Tudo",;
		"L - Liberado",;
		"B - Blq Fin",;
		"C - Blq Reg Coml",;
		"A - Em Aberto",;
		"R - Residuo"}  
		
MvParDef:="TLBCAR"


If lTipoRet
	If f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem)  // Chama funcao f_Opcoes
		&MvRet := mvpar                                     // Devolve Resultado
	EndIf	
EndIf

dbSelectArea(cAlias) 		   						        // Retorna Alias

Return( If( lTipoRet , .T. , MvParDef ) )



/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Programa   ≥   C()   ≥ Autores ≥ Norbert/Ernani/Mansano ≥ Data ≥10/05/2005≥±±
±±√ƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥Descricao  ≥ Funcao responsavel por manter o Layout independente da       ≥±±
±±≥           ≥ resolucao horizontal do Monitor do Usuario.                  ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/

Static Function C(nTam)                                                         
***********************
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
	nTam *= 0.8                                                                
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
	nTam *= 1                                                                  
Else	// Resolucao 1024x768 e acima                                           
	nTam *= 1.28                                                               
EndIf                                                                         
                                                                                 
//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø                                               
//≥Tratamento para tema "Flat"≥                                               
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ                                               
If "MP8" $ oApp:cVersion                                                      
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
		nTam *= 0.90                                                            
	EndIf                                                                      
EndIf                                                                         

Return Int(nTam)
   


Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
//          Grupo/Ordem/Pergunta BRA/SPA/USA            Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid        /Var01     /Def01               /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03              /Cnt03/Var04/Def04             /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture /IDFIL
aAdd(aRegs,{cPerg,"01" ,"SituaÁıes? "            ,"","","mv_ch1","C" ,6      ,0      ,0     ,"G","U_fParMapa" ,"mv_par01",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"02" ,"Cliente De? "           ,"","","mv_ch2","C" ,6      ,0      ,0     ,"G",""           ,"mv_par02",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,"SA1",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"03" ,"Loja De?"               ,"","","mv_ch3","C" ,2      ,0      ,0     ,"G",""           ,"mv_par03",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,"   ",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"04" ,"Cliente Ate?"           ,"","","mv_ch4","C" ,6      ,0      ,0     ,"G",""           ,"mv_par04",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,"SA1",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"05" ,"Loja Ate?"              ,"","","mv_ch5","C" ,2      ,0      ,0     ,"G",""           ,"mv_par05",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,"   ",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"06" ,"Produto De?"            ,"","","mv_ch6","C" ,15     ,0      ,0     ,"G",""           ,"mv_par06",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,"SB1",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"07" ,"Produto Ate?"           ,"","","mv_ch7","C" ,15     ,0      ,0     ,"G",""           ,"mv_par07",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,"SB1",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"08" ,"Armazem?"               ,"","","mv_ch8","C" ,2      ,0      ,0     ,"G",""           ,"mv_par08",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"09" ,"Data Entrega Ate?"      ,"","","mv_ch9","D" ,8      ,0      ,0     ,"G",""           ,"mv_par09",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"10" ,"Data Ultimo Dia do Mes?","","","mv_cha","D" ,8      ,0      ,0     ,"G",""           ,"mv_par10",""           ,"","",""    ,""  ,""               ,"","",""   ,""    ,""           ,"","",""   ,""   ,""          ,"","",""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	EndIf
Next

Return
