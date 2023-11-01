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

User Function F200VAR()
	Local aValRet	:= PARAMIXB
	
	if Type("nOutCrd200") <> 'U'
		nOutCrd200 := 0
	endif

	//if mv_par12 == 2	//Se modelo 2 e especie em branco
		if alltrim(aValRet[1][3]) == 'NF'
			cTipo := '01 '
		endif
	//endif

	//if cBanco == '341' .and. substr(aValRet[1][16],108,1) == 'R' .and. alltrim(aValRet[1][14]) == '02'	//Confirmacao da entrada em cobranca descontada
	//	aValRet[1][14] := PadR('SD',3)
	//	cOcorr := PadR('SD',3)
	//endif
	if cBanco == '341' .and. substr(aValRet[1][16],108,1) == 'I' .and. alltrim(aValRet[1][14]) == '47'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][14] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if cBanco == '001' .and. alltrim(aValRet[1][14]) == '04'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][14] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if cBanco == '422' .and. alltrim(aValRet[1][14]) == '21'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][14] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if cBanco == '237' .and. alltrim(aValRet[1][14]) == '10'	//Confirmacao da entrada em cobranca descontada
		aValRet[1][14] := PadR('SD',3)
		cOcorr := PadR('SD',3)
	endif
	if cBanco == '341' .and. substr(aValRet[1][16],108,1) == 'R' .and. alltrim(aValRet[1][14]) == '48'	//Confirmacao da saida de cobranca descontada e retorno pra simples
		aValRet[1][14] := PadR('DS',3)
		cOcorr := PadR('DS',3)

		if Type("nOutCrd200") <> 'U' .and. !empty(val(substr(aValRet[1][16],280,292)))
			nOutCrd200 := val(substr(aValRet[1][16],280,292))/100
		endif
	endif

	if Type("cGoVal200") <> 'U' .and. empty(cGoVal200)
		cGoVal200 := mv_par04
	endif


	//Tratamento baixa com juros - cobranca descontada banco Bradesco
	if cBanco == '237'
		cNrTit := substr(aValRet[1][16],38,17)
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
