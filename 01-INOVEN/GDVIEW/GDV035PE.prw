#include "protheus.ch"

// *********************************************************************** //
// GPV035PE - Pontos de entrada do GDVIEW Clientes para INOVEN             //
// @copyright (c) 2023-11-15 > Marcelo da Cunha > INOVEN                   //
// *********************************************************************** //

// Adicionar campos no browse principal
/*User Function GP035HGER()
    *********************
    LOCAL aCampos := {"A1_MUN","A1_EST","A1_XCOLIG","A1_CGC","C9_PEDIDO","A1_RISCO","A1_LC","A1_VENCLC",;
        "A1_CLASSE","A1_PRIOR","A1_PRICOM","A1_ULTCOM","A1_CONTATO","A1_DDD","A1_TEL","A1_EMAIL"}
Return aCampos
*/
// Adicionar informações de acordo com o cliente selecionado
User Function GP035INFO()
    *********************
    LOCAL aNewCols := paramixb[1]
    If (Len(aNewCols) > 0).and.!Empty(SA1->A1_xcolig)
        aadd(aNewCols,{"CLIENTE COLIGADO",SA1->A1_xcolig,.F.})
        nSldCol := getSaldoColigado(SA1->A1_xcolig)
        aadd(aNewCols,{"SALDO EM ABERTO COLIGADO",cSimMoed1+" "+Alltrim(Transform(nSldCol,PesqPict("SE1","E1_SALDO"))),.F.})
    Endif
Return aNewCols

// Buscar saldo em aberto dos coligados
Static Function getSaldoColigado(xColig)
    ************************************
    LOCAL nSaldo := 0, cQry, cAls
    cQry := "SELECT E1_MOEDA,SUM(E1_SALDO) E1_SALDO FROM "+RetSqlName("SE1")+" E1 "
    cQry += "INNER JOIN "+RetSqlName("SA1")+" A1 ON (A1.D_E_L_E_T_='' AND A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA) "
    cQry += "WHERE E1.D_E_L_E_T_ = '' AND E1_FILIAL = '"+xFilial("SE1")+"' AND E1_SALDO > 0 AND A1_XCOLIG = '"+xColig+"' "
    cQry += "GROUP BY E1_MOEDA "
    cAls := GDVDB():query(cQry)
    While !(cAls)->(Eof())
        nSaldo += xMoeda((cAls)->E1_SALDO,(cAls)->E1_MOEDA,1,dDatabase)
        (cAls)->(dbSkip())
    Enddo
    GDVDB():queryEnd(cAls)
Return nSaldo

// Tratamento para cores do browse de informacoes
User Function GP035CINF()
    *********************
    LOCAL nRetu := paramixb[1]
    LOCAL aHdr := paramixb[2]
    LOCAL aCls := paramixb[3]
    LOCAL nLin := paramixb[4]
    LOCAL nPMen := GDFieldPos("M_TIPO",aHdr)
	If (nPMen > 0).and.("COLIGADO" $ aCls[nLin,nPMen])
		nRetu := RGB(205,245,255) // Azul Claro
	Endif
Return nRetu
