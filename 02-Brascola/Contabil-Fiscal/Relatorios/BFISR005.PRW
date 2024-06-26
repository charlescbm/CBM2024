#INCLUDE "Matr921.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �Matr921      �Autor� Juan Jose Pereira    � Data � 07.01.97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime listagem para transcricao manual de entradas/saidas ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcelo Pim.�24/11/97�13523A� Ajustar incremento de controle de paginas���
���Eduardo     �26/05/98�15671A� Impressao de valores com F4_LIPI == Z    ���
���M.Simidu    �15/06/98�XXXXXX� Ajustes na impressao de valores Zerados. ���
���M.Simidu    �03/11/98�XXXXXX� Acertos no ano para 4 bytes.             ���
���M.Simidu    �10/11/98�18744A� Impressao de ICMS isentas/outros.        ���
���Andreia     �27/01/99�19443A� Correcao de bound error quando icms isen-���
���            �        �      � to e com base de calculo reduzida.       ���
���Andreia     �06/05/99�20734A� Tratamento da impressao do nome do forne-���
���            �        �      � cedor quando nota fiscal de entrada com  ���
���            �        �      � formulario proprio.                      ���
���Andreia     �23/11/99�24026a� Impressao de ICMS isentas.               ��� 
���Eduardo Fer.�27/09/06�XXXXXX� Processamento por multiplas filiais      ���
���Marcos Kato �07/07/09�16489 � Considerar a decricao do emitente para   ���
���            �        �      � Nota Fiscal Complementar - CH:SBVLJA     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER FUNCTION BFISR005()
// Variaveis de controle de multiplas filiais
Local aFilsCalc := {} 
Local nForFilial
Local cFilBack  := cFilAnt
Local MVIsento	:= mv_par16       

//���������������������������������Ŀ
//� Inicializa Variaveis            �
//�����������������������������������                      
Private lEnd:=.F.
//���������������������������������Ŀ
//� Largura do campo de observacoes �
//�����������������������������������
nLargObs:=IIf(nTipoMov==2,36,24)//42/30
//���������������������������������Ŀ
//� Largura do campo de cod.emitente�                                                           
//�����������������������������������
nLargEmi:=45
//������������������������������Ŀ
//� Pictures de campos numericos �
//��������������������������������
cPictVl:="@E 999,999,999,999.99"	// Colunas Valores
//�����������������������������������Ŀ
//� Recebe layout do modelo escolhido �
//�������������������������������������
aL:=NIL
R921LayOut()

aFilsCalc := MatFilCalc( MV_PAR13 == 1 )
If Empty( aFilsCalc )
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
	Return
Endif

For nForFilial := 1 to Len( aFilsCalc )
	If aFilsCalc[nForFilial][1]
		
		cFilAnt   := aFilsCalc[nForFilial][2]
		nLin      := 80  // faz a quebra de pagina por filial 
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		
		//��������������������������������������������������������Ŀ
		//�Nome da filial a ser impressa no cabecalho do relatorio.�
		//����������������������������������������������������������
		cNomEmp	:=Trim(SM0->M0_NOMECOM)
		cData:= dtos(ddatabase)
		cData:= substr(cData,7,2)+"/"+substr(cData,5,2)+"/"+substr(cData,1,4)
		cNomFil :=Trim(SM0->M0_FILIAL)+"  -  "+cData

		//��������������������������������������������������������������������Ŀ
		//� Cria Arquivo a ser Impresso com um indice de mesmo nome            �
		//� Ordem (1) = F3_FILIAL+DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_CFO  �
		//����������������������������������������������������������������������
		cArqTemp:=EmiteLivro(If(nTipoMov==1,"E","S"),dDtIni,dDtFim,lLacuna,lServico,lDesconto,cNrLivro,cFilterUser,,2,MV_PAR04,2,cFilAnt,cFilAnt,NIL,"MATR921",MVIsento)
	   
	   	//����������������������������Ŀ
		//� Salva periodos de Apuracao �
		//������������������������������
		nSvApurICM:=DefPeriodo(F3_ENTRADA,nApurICM)
		nSvApurIPI:=DefPeriodo(F3_ENTRADA,nApurIPI)
		If !lAbortPrint
			R921Listagem()
		Endif
		//���������������Ŀ
		//� Restaura area �
		//�����������������
		dbSelectArea(cArqTemp)
		dbClearFilter()
		dbCloseArea()
		Ferase(cArqTemp+GetDBExtension())
		Ferase(cArqTemp+OrdBagExt())
		dbSelectArea(aSvArea[1])
		dbSetOrder(aSvArea[2])
		dbGoto(aSvArea[3])
		
	EndIf
   		If FWModeAccess("SF3",3)=="C" .And. aFilsCalc[nForFilial][1]
			Exit
	 	EndIf
Next nForFilial

cFilAnt := cFilBack 


Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R921Listagem   �Autor� Juan Jose Pereira  � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime Listagem de Entradas/Saidas                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921Listagem

Local ncw		:=	0
Local bFiltro
Local lHistTab   := GetNewPar ("MV_HISTTAB", .F.)
Local cCGC := ""
Local cNome:= ""
Local cEspecie:= ""  

