#include 'protheus.ch'
#include 'parmtype.ch'

//DESENVOLVIDO POR INOVEN


user function ICADA050()

	Local cVldAlt := ".T."
	Local cVldExc := ".T."
	
	U_ITECX010("ICADA050","Cadastro Margem Orcamentos/Pedidos")//Grava detalhes da rotina usada
	
	ZM1->( DbsetOrder(01) )
	AxCadastro("ZM1","Margem Orcamentos/Pedidos",cVldExc,cVldAlt)
	
return
