#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10)

/*****************************************************************************/
/*/{Protheus.doc} ITECX080

@description Gera etiquetas

@author Bernard M. Margarido
@since 19/09/2018
@version 1.0

@type function
/*/
/*****************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function ITECX080()
Local aArea		:= GetArea()

Local cPerg		:= PadR("TESTM002",10)
Local cUsrId	:= "000000"
Local cCadastro	:= "Gera Etiquetas"

Local nOpcA		:= 0

Local aSays		:= {}
Local aButtons	:= {}

Local lGerou	:= .F.

//--------------------------------------+
// Somente utilizada pelo Administrador |
//--------------------------------------+
If cUsrId <> __cUserId
	MsgStop("Usuário sem acesso.","INOVEN - Avisos")
	RestArea(aArea)
	Return .T.
EndIf

//------------------------+
// Cria Parametros Rotina |
//------------------------+
AjustaSx1(cPerg)

//---------------------+
// Descrição da Rotina |
//---------------------+
aAdd(aSays,"Este programa tem o objetivo gerar etiquetas para notas que nao fo")
aAdd(aSays,"ram geradas, notas de entrada e notas de devolução.")

aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|| (nOpcA := 1,FechaBatch()) }} )
aAdd(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons ,,,445)

If nOpcA == 1
	FWMsgRun(, {|| TEstM02Etq(@lGerou) }, "Processando...", "Gerando Etiqueta..." )
	If lGerou
		MsgAlert("Etiquetas da Nota/Serie " + mv_par01 + "/" + mv_par02 + " geradas com sucesso.")
	EndIf
EndIf	 

RestArea(aArea)	
Return Nil

/*****************************************************************************/
/*/{Protheus.doc} TEstM02Etq

@description Gera Etoquetas ZZA

@author Bernard M. Margarido
@since 19/09/2018
@version 1.0

@type function
/*/
/*****************************************************************************/
Static Function TEstM02Etq(lGerou)
Local aArea		:= GetArea()

Local cAlias	:= GetNextAlias()
Local cNPallet	:= ""
Local cSeq		:= "001"

Local nQtdPallet:= 0
local nVolPallet:= 0
Local nCount	:= 0
Local nPallet	:= 0

//---------------+
// Consulta Nota |
//---------------+
If !TEstM02Qry(cAlias)
	MsgStop("Nao foram encontrado dados com os parametros passados. Favor verificar os parametros informados","INOVEN - Avisos")
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .F.
EndIf

//----------------+
// Posiciona Nota | 
//----------------+
dbSelectArea("SF1")
SF1->( dbSetOrder(1) )
SF1->( dbGoTo((cAlias)->RECNOSF1) )
    	    		
//------------------------+
// Complemento de Produto |
//------------------------+
dbSelectArea("SB5")
SB5->( dbSetOrder(1) )

//--------------------+
// Posiciona Etiqueta |
//--------------------+
dbSelectArea("ZZA")
ZZA->( dbSetOrder(1))
If ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
	MsgStop("Já existem etiquetas para essa nota.","INOVEN - Avisos")
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .F.
EndIf
    	
