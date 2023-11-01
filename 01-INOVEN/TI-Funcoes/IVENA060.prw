#INCLUDE "Protheus.ch"    
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE NMAXPAGE 50

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PARCOKPITบAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cadastro 					                              บฑฑ
ฑฑบ          ณ  Le parametros para Uso no Calculo do CockPit do vendedor  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑบ          ณ  PERGUNTA:  PERCOCKPIT									  บฑฑ
ฑฑบ          ณ  -Perํodo de datas para Clientes que Nใo Compraram		  บฑฑ
ฑฑบ          ณ		MV_PAR01 Periodo Inicial							  บฑฑ
ฑฑบ          ณ		MV_PAR02 Periodo Final								  บฑฑ
ฑฑบ          ณ  -Perํodo de datas para Clientes com Menores Margens		  บฑฑ
ฑฑบ          ณ		MV_PAR03 Periodo Inicial							  บฑฑ
ฑฑบ          ณ		MV_PAR04 Periodo Final								  บฑฑ
ฑฑบ          ณ  -Codigo da CFOP da Nota Fiscal da Amostra Clientes 		  บฑฑ
ฑฑบ          ณ		MV_PAR05 Codigo da CFOP ENTRADA/SAIDA				  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑบ          ณ  PARAMETRO:  PDHCOCKPIT									  บฑฑ
ฑฑบ          ณ  -Data e Hora Atualizada da Ultima Grava็ใo do CockPit	  บฑฑ
ฑฑบ          ณ		MV_COCPITD - Data									  บฑฑ
ฑฑบ          ณ		MV_COCPITH - Hora									  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//DESENVOLVIDO POR INOVEN

User Function PARCOCKPIT()
                      
Local alSays		:= {}
Local clTitulo		:= ""
Local alButtons	    := {}
Local cPerg			:= ""
Local lPergOk		:= .F.
Local aArea 		:= GetArea()

//Cria os parametros de data e hora na tabela SX6 - 
FUPDSX6()


//Cria as perguntas para o cockpit
cPerg := Padr("PERCOCKPIT",10)
U_FUPDSX1(cPerg)

Pergunte(cPerg, .F.)

aAdd(alSays,"Esta  rotina  tem  como  funcionalidade  ler e gravar os parametros para o calculo das")
aAdd(alSays,"metas gerando os registros que serใo visualizados no Cockpit do vendedor.			   ")

aAdd(alButtons, { 5,.T.,{|| lPergOk := Pergunte(cPerg,.T. ) 	}} )
aAdd(alButtons, { 1,.T.,{|| Iif(u_CALCOCKPIT(lPergOk),FechaBatch(),Nil) 	}} )
aAdd(alButtons, { 2,.T.,{|| FechaBatch() }} )

/*
	aAdd(alButtons, { 5,.T.,{|| lpPrgOk := Pergunte(cpPerg,.T. ) 	}} )
	aAdd(alButtons, { 1,.T.,{|| Iif(FCTBPBB(),FechaBatch(),Nil) 	}} )
	aAdd(alButtons, { 2,.T.,{|| FechaBatch() 					
*/

FormBatch( clTitulo, alSays, alButtons )

