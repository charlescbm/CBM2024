#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

User Function PEDVEN()
**********************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "PEDIDOS DE VENDA"
Local cPict			:= ""
Local titulo		:= "PEDIDOS DE VENDA"
Local nLin			:= 80
Local Cabec1		:= ""
Local Cabec2		:= ""                          
Local imprime		:= .T. 
Local aOrd			:= {}

Private lEnd		:= .F.
Private lAbortPrint  := .F.
Private CbTxt		:= ""
Private limite		:= 132
Private tamanho	:= "M"
Private nomeprog	:= "PEDVEN" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo		:= 18
Private aReturn	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private _cPerg		:= ""
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "PEDVEN" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString	:= "SC5"

dbSelectArea("SC5")
dbSetOrder(1)

//Alteração para não imprimir uma pagina em branco    
// o nome da variavel cPerg foi mudado para _cPerg
//Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)     

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
*************************
Local nOrdem
Local cItem 	:= cProd 	:= cDesc := cUm 	:= ""
Local nPos1 	:= nPos2 	:= nPos3 := nPos4 	:= nPos5 	:= nPos5 	:= nPos7 	:= nPos8 := nPos9 := 0
Local nQtd 		:= nVlUni 	:= nDesc := nVlTot 	:= nValor 	:= nDescont := _nDescit := nTdesc:= nTotq := nTotVal :=  nVlqliq := nTotPeso:= 0
Local OBSPEDIDO := ""

dbSelectArea(cString)
dbSetOrder(1)
SetRegua(RecCount())

nLin  := 99
Cabec1:= PadC("PEDIDO Nº: "+M->C5_NUM,132)

If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
   nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
Endif   

/*
@   nLin,057 PSAY "PEDIDO Nº: " + M->C5_NUM 
@ ++nLin,000 PSAY __PrtThinLine()
nLin+= 2
*/
	
@ ++nLin, 001 PSAY "Cliente : " + M->C5_CLIENTE + " / " + M->C5_LOJACLI + " - " + ALLTRIM(M->C5_NOMECLI)
nLin++

DBSELECTAREA("SA1")
DBSETORDER(1)
IF DBSEEK( XFILIAL("SA1") + M->C5_CLIENTE + M->C5_LOJACLI )
	@   nLin, 001 PSAY "Endereco: " + ALLTRIM(SA1->A1_END)
	@ ++nLin, 001 PSAY "Bairro: " + ALLTRIM(SA1->A1_BAIRRO)
	@ ++nLin, 001 PSAY "Cidade / UF: " + ALLTRIM(SA1->A1_MUN) + " - " + ALLTRIM(SA1->A1_EST)
	@ ++nLin, 001 PSAY "CEP: " + SUBSTR(ALLTRIM(SA1->A1_CEP),1,5) + "-" + SUBSTR(ALLTRIM(SA1->A1_CEP),6,3)
	@ ++nLin, 001 PSAY "CNPJ / CGC: "
	
	IF LEN(ALLTRIM(SA1->A1_CGC)) = 14
		@  nLin, 013 PSAY ALLTRIM(SA1->A1_CGC) PICTURE "@R 99.999.999/9999-99"
	ELSE
		@  nLin, 013 PSAY ALLTRIM(SA1->A1_CGC) PICTURE "@R 999.999.999-99"
	ENDIF	
	
	@++nLin, 001 PSAY "Inscr. Estadual : "
	
	IF LEN(ALLTRIM(SA1->A1_INSCR)) > 0
		@  nLin, 019 PSAY ALLTRIM(SA1->A1_INSCR)
	ELSE
		@  nLin, 019 PSAY "Inscr. Estadual Nao Cadastrada ou Cliente Isento de Inscricao"	
	ENDIF
	
	@ ++nLin, 001 PSAY "Contato / Telefone: "	+ ALLTRIM(SA1->A1_CONTATO) + " / " + SA1->A1_TEL
		
	nLin+= 2
ELSE	
	@ nLin, 001 PSAY "Cliente nao Encontrado"
ENDIF	

@  nLin, 001 PSAY "Representante : " + M->C5_VEND1

DBSELECTAREA("SA3")
DBSETORDER(1)
IF DBSEEK( XFILIAL("SA3") + M->C5_VEND1 )
	@  nLin, 024 PSAY ALLTRIM(SA3->A3_NOME)
ELSE
	@  nLin, 024 PSAY "Representante nao Encontrado"
ENDIF	        

@++nLin, 001 PSAY "Tabela de Preco: " + M->C5_TABELA

DBSELECTAREA("DA0")
DBSETORDER(1)
IF DBSEEK( XFILIAL("DA0") + M->C5_TABELA )
	@  nLin, 023 PSAY SubStr(DA0->DA0_DESCRI,1,30)
ENDIF	

DBSELECTAREA("SE4")
DBSETORDER(1)
IF DBSEEK( XFILIAL("SE4") + M->C5_CONDPAG )
	@ nLin, 060 PSAY "Cond.Pag.: " + M->C5_CONDPAG + " - " + SE4->E4_DESCRI
ENDIF	
		
IF M->C5_TPFRETE = "C"
	@++nLin, 001 PSAY "Frete: CIF"
