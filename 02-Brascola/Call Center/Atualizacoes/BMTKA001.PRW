#include "protheus.ch"

User Function BMTKA001()
	
	Local cAlias := "SUC"
	Private cCadastro := "Cadastro de Atendimentos"
	Private aRotina := {}
	Private aFixos := {}
	
	AADD(aRotina,{"Pesquisar" ,"AxPesqui",0,1})
	AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
	AADD(aRotina,{"Incluir" ,"U_Mensagem",0,3})
	AADD(aRotina,{"Manutenção" ,"TK271CallCenter",0,4})
	AADD(aRotina,{"Excluir" ,"U_Mensagem",0,5})
	
	dbSelectArea(cAlias)
	dbSetOrder(1)
	
	aAdd(aFixos,{"Atendimentos","UC_CODIGO"})
	aAdd(aFixos,{"Contatos","UC_CODCONT"})
	aAdd(aFixos,{"Operador","UC_OPERADO"}) 
	aAdd(aFixos,{"Ligação","UC_OPERACA"})  
	aAdd(aFixos,{"Comunicação","UC_TIPO"})
	
	mBrowse(6,1,22,75,cAlias,aFixos)

Return nil
   
User Function Mensagem()
	MsgAlert("Função não permitida!")
Return nil