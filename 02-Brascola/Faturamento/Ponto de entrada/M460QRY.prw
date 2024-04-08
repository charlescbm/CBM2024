#include "rwmake.ch" 

User Function M460QRY()
Local cQuery :=paramixb[1]

cQuery+= " AND C9_PEDIDO = (SELECT TOP 1 C6_NUM FROM SC6010 WHERE C6_NUM = '002675')"

Return(cQuery) 