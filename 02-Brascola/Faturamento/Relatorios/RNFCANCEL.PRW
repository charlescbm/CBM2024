#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RNFCancel� Autor � AP6 IDE            � Data �  10/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RNFCancel()
**********************
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Notas Fiscais Canceladas"
Local nLin         := 80
Local Cabec1       := "Seq.  Filial Emissao   N.Fiscal  Pedido  Cliente               Motivo                                                       G.Paga NF.Devolucao Dt.Canc.    Valor Bruto"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}

Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "RNFCANC"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RNFCANC"
Private cString    := ""
Private cPerg      := Padr( 'RNFCANC', Len( SX1->X1_GRUPO ) )

ValPergunte(cPerg)

Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint( cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .f., aOrd, .f., Tamanho )

If nLastKey == 27
	Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif

nTipo := If( aReturn[4] == 1, 15, 18 )

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus( {|| RunReport( Cabec1, Cabec2, Titulo,nLin ) }, Titulo )

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  10/12/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
***********************************************
Local _cMotivo:= ''
Local _cDesc  := ''
Local _Query  := ''
Local _nTotMoD:= 0
Local _nTotMoE:= 0
Local _nTotalD:= 0
Local _nTotalE:= 0
Local _aTotMes:={}
Local _aTotGer:={}

_Query:= "SELECT PA2_FILIAL, PA2_DOC, PA2_SERIE, PA2_EMISSA, PA2_DTCANC, PA2_OBS, PA2_TIPO, PA2_GP, A1_NREDUZ, PA2_NDEV, PA2_CLIENT, PA2_LOJA, PA2_VLRBRU "
_Query+= "FROM " + RetSqlName("PA2") + " PA2, " + RetSqlName("SA1") + " SA1 "
_Query+= "WHERE PA2.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_   = ' ' "
_Query+= "AND PA2.PA2_FILIAL BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "' "
_Query+= "AND PA2.PA2_DTCANC BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
_Query+= "AND PA2.PA2_CLIENT = SA1.A1_COD "
_Query+= "AND PA2.PA2_LOJA   = SA1.A1_LOJA "
_Query+= "ORDER BY PA2_TIPO, PA2_FILIAL, PA2_DTCANC, PA2_DOC "
If Select('TRB') > 0
	TRB->( DbCloseArea() )
EndIf
TCQUERY _Query NEW ALIAS 'TRB'
      
_aTotMes := {}  
_aTotGer := {0,0,0,0,0,0,0,0,0,0,0,0}
DbSelectArea('TRB')
SetRegua(RecCount())
DbGoTop()
nContAux:= 0
While !TRB->(Eof())
		
	If lAbortPrint
		@ nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	If (mv_par03 == 1).and.(nLin > 55)
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
		nLin:= 8
	Endif
		
	_cMotivo := TRB->PA2_TIPO
	_nTotMoD := 0 ; _nTotMoE := 0
		
	While !TRB->(Eof()).and.(_cMotivo == TRB->PA2_TIPO)

		If lAbortPrint
			@ nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If (mv_par03 == 1).and.(nLin > 55)
			Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
			nLin:= 8
		Endif
		
		Set Deleted Off
			
		DbSelectArea('SD2')
		DbSetOrder(3)
		If !DbSeek( "01" + TRB->PA2_DOC + TRB->PA2_SERIE + TRB->PA2_CLIENT + TRB->PA2_LOJA, .t. )
			Set Deleted On
			DbSelectArea('TRB')
			DbSkip()
			Loop
		EndIf
			
		Set Deleted On
			
		cPedAux:= SD2->D2_PEDIDO
		_cDesc := TRB->PA2_OBS
			
		DbSelectArea('ZZC')
		DbSetOrder(1)
		If DbSeek( xFILIAL('ZZC') + TRB->PA2_TIPO,  .t. )
			_cDesc:= ZZC_DESC
		EndIf
			
		// Seq.  Filial Emissao   N.Fiscal  Pedido  Cliente               Motivo                                                       G.Paga NF.Devolucao Dt.Canc.    Valor Bruto
		// 9999    99   99/99/99  999999    999999  XXXXXXXXXXXXXXXXXXXX  intem 03 com problema no cliente nao podemos mandar... desaC    X    XXXXXXXXX   99/99/99 999,999,999.99
		// 0         1         2         3         4         5         6         7         8         9        10        11        12        13        14         15       16
		// 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			
		If (MV_PAR03 == 1)
			DbSelectArea('TRB')
			@ ++nLin, 000 PSay ++nContAux Picture "@E 9999"
			@   nLin, 008 PSay TRB->PA2_FILIAL
			@   nLin, 013 PSay StoD(TRB->PA2_EMISSA)
			@   nLin, 023 PSay TRB->PA2_DOC
			@   nLin, 033 PSay cPedAux
			@   nLin, 041 PSay TRB->A1_NREDUZ
			@   nLin, 063 PSay Substr( _cDesc, 1, 60 )
			@   nLin, 127 PSay TRB->PA2_GP
			@   nLin, 132 PSay TRB->PA2_NDEV
			@   nLin, 144 PSay StoD(TRB->PA2_DTCANC)
			@   nLin, 153 PSay TRB->PA2_VLRBRU Picture '@E 999,999,999.99'
			If  !Empty( Substr( _cDesc, 61, 120 ) )
				@ ++nLin, 063 PSay Substr( _cDesc, 061, 60 )
			EndIf
			If  !Empty( Substr( _cDesc, 121, 150 ) )
				@ ++nLin, 063 PSay Substr( _cDesc, 121, 30 )
			EndIf
		Endif
			
		If !Empty( TRB->PA2_NDEV )
			_nTotMoD+= TRB->PA2_VLRBRU
			_nTotalD+= TRB->PA2_VLRBRU
		Else
			_nTotMoE+= TRB->PA2_VLRBRU
			_nTotalE+= TRB->PA2_VLRBRU
		EndIf      
		
		nPos1 := aScan(_aTotMes,{|x| x[1]==TRB->PA2_TIPO })
		If (nPos1 == 0)
			aadd(_aTotMes,{TRB->PA2_tipo,Array(12)})
			nPos1 := Len(_aTotMes)
			aFill(_aTotMes[nPos1,2],0)
		Endif
		nPos2 := Val(Substr(TRB->PA2_dtcanc,5,2))
		If (nPos1 > 0).and.(nPos2 > 0)
			_aTotMes[nPos1,2,nPos2]++
		Endif
		If (nPos2 > 0)
			_aTotGer[nPos2]++
		Endif
			
		TRB->(DbSkip())
	EndDo

	If (MV_PAR03 == 1).and.((_nTotMoD+_nTotMoE) <> 0)
		@ ++nLin, 070 PSay 'Total devolu��es '+Substr( _cDesc, 1, 60 )+': '
		@   nLin, 153 PSay _nTotMoD Picture '@E 999,999,999.99'
		@ ++nLin, 070 PSay 'Total exclus�es '+Substr( _cDesc, 1, 60 )+' : '
		@   nLin, 153 PSay _nTotMoE Picture '@E 999,999,999.99'
		@ ++nLin, 070 PSay 'Total motivo '+Substr( _cDesc, 1, 60 )+'    : '
		@   nLin, 153 PSay _nTotMoD + _nTotMoE Picture '@E 999,999,999.99'
		nLin++
	EndIf
		
