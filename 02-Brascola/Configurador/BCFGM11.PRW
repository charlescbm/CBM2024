#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBCFGM11   บ Autor ณ Sidinei            บ Data ณ  21/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Altera .INI do Server e Slaves                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BCFGM11()
***********************

PRIVATE cPERG := "BCGM11"+space(04)

dbSelectArea("SX1")
dbSetOrder(1)
If !dbseek(cPerg) 
  //PutSx1(cGrupo,cOrdem,  cPergunt            ,cPerSpa,cPerEng,  cVar  ,cTipo, nTam ,nDec,nPres,cGSC,cValid,cF3,cGrpSxg,cPyme,cVar01	  ,cDef01  ,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04     ,cDefSpa4   ,cDefEng4, cDef05   ,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"   ,"Environment        ?",   ""  ,   ""  ,"mv_ch1", "C" ,  30  ,  0 ,  0	,"G" ,  ""  ,""	,""	    ,""   ,"mv_par01" ,""	   ,""		,""		 ,""	,""		,""		 ,""	  ,""	 ,""  	  ,""	   ,""         ,""         ,""		,""		   ,""	 	,""		 ,{""}     ,{""}    ,{""})
	PutSx1(cPerg,"02"   ,"Novo Dir. APO      ?",   ""  ,   ""  ,"mv_ch2", "C" ,  30  ,  0 ,  0	,"G" ,  ""	,""	,""	    ,""	  ,"mv_par02" ,""	   ,""		,""		 ,""	,""		,""		 ,""	  ,""	 ,""   	  ,""	   ,""         ,""	       ,""		,""		   ,""	 	,""		 ,{""}     ,{""}    ,{""})
Endif

If !Pergunte(cPerg,.T.)
	Return
Endif

U_BCFGM01("BCFGM11")

cIni := SubStr(Time(),1,5)

lEnvAlt := .F.
cArq	:= "appserver.ini"

For _x := 0 to 11

	aReg 	:= {}
	
	Do Case
		Case _x == 0
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 1
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 2
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 3
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 4
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 5
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 6
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 7
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 8
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 9
			cLocal  := "N:\Protheus11\bin\slave"+AllTrim(Str(_x))+"N\"
		Case _x == 10
			cLocal  := "N:\Protheus11\bin\appserver\"      
		Case _x == 11
			cLocal  := "N:\Protheus11\bin\appserverjob\"    
		Case _x == 12
			cLocal  := "N:\Protheus11\bin\appserverti\"
	EndCase
	
	If (nHandle := FT_FUSE(AllTrim(cLocal+cArq))) == -1
		MsgStop("Nao foi possivel abrir o arquivo "+cLocal+cArq)
		Loop
	EndIf
	
	FT_FGOTOP()
	While !FT_FEOF()
		
		cLinha := Alltrim(FT_FREADLN())
		
		If Upper(cLinha) $ "["+AllTrim(mv_par01)+"]"
			lEnvAlt := .T.
		EndIf
		
		If lEnvAlt
			If SubStr(cLinha,1,10) == "SOURCEPATH"
				cLinha := "SOURCEPATH=D:\TOTVS\Protheus11\ambientes\producao\apo\"+AllTrim(mv_par02)
				aadd(aReg,{AllTrim(cLinha)})
				lEnvAlt := .F.
			Else
				aadd(aReg,{AllTrim(cLinha)})
			EndIf
		Else
			aadd(aReg,{AllTrim(cLinha)})
		EndIf
		
		FT_FSKIP()
	Enddo
	
	FT_FUSE()
	FClose(nHandle)
	FErase(cLocal+cArq)
	
	If (nHandLog := MSFCreate(cLocal+cArq)) == -1
		FClose(nHandLog)
		MsgStop("Nao eh possivel criar o arquivo : "+cLocal+cArq)
		Return
	Endif
	
	For _y := 1 To Len(aReg)
		cLin := aReg[_y,1]
		cLin += chr(13)+chr(10)
		fWrite(nHandLog,cLin,len(cLin))
	Next _y
	
	FClose(nHandLog)
	
Next _x

cFim := SubStr(Time(),1,5)

cMsg := "Inicio : "+cIni+chr(13)+chr(10)
cMsg += "Fim    : "+cFim+chr(13)+chr(10)
MsgInfo(cMsg)

Return