#INCLUDE 'PROTHEUS.CH'

/************************************************************************************/
/*/{Protheus.doc} ICOMR040

@description Rotina monta imagem das etiquetas Inoven

@author Bernard M. Margarido
@since 11/07/2018
@version 1.0

@type function
/*/
/************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function ICOMR040(nTipo,cCodProd,cDescPrd,cNumLot,cCodPallet,cNumCx,dData,dDtValid,cCodBar,cDsQrCode,nGridEtq)
Local cEtiqueta 	:= "" 

Default cNumLot		:= ""
Default cCodPallet	:= ""
Default cNumCx		:= ""

//----------------+
// Etiqueta Caixa |
//----------------+
If nTipo == 1
	
	TEtqCaixa(cCodProd,cDescPrd,cNumLot,dData,dDtValid,cCodBar,@cEtiqueta,cDsQrCode,nGridEtq)
	
//-----------------+
// Etiqueta Pallet |
//-----------------+
ElseIf nTipo == 2

	TEtqPallet(cCodProd,cDescPrd,cCodPallet,cNumCx,dData,dDtValid,cCodBar,@cEtiqueta,cDsQrCode,nGridEtq)
	
//-----------------+
// Etiqueta Volume |
//-----------------+
ElseIf nTipo == 3
	
EndIf

Return cEtiqueta

/************************************************************************************/
/*/{Protheus.doc} TEtqCaixa

@description Monta imagem da etiqueta caixa

@author Bernard M. Margarido
@since 11/07/2018
@version 1.0

@param cCodProd		, characters, descricao
@param cDescPrd		, characters, descricao
@param cNumLot		, characters, descricao
@param dData		, date, descricao
@param dDtValid		, date, descricao
@param cCodBar		, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function TEtqCaixa(cCodProd,cDescPrd,cNumLot,dData,dDtValid,cCodBar,cEtiqueta,cDsQrCode,nGridEtq)
    
//dToc(monthSub(dData,_mesvalid))

//LOCAL _mesvalid:= posicione("SB1",1,XFILIAL("SB1")+cCodProd,"B1_XDTVALI")

	/*
	cEtiqueta := 'CT~~CD,~CC^~CT~' + CRLF
    cEtiqueta += '^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ' + CRLF 
    cEtiqueta += '^XA' + CRLF
    cEtiqueta += '^MMT' + CRLF
	cEtiqueta += '^PW823' + CRLF
	cEtiqueta += '^LL0280' + CRLF
	cEtiqueta += '^LS0' + CRLF                                                                
	cEtiqueta += '^FT342,35^A0N,30,30^FH\^FDINOVEN^FS' + CRLF
	cEtiqueta += '^FO10,187^GB782,0,2^FS' + CRLF
	cEtiqueta += '^FT41,82^A0N,28,28^FH\^FD' + Alltrim(cCodProd) + "-" + Alltrim(cDescPrd) + '^FS' + CRLF
	cEtiqueta += '^FT43,126^A0N,28,28^FH\^FDLOTE: ' + Alltrim(cNumLot)  + ' ^FS' + CRLF
   	cEtiqueta += '^FT41,170^A0N,28,28^FH\^FDFabrica\87\C6o: ' + dToc(monthSub(dDtValid,_mesvalid)) + ' ^FS' + CRLF
	cEtiqueta += '^FT376,173^A0N,28,28^FH\^FDValidade: ' + dToc(dDtValid) + ' ^FS' + CRLF
	cEtiqueta += '^BY2,3,61^FT40,255^BCN,,Y,N^FD>;' + cCodBar + '>6' + cNumLot + '^FS' + CRLF
	cEtiqueta += '^FO10,46^GB782,0,1^FS' + CRLF
	cEtiqueta += '^PQ1,0,1,Y' + CRLF
	cEtiqueta += '^XZ' + CRLF
	*/

	//Novo Layout
	do Case
		Case nGridEtq == 1
			cEtiqueta += '^FT32,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT33,180^A0N,16,20^FH\^CI28^FD' + cDsQrCode + cNumLot +'   ^FS^CI27' + CRLF
			cEtiqueta += '^FO200,48^GFA,333,1080,12,:Z64:eJzNkiEOg0AQRXchmwrEKiRn4AjsERBFcoeK1pOeBM0l4AgVlTRBIisbBHQ2YfaP4ACMenmZDPNnUeqM1TXgyoE3eF1BR9J/4OMVrO/gRHgzCr8IfwXbn/AvcC58WoKLGZzt/VFHftp3odmp4x0b1bOnXWr2lIlj+awhrvDUrOvgW8StHM6zTf4Te/+AuMWEuGmJuMWMuNnLvBEW3pSIa8nzfDPiPMlip9B/NS741Ybz6NEMzPEat8FXmpEe99kE/4GnKwSvHkr4FlwPYL6+L76+r/7gtXzlX9F/A1vRL/+GRMy/uGOvxT6ISx6ookadv/40dlGK:9D59' + CRLF
			cEtiqueta += '^FT91,182^BQN,2,4' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '   \0D\0A^FS' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '\0D\0A^FS' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '^FS' + CRLF
		Case nGridEtq == 2
			cEtiqueta += '^FT312,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT313,180^A0N,16,20^FH\^CI28^FD' + cDsQrCode + cNumLot +'   ^FS^CI27' + CRLF
			cEtiqueta += '^FO480,48^GFA,333,1080,12,:Z64:eJzNkiEOg0AQRXchmwrEKiRn4AjsERBFcoeK1pOeBM0l4AgVlTRBIisbBHQ2YfaP4ACMenmZDPNnUeqM1TXgyoE3eF1BR9J/4OMVrO/gRHgzCr8IfwXbn/AvcC58WoKLGZzt/VFHftp3odmp4x0b1bOnXWr2lIlj+awhrvDUrOvgW8StHM6zTf4Te/+AuMWEuGmJuMWMuNnLvBEW3pSIa8nzfDPiPMlip9B/NS741Ybz6NEMzPEat8FXmpEe99kE/4GnKwSvHkr4FlwPYL6+L76+r/7gtXzlX9F/A1vRL/+GRMy/uGOvxT6ISx6ookadv/40dlGK:9D59' + CRLF
			cEtiqueta += '^FT371,182^BQN,2,4' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '   \0D\0A^FS' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '\0D\0A^FS' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '^FS' + CRLF
		Case nGridEtq == 3
			cEtiqueta += '^FT591,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT592,180^A0N,16,20^FH\^CI28^FD' + cDsQrCode + cNumLot +'   ^FS^CI27' + CRLF
			cEtiqueta += '^FO759,48^GFA,333,1080,12,:Z64:eJzNkiEOg0AQRXchmwrEKiRn4AjsERBFcoeK1pOeBM0l4AgVlTRBIisbBHQ2YfaP4ACMenmZDPNnUeqM1TXgyoE3eF1BR9J/4OMVrO/gRHgzCr8IfwXbn/AvcC58WoKLGZzt/VFHftp3odmp4x0b1bOnXWr2lIlj+awhrvDUrOvgW8StHM6zTf4Te/+AuMWEuGmJuMWMuNnLvBEW3pSIa8nzfDPiPMlip9B/NS741Ybz6NEMzPEat8FXmpEe99kE/4GnKwSvHkr4FlwPYL6+L76+r/7gtXzlX9F/A1vRL/+GRMy/uGOvxT6ISx6ookadv/40dlGK:9D59' + CRLF
			cEtiqueta += '^FT650,182^BQN,2,4' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '   \0D\0A^FS' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '\0D\0A^FS' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + cNumLot + '^FS' + CRLF
	endCase

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TEtqPallet

