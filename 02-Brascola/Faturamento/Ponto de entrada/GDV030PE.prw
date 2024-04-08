#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GDV030PE บAutor  ณ Marcelo da Cunha   บ Data ณ  14/04/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Pontos de Entrada utilizados no GDView CRM                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030LEGEบAutor  ณ Marcelo da Cunha   บ Data ณ  03/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para incluir legenda Brascola no GDView   บฑฑ
ฑฑบ          ณ CRM.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030LEGE()
*************************
LOCAL aRetu := {{"BR_VERDE","Com pedido nos ๚ltimos 30 dias"},;
				{"BR_AZUL","ฺltimo pedido entre 30 e 60 dias"},;
				{"BR_AMARELO","ฺltimo pedido entre 60 e 90 dias"},;
				{"BR_VERMELHO","ฺltimo pedido entre 90 e 180 dias"},;
				{"BR_PRETO","Sem PV +180 dias (vendedor anterior)"}}
Return aRetu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030SEMAบAutor  ณ Marcelo da Cunha   บ Data ณ  03/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para tratar semaforo Brascola no GDView   บฑฑ
ฑฑบ          ณ CRM.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030SEMA()
*************************
LOCAL cRetu := "", cQuery1 := ""
                      
//Analisar tabela de Clientes
/////////////////////////////
If (paramixb[1] == "SA1") 
	cQuery1 += "SELECT "
	cQuery1 += "ISNULL((SELECT MAX(C5_EMISSAO) FROM "+RetSQLName("SC5")+" SC5X "
	cQuery1 += "   WHERE SC5X.D_E_L_E_T_='' AND SC5X.C5_FILIAL = '"+xFilial("SC5")+"' "
	cQuery1 += "   AND SC5X.C5_CLIENTE = SA1.A1_COD AND SC5X.C5_LOJACLI = SA1.A1_LOJA "
	cQuery1 += "   AND SC5X.C5_CANCELA <> 'S'),'') 'MDTULPV', "
	cQuery1 += "ISNULL((SELECT MAX(C5_EMISSAO) FROM "+RetSQLName("SC5")+" SC5X "
	cQuery1 += "   WHERE SC5X.D_E_L_E_T_='' AND SC5X.C5_FILIAL = '"+xFilial("SC5")+"' "
	cQuery1 += "   AND SC5X.C5_CLIENTE = SA1.A1_COD AND SC5X.C5_LOJACLI = SA1.A1_LOJA "
	cQuery1 += "   AND SC5X.C5_CANCELA <> 'S' AND SC5X.C5_VEND1 = SA1.A1_VENDANT),'') 'MDTULAN' "
	cQuery1 += "FROM "+RetSQLName("SA1")+" SA1 "
	cQuery1 += "WHERE SA1.D_E_L_E_T_ = '' AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQuery1 += "AND SA1.A1_COD = '"+paramixb[2]+"' AND SA1.A1_LOJA = '"+paramixb[3]+"' " 
	If (Select("GD030SEM") <> 0)
		dbSelectArea("GD030SEM")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "GD030SEM"
	TCSetField("GD030SEM","MDTULPV","D",08,0)
	TCSetField("GD030SEM","MDTULAN","D",08,0)
	If !GD030SEM->(Eof())
		If (GD030SEM->MDTULPV >= (dDatabase-30))
			cRetu := "BR_VERDE"
		Elseif (GD030SEM->MDTULPV < (dDatabase-30)).and.(GD030SEM->MDTULPV >= (dDatabase-60))
			cRetu := "BR_AZUL"
		Elseif (GD030SEM->MDTULPV < (dDatabase-60)).and.(GD030SEM->MDTULPV >= (dDatabase-90))
			cRetu := "BR_AMARELO"
		Elseif (GD030SEM->MDTULPV < (dDatabase-90)).and.(GD030SEM->MDTULPV >= (dDatabase-180))
			cRetu := "BR_VERMELHO"
		Elseif (GD030SEM->MDTULPV < (dDatabase-180)).or.(!Empty(GD030SEM->MDTULAN).and.(GD030SEM->MDTULAN < (dDatabase-180)))
			cRetu := "BR_PRETO"
		Endif
	Endif
	If (Select("GD030SEM") <> 0)
		dbSelectArea("GD030SEM")
		dbCloseArea()
	Endif
Endif
					
Return cRetu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030FILTบAutor  ณ Marcelo da Cunha   บ Data ณ  03/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para tratar filtro Brascola no GDView     บฑฑ
ฑฑบ          ณ CRM.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030FILT()
*************************
LOCAL cRetu := "", cCodRep := ""
                      
//Analisar tabela de Clientes
/////////////////////////////
If (paramixb[1] == "SA1") 
	If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cRetu += "AND A1_VEND IN ("+cCodRep+") "
		Else
			cRetu += "AND A1_VEND = 'ZZZZZZ' "
		Endif
	Endif	
Elseif (paramixb[1] == "SA3") 
	If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cRetu += "AND A3_COD IN ("+cCodRep+") "
		Else
			cRetu += "AND A3_COD = 'ZZZZZZ' "
		Endif
	Endif	
Elseif (paramixb[1] == "SE1").and.(paramixb[2] == 8) //Comiss๕es
	cDataSE1 := GetMV("BR_000047")
	If !Empty(cDataSE1)
		cRetu += "AND E1_EMISSAO >= '"+cDataSE1+"' "
	Endif
Endif
					