RestArea(aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUPDSX1   บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE ATUALIZA A TABELA SX1 COM AS PERGUNTAS DO PROCES-บฑฑ
ฑฑบ          ณSAMENTO DA ROTINA DE CONTABILIZAวรO OFF-LINE CASO ELAS NรO  บฑฑ
ฑฑบ          ณEXISTAM.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FUPDSX1(cPerg)                        

Local alRegs	:= {}
Local nlI		:= 1
Local nlJ		:= 1

aAdd(alRegs,{cPerg,"01","Dt.In. Cliente Nao Compraram ?"," "," ","MV_CH1","D", 08,0,0,"G","NaoVazio(MV_PAR01)                         ","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(alRegs,{cPerg,"02","Dt.Fim Cliente Nao Compraram ?"," "," ","MV_CH2","D", 08,0,0,"G","NaoVazio(MV_PAR02) .And. MV_PAR02>=MV_PAR01","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(alRegs,{cPerg,"03","Dt.In. Cliente C/Menor Margem?"," "," ","MV_CH3","D", 08,0,0,"G","NaoVazio(MV_PAR03)                         ","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(alRegs,{cPerg,"04","Dt.Fim Cliente C/Menor Margem?"," "," ","MV_CH4","D", 08,0,0,"G","NaoVazio(MV_PAR04) .And. MV_PAR04>=MV_PAR03","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(alRegs,{cPerg,"05","CFOP Amostras Clientes(E/S)?  "," "," ","MV_CH5","C", 60,0,0,"G","NaoVazio(MV_PAR05)                         ","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(alRegs,{cPerg,"06","Prz Pedidos em Casa P/Estoque?"," "," ","MV_CH6","C", 03,0,0,"G","NaoVazio(MV_PAR06)                         ","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

DbSelectArea("SX1")
DbSetOrder(1)

For nlI := 1 to Len(alRegs)

	If !DbSeek(cPerg+alRegs[nlI,2])

		If RecLock("SX1",.T.)

			For nlJ :=1 to FCount()

				FieldPut(nlJ,alRegs[nlI,nlJ])

			Next nlJ

			SX1->(MsUnlock())
			DbCommit()

		EndIf

	Endif

Next nlI

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUPDSX6 บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE ATUALIZA A TABELA SX6 CRIANDO OS PARAMETROS	  บฑฑ
ฑฑบ          ณ 		 DE DATA E HORA DA ULTIMA GRAVACAO DO COCKPIT DO 	  บฑฑ
ฑฑบ          ณ 		 VENDEDOR			                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FUPDSX6()

Local aEstrut	:= {}
Local aSX6		:= {}
Local nI		:= 0
Local nJ		:= 0

aEstrut:= { "X6_FIL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1","X6_DSCENG1",;
			"X6_DESC2","X6_DSCSPA2","X6_DSCENG2","X6_CONTEUD","X6_CONTSPA","X6_CONTENG","X6_PROPRI","X6_PYME"}

Aadd(aSX6,{ xFilial("SX6"), "MV_COCPITD","C","Data da Ultima Gravacao?","","","" ,"","","","","","","","","U","S"})
Aadd(aSX6,{ xFilial("SX6"), "MV_COCPITH","C","Hora da Ultima Gravacao?","","","" ,"","","","","","","","","U","S"})

dbSelectArea("SX6")
dbSetOrder(1)
For nI	:= 1 To Len(aSX6)
	If !Empty(aSX6[nI][2])
		If !dbSeek(aSX6[nI,1]+aSX6[nI,2])
			RecLock("SX6",.T.)
			For nJ:=1 To Len(aSX6[nI])
				If !Empty(FieldName(FieldPos(aEstrut[nJ])))
					FieldPut(FieldPos(aEstrut[nJ]),aSX6[nI,nJ])
				EndIf
			Next nJ
	  
			dbCommit()        
			MsUnLock()
		EndIf
	EndIf
Next nI

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUPCOCSX6 บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE ATUALIZA A TABELA SX6 COM OS PARAMETROS DA ULTIMAบฑฑ
ฑฑบ          ณGRAVACAO DO COCKPIT DO VENDEDOR							  บฑฑ
ฑฑบ          ณ 			                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FUPCOCSX6(cParam, cConteudo)

dbSelectArea("SX6")
dbSetOrder(1)

dbSeek( xFilial("SX6") + &('"'+ cParam +'"') )
RecLock("SX6",.F.)
X6_CONTEUD := cConteudo				// Atualiza a Data da Ultima Grava็ใo do CockPit do Vendedor
MsUnLock()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCALCOCKPITบAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE CALCULA AS METAS E ATUALIZA O COCKPIT QUE SERA   บฑฑ
ฑฑบ          ณVISUALIZADO PELOS VENDEDORES								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CalCockpit(lPergOk)
Local	cPerg			:= Padr("PERCOCKPIT",10)
Local	lRet			:= .F.
Local	aArea			:= GetArea()
Private dCockPitD		:= CToD("  /  /  ")
Private cCockPitH		:= ""
Private cDtProc			:= Iif(.F.,"GETDATE()","'"+Dtos(ddatabase)+"'")

lPergOk	:= If( Type("lPergOk") == "U", .F., lPergOk )

If !lPergOk

	DbSelectArea("SX1")
	DbSetOrder(1)

	If DbSeek(cPerg)
		
		Pergunte(cPerg, .F.)
		lRet := .T.

		If	Empty(mv_par01) .Or. ;
			Empty(mv_par02) .Or. ;
			Empty(mv_par03) .Or. ;
			Empty(mv_par04) .Or. ;
			Empty(mv_par05)

				lRet := Pergunte(cPerg, .T.)

		Endif
		
	Else
		
		//Cria as perguntas, caso elas nใo existam na tabela SX1
		U_FUPDSX1(cPerg)

		lRet := Pergunte(cPerg, .T.)

	Endif

Else

	lRet := Pergunte(cPerg, .T.)

Endif

If lRet

	If	Empty(mv_par01) .Or. ;
		Empty(mv_par02) .Or. ;
		Empty(mv_par03) .Or. ;
		Empty(mv_par04) .Or. ;
		Empty(mv_par05)

		ConOut(" Parametros do Cockpit do Vendedor NAO PREENCHIDOS ou NAO CRIADOS ")

		lRet := .F.
		
	Else

			FUPDSX6()  								// Cria os parametros Data e Hora no  SX6
			dCockPitD		:= dDatabase         	// Data a Ser utilizada na Grava็ใo do CockPit
			cCockPitH		:= Substr(Time(),1,5)	// Hora a Ser utilizada na Grava็ใo do CockPit

			// Calcula as Metas e Grava os Arquivos...
			CMetCal1("Z14", "Z08")	// Meta Z08	-  Itens SKU e SKU Produto
		   	CMetCal1("Z15", "Z09")	// Meta Z09	-  Itens SKU e SKU Produto
			CMetCal1("Z16", "Z10")	// Meta Z10	-  Clientes Atendidos
			CMetCal1("Z17", "Z11")	// Meta Z11	-  Categoria
			CMetCal1("Z18", "Z12")	// Meta Z12	-  Linha de Produtos
			CMetCal1("Z19", "Z13")	// Meta Z13	-  Celulas			
			CCliMMa("Z22")			// Clientes com Menores Margens
			CCliQNC("Z21")			// Clientes Que Ainda Nใo Compraram
			CProAmo("Z20")			// Amostras

			FUPCOCSX6("MV_COCPITD", DToS(dCockPitD))	// Atualiza os Parametros da Data utilizada na Grava็ใo do CockPit
			FUPCOCSX6("MV_COCPITH", cCockPitH)			// Atualiza os Parametros da Hora utilizada na Grava็ใo do CockPit

	Endif

Endif

RestArea(aArea)                                                                    

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCMETCAL1 บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE CALCULA AS METAS                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR Z14		                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CMetCal1(cAliasCok, cAliasMeta)    // cAliasCok = Arquivo do CockPit (Z14 a Z19) // cAliasMeta = cadastro de Metas (Z08 a Z13)
Local cQuery1 		:= ""
Local cEol			:= chr(13)+chr(10)
Local cTipoAnt		:= ""
Local aAreaZ 		:= (cAliasMeta)->(GetArea())
Private cAliasTRB	:= GetNextAlias()		  // Registro Faturamento para calcular as Metas
Private cAliasMT	:= GetNextAlias()         // SELECIONO OS REGISTROS VALIDOS DAS METAS A SEREM CALCULADAS

If cAliasMeta == "Z09"

	cQuery1 := " SELECT Z09.Z09_COD, Z09.Z09_CODCEL, Z09.Z09_CODPRO, Z09.R_E_C_N_O_ AS Z09_NREG, Z08.Z08_TIPO AS Z09_TIPO FROM " +RetSqlName("Z09")+ " AS Z09 " + cEol
	cQuery1 += " LEFT JOIN " +RetSqlName("Z08")+ " AS Z08 "+ cEol
	cQuery1 += " ON '" +xFilial("Z08")+ "' = Z08.Z08_FILIAL AND Z08.Z08_COD = Z09.Z09_COD AND Z08.Z08_CODCEL = Z09.Z09_CODCEL AND "+cDtProc+" BETWEEN Z08.Z08_VALINI AND Z08.Z08_VALFIM AND Z08.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " WHERE Z09.D_E_L_E_T_ = ' ' AND '" +xFilial("Z09")+ "' = Z09.Z09_FILIAL " + cEol
	cQuery1 += " ORDER BY Z09.Z09_COD, Z09.Z09_CODCEL, Z08.Z08_TIPO"

ElseIf cAliasMeta == "Z11"

	cQuery1 := " SELECT Z11.Z11_CODCEL, Z11.Z11_GRUPO, Z11.R_E_C_N_O_ AS Z11_NREG, Z11.Z11_TIPO FROM " +RetSqlName("Z11")+ " AS Z11 " + cEol
	cQuery1 += " WHERE Z11.D_E_L_E_T_ = ' ' AND '" +xFilial("Z11")+ "' = Z11.Z11_FILIAL  AND "+cDtProc+" BETWEEN Z11.Z11_VALINI AND Z11.Z11_VALFIM " + cEol
	cQuery1 += " ORDER BY Z11.Z11_CODCEL, Z11.Z11_TIPO"

ElseIf cAliasMeta == "Z12"

	cQuery1 := " SELECT Z12.Z12_CODCEL, Z12.Z12_FPCOD, Z12.R_E_C_N_O_ AS Z12_NREG, Z12.Z12_TIPO FROM " +RetSqlName("Z12")+ " AS Z12 " + cEol
	cQuery1 += " WHERE Z12.D_E_L_E_T_ = ' ' AND '" +xFilial("Z12")+ "' = Z12.Z12_FILIAL  AND "+cDtProc+" BETWEEN Z12.Z12_VALINI AND Z12.Z12_VALFIM " + cEol
	cQuery1 += " ORDER BY Z12.Z12_CODCEL, Z12.Z12_TIPO"

Else

	cQuery1 := " SELECT "+ cAliasMeta +"."+ cAliasMeta +"_TIPO, "+ cAliasMeta +"."+ cAliasMeta + "_CODCEL, "+ cAliasMeta + ".R_E_C_N_O_ AS "+ cAliasMeta + "_NREG FROM "+RetSqlName(cAliasMeta)+ " AS " + cAliasMeta + " " + cEol
	cQuery1 += " WHERE "+ cAliasMeta +".D_E_L_E_T_ = ' ' AND '"+xFilial(cAliasMeta)+"' = "+ cAliasMeta +"."+ cAliasMeta +"_FILIAL AND "+cDtProc+" BETWEEN "+ cAliasMeta +"."+ cAliasMeta +"_VALINI AND "+ cAliasMeta +"."+ cAliasMeta +"_VALFIM " + cEol
	cQuery1 += " ORDER BY "+ cAliasMeta +"."+ cAliasMeta +"_TIPO, "+ cAliasMeta +"."+ cAliasMeta +"_CODCEL "

Endif

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery1),cAliasMT,.F.,.T.)

DbSelectArea(cAliasMT)
dbGoTop()
While (cAliasMT)->(!Eof())

	If cTipoAnt <> &(cAliasMT + "->" + cAliasMeta + "_TIPO")
	
		If Select(cAliasTRB) > 0

		    (cAliasTRB)->(DbCloseArea())

		Endif
		
		cTipoAnt := &(cAliasMT + "->" + cAliasMeta + "_TIPO")
		
		FMCOKSQL(&(cAliasMT + "->" + cAliasMeta + "_TIPO"), cAliasMeta)

	Endif

	(cAliasTRB)->(dbGoTop())
	
		//Se a query retornar algum resultado, executa o processamento.
	If (cAliasTRB)->(!Eof()) .And. (cAliasTRB)->(!Bof())
			
    	ConOut(" Gerando Lan็amentos Metas - FEXECOK  -  " + cAliasCok + " - " + cAliasMeta)
		FEXECOK(cAliasCok, cAliasMeta)
		//MsgRun("Gerando Lan็amentos Metas...",,{|| FEXECOK(cAliasCok, cAliasMeta) } ) 
								
		//Se a query nใo retornar nenhum resultado, ้ exibida uma tela informativa para o usuแrio.
	ElseIf (cAliasTRB)->(Eof()) .And. (cAliasTRB)->(Bof())
			
		ConOut(" Consulta vazia - O filtro efetuado com os parโmetros preenchidos nใo consistiram em nenhum registro da Meta: "+cAliasMeta)
			
	EndIf
			
	(cAliasMT)->(dbSkip())

End

If Select(cAliasTRB) > 0

    (cAliasTRB)->(DbCloseArea())

Endif

(cAliasMT)->(DbCloseArea())

RestArea(aAreaZ)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFMCOKSQL  บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE APLICA A QUERY SQL E GERA O ARQUIVO TEMPORARIO   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FMCOKSQL(cTipo, cAliasZ)
Local cQuery1	:= ""
Local cEol		:= chr(13)+chr(10)
Local cMS		:= If(cTipo == "M", "MONTH", "WEEK")
Local cCMS		:= If(cTipo == "M", "MES",   "SEMANA")
Local cCondMS	:= "= '"+ cTipo + "' "
//Local cIndCond	:= ""
//Local cNomInd	:= CriaTrab(Nil,.F.)

If cAliasZ == "Z08"

	cQuery1 := "SELECT Z08.Z08_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO) AS "+ cCMS + ", SD2.D2_COD FROM "+RetSqlName("SD2")+ " AS SD2 " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+ " AS SA1 " + cEol
	cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' '" + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("Z08")+ " AS Z08 " + cEol
	cQuery1 += " ON '" + xFilial("Z08") + "' = Z08.Z08_FILIAL AND Z08.Z08_CODCEL = SA1.A1_CELULA AND "+cDtProc+" BETWEEN Z08.Z08_VALINI AND Z08.Z08_VALFIM AND Z08.D_E_L_E_T_ = ' '" + cEol
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' ' AND '" +xFilial("SD2")+ "' = SD2.D2_FILIAL AND SD2.D2_EMISSAO BETWEEN Z08.Z08_VALINI AND Z08.Z08_VALFIM AND Z08.Z08_TIPO "+ cCondMS + cEol
	cQuery1 += " GROUP BY Z08.Z08_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SD2.D2_COD" + cEol
	cQuery1 += " ORDER BY Z08.Z08_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SD2.D2_COD"

ElseIf cAliasZ == "Z09"

	cQuery1 := " SELECT Z09.Z09_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO) AS "+ cCMS + ", SD2.D2_COD, ISNULL(SUM(D2_QUANT),0) AS Z09_QTDE FROM "+RetSqlName("SD2")+ " AS SD2 " + cEol
	cQuery1 += " LEFT JOIN " +RetSqlName("SA1")+ " AS SA1 " + cEol
	cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " LEFT JOIN " +RetSqlName("Z08")+ " AS Z08 " + cEol
	cQuery1 += " ON '" + xFilial("Z08") + "' = Z08.Z08_FILIAL AND Z08.Z08_CODCEL = SA1.A1_CELULA AND "+cDtProc+" BETWEEN Z08.Z08_VALINI AND Z08.Z08_VALFIM AND Z08.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " LEFT JOIN " +RetSqlName("Z09")+ " AS Z09 " + cEol
	cQuery1 += " ON '" + xFilial("Z09") + "' = Z09.Z09_FILIAL AND LTRIM(RTRIM(Z09.Z09_COD)) = LTRIM(RTRIM(Z08.Z08_COD)) AND Z09.Z09_CODCEL = Z08.Z08_CODCEL  AND Z09.D_E_L_E_T_ = ' ' "+ cEol
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' ' AND '" + xFilial("SD2") + "' = SD2.D2_FILIAL AND SD2.D2_TIPO = 'N' AND SD2.D2_EMISSAO BETWEEN Z08.Z08_VALINI AND Z08.Z08_VALFIM AND Z08.Z08_TIPO "+ cCondMS + " AND LTRIM(RTRIM(SD2.D2_COD)) = LTRIM(RTRIM(Z09.Z09_CODPRO)) " + cEol
	cQuery1 += " GROUP BY Z09.Z09_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SD2.D2_COD " + cEol
	cQuery1 += " ORDER BY Z09.Z09_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SD2.D2_COD "

ElseIf cAliasZ == "Z10"

	cQuery1 := " SELECT Z10.Z10_CODCEL, DATEPART("+ cMS + ",SF2.F2_EMISSAO) AS "+ cCMS + ", SF2.F2_CLIENTE FROM "+RetSqlName("SF2")+ " AS SF2 " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+ " AS SA1 " + cEol
	cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("Z10")+ " AS Z10 " + cEol
	cQuery1 += " ON '" + xFilial("Z10") + "' = Z10.Z10_FILIAL AND Z10.Z10_CODCEL = SA1.A1_CELULA AND "+cDtProc+" BETWEEN Z10.Z10_VALINI AND Z10.Z10_VALFIM  AND Z10.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " WHERE SF2.D_E_L_E_T_ = ' ' AND '" + xFilial("SF2") + "' = SF2.F2_FILIAL AND SF2.F2_TIPO = 'N' AND SF2.F2_EMISSAO BETWEEN Z10.Z10_VALINI AND Z10.Z10_VALFIM AND Z10.Z10_TIPO "+ cCondMS + cEol
	cQuery1 += " GROUP BY Z10.Z10_CODCEL, DATEPART("+ cMS + ",SF2.F2_EMISSAO), SF2.F2_CLIENTE " + cEol
	cQuery1 += " ORDER BY Z10.Z10_CODCEL, DATEPART("+ cMS + ",SF2.F2_EMISSAO), SF2.F2_CLIENTE "

ElseIf cAliasZ == "Z11"

	cQuery1 := " SELECT Z11.Z11_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO) AS "+ cCMS + ", SUBSTRING(SD2.D2_GRUPO,1,2)+ '00' AS D2_GRUPO, ISNULL(SUM(SD2.D2_TOTAL),0) AS Z11_QTDE FROM " +RetSqlName("SD2")+ " AS SD2 " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+ " AS SA1 " + cEol
	cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("Z11")+ " AS Z11 " + cEol
	cQuery1 += " ON '" + xFilial("Z11") + "' = Z11.Z11_FILIAL AND Z11.Z11_CODCEL = SA1.A1_CELULA AND "+cDtProc+" BETWEEN Z11.Z11_VALINI AND Z11.Z11_VALFIM  AND Z11.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' '  AND '" + xFilial("SD2") + "' = SD2.D2_FILIAL  AND SD2.D2_TIPO = 'N' AND SD2.D2_EMISSAO BETWEEN Z11.Z11_VALINI AND Z11.Z11_VALFIM AND Z11.Z11_TIPO "+ cCondMS + " AND SUBSTRING(SD2.D2_GRUPO,1,2) = SUBSTRING(Z11.Z11_GRUPO,1,2) " + cEol
	cQuery1 += " GROUP BY Z11.Z11_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SUBSTRING(SD2.D2_GRUPO,1,2) " + cEol
	cQuery1 += " ORDER BY Z11.Z11_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SUBSTRING(SD2.D2_GRUPO,1,2) "

ElseIf cAliasZ == "Z12"

	cQuery1 := " SELECT Z12.Z12_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO) AS "+ cCMS + ", SB1.B1_CATE, ISNULL(SUM(SD2.D2_TOTAL),0) AS Z12_QTDE FROM " +RetSqlName("SD2")+ " AS SD2 " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+ " AS SA1 " + cEol
	cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "  + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("SB1")+ " AS SB1 " + cEol
	cQuery1 += " ON '" + xFilial("SB1") + "' = SB1.B1_FILIAL AND LTRIM(RTRIM(SD2.D2_COD)) = LTRIM(RTRIM(SB1.B1_COD)) AND SB1.D_E_L_E_T_ = ' ' " + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("Z12")+ " AS Z12 " + cEol
	cQuery1 += " ON '" + xFilial("Z12") + "' = Z12.Z12_FILIAL AND Z12.Z12_CODCEL = SA1.A1_CELULA AND "+cDtProc+" BETWEEN Z12.Z12_VALINI AND Z12.Z12_VALFIM  AND Z12.D_E_L_E_T_ = ' ' AND SUBSTRING(SB1.B1_CATE,1,2) = SUBSTRING(Z12.Z12_FPCOD,1,2) " + cEol
	cQuery1 += " WHERE SD2.D_E_L_E_T_ = ' '  AND '" + xFilial("SD2") + "' = SD2.D2_FILIAL  AND SD2.D2_TIPO = 'N' AND SD2.D2_EMISSAO BETWEEN Z12.Z12_VALINI AND Z12.Z12_VALFIM AND Z12.Z12_TIPO "+ cCondMS + cEol
	cQuery1 += " GROUP BY Z12.Z12_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SB1.B1_CATE " + cEol
	cQuery1 += " ORDER BY Z12.Z12_CODCEL, DATEPART("+ cMS + ",SD2.D2_EMISSAO), SB1.B1_CATE "

ElseIf cAliasZ == "Z13"

	cQuery1 := " SELECT Z13.Z13_CODCEL, DATEPART("+ cMS + ",SF2.F2_EMISSAO) AS "+ cCMS + ", ISNULL(SUM(F2_VALMERC),0) AS Z13_QTDE FROM "+RetSqlName("SF2")+ " AS SF2 "  + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("SA1")+ " AS SA1 " + cEol
	cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "  + cEol
	cQuery1 += " LEFT JOIN "+RetSqlName("Z13")+ " AS Z13 " + cEol
	cQuery1 += " ON '" + xFilial("Z13") + "' = Z13.Z13_FILIAL AND Z13.Z13_CODCEL = SA1.A1_CELULA AND "+cDtProc+" BETWEEN Z13.Z13_VALINI AND Z13.Z13_VALFIM  AND Z13.D_E_L_E_T_ = ' ' "  + cEol
	cQuery1 += " WHERE SF2.D_E_L_E_T_ = ' ' AND '" + xFilial("SF2") + "' = SF2.F2_FILIAL AND SF2.F2_TIPO = 'N' AND SF2.F2_EMISSAO BETWEEN Z13.Z13_VALINI AND Z13.Z13_VALFIM AND Z13.Z13_TIPO "+ cCondMS + cEol
	cQuery1 += " GROUP BY Z13.Z13_CODCEL, DATEPART("+ cMS + ",SF2.F2_EMISSAO) "  + cEol
	cQuery1 += " ORDER BY Z13.Z13_CODCEL, DATEPART("+ cMS + ",SF2.F2_EMISSAO) " 

EndIf

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery1),cAliasTRB,.F.,.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFEXECOK   บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GERA O ARQUIVO Z?? DO COCKPIT					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FEXECOK(cAliasCOK, cAliasMeta)
Local cTipo		:= &(cAliasMT + "->" + cAliasMeta + "_TIPO")
Local cPeriodo	:= "  "
Local nCalc		:= 0
Local nAcum		:= 0
Local cCMS		:= If(cTipo == "M", "MES",   "SEMANA")
Local cItem		:= If(cAliasMeta == "Z09", "Z09->Z09_CODPRO", If(cAliasMeta == "Z11", "Z11->Z11_GRUPO", If(cAliasMeta == "Z12", "Z12->Z12_FPCOD", "NIL")))
Local cCond		:= "" 
Local cCond2	:= "" 

If		cAliasMeta == "Z09"

     		cCond 	:= "ALLTRIM(Z09->Z09_CODPRO) == ALLTRIM(" + cAliasTRB +"->D2_COD)"
     		cCond2	:= "ALLTRIM("+ cAliasMT + "->Z09_CODPRO) == ALLTRIM(" + cAliasCOK +"->"+ cAliasCOK + "_ITEM)"

ElseIf	cAliasMeta == "Z11"

     		cCond	:= "Z11->Z11_GRUPO == " +  cAliasTRB +"->D2_GRUPO"
     		cCond2	:= cAliasMT + "->Z11_GRUPO == " +  cAliasCOK +"->"+ cAliasCOK + "_ITEM"

ElseIf	cAliasMeta == "Z12"

			cCond	:= "Z12->Z12_FPCOD == " +  cAliasTRB +"->B1_CATE"
     		cCond2	:= cAliasMT + "->Z12_FPCOD == " +  cAliasCOK +"->"+ cAliasCOK + "_ITEM"

Else

			cCond	:= ".T."
			cCond2	:= ".T."
			
Endif			

DbSelectArea(cAliasMeta)
(cAliasMeta)->(dbGoTo( &(cAliasMT + "->" + cAliasMeta + "_NREG") ) )

DbSelectArea(cAliasTRB)
(cAliasTRB)->(dbGotop())

While (cAliasTRB)->(!Eof())

	While (cAliasTRB)->(!Eof()) .and. &(cAliasTRB + "->" + cAliasMeta + "_CODCEL") <> &(cAliasMeta + "->" + cAliasMeta + "_CODCEL")

		nAcum := 0
		(cAliasTRB)->(dbSkip())

	End

	nCalc		:= 0
	cPeriodo	:= &(cAliasTRB + "->" + cCMS)
		
	While (cAliasTRB)->(!Eof()) .and. &(cAliasTRB + "->" + cAliasMeta + "_CODCEL") == &(cAliasMeta + "->" + cAliasMeta + "_CODCEL") .and. cPeriodo == &(cAliasTRB + "->" +cCMS) 
	
		if ! &(cCond)

			(cAliasTRB)->(dbSkip())
			Loop

		Endif

		If		cAliasMeta $ "|Z08|Z10|"

					nCalc ++

		ElseIf	cAliasMeta $ "|Z09|Z11|Z12|Z13|"          

					nCalc += &(cAliasTRB + "->" + cAliasMeta + "_QTDE")

		EndIf
			
		(cAliasTRB)->(dbSkip())
	
	End                                                          

	(cAliasCOK)->(RecLock(cAliasCOK,.T.))
		
	&(cAliasCOK + "->" + cAliasCOK + "_FILIAL")	:= xFilial(cAliasCOK)
	&(cAliasCOK + "->" + cAliasCOK + "_CODCEL")	:= &(cAliasMeta + "->" + cAliasMeta + "_CODCEL")
	&(cAliasCOK + "->" + cAliasCOK + "_TIPO")	:= cTipo
	&(cAliasCOK + "->" + cAliasCOK + "_PERIOD")	:= StrZero(cPeriodo, 2)

	If	cAliasMeta $ "|Z09|Z11|Z12|"

	  		&(cAliasCOK + "->" + cAliasCOK + "_ITEM")	:= &(cItem)

	Endif

	&(cAliasCOK + "->" + cAliasCOK + "_QTDE")	:= &(cAliasMeta + "->" + cAliasMeta + "_QTDE") + nAcum
	&(cAliasCOK + "->" + cAliasCOK + "_REAL")	:= nCalc
	&(cAliasCOK + "->" + cAliasCOK + "_DATA")	:= dCockPitD
	&(cAliasCOK + "->" + cAliasCOK + "_HORA")	:= cCockPitH
	
	(cAliasCOK)->(MsUnlock())
		
	If nCalc < &(cAliasMeta + "->" + cAliasMeta + "_QTDE") + nAcum .and. cTipo == "C"
		
		nAcum := &(cAliasMeta + "->" + cAliasMeta + "_QTDE") - nCalc + nAcum

	Else

		nAcum := 0		

	Endif	

	If nCalc = 0

		Exit

	Endif

End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCPROAMO   บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GERA O ARQUIVO Z20 (AMOSTRAS) DO COCKPIT DO	  บฑฑ
ฑฑบ          ณ       VENDEDOR.                                      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CPROAMO(cAliasCOK)
Local	cQuery1		:= ""
Local	cEol		:= chr(13)+chr(10)
Local	aAreaZ		:= GetArea()
Private	cAliasTRB	:= GetNextAlias()		  // Registro Faturamento para Gravar os Registros das Amostras Nใo Encerradas e Sem Retorno

cQuery1 := " SELECT SA1.A1_CELULA, SD2.D2_COD, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_QUANT, SD2.D2_QUANT*SD2.D2_PRUNIT AS D2_VALOR, SD2.D2_EMISSAO " + cEol
cQuery1 += " FROM " +RetSqlName("SD2")+ " AS SD2 " + cEol
cQuery1 += " LEFT JOIN " +RetSqlName("SA1")+ " AS SA1 " + cEol
cQuery1 += " ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + cEol
cQuery1 += " WHERE '" + xFilial("SD2") + "' = SD2.D2_FILIAL AND SD2.D2_BAMOST = 'F' AND SD2.D_E_L_E_T_ = ' ' AND SD2.D2_BMOTIVO IS NULL " + cEol
cQuery1 += " AND SD2.D2_CF IN (" +AllTrim(mv_par05)+ ") AND SD2.D2_TIPO = 'N' " + cEol
cQuery1 += " ORDER BY SA1.A1_CELULA, D2_VALOR DESC, D2_DOC, D2_SERIE "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery1),cAliasTRB,.F.,.T.)
dbGoTop()

	//Se a query retornar algum resultado, executa o processamento.
If (cAliasTRB)->(!Eof()) .And. (cAliasTRB)->(!Bof())
		
    ConOut(" Gerando Lan็amentos Amostras - FEXEAMO")
	FEXEAMO(cAliasCok)
//	MsgRun("Gerando Lan็amentos Amostras...",,{|| FEXEAMO(cAliasCok) } ) 
							
	//Se a query nใo retornar nenhum resultado, ้ exibida uma tela informativa para o usuแrio.
ElseIf (cAliasTRB)->(Eof()) .And. (cAliasTRB)->(Bof())
		
	ConOut(" Consulta vazia - O filtro efetuado com os parโmetros preenchidos nใo consistiram em nenhum registro de Amostras")
		
EndIf
		
(cAliasTRB)->(DbCloseArea())

RestArea(aAreaZ)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCEXEAMO   บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GRAVA O ARQUIVO Z20 (AMOSTRAS) DO COCKPIT DO	  บฑฑ
ฑฑบ          ณ       VENDEDOR.                                      	  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FEXEAMO(cAliasCOK)

While (cAliasTRB)->(!Eof())

	(cAliasCOK)->(RecLock(cAliasCOK,.T.))
		
	&(cAliasCOK + "->" + cAliasCOK + "_FILIAL")	:= xFilial(cAliasCOK)
	&(cAliasCOK + "->" + cAliasCOK + "_CODCEL")	:= &(cAliasTRB + "->A1_CELULA")
	&(cAliasCOK + "->" + cAliasCOK + "_COD")	:= &(cAliasTRB + "->D2_COD")
	&(cAliasCOK + "->" + cAliasCOK + "_DOC")	:= &(cAliasTRB + "->D2_DOC")
	&(cAliasCOK + "->" + cAliasCOK + "_SERIE")	:= &(cAliasTRB + "->D2_SERIE")
	&(cAliasCOK + "->" + cAliasCOK + "_QUANT")	:= &(cAliasTRB + "->D2_QUANT")
	&(cAliasCOK + "->" + cAliasCOK + "_VALOR")	:= &(cAliasTRB + "->D2_VALOR")
	&(cAliasCOK + "->" + cAliasCOK + "_EMISSA")	:= SToD( &(cAliasTRB + "->D2_EMISSAO") )
	&(cAliasCOK + "->" + cAliasCOK + "_DATA")	:= dCockPitD
	&(cAliasCOK + "->" + cAliasCOK + "_HORA")	:= cCockPitH
	
	(cAliasCOK)->(MsUnlock())

	(cAliasTRB)->(dbSkip())

End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCLIQNC   บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GERA O ARQUIVO Z21 (CLIENTES QUE NAO COMPRARAM)  บฑฑ
ฑฑบ          ณ  DO COCKPIT DO VENDEDOR.                               	  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑบ          ณ  UTILIZA SX1->PERGUNTA:  PERCOCKPIT						  บฑฑ
ฑฑบ          ณ  -Perํodo de datas para Clientes que Nใo Compraram		  บฑฑ
ฑฑบ          ณ		MV_PAR01 Periodo Inicial							  บฑฑ
ฑฑบ          ณ		MV_PAR02 Periodo Final								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCLIQNC(cAliasCOK)
Local	cQuery1		:= ""
Local	cEol		:= chr(13)+chr(10)
Local	aAreaZ		:= GetArea()
Private	cAliasTRB	:= GetNextAlias()		  // Registro Faturamento para Gravar os Registros dos Clientes que nao compraram

cQuery1 := " SELECT SA1.A1_CELULA, TRB_CLIENTE, TRB_VALOR  FROM " + cEol
cQuery1 += "        (SELECT SF2.F2_CLIENTE AS TRB_CLIENTE, SF2.F2_LOJA AS TRB_LOJA, ISNULL( SUM(SF2.F2_VALMERC), 0) AS TRB_VALOR " + cEol
cQuery1 += "         FROM " +RetSqlName("SF2")+ " AS SF2 " + cEol
cQuery1 += "         WHERE '" + xFilial("SF2") + "' = SF2.F2_FILIAL AND SF2.F2_TIPO = 'N' AND SF2.F2_EMISSAO BETWEEN " +DToS(MV_PAR01)+ " AND " +DToS(MV_PAR02)+ " "+ cEol
cQuery1 += "         GROUP BY SF2.F2_CLIENTE, SF2.F2_LOJA) AS TRB "+ cEol
cQuery1 += " LEFT JOIN " +RetSqlName("SA1")+ " AS SA1 ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND TRB_CLIENTE = SA1.A1_COD AND TRB_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "+ cEol
cQuery1 += " WHERE (NOT EXISTS (SELECT * FROM " +RetSqlName("SF2")+ " As SF2 WHERE '" + xFilial("SF2") + "' = SF2.F2_FILIAL AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SF2.F2_TIPO = 'N' AND SF2.F2_EMISSAO > " +DToS(MV_PAR02)+ ")) "+ cEol
cQuery1 += " GROUP BY SA1.A1_CELULA, TRB_CLIENTE, TRB_VALOR " + cEol
cQuery1 += " ORDER BY SA1.A1_CELULA, TRB_VALOR DESC "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery1),cAliasTRB,.F.,.T.)
dbGoTop()

	//Se a query retornar algum resultado, executa o processamento.
