#include "Protheus.ch"
 
User Function CadPessoa() 

Local oPessoa 
Local oAluno 
Local cNome := "AdvplBrasil" 
Local dNascimento:= (Date() - 30) 
Local nID := 5
 
//aDados := GetDados() 
oPessoa := Pessoa():Create(cNome,dNascimento) 
oAluno := Aluno():Create(nID) 
oAluno := Aluno():Inscrever(nID) 
oAluno := Aluno():Avaliar(nID)
 
Return()  


//criação da classe pessoa 
CLASS Pessoas 
	DATA cNome 
	DATA nIdade
	DATA dNascimento 
	METHOD Create() CONSTRUCTOR 
	METHOD SetNome() 
	METHOD SetIdade() 
ENDCLASS         


//implementação do método construtor 
METHOD Create(cNome, dNascimento) CLASS Pessoas 
	::cNome := cNome 
	::dNascimento := dNascimento 
	::nIdade := CalcIdade(dNascimento) 
Return SELF 
          

//implementação de função CalcIdade() 
STATIC FUNCTION CalcIdade(dNascimento) 
	Local nIdade 
	nIdade := Date() - dNascimento 
RETURN nIdade


//criação da classe Aluno com Herança da classe Pessoa 
CLASS Aluno FROM Pessoas 
	DATA nID 
	DATA aCursos 
	METHOD Create() CONSTRUCTOR 
	METHOD Inscrever()
	METHOD Avaliar() 
ENDCLASS
            
 
//Implementação do construtor  da classe Aluno
METHOD Create(nID) class aluno 
	::nID := nID
Return SELF   

//Implementação do Método Inscrever() da classe Aluno
METHOD Inscrever(nID) class aluno 
	Local nTeste := nID 
	if nTeste == 0
		nTeste := 10
	endif
Return
  
//Implementação do Método Avaliar() da classe Aluno 
METHOD Avaliar(nID) class aluno
	if nId == 10
		Conout("Voce foi Aprovado com Meritos")
	else
		Conout("Voce foi Reprovado")
	endif
Return