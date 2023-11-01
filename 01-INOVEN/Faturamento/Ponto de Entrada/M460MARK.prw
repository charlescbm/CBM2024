#include "rwmake.ch"
#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*--------------------------------------------------------------------------*
* Ponto de entrada apos a selecao dos pedidos para faturar que ira calcular *
* o frete e o peso dos itens selecionados                                   *
*---------------------------------------------------------------------------*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460MARK  ºAutor  ³Daniel Pelegrinelli º Data ³  09/15/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada que bloqueia todos os itens do pedido      º±±
±±º          ³selecionado quando nao possui credito                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

user function M460MARK

//Local aArea    := GetArea()
//Local aAreaSC9 := SC9->(GetArea())
//Local nSaldo  := 0
//Local dData   := "" // Campo alimentado no ponto de entrada MTA450I().
//Local aAmbSC5 := sc5->(GetArea())
//Local cMarca  := PARAMIXB[1]
//Local lInv    := PARAMIXB[2]
Local cMarca    := ThisMark()
Local lInverte  := ThisInv()
//Local aFiltro := Eval(bFiltraBrw,1)
//Local cNum, cQuery, nVol, nFrete
//Local cCliente := ""
//Local dLimite 
 
//Local _cPedido := Space(6) 
Local _aArea   := GetArea()
Local _cAreaSC5:= SC5->(GetArea())
Local _cAreaSC6:= SC6->(GetArea())
Local _cAreaSC9:= SC9->(GetArea())
//Local _lMarcado := .f.
//Local _nRecno  
//local _nQtdSC9:=0
//local _nQtdSC6:=0
local _lRet:=.t.



SC5->( Dbsetorder(1) )
SC6->( Dbsetorder(1) )

    DBSELECTAREA("SC9")
    SC9->( Dbsetorder(1) )
    SC9->( DbGoTop() )
    
    If Select("TRB") > 0
       TRB->(dbCloseArea())
    Endif                         
    
    cQuery := ""
    cQuery := "Select Distinct C9_PEDIDO from "+RetSqlName("SC9")+" Where C9_FILIAL = '"+xFilial("SC9")+"' AND D_E_L_E_T_ = ' ' AND C9_NFISCAL = '' AND C9_BLEST = ''  AND C9_BLCRED = '' " 
     If ( lInverte )
			cQuery +=" AND C9_OK<>'"+cMarca+"'"
     Else
			cQuery +=" AND C9_OK='"+cMarca+"'"
     ENDIF
     
    
    //AND C9_OK = '"+PARAMIXB[1]+"' AND D_E_L_E_T_ = ' ' AND C9_NFISCAL = '' "
//    cQuery += " GROUP BY C9_PEDIDO "
    cQuery += " ORDER BY C9_PEDIDO "
    TcQuery cQuery New Alias "TRB"
     
    dbSelectArea("TRB")
    Do While !Eof()
        
       If Select("QSC6") > 0
          QSC6->(dbCloseArea())
       Endif  
       cQuery := ""              
       cQuery := "Select ISNULL(SUM(C6_QTDVEN),0) NTOTSC6  from "+RetSqlName("SC6")+" SC6 "
       cQuery += "Inner Join "+RetSqlName("SC5")+" SC5 On C5_FILIAL = '"+xFilial("SC5")+"' And C5_NUM = '"+TRB->C9_PEDIDO+"' AND C5_TIPO = 'N' AND SC5.D_E_L_E_T_ = ' ' "  
       cQuery += "Where C6_FILIAL = '"+xFilial("SC6")+"'  AND C6_NUM = '"+TRB->C9_PEDIDO+"' AND SC6.D_E_L_E_T_ = ' '  AND C6_QTDVEN > C6_QTDENT AND C6_BLQ <> 'R' "
       TcQuery cQuery New Alias "QSC6"
                                    

       If Select("QSC9") > 0
          QSC9->(dbCloseArea())
       Endif       
       cQuery := ""         
       cQuery := "Select SUM(C9_QTDLIB) NTOTSC9 from "+RetSqlName("SC9")+" "
       cQuery += "Where C9_FILIAL = '"+xFilial("SC9")+"'  AND C9_PEDIDO = '"+TRB->C9_PEDIDO+"' AND D_E_L_E_T_ = ' ' AND C9_NFISCAL = '' AND C9_BLEST = ''  AND C9_BLCRED = '' "
        If ( lInverte )
			cQuery +=" AND C9_OK<>'"+cMarca+"'"
     	Else
			cQuery +=" AND C9_OK='"+cMarca+"'"
     	ENDIF
       
     	TcQuery cQuery New Alias "QSC9"
     	
     	DbSelectArea("SC5")
     	DbSetORder(1)
     	DbSeek(xFilial("SC5") + TRB->C9_PEDIDO)
       
       If QSC9->NTOTSC9 <> QSC6->NTOTSC6 .AND. SC5->C5_TIPOFAT == '2' // TRAVA NA ROTINA DE DOCUMENTO DE SAIDA -> PREPARA DOCUMENTO -- CHARLES MEDEIROS 02/03/2020
          Aviso( "Atencao", "Pedido "+TRB->C9_PEDIDO+" Está com liberação parcial e TipoFat por Pedido!"+CHR(13)+" O PEDIDO NAO SERA FATURADO.", {"OK"} ) // TRAVA NA ROTINA DE DOCUMENTO DE SAIDA -> PREPARA DOCUMENTO -- CHARLES MEDEIROS 02/03/2020
          If MsgYesNo( "Deseja estornar a liberação do pedido ? ", "Atenção" )
  	         
			//-- IR -- Necessário estornar a liberação do pedido antes de liberar novamente.
				aEstLibPv(cFilAnt,TRB->C9_PEDIDO)    
				_lRet := .T.
   	     EndIf

          _lRet := .F.
       Endif

       dbSelectArea("TRB")
       Dbskip()
    Enddo


