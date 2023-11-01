#INCLUDE "rwmake.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! F200VAR													!
+-------------------+-----------------------------------------------------------+
!Descricao			! O ponto de entrada F200VAR do CNAB a receber sera 		!
!					! executado apos carregar os dados do arquivo de recepcao 	!
!					! bancaria e sera utilizado para alterar os dados recebidos.!
!					+-----------------------------------------------------------+
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 07/07/2008												!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function F650VAR()
	Local aValRet	:= PARAMIXB

	//if mv_par08 == 2	//Se modelo 2 e especie em branco
		if alltrim(aValRet[1][3]) == 'NF'
			cTipo := '01 '
		endif
	//endif
	
	//if mv_par03 == '341' .and. substr(aValRet[1][14],108,1) == 'R' .and. alltrim(aValRet[1][13]) == '02'	//Confirmacao da entrada em cobranca descontada
	//	aValRet[1][13] := PadR('SD',3)
	//	cOcorr := PadR('SD',3)
	//endif
	if mv_par03 == '341' .and. substr(aValRet[1][14],108,1) == 'I' .and. alltrim(aValRet[1][13]) == '47'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][13] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if mv_par03 == '001' .and. alltrim(aValRet[1][13]) == '04'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][13] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if mv_par03 == '422' .and. alltrim(aValRet[1][13]) == '21'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][13] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if mv_par03 == '237' .and. alltrim(aValRet[1][13]) == '10'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][13] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if mv_par03 == '341' .and. substr(aValRet[1][14],108,1) == 'R' .and. alltrim(aValRet[1][13]) == '48'	//Confirmacao da saida de cobranca descontada e retorno pra simples
		aValRet[1][13] := PadR('DS',3)
		cOcorr := PadR('DS',3)
	endif

	//Tratamento baixa com juros - cobranca descontada banco Bradesco
	if mv_par03 == '237'
		cNrTit := substr(aValRet[1][14],38,17)
		SE1->(dbSetOrder(1))
		if SE1->(msSeek(xFilial('SE1') + cNrTit))
			if SE1->E1_SITUACA == '2'	//Se descontada
				if aValRet[1][8] > SE1->E1_VALOR	//Se valor recebido maior que valor original, receber como juros
					aValRet[1][9] := (aValRet[1][8] - SE1->E1_VALOR)
					nJuros := (aValRet[1][8] - SE1->E1_VALOR)
				endif
			endif
		endif
	endif
	//Fim


Return( aValRet )