Local lRemMerc  := .F.
Local lImprZero	:= GetNewPar ("MV_IMPZNFC",.F.)

aGrade:=NIL
dbSelectArea(cArqTemp)
//�������������������������������������������������Ŀ
//� Avalia filtro do usuario                        �
//���������������������������������������������������          

dDiaAnt:=F3_ENTRADA
dDia:=dDiaAnt

If Empty(cFilterUser)
	bFiltro := { || .T. }
Else
	bFiltro := &("{ || " + cFilterUser+ " }")
Endif
SetRegua(LastRec())
While !Eof()

	IncRegua()
	If Interrupcao(@lAbortPrint)
		Exit
	Endif
	
	LivrAcumula(cArqTemp,@aTotDia,@aTotPerICM,@aTotPerIPI,@aTotMes,@aTransp,@aResumo,@aResCFO,,.T.)
    	
	//����������������������������������������������������������������������Ŀ
	//�Para nota fiscal de retorno de Remessao em poder de terceiros o       �
	//�valor contabil deve ser zerado, foi incluido este tratamento para que �
	//�tanto na impressao da nota fiscal quanto nos totalizadores o sistema  �
	//�zere o valor contabil quando a nota fiscal for referente a um retorno �
	//�de remessa. (O tratamento foi copiado do relatorio MATR930)           �
	//������������������������������������������������������������������������
    If GetNewPar("MV_ESTADO","")=="SP" .And. Alltrim((cArqTemp)->F3_CFO) $ "1904/2904"   
	    lRemMerc := .T.
    Else
	    lRemMerc := .F.
    EndIf
		
	If ! Eval(bFiltro)
		//���������������������������������Ŀ
		//�Imprime os periodos sem movimento�
		//�����������������������������������
		If SEMMOV
			dDia:=F3_ENTRADA
			R921Cabec(dDia)
			FmtLin({"*** NAO HOUVE MOVIMENTO ***"},aL[10],,,@nLin)
			nLin	:=	99
			dbSkip()
			dDia:=F3_ENTRADA          
			Loop
		Else
			dbSkip()
			If Eof()
				R921Totais(lRemMerc)
			Endif	  
			Loop
		Endif	
	Else
	    If (!lLacuna .AND. !Empty(F3_DTCANC))
		   dbSelectArea(cArqTemp)
		   dbSkip()
		   If Eof()
		   	  dDia:=F3_ENTRADA
		   	  R921Totais(lRemMerc)
		   Else
			  dbSkip(-1)  
		   Endif	  
	    Endif
	
		//
		//���������������������������������Ŀ
		//�Imprime os periodos sem movimento�
		//�����������������������������������
		If SEMMOV
			dDia:=F3_ENTRADA
			R921Cabec(dDia)
			FmtLin({"*** NAO HOUVE MOVIMENTO ***"},aL[10],,,@nLin)
			nLin	:=	99
			dbSkip()
			dDia:=F3_ENTRADA          
			Loop
		Endif
	
		//�����������Ŀ
		//� Cabecalho �
		//�������������
		If nLin>nLimPag .Or. (Month(dDiaAnt)<>Month(dDia) .Or. Year(dDiaAnt)<>Year(dDia))
			If nLin<60 .And. !(Month(dDiaAnt)<>Month(dDia) .Or. Year(dDiaAnt)<>Year(dDia))
				FmtLin(,aL[01],,,@nLin)
			Endif
			R921Cabec()
		Endif
		//�����������������������������Ŀ
		//� Contador de Tamanho de nota �
		//�������������������������������
		nTamNota:=nLin
		//�������������������������������������������������Ŀ
		//� Posiciona nos cadastros de Clientes/Fornecedores�
		//���������������������������������������������������
		
		cEmitente:=""
		cClieFor:=F3_CLIEFOR+F3_LOJA
		
		If nTipoMov==1
			If F3_TIPO$"DB"
				dbSelectArea("SA1")
			Else
				dbSelectArea("SA2")
			Endif
		Else
			If F3_TIPO$"DB" 
				if (substr(F3_CFO,1,3)=="999".and. F3_FORMUL=="S") .Or. (substr(F3_CFO,1,1)$"123".and. F3_FORMUL=="S") // Quando a NF e cancelada, traz o CFOP preenchido e nao 999
					dbSelectArea("SA1")
				else	
					dbSelectArea("SA2")
				endif	
			Else
				if (substr(F3_CFO,1,3)=="999".and. F3_FORMUL=="S") .Or. (substr(F3_CFO,1,1)$"123".and. F3_FORMUL=="S") // Quando a NF e cancelada, traz o CFOP preenchido e nao 999 
					dbSelectArea("SA2")
				else	
					dbSelectArea("SA1")
				EndIf	
			Endif
		Endif

		dbSeek(F3Filial(Alias())+cClieFor)
		If Alias()=="SA1"
			cEmitente:=If(nCodigo==1,TRIM(A1_COD),Transform(A1_CGC,PicPesFJ(RetPessoa(A1_CGC))))
			cEmitente:=cEmitente+IIf(RetPessoa(A1_CGC)=="F",Space(4),Space(0))+" - "+TRIM(A1_NOME)
		Else
			If lHistTab
				DbSelectArea("AIF")
				AIF->(DbSetOrder(1))
				AIF->(dbSeek(xFilial("AIF")+"  "+"SA2"+SA2->A2_COD+SA2->A2_LOJA+ DTOS(dDia)))
				While !AIF->(Eof()) .And. AIF_TABELA == "SA2" .And. AIF_FILTAB=="  " .And. AIF_CODIGO==SA2->A2_COD .And. AIF_LOJA==SA2->A2_LOJA .And. dDia<AIF->AIF_DATA   
						If Alltrim(AIF->AIF_CAMPO)=="A2_CGC" .And. Empty(cCGC)
							cCGC := Alltrim(Transform(AIF->AIF_CONTEU,PicPesFJ(RetPessoa(AIF->AIF_CONTEU))))
						Elseif Alltrim(AIF->AIF_CAMPO)=="A2_NOME" .And. Empty(cNome)
							cNome := Alltrim(AIF->AIF_CONTEU)	
						Endif
					DbSkip()
				Enddo
				If cCGC<>"" .And. cNome==""
					cEmitente:=If(nCodigo==1,TRIM(SA2->A2_COD),cCGC)
					cEmitente:=cEmitente+IIf(RetPessoa(SA2->A2_CGC)=="F",Space(4),Space(0))+" - "+TRIM(SA2->A2_NOME)
				Elseif cCGC=="" .And. cNome<>""
					cEmitente:=If(nCodigo==1,TRIM(SA2->A2_COD),Transform(SA2->A2_CGC,PicPesFJ(RetPessoa(SA2->A2_CGC))))+" - "+cNome
				Elseif cCGC<>"" .And. cNome<>"" 
					cEmitente:=If(nCodigo==1,TRIM(SA2->A2_COD),cCGC)+" - "+cNome
				Else
					cEmitente:=If(nCodigo==1,TRIM(SA2->A2_COD),Transform(SA2->A2_CGC,PicPesFJ(RetPessoa(SA2->A2_CGC))))
					cEmitente:=cEmitente+IIf(RetPessoa(SA2->A2_CGC)=="F",Space(4),Space(0))+" - "+TRIM(SA2->A2_NOME)	
				Endif
			 	DbGotop()
			Else
				cEmitente:=Space(1)+ If(nCodigo==1,TRIM(SA2->A2_COD),Transform(SA2->A2_CGC,PicPesFJ(RetPessoa(SA2->A2_CGC))))
				cEmitente:=cEmitente+IIf(RetPessoa(A2_CGC)=="F",Space(4),Space(0))+" - "+TRIM(A2_NOME)
			Endif
			cCGC:=""
			cNome:=""
		Endif
		cEmitente:=Substr(cEmitente,1,nLargEmi)
		
		If ( substr((cArqTemp)->F3_CFO,1,3) == "999" ) //Notas Canceladas
			cEspecie := a460Especie((cArqTemp)->F3_SERIE)
		EndIf

		dbSelectArea(cArqTemp)
		//��������������������������������������������������������������������Ŀ
		//� Cria Array com mensagens a serem impressas na coluna de Observacao �
		//����������������������������������������������������������������������
		aObs:=LivrArrayObs(nLargObs,,lListaNFO)
	
		R921IniGrade()
	
		If lImpZer.or.F3_BASEICM+F3_VALICM>0
			aGrade[1,2]:=F3_BASEICM
			aGrade[1,3]:=F3_VALICM
		Else
			aGrade[1,1]:=""
		Endif
	
		If lImpZer.or.F3_ISENICM>0
			ncw:=Ascan(aGrade,{|x|x[1]=="" .or. x[1]=="2"})
			aGrade[ncw,1]:="2"
			aGrade[ncw,2]:=F3_ISENICM
		Endif
	
		If lImpZer.or.F3_OUTRICM>0
			ncw:=Ascan(aGrade,{|x|x[1]=="".or. x[1]=="3"})
			aGrade[ncw,1]:="3"
			aGrade[ncw,2]:=F3_OUTRICM
		Endif
	
		aGrade[4,2]:=F3_BASEIPI
		aGrade[4,3]:=F3_VALIPI
	
		aGrade[5,2]:=F3_ISENIPI
		aGrade[6,2]:=F3_OUTRIPI  
			
		aDados:=Array(16)
		aDados[1]:=If(nTipoMov==1,DTOC(F3_ENTRADA),DTOC(F3_EMISSAO))
		aDados[2]:=If(Empty(F3_ESPECIE),If((Substr(F3_CFO,2,2)$"62").OR.(Substr(F3_CFO,2,3)$"352"),STR0001,Iif(!Empty(cEspecie),cEspecie,STR0002)),F3_ESPECIE) //"CT"###"NF"
		aDados[3]:=F3_SERIE
		aDados[4]:=F3_NFISCAL+" A "+IF(F3_TIPO$"L",F3_DOCOR,F3_NFISCAL)
		aDados[5]:=If(nTipoMov==1,DTOC(F3_EMISSAO),)
		aDados[6]:=cEmitente
		aDados[7]:=F3_ESTADO
		
		If Empty(F3_DTCANC) .Or. lImprZero
			aDados[8]:=Iif(lRemMerc,0,F3_VALCONT)
			aDados[9]:=EvalMacro(cContaContabil)
			aDados[10]:=If(substr(F3_CFO,1,3)$"999#000",,Transform(F3_CFO,PESQPICT("SF3","F3_CFO")))	//F3_CFO
			aDados[14]:=Transform(F3_ALIQICM,"@ZE 99.99")
			//����������������������������������������Ŀ
			//� Imprime Linhas de detalhe              �
			//������������������������������������������
			R921ImpGrade()
		Endif
	
		nPosObs:=Ascan(aObs,{|x|x[2]})
		While nPosObs>0
			R921LoadObs()
			If nPosObs>0
				FmtLin(@aDados,aL[9],cPictVl,,@nLin)
			Endif
		End
		//�����������������Ŀ
		//� Acumula valores �
		//�������������������
		nLinNec:=nLin-nTamNota
		aTamNotas[1]:=Max(aTamNotas[1],nLinNec)
	
		dDiaAnt:=F3_ENTRADA
		dbSelectArea(cArqTemp)
		dbSkip()
		If Empty(F3_ENTRADA)
		   dDiaAnt := dDia
		Endif   
		dDia:=F3_ENTRADA
		//�������������������������������������Ŀ
		//� Imprime Totais e finaliza relatorio �
		//���������������������������������������
		R921Totais(lRemMerc)
	Endif