If (cAliasTRB)->(!Eof()) .And. (cAliasTRB)->(!Bof())
		
    ConOut(" Gerando Lan็amentos Clientes que nใo Compraram - FEXECQNC")
	FEXECQNC(cAliasCok)
  //	MsgRun("Gerando Lan็amentos Clientes que nใo Compraram...",,{|| FEXECQNC(cAliasCok) } ) 
							
	//Se a query nใo retornar nenhum resultado, ้ exibida uma tela informativa para o usuแrio.
ElseIf (cAliasTRB)->(Eof()) .And. (cAliasTRB)->(Bof())
		
	ConOut(" Consulta vazia - O filtro efetuado com os parโmetros preenchidos nใo consistiram em nenhum registro de Clientes Que Nao Compraram.")
		
EndIf
		
(cAliasTRB)->(DbCloseArea())

RestArea(aAreaZ)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFEXECQNC  บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GRAVA O ARQUIVO Z21 (CLIENTES QUE NAO COMPRARAM) บฑฑ
ฑฑบ          ณ  DO COCKPIT DO VENDEDOR.                               	  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FEXECQNC(cAliasCOK)

While (cAliasTRB)->(!Eof())

	(cAliasCOK)->(RecLock(cAliasCOK,.T.))
		
	&(cAliasCOK + "->" + cAliasCOK + "_FILIAL")	:= xFilial(cAliasCOK)
	&(cAliasCOK + "->" + cAliasCOK + "_CODCEL")	:= &(cAliasTRB + "->A1_CELULA")
	&(cAliasCOK + "->" + cAliasCOK + "_CLIENT")	:= &(cAliasTRB + "->TRB_CLIENTE")
	&(cAliasCOK + "->" + cAliasCOK + "_VALOR")	:= &(cAliasTRB + "->TRB_VALOR")
	&(cAliasCOK + "->" + cAliasCOK + "_DATA")	:= dCockPitD
	&(cAliasCOK + "->" + cAliasCOK + "_HORA")	:= cCockPitH
	
	(cAliasCOK)->(MsUnlock())

	(cAliasTRB)->(dbSkip())

