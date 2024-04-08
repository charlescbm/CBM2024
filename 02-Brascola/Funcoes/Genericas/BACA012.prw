#include "rwmake.ch"
#include "topconn.ch"

User Function BACA012()
*********************
If (Alltrim(cUserName) == "mcunha").and.MsgYesNo("> Busco dados da tabela SYP da base antiga?","ATENCAO")
	Processa({|| B012Proc() })
Endif
Return

Static Function B012Proc()
***********************

//Procuro no SX2 pelas familias que precisam ser substituidas
/////////////////////////////////////////////////////////////
SYP->(dbSetOrder(1))
TQB->(dbSetOrder(1))
TQB->(dbGotop())
While !TQB->(Eof())
   If !SYP->(dbSeek(xFilial("SYP")+TQB->TQB_codmss))
	   cQuery1 := "SELECT YP_CHAVE,YP_SEQ,YP_TEXTO,YP_CAMPO FROM DADOS10.dbo.SYP020 "
	   cQuery1 += "WHERE YP_CAMPO = 'TQB_CODMSS' AND YP_CHAVE = '"+TQB->TQB_codmss+"' "
	   If (Select("MSYP") <> 0)
	   	dbSelectArea("MSYP")
	   	dbCloseArea()
	   Endif
	   TCQuery cQuery1 NEW ALIAS "MSYP"
	   While !MSYP->(Eof())
	   	If !SYP->(dbSeek(xFilial("SYP")+MSYP->YP_chave+MSYP->YP_seq))
	   		Reclock("SYP",.T.)
	   		SYP->YP_filial := xFilial("SYP")
	   		SYP->YP_chave  := MSYP->YP_chave
	   		SYP->YP_seq    := MSYP->YP_seq
	   		SYP->YP_texto  := MSYP->YP_texto
	   		SYP->YP_campo  := MSYP->YP_campo
	   		MsUnlock("SYP")	      
	   	Endif
		   MSYP->(dbSkip())
	   Enddo   
   Endif
	TQB->(dbSkip())
Enddo
If (Select("MSYP") <> 0)
  	dbSelectArea("MSYP")
  	dbCloseArea()
Endif

Return