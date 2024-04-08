#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Ponto Eletronico                                        !
+------------------+---------------------------------------------------------+
!Nome              ! PonaPo4                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! PON - Ponto de Entrada Modificar horas apontadas        !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/09/2013                                              !
+------------------+---------------------------------------------------------+
*/


User Function PonaPo4() 
Local __aMarcacoes  := aClone( ParamIxb[1] )
Local __aTabCalend  := aClone( ParamIxb[2] )
Local __aCodigos    := aClone( ParamIxb[3] )
Local __aEvesIds    := aClone( ParamIxb[4] )
Local __aResult	  := aClone( aEventos )
Local dDtGer	  := dDataBase
Local nHoras 	  := 0
Local cEvento	  := "999"
Local cCusto 	  := SRA->RA_CC
Local cTpMarc 	  := ""
Local lSoma	  := .F.
Local cPeriodo	  := ""
Local nTole   	  := 0
Local cArred	  := ""
Local lSubstitui	  := .T.
Local nCont := 0
fGeraRes(	__aResult	,; //01 -> Array com os Resultados do Dia
dDtGer		,; //02 -> Data da Geracao
nHoras		,; //03 -> Numero de Horas Resultantes
cEvento		,; //04 -> Codigo do Evento
cCusto		,; //05 -> Centro de Custo a ser Gravado
cTpMarc		,; //06 -> Tipo de Marcacao
lSoma		,; //07 -> True para Acumular as Horas
cPeriodo	,; //08 -> Periodo de Apuracao
nTole		,; //09 -> Tolerancia
cArred		,; //10 -> Tipo de Arredondamento a Ser Utilizado
lSubstitui	 )//11 -> Substitui a(s) Hora(s) Existente(s)
aEventos := aClone( __aResult ) 

msgstop("ponapo4")
/*
For nx := 1 to Len(__aResult)
	If aEventos[nx][2] == '022'
		DbSelectArea("SPC")
		DbSetOrder(2)
		If DbSeek(xFilial("SPC")+SRA->RA_MAT+DtoS(__aResult[nx,1]))
			While !Eof() .AND. SPC->PC_MAT == SRA->RA_MAT //.AND. DtoS(SPC->PC_DATA) == DtoS(_aResult[nx,1])
				If SPC->PC_PD  $ '022'
					RecLock("SPC",.F.)
					SPC->PC_PDI:= '900'
					MsUnlock()
				EndIf
				DbSelectArea("SPC")
				DbSkip()
			EndDo
		EndIf
		
		//aEventos[nx][2]:= '900'
		//msgstop("evento 022")
		nCont:= nCont + 1
	EndIf
Next nx
msgstop("Evento 022: "+ CVALTOCHAR(nCont) + "vezes") */
Return( NIL ) 