End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCLIMMA   บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GERA O ARQUIVO Z22 (CLIENTES COM MENORES MARGENS)บฑฑ
ฑฑบ          ณ  DO COCKPIT DO VENDEDOR.                               	  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑบ          ณ  UTILIZA SX1->PERGUNTA:  PERCOCKPIT						  บฑฑ
ฑฑบ          ณ  -Perํodo de datas para Clientes que Nใo Compraram		  บฑฑ
ฑฑบ          ณ		MV_PAR03 Periodo Inicial							  บฑฑ
ฑฑบ          ณ		MV_PAR04 Periodo Final								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCLIMMA(cAliasCOK)
Local	cQuery1		:= ""
Local	cEol		:= chr(13)+chr(10)
Local	aAreaZ		:= GetArea()
Private	cAliasTRB	:= GetNextAlias()		  // Registro Faturamento para Gravar os Registros dos Clientes que nao compraram

cQuery1 := " select SA1.A1_CELULA, SF2.F2_CLIENTE, SF2.F2_PRENT, SF2.F2_VALMERC " + cEol
cQuery1 += " FROM " +RetSqlName("SF2")+ " AS SF2 " + cEol
cQuery1 += " LEFT JOIN " +RetSqlName("SA1")+ " AS SA1 ON '" + xFilial("SA1") + "' = SA1.A1_FILIAL AND SF2.F2_CLIENTE = SA1.A1_COD AND SF2.F2_LOJA = SA1.A1_LOJA AND SA1.D_E_L_E_T_ = ' ' " + cEol
cQuery1 += " WHERE SF2.D_E_L_E_T_ = ' '  AND '" + xFilial("SF2") + "' = SF2.F2_FILIAL AND SF2.F2_TIPO = 'N' AND SF2.F2_EMISSAO BETWEEN " +DToS(MV_PAR03)+ " AND " +DToS(MV_PAR04)+ " "+ cEol
cQuery1 += " ORDER BY SA1.A1_CELULA, SF2.F2_CLIENTE "

dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery1),cAliasTRB,.F.,.T.)
dbGoTop()

	//Se a query retornar algum resultado, executa o processamento.
If (cAliasTRB)->(!Eof()) .And. (cAliasTRB)->(!Bof())
		
    ConOut(" Gerando Lan็amentos Clientes Menores Margens - FEXECMMA")
	FEXECMMA(cAliasCok)
	//MsgRun("Gerando Lan็amentos Clientes Menores Margens...",,{|| FEXECMMA(cAliasCok) } ) 
							
	//Se a query nใo retornar nenhum resultado, ้ exibida uma tela informativa para o usuแrio.
ElseIf (cAliasTRB)->(Eof()) .And. (cAliasTRB)->(Bof())
		
	ConOut(" Consulta vazia - O filtro efetuado com os parโmetros preenchidos nใo consistiram em nenhum registro de Clientes Menores Margens.")
		
EndIf
		
(cAliasTRB)->(DbCloseArea())

RestArea(aAreaZ)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFEXECMMA  บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE GRAVA O ARQUIVO Z22 (CLIENTES COM MENOR MARGEM)  บฑฑ
ฑฑบ          ณ  DO COCKPIT DO VENDEDOR.                               	  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FEXECMMA(cAliasCOK)
Local cCliente	:= ""
Local cCelula 	:= ""
Local aMMargem	:= {}
Local nTotal	:= 0
Local nPorc		:= 0

