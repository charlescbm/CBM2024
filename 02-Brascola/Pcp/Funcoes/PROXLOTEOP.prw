#include "rwmake.ch"
#include "topconn.ch"

User Function PROXLOTEOP(cProd,cNumOp,cSequen)
*****************************************
Local cLote := "", cQuery := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco numero de lote da OP Pai                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cNumOp != Nil).and.(cSequen != Nil).and.(cSequen != "001") //OP Filha
	cQuery := "SELECT C2_LOTECTL FROM "+RetSqlName("SC2")+" C2 "
	cQuery += "WHERE C2.D_E_L_E_T_ = '' AND C2.C2_FILIAL = '"+xFilial("SC2")+"' "
	cQuery += "AND C2_NUM = '"+cNumOp+"' AND C2_SEQUEN = '001' AND C2_LOTECTL <> '' "
	cQuery := ChangeQuery(cQuery)
	If (Select("MSC2") <> 0)
		dbSelectArea("MSC2")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MSC2"
	dbSelectArea("MSC2")
	If !MSC2->(Eof())
	   cLote := MSC2->C2_lotectl
	Endif	
	If (Select("MSC2") <> 0)
		dbSelectArea("MSC2")
		dbCloseArea()
	Endif
Endif
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco novo numero de lote da OP                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cLote)
	cParam := getmv("MV_PRLOTE")
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
	_cFilial:=xfilial("SC2")
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL()+cProd)
		if B1_RASTRO == "L"
			cLote := cAno+cMes+cParam
			dbselectarea("SX6")
			dbsetorder(1)
			dbseek(_cFilial+"MV_PRLOTE")
			if reclock("SX6",.F.)
				replace X6_CONTEUD with strzero(val(cParam)+1,4)
				msunlock()
			EndIf
		ENDIF	
	ENDIF
Endif

Return(cLote)