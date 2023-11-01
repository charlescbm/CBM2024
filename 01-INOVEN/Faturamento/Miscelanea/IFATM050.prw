#INCLUDE "rwmake.ch"
#INCLUDE "SPEDNFE.ch" 

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! IFATM050													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Programa para exportar o XML						 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 19/07/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function IFATM050()

	//cParNfeExp := __cUSERID+'_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"SPEDNFEEXP"
	cParNfeExp := __cUSERID+'_'+SM0->M0_CODIGO+SM0->M0_CODFIL+"IFAT050EXP"

	//Obtem o codigo da entidade
	cEntidade := GetIdEnt( .F. )

	//Parametros
	aPergEE   	 := {}
	aParamEE  	 := {Space(If (TamSx3("F2_SERIE")[1] == 14,Len(SF2->F2_SDOC),Len(SF2->F2_SERIE))),;
					Space(Len(SF2->F2_DOC)),Space(Len(SF2->F2_DOC)),Space(60),CToD(""),CToD(""),;
					Space(14),Space(14)}

	aadd(aPergEE,{1,STR0010,aParamEE[01],"",".T.","",".T.",30,.F.}) //"Serie da Nota Fiscal"
	aadd(aPergEE,{1,STR0011,aParamEE[02],"",".T.","",".T.",30,.T.}) //"Nota fiscal inicial"
	aadd(aPergEE,{1,STR0012,aParamEE[03],"",".T.","",".T.",30,.T.}) //"Nota fiscal final"
	aadd(aPergEE,{6,STR0119,"U:\","",".T.","!Empty(mv_par04)",80,.T.,"Arquivos XML |*.XML","",GETF_RETDIRECTORY+GETF_LOCALHARD,.T.}) //"Diretório de destino"
	aadd(aPergEE,{1,STR0141,aParamEE[05],"",".T.","",".T.",50,.T.}) //"Data Inicial"
	aadd(aPergEE,{1,STR0142,aParamEE[06],"",".T.","",".T.",50,.T.}) //"Data Final"
	aadd(aPergEE,{1,STR0143,aParamEE[07],"",".T.","",".T.",50,.F.}) //"CNPJ Inicial"
	aadd(aPergEE,{1,STR0144,aParamEE[08],"",".T.","",".T.",50,.F.}) //"CNPJ final"

	aParamEE[01] := ParamLoad(cParNfeExp,aPergEE,1,aParamEE[01])
	aParamEE[02] := ParamLoad(cParNfeExp,aPergEE,2,aParamEE[02])
	aParamEE[03] := ParamLoad(cParNfeExp,aPergEE,3,aParamEE[03])
	aParamEE[04] := ParamLoad(cParNfeExp,aPergEE,4,aParamEE[04])
	aParamEE[05] := ParamLoad(cParNfeExp,aPergEE,5,aParamEE[05])
	aParamEE[06] := ParamLoad(cParNfeExp,aPergEE,6,aParamEE[06])
	aParamEE[07] := ParamLoad(cParNfeExp,aPergEE,7,aParamEE[07])
	aParamEE[08] := ParamLoad(cParNfeExp,aPergEE,8,aParamEE[08])

	If ParamBox(aPergEE,"SPED - NFe",@aParamEE,,,,,,,cParNfeExp,.T.,.T.)
		Processa({|lEnd| &("StaticCall(SPEDNFE,SPEDPEXP,cEntidade,"+;
		"aParamEE[01],"+;
		"aParamEE[02],"+;
		"aParamEE[03],"+;
		"aParamEE[04],"+;
		"lEnd,"+;
		"aParamEE[05],"+;
		"aParamEE[06],"+;
		"aParamEE[07],"+;
		"aParamEE[08],"+;
		"1,,"+;
		"aParamEE[01])")},"Processando","Aguarde, exportando arquivos",.F.)

		ApMsgAlert("XML(s) exportado(s) com sucesso!","CHECK-LIST FATURAMENTO")
	ENdif

Return


Static Function GetIdEnt(lUsaColab)

local cIdEnt := ""
local cError := ""

//Default lUsaColab := .F.

If !lUsaColab

	cIdEnt := getCfgEntidade(@cError)

	if(empty(cIdEnt))
		Aviso("SPED", cError, {STR0114}, 3)

	endif

else
	if !( ColCheckUpd() )
		Aviso("SPED","UPDATE do TOTVS Colaboração 2.0 não aplicado. Desativado o uso do TOTVS Colaboração 2.0",{STR0114},3)
	else
		cIdEnt := "000000"
	endif
endIf

Return(cIdEnt)