Enddo
If (MV_PAR03 == 1).and.((_nTotalD+_nTotalE) <> 0)
	@ ++nLin, 125 PSay 'Total geral devolu��es: '
	@   nLin, 153 PSay _nTotalD Picture '@E 999,999,999.99'
	@ ++nLin, 125 PSay 'Total geral exclus�es : '
	@   nLin, 153 PSay _nTotalE Picture '@E 999,999,999.99'
	@ ++nLin, 125 PSay 'Total geral           : '
	@   nLin, 153 PSay _nTotalD + _nTotalE Picture '@E 999,999,999.99'
Endif
                  
If (MV_PAR03 == 2) //Sintetico       
	Cabec1 := "MOTIVO CANCELAMENTO"
	Cabec1 := Cabec1+Space(70-Len(Cabec1))
	For ny := 1 to 12
		Cabec1 += PadL(Alltrim(Upper(Substr(MesExtenso(ny),1,3))),10)
	Next ny
	SetRegua(Len(_aTotMes))
	For nx := 1 to Len(_aTotMes)
		                   
		Incregua()	

		If lAbortPrint
			@ nLin, 000 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 55
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin:= 8
		Endif
		
		_cDesc := ""
		ZZC->(dbSetOrder(1))
		If ZZC->(dbSeek(xFilial("ZZC")+_aTotMes[nx,1]))
			_cDesc := ZZC->ZZC_desc
		EndIf
		
		@ nLin,000 PSAY _aTotMes[nx,1]+" "+Alltrim(Substr(_cDesc,1,60))
		nCol := 70
		For ny := 1 to 12
			@ nLin,nCol PSAY _aTotMes[nx,2,ny]  PICTURE "99,999,999"
			nCol += 10
		Next ny
		nLin++
		
	Next nx
	nLin++
	@ nLin,000 PSAY "T O T A L >"
	nCol := 70
	For ny := 1 to 12
		@ nLin,nCol PSAY _aTotGer[ny]  PICTURE "99,999,999"
		nCol += 10
	Next ny
	nLin++

Endif

Roda()

DbSelectArea('TRB')
DbCloseArea()

If aReturn[5]==1
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValPergunte�Autor  �Microsiga          � Data �  08/11/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValPergunte( cPerg )

DbSelectArea("SX1")
DbSetOrder(1)

aRegs:={}

aAdd( aRegs, { cPerg, "01", "Data De? "       , "", "", "MV_CH1", "D" ,08, 0, 0, "G", "", "MV_PAR01", ""         , "", "", "", "", ""         ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { cPerg, "02", "Data Ate? "      , "", "", "MV_CH2", "D" ,08, 0, 0, "G", "", "MV_PAR02", ""         , "", "", "", "", ""         ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { cPerg, "03", "Tipo relat�rio:" , "", "", "MV_CH3", "N" ,01, 0, 0, "C", "", "MV_PAR03", "Analitico", "", "", "", "", "Sintetico","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { cPerg, "04", "Da  Filial:"     , "", "", "MV_CH4", "C" ,02, 0, 0, "G", "", "MV_PAR04", ""         , "", "", "", "", ""         ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )
aAdd( aRegs, { cPerg, "05", "Ate Filial:"     , "", "", "MV_CH5", "C" ,02, 0, 0, "G", "", "MV_PAR05", ""         , "", "", "", "", ""         ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" } )

For I:= 1 to Len( aRegs )
	If !DbSeek( cPerg + aRegs[I,2])
		RecLock( "SX1", .t. )
		For J:= 1 To Max( FCount(), Len( aRegs[I] ) )
			FieldPut( J, aRegs[I,J] )
		Next
		MsUnlock()
		DbCommit()
	EndIf
Next

Return