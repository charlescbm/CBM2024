#include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include 'parmtype.ch'
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FT210LIB
Ponto de entrada utilizado no fim da liberação de regra.

@author		CBM
@since     	10/04/20            
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function FT210COR()

Local aCores := ParamIXB 

aCores := {{ "C5_BLQ == '1'",'BR_AZUL'},{ "C5_BLQ == '2'",'BR_VERMELHO'} } 		 		

//Alert("Passou no ponto FT210COR")

Return aCores