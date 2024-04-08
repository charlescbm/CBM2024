#include "protheus.ch"
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT103FIM  บAutor  ณ SSERVICES          บ Data ณ  09/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑบ Chamado pela rotina MATA103.                                          บฑฑ
ฑฑบ    O ponto de entrada ้ chamado no final da grava็ใo da nota fiscal   บฑฑ
ฑฑบ de entrada.                                                           บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Brascola                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MT103FIM()

Local oDlg1   := {}
Local _aArea  := GetArea()
Local _cCod	  := CriaVar( 'PA2_TIPO', .f., 'L' )
Local _cGp	  := 'N'
Local _nSeq	  := 0
Local _cQuery := ''
Local _cINCSOL:= ''

If SF1->F1_TIPO = 'D' .And. Inclui
	/////////////////////////////////////////////////////////////////////
	//       Neste ponto solicita o motivo da devolu็ใo de venda.      //
	/////////////////////////////////////////////////////////////////////

	DEFINE MSDIALOG oDlg1 TITLE 'Motivo da Exclusao' From 000, 000 To 110,440 OF oMainWnd PIXEL
		@ 010,010 SAY 'Informe o c๓digo do motivo da devolu็ใo da nota fiscal: '       OF oDlg1 PIXEL COLOR CLR_HBLUE
		@ 025,010 SAY 'Informe se a guia de recolhimento de impostos foi paga (S/N): ' OF oDlg1 PIXEL COLOR CLR_HBLUE		
		@ 010,170 MSGET _cCod             SIZE 040, 010	F3 'ZZC' Of oDlg1 PIXEL WHEN .t. VALID( !Empty( _cCod ))// .And. U_VALIDAZZC( _cCod ) )
		@ 025,170 MSGET _cGp  PICTURE '!' SIZE 040, 010          Of oDlg1 PIXEL WHEN .t. VALID( !Empty( _cGp  ) .And. _cGp $ 'S/N' )
		DEFINE SBUTTON FROM 040, 185 TYPE 1 ACTION ( oDlg1:End() ) ENABLE OF oDlg1 PIXEL
	ACTIVATE MSDIALOG oDlg1 CENTERED VALID( !Empty( _cCod ) )

	DbSelectArea('SD1')
	DbSetOrder(1)

	DbSeek( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA, .t. )

	While !Eof() .And. ( SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA )
	         
		_cINCSOL:= Posicione( 'SF4', 1, xFilial('SF4') + SD1->D1_TES, 'SF4->F4_INCSOL' )
		
		If Posicione( 'SF4', 1, xFilial('SF4') + SD1->D1_TES, 'SF4->F4_DUPLIC' ) = 'N'
			DbSelectArea('SD1')
			DbSkip()
			Loop
        EndIf
		
		DbSelectArea('SF2')
		DbSetOrder(2)

		If !DbSeek( SD1->D1_FILIAL + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_NFORI + SD1->D1_SERIORI, .f. )
		    Alert( 'Nota fiscal nao encontrada!... ' + SD1->D1_FILIAL + ' ' + SD1->D1_FORNECE + ' ' +  SD1->D1_LOJA + ' ' +  SD1->D1_NFORI + ' ' +  SD1->D1_SERIORI )
			RestArea( _aArea )
			Return
		EndIf    

		DbSelectArea('PA2')
		DbSetOrder(1)
	
		DbSeek( SD1->D1_FILIAL + SD1->D1_NFORI + SD1->D1_SERIORI, .f. ) 
		// DbSeek( SD1->D1_FILIAL + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_NFORI + SD1->D1_SERIORI, .f. ) 
		
		If !Found()
			RecLock( 'PA2', .t. )
				PA2_FILIAL := SF2->F2_FILIAL
				PA2_DOC    := SF2->F2_DOC
				PA2_SERIE  := SF2->F2_SERIE
				PA2_SEQ    := '000001'
				PA2_CLIENT := SF2->F2_CLIENTE
				PA2_LOJA   := SF2->F2_LOJA
				PA2_COND   := SF2->F2_COND
				PA2_DUPL   := SF2->F2_DUPL
				PA2_EMISSA := SF2->F2_EMISSAO
				PA2_HORAEM := SF2->F2_HORA
				PA2_EST    := SF2->F2_EST
				PA2_TIPCLI := SF2->F2_TIPOCLI
				PA2_DTENTR := SF2->F2_DTENTR
				PA2_DTSAID := SF2->F2_DTSAIDA
				PA2_FLGIMP := SF2->F2_FLGIMP
				PA2_VLRBRU := SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_VALFRE + SD1->D1_SEGURO + SD1->D1_DESPESA - SD1->D1_VALDESC + IIF( _cINCSOL = 'S', SD1->D1_ICMSRET, 0 )
				PA2_DTDIGT := SD1->D1_DTDIGIT
				PA2_DTCANC := SD1->D1_DTDIGIT
				PA2_HORA   := Left( Time(), 5 )
				PA2_NDEV   := SD1->D1_DOC
				// PA2_SNDEV   := SD1->D1_SERIE
				// PA2_INDEV   := SD1->D1_ITEM				
				PA2_USRCANC:= SubStr( cUsuario, 7, 15 )
				PA2_OBS    := '     '
				PA2_TIPO   :=  _cCod
				PA2_GP	   :=  _cGp
			MsUnLock()
		Else
			RecLock( 'PA2', .f. )
				PA2_VLRBRU := PA2_VLRBRU + SD1->D1_TOTAL + SD1->D1_VALIPI + SD1->D1_VALFRE + SD1->D1_SEGURO + SD1->D1_DESPESA - SD1->D1_VALDESC + IIF( _cINCSOL = 'S', SD1->D1_ICMSRET, 0 )
			MsUnLock()	
		EndIf	
		
		DbSelectArea('SD1')
		DbSkip()
	
	EndDo

	// Para evitar que a rotina seja chamada na saida para o browse
	DbSelectArea('SF1')
	DbSkip()

ElseIf SF1->F1_TIPO = 'D' .And. !Inclui .And. !Altera
	/////////////////////////////////////////////////////////////////////
	//        Neste ponto exclui o motivo da devolu็ใo de venda.       //
	/////////////////////////////////////////////////////////////////////

	_cQuery+= "DELETE FROM " + RetSqlName('PA2') + " "
	_cQuery+= "WHERE D_E_L_E_T_ <> '*' "
	_cQuery+= "AND PA2_FILIAL = '" + SF1->F1_FILIAL + "' "
	_cQuery+= "AND PA2_NDEV   = '" + SF1->F1_DOC	+ "' "
	
	TCSQLEXEC( _cQuery )

	DbSelectArea('SF1')
	DbGoTop()

EndIf
		
RestArea( _aArea )

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VALIDAZZC บAutor ณ SSERVICES          บ Data ณ  09/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o c๓digo da devolu็ใo de vendas, chamada pelo campo บฑฑ
ฑฑบ          ณ de valida็ใo do usuแrio na tabela 'SX3' campo ZZC_COD      บฑฑ
ฑฑบ          ณ  														  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Brascola                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VALIDAZZC( _cCod )

Local _aArea:= GetArea()
Local _lRet := .t.

DbselectArea('ZZC')
DbSetOrder(1)

If !DbSeek( xFILIAL('ZZC') + _cCod, .f. )
	Alert( 'Digite um c๓digo vแlido!...' )
	_lRet:= .f.
EndIf	

RestArea( _aArea )

Return _lRet