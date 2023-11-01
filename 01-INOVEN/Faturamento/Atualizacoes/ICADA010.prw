#include 'protheus.ch'
#include 'parmtype.ch'

//DESENVOLVIDO POR INOVEN


user function ICADA010()

	Local cVldAlt := ".T."
	Local cVldExc := ".T."
	
	U_ITECX010("ICADA010","Cadastro de Coligados")//Grava detalhes da rotina usada
	
	SZ6->( DbsetOrder(01) )
	AxCadastro("SZ6","Cadastro de Coligados",cVldExc,cVldAlt)
	
return