dbSelectArea("SD1")
SD1->( dbSetOrder( 1 ) )
If SD1->( DbSeek( SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
	
	//---------------+
	// Atualiza Flag |
	//---------------+
	RecLock("SF1",.F.)
		SF1->F1_XSTATUS := "1"
	SF1->( MsUnLock() )
	
    While SD1->( !Eof() ) .And. SD1->( D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA ) == ; 
                                SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )
                
        //------------------------------------------+
        // Valida a quantidade de caixas por Pallet |
        //------------------------------------------+
        nVolPallet := 0
        If SB5->( dbSeek(xFilial("SB5") + SD1->D1_COD) )
        	nVolPallet := SB5->B5_XPALLET
        EndIf
        
        lGerou 		:= .T.        
        nCount 		:= 1
        nPallet		:= 1
        nQtdPallet	:= Int(SD1->D1_QUANT/nVolPallet)
        cNPallet	:= ""
        If nQtdPallet > 0
        	cNPallet	:= PadL(Alltrim(SF1->F1_DOC),7,"0") + PadL(Alltrim(SF1->F1_SERIE),3,"0") + cSeq
        EndIf	
                
        While SD1->D1_QUANT >= nCount 
        	
            RecLock( "ZZA", .T. )
                ZZA->ZZA_FILIAL	:= xFilial( "ZZA" )
                ZZA->ZZA_CODPRO	:= SD1->D1_COD
                ZZA->ZZA_CODBAR := GetADVFVal( "SB1", "B1_CODBAR", xFilial( "SB1" ) + SD1->D1_COD, 1 )
                ZZA->ZZA_QUANT  := 1
                ZZA->ZZA_VLRUNI := SD1->D1_VUNIT
                ZZA->ZZA_NUMNF  := SF1->F1_DOC
                ZZA->ZZA_SERIE  := SF1->F1_SERIE
                ZZA->ZZA_FORNEC := SF1->F1_FORNECE
                ZZA->ZZA_LOJA   := SF1->F1_LOJA
                ZZA->ZZA_NUMCX  := StrZero(nCount,4)
                ZZA->ZZA_NUMLOT := SD1->D1_LOTECTL
                ZZA->ZZA_ITEMNF := SD1->D1_ITEM
                ZZA->ZZA_LOCENT := SD1->D1_LOCAL
                ZZA->ZZA_PALLET	:= cNPallet	
                ZZA->ZZA_BAIXA	:= "1"
                ZZA->ZZA_CONFER	:= .F.
            ZZA->( MsUnlock() )
            
            //------------------------------+
            // Valida se preencheu o Pallet |
            //------------------------------+
            If nPallet == nVolPallet .And. nQtdPallet <> 0
            	nPallet 	:= 0
            	cSeq		:= Soma1(cSeq)
            	cNPallet	:= PadL(Alltrim(SF1->F1_DOC),7,"0") + PadL(Alltrim(SF1->F1_SERIE),3,"0") + cSeq
            	nQtdPallet--
            ElseIf nQtdPallet == 0
            	cNPallet	:= ""
            EndIf	
            
            //-----------------+
            // Contador Rotina |
            //-----------------+
            nCount++
            nPallet++
                        
        EndDo
        SD1->( DbSkip() )
    EndDo 
EndIf

(cAlias)->(dbCloseArea() )

RestArea(aArea)
Return .T.

/*****************************************************************************/
/*/{Protheus.doc} TEstM02Qry

@description Consulta Nota de Entrada

@author Bernard M. Margarido
@since 19/09/2018
@version 1.0

@param cAlias	, characters, descricao
@type function
/*/
/*****************************************************************************/
Static Function TEstM02Qry(cAlias)
Local cQuery := ""

cQuery := "	SELECT " + CRLF
cQuery += "		F1.F1_DOC, " + CRLF
cQuery += "		F1.F1_SERIE, " + CRLF
cQuery += "		F1.R_E_C_N_O_ RECNOSF1 " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("SF1") + " F1 " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		F1.F1_FILIAL = '" + xFilial("SF1") + "' AND " + CRLF 
cQuery += "		F1.F1_DOC = '" + mv_par01 + "' AND " + CRLF
cQuery += "		F1.F1_SERIE = '" + mv_par02 + "' AND " + CRLF
cQuery += "		F1.F1_FORNECE = '" + mv_par03 + "' AND " + CRLF
cQuery += "		F1.F1_LOJA = '" + mv_par04 + "' AND " + CRLF
cQuery += "		F1.D_E_L_E_T_ = '' " + CRLF
cQuery += "	ORDER BY F1.F1_DOC,F1.F1_SERIE "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	Return .F.
EndIf

Return .T.

/*****************************************************************************/
/*/{Protheus.doc} AjustaSx1

@description Cria parametros rotina

@author Bernard M. Margarido
@since 19/09/2018
@version 1.0

@param cPerg	, characters, descricao
@type function
/*/
/*****************************************************************************/
Static Function AjustaSx1(cPerg)
Local aPerg := {}
Local aArea := GetArea()
Local i

aAdd(aPerg, {cPerg, "01", "Nota "	, "mv_ch1", "C", TamSX3("F1_DOC")[1]		, 0, "G"	, "mv_par01", "SF1VEI","","","",""})
aAdd(aPerg, {cPerg, "02", "Serie"	, "mv_ch2", "C", TamSX3("F1_SERIE")[1]		, 0, "G"	, "mv_par02", ""      ,"","","",""})
aAdd(aPerg, {cPerg, "03", "Forn\Cli", "mv_ch3", "C", TamSX3("F1_FORNECE")[1]	, 0, "G"	, "mv_par03", ""      ,"","","",""})
aAdd(aPerg, {cPerg, "04", "Loja"	, "mv_ch4", "C", TamSX3("F1_LOJA")[1]		, 0, "G"	, "mv_par04", ""      ,"","","",""})

For i := 1 To Len(aPerg)
	
	If  !SX1->( dbSeek(aPerg[i,1] + aPerg[i,2]) )		
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIf
	
		Replace X1_GRUPO   with aPerg[i,01]
		Replace X1_ORDEM   with aPerg[i,02]
		Replace X1_PERGUNT with aPerg[i,03]
		Replace X1_VARIAVL with aPerg[i,04]
		Replace X1_TIPO	   with aPerg[i,05]
		Replace X1_TAMANHO with aPerg[i,06]
		Replace X1_PRESEL  with aPerg[i,07]
		Replace X1_GSC	   with aPerg[i,08]
		Replace X1_VAR01   with aPerg[i,09]
		Replace X1_F3	   with aPerg[i,10]
		Replace X1_DEF01   with aPerg[i,11]
		Replace X1_DEF02   with aPerg[i,12]
		Replace X1_DEF03   with aPerg[i,13]
		Replace X1_DEF04   with aPerg[i,14]
	
	SX1->( MsUnlock() )
	
Next i

RestArea( aArea )
Return .T.