End   

//������������������������������������������������Ŀ
//�Quando mudar a filial, reinicia os totalizadores�
//��������������������������������������������������
aTotDia    := NIL
aTotPerICM := NIL
aTotPerIPI := NIL
aTotMes    := NIL
aTransp    := NIL
aResumo    := NIL
aResCFO    := NIL

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921Cabec �Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Impressao de Cabecalho                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921Cabec

cPeriodo:=""
If !Empty(dDiaAnt) .Or. !Empty(dDia)
	cPeriodo:=aMeses[Month(IIf(Empty(dDia),dDiaAnt,dDia))]+" / "+Str(Year(IIf(Empty(dDia),dDiaAnt,dDia)),4)
Endif	
cPagina :=StrZero(nPagina++,6)
cTitulo:=If(nTipoMov==1,STR0003,STR0004) //"ENTRADAS"###"SAIDAS"
//��������������������Ŀ
//� Imprime Cabecalho  �
//����������������������
nLin:=0
FmtLin(,AvalImp(nLargMax),,,@nLin)
FmtLin({cNomEmp+" - "+STR0028+cFilAnt+" "+cNomFil,cTitulo,cPagina},aL[1],,,@nLin) //"Filial : "
FmtLin(,aL[2],,,@nLin)
FmtLin({cPeriodo},aL[3],,,@nLin)
FmtLin(,{aL[4],aL[5],aL[6],aL[7],aL[8]},,,@nLin)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921LayOut�Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Layout da Listagem                                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921LayOut

