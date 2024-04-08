#INCLUDE "RWMAKE.CH"    
#INCLUDE "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATG008  º Autor ³ Microsiga          º Data ³  03/13/07  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Filtra os clientes dos representantes na consulta 'SXB'    º±±
±±º          ³ ao cadastro de representates 'SA3'.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATG008()
*********************
LOCAL aArea := GetArea()
LOCAL cCodRepr := "", cFiltro := ""
                           
//04/02/13 - Marcelo - Filtro dos Representantes
////////////////////////////////////////////////
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRepr := u_BXRepLst("FIL") //Lista dos Representantes
	If Empty(cCodRepr)
		Return (cFiltro := "(.F.)")
	Endif
Endif
If !Empty(cCodRepr)
	cFiltro := 'AllTrim(SA3->A3_COD) $ "'+cCodRepr+'"'
Endif
RestArea(aArea)

Return (cFiltro)  
  
User Function BFATG8A(xCodVen) 
***************************
LOCAL lRetu := .T., aArea := GetArea()
LOCAL cCodRepr := "", cFiltro := ""
                           
//04/02/13 - Marcelo - Filtro dos Representantes
////////////////////////////////////////////////
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRepr := u_BXRepLst("FIL") //Lista dos Representantes
	If Empty(cCodRepr)
		lRetu := .F.
	Endif
Endif
If !Empty(cCodRepr).and.(Alltrim(xCodVen) $ cCodRepr)
	lRetu := .F.
Endif
RestArea(aArea)
	
Return (lRetu)