#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "MATR410.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PlistBra ³ Autor ³ Paulo Boschetti       ³ Data ³ 16.02.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Pick List (Relacao de Materiais a retirar do almoxarifado)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±³                                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PlistBra( cOrdProdDe, cOrdProdAte )
********************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cString   := "SD4"
LOCAL cDesc     := "Este programa ira imprimir o Pick list"
LOCAL aOrd      := {}
                                                                 
PRIVATE limite    := 132 
PRIVATE tamanho   := "M"
PRIVATE nTipo     := 18
PRIVATE aReturn   := {"Zebrado",1,"Administracao",1,2,1,"",1}
PRIVATE aLinha    := {}, nLastKey := 0, cPerg := ""
PRIVATE nomeprog  := "PLISTBRA"
PRIVATE wnrel     := "PLISTBRA"
PRIVATE titulo    := "Pick List"
PRIVATE CbCont,cabec1,cabec2

Pergunte("MTR410",.F.)  // Verifica as perguntas selecionadas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01              Data de                                ³
//³ mv_par02              Data Ate                               ³
//³ mv_par03              Almoxarifado de                        ³
//³ mv_par04              Almoxarifado ate                       ³
//³ mv_par05              OP de                                  ³
//³ mv_par06              OP Ate                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:= SetPrint( cString, wnrel, cPerg, @titulo, cDesc,"", "", .F., aOrd,, Tamanho )

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
EndIf

RptStatus({|lEnd| C410ImpBRA( @lEnd, wnRel, titulo, Tamanho, cOrdProdDe, cOrdProdAte )}, titulo )

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C410IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 14.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR410			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C410ImpBRA( lEnd, WnRel, Titulo, Tamanho, cOrdProdDe, cOrdProdAte )
***************************************************************************
LOCAL cProdAnt  := Space(17)
LOCAL nCount    := 0
LOCAL nTotProd  := 0
LOCAL cQuery    := ""
LOCAL cIndex    := CriaTrab("",.F.)
LOCAL nIndex    := 0
LOCAL nQuantLote:= 0
LOCAL nSaldoProd:= 0
LOCAL cItemLido := ""
LOCAL cQuery2   := ""
LOCAL cOp       := ""
LOCAL lExCpo    := .f.

lImpOpAux := .t.
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 0

MV_PAR01:= dDataBase - (365 * 5)
MV_PAR02:= CtoD("11/11/2099")
MV_PAR03:= "  "
MV_PAR04:= "ZZ"
MV_PAR05:= cOrdProdDe
MV_PAR06:= cOrdProdAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Cabec1 := ""
Cabec2 := ""

nTipo:= IIF( aReturn[4] == 1, 15, 18 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt := SPACE(10)
cbcont:= 00
li    := 80
m_pag := 01

DbSelectArea("SB1")
DbSetOrder(1)
DbSelectArea("SB8")
DbSetOrder(1)
DbSelectArea("SD4")
DbSetOrder(1)

lExCpo:= U_ValCpo( "SB1", "B1_X_PICK" )

If Len( ALLTRIM( MV_PAR01 ) ) == 0
	MV_PAR01:= DDATABASE - (365 * 5)
EndIf

cQuery:= "SELECT D4_OP,R_E_C_N_O_ MRECSD4 "
cQuery+= " FROM "+ RetSQLName("SD4")
cQuery+= " WHERE D_E_L_E_T_ = ''"
cQuery+= " AND D4_DATA BETWEEN '"  + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
cQuery+= " AND D4_LOCAL BETWEEN '" + MV_PAR03       + "' AND '" + MV_PAR04 + "'"
cQuery+= " AND D4_OP BETWEEN '"    + MV_PAR05       + "' AND '" + MV_PAR06 + "'"
cQuery+= " ORDER BY D4_FILIAL, D4_OP, D4_LOCAL, D4_TRT"
cQuery:= ChangeQuery(cQuery)
If (Select("MSD4") <> 0)
	dbSelectArea("MSD4")
	dbCloseArea()
Endif
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"MSD4",.F.,.T.)

