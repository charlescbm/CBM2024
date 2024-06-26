#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TbiConn.ch"   
#INCLUDE "TOPCONN.CH"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BFISR003()  �Autor  � Rodolfo Gaboardi  � Data �  01/09/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime Relatorio da Guia                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Livros Fiscais Brascola                                    ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function BFISR003()// NOME ROTINA ANTIGA TRANSGUIA()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Notas Fiscais de Saida Com Guias Pagas"
Local cPict          := ""
Local titulo         := "Notas Fiscais de Saida Com Guias Pagas"
Local nLin           := 80
                       //          1         2         3         4         5         6         7         8         9         1         2         3         5         6         7         8
                       //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       	 := "NR.NOTA COD.CLIENTE   NOME                            MUN                 CNPJ                 DT.EMISSAO      DT.SAIDA    UF    DT.GUIAPAGA    VALOR NOTA    VALOR GUIA      BICMSSOL      DILALIQ."
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite		 := 220
Private tamanho      := "G"
Private nomeprog     := "TRANSGUIA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "TRARGUIA"//U_CRIAPERG("TRARGUIA")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TRANSGUIA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aRegs        := {}  
Private _TOTDIA      := 0
Private cString := "SF2"


dbSelectArea("SF2")


 pergunte(cPerg,.F.)

	//���������������������������������������������������������������������Ŀ
	//� Monta a interface padrao com o usuario...                           �
	//�����������������������������������������������������������������������

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//���������������������������������������������������������������������Ŀ
	//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
	//�����������������������������������������������������������������������
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
//EndIf
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunReport �Autor  � Sergio Lacerda     � Data �  01/09/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)


Local cQuery 	:= ''
Local nCount	:= 0


cQuery :=" SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO, A1_CGC,A1_INSCR,A1_MUN, F2_DTSAIDA, F2_X_DTGNR, F2_ICMSRET, F2_EST,F2_VALBRUT,0 DIFAL,F2_BRICMS "
cQuery +=" FROM SF2010,SA1010 WHERE  SF2010.D_E_L_E_T_  <> '*'                                                                                                     "
cQuery +=" AND F2_FILIAL = '"+XFILIAL("SF2")+"'"                                                                                                     "
cQuery +=" AND F2_X_DTGNR BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "                                                                    
//cQuery +=" AND F2_DUPL <> '' "
cQuery +=" AND F2_ICMSRET > 0 "  
cQuery +=" AND A1_COD = F2_CLIENTE "
cQuery +=" AND A1_LOJA = F2_LOJA "
cQuery +=" AND SA1010.D_E_L_E_T_ = '' "
If !Empty(MV_Par03)
	cQuery += " AND F2_EST = '" + MV_Par03 + "' "
ELSE
	cQuery += " AND F2_EST <> 'SC'"
ENDIF

If mv_par04 == 1
	cQuery += " AND F2_X_DTGNR = '' "
elseif mv_par04 == 2
	cQuery += " AND F2_X_DTGNR <> '' "
ENDIF