@description Monta imagem etiqueta pallet

@author Bernard M. Margarido
@since 11/07/2018
@version 1.0

@param cCodProd		, characters, descricao
@param cDescPrd		, characters, descricao
@param cCodPallet	, characters, descricao
@param dData		, date, descricao
@param dDtValid		, date, descricao
@param cCodBar		, characters, descricao
@param cEtiqueta	, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function TEtqPallet(cCodProd,cDescPrd,cCodPallet,cNumCx,dData,dDtValid,cCodBar,cEtiqueta,cDsQrCode,nGridEtq)

//LOCAL _mesvalid:= posicione("SB1",1,XFILIAL("SB1")+cCodProd,"B1_XDTVALI")

	/*
	cEtiqueta 	:= '^XA' + CRLF
	cEtiqueta 	+= '^MMT' + CRLF
	cEtiqueta 	+= '^PW823' + CRLF
	cEtiqueta 	+= '^LL0280' + CRLF
	cEtiqueta 	+= '^LS0' + CRLF
	cEtiqueta 	+= '^FT342,35^A0N,30,30^FH\^FDINOVEN^FS' + CRLF
	cEtiqueta 	+= '^FO10,187^GB782,0,2^FS' + CRLF
	cEtiqueta 	+= '^FT41,82^A0N,28,28^FH\^FD' + Alltrim(cCodProd) + "-" + Alltrim(cDescPrd) + '^FS' + CRLF
	cEtiqueta 	+= '^FT43,126^A0N,28,28^FH\^FDPALLETE: ' + cCodPallet + '^FS' + CRLF
	cEtiqueta 	+= '^FT376,126^A0N,28,28^FH\^FDCXS: ' + cNumCx + '^FS' + CRLF
	cEtiqueta 	+= '^FT41,170^A0N,28,28^FH\^FDFabrica\87\C6o: ' + dToc(monthSub(dDtValid,_mesvalid)) + ' ^FS' + CRLF
 	cEtiqueta 	+= '^FT376,173^A0N,28,28^FH\^FDValidade: ' + dToc(dDtValid) + ' ^FS' + CRLF
	cEtiqueta 	+= '^FO10,46^GB782,0,1^FS' + CRLF
	cEtiqueta 	+= '^PQ1,0,1,Y' + CRLF
	cEtiqueta 	+= '^BY2,3,58^FT33,251^BCN,,Y,N^FD>;' + cCodBar + '^FS' + CRLF
	cEtiqueta 	+= '^XZ'
	*/

	//Novo Layout
	do Case
		Case nGridEtq == 1
			//cEtiqueta += '^FT32,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			//cEtiqueta += '^FT33,180^A0N,22,22^FH\^CI28^FD' + cDsQrCode +'   ^FS^CI27' + CRLF
			//cEtiqueta += '^FO200,48^GFA,333,1080,12,:Z64:eJzNkiEOg0AQRXchmwrEKiRn4AjsERBFcoeK1pOeBM0l4AgVlTRBIisbBHQ2YfaP4ACMenmZDPNnUeqM1TXgyoE3eF1BR9J/4OMVrO/gRHgzCr8IfwXbn/AvcC58WoKLGZzt/VFHftp3odmp4x0b1bOnXWr2lIlj+awhrvDUrOvgW8StHM6zTf4Te/+AuMWEuGmJuMWMuNnLvBEW3pSIa8nzfDPiPMlip9B/NS741Ybz6NEMzPEat8FXmpEe99kE/4GnKwSvHkr4FlwPYL6+L76+r/7gtXzlX9F/A1vRL/+GRMy/uGOvxT6ISx6ookadv/40dlGK:9D59' + CRLF
			//cEtiqueta += '^FT91,178^BQN,2,4' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + '   \0D\0A^FS' + CRLF

			//1o. layout pallet
			/*cEtiqueta += '^FT27,48^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT51,186^A0N,16,20^FH\^CI28^FD' + cDsQrCode +'^FS^CI27' + CRLF
			cEtiqueta += '^FT97,182^BQN,2,4' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + '\0D\0A\0D\0A^FS' + CRLF
			cEtiqueta += '^FO34,164^GB240,0,3^FS' + CRLF
			cEtiqueta += '^FO24,52^GB258,0,3^FS' + CRLF*/

			cEtiqueta += '^FT32,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT51,184^A0N,16,20^FH\^CI28^FD' + cDsQrCode +'^FS^CI27' + CRLF
			cEtiqueta += '^FT97,184^BQN,2,4' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + '\0D\0A\0D\0A^FS' + CRLF
			cEtiqueta += '^FO34,162^GB240,0,3^FS' + CRLF
			cEtiqueta += '^FO24,52^GB258,0,3^FS' + CRLF
			//cEtiqueta += '^LRY^FO0,0^GB272,0,184^FS^LRN' + CRLF
			cEtiqueta += '^LRY^FO20,0^GB270,0,192^FS^LRN' + CRLF

		Case nGridEtq == 2
			//cEtiqueta += '^FT312,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			//cEtiqueta += '^FT313,180^A0N,22,22^FH\^CI28^FD' + cDsQrCode +'   ^FS^CI27' + CRLF
			//cEtiqueta += '^FO480,48^GFA,333,1080,12,:Z64:eJzNkiEOg0AQRXchmwrEKiRn4AjsERBFcoeK1pOeBM0l4AgVlTRBIisbBHQ2YfaP4ACMenmZDPNnUeqM1TXgyoE3eF1BR9J/4OMVrO/gRHgzCr8IfwXbn/AvcC58WoKLGZzt/VFHftp3odmp4x0b1bOnXWr2lIlj+awhrvDUrOvgW8StHM6zTf4Te/+AuMWEuGmJuMWMuNnLvBEW3pSIa8nzfDPiPMlip9B/NS741Ybz6NEMzPEat8FXmpEe99kE/4GnKwSvHkr4FlwPYL6+L76+r/7gtXzlX9F/A1vRL/+GRMy/uGOvxT6ISx6ookadv/40dlGK:9D59' + CRLF
			//cEtiqueta += '^FT371,178^BQN,2,4' + CRLF
			//cEtiqueta +=  '^FH\^FDLA,' + cCodBar + '   \0D\0A^FS' + CRLF

			//1o. layout pallet
			/*cEtiqueta += '^FT307,48^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT331,186^A0N,16,20^FH\^CI28^FD' + cDsQrCode +'^FS^CI27' + CRLF
			cEtiqueta += '^FT377,182^BQN,2,4' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + '\0D\0A\0D\0A^FS' + CRLF
			cEtiqueta += '^FO314,164^GB240,0,3^FS' + CRLF
			cEtiqueta += '^FO304,52^GB258,0,3^FS' + CRLF*/

			cEtiqueta += '^FT312,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT331,184^A0N,16,20^FH\^CI28^FD' + cDsQrCode +'^FS^CI27' + CRLF
			cEtiqueta += '^FT377,184^BQN,2,4' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + '\0D\0A\0D\0A^FS' + CRLF
			cEtiqueta += '^FO314,162^GB240,0,3^FS' + CRLF
			cEtiqueta += '^FO304,52^GB258,0,3^FS' + CRLF
			//cEtiqueta += '^LRY^FO261,0^GB291,0,184^FS^LRN' + CRLF
			//cEtiqueta += '^LRY^FO280,0^GB291,0,190^FS^LRN' + CRLF
			cEtiqueta += '^LRY^FO295,0^GB272,0,192^FS^LRN' + CRLF

		Case nGridEtq == 3
			//cEtiqueta += '^FT591,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			//cEtiqueta += '^FT592,180^A0N,22,22^FH\^CI28^FD' + cDsQrCode +'   ^FS^CI27' + CRLF
			//cEtiqueta += '^FO759,48^GFA,333,1080,12,:Z64:eJzNkiEOg0AQRXchmwrEKiRn4AjsERBFcoeK1pOeBM0l4AgVlTRBIisbBHQ2YfaP4ACMenmZDPNnUeqM1TXgyoE3eF1BR9J/4OMVrO/gRHgzCr8IfwXbn/AvcC58WoKLGZzt/VFHftp3odmp4x0b1bOnXWr2lIlj+awhrvDUrOvgW8StHM6zTf4Te/+AuMWEuGmJuMWMuNnLvBEW3pSIa8nzfDPiPMlip9B/NS741Ybz6NEMzPEat8FXmpEe99kE/4GnKwSvHkr4FlwPYL6+L76+r/7gtXzlX9F/A1vRL/+GRMy/uGOvxT6ISx6ookadv/40dlGK:9D59' + CRLF
			//cEtiqueta += '^FT650,178^BQN,2,4' + CRLF
			//cEtiqueta += '^FH\^FDLA,' + cCodBar + '   \0D\0A^FS' + CRLF

			//1o. layout pallet
			/*cEtiqueta += '^FT586,48^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT610,186^A0N,16,20^FH\^CI28^FD' + cDsQrCode +'^FS^CI27' + CRLF
			cEtiqueta += '^FT656,182^BQN,2,4' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + '\0D\0A\0D\0A^FS' + CRLF
			cEtiqueta += '^FO593,164^GB240,0,3^FS' + CRLF
			cEtiqueta += '^FO583,52^GB258,0,3^FS' + CRLF*/

			cEtiqueta += '^FT591,45^A0N,26,23^FH\^CI28^FD' + Alltrim(cCodProd) + ' -' + Alltrim(substr(cDescPrd,1,15)) + '^FS^CI27' + CRLF
			cEtiqueta += '^FT610,184^A0N,16,20^FH\^CI28^FD' + cDsQrCode +'^FS^CI27' + CRLF
			cEtiqueta += '^FT656,184^BQN,2,4' + CRLF
			cEtiqueta += '^FH\^FDLA,' + cCodBar + '\0D\0A\0D\0A^FS' + CRLF
			cEtiqueta += '^FO593,162^GB240,0,3^FS' + CRLF
			cEtiqueta += '^FO583,52^GB258,0,3^FS' + CRLF
			//cEtiqueta += '^LRY^FO540,0^GB291,0,184^FS^LRN' + CRLF
			cEtiqueta += '^LRY^FO575,0^GB270,0,192^FS^LRN' + CRLF

	endCase

Return .T.
