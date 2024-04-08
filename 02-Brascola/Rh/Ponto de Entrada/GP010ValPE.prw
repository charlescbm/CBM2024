#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GP010VALPEºAutor  ³ Marcelo da Cunha   º Data ³  11/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow de aviso de alteracao salarial                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GP010VALPE()
***********************                         
LOCAL aSeg := GetArea(), lRetu := .T., cDir := ""
LOCAL oProcess := Nil, cArquivo := "wfavisosal.htm"
                  
//Coloco a barra no final do parametro do diretorio
///////////////////////////////////////////////////
cDir := Alltrim(GetMV("MV_WFDIR"))
If Substr(cDir,Len(cDir),1) != "\"
	cDir += "\"
Endif         
      
//Verifico se existe o arquivo de workflow
//////////////////////////////////////////
If !File(cDir+cArquivo)
	conout(">>> Nao foi encontrado o arquivo "+cDir+cArquivo)
	Return
Endif

//Verifico se ocorreu aumento de salario
////////////////////////////////////////
If (ALTERA) 
/*
SuperGetMv:
Retorna o conteúdo do parâmetro especificado no arquivo SX6 caso esteja cadastrado, considerando a filial passada nos parâmetros, 
ou se estiver em branco o parâmetro filial, considera a filial atual. O parâmetro consultado pela SuperGetMv é gravado na memória, 
o que permite que em uma nova consulta deste parâmetro retorne o valor utilizado anteriormente( ou caso não exista o parâmetro retorna 
o valor passado como padrão), não sendo necessário acessar ou criar o parâmetro no dicionário de dados. 

 SuperGetMv ( [ cParametro ] [ lHelp ] [ cDefault ] [ cFil ] ) --> cConteudo

 cParametro Caracter Nome do parâmetro do sistema no SX6 a ser pesquisado.    
 lHelp Lógico Se será exibida a mensagem de Help caso o parâmetro não seja encontrado no SX6.     
 cDefault Caracter Conteúdo padrão que será utilizado caso o parâmetro não exista.    
 cFil Caracter Filial onde será consultado o parâmetro. Se em branco, utiliza a filial corrente. 

 Já o getmv apenas verifica se um parâmetro existe no Dicionário de Parâmetros (SX6), ou retorna seu conteúdo dependendo dos parâmetros informados à função.

 GetMv ( cMv_par [ lConsulta ] [ xDefault ] ) --> xConteudo

 cMv_par Caracter Nome do parametro X   
 lConsulta Lógico Se for verdadeiro apenas verifica se o parametro existe. Valor padrão é falso.    
 xDefault Qualquer Valor padrão que deve ser retornado quando o parâmetro não existir. O valor desse parâmetro pode ser Caracter, Numérico, 
 Lógico ou Data. 
*/
	cEmail := Alltrim(SuperGetMV("BR_WFSALAR",.F.,"")) //Lista de E-mails
 	If (Type("M->RA_SALARIO") != "U").and.(M->RA_salario > SRA->RA_salario).and.;
		!Empty(cEmail).and.!Empty(M->RA_dataalt).and.!Empty(M->RA_tipoalt)
		If !TCCanOpen(RetSqlName("SA1"))
			conout("> Erro de acesso ao DATABASE: "+dtoc(MsDate())+" "+Time())
			Return
		Endif
		oProcess := TWFProcess():New("AVISOSAL","> Aviso Alteração Salarial: "+dtoc(MsDate()))
		oProcess:NewTask("100001",cDir+cArquivo)
		oProcess:cSubject := "Aviso Alteração Salarial - "+dtoc(MsDate())
		cEmail := u_BXFormatEmail(cEmail) //Adiciona o Dominio na lista de e-mails
		oProcess:cTo := cEmail
		oProcess:UserSiga := __cUserID
		oProcess:oHtml:ValByName("DATA"    ,dtoc(MsDate()))
		oProcess:oHtml:ValByName("HORA"    ,Time())
		oProcess:oHtml:ValByName("USUARIO" ,UsrFullName(RetCodUsr()))
		oProcess:oHtml:ValByName("FUNC"    ,M->RA_mat+" - "+M->RA_nome)
		oProcess:oHtml:ValByName("SALANT"  ,Transform(SRA->RA_salario,"@E 999,999,999.99"))
		oProcess:oHtml:ValByName("SALNOV"  ,Transform(M->RA_salario,"@E 999,999,999.99"))
		oProcess:oHtml:ValByName("MOTIVO"  ,Alltrim(M->RA_tipoalt)+" - "+Alltrim(Tabela("41",M->RA_tipoalt,.F.)))
		oProcess:oHtml:ValByName("DATAUM"  ,dtoc(M->RA_dataalt))
		oProcess:Start()            
		oProcess:Finish()
	Endif
Endif

//Gravo historico
/////////////////
If (lRetu)
	u_GDVHCompara("SRA")
Endif
          
RestArea(aSeg)

Return lRetu