//aL[00]:=0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220                          
//aL[00]:=01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

aL:=Array(10)

aL[01]:=STR0005 //"#################################################################                                    REGISTRO DE ########                                                                                      PAGINA ######"
aL[02]:=""
If nTipoMov==1
	aL[03]:=STR0006 //"MES OU PERIODO/ANO: #######                                                                                                                                                               ----------- OPERACOES ------------"
	aL[04]:=STR0007 //"                                                                                                                                                                                          (1)TRIBUTADAS (2)ISENTAS (3)OUTRAS"
	aL[05]:="----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	aL[06]:=STR0008 //"  DT       ESPE  SE                        DT                                                                                                  ICMS OPERACOES"
	aL[07]:=STR0009 //"ENTRADA    CIE   RIE        NUMERO         EMISSAO                     EMITENTE                   UF     VALOR CONTABIL CONTA CONTABIL       CFO  IPI (*)    BASE DE CALCULO ALIQ    VALOR DO IMPOSTO           OBSERVACOES "
	aL[08]:="----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    aL[09]:="########## ##### ### ##################### ######## ############################################# ## ################## #################### ##### #### # ################## ##### ################## ######################"
	//          [1]     [2]   [3]      [4]           [5]   <------------[6]------45--------------------> [7]      [8]               [9]            [10] [11][12]       [13]         [14]         [15]        <-------------35-[16]----------->
	//       x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789
	//		 0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
Else
	aL[03]:=STR0010 //"MES OU PERIODO/ANO: #######                                                                                                                                                               ----------- OPERACOES ------------"
	aL[04]:=STR0011 //"                                                                                                                                                                                          (1)TRIBUTADAS (2)ISENTAS (3)OUTRAS"
	aL[05]:="----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	aL[06]:=STR0012 //"  DT       ESPE  SE                                                                                                                 ICMS OPERACOES"
	aL[07]:=STR0013 //"EMISSAO    CIE   RIE        NUMERO                              EMITENTE                   UF     VALOR CONTABIL CONTA CONTABIL       CFO  IPI (*)    BASE DE CALCULO ALIQ    VALOR DO IMPOSTO                  OBSERVACOES "
	aL[08]:="----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    aL[09]:="########## ##### ### ##################### # ############################################# ## ################## #################### ##### #### # ################## ##### ################## #############################"
	//          [1]     [2]   [3]       [4]      [5]<------------[6]------45--------------------> [7]      [8]               [9]            [10] [11][12]       [13]         [14]         [15]        <-------------------42-[16]------------>
	//       x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789x123456789
	//		 0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
