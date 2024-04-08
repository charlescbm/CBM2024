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

 
User Function BFATG002()
**********************    

Private cRdesp := ''    

//Alterado com consentimento do Djeison em 30/11/2012
If M->A1_EST == 'RS'
	cRdesp := ''
ElseIf M->A1_EST == 'SC'
	cRdesp := ''	
ElseIf M->A1_EST == 'PR'
	cRdesp := ''	
ElseIf M->A1_EST == 'SP'
	cRdesp := ''	
ElseIf M->A1_EST == 'RJ'
	cRdesp := ''	
ElseIf M->A1_EST == 'MG'
	cRdesp := ''	
ElseIf M->A1_EST == 'ES'
	cRdesp := ''	
ElseIf M->A1_EST == 'GO'
	cRdesp := ''
ElseIf M->A1_EST == 'DF'
	cRdesp := ''
ElseIf M->A1_EST == 'TO'
	cRdesp := ''
ElseIf M->A1_EST == 'MS'
	cRdesp := ''
ElseIf M->A1_EST == 'MT'
	cRdesp := ''
ElseIf M->A1_EST == 'BA'
	cRdesp := ''
ElseIf M->A1_EST == 'SE'
	cRdesp := ''
ElseIf M->A1_EST == 'AL'
	cRdesp := ''
ElseIf M->A1_EST == 'PB'
	cRdesp := ''
ElseIf M->A1_EST == 'PB'
	cRdesp := ''
ElseIf M->A1_EST == 'PE'
	cRdesp := ''
ElseIf M->A1_EST == 'RN'
	cRdesp := ''
ElseIf M->A1_EST == 'CE'
	cRdesp := '' 
ElseIf M->A1_EST == 'PI'
	cRdesp := ''
ElseIf M->A1_EST == 'MA'
	cRdesp := ''
ElseIf M->A1_EST == 'AC'
	cRdesp := ''
ElseIf M->A1_EST == 'RO'
	cRdesp := '' 
ElseIf M->A1_EST == 'PA'
	cRdesp := ''
ElseIf M->A1_EST == 'AM'
	cRdesp := ''
ElseIf M->A1_EST == 'RR'
	cRdesp := ''
ElseIf M->A1_EST == 'AP'
	cRdesp := '' 
Endif

/*  Antigo
If M->A1_EST == 'RS'
	cRdesp := ''
ElseIf M->A1_EST == 'SC'
	cRdesp := ''	
ElseIf M->A1_EST == 'PR'
	cRdesp := ''	
ElseIf M->A1_EST == 'SP'
	cRdesp := ''	
ElseIf M->A1_EST == 'RJ'
	cRdesp := ''	
ElseIf M->A1_EST == 'MG'
	cRdesp := ''	
ElseIf M->A1_EST == 'ES'
	cRdesp := ''	
ElseIf M->A1_EST == 'GO'
	cRdesp := ''
ElseIf M->A1_EST == 'DF'
	cRdesp := ''
ElseIf M->A1_EST == 'TO'
	cRdesp := ''
ElseIf M->A1_EST == 'MS'
	cRdesp := ''
ElseIf M->A1_EST == 'MT'
	cRdesp := ''
ElseIf M->A1_EST == 'BA'
	cRdesp := ''
ElseIf M->A1_EST == 'SE'
	cRdesp := ''
ElseIf M->A1_EST == 'AL'
	cRdesp := ''
ElseIf M->A1_EST == 'PB'
	cRdesp := ''
ElseIf M->A1_EST == 'PB'
	cRdesp := ''
ElseIf M->A1_EST == 'PE'
	cRdesp := ''
ElseIf M->A1_EST == 'RN'
	cRdesp := ''
ElseIf M->A1_EST == 'CE'
	cRdesp := '' 
ElseIf M->A1_EST == 'PI'
	cRdesp := ''
ElseIf M->A1_EST == 'MA'
	cRdesp := ''
ElseIf M->A1_EST == 'AC'
	cRdesp := '002161'
ElseIf M->A1_EST == 'RO'
	cRdesp := '002161' 
ElseIf M->A1_EST == 'PA'
	cRdesp := '000150'
ElseIf M->A1_EST == 'AM'
	cRdesp := '000150'
ElseIf M->A1_EST == 'RR'
	cRdesp := '000150'
ElseIf M->A1_EST == 'AP'
	cRdesp := '000150' 
Endif     */

 
Return(cRdesp)