SetRegua(1)
MSD4->(DbGoTop())
While !MSD4->(Eof())

	SD4->(dbGoto(MSD4->MRECSD4))

	cOp    := SD4->D4_OP
	_vcodop:= Posicione("SC2",1,xFilial("SC2")+cOP,"C2_PRODUTO")
	_vdescp:= AllTrim(Posicione("SB1",1,xFilial("SB1")+_vcodop,"B1_DESC"))
	
	IncRegua()
	
	If lExCpo
		DbSelectArea("SB1")
		If DbSeek(xFilial("SB1")+_vcodop)
			If (SB1->B1_x_pick == "2")
				dbSelectArea("MSD4")
				MSD4->(DbSkip())
				Loop
			EndIf
		EndIf
		DbSelectArea("MSD4")
	EndIf
	
	If lEnd
		@ Prow()+1,001 PSay STR0007
		Exit
	EndIf
	
	lImpOpAux := .T.
	
	DbSelectArea("MSD4")
	While !MSD4->(Eof()).and.(MSD4->D4_OP == cOp)

		SD4->(dbGoto(MSD4->MRECSD4))

		DbSelectArea("MSD4")
		If lEnd
			@ Prow()+1, 001 PSay STR0007
			Exit
		EndIf
		
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				MSD4->(DbSkip())
				Loop
			EndIf
		EndIf
		
		If (SubStr(SD4->D4_COD,1,3) == "MOD")
			MSD4->(DbSkip())
			Loop
		EndIf
		
		//Devolve saldo do Empenho
		//////////////////////////
		nSaldo := SD4->D4_picklst
		If (nSaldo > 0)
			_LOCAL := "10" ; aLotes := {} ; nQuant := 0
			SB8->(dbSeek(xFilial("SB8")+SD4->D4_cod+_LOCAL,.T.))
			While !SB8->(Eof()).and.(xFilial("SB8") == SB8->B8_filial).and.(SB8->B8_produto+SB8->B8_local == SD4->D4_cod+_LOCAL)
				If (SB8->B8_saldo > 0).and.(SB8->B8_picklst > 0)
				   aadd(aLotes,SB8->(Recno()))
				Endif
				SB8->(dbSkip())
			Enddo
			For nx := Len(aLotes) to 1 step -1
				SB8->(dbGoto(aLotes[nx]))
				nQuant := Min(SB8->B8_saldo,SB8->B8_picklst)
				RecLock("SB8",.F.)
				SB8->B8_picklst -= nQuant
				MsUnlock("SB8")
				nSaldo -= nQuant
				If (nSaldo <= 0)
					Exit
				Endif			
			Next nx
			Reclock("SD4",.F.)
			SD4->D4_picklst := Max(nSaldo,0)
			MsUnlock("SD4")
		Endif
		
		If (SD4->D4_QUANT > 0)
			If Li > 56 .And. !lImpOpAux
				Li:= Cabec( Titulo, Cabec1, Cabec2, wnRel, Tamanho, nTipo,, .F. )
				@ Li, 000 PSay "CODIGO  |DESCRICAO                                                                |UM|    QUANT   | LOTE.SUGER | LOTE.REAL  "
				// Li++
			Endif
			
			DbSelectArea("SB1")
			If DbSeek(xFilial("SB1")+SD4->D4_COD )
				If lExCpo .And. (SB1->B1_x_pick == "2")
					DbSelectArea("MSD4")
					MSD4->(DbSkip())
					Loop
				EndIf
				
				If lImpOpAux
					Li:= Cabec( Titulo, Cabec1, Cabec2, wnRel, Tamanho, nTipo,, .F. )
					@ ++Li, 000 PSay "OP NR: " + MSD4->D4_OP + "->  " + Alltrim( _vcodop ) + " - " + _vdescp
					@ ++Li, 000 PSay __PrtThinLine()
					@ ++Li, 000 PSay "CODIGO  |DESCRICAO                                                                |UM|    QUANT   | LOTE.SUGER | LOTE.REAL  "
					@ ++Li, 000 PSay __PrtThinLine()
					lImpOpAux:= .f.
				EndIf
				
				@ ++Li, 000 PSay Substr( SD4->D4_COD, 1, 8 )
				@   Li, 008 PSay "|"//008
				@   Li, 009 PSay Substr( SB1->B1_DESC, 1, 70 )
				@   Li, 082 PSay "|"   //42
				@   Li, 083 PSay SB1->B1_UM //43
				@   Li, 085 PSay "|"   //45
				//@   Li, 095 PSay MSD4->D4_QUANT Picture "@E 9,999,999.999"
				//@   Li, 109 PSay "|"
				
			Endif
			
			_LOCAL:='10'  //rodolfo
			
			If (SD4->D4_COD != cItemLido)
				SB8->(dbSeek(xFilial("SB8")+SD4->D4_COD+_LOCAL)) //MSD4->D4_LOCAL
			EndIf
			
			//Reserva Saldo PickList
			////////////////////////
			aQuantLote := {} ; nQuantLote := 0 ; nSaldoProd := 0 ; nNecessita := SD4->D4_QUANT
			While ( SB8->B8_PRODUTO == SD4->D4_COD ) .AND. ( _LOCAL == SB8->B8_LOCAL ) .AND. ( nNecessita > 0 )
				If ( SB8->B8_SALDO - SB8->B8_PICKLST ) >= nNecessita .AND. ( SB8->B8_SALDO - SB8->B8_PICKLST ) > 0
					t := Ascan(aQuantLote, {|x| alltrim(x[1])  == ALLTRIM(SB8->B8_LOTECTL)})
					If t == 0
						AADD( aQuantLote, { SB8->B8_LOTECTL, DTOC(SB8->B8_DTVALID), nNecessita, SB8->B8_LOCAL } )
					Else
						aQuantLote[t,3] += nNecessita
					Endif					
					//SB8/////////////
					RecLock("SB8",.F.)
					SB8->B8_picklst += nNecessita
					MsUnlock("SB8")
					//SD4/////////////
					RecLock("SD4",.F.)
					SD4->D4_picklst += nNecessita
					MsUnlock("SD4")
					//////////////////
					nNecessita:= 0
				ElseIf (SB8->B8_SALDO - SB8->B8_PICKLST) > 0
					nNecessita:= nNecessita - ( SB8->B8_SALDO - SB8->B8_PICKLST )					
					t := Ascan(aQuantLote, {|x| alltrim(x[1])  == ALLTRIM(SB8->B8_LOTECTL)})
					If t == 0
						AADD( aQuantLote, { SB8->B8_LOTECTL, DTOC(SB8->B8_DTVALID), SB8->B8_SALDO - SB8->B8_PICKLST, SB8->B8_LOCAL } )						
					Else
						aQuantLote[t,3] += SB8->B8_SALDO - SB8->B8_PICKLST						
					Endif
					//SB8/////////////
					RecLock("SB8",.F.)
					SB8->B8_picklst += SB8->B8_saldo
					MsUnlock("SB8")
					//SD4/////////////
					RecLock("SD4",.F.)
					SD4->D4_picklst += SB8->B8_saldo
					MsUnlock("SD4")
					//////////////////
				EndIf				
				SB8->( dbSkip() )
			Enddo
			
			If Empty( SD4->D4_LOTECTL )
				If  Len( aQuantLote ) > 0
					For I:= 1 To Len( aQuantLote )
						If (I > 1)
							@ Li, 000 PSay " "
							@ Li, 008 PSay "|"
							@ Li, 009 PSay " "
							@ Li, 082 PSay "|"
							@ Li, 083 PSay SB1->B1_UM
							@ Li, 085 PSay "|"
						Endif						
						@ Li, 086 PSay aQuantLote[I][3] Picture "@E 999,999.999"//"@E 9,999,999.999"            //55
						@ Li, 098 PSay "|"        //69
						@ Li, 100 PSay aQuantLote[I][1]
						@ Li, 111 PSay "|"
						Li++
					Next
					If  nNecessita > 0
						@  Li, 086 PSay nNecessita Picture "@E 999,999.999"
						@  Li, 098 PSay "|"
						@  Li, 100 PSay SPACE(10)//MSD4->D4_LOTECTL
						@  Li, 111 PSay "|"
						Li++
					Endif
				Else
					@  Li, 086 PSay SD4->D4_QUANT Picture "@E 999,999.999"
					@  Li, 098 PSay "|"
					@  Li, 100 PSay "*SEM SALDO*"
					@  Li, 111 PSay "|"
					Li++
				Endif
			Else
				@  Li, 086 PSay SD4->D4_QUANT Picture "@E 9,999.999"
				@  Li, 098 PSay "|"
				@  Li, 100 PSay SD4->D4_LOTECTL
				@  Li, 111 PSay "|"
				Li++
			ENDIF

			@ Li, 000 PSay "--------|-------------------------------------------------------------------------|--|------------|------------|---------------------| "
			
			If !Empty( AllTrim( Substr( SB1->B1_DESC, 71, 80 ) ) )
				@ ++Li, 000 PSay "       |"
				@   Li, 008 PSay Substr( SB1->B1_DESC, 71, 80 )
				@   Li, 051 PSay "|  |              |"
				@ ++Li, 000 PSay "--------|-------------------------------------------------------------------------|--|------------|------------|---------------------| "
			EndIf
		Endif
		
		cItemLido:= SD4->D4_COD
		
		DbSelectArea("MSD4")
		MSD4->(DbSkip())
	Enddo
	
	aArea   := GetArea()
	cabecrot()
	
	DbSelectArea("MSD4")
	
	nTotProd := 0
	nCount := 0
