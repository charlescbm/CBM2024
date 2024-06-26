#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
                    
/*/
----------------------------------------------------------------------------
PROGRAMA: BCFGV002        AUTOR: FERNANDO S. MAIA           DATA: 14/12/11
----------------------------------------------------------------------------

DESCRICAO: Controla numera��o do autom�tica do Lote

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/
   
User Function BCFGV002()
***********************
   
Local dDataBase := Date()
Local nSeq   	:= 0
Local cSeq	    := '0000'
Local cCod	    := ''   
Local dMes      := Month(dDataBase)
Local cMes      := '' 
Local dAno      := Year (dDataBase)  
Local cAno      := '' 

//Abre ambiente para trabalho
//prepare environment empresa '01' filial '01' tables 'QEK'

//conout(" ")
//conout("> BCFGV002 - Numeracao automatica... Inicio: "+Time())

cAno:= SUBSTR(Alltrim(Str(dAno)),3,2)

Do Case
   Case dMes = 1
   		cMes = 'A'
   Case dMes = 2
   		cMes = 'B'
   Case dMes = 3
   		cMes = 'C'  		
   Case dMes = 4
   		cMes = 'D'
   Case dMes = 5
   		cMes = 'E'
   Case dMes = 6
   		cMes = 'F'
   Case dMes = 7
   		cMes = 'G'
   Case dMes = 8
   		cMes = 'H'  		
   Case dMes = 9
   		cMes = 'I'
   Case dMes = 10
   		cMes = 'J'
   Case dMes = 11
   		cMes = 'L'
   Case dMes = 12
   		cMes = 'M'   		
EndCase     

cQuery := ""                      
cQuery += "SELECT QEK_LOTE FROM QEK010 WHERE R_E_C_N_O_ = " 
cQuery += "(SELECT MAX(R_E_C_N_O_) R_E_C_N_O_ FROM QEK010 QEK WHERE D_E_L_E_T_ <> '*') "                 

If Select("FER") <> 0
	dbSelectArea("FER")
	dbCloseArea()
Endif              

TCQuery cQuery NEW ALIAS "FER"

If FER->QEK_LOTE <> ''
	nSeq := VAL(SUBSTR(FER->QEK_LOTE,4,4))+1
	cSeq := Alltrim(cAno)+Alltrim(cMes)+STRZERO(nSeq,4)
else
	cSeq := Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
Endif

cCod := cSeq
    
//conout("> BCFGV002 - Numeracao automatica... Fim: "+Time())

//MsgStop ("Lote: "+ cCod) 

Return (cCod)                 