Endif
aL[10]:="#################################################################################"

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921Transp�Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime linhas de transporte                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921Transp(lRemMerc)

nMaior:=0
AEval(aTamNotas,{|x|nMaior:=Max(nMaior,x)})
aTamNotas[2]:=nMaior

nLinNec:=aTamNotas[2]
lTransp:=(nLimPag<=nLin+nLinNec)

lTransp2 := Iif((60-nLin)>8,.F.,.T.)

If lTransp2
	nTamTransp:=nLin

	aObs:=LivrArrayObs(nLargObs,aTotMes)

	R921IniGrade()

	aGrade[1,2]:=aTransp[ColF3("F3_BASEICM")]
	aGrade[1,3]:=aTransp[ColF3("F3_VALICM")]
	aGrade[2,2]:=aTransp[ColF3("F3_ISENICM")]
	aGrade[3,2]:=aTransp[ColF3("F3_OUTRICM")]

	aGrade[4,2]:=aTransp[ColF3("F3_BASEIPI")]
	aGrade[4,3]:=aTransp[ColF3("F3_VALIPI")]
	aGrade[5,2]:=aTransp[ColF3("F3_ISENIPI")]
	aGrade[6,2]:=aTransp[ColF3("F3_OUTRIPI")]

	aDados:=Array(16)
	FmtLin(@aDados,aL[9],,,@nLin)
	aDados[6]:=STR0014 //"A TRANSPORTAR"
	aDados[8]:=Iif(lRemMerc,0,aTransp[ColF3("F3_VALCONT")])
	//����������������������������������������Ŀ
	//� Imprime Linhas de detalhe              �
	//������������������������������������������
	R921ImpGrade()

	nPosObs:=Ascan(aObs,{|x|x[2]})
	While nPosObs>0
		R921LoadObs()
		If nPosObs>0
			FmtLin(@aDados,aL[9],cPictVl,,@nLin)
		Endif
	End

	nLinNec:=nLin-nTamTransp
	aTamNotas[2]:=Max(aTamNotas[2],nLinNec)

	R921Cabec()
Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921Totdia�Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime total do dia                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921TotDia(lRemMerc)

lTotDia:=(dDiaAnt!=dDia)

If lTotDia .Or. Eof()
	aTamNotas[3]:=Max(aTamNotas[3],nLinNec)
	nLinNec:=aTamNotas[3]

	If nLimPag<=nLin+nLinNec
		R921Transp(lRemMerc)
	Endif

	nTamTotDia:=nLin
	aObs:=LivrArrayObs(nLargObs,aTotDia)

	R921IniGrade()

	If	aTotDia[ColF3("F3_BASEICM")]>0
		aGrade[1,2]:=aTotDia[ColF3("F3_BASEICM")]
	Endif
	If aTotDia[ColF3("F3_VALICM")]>0
		aGrade[1,3]:=aTotDia[ColF3("F3_VALICM")]
	Endif
	If aTotDia[ColF3("F3_ISENICM")]>0
		aGrade[2,2]:=aTotDia[ColF3("F3_ISENICM")]
	Endif
	If aTotDia[ColF3("F3_OUTRICM")]>0
		aGrade[3,2]:=aTotDia[ColF3("F3_OUTRICM")]
	Endif

	aGrade[4,2]:=aTotDia[ColF3("F3_BASEIPI")]
	aGrade[4,3]:=aTotDia[ColF3("F3_VALIPI")]
	aGrade[5,2]:=aTotDia[ColF3("F3_ISENIPI")]
	aGrade[6,2]:=aTotDia[ColF3("F3_OUTRIPI")]

	aDados:=Array(16)
	FmtLin(@aDados,aL[9],,,@nLin)
	aDados[6]:=STR0015+StrZero(Day(dDiaAnt),2) //"TOTAL DO DIA "
	aDados[8]:=Iif(lRemMerc,0,aTotDia[ColF3("F3_VALCONT")])

	//����������������������������������������Ŀ
	//� Imprime Linhas de detalhe              �
	//������������������������������������������
	R921ImpGrade()

	nPosObs:=Ascan(aObs,{|x|x[2]})
	While nPosObs>0
		R921LoadObs()
		If nPosObs>0
			FmtLin(@aDados,aL[9],cPictVl,,@nLin)
		Endif
	End

	FmtLin(@aDados,aL[9],,,@nLin)
	nLinNec:=nLin-nTamTotDia
	aTamNotas[3]:=Max(aTamNotas[3],nLinNec)
Endif
If lTotDia
	Afill(aTotDia,0)
Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921TotMes�Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime total do Mes                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921TotMes(lRemMerc)

lTotMes:=(Month(dDiaAnt)!=Month(dDia))

