#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ ESTESINT ณ Retorna o TES em fun็ใo da opera็ใo e grupos de tributa็ใo   บฑฑ
ฑฑบ             ณ          ณ do produto e cliente.                                        บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 21.12.05 ณ Telma / Hernane                                              บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 22.12.05 ณ Almir Bandina                                                บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ 99.99.99 ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpN1 = Documento de 1-Entrada / 2-Saida                                ณฑฑ
ฑฑณ             ณ ExpC1 = Tipo de Operacao Tabela "DJ" do SX5                             ณฑฑ
ฑฑณ             ณ ExpC2 = Codigo do Cliente ou Fornecedor                                 ณฑฑ
ฑฑณ             ณ ExpC3 = Loja do Cliente ou Fornecedor                                   ณฑฑ
ฑฑณ             ณ ExpC4 = Tipo do Detinatแrio (C=Cliente, F=Fornecedor)                   ณฑฑ
ฑฑณ             ณ ExpC5 = C๓digo do Produto                                               ณฑฑ
ฑฑณ             ณ ExpC6 = Campo para Retorno do TES                                       ณฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Alteracoes  ณ 19/12/06 - Elias Reis - Alteracao do calculo do peso, especificamente   บฑฑ
ฑฑบ             ณ                         para o cliente Embrasil                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EsTesInt(nEntSai,cTpOper,cClieFor,cLoja,cTipoCF,cProduto,cCampo)

Local aArea			:= GetArea()
Local aAreaSA1		:= SA1->(GetArea())
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aTes			:= {}
Local aDadosCfo	:= {} 
Local cTesRet		:= "   "
Local cGrupo		:= ""
Local cGruProd		:= ""
Local cQuery		:= ""  
Local cProg			:= "MT100"
Local cAliasSFM	    := "SFM"         
Local cTabela		:= ""
Local nPosCpo		:= 0
Local nPosCfo		:= 0
Local nPeso			:= SuperGetMV("BR_PESOST",.F.,1.0)   
Local nPesoProd   := 0



DEFAULT cTpOper	:= &(ReadVar())
DEFAULT cClieFor	:= ""
DEFAULT cProduto	:= ""
DEFAULT nEntSai	:= 0
DEFAULT cTipoCF	:= "C"
DEFAULT cCampo		:= ""


//Esta validacao esta sendo feita somente para testar a tes inteligente com o CALLCENTER

 If Upper(GetEnvServ())=='CALLCENTER' //.Or. "PARALELO" $ Upper(GetEnvServ())
	cTesRet := aCols[n, aScan(aHeader, { |x| AllTrim(x[2]) == "C6_TES"}) ]
	Return(cTesRet)
 EndIf



If !Empty(cCampo)
	nPosCpo	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim(cCampo) })
	//cTabela  := aHeader[nPosCpo,9]
    if cCampo = 'C6_TES'
       cTabela:= 'SC6'
    ELSEIF cCampo = 'D2_TES'
          cTabela:= 'SD2'
    ELSEIF cCampo = 'D1_TES'
          cTabela:= 'SD1'
    ENDIF
    
EndIf




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica o grupo de tributacao do cliente/fornecedor         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea(If(cTipoCF == "C","SA1","SA2"))
dbSetOrder(1)
MsSeek(xFilial()+cClieFor+cLoja)
If cTipoCF == "C"
	cGrupo := SA1->A1_GRPTRIB
Else
	cGrupo := SA2->A2_GRPTRIB
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica o grupo do produto                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProduto)
cGruProd := RTRIM(SB1->B1_GRTRIB)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Efetua o tratamento para a tributa็ใo do produto caso o peso ณ
//ณ seja maior que o definido em parโmetro                       ณ
//ณ Altera็ใo conforme Decreto 43.923/04 - RICMS-MG              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//****Elias
	nPos3   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"  }) // Posicao do Campo na Matriz
	nQtdVen := aCols[n,nPos3]  //Grava na variavel