Return cRetu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030BUTTบAutor  ณ Marcelo da Cunha   บ Data ณ  08/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para adicionar bot๔es no GDView CRM       บฑฑ
ฑฑบ          ณ CRM.                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030BUTT()
*************************
LOCAL aRetu := {}
If (Alltrim(cUserName) $ SuperGetMV("BR_GDUSUCR",.F.,""))
	aadd(aRetu,{"Transf.Vendedor",{|| u_GP030BTransf() }})
Endif
Return aRetu

User Function GP030BTransf()
****************************
LOCAL nn := 1, aRegs := {}, cPerg := "GD030BTRAN"
LOCAL nPEnt := GDFieldPos("M_ENTIDA",oGetGer:aHeader)
LOCAL nPChv := GDFieldPos("M_CHAVE",oGetGer:aHeader)
                  
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria grupo de perguntas                                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
AADD(aRegs,{cPerg,"01","Vendedor   ?" ,"mv_ch1","C",06,0,0,"G","ExistCpo('SA3')","MV_PAR01","","","","","","","","","","","","","","","SA3"})
u_BXCriaPer(cPerg,aRegs) //Brascola
SA1->(dbSetOrder(1))
If Pergunte(cPerg,.T.).and.!Empty(mv_par01).and.MsgYesNo("> Confirma transfer๊ncia de vendedor?","ATENCAO")
	SA1->(dbSetOrder(1))
	For nn := 1 to Len(oGetGer:aCols)
		If (oGetGer:aCols[nn,nPEnt] == "SA1")
			If SA1->(dbSeek(xFilial("SA1")+oGetGer:aCols[nn,nPChv]))
				cTitHis := "ALTERACAO REPRESENTANTE GDVIEW CRM"
				cObsAdi := "CLIENTE ALTERADO VENDEDOR "+SA1->A1_vend+" PARA "+mv_par01
				Reclock("SA1",.F.)
				SA1->A1_vendant := SA1->A1_vend
				SA1->A1_vend := mv_par01
				MsUnlock("SA1")                     
				u_GDVHInclui("SA1",cTitHis,cObsAdi,,.T.,.T.)
			Endif
		Endif
	Next nn
	MsgInfo("> Processo realizado com sucesso!","ATENCAO")
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030HFATบAutor  ณ Marcelo da Cunha   บ Data ณ  29/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para adicionar campos no browse das notas บฑฑ
ฑฑบ          ณ fiscais de saida.                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030HFAT()
*************************
LOCAL aRetu := {"F2_EMISSAO","F2_DTSAIDA","F2_VALMERC","F2_VALBRUT","F2_ESPECIE","F2_CLIENTE","F2_LOJA","A1_NOME","F2_VEND1","A3_NOME","F2_CHVNFE"}
Return aRetu 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030SPEDบAutor  ณ Marcelo da Cunha   บ Data ณ  05/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para tratar usuarios com acesso SPED      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030SPED()
**********************
LOCAL lRetu := .F.
SZA->(dbSetOrder(1))
If SZA->(dbSeek(xFilial("SZA")+"SPEDNFE")).and.(Alltrim(cUserName) $ Alltrim(SZA->ZA_user1)+"/"+Alltrim(SZA->ZA_user2))
	lRetu := .T.
Endif
Return lRetu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030HPEDบAutor  ณ Marcelo da Cunha   บ Data ณ  11/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para adicionar novos campos na tela de    บฑฑ
ฑฑบ          ณ pedidos de venda do GDView CRM                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030HPED()
**********************
LOCAL aRetu := {"C5_EMISSAO","C6_ENTREG","C5_CONDPAG","C5_NOTA","C5_SERIE","C5_CLIENTE","C5_LOJACLI","A1_NOME","C6_VALOR","C5_VEND1","C5_TRANSP","A4_NOME","C5_OBSER","C9_MOTREJ"}
Return aRetu

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GP030CPEDบAutor  ณ Marcelo da Cunha   บ Data ณ  11/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para realizar alteracoes no aCols do      บฑฑ
ฑฑบ          ณ pedidos de venda do GDView CRM                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GP030CPED()
**********************
LOCAL aHdrP := aClone(paramixb[1]) //aHeader
LOCAL aRetu := aClone(paramixb[2]) //aCols
LOCAL nPEnt := GDFieldPos("C6_ENTREG",aHdrP)
LOCAL nPVal := GDFieldPos("C6_VALOR" ,aHdrP)
LOCAL nPMot := GDFieldPos("C9_MOTREJ",aHdrP)
LOCAL dEntreg := ctod("//"), nValor := 0, cMotivo := ""
If (nPEnt > 0).and.(nPVal > 0).and.(nPMot > 0)
	SC6->(dbSetOrder(1)) ; SC9->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_num,.T.))
	While !SC6->(Eof()).and.(xFilial("SC6") == SC6->C6_filial).and.(SC6->C6_num == SC5->C5_num)
		If Empty(dEntreg).or.(dEntreg < SC6->C6_entreg)
			dEntreg := SC6->C6_entreg
		Endif
		nValor += SC6->C6_valor
		If Empty(cMotivo)
			SC9->(dbSeek(xFilial("SC9")+SC6->C6_num+SC6->C6_item,.T.))
			While !SC9->(Eof()).and.(xFilial("SC9") == SC9->C9_filial).and.(SC9->C9_pedido+SC9->C9_item == SC6->C6_num+SC6->C6_item)
				If !Empty(SC9->C9_motrej)
					cMotivo := SC9->C9_motrej
					Exit
				Endif
				SC9->(dbSkip())
			Enddo
		Endif	
		SC6->(dbSkip())
	Enddo
	aRetu[nPEnt] := dEntreg
	aRetu[nPVal] := nValor
	aRetu[nPMot] := cMotivo
Endif
Return aRetu