#include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include 'parmtype.ch'
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FT210LIB
Ponto de entrada utilizado no fim da libera��o de regra.
@author		CBM
@since     	10/04/20          
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Altera��es Realizadas desde a Estrutura��o Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function FT210LEG()

Local aCores := ParamIXB 

aCores := {{ "BR_AZUL" 	,  "Pedido Em Analise - Rentabilidade" },	{ "BR_VERMELHO"	,  "Pedido Rejeitado - Rentabilidade"   } }

Return aCores
