#INCLUDE "Protheus.ch" 
#include "rwmake.ch"
#INCLUDE "TopConn.ch" 
  
/*/
----------------------------------------------------------------------------
PROGRAMA: BESTG001         AUTOR: CHARLES B. MEDEIROS      DATA: 09/01/12
----------------------------------------------------------------------------

DESCRICAO: Alimenta no Cadastro de Cliente o Campo Transportadora e Redespacho

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR: Charles Battisti Medeiros
OBJETIVO:
----------------------------------------------------------------------------
/*/

 
User Function BFATG001(cTransp)
**********************

Private cTransp := ''     

If M->A1_EST == 'RS'
                cTransp := '000089'
ElseIf M->A1_EST == 'SC'
                cTransp := '000999'         
ElseIf M->A1_EST == 'PR'
                cTransp := '000089'         
ElseIf M->A1_EST == 'SP'
                cTransp := '000999'         
ElseIf M->A1_EST == 'RJ'
                cTransp := '100061'
ElseIf M->A1_EST == 'MG'
                cTransp := '100061'         
ElseIf M->A1_EST == 'ES'
                cTransp := '100061'         
ElseIf M->A1_EST == 'GO'
                cTransp := '100061'
ElseIf M->A1_EST == 'DF'
                cTransp := '100061'
ElseIf M->A1_EST == 'TO'
                cTransp := '100061'
ElseIf M->A1_EST == 'MS'
                cTransp := '100052'
ElseIf M->A1_EST == 'MT'
                cTransp := '100052'
ElseIf M->A1_EST == 'BA'
                cTransp := '100051'
ElseIf M->A1_EST == 'SE'
                cTransp := '100051'
ElseIf M->A1_EST == 'AL'
                cTransp := '100051'
ElseIf M->A1_EST == 'PB'
                cTransp := '100051'
ElseIf M->A1_EST == 'PE'
                cTransp := '100051'
ElseIf M->A1_EST == 'RN'
                cTransp := '100051'
ElseIf M->A1_EST == 'CE'
                cTransp := '100051'
ElseIf M->A1_EST == 'PI'
                cTransp := '100051'
ElseIf M->A1_EST == 'MA'
                cTransp := '100051'
ElseIf M->A1_EST == 'AC'
                cTransp := '000999'
ElseIf M->A1_EST == 'RO'
                cTransp := '000999'
ElseIf M->A1_EST == 'PA'
                cTransp := '000999'
ElseIf M->A1_EST == 'AM'
                cTransp := '000999'
ElseIf M->A1_EST == 'RR'
                cTransp := '000999'
ElseIf M->A1_EST == 'AP'
                cTransp := '000999' 
Endif


/* Antigo
If M->A1_EST == 'RS'
	cTransp := '100052'
ElseIf M->A1_EST == 'SC'
	cTransp := '000999'	
ElseIf M->A1_EST == 'PR'
	cTransp := '000120'	
ElseIf M->A1_EST == 'SP'
	cTransp := '000999'	
ElseIf M->A1_EST == 'RJ'
	cTransp := '000999'
ElseIf M->A1_EST == 'MG'
	cTransp := '100052'	
ElseIf M->A1_EST == 'ES'
	cTransp := '100052'	
ElseIf M->A1_EST == 'GO'
	cTransp := '100052'
ElseIf M->A1_EST == 'DF'
	cTransp := '100052'
ElseIf M->A1_EST == 'TO'
	cTransp := '100052'
ElseIf M->A1_EST == 'MS'
	cTransp := '100052'
ElseIf M->A1_EST == 'MT'
	cTransp := '100052'
ElseIf M->A1_EST == 'BA'
	cTransp := '000151'
ElseIf M->A1_EST == 'SE'
	cTransp := '000151'
ElseIf M->A1_EST == 'AL'
	cTransp := '000151'
ElseIf M->A1_EST == 'PB'
	cTransp := '000151'
ElseIf M->A1_EST == 'PE'
	cTransp := '000151'
ElseIf M->A1_EST == 'RN'
	cTransp := '000151'
ElseIf M->A1_EST == 'CE'
	cTransp := '000151'
ElseIf M->A1_EST == 'PI'
	cTransp := '000151'
ElseIf M->A1_EST == 'MA'
	cTransp := '000151'
ElseIf M->A1_EST == 'AC'
	cTransp := '000999'
ElseIf M->A1_EST == 'RO'
	cTransp := '000999'
ElseIf M->A1_EST == 'PA'
	cTransp := '000999'
ElseIf M->A1_EST == 'AM'
	cTransp := '000999'
ElseIf M->A1_EST == 'RR'
	cTransp := '000999'
ElseIf M->A1_EST == 'AP'
	cTransp := '000999' 
Endif    */

 
Return(cTransp)