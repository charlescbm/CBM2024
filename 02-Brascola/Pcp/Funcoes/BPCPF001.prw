User Function BPCPF001()

Local cLote := ""
cParam := Alltrim(getmv("MV_PRLOTE"))
cMes := strzero(MONTH(DDATABASE),2)
cAno := substr(alltrim(str(YEAR(DDATABASE))),3,2)   


Do Case
   Case cMes = '01'
   		cMes = 'A'
   Case cMes = '02'
   		cMes = 'B'
   Case cMes = '03'
   		cMes = 'C'  		
   Case cMes = '04'
   		cMes = 'D'
   Case cMes = '05'
   		cMes = 'E'
   Case cMes = '06
   		cMes = 'F'
   Case cMes = '07'
   		cMes = 'G'
   Case cMes = '08'
   		cMes = 'H'  		
   Case cMes = '09'
   		cMes = 'I'
   Case cMes = '10'
   		cMes = 'J'
   Case cMes = '11'
   		cMes = 'L'
   Case cMes = '12'
   		cMes = 'M'   		
EndCase   


///////// MONTA LOTE INTERNO BRASCOLA ///////

cLote := cAno+cMes+cParam

/////// ATUALIZA PROXIMO NUMERO DE LOTE NO PARAMETRO ///////////

nParam := Val(cParam) + 1  

dbseek(_cFilial+"MV_PRLOTE")

if reclock("SX6",.F.)
	replace X6_CONTEUD with strzero(val(nParam)+1,4)
	msunlock()
EndIf

Return(cLote)

/*
cLastLot:= getmv("mv_lastlot")

_cFilial:=xfilial("SC2")

DBSELECTAREA("SB1")
DBSETORDER(1)
IF DBSEEK(XFILIAL()+cProd)
	if B1_RASTRO == "L"
		//	if subs(cLastLot,3,2) < cMes .or. subs(cLastLot,1,2) < cAno
		if subs(cLastLot,3,2) < cMes .or. subs(cLastLot,1,2) < cAno
			cLote:= cAno+cMes+"000001"
			dbselectarea("SX6")
			dbsetorder(1)
			//IF dbseek(_cFilial+"MV_PRXLOTE")
			IF dbseek(_cFilial+"MV_PRLOTE")	
				if reclock("SX6",.F.)
					replace X6_CONTEUD with "000002"
					msunlock()
				EndIf
			EndIf
		Else
			cLote := cAno+cMes+cParam
			dbselectarea("SX6")
			dbsetorder(1)
			//dbseek(_cFilial+"MV_PRXLOTE")
			dbseek(_cFilial+"MV_PRLOTE")
			if reclock("SX6",.F.)
				replace X6_CONTEUD with strzero(val(cParam)+1,6)
				msunlock()
			EndIf
		EndIf
	ENDIF
	dbselectarea("SX6")
	dbsetorder(1)                                                                          
	dbseek(_cFilial+"MV_LASTLOT")
	
	if found()
		if reclock("SX6",.F.)
			replace X6_CONTEUD with cLote
			msunlock()
		EndIf
	EndIf
	
ENDIF
 /*
dbselectarea("SX6")
dbsetorder(1)
dbseek(_cFilial+"MV_LASTLOT")

if found()
	if reclock("SX6",.F.)
		replace X6_CONTEUD with cLote
		msunlock()
	EndIf
EndIf
*/
