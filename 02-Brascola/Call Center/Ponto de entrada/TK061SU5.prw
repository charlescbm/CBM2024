#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TK061SU5 ºAutor  ³ Marcelo da Cunha   º Data ³  20/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para filtrar contatos                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TK061SU5()
**********************
LOCAL cRetu := Nil, cEnti := paramixb[1], lLog := paramixb[3], lAchou := .F.
If (cEnti == "SA1")
	If (lLog) //Filtro DBA
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+SU5->U5_codcli+SU5->U5_lojacli,.T.))
		//cRetu := " (SA1->A1_MSBLQL!='1') " ; lAchou := .T.
		If !Empty(mv_par16).or.!Empty(mv_par17)
			cRetu := iif(lAchou,cRetu+" .AND. ","")+" (SA1->A1_REGIAO>='"+mv_par16+"') .AND. (SA1->A1_REGIAO<='"+mv_par17+"') "
			lAchou := .T.
		Endif
		If !Empty(mv_par18).or.!Empty(mv_par19)
			cRetu := iif(lAchou,cRetu+" .AND. ","")+" (SA1->A1_GRPVEN>='"+mv_par18+"') .AND. (SA1->A1_GRPVEN<='"+mv_par19+"') "
			lAchou := .T.
		Endif
		If !Empty(mv_par20).or.!Empty(mv_par21)
			cRetu := iif(lAchou,cRetu+" .AND. ","")+" (SA1->A1_EST>='"+mv_par20+"') .AND. (SA1->A1_EST<='"+mv_par21+"') "
			lAchou := .T.
		Endif
	Else //Filtro SQL
		//cRetu := " SA1.A1_MSBLQL <> '1' " ; lAchou := .T.
		If !Empty(mv_par16).or.!Empty(mv_par17)
			cRetu := iif(lAchou,cRetu+" AND ","")+" SA1.A1_REGIAO BETWEEN '"+mv_par16+"' AND '"+mv_par17+"' "
			lAchou := .T.
		Endif
		If !Empty(mv_par18).or.!Empty(mv_par19)
			cRetu := iif(lAchou,cRetu+" AND ","")+" SA1.A1_GRPVEN BETWEEN '"+mv_par18+"' AND '"+mv_par19+"' "
			lAchou := .T.
		Endif
		If !Empty(mv_par20).or.!Empty(mv_par21)
			cRetu := iif(lAchou,cRetu+" AND ","")+" SA1.A1_EST BETWEEN '"+mv_par20+"' AND '"+mv_par21+"' "
			lAchou := .T.
		Endif
	Endif
Endif
Return cRetu