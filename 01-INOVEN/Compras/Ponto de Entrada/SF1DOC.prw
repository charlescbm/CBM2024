#INCLUDE 'PROTHEUS.CH'

/*********************************************************************************************/
/*/{Protheus.doc} SF1DOC

@description Ajustar numeracao da nota fiscal de entrada

@author 
@since 18/05/2021
@version 1.0

@param cStatus	, characters, descricao
@param nOpc		, numeric, descricao
@type function
/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function SF1DOC()
If !Empty(M->F1_DOC) .Or. !Empty(cNFISCAL)
  M->F1_DOC := StrZero(Val(M->F1_DOC),9)
  CNFISCAL := M->F1_DOC
Endif  
Return(.T.)
