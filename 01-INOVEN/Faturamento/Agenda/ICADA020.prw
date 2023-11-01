#include 'protheus.ch'
#include 'parmtype.ch'

//DESENVOLVIDO POR INOVEN


user function ICADA020()

	Local cVldAlt := ".T."
	Local cVldExc := ".T."
	
	U_ITECX010("ICADA020","Cadastro Tipos de Agenda")//Grava detalhes da rotina usada
	
	ZAD->( DbsetOrder(01) )
	AxCadastro("ZAD","Tipos de agendas",cVldExc,cVldAlt)
	
return
