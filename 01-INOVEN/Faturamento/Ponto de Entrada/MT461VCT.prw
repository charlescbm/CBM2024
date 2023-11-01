#Include "Protheus.ch"
#INCLUDE "COLORS.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"

//DESENVOLVIDO POR INOVEN


User Function MT461VCT() 

Local _aVencto := PARAMIXB[1] 
//Local _aTitulo := PARAMIXB[2] 
Local i
                             
// Condicao especifica 38DD com vencimento sempre as quartas da propria semana 
// Se cair no domingo, segunda ou terca prorroga para a quarta-feira 
// Se cair na quinta, sexta ou sabado antecipa para a quarta-feira 
// Se cair na quarta nao altera 
DBSELECTAREA("SE4")
dbsetorder(1)
dbseek(xfilial("SE4")+SC5->C5_CONDPAG)
If SE4->E4_TIPO == '9'
  for i:=1 to len(_aVencto) 
      IF i == 1 .AND. SC5->C5_XDIAS1 > 0
      _aVencto[i][1] := DataValida(DaySum(dDatabase, SC5->C5_XDIAS1),.T.)
   	  elseIF i == 2 .AND. SC5->C5_XDIAS2 > 0
 	     _aVencto[i][1] := DataValida(DaySum(dDatabase, SC5->C5_XDIAS2),.T.)
      elseIF i == 3 .AND. SC5->C5_XDIAS3 > 0
    	  _aVencto[i][1] := DataValida(DaySum(dDatabase, SC5->C5_XDIAS3),.T.)
      elseIF i == 4 .AND. SC5->C5_XDIAS4 > 0
      	_aVencto[i][1] := DataValida(DaySum(dDatabase, SC5->C5_XDIAS4),.T.)
     Endif 
   next i  
Endif 

//caso a nota tenha valor de frete informado
if SF2->F2_FRETE <> 0
   
   nVlAux := SF2->F2_FRETE / len(_aVencto)
   for i:=1 to len(_aVencto) 
        _aVencto[i][2] := (_aVencto[i][2] - nVlAux) + iif(i == 1, SF2->F2_FRETE, 0)
   next i  

endif

Return(_aVencto) 