If lTotMes .Or. Eof()
	If nLin>=nLimPag
		R921Transp(lRemMerc)
	Endif
	aObs:=LivrArrayObs(nLargObs,aTotMes)

	R921IniGrade()

	If	aTotMes[ColF3("F3_BASEICM")]>0
		aGrade[1,2]:=aTotMes[ColF3("F3_BASEICM")]
	Endif
	If aTotMes[ColF3("F3_VALICM")]>0
		aGrade[1,3]:=aTotMes[ColF3("F3_VALICM")]
	Endif
	If aTotMes[ColF3("F3_ISENICM")]>0
		aGrade[2,2]:=aTotMes[ColF3("F3_ISENICM")]
	Endif
	If aTotMes[ColF3("F3_OUTRICM")]>0
		aGrade[3,2]:=aTotMes[ColF3("F3_OUTRICM")]
	Endif

	aGrade[4,2]:=aTotMes[ColF3("F3_BASEIPI")]
	aGrade[4,3]:=aTotMes[ColF3("F3_VALIPI")]
	aGrade[5,2]:=aTotMes[ColF3("F3_ISENIPI")]
	aGrade[6,2]:=aTotMes[ColF3("F3_OUTRIPI")]

	aDados:=Array(16)
	FmtLin(@aDados,aL[9],,,@nLin)
	aDados[6]:=STR0016 //"TOTAL DO MES"
	aDados[8]:=Iif(lRemMerc,0,aTotMes[ColF3("F3_VALCONT")])

	//����������������������������������������Ŀ
	//� Imprime Linhas de detalhe              �
	//������������������������������������������
	R921ImpGrade()

	nPosObs:=Ascan(aObs,{|x|x[2]})
	While nPosObs>0
		R921LoadObs()
		If nPosObs>0
			FmtLin(@aDados,aL[9],cPictVl,,@nLin)
		Endif
	End

	FmtLin(@aDados,aL[9],,,@nLin)
Endif
If lTotMes .Or. Eof()
	Afill(aTransp,0)
	Afill(aTotMes,0)
	Afill(aTamNotas,0)
Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921TotPer�Autor � Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime total do periodo de apuracao                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921TotPer(lRemMerc)
Local nX :=0

lTotPerICM:=(nSvApurICM!=DefPeriodo(dDia,nApurICM))
lTotPerIPI:=(nSvApurIPI!=DefPeriodo(dDia,nApurIPI))

nLinNec2:=0
If lTotPerICM
	aTamNotas[4]:=Max(aTamNotas[4],nLinNec)
	nLinNec2:=nLinNec2+aTamNotas[4]
Endif
If lTotPerIPI
	aTamNotas[5]:=Max(aTamNotas[5],nLinNec)
	nLinNec2:=nLinNec2+aTamNotas[5]
Endif

If lTotPerICM.or.lTotPerIPI
	nLinNec:=nLinNec2
	If nLimPag<=nLin+nLinNec
		R921Transp(lRemMerc)
	Endif

	aObs:=LivrArrayObs(nLargObs,aTotPerICM)

	R921IniGrade()

	If lTotPerICM
		aGrade[1,2]:=aTotPerICM[ColF3("F3_BASEICM")]
		aGrade[1,3]:=aTotPerICM[ColF3("F3_VALICM")]
		aGrade[2,2]:=aTotPerICM[ColF3("F3_ISENICM")]
		aGrade[3,2]:=aTotPerICM[ColF3("F3_OUTRICM")]
	Endif
	If lTotPerIPI
		aGrade[4,2]:=aTotPerIPI[ColF3("F3_BASEIPI")]
		aGrade[4,3]:=aTotPerIPI[ColF3("F3_VALIPI")]
		aGrade[5,2]:=aTotPerIPI[ColF3("F3_ISENIPI")]
		aGrade[6,2]:=aTotPerIPI[ColF3("F3_OUTRIPI")]
	Endif
	aDados:=Array(16)

	nTamTotPer:=nLin
	cICM:="ICMS"
	cIPI:="IPI"
	nTotVContICM:=Iif(lRemMerc,0,aTotPerICM[ColF3("F3_VALCONT")])
	nTotVContIPI:=Iif(lRemMerc,0,aTotPerIPI[ColF3("F3_VALCONT")])

	lImprime:=.F.
	For nx:=1 to Len(aGrade)
		//����������������Ŀ
		//� Colunas de ICMS�
		//������������������
		If lTotPerICM.and.nx<=3
			If !lImpZer.and.aGrade[nx,2]+aGrade[nx,3]==0
				Loop
			Endif
			If !Empty(cICM)
				aDados[6]:=STR0017 //"TOTAL DO PERIODO"
				aDados[8]:=nTotVContICM
				aDados[11]:="ICMS"
				cICM:=""
			Endif
			aDados[12]:=aGrade[nx,1]
			aDados[13]:=aGrade[nx,2]
			aDados[15]:=aGrade[nx,3]
			lImprime:=.T.
		Endif
		//���������������Ŀ
		//� Colunas de IPI�
		//�����������������
		If lTotPerIPI.and.nx>3
			If !lImpZer.and.aGrade[nx,2]+aGrade[nx,3]==0
				Loop
			Endif
			If !Empty(cIPI)
				aDados[6]:=STR0017 //"TOTAL DO PERIODO"
				aDados[8]:=nTotVContIPI
				aDados[11]:="IPI"
				cIPI:=""
			Endif
			aDados[12]:=aGrade[nx,1]
			aDados[13]:=aGrade[nx,2]
			aDados[15]:=aGrade[nx,3]
			lImprime:=.T.
		Endif
		//����������������������Ŀ
		//� Coluna de Observacoes�
		//������������������������
		If lTotPerICM
			R921LoadObs()
		Endif
		If lImprime
			FmtLin(@aDados,aL[9],cPictVl,,@nLin)
			lImprime:=.F.
		Endif

	If lTotPerICM
		nPosObs:=Ascan(aObs,{|x|x[2]})
		While nPosObs>0
			R921LoadObs()
			If nPosObs>0
				FmtLin(@aDados,aL[9],cPictVl,,@nLin)
			Endif
		End
	Endif
	Next nx

	If lTotPerICM
		nLinNec:=nLin-nTamTotPer
		aTamNotas[4]:=Max(aTamNotas[4],nLinNec)
	Endif
	If lTotPerIPI
		nLinNec:=nLin-nTamTotPer
		aTamNotas[5]:=Max(aTamNotas[5],nLinNec)
	Endif
	FmtLin(@aDados,aL[9],,,@nLin)

	If lTotPerICM
		aFill(aTotPerICM,0)
		nSvApurICM:=DefPeriodo(dDia,nApurICM)
	Endif
	If lTotPerIPI
		aFill(aTotPerIPI,0)
		nSvApurIPI:=DefPeriodo(dDia,nApurIPI)
	Endif
Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921ResCfo�Autor � Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Resumo por CFO                                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921ResCfo(lRemMerc)
Local i	:=0

