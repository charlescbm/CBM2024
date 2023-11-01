#INCLUDE "rwmake.ch"
#include 'protheus.ch'

/*
+-------------------+-----------------------------------------------------------+
!Descricao			! O ponto de entrada F200TIT do CNAB a receber, sera        !
					! executado apos o Sistema ler a linha de detalhe e         ! 
					! gravar todos os dados.						            ! 
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria											!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 08/06/2021                                              	!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN


User Function F200TIT()

    Local aTit200         := {}
    //-- Variáveis utilizadas para o controle de erro da rotina automática
    //Local aErroAuto     := {}
    //Local cErroRet      := ""
    //Local nCntErr       := 0
 
    Private lMsErroAuto     := .F.
    //Private lMsHelpAuto     := .T.
    //Private lAutoErrNoFile  := .T.

	//Se ocorrencia SIMPLES para COBRANCA DESCONTADA
	if alltrim(cOcorr) $ 'SD|DS'	//codigo customizado - cadastrar no SEB

		aArea := GetArea()


		//Chave do título
		AAdd(aTit200, {"E1_PREFIXO",   SE1->E1_PREFIXO,   Nil})
		AAdd(aTit200, {"E1_NUM",       SE1->E1_NUM,       Nil})
		AAdd(aTit200, {"E1_PARCELA",   SE1->E1_PARCELA,   Nil})
		AAdd(aTit200, {"E1_TIPO",      SE1->E1_TIPO,      Nil})
	
		//Informações bancárias
		AAdd(aTit200, {"AUTDATAMOV",   dBaixa,				Nil})	//Vem no arquivo de retorno
		AAdd(aTit200, {"AUTBANCO",     SE1->E1_PORTADO,	Nil})
		AAdd(aTit200, {"AUTAGENCIA",   SE1->E1_AGEDEP,		Nil})
		AAdd(aTit200, {"AUTCONTA",     SE1->E1_CONTA,		Nil})
		AAdd(aTit200, {"AUTSITUACA",   iif(alltrim(cOcorr) == "SD","2","1"), Nil})
		AAdd(aTit200, {"AUTNUMBCO",    SE1->E1_NUMBCO,		Nil})
		AAdd(aTit200, {"AUTGRVFI2",    .F.,				Nil})
	
		//Carteira descontada deve ser encaminhado o valor de crédito, desconto e IOF já calculados
		//If cSituaca $ "2|7"
			//AAdd(aTit, {"AUTDESCONT",   nDescont,    Nil})
			//AAdd(aTit, {"AUTCREDIT",    nValCrd,    Nil})
			AAdd(aTit200, {"AUTCREDIT",    SE1->E1_SALDO,    Nil})
			//AAdd(aTit, {"AUTIOF",       nValIOF,    Nil})
		//EndIf
		
		//Identifica que existiu movimento de transferencia
		if Type("cCtrTrf200") <> 'U'
			cCtrTrf200 := iif(alltrim(cOcorr) == "SD","S","D")
		endif

		MsExecAuto({|xoper, xtit060| FINA060(xoper, xtit060)}, 2, aTit200)
		
		If lMsErroAuto
			//aErroAuto := GetAutoGRLog()
			
			//For nCntErr := 1 To Len(aErroAuto)
			//	cErroRet += aErroAuto[nCntErr]
			//Next nCntErr
	
			//Conout(cErroRet)
			MostraErro()
		
		endif
			
		if alltrim(cOcorr) == "DS" .and. Type("nOutCrd200") <> 'U' .and. !empty(nOutCrd200)

			lMsErroAuto     := .F.
			SED->(dbSetOrder(1))
			SED->(msSeek(xFilial('SED') + padr('2.5.2.01',tamsx3('ED_CODIGO')[1])))
			cHistor := alltrim(SED->ED_DESCRIC) + ' - ' + SE1->E1_NUM

			aSE5 := {}
			aAdd( aSE5, {"E5_DATA"    , dDataBase  , NIL} )
			aAdd( aSE5, {"E5_DTDIGIT" , dDataBase  , NIL} )
			aAdd( aSE5, {"E5_DTDISPO" , dDataBase  , NIL} )
			aAdd( aSE5, {"E5_VALOR"   , nOutCrd200    , NIL} )
			aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
			aAdd( aSE5, {"E5_BANCO"   , SE1->E1_PORTADO    , NIL} )
			aAdd( aSE5, {"E5_AGENCIA" , SE1->E1_AGEDEP  , NIL} )
			aAdd( aSE5, {"E5_CONTA"   , SE1->E1_CONTA    , NIL} )
			aAdd( aSE5, {"E5_NATUREZ" , '2.5.2.01' , NIL} )
			aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

			MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

			If lMsErroAuto
				MostraErro()
			EndIf

		endif
	
		pergunte("AFI200", .F.)
		RestArea(aArea)
	endif

Return()