Enddo

//If Li!= 80
//	Roda( cbcont, cbtxt, Tamanho )/
//EndIf

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("MSD4")
DbCloseArea()

If aReturn[5] = 1
	ourspool(wnrel)
Endif

MS_FLUSH()

//cQuery2:= "UPDATE SB8010 SET B8_PICKLST = '0' WHERE B8_PICKLST  > 0 "
//nRet   := TCSQLEXEC(cQuery2)

DbSelectArea("SB1")
Set Filter To

DbSelectArea("SB8")
Set Filter To

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLISTBRA  ºAutor  ³Microsiga           º Data ³  09/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CabecRot()
***********************
cCabec2:= "RECURSO                       FERRAMENTA               OPERACAO"
If Li > 56 .And. !lImpOpAux
	Li:= Cabec( Titulo, Cabec1, Cabec2, wnRel, Tamanho, nTipo,, .F. )
	@ ++Li, 00 PSay __PrtFatLine()
	@ ++Li, 00 PSay cCabec2
	//@ ++Li, 000 PSay "OP NRS: " + MV_PAR05 + "A " + MV_PAR06
	@ ++Li, 00 PSay __PrtFatLine()
	ROTOPER()
Elseif ((Li+8) < 56)	
	Li:=Li+2
	@ ++Li, 00 PSay __PrtFatLine()
	@ ++Li, 00 PSay cCabec2
	//@ ++Li, 000 PSay "OP NRS: " + MV_PAR05 + "A " + MV_PAR06
	@ ++Li, 00 PSay __PrtFatLine()
	ROTOPER()