If !Eof().or.Len(aResCFO)==0
	Return
Endif
//������������Ŀ
//� Ordena CFOs�
//��������������
aResCFO:=Asort(aResCFO,,,{|x,y|x[ColF3("F3_CFO")]<y[ColF3("F3_CFO")]})

aCFOS:={	STR0018,; //"1.00 ENTRADAS DO ESTADO"
			STR0019,; //"2.00 ENTRADAS DE FORA DO ESTADO"
			STR0020,; //"3.00 ENTRADAS DO EXTERIOR"
			"",;
			STR0021,; //"5.00 SAIDAS PARA O ESTADO"
			STR0022,; //"6.00 SAIDAS PARA FORA DO ESTADO"
			STR0023} //"7.00 SAIDAS PARA O EXTERIOR"

cSvCFO:="X"
nLin:=80
For i:=1 to Len(aResCFO)
	If nLin>nLimPag .Or. nLin > 60	//quebra de linha Fernando: 05/08/13 (estava nLin > 75)
		R921Cabec()
	EndIf
	aObs:=LivrArrayObs(nLargObs,aResCFO[i])
	cCFO:=Trim(aResCFO[i,ColF3("F3_CFO")])

	R921IniGrade()

	If aResCFO[i,ColF3("F3_BASEICM")]>0
		aGrade[1,2]:=aResCFO[i,ColF3("F3_BASEICM")]
	Endif
	If aResCFO[i,ColF3("F3_VALICM")]>0
		aGrade[1,3]:=aResCFO[i,ColF3("F3_VALICM")]
	Endif
	If aResCFO[i,ColF3("F3_ISENICM")]>0
		aGrade[2,2]:=aResCFO[i,ColF3("F3_ISENICM")]
	Endif
	If aResCFO[i,ColF3("F3_OUTRICM")]>0
		aGrade[3,2]:=aResCFO[i,ColF3("F3_OUTRICM")]
	Endif

	aGrade[4,2]:=aResCFO[i,ColF3("F3_BASEIPI")]
	aGrade[4,3]:=aResCFO[i,ColF3("F3_VALIPI")]
	aGrade[5,2]:=aResCFO[i,ColF3("F3_ISENIPI")]
	aGrade[6,2]:=aResCFO[i,ColF3("F3_OUTRIPI")]

	aDados:=Array(16)
    If !(Substr(cCFO,1,1)==cSvCFO).and.!(ALLTRIM(cCFO)$"TTT") .And. !Empty (cCFO)
		FmtLin(@aDados,aL[9],,,@nLin)
		cSvCFO:=Substr(cCFO,1,1)
		aDados[6]:=aCFOS[Val(cSvCFO)]
		FmtLin(@aDados,aL[9],,,@nLin)
		aDados[6]:=Replic("=",Len(aCFOS[Val(cSvCFO)]))
		FmtLin(@aDados,aL[9],,,@nLin)
	Endif
	If ("TT"$cCFO)
		FmtLin(@aDados,aL[9],,,@nLin)
        aDados[6]:=If(ALLTRIM(cCFO)=="TTT",STR0024,STR0025) //"TOTAL GERAL"###"TOTAL"
	Else
		aDados[10]:=cCFO
	Endif
	aDados[8]:=Iif(lRemMerc, 0 ,aResCFO[i,ColF3("F3_VALCONT")])

	//����������������������������������������Ŀ
	//� Imprime Linhas de detalhe              �
	//������������������������������������������
	R921ImpGrade()

	nPosObs:=Ascan(aObs,{|x|x[2]})
	While nPosObs>0
		R921LoadObs()
		If nPosObs>0
			FmtLin(@aDados,aL[9],cPictVl,,@nLin)
		Endif
	End
