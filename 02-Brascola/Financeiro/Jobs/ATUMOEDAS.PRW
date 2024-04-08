// Programa:		ATUMOEDAS
// Autor:		Todos que contribuiram com a ideia.
// Data:		27/10/2006
// Objeto:		Atualiza e Projeta Moedas/Cambio
// Uso:			Modulos Contabilidade Gerencial e Financeiro
//			Protheus 8

// Colocar as linhas abaixo no AP8SRV.INI
// [ONSTART]
// jobs=Moedas
// ;Tempo em Segundos 86400=24 horas
// RefreshRate=86400  
//
// [Moedas]
// main=u_AtuMoedas
// Environment=Environment


#include 'protheus.ch'

User Function AtuMoedas()

Private lAuto		:= .F.
Private dDataRef, dData
Private nValDolar, nValSui, nValEuro
Private nValReal	:= 1.000000
Private nValUfir	:= 0.000000
Private nN		:= 0
Private nS1, nS2, nS3
Private nI1, nI2, nI3
Private oDlg
Private nDiasPro	:= 000
Private nDiasreg	:= 000

//Testa se esta sendo rodado do menu
If	Select('SX2') == 0						
	RPCSetType( 3 )						//Não consome licensa de uso
	RpcSetEnv('01','01',,,,GetEnvServer(),{ "SM2" })
	sleep( 5000 )						//Aguarda 5 segundos para que as jobs IPC subam.
	ConOut('Atualizando Moedas... '+Dtoc(DATE())+' - '+Time())
	lAuto := .T.
EndIf

If	( ! lAuto )
	LjMsgRun(OemToAnsi('Atualização On-line BCB'),,{|| xExecMoeda()} )
Else
	xExecMoeda()
EndIf

If	( lAuto )
	RpcClearEnv()		   				//Libera o Environment
	ConOut('Moedas Atualizadas. '+Dtoc(DATE())+' - '+Time())
EndIf
Return


Static Function xExecMoeda()
Local nPass, cFile, cTexto, nLinhas, cLinha, cdata, cCompra, cVenda, J, K, L

For nPass := 5 to 0 step -1					//Refaz os ultimos 6 dias. O BCB não disponibiliza periodo maior de uma semana
	dDataRef := dDataBase - nPass
    
	//Feriados Bancário Fixo
	If ( Dtos(dDataRef) == STR(Year(Date()),4)+'0101' )	//Dia Mundial da Paz
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0421'	//Dia de Tradentes
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0501'	//Dia do Trabalho
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0907'	//Dia da Independencia
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1012'	//Dia da N. Sra. Aparecida
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1102'	//Dia de Finados
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1115'	//Dia da Proclamação da Republica
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1225'	//Natal
		cFile := Dtos(dDataRef - 1)+'.csv'
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'1231'	//Dia sem Expediente Bancário
		cFile := Dtos(dDataRef - 1)+'.csv'		
	
	//Feriado Bancário Variável 2014. Rever Anualmente
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0303'	//Segunda de Carnaval
		cFile := Dtos(dDataRef - 1)+'.csv'		
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0304'	//Terça de Carnaval
		cFile := Dtos(dDataRef - 1)+'.csv'		
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0418'	//Sexta-Feira da Paixão
		cFile := Dtos(dDataRef - 1)+'.csv'		
	ElseIf	Dtos(dDataRef) == STR(Year(Date()),4)+'0619'	//Corpus Christi
			cFile := Dtos(dDataRef - 1)+'.csv' 
					
	//Finais de Semana
	ElseIf	Dow(dDataRef) == 1				//Se for domingo
		cFile := Dtos(dDataRef - 2)+'.csv'
	ElseIf	Dow(dDataRef) == 7  				//Se for sabado
		cFile := Dtos(dDataRef - 1)+'.csv'
	//Dias Normais
	Else							//Se for dia normal
		cFile := Dtos(dDataRef)+'.csv'	
	EndIf
	
	cTexto  := HttpGet('http://www4.bcb.gov.br/Download/fechamento/'+cFile)

	If	( lAuto )
		ConOut('DownLoading from BCB '+cFile+' In '+Dtoc(DATE()))
	EndIf

	If ! Empty(cTexto)
		nLinhas := MLCount(cTexto, 81)
		For J	:= 1 to nLinhas
			cLinha	:= Memoline(cTexto,81,j)
			aDados  := Separa(cLinha,";",.T.)
			
			If !aDados[2] $ '220*978'
				Loop
			Endif
			
			cData  	:= aDados[1]	// Data
			cCompra := StrTran(Substr(cLinha,22,14),',','.')//Caso a empresa use o Valor de Compra nas linhas abaixo substitua por esta variável
			cVenda  := StrTran(Substr(cLinha,37,14),',','.')//Para conversão interna nas empresas normalmente usa-se Valor de Venda

			If	( aDados[2]=='220' )	//Seleciona o Valor do Dolar
				dData		:= Ctod(cData)
 				nValDolar	:= Val(cCompra)
			EndIf

			/*If	( aDados[2]=='425' )	//Seleciona o Valor do Franco Suíco
 				nValSui		:= Val(cCompra)
			EndIf*/
			
			If	( aDados[2]=='978' )	//Seleciona o Valor do Euro
 				nValEuro	:= Val(cCompra)
			EndIf
		Next
	Endif     
	GravaDados()                            		//Grava Dados do Período selecionado em "J"
