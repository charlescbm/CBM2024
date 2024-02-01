#INCLUDE 'parmtype.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch"                                                  
#INCLUDE "TbiConn.ch"

/*//--------------------------------------------------------------------------------------
-------- Ponto de entrada para retornar os campos de exibição no GdView Clientes. A1_SALDUP = SALDO TITULOS EM ABERTO / 
*/
User Function GP035HGER()

Return {"A1_XCOLIG","A1_MUN","A1_EST","A1_CGC","A1_RISCO","A1_LC","A1_VENCLC","A1_CLASSE","A1_PRIOR","A1_PRICOM","A1_ULTCOM","A1_CONTATO","A1_DDD","A1_TEL","A1_EMAIL,A1_VACUM"}

    //aHdrGer//////////////////////////////////////////////////////////
   // GDVFW():addHdr(@aHdrGer,{"MSTATUS","A1_FILIAL","A1_COD","A1_LOJA","A1_NOME"})
   /* 
    If ExistBlock("GP035HGER")
        GDVFW():addHdr(@aHdrGer,ExecBlock("GP035HGER",.F.,.F.))
    Else
        GDVFW():addHdr(@aHdrGer,{"A1_MUN","A1_EST","A1_CGC","C9_PEDIDO","A1_RISCO","A1_LC","A1_VENCLC",;
        "A1_CLASSE","A1_PRIOR","A1_PRICOM","A1_ULTCOM","A1_CONTATO","A1_DDD","A1_TEL","A1_EMAIL,A1_VACUM"})
    Endif
Return
*/