Next i    

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R921ResEst�Autor � Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Resumo por Estado                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921ResEst(lRemMerc)
Local i :=0
Local j	:=0
If !Eof().or.Len(aResumo)==0
	Return
Endif

nLin:=80
//������������������������������������������Ŀ
//� Arranja o resumo em ordem de CFO e Estado�
//��������������������������������������������
aResumo:=ASort(aResumo,,,{|x,y|x[1]+x[2]<y[1]+y[2]})
lFirstCO:=.T.
lFirstNC:=.T.
For i:=1 to Len(aResumo)
	If nLin>nLimPag
		R921Cabec()
	Endif
	aDados:=Array(16)
	If i==1
		FmtLin(@aDados,aL[9],,,@nLin)
		aDados[8]:=STR0026 //"DEMONSTRATIVO POR ESTADO DE ORIGEM DA MERCADORIA OU DE INICIO DA PRESTACAO DE SERVICO"
		FmtLin(@aDados,aL[9],,,@nLin)
		aDados[8]:="====================================================================================="
		FmtLin(@aDados,aL[9],,,@nLin)
		FmtLin(@aDados,aL[9],,,@nLin)
	Endif
	aGrade:={}
	If aResumo[i,4]>0
		AADD(aGrade,{"1",aResumo[i,4]})
	Endif
	If aResumo[i,7]>0
		AADD(aGrade,{"2",aResumo[i,7]})
	Endif
	If aResumo[i,5]>0
		AADD(aGrade,{"3",aResumo[i,5]})
	Endif
	aDados[7]:=aResumo[i,2]
	aDados[8]:=Iif(lRemMerc,0,aResumo[i,3])
	If aResumo[i,6]>0
		aDados[16]:=STR0027+Alltrim(Transform(aResumo[i,6],PesqPict("SF3","F3_ICMSRET"))) //"ICMS RETIDO...: "
	Endif
	For j:=1 to Len(aGrade)
		aDados[12]:=aGrade[j,1]
		aDados[13]:=aGrade[j,2]
		FmtLin(@aDados,aL[9],cPictVl,,@nLin)
	Next j

Next i

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R921LoadObs�Autor � Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega observacao para ser impressa                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921LoadObs

nPosObs:=Ascan(aObs,{|x|x[2]})
If nPosObs>0
	aDados[16]:=aObs[nPosObs,1]
	aObs[nPosObs,2]:=.F.
Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R921Totais �Autor � Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Aciona funcoes de totalizacao                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921Totais(lRemMerc)
R921Transp(lRemMerc)
R921TotDia(lRemMerc)
R921TotPer(lRemMerc)
R921TotMes(lRemMerc)
//������������������������Ŀ
//� Imprime Resumo por CFO �
//��������������������������
R921ResCfo(lRemMerc)
//���������������������������Ŀ
//� Imprime Resumo por Estado �
//�����������������������������
R921ResEst(lRemMerc)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R921IniGrade�Autor� Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inicializa array aGrade do registro de entradas            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921IniGrade
//�������������������������������������Ŀ
//� Monta grade de impressao            �
//� [1]=Codigo de Operacao              �
//� [2]=Base / Isentas / Outras         �
//� [3]=Valor do imposto                �
//���������������������������������������
aGrade:=Array(6)
aGrade[1]:={"1",0,0} //
aGrade[2]:={"2",0,0} // ICMS
aGrade[3]:={"3",0,0} //
aGrade[4]:={"1",0,0} //
aGrade[5]:={"2",0,0} // IPI
aGrade[6]:={"3",0,0} //

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �R921ImpGrade�Autor� Juan Jose Pereira     � Data � 23.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime aGrade do registro de entradas                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R921ImpGrade

Local nVlrCont:=aDados[8]
Local nX :=0

cICMS:="ICMS"
cIPI :="IPI"
For nx:=1 to Len(aGrade)
	If !lImpZer.and.(aGrade[nx,2]+aGrade[nx,3]+IIf(nx==1,nVlrCont,0))==0
		Loop
	Endif
	If nx<=3
		aDados[11]:=cICMS
		cICMS:=""
	Else
		aDados[11]:=cIPI
		cIPI:=""
	Endif
	aDados[12]:=aGrade[nx,1]
	aDados[13]:=aGrade[nx,2]
	aDados[15]:=aGrade[nx,3]
	R921LoadObs()
	FmtLin(@aDados,aL[9],cPictVl,,@nLin)
	//
	nPosObs:=Ascan(aObs,{|x|x[2]})
	While nPosObs>0
		R921LoadObs()
		If nPosObs>0
			FmtLin(@aDados,aL[9],cPictVl,,@nLin)
		Endif
	End
Next nx

Return
