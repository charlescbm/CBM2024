#include "rwmake.ch"
#include "topconn.ch"

User Function BACA010()
*********************
If (Alltrim(cUserName) == "mcunha").and.MsgYesNo("> Busco dados de MNT da base antiga?","ATENCAO")
	Processa({|| B010Proc() })
Endif
Return

Static Function B010Proc()
***********************
PRIVATE na, nb, nx, ny, cCampo
PRIVATE cFamilias := "SYP"
PRIVATE cDriver := ""

//Abrir SX3 base antiga
///////////////////////
If (Select("SX3ANT") <> 0)
	dbSelectArea("SX3ANT")
	dbCloseArea()
Endif
cDriSX3 := RetDrvFile('SX3')
DbUseArea(.T.,cDriSX3,"\TEMP\SX3ANT.DTC","SX3ANT",.T.,.F.)
cArqTmp := CriaTrab(NIL,.F.)
IndRegua("SX3ANT",cArqTmp,"X3_CAMPO",,,"Selecionando Registros")

//Procuro no SX2 pelas familias que precisam ser substituidas
/////////////////////////////////////////////////////////////
cDriver := "TOPCONN"
dbSelectArea("SX2")
SX2->(dbSetOrder(1))
SX2->(dbGotop())
Procregua(Reccount())
While !SX2->(Eof())
	
	If !(Left(SX2->X2_chave,3) $ cFamilias)
		Incproc()
		SX2->(dbSkip())
		Loop
	Else
		Incproc("> Importando Tabela "+SX2->X2_arquivo)
	Endif
	
	//Busco dados da Origem
	///////////////////////
	If (Left(SX2->X2_chave,3) $ cFamilias)
		dbSelectArea(SX2->X2_chave)
		aStru := dbStruct()
		dbCloseArea()
		cSource := "DADOS10.dbo."+SX2->X2_chave+"020"
		cTarget := SX2->X2_arquivo
		cCampo := PrefixoCpo(SX2->X2_chave)+"_FILIAL"
		///////////////////////
		If SX3ANT->(dbSeek(cCampo)).and.(TCSQLExec("SELECT COUNT(*) MRECNO FROM "+cSource) >= 0)
			nMax := BLastRec(cSource)+200
			BCopyFile(cSource,cTarget,aStru,nMax)
			TCSQLExec("DELETE FROM "+Alltrim(SX2->X2_arquivo)+" WHERE D_E_L_E_T_ = '*' ")
			SX3->(dbSetOrder(2))
			If SX3->(dbSeek(cCampo))
				TCSQLExec("DELETE FROM "+Alltrim(SX2->X2_arquivo)+" WHERE D_E_L_E_T_ = '' AND "+cCampo+" <> '' AND "+cCampo+" <> '04' ")
				TCSQLExec("UPDATE "+Alltrim(SX2->X2_arquivo)+" SET "+cCampo+" = '"+iif(SX2->X2_modo=="C",Space(2),xFilial(SX2->X2_chave))+"' ")
			Endif
		Endif
	Endif	
	SX2->(dbSkip())
Enddo

Return

Static Function BCopyFile(cSource,cTarget,aStru,nMax)
************************************************
LOCAL lBack := .T., cOldAlias := Alias()
cTarget := Alltrim(cTarget)
cSource := Alltrim(cSource)
If (cTarget == "SYP010")
	lBack := BAppend(cTarget,cSource,aStru,nMax)  // Transfere de cSource para cTarget
Else
	If TCCanOpen(cTarget)
		lBack := MsErase(cTarget)              // Deletando arquivo de Destino
	EndIf
	If (lBack) 
		If (lBack := MsCreate(cTarget,aStru,cDriver))  // Cria Arquivo de Destino
			lBack := BAppend(cTarget,cSource,aStru,nMax)  // Transfere de cSource para cTarget
			If (Select("TARGET") <> 0)
				dbSelectArea("TARGET")
				dbCloseArea()
			Endif
		Else
			MsgStop("Nao foi possivel criar o arquivo "+cTarget+"!")
		EndIf
	Else                                      
		MsgStop("Arquivo "+cTarget+" nao foi possivel excluir.")
	EndIf
