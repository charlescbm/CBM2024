#include "rwmake.ch"


User Function grvcstdd()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


SetPrvt("CPERG,CCOMBO,AITENS,VCODIGO")
SetPrvt("cImage1,VDESC,cImage2,cImage3")
SetPrvt("VCONF,VDTAVAL,VSAIR,_CPORTA,_SALIAS,AREGS")
SetPrvt("I,J,qQetiq")


cCombo:="Nao"
aItens:={"Sim","Nao"}

nCusto 	:= 0
vCodigo := Space(30)
vSair 	:= .f.
Aviso	:= Space(50)
nMes    := 0

While vSair == .f.
	
	@ 3,1 TO 350,350 DIALOG oDlg1 TITLE "Alteracao Do Custo Standard Digitado"
	
	@ 130,010 BUTTON "_Alterar Custo."      SIZE 60,10 ACTION Gravar()// Substituido pelo assistente de conversao do AP6 IDE em 18/10/02 ==>    @ 102,015 BUTTON "_Imprimir"      SIZE 30,20 ACTION Execute(Impetiq)
	@ 130,090 BUTTON "_Sair"               SIZE 30,10 ACTION sair()// Substituido pelo assistente de conversao do AP6 IDE em 18/10/02 ==>    @ 102,158 BUTTON "_Sair"          SIZE 30,20 ACTION Execute(sair)
	
	//@ 05,003 To 30,350
   
	@ 14,005 Say "Codigo:"
	@ 14,035 Get  VCodigo                   SIZE 50,20 Pict "@!"  F3("SB1") Valid Verif_Prod(vCodigo)
	
	@ 35,005 Say "Descricao:"
	@ 35,035 Get  Vdesc                     SIZE 120,20 Pict "@!"  when .f.
	
	@ 55,005 Say "Custo Std Digitado"
	@ 55,055 Get nCusto                     SIZE 50,20   picture '999.999'

	@ 75,005 Say "Mes "
	@ 75,055 Get nMes                       SIZE 50,20   picture '99'
	
    @ 105,005 Say "Gravar Custo Standard:"
    @ 105,085 ComboBox cCombo Items aItens   SIZE 30,50   
    
    	
	ACTIVATE DIALOG oDlg1 CENTERED
end

RETURN


****************************************************************************
Static Function Gravar()

cMes 	:= StrZero(nMes, 2)
cCampo3 := "B3_STDM&cMes

DbSelectArea("SB3")
If DBSeek('01' + VCodigo)
    RecLock("SB3",.F.)
    &(cCampo3) := nCusto
    MsUnlock()
EndIf

DbSelectArea("SB3")
If DBSeek('04' + VCodigo)
    RecLock("SB3",.F.)
    &(cCampo3) := nCusto
    MsUnlock()
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial()+vCodigo)

if cCombo == "Nao"

If Reclock("sb1",.f.)
	IF SUBSTR(B1_COD,1,3) == 'MOD'
	   SB1->b1_CUSTDM := nCusto
	   SB1->b1_CUSTD  := nCusto
	ELSE
	   SB1->b1_CUSTDM := nCusto
	ENDIF
	   
    msgAlert("Custo Alterado Com Sucesso")
    MsUnlock()	
		
Endif

else
If Reclock("sb1",.f.)
	   SB1->b1_CUSTDM := nCusto
	   SB1->b1_CUSTD  := nCusto
	   
    msgAlert("Custo Alterado Com Sucesso")
    MsUnlock()	
		
Endif

endif

nCusto := 0
vCodigo := Space(30)
VDesc :=Space(60)

Return


Static Function Sair()
Close(oDlg1)
vSair := .t.
Return


dbSelectArea(_sAlias)

Return


Static Function Verif_Prod(vCodigo)
*********************************
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial()+vCodigo)
If !Found()
	Return .f.
EndIf
VDesc := SB1->B1_DESC
nCusto := SB1->B1_CUSTDM

RETURN .T.