While (cAliasTRB)->(!Eof())

	cCliente	:=  (cAliasTRB)->F2_CLIENTE
	cCelula		:=	(cAliasTRB)->A1_CELULA
	aMMargem	:= {}

	While (cAliasTRB)->(!Eof()) .and. (cAliasTRB)->F2_CLIENTE == cCliente .and. (cAliasTRB)->A1_CELULA == cCelula

		AADD( aMMargem, { (cAliasTRB)->A1_CELULA, (cAliasTRB)->F2_CLIENTE, (cAliasTRB)->F2_VALMERC, (cAliasTRB)->F2_PRENT, 0, 0 } )

		(cAliasTRB)->(dbSkip())

	End

	nTotal	:= 0
	AEVAL(aMMargem, { |x| nTotal += x[3]})
	AEVAL(aMMargem, { |x| x[5] := x[3] / nTotal })
	AEVAL(aMMargem, { |x| x[6] := x[5] * x[4] })
	nPorc := 0
	AEVAL(aMMargem, { |x| nPorc += x[6]})


	(cAliasCOK)->(RecLock(cAliasCOK,.T.))
		
	&(cAliasCOK + "->" + cAliasCOK + "_FILIAL")	:= xFilial(cAliasCOK)
	&(cAliasCOK + "->" + cAliasCOK + "_CODCEL")	:= aMMargem[1][1]
	&(cAliasCOK + "->" + cAliasCOK + "_CLIENT")	:= aMMargem[1][2]
	//&(cAliasCOK + "->" + cAliasCOK + "_PRENT")	:= nPorc
	&(cAliasCOK + "->" + cAliasCOK + "_VALOR")	:= nTotal
	&(cAliasCOK + "->" + cAliasCOK + "_DATA")	:= dCockPitD
	&(cAliasCOK + "->" + cAliasCOK + "_HORA")	:= cCockPitH
	
	(cAliasCOK)->(MsUnlock())                                                 