Endif
If (Select(cOldAlias) > 0)
	dbSelectArea(cOldAlias)
EndIf
Return(lBack)

Static Function BAppend(cTarget,cSource,aNewStru,nMax)
************************************************
Local cStru,cCommand,cAlias,aOldStru,aNewStru,xConteudo,cNewStru,nRecno:= 0,cSelWhere,cNewCampo
Local lBack := .T., cSelect
cTarget := Alltrim(cTarget)
cSource := Alltrim(cSource)
cStru := ""
cNewStru := ""
For i := 1 To Len(aNewStru)
	lNewCpo := .F.
	cNewCampo := Alltrim(aNewStru[i,1])
	cNewCampo := cNewCampo+Space(10-Len(cNewCampo))
	If !SX3ANT->(dbSeek(cNewCampo))
		lNewCpo := .T.
		If aNewStru[i,2]=="C"
			xConteudo :="'"+Space(aNewStru[i,3])+"'"
		ElseIf aNewStru[i,2] =="N"
			xConteudo := "0"
		ElseIf aNewStru[i,2]=="D"
			xConteudo := "'"+ Space(8) + "'"
		ElseIf aNewStru[i,2] == "L"
			xConteudo := "'FALSE'"
		Else
			xConteudo := "''"
		EndIf
	Endif
	cStru += IIF(lNewCpo,xConteudo,ANewStru[i,1]) + ","
	cNewStru += aNewStru[i,1]+","
Next i
cStru += "D_E_L_E_T_,R_E_C_N_O_"
cNewStru +="D_E_L_E_T_,R_E_C_N_O_"
cSelect := "SELECT "+ cStru +" FROM "+ cSource
While nRecno < nMax
	nRecno += 1024
	cSelWhere := cSelect + " WHERE R_E_C_N_O_ > "+Alltrim(Str(nRecno-1024))+" AND R_E_C_N_O_ <= "+Alltrim(Str(nRecno))+" "
	cCommand := "INSERT INTO "+ cTarget +" ("+cNewStru+") (  "+ cSelWhere+" )"
	lBack := (TCSqlExec(cCommand) == 0)
	If (!lBack)
	
	Endif
End
TCRefresh(cTarget)
dbSelectArea(cAlias)
Return( lBack )

Static Function RetDrvFile(cAlias)
*******************************
Local cDriveSX := __cRdd

If ( Empty( cAlias ) )
	Return( __cRdd )
EndIf

#ifdef TOP
	cDriveSX := "DBFCDX"
#else
	#ifdef BTV
		cDriveSX := "DBFCDX"
	#endif
#endif

If cAlias $ 'SM0/SX1/SX6'
	cDriver := 'DBFCDX'
ElseIf cAlias == 'SX5'
	cDriver := __cRdd
ElseIf 'SX' $ cAlias .Or. cAlias == 'SIX'
	cDriver := cDriveSX
ElseIf cAlias $ 'SH7/SH9'
	#ifdef TOP
		cDriver := 'DBFCDX'
	#else
		cDriver := __cRdd
	#endif
Else
	cDriver := __cRdd
EndIf

Return( cDriver )

Static Function BLastRec(xSource)
*****************************
LOCAL nRetu := 0, cQuery1
cQuery1 := "SELECT MAX(R_E_C_N_O_) MRECNO FROM "+xSource
If (Select("MREC") <> 0)
	dbSelectArea("MREC")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MREC"
If !MREC->(Eof())
	nRetu := MREC->MRECNO
Endif
If (Select("MREC") <> 0)
	dbSelectArea("MREC")
	dbCloseArea()
Endif
Return nRetu