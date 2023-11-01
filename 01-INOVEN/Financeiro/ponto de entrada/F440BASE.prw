#Include 'Protheus.ch'
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! F440BASE - Base de Comissão								!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne - Crele Cristina									!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 25/10/2021					                          	!
+-------------------+-----------------------------------------------------------+
*/

User Function F440BASE()


Local aDados := ParamIXB
/*
ParamIXB[1]cVendedor,;
ParamIXB[2]SE1->E1_VLCRUZ,;
ParamIXB[3]nBaseEmis,;
ParamIXB[4]nBaseBaix,;
ParamIXB[5]nVlrEmis,;
ParamIXB[6]nVlrBaix,;
ParamIXB[7]nPerComis
*/

if IsInCallStack("MATA460A")
	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA))
else
	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial('SA1') + SE1->E1_CLIENTE + SE1->E1_LOJA))
endif

if !empty(SA1->A1_ZPDCFIN)	//Se possui % de desconto financeiro preenchido

	//alert(aDados[1][3])
	aDados[1][3] := (aDados[1][3]) * ((100 - SA1->A1_ZPDCFIN)/100) // soma 10%
	aDados[1][5] := (aDados[1][3]) * (aDados[1][7]/100)// novo valor

endif

//varinfo('aDados',aDados)

RETURN aDados


