#include "rwmake.ch"
#include "topconn.ch"

User Function BACA013()
***********************
LOCAL nPrcMed := 0   
      
RpcSetType(3)
RPCSetEnv("01","01","","","EST","",{"SB1","SC2"})

SC2->(dbSetOrder(1))
SC2->(dbSeek(xFilial("SC2"),.T.))
While !SC2->(Eof()).and.(xFilial("SC2") == SC2->C2_filial)
	dDatabase := SC2->C2_emissao
	nPrcMed := BPrcLiqu(SC2->C2_produto)
	If (SC2->C2_prcmed != nPrcMed)
		Reclock("SC2",.F.)
		SC2->C2_prcmed := nPrcMed
		MsUnlock("SC2")
	Endif     
	SC2->(dbSkip())
Enddo

Return

Static Function BPrcLiqu(xProduto)
*******************************
LOCAL nRetu := 0, cQuery1 := "", cTab1 := "036" //12% ICMS

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Custo de Venda medio do ultimos 30 dias                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT SUM(D2_QUANT) D2_QUANT,SUM(D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6) D2_TOTAL FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF4")+" F4 "
cQuery1 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+xFilial("SD2")+"' AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery1 += "AND D2_TES=F4_CODIGO AND F4_DUPLIC='S' AND D2_COD='"+xProduto+"' AND D2_EMISSAO BETWEEN '"+dtos(dDatabase-30)+"' AND '"+dtos(dDatabase)+"' "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSD2"
dbSelectArea("MSD2")
If !MSD2->(Eof()).and.(MSD2->D2_quant > 0)
	nRetu := Round(MSD2->D2_total/MSD2->D2_quant,4)
Endif
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se nao encontrar preco medio, utilizar tabela 12% ICMS       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nRetu == 0)
	DA1->(dbSetOrder(1)) //Tabela+Produto
	DA1->(dbSeek(xFilial("DA1")+cTab1+xProduto,.T.))
	While !DA1->(Eof()).and.(xFilial("DA1") == DA1->DA1_filial).and.(DA1->DA1_codtab+DA1->DA1_codpro == cTab1+xProduto)
		nRetu := DA1->DA1_prcven //Preco Venda
		Exit
	Enddo
Endif

Return nRetu