End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSCHCOCKPITบAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE ษ CHAMADA PELO SCHEDULE PARA RODAR O CALCOCKPIT  บฑฑ
ฑฑบ          ณ   						                              	  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SchCockPit()

//Local aOpTables := { "SX1","SX6", "SA1", "Z08", "Z09", "Z10", "Z11", "Z12", "Z13", "Z14", "Z15", ;
//												"Z16", "Z17", "Z18", "Z19", "Z20", "Z21", "Z22", "SF2", "SD2" }
Local cCodEmp   := "99"
Local cCodFil	:= "01"

ConOut("****************************************************")
ConOut("****************************************************")
ConOut("** Inicializando a rotina do CALCOCKPIT: " +Time()+ " **")		//"Inicio: 
ConOut("****************************************************")
ConOut("****************************************************")

/*
If Select("SM0") == 0

	If !SCHOpSM0()

*/	
		RPCSetType(3)   // Nao consome licen็as.
	
/*
		While SM0->(!Eof())
	
			RPCSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL, "", "", "", "",aOpTables) // Abre todas as tabelas.

			RPCSetEnv("99", "01", , , , ,aOpTables) // Abre todas as tabelas.

			PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil TABLES "SX1","SX6","SA1","Z08","Z09","Z10","Z11","Z12","Z13","Z14","Z15","Z16","Z17","Z18","Z19","Z20","Z21","Z22","SF2","SD2"

*/	

			PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil TABLES "SA1","Z08","Z09","Z10","Z11","Z12","Z13","Z14","Z15","Z16","Z17","Z18","Z19","Z20","Z21","Z22","SF2","SD2"

			U_CalCockPit(.F.)
	     
			RpcClearEnv() // Limpa o environment
/*	
	        SM0->(dbSkip())
	
	    End 

	Endif

Else      

		CalCockPit(.F.)

Endif
*/
ConOut("****************************************************")
ConOut("****************************************************")
ConOut("**  Finalizando a rotina do CALCOCKPIT: " +Time()+ "  **")		//"Inicio: 
ConOut("****************************************************")
ConOut("****************************************************")

Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSCHOpSM0  บAutor  ณMicrosiga           บ Data ณ 12/06/2012  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFUNวรO QUE ษ CHAMADA PELO SCHEDULE PARA RODAR O CALCOCKPIT  บฑฑ
ฑฑบ          ณ   						                              	  บฑฑ
ฑฑบ          ณ   														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ  COCKPIT VENDEDOR						                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SCHOpSM0()
LOCAL lOpen 	:= .F.
LOCAL nLoop 	:= 0

For nLoop := 1 To 20

	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )

	If !Empty( Select( "SM0" ) )

		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit

	EndIf

	Sleep( 500 )

Next nLoop

If !lOpen

	ConOut(" SCHEDULE SCHCOCKPIT: Arquivo de Empresas com Problemas na abertura Compartilhada")

EndIf

Return( lOpen )

