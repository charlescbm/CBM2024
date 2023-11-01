#INCLUDE "PROTHEUS.CH"

// Fonte com funções para facilitar o uso de dicionários com o Lobo Guará
// Autor: Octávio Augusto
// Data: 23/05/2019   
//                          ,     ,
//                          |\---/|
//                         /  , , |
//                    __.-'|  / \ /
//           __ ___.-'        ._O| AUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU
//        .-'  '        :      _/
//       / ,    .        .     |
//      :  ;    :        :   _/
//      |  |   .'     __:   /
//      |  :   /'----'| \  |
//      \  |\  |      | /| |
//       '.'| /       || \ |
//       | /|.'       '.l \\_
//       || ||             '-'
//       '-''-'

Static aParCache := {}

// Função para quando usar RecLock em dicionário, colocar o valor nos campos
User Function LGFPut(cField, xVal)
	
	FieldPut(FieldPos(cField), xVal)
	
Return

// Função para retornar valor dos campos da tabela
User Function LGFGet(cField)
	
Return FieldGet(FieldPos(cField))

// Abre um dicionário de dados quando não carregou ainda pelo sistema.
User Function LGAbreDic(cTab, cAli, cEmp, lShared)
	
	Default cAli := cTab
	
	OpenSxs(,,,, cEmp, cAli, cTab,, .F.,, lShared, )
	
Return Select(cAli) > 0

// Cria uma tabela temporária
User Function LGTab(aStruct, cAli, aIndex)
	
	Local nI
	Local oObj
	
	Default aIndex := {}
	
	oObj := FWTemporaryTable():New(cAli)
	oObj:SetFields(aStruct)
	
	For nI := 1 To Len(aIndex)
		
		oObj:AddIndex(cValToChar(nI), aIndex[nI])
		
	Next nI
	
	oObj:Create()
	
Return oObj

// Apaga a tabela temporária por meio do objeto
User Function LGDelTab(oObj)
	
	oObj:Delete()
	
Return

// Utilizado para substituir o conout.
User Function LGLog(cMsg, cTipo, cGroup, cCategory, cStep, cId)
	
	Default cTipo := "INFO"
	Default cGroup := "URBLOG"
	Default cCategory := FunName()
	Default cStep := ""
	Default cId := "01"
	
	If !Empty(cMsg)
	
		FwLogMsg(cTipo, /*cTransactionId*/, cGroup, cCategory, cStep, cId, cMsg, 0, 0, {})
		
	EndIf
	
Return

// Devido que em alguns casos acusa erro de GetMV em Loop porém, se faz necessário porque o próprio parâmetro é atualizado no Loop
// Desenvolvido sistema de Cache de Parâmetro!
User Function LGMV(cPar, nTipo, xDefault, lFil, lRefresh)
	
	Local xRet
	Local nPos
	
	Default nTipo := 1
	Default lRefresh := .F.
	
	nPos := AScan(aParCache, {|x| ;
		AllTrim(x[1]) == AllTrim(cPar) .And. ;
		x[2] == cFilAnt .And. ;
		x[3] == lFil .And. ;
		x[4] == xDefault ;
		})
		
	If !lRefresh .And. nPos > 0
		
		Return aParCache[nPos][5]
		
	EndIf
	
	If nTipo == 1
		
		xRet := GetMv(cPar)
		
	ElseIf nTipo == 2
		
		xRet := GetNewPar(cPar, xDefault)
		
	ElseIf nTipo == 3
		
		xRet := SuperGetMv(cPar, lFil, xDefault)
		
	EndIf
	
	If nPos == 0
		
		AAdd(aParCache, {cPar, cFilAnt, lFil, xDefault, xRet})
		
	Else
		
		aParCache[nPos] := {cPar, cFilAnt, lFil, xDefault, xRet}
	
	EndIf
	
Return xRet

// executa o pergunte, pois há casos de loop onde é necessário o Pergunte.
User Function LGPerg(cPerg, cVisu)
	
Return Pergunte(cPerg, cVisu)

// Verifica se o usuário está no parâmetro.
User Function LGUPar(cPar)

