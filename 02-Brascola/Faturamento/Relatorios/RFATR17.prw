#INCLUDE "rwmake.ch"  
#INCLUDE "TopConn.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR17  º Autor ³ Elias Reis         º Data ³  20/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que dispara a impressão de um ou mais clientes      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATR17

Local cDesc1		 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Relatorio de Clientes por Representantes"
Local cPict        := ""
Local titulo       := "Relatorio de Clientes por Representantes"
Local nLin         := 80
Local cQuery		 := ""
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
//Local aOrd 			 := {}
Local aRegs		    := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RFATR17" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CriaPerg("FATR17")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATR17" // Coloque aqui o nome do arquivo usado para impressao em disco
//Private cString 		:= "SA1"

aAdd(aRegs,{cPerg,"01",	"Cliente de  :"	    ,"","","mv_ch1","C",08,0,0,"G","","MV_PAR01","","","","00000001","","","","","","","","","","","","","","","","","","","","","SA1","","","","" })
aAdd(aRegs,{cPerg,"02",	"Cliente até :" 	,"","","mv_ch2","C",08,0,0,"G","","MV_PAR02","","","","99999999","","","","","","","","","","","","","","","","","","","","","SA1","","","","" })
aAdd(aRegs,{cPerg,"03",	"Vendedor de  :"	,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","" })
aAdd(aRegs,{cPerg,"04",	"Vendedor até :"	,"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA3","","","","" })

// Cria as perguntas
U_CriaSX1(aRegs)

pergunte(cPerg,.F.)

wnrel := SetPrint(/*cString*/,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn/*,cString*/)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RunReportº Autor ³ Elias Reis         º Data ³  20/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao que dispara a impressão de um ou mais clientes      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nTotReg	:= 0
Local cQuery 	:= cVendedor	:= "" 

dbSelectArea("SA3")
dbSetOrder(7)
dbGoTop()

If msSeek(xFilial()+__cUserID,.T.) 
	While !Eof() .And. SA3->A3_CODUSR == __cUserID
			cVendedor += "'"+SA3->A3_COD+"'" + ','
			dbSkip()	
	EndDo
	
	cVendedor := SubStr(cVendedor,1,Len(cVendedor)-1)	
EndIf            

SA3->(dbCloseArea())

//Seleciona os Clientes
cQuery := " SELECT * FROM " + RetSQLName("SA1")  
cQuery += " WHERE "

If Len(Alltrim(cVendedor))!=0
	cQuery += "     A1_VEND IN ("+cVendedor+") AND "
Else
	cQuery += "     A1_VEND BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND "
EndIf	

cQuery += "     D_E_L_E_T_ <> '*' "     
cQuery += " AND A1_COD >= '" + MV_PAR01 + "'"
cQuery += " AND A1_COD <= '" + MV_PAR02 + "'"     
cQuery += " ORDER BY A1_NOME "

If Select('RFATR17') > 0                                             '
	dbSelectArea('RFATR17')
	dbCloseArea()
EndIf

//MEMOWRITE("\QUERYSYS\RFATR17.SQL",cQuery)
TCQUERY cQuery NEW ALIAS 'RFATR17'  

dbSelectArea("RFATR17")

dbGotop() 

While !EOF() 

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif 
   
   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif  
   
   nTotReg++
   
   @nLin, 00 PSAY Replicate("_",132)

   nLin++ 
   
	@nLin, 00 PSAY "CNPJ/CPF"  

	If Len(Alltrim(RFATR17->A1_CGC)) > 11
		@nLin, 16 PSAY RFATR17->A1_CGC Picture "@R 99.999.999/9999-99"
	Else
		@nLin, 16 PSAY RFATR17->A1_CGC Picture "@R 999.999.999-99"	
	EndIf	
		
   @nLin, 46 PSAY "Codigo"
   @nLin, 61 PSAY RFATR17->A1_COD                  

   nLin++ 

   @nLin, 00 PSAY "Nome"
   @nLin, 16 PSAY SubStr(RFATR17->A1_NOME,1,30)
                                        
   nLin++ 
   
   @nLin, 00 PSAY "Endereco"
   @nLin, 16 PSAY SubStr(RFATR17->A1_END,1,30)
   @nLin, 91 PSAY "Municipio"
   @nLin,106 PSAY RFATR17->A1_MUN   
   
   nLin++ 
   
   @nLin, 00 PSAY "Estado"
   @nLin, 16 PSAY RFATR17->A1_EST   
   @nLin, 46 PSAY "Bairro"
   @nLin, 61 PSAY RFATR17->A1_BAIRRO   
   @nLin, 91 PSAY "Cep"
   @nLin,106 PSAY RFATR17->A1_CEP    Picture "@R 99999-999"	  
   
   nLin++ 
   
   @nLin, 00 PSAY "DDD"
   @nLin, 16 PSAY RFATR17->A1_DDD   
   @nLin, 46 PSAY "Telefone"                  
   @nLin, 61 PSAY RFATR17->A1_TEL                     
   @nLin, 91 PSAY "Vendedor"                  	   
   @nLin,106 PSAY RFATR17->A1_VEND                    
   
   nLin++ 
   
   @nLin, 00 PSAY "Email"
   @nLin, 16 PSAY RFATR17->A1_EMAIL     

   nLin++   

   dbSkip() 
EndDo

dbCloseArea()

@nLin, 00 PSAY Replicate("_",132)
nLin++ 
@nLin,00 PSAY  "Total de Registros Impressos : "  + Str(nTotReg)

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return