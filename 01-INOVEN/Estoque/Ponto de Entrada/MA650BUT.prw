#Include 'Protheus.ch'
/*/{Protheus.doc} MA650BUT

MA650BUT - Adiciona itens no menu principal do fonte MATA650
LOCALIZAÇÃO : Function MenuDef() - Responsável pelo menu Funcional.

EM QUE PONTO : Ponto de Entrada 'MA650BUT', utilizado para adicionar itens no menu  principal do fonte MATA650.PRX.
Eventos

@author GoOne Consultoria - Crele Cristia
@since 16/11/2021
@version 1.0
/*/
User Function MA650BUT()
	Local aRotina	:=	PARAMIXB

	//aRotinaX  := {	{'Geracao','U_ITECX150()',0,4,0,NIL},; 
	//				{'Impressao','U_ITECX160()',0,4,0,NIL}	}

	aAdd(aRotina,{'*Impressao Etiq.','U_ITECX160()',0,4,0,NIL})


Return aRotina
