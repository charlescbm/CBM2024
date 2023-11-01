#include 'protheus.ch'
#include 'parmtype.ch'

//DESENVOLVIDO POR INOVEN


user function ICADA030()

	Local cVldAlt := ".T."
	Local cVldExc := ".T."
	
	U_ITECX010("ICADA030","Cadastro Grp Carteira")//Grava detalhes da rotina usada
	
	ZAE->( DbsetOrder(01) )
	AxCadastro("ZAE","Grupo de carteira",cVldExc,cVldAlt)
	
	
return