If Empty(MV_Par03) .OR. MV_Par03 == 'RS'

	cQuery +=" UNION  ALL "
	cQuery +=" SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO, A1_CGC,A1_INSCR,A1_MUN, F2_DTSAIDA,F2_X_DTGNR, SUM( F2_ICMSRET) F2_ICMSRET,F2_EST,SUM(F2_VALBRUT)F2_VALBRUT,((SUM(D2_TOTAL)* 5)/100)DIFAL,SUM(F2_BRICMS)F2_BRICMS "
	cQuery +=" FROM SF2010,SD2010,SB1010,SA1010 WHERE  SF2010.D_E_L_E_T_  <> '*' AND SD2010.D_E_L_E_T_  <> '*' AND SB1010.D_E_L_E_T_  <> '*'  AND SA1010.D_E_L_E_T_  <> '*' "
	cQuery +=" AND F2_FILIAL = '"+XFILIAL("SF2")+"'"
	cQuery +=" AND F2_X_DTGNR BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
   //	cQuery +=" AND F2_DUPL <> '' " 
    cQuery +=" AND A1_COD = F2_CLIENTE "
    cQuery +=" AND A1_LOJA = F2_LOJA "
    cQuery +=" AND F2_DOC = D2_DOC
	cQuery +=" AND F2_SERIE = D2_SERIE
	cQuery +=" AND F2_FILIAL = D2_FILIAL
	cQuery +=" AND F2_EST = 'RS'
	cQuery +=" AND D2_COD = B1_COD
	cQuery +=" AND B1_DIFALRS = '1'
	cQuery +=" AND D2_ICMSRET = 0 
	If mv_par04 == 1
	cQuery += " AND F2_X_DTGNR = '' "
	elseif mv_par04 == 2
	cQuery += " AND F2_X_DTGNR <> '' "
	ENDIF
	cQuery +=" GROUP BY F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_DOC, F2_SERIE, F2_TRANSP, F2_EMISSAO,  F2_DTSAIDA,F2_X_DTGNR,F2_EST,A1_CGC,A1_INSCR,A1_MUN
ENDIF	
	cQuery += " ORDER BY F2_FILIAL, F2_DOC,F2_EMISSAO,F2_EST "

If Select("TRAB") > 0
	TRAB->(DbCloseArea())
EndIf

 TcQuery cQuery New Alias "TRAB"

dbSelectArea("TRAB")
DBGOTOP()

If MV_PAR05 = 1
   u_ProcExcel("TRAB" )  
ENDIF

While !("TRAB")->( Eof() ) 
	nCount++

_TOTDIA := 0


If lAbortPrint
   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
   Exit
Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 8
	Endif
	   
	nLin := nLin + 1 // Avanca a linha de impressao 
	
 _EMISSAO:=TRAB->F2_EMISSAO 
  
  While !("TRAB")->( Eof() ) .AND. TRAB->F2_EMISSAO == _EMISSAO 
	 
		//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 8
	Endif
	   
		@  nLin, 000 PSAY RTRIM(TRAB->F2_DOC)
		@  nLin, 010 PSAY TRAB->F2_CLIENTE     
		_NOMEC:=Posicione("SA1",1,xFilial("SA1")+TRAB->F2_CLIENTE,"A1_NOME")
	    @  nLin, 022 PSAY SUBSTR(_NOMEC,1,25)
        @  nLin, 052 PSAY SUBSTR(TRAB->A1_MUN,1,25)
        @  nLin, 074 PSAY ALLTRIM(TRAB->A1_CGC)
        @  nLin, 096 PSAY stod(TRAB->F2_EMISSAO)
        @  nLin, 110 PSAY stod(TRAB->F2_DTSAIDA)
        @  nLin, 123 PSAY TRAB->F2_EST
        @  nLin, 130 PSAY stod(TRAB->F2_X_DTGNR)  
        @  nLin, 142 PSAY TRAB->F2_VALBRUT PICTURE "9,999,999.99"
        @  nLin, 154 PSAY TRAB->F2_ICMSRET PICTURE "9,999,999.99" 
        @  nLin, 170 PSAY TRAB->F2_BRICMS  PICTURE "9,999,999.99" 
        @  nLin, 184 PSAY  TRAB->DIFAL PICTURE "9,999,999.99"
        
	  _TOTDIA := TRAB->F2_ICMSRET+_TOTDIA +IIF(TRAB->DIFAL > 0,TRAB->DIFAL,0)                                        
	 
	    nLin := nLin + 1
	 
	 TRAB->(DBSKIP())
	 ENDDO
	 
   	@  ++nLin,40 PSAY "TOTAL DE GUIA DO DIA " + DtoC(StoD(_EMISSAO))+"------------>" 
	@  nLin,154 PSAY _TOTDIA PICTURE "9,999,999.99"
	
    @ ++nLin, 000 PSay __PrtFatLine()
	nLin++
EndDo
         


If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
