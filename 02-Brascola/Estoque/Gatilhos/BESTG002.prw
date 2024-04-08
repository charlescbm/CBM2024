#INCLUDE "Protheus.ch" 
#include "rwmake.ch"
#INCLUDE "TopConn.ch" 
  
/*/
----------------------------------------------------------------------------
PROGRAMA: BESTG001         AUTOR: CHARLES B. MEDEIROS      DATA: 19/12/11
----------------------------------------------------------------------------

DESCRICAO: QUANDO TIPO MOD SOLICITA A INCLUSÃO DO CENTRO DE CUSTO

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

 
User Function BESTG002()
**********************

//Local cCCusto	 := SPACE(TAMSX3("CTT_CUSTO")[1])    
Private cCCusto := '      '
Private _oDlg


@ 000,1 TO 090,200 DIALOG _oDlg TITLE OemToAnsi("Informe o Centro de Custo")
@ 010,007 Say "Centro de Custos: " Size 60,10
@ 008,060 Get cCCusto  VALID NaoVazio().And. ExistCpo("CTT") F3 "CTT" Size 30,10   
@ 030,040 BMPBUTTON TYPE 01 ACTION Close(_oDlg)
Activate Dialog _oDlg Centered
           
//@ 008,060 Get cCCusto  VALID "NaoVazio()" .And. ExistCpo("CTT") F3 "CTT" Size 30,10                                                       
   
   

Return(cCCusto)