Return AllTrim(__cUserId) $ U_LGMV(cPar, 2, "", , .T.)

// Função que pega um array de índices no formato antigo e passa para o novo da FWTemporaryTable
// Ex.: {"B1_COD+B1_DESC", "B1_POSIPI"} => {{"B1_COD", "B1_DESC"}, {"B1_POSIPI"}}
User Function LGFIdx(aIdxs)
	
	Local aNewIdx := {}
	Local nI
	Local nX
	Local aAux
	
	For nI := 1 To Len(aIdxs)
		
		aAux := StrTokArr(aIdxs[nI], "+")
		AAdd(aNewIdx, {})
		
		For nX := 1 To Len(aAux)
			
			AAdd(ATail(aNewIdx), aAux[nX])
			
		Next nX
		
	Next nI 
	
Return aNewIdx

User Function UrbSe(lCond, xSim, xNao)

Return IIf(lCond, xSim, xNao)

User Function USqlCmps(cTab, cAlias, lRec, cEmpOri)
	
	Local cRet := ""
	Local aCmp
	Local nI
	Local aArea := GetArea()
	
	Default cAlias := ""
	Default lRec := .F.
	Default cEmpOri := ""
	
	If AliasInDic(cTab)
		
		dbSelectArea(cTab)
		
		aCmp := FWSX3Util():GetAllFields(cTab, .F.)
		
		For nI := 1 To Len(aCmp)

			//GoOne Consultoria - Crele Cristina - Chamado 50850 - Verificar se campo existe na empresa que vai consultar
			if !empty(cEmpOri) .and. cEmpAnt <> cEmpOri
				cTable := cTab + cEmpOri + '0'
				If (Select("XTABLECOL") <> 0)
					XTABLECOL->(dbCloseArea())
				Endif
				BEGINSQL ALIAS "XTABLECOL"
					SELECT COLUMN_NAME FROM DBA_TAB_COLUMNS
					WHERE TABLE_NAME = %exp:cTable% AND COLUMN_NAME = %exp:aCmp[nI]%
				ENDSQL
				if empty(XTABLECOL->COLUMN_NAME)
					loop
				endif
				XTABLECOL->(dbCloseArea())
			endif
			
			If FWSX3Util():GetFieldType(aCmp[nI]) # "M" .And. !(AllTrim(aCmp[nI]) + "," $ cRet) .And. (cTab)->( FieldPos(aCmp[nI]) ) > 0
				
				If Empty(cAlias)
					
					cRet += AllTrim(aCmp[nI]) + ","
					
				Else
					
					cRet += cAlias + "." + AllTrim(aCmp[nI]) + ","
					
				EndIf
				
			EndIf
			
		Next nI
		
		If lRec
		
			If Empty(cAlias)
				
				cRet += "R_E_C_N_O_,"
				cRet += "D_E_L_E_T_,"
				
			Else
				
				cRet += cAlias + ".R_E_C_N_O_,"
				cRet += cAlias + ".D_E_L_E_T_,"
				
			EndIf
			
		EndIf
		
		cRet := Left(cRet, Len(cRet) - 1)
			
	EndIf
	
	RestArea(aArea)
	
Return cRet

//                               __
//                             .d$$b
//                           .' TO$;\
//                          /  : TP._;
//                        / _.;  :Tb|
//                        /   /   ;j$j
//                    _.-"       d$$$$
//                  .' ..       d$$$$;  
//                 /  /P'      d$$$$P. |\
//                /   "      .d$$$P' |\^"l
//              .'           `T$P^"""""  :
//          ._.'      _.'                ;
//       `-.-".-'-' ._.       _.-"    .-"
//     `.-" _____  ._              .-"
//    -(.g$$$$$$$b.              .'
//      ""^^T$$$P^)            .(:
//        _/  -"  /.'         /:/;
//     ._.'-'`-'  ")/         /;/;
//  `-.-"..--""   " /         /  ;
// .-" ..--""        -'          :
// ..--""--.-"         (\      .-(\
//   ..--""              `-\(\/;`
//     _.                      :
//                             ;`-
//                            :\
//                            ;