SC5->(RestArea(_cAreaSC5))
SC6->(RestArea(_cAreaSC6))
SC9->(RestArea(_cAreaSC9)) 
RestArea(_aArea)

Return(_lRet)
                                                   

/*


SC5->( Dbsetorder(1) )
SC6->( Dbsetorder(1) )

    DBSELECTAREA("SC9")
    SC9->( Dbsetorder(1) )
    SC9->( DbGoTop() )
    
    Do While ! SC9->( Eof() )
        
        IF ! ((SC9->C9_OK != PARAMIXB[1] .And. PARAMIXB[2] .AND. !A460AVALIA()) .Or.(SC9->C9_OK == PARAMIXB[1] .And. !PARAMIXB[2])) 
            SC9->( Dbskip() )
            Loop
        Else
            _lMarcado := .t.
        Endif
        
        IF _lMarcado
            If SC5->( Dbseek(xFilial("SC5") + SC9->C9_PEDIDO) ) .And. (SC5->C5_TIPO == 'N' .And. SC5->C5_TIPLIB="2") 
                _cPedido := SC9->C9_PEDIDO
                _nQtdSC6 := 0
                If SC6->( Dbseek(xFilial("SC6") + _cPedido ) )
                    Do While ! SC6->( EOF() ) .And. SC6->C6_NUM == _cPedido 
                        _nQtdSC6 += SC6->C6_QTDVEN
                        SC6->( Dbskip() )
                    Enddo
                Endif
                _nQtdSC9 := 0
                If SC9->( Dbseek(xFilial("SC9") + _cPedido ) ) 
                    Do While ! SC9->( EOF() ) .And. SC9->C9_PEDIDO == _cPedido
                        If SC9->C9_OK == PARAMIXB[1]
                            _nQtdSC9 += SC9->C9_QTDLIB
                        Endif 
                        SC9->( Dbskip() )
                    Enddo
                Endif
                If _nQtdSC9 <> _nQtdSC6
                    Aviso( "Atencao", "Pedido "+_cPedido+" nao confere com a Qtd Liberada !"+CHR(13)+"O PEDIDO NAO SERA FATURADO.", {"OK"} ) 
                    /*
                    If SC9->( Dbseek(xFilial("SC9") + _cPedido ) )
                        Do While ! SC9->( EOF() ) .And. SC9->C9_PEDIDO == _cPedido
                            If SC9->C9_OK == PARAMIXB[1]
                                RecLock("SC9",.F.)
                                SC9->C9_OK := space(4)
                                MsUnlock()
                                //If Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)
	                            //   SC9->(A460Estorna())
                               //	EndIf   
                            Endif
                            SC9->( Dbskip() ) 
                        Enddo
                    Endif
                    */
