#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"        
#INCLUDE "TbiConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BFATA001 บAutor  ณFernando            บ Data ณ  26/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza Transportadora x Cliente/Pedido                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Brascola                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function BFATA001()
**********************
LOCAL _cQuery := "" 
LOCAL cFil := Substr(cFilAnt,2,1) //Fernando: cFilAnt(variavel que captura a filial acessada atualmente)  
LOCAL nRet := 0, nRet1 := 0

U_BCFGA002("BFATA001") //Grava detalhes da rotina usada

If !Pergunte("BFATA001",.t.)
  	Return
EndIf

//Gravar Alteracao no Pedido
////////////////////////////
If MsgYesNo(" Confirma Atualiza็ใo de Pedidos para Filial "+iif(cFil=="1","JOINVILLE","FRANCA")+" ?")
	_cQuery := "SELECT C5.R_E_C_N_O_ MRECNO FROM "+RetSqlName("SC5")+" C5,"+RetSqlName("SA1")+" A1 "
	_cQuery += "WHERE C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+xFilial("SC5")+"' "
	_cQuery += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
	_cQuery += "AND C5.C5_CLIENTE = A1.A1_COD AND C5.C5_LOJACLI = A1.A1_LOJA "
	If !Empty(mv_par03)
		_cQuery += "AND A1_EST = '"+mv_par03+"' " 
	Endif
	If !Empty(mv_par06)                  
		_cQuery += "AND A1_VEND = '"+mv_par06+"' " 
	Endif
	_cQuery += "AND A1_FILFAT = '"+Alltrim(cFil)+"' " //Fernando
	_cQuery += "AND C5_NOTA = '' AND C5_TRANSP <> '"+mv_par01+"' AND C5_TRANSP <> '099999' "
	_cQuery := ChangeQuery(_cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery _cQuery NEW ALIAS "MAR"
	SC5->(dbSetOrder(1))
	dbSelectArea("MAR")
	While !MAR->(Eof())
		SC5->(dbGoto(MAR->MRECNO))
	  	cTitHis := "ALTERACAO AUTOMATICA PEDIDO (BFATA001)"
	  	cObsAdi := "TRANSPORTADORA ALTERADA "+SC5->C5_transp+" PARA "+mv_par01+chr(13)+chr(10)
		If (mv_par04 == 1) //Altera Redespacho
	  		cObsAdi += "REDESPACHO ALTERADO "+SC5->C5_redesp+" PARA "+mv_par02+chr(13)+chr(10)
		Endif
	  	u_GDVHInclui("SC5",cTitHis,cObsAdi,,.T.,.T.)
	  	Reclock("SC5",.F.)
	  	SC5->C5_transp := mv_par01
		If (mv_par04 == 1) //Altera Redespacho
	  		SC5->C5_redesp := mv_par02
		Endif
	  	MsUnlock("SC5")
		MAR->(dbSkip())
	Enddo
Endif

//Gravar Alteracao no Cliente
/////////////////////////////
If MsgYesNo(" Confirma Atualiza็ใo de Clientes para Filial "+iif(cFil=="1","JOINVILLE","FRANCA")+" ?")
	_cQuery := "SELECT A1.R_E_C_N_O_ MRECNO FROM "+RetSqlName("SA1")+" A1 "
	_cQuery += "WHERE  A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
	If !Empty(mv_par03)
		_cQuery += "AND A1_EST = '"+mv_par03+"' " 
	Endif
	If !Empty(mv_par06)                  
		_cQuery += "AND A1_VEND = '"+mv_par06+"' " 
	Endif
	_cQuery += "AND A1_FILFAT = '"+Alltrim(cFil)+"' AND A1_TRANSP <> '"+mv_par01+"' AND A1_TRANSP <> '999999' " //Fernando
	_cQuery := ChangeQuery(_cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery _cQuery NEW ALIAS "MAR"
	SA1->(dbSetOrder(1))
	dbSelectArea("MAR")
	While !MAR->(Eof())
		SA1->(dbGoto(MAR->MRECNO))
	  	cTitHis := "ALTERACAO AUTOMATICA TRANSPORTADORA CLIENTE (BFATA001)"
	  	cObsAdi := "TRANSPORTADORA ALTERADA "+SA1->A1_transp+" PARA "+mv_par01+chr(13)+chr(10)
	  	cObsAdi += "REDESPACHO ALTERADO "+SA1->A1_x_rdesp+" PARA "+mv_par02+chr(13)+chr(10)
	  	cObsAdi += "% FRETE ALTERADO "+Alltrim(Str(SA1->A1_percfre))+" PARA "+Alltrim(Str(mv_par05))+chr(13)+chr(10)
	  	u_GDVHInclui("SA1",cTitHis,cObsAdi,,.T.,.T.)
	  	Reclock("SA1",.F.)
	  	SA1->A1_transp  := mv_par01
	  	SA1->A1_x_rdesp := mv_par02
	  	SA1->A1_percfre := mv_par05
	  	MsUnlock("SA1")
		MAR->(dbSkip())
	Enddo
Endif

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
                              
Return