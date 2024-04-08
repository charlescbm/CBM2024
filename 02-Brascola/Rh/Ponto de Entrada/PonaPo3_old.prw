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
!Nome              ! PonaPo3                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! PON - Ponto de Entrada Modificar horas apontadas        !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/09/2013                                              !
+------------------+---------------------------------------------------------+
*/
User Function PONAPO3()

dbSelectArea("SRA")
cMat     := alltrim(SRA->RA_MAT)
cNasc    := DtoS(SRA->RA_NASC)
cBH      := alltrim(SRA->RA_BHFOL)
cEventBH := GetMv("BR_000029")//Eventos a serem processados para Banco de Horas
cEventMot:= GetMv("BR_000030")//Eventos a serem processados para Motivo do Abono

If (Upper(Alltrim(Funname())) $ "PONA280")
	mv_par13 := Ctod("  /  /  ")
	mv_par14 := Ctod("  /  /  ")
	CheckPonMes(@mv_par13,@mv_par14,.F.,.T.,!lPona240)
EndIf


If (Upper(Alltrim(Funname())) $ "PONA040")
	mv_par13 := Stod(Substr(GetMv("MV_PONMES"),01,08))
	mv_par14 := Stod(Substr(GetMv("MV_PONMES"),10,08))
EndIf

DbSelectArea("SPC")
DbSetOrder(2)
If DbSeek(xFilial("SPC")+SRA->RA_MAT+Dtos(mv_par13))
	If cBH == 'S'
		While !Eof() .AND. SPC->PC_MAT == cMat .AND. SPC->PC_DATA <= MV_PAR14  .AND. cBH == 'S'
			DbSelectArea("SP9")
			DbSetOrder(1)
			DbSeek(xFilial("SP9")+SPC->PC_PD)
			If (!Empty(SP9->P9_CODINFO)) .AND. (SPC->PC_PD  $ cEventBH)//'022/023/024/029/030/031' - Verbas hora extra para funcionários com regime de banco de horas
				RecLock("SPC",.F.)
				SPC->PC_PDI:= SP9->P9_CODINFO//'900'
				SPC->PC_QUANTI:= SPC->PC_QUANTC
				MsUnlock()
			EndIf
			If SPC->PC_PD  $ cEventMot .AND. (Substr(DtoS(SPC->PC_DATA),5,4)  != SubStr(cNasc,5,4))//'433/447/409' - Eventos que recebem tratamento de Motivo de Abono - Manutencao Apontamentos
				RecLock("SPC",.F.)
				SPC->PC_ABONO:= '030'
				SPC->PC_QTABONO:= SPC->PC_QUANTC
				MsUnlock()
				BGravaAbono('030')
			EndIf
			If (SPC->PC_PD $ '409') .AND. (Substr(DtoS(SPC->PC_DATA),5,4)  == SubStr(cNasc,5,4))//Faltou porque esta de aniversário, tem que abonar...fmaia
				RecLock("SPC",.F.)
				SPC->PC_ABONO:= '012'
				SPC->PC_QTABONO:= SPC->PC_QUANTC
				MsUnlock()
				BGravaAbono('012')
			EndIf
			DbSelectArea("SPC")
			DbSkip()
		EndDo
	Else
		While !Eof() .AND. SPC->PC_MAT == cMat .AND. SPC->PC_DATA <= MV_PAR14 //Procedimento para todos os colaboradores independente do regime
			If (SPC->PC_PD $ '409') .AND. (Substr(DtoS(SPC->PC_DATA),5,4)  == SubStr(cNasc,5,4))//Faltou porque esta de aniversário, tem que abonar...fmaia
				RecLock("SPC",.F.)
				SPC->PC_ABONO:= '012'
				SPC->PC_QTABONO:= SPC->PC_QUANTC
				MsUnlock()
				BGravaAbono('012')
			EndIf
			DbSelectArea("SPC")
			DbSkip()
		EndDo
	EndIf
EndIf      
       
Return
           

//Função desenvolvida por Marcelo Cunha(18/09/13)
Static Function BGravaAbono(xAbono)
***********************************
LOCAL lPort1510 	:= Port1510()
LOCAL __lCpoDataAlt	:= IF((SPC->(FIELDPOS( "PC_DATAALT" )) != 0 ) .and. ( SPK->(FIELDPOS( "PK_DATAALT" )) != 0 ) .and. ( SPH->(FIELDPOS( "PH_DATAALT" )) != 0 ) .and. ( ( SuperGetMv("MV_PONLOG",NIL,"N") == "S" ) .or. lPort1510 ) ,.T. , .F. )
LOCAL __lCpoUsuaAlt	:= IF(( SPC->(FIELDPOS( "PC_USUARIO" )) != 0 ) .and. ( SPK->(FIELDPOS( "PK_USUARIO" )) != 0 ) .and. ( SPH->(FIELDPOS( "PH_USUARIO" )) != 0 ) .and. ( ( SuperGetMv("MV_PONLOG",NIL,"N") == "S" ) .or. lPort1510 ) ,.T. , .F. ) 
SPK->(dbSetOrder(1)) //PK_FILIAL,PK_MAT,PK_DATA,PK_CODABO
If !SPK->(dbSeek(SRA->RA_filial+SRA->RA_mat+dtos(SPC->PC_data)+xAbono))
	RecLock("SPK",.T.)
	SPK->PK_FILIAL  := SRA->RA_filial
	SPK->PK_MAT     := SRA->RA_mat
	SPK->PK_DATA    := SPC->PC_data
	SPK->PK_CODABO  := xAbono
	SPK->PK_HRSABO  := SPC->PC_qtabono
	SPK->PK_HORINI  := 0
	SPK->PK_HORFIM  := 0
	SPK->PK_CODEVE  := SPC->PC_pd
	SPK->PK_CC      := SPC->PC_cc
	SPK->PK_TPMARCA := SPC->PC_tpmarca
	SPK->PK_FLAG    := "I"
    If __lCpoDataAlt .and. __lCpoUsuaAlt		
		SPK->PK_DATAALT	:= MsDate()
		SPK->PK_USUARIO	:= __cUserId
	EndIf
	MsUnlock("SPK")
Endif
Return