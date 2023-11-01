#INCLUDE "rwmake.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! FINALEG													!
+-------------------+-----------------------------------------------------------+
!Descricao			! O ponto de entrada FINALEG legenda customizada	 		!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 20/07/2021												!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function FINALEG()

Local nReg := PARAMIXB[1] // Com valor: Abrir a telinha de legendas ### Sem valor: Retornar as regras
Local cAlias := PARAMIXB[2] // SE1 ou SE2
Local aRegras := PARAMIXB[3] // Regras do padrão
Local aLegendas := PARAMIXB[4] // Legendas do padrão
Local aRet := {}
Local nI := 0

if nReg == NIL

	if cAlias == 'SE1'
		for nI := 1 to len(aRegras)
			if aRegras[nI][2] == 'BR_AZUL_CLARO'
				aRegras[nI][1] := "E1_SITUACA == '2' .and. !empty(E1_SALDO)"
			endif
		next
	endif

	aRet := aRegras

else

	if cAlias == 'SE1'
		for nI := 1 to len(aLegendas)
			if aLegendas[nI][1] == 'BR_AZUL_CLARO'
				aLegendas[nI][2] := 'Título em Cobrança Descontada'
			endif
		next
	endif

	BrwLegenda(cCadastro, "Legenda", aLegendas)

endif

Return aRet	