Next
          
If	( Dow(dData) == 6 )					//Se for sexta
	For K := 1 to 2
		dData ++
		GravaDados()	      				//Grava os Valores de Sabado e Domingo, Para calculo da Regressão
	Next                                                                                              
EndIf	

Regressao()							//Executa a Projeção das Moedas
	
For L := 1 to nDiasPro						//Projeta para 10 dias seguintes em JOB. Períodos muito grande numa economia estável causa distorções
	nN++
	dData ++    
	nValDolar := (nN * nS1) + nI1				//Valor projetado do Dolar
	nValEuro  := (nN * nS2) + nI2				//Valor projetado do Euro
	//nValSui	  := (nN * nS3) + nI3				//Valor Projetado do Suico 
	Gravadados()
Next
Return


Static Function GravaDados()

DbSelectArea("SM2")						//Grava Moedas
SM2->(DbSetorder(1))
  	
	If SM2->(DbSeek(Dtos(dData)))
		Reclock('SM2',.F.)
	Else
		Reclock('SM2',.T.)
			SM2->M2_DATA	:= dData
	EndIf
	SM2->M2_MOEDA1	:= nValReal				//Real
	SM2->M2_MOEDA2	:= nValDolar			//Dolar
	SM2->M2_MOEDA3	:= nValUfir				//Ufir
	SM2->M2_MOEDA4	:= nValEuro				//Euro
	//SM2->M2_MOEDA5	:= nValSui				//Suico
	SM2->M2_INFORM	:= "S"
	MsUnlock('SM2')

DbSelectArea('CTP')						//Grava Cambio	
CTP->(DbSetorder(1))
	
	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'01'))	//Real
		RecLock('CTP',.F.)		
	Else
		RecLock('CTP',.T.)
			CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '01'
	CTP->CTP_TAXA	:= nValReal
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')
	
	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'02'))	//Dolar
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
			CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '02'
	CTP->CTP_TAXA	:= nValDolar
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')
	
	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'03'))	//Ufir
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
			CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '03'
	CTP->CTP_TAXA	:= nValUfir
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')
	
	If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'04'))	//Euro
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
			CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '04'
	CTP->CTP_TAXA	:= nValEuro
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP')
	
	/*If CTP->(DbSeek(xfilial('CTP')+Dtos(dData)+'05'))	//Suico
		RecLock('CTP',.F.)
	Else
		RecLock('CTP',.T.)
			CTP->CTP_DATA	:= dData
	EndIf
	CTP->CTP_MOEDA	:= '05'
	CTP->CTP_TAXA	:= nValSui
	CTP->CTP_BLOQ	:= '2'
	MsUnlock('CTP') */

