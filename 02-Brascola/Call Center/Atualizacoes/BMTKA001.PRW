#include "protheus.ch"

User Function BMTKA001()
	
	Local cAlias := "SUC"
	Private cCadastro := "Cadastro de Atendimentos"
	Private aRotina := {}
	Private aFixos := {}
	
	AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
	AADD(aRotina,{"Incluir" ,"U_Mensagem",0,3})
	AADD(aRotina,{"Manuten��o" ,"TK271CallCenter",0,4})
	AADD(aRotina,{"Excluir" ,"U_Mensagem",0,5})
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	aAdd(aFixos,{"Atendimentos","UC_CODIGO"})
	aAdd(aFixos,{"Contatos","UC_CODCONT"})
	aAdd(aFixos,{"Operador","UC_OPERADO"}) 
	aAdd(aFixos,{"Liga��o","UC_OPERACA"})  
	aAdd(aFixos,{"Comunica��o","UC_TIPO"})
	
	mBrowse(6,1,22,75,cAlias,aFixos)

Return nil
   
User Function Mensagem()
	MsgAlert("Fun��o n�o permitida!")
Return nil