ELSE
	@++nLin, 001 PSAY "Frete: FOB"
ENDIF	
		
@++nLin, 001 PSAY "Emissao: " + DTOC(M->C5_EMISSAO)
@  nLin, 050 PSAY "Dt. Entrega: " + DTOC(M->C5_ENTREGA)
@++nLin, 001 PSAY "Transportadora: " + M->C5_TRANSP

DBSELECTAREA("SA4")
DBSETORDER(1)
IF DBSEEK( XFILIAL("SA4") + M->C5_TRANSP )
	@  nLin, 024 PSAY ALLTRIM(SA4->A4_NOME)
ENDIF	         
		
nLin+= 2

@++nLin, 000 PSay __PrtThinLine()
@++nLin, 001 PSAY "SEQ.  ITEM     DESCRICAO                                 UM    PESO BRUTO           QTDE        VL.UNIT     % DESC       VL.TOTAL"
//                0         1        2         3         4         5         6         7         8         9        10        11        12        13
//				  012345678901234678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
//                 XXXX  XXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XX  999,999.9999  99.999.999,99  99.999.999,99     999,99  99.999.999,99
@++nLin, 000 PSay __PrtThinLine()
		
DBSELECTAREA("SC6")

FOR N1 := 1 TO LEN(aCols)
	nPos1   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ITEM"})
	cItem   := aCols[N1,nPos1]  //Grava na variavel
	nPos2   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"})
	cProd   := aCols[N1,nPos2]  //Grava na variavel
	nPos3   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCRI"})
	cDesc   := aCols[N1,nPos3]  //Grava na variavel
	nPos4   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_UM"}) 
	cUM     := aCols[N1,nPos4]  //Grava na variavel
	nPos5   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"})
	nQtd    := aCols[N1,nPos5]  //Grava na variavel
	nPos10  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"})
	nValT   := aCols[N1,nPos10]  //Grava na variavel

	nPesBruto:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_PESBRU")

    //Modificação feita para que, no caso de uma venda onde o valor vendido seja maior que o preço de lista
    //nPos6   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"  }) 
	If aCols[N1,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"})] <;
	   aCols[N1,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"})]  
	    nPos6 := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"}) 
	Else
		nPos6 := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"})
	EndIf
	nVlUni  := aCols[N1,nPos6]  //Grava na variavel

	nPos7   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT"}) 
	nDesc   := aCols[N1,nPos7]  //Grava na variavel
	nPos8   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"}) 
	nVlTot  := aCols[N1,nPos8]  //Grava na variavel
	nPos9   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC"}) 
	nDescont:= aCols[N1,nPos9]  //Grava na variavel			
	
	@++nLin, 001 PSAY ALLTRIM(cItem)
	@  nLin, 007 PSAY SubStr(cProd,1,7)
	@  nLin, 016 PSAY SubStr(cDesc,1,40)
	@  nLin, 058 PSAY ALLTRIM(cUm)
	@  nLin, 062 PSAY nQtd*nPesBruto  PICTURE "@E 999,999.9999"
	@  nLin, 076 PSAY nQtd   		  PICTURE "@E 99,999,999.99"
	@  nLin, 091 PSAY nVlUni 		  PICTURE "@E 99,999,999.99"
	@  nLin, 109 PSAY nDesc 		  PICTURE "@E 999.99"
	@  nLin, 117 PSAY nVlTot 		  PICTURE "@E 99,999,999.99"

	nValor  += nVlTot
	nTdesc  += nDescont
    nTotq   += nVlUni * nQtd
    nVlqliq += 	nValT   //rodolfo adicionado
    nTotPeso+= nPesBruto * nQtd
    
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		//@   nLin,057 PSAY "PEDIDO Nº: " + M->C5_NUM 
		@ ++nLin,000 PSAY __PrtThinLine()
		@ ++nLin,001 PSAY "SEQ.  ITEM     DESCRICAO                                 UM    PESO BRUTO           QTDE        VL.UNIT     % DESC       VL.TOTAL"
		@ ++nLin,000 PSAY __PrtThinLine()
   Endif
NEXT	
			
nLin += 2
@  nLin, 040 PSAY "Tot.Peso Bruto:"
@  nLin, 059 PSAY nTotPeso PICTURE "@E 99,999,999.9999"  						
@  nLin, 080 PSAY "Valor Bruto: "
@  nLin, 117 PSAY nTotq PICTURE "@E 99,999,999.99"  						
@++nLin, 080 PSAY "Valor Total de Desconto: "
@  nLin, 117 PSAY nTdesc PICTURE "@E 99,999,999.99"						
@++nLin, 080 PSAY "Valor Total: "	
@  nLin, 117 PSAY nVlqliq PICTURE "@E 99,999,999.99"	  //alterado rodolfo		
		
OBSPEDIDO := (AllTrim(SC5->C5_HISTORI)) // Leitura do campo memo da observação do pedido

nLin += 3
			
@  nLin , 001 PSAY "Observacao: "

LTOT := MLCOUNT(OBSPEDIDO,140,3,.T.)
        
FOR A = 1 TO LTOT 
    LDESC = MEMOLINE(OBSPEDIDO,140,A,3,.T.)
    @++ nLin , 001 PSAY LDESC          
NEXT
 				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return