Else
	Li:= Cabec( Titulo, Cabec1, Cabec2, wnRel, Tamanho, nTipo,, .F. )
	@ ++Li, 00 PSay __PrtFatLine()
	@ ++Li, 00 PSay cCabec2
	//@ ++Li, 000 PSay "OP NRS: " + MV_PAR05 + "A " + MV_PAR06
	@ ++Li, 00 PSay __PrtFatLine()
	ROTOPER()
Endif
RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PLISTBRA  ºAutor  ³Microsiga           º Data ³  09/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ROTOPER()
***********************
DbSelectArea("SH1")
DbSeek(xFilial("SH1")+'FR001')

//DbSelectArea("SG2")
//If DbSeek( xFilial() + 4040001         + "01" )

@ ++Li, 000 PSay "FR001" + " " + "FRACIONAMENTO SOLIDOS          "
@   Li, 033 PSay SG2->G2_FERRAM + " " + Subs( SH4->H4_DESCRI, 1, 20 )
@   Li, 061 PSay "FRACIONAR SOLIDOS  "
@ ++Li, 000 PSay "QTD MOD:. 1  "
@ ++Li, 000 PSay " INICIO  REAL : ____/ ____/____ ___:___"
//@ ++Li, 00 PSay "TERMINO ALOC.: " +IIf( lSH8, DTOC( SH8->H8_DTFIM ), Space(8) ) + " " +IIf( lSH8, SH8->H8_HRFIM, Space(5)) + "  TERMINO REAL : ____/ ____/____ ___:___"
@ ++Li, 000 PSay " TERMINO REAL : ____/ ____/____ ___:___"
@ ++Li, 000 PSay "Quantidade :"
@ ++Li, 001 PSay "--------------------------------------------------------------------------------"
++Li

Return