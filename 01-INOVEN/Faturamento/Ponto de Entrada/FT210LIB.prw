#include "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#include 'parmtype.ch'
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FT210LIB
Ponto de entrada utilizado no fim da liberação de regra.

@author		.iNi Sistemas
@since     	24/11/17
@version  	P.12              
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

User Function FT210LIB()
	
	//--Rotina valida bloqueio
	U_IFATM030()	
	//--Se motivo do bloqueio preenchido.
	If !Empty(SC5->C5_XMOTBLQ)
		RecLock('SC5',.F.)   
		Replace SC5->C5_BLQ With '2' 
	    SC5->(MsUnlock())
	Else
		Replace SC5->C5_BLQ With " "
//		u_DnyGrvSt(SC5->C5_NUM, "000047")
	Endif
	
Return(Nil)