//** Elias	


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Pesquisa por todas as regras validas para este caso

//cQuery += "SELECT * FROM " + RetSqlName("SFM") + " SFM "          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cAliasSFM := GetNextAlias() 
cQuery += "SELECT * FROM " + RetSqlName("SFM") + " SFM "
cQuery += "WHERE SFM.FM_FILIAL = '01'"
cQuery += "AND SFM.FM_TIPO = '" + cTpOper + "'"
cQuery += "AND SFM.D_E_L_E_T_=' ' "
cQuery += "ORDER BY "+SqlOrder(SFM->(IndexKey()))
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSFM,.T.,.T.)
nCont:= 0  

While !Eof() .And. (cAliasSFM)->FM_TIPO==cTpOper
	//nCont:= nCont + 1 
	
	//If nCont == 150
	   //	Alert("REGISTRO 151")
   //	EndIf
	
	If cTipoCF == "C" 
		If (Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD)) .Or.;
			(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
			 (cGruProd == AllTrim((cAliasSFM)->FM_GRPROD) .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
			 (cClieFor+cLoja == (cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI .Or. Empty((cAliasSFM)->FM_CLIENTE+(cAliasSFM)->FM_LOJACLI)) .And.;
			 (cGrupo == (cAliasSFM)->FM_GRTRIB .Or. Empty((cAliasSFM)->FM_GRTRIB)))
				aadd(aTes, {(cAliasSFM)->FM_PRODUTO, (cAliasSFM)->FM_GRPROD, (cAliasSFM)->FM_CLIENTE, (cAliasSFM)->FM_LOJACLI, (cAliasSFM)->FM_GRTRIB, (cAliasSFM)->FM_TE, (cAliasSFM)->FM_TS})
		EndIf
	Else
		If (Empty((cAliasSFM)->FM_PRODUTO+(cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR+(cAliasSFM)->FM_GRTRIB+(cAliasSFM)->FM_GRPROD)) .Or.;
			(((cAliasSFM)->FM_PRODUTO == cProduto .Or. Empty((cAliasSFM)->FM_PRODUTO)) .And.;
			 (cGruProd == (cAliasSFM)->FM_GRPROD .Or. Empty((cAliasSFM)->FM_GRPROD)) .And.;
			 (cClieFor+cLoja == (cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR .Or. Empty((cAliasSFM)->FM_FORNECE+(cAliasSFM)->FM_LOJAFOR)) .And.;
			 (cGrupo == (cAliasSFM)->FM_GRTRIB .Or. Empty((cAliasSFM)->FM_GRTRIB)))
			aadd(aTes, {(cAliasSFM)->FM_PRODUTO, (cAliasSFM)->FM_GRPROD, (cAliasSFM)->FM_FORNECE, (cAliasSFM)->FM_LOJAFOR, (cAliasSFM)->FM_GRTRIB, (cAliasSFM)->FM_TE, (cAliasSFM)->FM_TS})
		EndIf
	EndIf
	dbSelectArea(cAliasSFM)
	dbSkip()
EndDo

dbSelectArea(cAliasSFM)
dbCloseArea()
dbSelectArea("SFM")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Pesquisa por todas as regras validas para este caso          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aSort(aTES,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5] > y[1]+y[2]+y[3]+y[4]+y[5]})

If Len(aTes) <> 0                                                   
   
   if SM0->M0_CODFIL = '04' .OR. SM0->M0_CODFIL = '03' .OR. SM0->M0_CODFIL = '01'
 
      //if ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SP*RS*PR').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
      //   cTesRet:='578'
      If ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RJ') .and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'   
         cTesRet:='798'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ getmv('MV_NORTE') .and. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='801'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SC') .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='799'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('MG') .AND. cGruProd <> '015'.and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='794'
   //ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_TIPO = 'F'.and. SA1->A1_TIPO <> 'F'
   //    cTesRet:='708'
      
      ELSE
	     cTesRet := If(nEntSai==1,aTes[1][6],aTes[1][7])
      Endif
   ELSEIF SM0->M0_CODFIL = '02'
      if ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SP*PR*SC').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='578'
      
      elseif ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RJ').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='798'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ getmv('MV_NORTE') .and. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='801'
            
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RS') .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='595'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('MG') .AND. cGruProd <> '015'.and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='794'
   //ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_TIPO = 'F'.and. SA1->A1_TIPO <> 'F'
   //    cTesRet:='708'
      ELSE
	     cTesRet := If(nEntSai==1,aTes[1][6],aTes[1][7])
      Endif
   ENDIF

EndIf

IF EMPTY(cTesRet)
     if SM0->M0_CODFIL = '04' .OR. SM0->M0_CODFIL = '03' .OR. SM0->M0_CODFIL = '01'

      if ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SP*RS*PR').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='578'
      elseif ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RJ').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='798'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ getmv('MV_NORTE') .and. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='801'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SC') .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='799'
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('MG') .AND. cGruProd <> '015'.and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='794'
   //ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_TIPO = 'F'.and. SA1->A1_TIPO <> 'F'
   //    cTesRet:='708'
      Endif
   ELSEIF SM0->M0_CODFIL = '02'
      if ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SP*PR*SC').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='578'
      
      elseif ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RJ').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='798'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ getmv('MV_NORTE') .and. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
         cTesRet:='801'
            
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RS') .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='595'
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('MG') .AND. cGruProd <> '015'.and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='794'
   //ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_TIPO = 'F'.and. SA1->A1_TIPO <> 'F'
   //    cTesRet:='708'
      Endif
   ENDIF

EndIf

If nPosCpo > 0 .And. !Empty(cTesRet) .And. Type('aCols') <> "U"
		aCols[n][nPosCpo] := cTesRet
	
	Do Case
		Case cTabela == "SD1"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D1_CF") })
		Case cTabela == "SD2"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D2_CF") })
		Case cTabela == "SC6"     
			dbSelectArea("SF4")
			dbSetOrder(1)
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("C6_CF") })
			If nPosCfo > 0 .And. MsSeek(xFilial("SF4")+cTesRet)
				aDadosCfo := {} 
			 	AAdd(aDadosCfo,{"OPERNF","S"})
			 	AAdd(aDadosCfo,{"TPCLIFOR",If(cTipoCF == "C", SA1->A1_TIPO , SA2->A2_TIPO )})
			 	AAdd(aDadosCfo,{"UFDEST"  ,If(cTipoCF == "C", SA1->A1_EST  , SA2->A2_EST  )})
			 	AAdd(aDadosCfo,{"INSCR"   ,If(cTipoCF == "C", SA1->A1_INSCR, SA2->A2_INSCR)})
				aCols[n][nPosCfo] := MaFisCfo( ,SF4->F4_CF,aDadosCfo ) 
			EndIf
			nPosCfo := 0      
		Case cTabela == "SC7"
			cProg := "MT120"
		Case cTabela == "SC8"
			cProg := "MT150"
		Case cTabela == "SUB"
			nPosCfo := aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("UB_CF") })
			cProg := "TK273"
	EndCase
	If nPosCfo > 0
		aCols[n][nPosCfo] := Space(Len(aCols[n][nPosCfo]))
	EndIf
   	If MaFisFound("IT",N)
		MaFisAlt("IT_TES",cTesRet,n)
		MaFisRef("IT_TES",cProg,cTesRet)
	EndIf

EndIf
If !Empty(cTesRet)
	dbSelectArea("SF4")
	If MsSeek(xFilial("SF4")+cTesRet)
		If !RegistroOK("SF4")
			cTesRet := Space(Len(cTesRet))
		EndIf
	EndIf
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Restaura a integridade da rotina                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aAreaSB1)
RestArea(aArea)

Return(cTesRet)