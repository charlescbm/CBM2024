#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � ESTESINT � Retorna o TES em fun��o da opera��o e grupos de tributa��o   ���
���             �          � do produto e cliente.                                        ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � 21.12.05 � Telma / Hernane                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 22.12.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpN1 = Documento de 1-Entrada / 2-Saida                                ���
���             � ExpC1 = Tipo de Operacao Tabela "DJ" do SX5                             ���
���             � ExpC2 = Codigo do Cliente ou Fornecedor                                 ���
���             � ExpC3 = Loja do Cliente ou Fornecedor                                   ���
���             � ExpC4 = Tipo do Detinat�rio (C=Cliente, F=Fornecedor)                   ���
���             � ExpC5 = C�digo do Produto                                               ���
���             � ExpC6 = Campo para Retorno do TES                                       ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Alteracoes  � 19/12/06 - Elias Reis - Alteracao do calculo do peso, especificamente   ���
���             �                         para o cliente Embrasil                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
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




//��������������������������������������������������������������Ŀ
//� Verifica o grupo de tributacao do cliente/fornecedor         �
//����������������������������������������������������������������
dbSelectArea(If(cTipoCF == "C","SA1","SA2"))
dbSetOrder(1)
MsSeek(xFilial()+cClieFor+cLoja)
If cTipoCF == "C"
	cGrupo := SA1->A1_GRPTRIB
Else
	cGrupo := SA2->A2_GRPTRIB
EndIf

//��������������������������������������������������������������Ŀ
//� Verifica o grupo do produto                                  �
//����������������������������������������������������������������
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+cProduto)
cGruProd := RTRIM(SB1->B1_GRTRIB)

//��������������������������������������������������������������Ŀ
//� Efetua o tratamento para a tributa��o do produto caso o peso �
//� seja maior que o definido em par�metro                       �
//� Altera��o conforme Decreto 43.923/04 - RICMS-MG              �
//����������������������������������������������������������������

//****Elias
	nPos3   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"  }) // Posicao do Campo na Matriz
	nQtdVen := aCols[n,nPos3]  //Grava na variavel
//** Elias	


//��������������������������������������������������������������Ŀ
//� Pesquisa por todas as regras validas para este caso

//cQuery += "SELECT * FROM " + RetSqlName("SFM") + " SFM "          �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Pesquisa por todas as regras validas para este caso          �
//����������������������������������������������������������������
aSort(aTES,,,{|x,y| x[1]+x[2]+x[3]+x[4]+x[5] > y[1]+y[2]+y[3]+y[4]+y[5]})

If Len(aTes) <> 0                                                   
   
   if SM0->M0_CODFIL = '04' .OR. SM0->M0_CODFIL = '03' .OR. SM0->M0_CODFIL = '01'
 
      //if ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SP*RS*PR').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
      //   cTesRet:='578'
      If ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RJ') .and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'   
         //cTesRet:='798'
         cTesRet:='849'  //Fernando                                                             //ZFM-009                     F - CONS.FINAL     118 - NAO CADASTRADO
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. !SA1->A1_EST $ getmv('MV_NORTE')
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'  .and. SA1->A1_EST $ getmv('MV_NORTE')
         cTesRet:='801'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SC') .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='799'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('MG') .AND. cGruProd <> '015'.and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     //cTesRet:='794'
	      cTesRet:='801'    //Fernando
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
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. !SA1->A1_EST $ getmv('MV_NORTE')
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. SA1->A1_EST $ getmv('MV_NORTE')
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
         //cTesRet:='798'
          cTesRet:='849' //Fernando
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. !SA1->A1_EST $ getmv('MV_NORTE')
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. SA1->A1_EST $ getmv('MV_NORTE')
         cTesRet:='801'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SC') .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     cTesRet:='799'
      ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('MG') .AND. cGruProd <> '015'.and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118'
	     //cTesRet:='794' 
	     cTesRet:='801' //Fernando
   //ELSEIF ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_TIPO = 'F'.and. SA1->A1_TIPO <> 'F'
   //    cTesRet:='708'
      Endif
   ELSEIF SM0->M0_CODFIL = '02'
      if ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('SP*PR*SC').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='578'
      
      elseif ALLTRIM(SB1->B1_POSIPI) $ ('84242000*84243090*84248900') .AND. SA1->A1_EST $ ('RJ').and. SA1->A1_TIPO <> 'F' .and. cGruProd <> '118'
         cTesRet:='798'
      
      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. SA1->A1_GRPTRIB $ '009*166'   .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. !SA1->A1_EST $ getmv('MV_NORTE')
         cTesRet:='704'

      ELSEIF ALLTRIM(SB1->B1_POSIPI)  $ ('84242000*84243090*84248900') .AND. !SA1->A1_GRPTRIB $ '009*166'  .and. SA1->A1_TIPO <> 'F' .AND. cGruProd <> '118' .and. SA1->A1_EST $ getmv('MV_NORTE')
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

//��������������������������������������������������������������Ŀ
//� Restaura a integridade da rotina                             �
//����������������������������������������������������������������
RestArea(aAreaSA2)
RestArea(aAreaSA1)
RestArea(aAreaSB1)
RestArea(aArea)

Return(cTesRet)