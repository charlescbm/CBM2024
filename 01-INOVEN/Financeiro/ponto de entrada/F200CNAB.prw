#include 'rwmake.ch'
#include 'protheus.ch'

/*
+-------------------+-----------------------------------------------------------+
!Descricao			! O ponto de entrada F200TIT do CNAB a receber, sera        !
					! executado apos o Sistema ler a linha de detalhe e         ! 
					! gravar todos os dados.						            ! 
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria											!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 08/06/2021                                              	!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN


User Function F200CNAB()

	if Type("cGoVal200") == 'U'
		_SetNamedPrvt( "cGoVal200" , "" , "FINA200" )
	endif
	if Type("cCtrTrf200") == 'U'
		_SetNamedPrvt( "cCtrTrf200" , "" , "FINA200" )
	else
		cCtrTrf200 := ""
	endif
	if Type("nOutCrd200") == 'U'
		_SetNamedPrvt( "nOutCrd200" , 0 , "FINA200" )
	endif

Return(.T.)
