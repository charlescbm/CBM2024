/********************************************************************************************************************
** FONTE:     A650LEMP.PRW																					       **
** FUNCAO:    A650LEMP --> PONTO DE ENTRADA NA GERACAO DA OP PARA ALTERAR O ARMAZEM DE EMPENHO                     **
** DESCRICAO: UTILIZA O PARAMETRO MV_ARMPR, SE O PARAMETRO NAO ESTIVER CADASTRADO UTILIZADO O ARMAZEM 20, PARA     **
**			  RETORNAR O CODIGO DO ARMAZEM DE PRODUCAO UTILIZADO PARA OS EMPENHOS								   **
** DATA:      10/06/2005																						   **
** CLIENTE:   BRASCOLA LTDA																						   **
** AUTOR:     SERGIO LACERDA / EVALDO BATISTA																	   **
********************************************************************************************************************/

USER FUNCTION A650LEMP()

Local _cLocPad := ""   

IF SM0->M0_CODFIL == '01'
  _cLocPad :=  GETMV("BR_ESTPROD")
Endif


RETURN(_cLocPad)
//RETURN("20") // ALTERADO - Daniel Neves 22.11.05 