#Include 'Protheus.ch'
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! F460SE1 - Gravacao campos complementares rotina LIQUIDACAO!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne - Crele Cristina									!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 20/10/2022					                          	!
+-------------------+-----------------------------------------------------------+
*/

User Function F460SE1()

Local _aComple := ParamIxb

aadd(_aComple,{"E1_VEND1",SE1->E1_VEND1})
aadd(_aComple,{"E1_VEND2",SE1->E1_VEND2})
aadd(_aComple,{"E1_COMIS1",SE1->E1_COMIS1})
aadd(_aComple,{"E1_COMIS2",SE1->E1_COMIS2})
Return( _aComple )