/*
                    _lRet := .F.
                Endif
            Endif
        Endif
        SC9->( Dbskip() )
    Enddo
//Endif


SC5->(RestArea(_cAreaSC5))
SC6->(RestArea(_cAreaSC6))
SC9->(RestArea(_cAreaSC9)) 
RestArea(_aArea)

Return(_lRet)





/*
Local aArea    := GetArea()
Local aAreaSC9 := SC9->(GetArea())
Local nSaldo  := 0
Local dData   := "" // Campo alimentado no ponto de entrada MTA450I().
Local aAmbSC5 := sc5->(GetArea())
Local cMarca  := PARAMIXB[1]
Local lInv    := PARAMIXB[2]
Local aFiltro := Eval(bFiltraBrw,1)
Local cNum, cQuery, nVol, nFrete
Local cCliente := ""
Local dLimite

/
// Inicio Programa para retornar os Pedidos Marcados
cQurc9 := "SELECT C9_PEDIDO, C9_PRODUTO, C9_CLIENTE, C9_X_LBFIN, C9_ITEM, SC9.R_E_C_N_O_ RECSC9 "

cQurc9 += " FROM "+RetSqlName("SC9")+" SC9, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SF4")+" SF4 "

cQurc9 += " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"'"
cQurc9 += " AND SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST = '  '"

//cQurc9 += " AND "+aFiltro[2]+If(lInv," AND C9_OK <> '"," AND C9_OK = '")+cMarca+"' "
cQurc9 += If(lInv," AND C9_OK <> '"," AND C9_OK = '")+cMarca+"' "
cQurc9 += " AND SC9.D_E_L_E_T_ <> '*'"

cQurc9 += " AND SC6.C6_FILIAL = '"+xFilial("SC6")+"'"
cQurc9 += " AND SC6.C6_NUM = SC9.C9_PEDIDO "
cQurc9 += " AND SC6.C6_ITEM = SC9.C9_ITEM "
cQurc9 += " AND SC6.C6_PRODUTO = SC9.C9_PRODUTO"
cQurc9 += " AND SC6.D_E_L_E_T_ <> '*'"

cQurc9 += " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
cQurc9 += " AND SF4.F4_CODIGO = SC6.C6_TES "
cQurc9 += " AND SF4.F4_DUPLIC = 'S'"
cQurc9 += " AND SF4.D_E_L_E_T_ <> '*'"

cQurc9 += " ORDER BY C9_PEDIDO, C9_ITEM "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQurC9),"TM2",.F.,.F.)
TM2->(dBGotop())

While TM2->(!Eof())
	
	dLimite  := GETMV("BR_FBLQDIA")
	cCliente := TM2->C9_CLIENTE
	dData    := Stod(TM2->C9_X_LBFIN)
	dData    := dData + dLimite // dias de prazo, tera que ser substituido por parametro.
	dData    := Dtos(dData)
	
	_lok := .f.
	
	cQryE1 := "SELECT SUM(E1_SALDO)SALDO"
	cQryE1 += "FROM SE1020"
	cQryE1 += "WHERE E1_SALDO <> 0"
	cQryE1 += "AND E1_CLIENTE = '"+cCliente+"'"
	cQryE1 += "AND E1_VENCREA < '"+dData+"'"
	cQryE1 += "AND (E1_TIPO = 'JP ' or E1_TIPO = 'NF ' or E1_TIPO = 'DP ' or E1_TIPO = 'FT ' or E1_TIPO = 'NDF' OR E1_TIPO = 'NP ' or E1_TIPO = 'OP ' or E1_TIPO = 'PF 'or E1_TIPO = 'RC ' or E1_TIPO = 'DM '  )"
	cQryE1 += "AND D_E_L_E_T_ <> '*'"
	
	cQryE1 := ChangeQuery(cQryE1)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryE1),"TR2",.T.,.T.)
	dbGotop()
	nSaldo := TR2->SALDO
	dbCloseArea()
	
	//	IF nSaldo > 0 .And. dData < Dtos(dDataBase)
	If dData < Dtos(dDataBase)
		
      // Bloquear
      dbSelectArea("SC9")
      dbGoto(TM2->RECSC9)
      RecLock("SC9",.F.)
      SC9->C9_OK := "  "
      MsUnLock()

      // Aviso ?? - Email
		SendBlFin()

	EndIf

	dbSelectArea("TM2")
	dbSkip()
EndDo

TM2->(dBCloseArea())
RestArea(aAreaSC9)
RestArea(aArea)
/*/                       




Static Function aEstLibPv(cFilPed,cPedido)

Local aArea	:= GetArea()

//------------------+
// Posiciona Pedido |
//------------------+
dbSelectArea("SC9")
SC9->( dbSetOrder(1) )
If SC9->( dbSeek(cFilPed + cPedido ) )
	While SC9->( !Eof() .And. cFilPed + cPedido == SC9->( C9_FILIAL + C9_PEDIDO ) )
		If Empty(SC9->C9_NFISCAL) .And. Empty(SC9->C9_SERIENF)
			//--------------------------+
			// Estorna Liberação Pedido |
			//--------------------------+
			a460Estorna(.T.,.F.)
		EndIf
		SC9->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)

Return .T.
