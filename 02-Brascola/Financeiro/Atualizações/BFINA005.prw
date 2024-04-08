#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFINA005 ºAutor  ³ Marcelo da Cunha   º Data ³  30/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para Atualizar Taxa Selic Mensal                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10/MP11                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFINA005()
*********************
PRIVATE aRotina := MenuDef(), cAlias := "SZ6"
PRIVATE cCadastro := OemToAnsi("Atualizacao Taxa Selic")
If !(Alltrim(cUserName) $ SuperGetMV("BR_000033",.F.,""))
	Help("",1,"BRASCOLA",,OemToAnsi("Usuário sem acesso para Atualização Taxa Selic!"),1,0)
	Return
Endif
If !AliasInDic(cAlias)
	Help("",1,"BRASCOLA",,OemToAnsi("Arquivo "+cAlias+" nao foi criado!"),1,0)
	Return
Endif
dbSelectArea(cAlias)
mBrowse(6,1,22,75,cAlias)
Return

User Function BFIA005Atu(cAlias,nReg,nOpcx)
***************************************
LOCAL cPerg := "BFIA005ATU", aRegs := {}

//Verifico acesso do usuario
////////////////////////////
If !(Alltrim(cUserName) $ SuperGetMV("BR_000033",.F.,""))
	Help("",1,"BRASCOLA",,OemToAnsi("Usuário sem acesso para Atualização Taxa Selic!"),1,0)
	Return
Endif

//Crio o grupo de perguntas
///////////////////////////
aadd(aRegs,{cPerg,"01","Ano/Mes Taxa Selic ?","mv_ch1","C",06,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Fornecedor De      ?","mv_ch2","C",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","SA2"})
aadd(aRegs,{cPerg,"03","Fornecedor Ate     ?","mv_ch3","C",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA2"})
u_BXCriaPer(cPerg,aRegs)
If Pergunte(cPerg,.T.).and.MsgYesNo("> Confirma processamento para Ano/Mes "+mv_par01+" ? ")
	Processa({|| BFIAProc() })
Endif

Return

Static Function BFIAProc()
***********************
LOCAL cAnoMes1 := "", cQuery1 := "", lProcOk := .F., dData1 := MsDate()
LOCAL nTaxa1 := 0, nSaldo1 := 0, nAcres1 := 0, nPerc1 := 0.5 //50% Selic

                                      
//Verifico se Taxa Selic existe
///////////////////////////////
cAnoMes1 := mv_par01
If !ExistCpo("SZ6",cAnoMes1,1)
	Return
Endif
SZ6->(dbSetOrder(1))
If SZ6->(dbSeek(xFilial("SZ6")+cAnoMes1))
	nTaxa1 := (SZ6->Z6_taxames/100)*nPerc1
Endif
If (nTaxa1 < 0)
	Help("",1,"BRASCOLA",,OemToAnsi("Taxa Selic para o Ano/Mes "+cAnoMes1+" incorretao!"),1,0)
	Return
Endif

//Busco informacoes no banco de dados
/////////////////////////////////////
cQuery1 := "SELECT E2.R_E_C_N_O_ MRECSE2 FROM "+RetSqlName("SE2")+" E2 "
cQuery1 += "WHERE E2.D_E_L_E_T_ = '' AND E2.E2_FILIAL = '"+xFilial("SE2")+"' "
cQuery1 += "AND E2.E2_FORNECE BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' "
cQuery1 += "AND E2.E2_TIPO = 'RJ' AND E2.E2_SALDO > 0 "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSE2") <> 0)
	dbSelectArea("MSE2")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSE2"
SE2->(dbSetOrder(1))
Procregua(1)
dbSelectArea("MSE2")
While !MSE2->(Eof())
	SE2->(dbGoto(MSE2->MRECSE2))
	Incproc("> Titutlos RJ "+SE2->E2_prefixo+SE2->E2_num)
	If Empty(SE2->E2_x_amsel).or.(SE2->E2_x_amsel < cAnoMes1)
		nSaldo1 := (SE2->E2_valor+SE2->E2_acresc-SE2->E2_decresc)*nTaxa1
		If (nSaldo1 > 0)
			Reclock("SE2",.F.)
			SE2->E2_acresc  += nSaldo1
			SE2->E2_x_amsel := cAnoMes1
			SE2->E2_x_dtsel := dData1
			MsUnlock("SE2")
			lProcOk := .T.
		Endif	
	Endif	
	MSE2->(dbSkip())
Enddo
If (Select("MSE2") <> 0)
	dbSelectArea("MSE2")
	dbCloseArea()
Endif

If (lProcOk)
	MsgInfo("> Processo realizado com sucesso!")
Endif

Return

Static Function MenuDef()                   
**********************
PRIVATE aRotina := { { OemToAnsi("Pesquisar")  ,"AxPesqui"    , 0 , 1,0,.F.},;
	               {   OemToAnsi("Visualizar")   ,"AxVisual"    , 0 , 2,0,NIL},;
	               {   OemToAnsi("Incluir")      ,"AxInclui"    , 0 , 3,0,NIL},;
                  {   OemToAnsi("Alterar")      ,"AxAltera"    , 0 , 4,0,NIL},;
	               {   OemToAnsi("Excluir")      ,"AxDeleta"    , 0 , 5,0,NIL},;
                  {   OemToAnsi("Atualizar RJ") ,"u_BFIA005Atu", 0 , 4,0,NIL}}
Return(aRotina) 