#include "Protheus.ch"
                 

User Function CriaHomem()
**********************************************Cria��o do Objeto oHomem instanciando da Classe Homem()******************************************	
	Local oHomem := Homem():New("Roberto")
	
	//usando m�todos e propriedades implementados na Classe Homem
	oHomem:SetCidadeNatal("S�o Paulo")
	oHomem:SetTipoSanguineo("O-")
	oHomem:SetCarro("Golf") 
	Alert("Nome da Pessoa: "+oHomem:Nome) 
	oHomem:Acordar()
	oHomem:Andar()
	oHomem:TirarCarroGaragem()	  	
Return



********************************************Cria��o da Classe Pessoa************************************************************************
Class Pessoa
	Data Nome
	Data CidadeNatal
	Data SetTipoSanguineo
	
	Method New(Nome) Constructor
	Method Acordar()
	Method Andar()
	Method SetCidadeNatal(Cidade)
	Method SetTipoSanguineo(Tipo)
EndClass 


Method New(Nome) Class Pessoa
	::Nome := Nome
Return Self

Method Acordar() Class Pessoa
	Alert("Bom dia!")
Return

Method Andar() Class Pessoa
    Alert("Andando")  	
Return             

Method SetCidadeNatal(Cidade) Class Pessoa
	::CidadeNatal := Cidade
Return                     

Method SetTipoSanguineo(Tipo) Class Pessoa
	::SetTipoSanguineo := Tipo
Return
********************************************************************************************************************************************

  


******************************************Cria��o da Classe Homem - Heran�a da Classe Pessoa************************************************
Class Homem From Pessoa
	Data CarroPreferido
	
	Method New(Nome) Constructor
	Method SetCarro(Carro)
	Method TirarCarroGaragem()
EndClass                      

Method New(Nome) Class Homem
	::Nome := Nome
Return            

Method SetCarro(Carro) Class Homem
	::CarroPreferido := Carro
Return                       

Method TirarCarroGaragem() Class Homem
	Alert("Tirando o carro da garagem..")
Return                                  
********************************************************************************************************************************************