Return


Static Function Regressao()

Local nSX       	:= 0
Local nSY1      	:= 0
Local nSY2			:= 0
Local nSY3      	:= 0
local nSXY1	 		:= 0
Local nSXY2     	:= 0
Local nSXY3     	:= 0
Local nSXX      	:= 0
Local mPass, nMedx, nMedY1, nMedY2, nMedY3

If	( ! lAuto )						//Tela de pergunta Dias Projeção e Dias Regressão			
	DEFINE MSDIALOG oDlg TITLE "Regressão Linear" From 415,420 To 500,690 OF oMainWnd PIXEL
	@ 005,012 Say OemToAnsi("Dias Projeção") SIZE 75,10 OF oDlg PIXEL
	oGet01	:= TGet():New(005,100,bSetGet(nDiasPro),oDlg,25,10,"@E 999",,,,,,,.T.)	
	@ 020,012 Say OemToAnsi("Dias Regressao") SIZE 75,10 OF oDlg PIXEL
	oGet02	:= TGet():New(020,100,bSetGet(nDiasReg),oDlg,25,10,"@E 999",,,,,,,.T.)	
	oButton	:= tButton():New(035,100,"Calcular",oDlg,{||oDlg:End()},24,7,,,,.T.)
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	nDiasPro	:= 000
	nDiasReg	:= 000
EndIf

For mPass := nDiasReg to 0 step -1				//Seleciona os Ultimos 15 Dias em JOB. Períodos muito grande numa economia estável causa distorções
	dDataRef	:= dData - mPass
	DbSelectArea("SM2")
	SM2->(DbSetorder(1))
	If SM2->(DbSeek(Dtos(dDataRef)))	 	 	//Pesquisa
		nN		:= nN	 + 1			//Quantidade de Variãveis
		nSX		:= nSX   + nN			//Somatoria de X
		nSY1	:= nSY1  + SM2->M2_MOEDA2		//Somatoria de Y Dolar
		nSY2	:= nSY2  + SM2->M2_MOEDA4		//Somatoria de Y Euro
		//nSY3	:= nSY3  + SM2->M2_MOEDA5		//Somatoria de Y Suico
		nSXY1	:= nSXY1 + (nN*SM2->M2_MOEDA2)		//Somatoria de X * Y Dolar
		nSXY2	:= nSXY2 + (nN*SM2->M2_MOEDA4)		//Somatoria de X * Y Euro
		//nSXY3	:= nSXY3 + (nN*SM2->M2_MOEDA5)		//Somatoria de X * Y Suico
		nSXX	:= nSXX  + (nN*nN)			//Somatoria de X Quadrado
	EndIf
Next
	
nMedX	:= nSX 	/ nN						//Media de X
nMedY1	:= nSY1 / nN						//Media de Y Dolar
nMedY2	:= nSY2 / nN						//Media de Y Euro
//nMedY3	:= nSY3 / nN						//Media de Y Suico
                        	
// DOLAR
nS1	:= (nN*nSXY1 - (nSX*nSY1)) / (nN*nSXX-(nSX*nSX))	//Coeficiente de X Na Equação
nI1	:= nMedY1 - (nS1*nMedX)					//Ponto que a reta toca Eixo X

// EURO
nS2	:= (nN*nSXY2 - (nSX*nSY2)) / (nN*nSXX-(nSX*nSX))	//Coeficiente de X Na Equação
nI2	:= nMedY2 - (nS2*nMedX)					//Ponto que a reta toca Eixo X

// Suico
//nS3	:= (nN*nSXY3 - (nSX*nSY3)) / (nN*nSXX-(nSX*nSX))	//Coeficiente de X Na Equação
//nI3	:= nMedY3 - (nS3*nMedX)					//Ponto que a reta toca Eixo X

Return