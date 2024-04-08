#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GP010VALPE�Autor  � Marcelo da Cunha   � Data �  11/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Workflow de aviso de alteracao salarial                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Retorna o conte�do do par�metro especificado no arquivo SX6 caso esteja cadastrado, considerando a filial passada nos par�metros, 
ou se estiver em branco o par�metro filial, considera a filial atual. O par�metro consultado pela SuperGetMv � gravado na mem�ria, 
o que permite que em uma nova consulta deste par�metro retorne o valor utilizado anteriormente( ou caso n�o exista o par�metro retorna 
o valor passado como padr�o), n�o sendo necess�rio acessar ou criar o par�metro no dicion�rio de dados. 

 SuperGetMv ( [ cParametro ] [ lHelp ] [ cDefault ] [ cFil ] ) --> cConteudo

 cParametro Caracter Nome do par�metro do sistema no SX6 a ser pesquisado.    
 lHelp L�gico Se ser� exibida a mensagem de Help caso o par�metro n�o seja encontrado no SX6.     
 cDefault Caracter Conte�do padr�o que ser� utilizado caso o par�metro n�o exista.    
 cFil Caracter Filial onde ser� consultado o par�metro. Se em branco, utiliza a filial corrente. 

 J� o getmv apenas verifica se um par�metro existe no Dicion�rio de Par�metros (SX6), ou retorna seu conte�do dependendo dos par�metros informados � fun��o.

 GetMv ( cMv_par [ lConsulta ] [ xDefault ] ) --> xConteudo

 cMv_par Caracter Nome do parametro X   
 lConsulta L�gico Se for verdadeiro apenas verifica se o parametro existe. Valor padr�o � falso.    
 xDefault Qualquer Valor padr�o que deve ser retornado quando o par�metro n�o existir. O valor desse par�metro pode ser Caracter, Num�rico, 
 L�gico ou Data. 
*/
	cEmail := Alltrim(SuperGetMV("BR_WFSALAR",.F.,"")) //Lista de E-mails
 	If (Type("M->RA_SALARIO") != "U").and.(M->RA_salario > SRA->RA_salario).and.;
		!Empty(cEmail).and.!Empty(M->RA_dataalt).and.!Empty(M->RA_tipoalt)
		If !TCCanOpen(RetSqlName("SA1"))
			conout("> Erro de acesso ao DATABASE: "+dtoc(MsDate())+" "+Time())
			Return
		Endif
		oProcess := TWFProcess():New("AVISOSAL","> Aviso Altera��o Salarial: "+dtoc(MsDate()))
		oProcess:NewTask("100001",cDir+cArquivo)
		oProcess:cSubject := "Aviso Altera��o Salarial - "+dtoc(MsDate())
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