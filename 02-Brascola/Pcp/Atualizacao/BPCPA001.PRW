#INCLUDE "RWMAKE.CH"
#INCLUDE "TbiConn.ch"   
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"    
#INCLUDE "TOPCONN.CH"  

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRIAMOD   �Autor  �Sergio Lacerda S.Ser� Data �  28/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atraves do Cadastro de Recursos gera os registros MOD na    ���
���          �estrutura de cada produto.                                  ���
�������������������������������������������������������������������������͹��
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BPCPA001()

Local cProduto  := ""
Local cAlias    := "SG2"

dbSelectArea(cAlias)
dbGoTop()            

/////////////////////////////////////////////////////

Private 	cPerg 	:= U_CRIAPERG("ESTM02")
Private 	aRegs 	:= {}
Private 	_oDlg				// Dialog Principal
Private 	INCLUI	:= .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

AADD(aRegs,{cPerg,"01","Produto?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})

//Constroi o Pergunte se n�o existir 
If lValidPerg(aRegs)
	Pergunte(cPerg,.f.) 
EndIf

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Criacao de MODs nas Estruturas") FROM C(178),C(181) TO C(300),C(500) PIXEL
@ C(003),C(003) TO C(060),C(100) LABEL "" PIXEL OF _oDlg

// Cria Componentes Padroes do Sistema
@ C(006),C(110) Button OemtoAnsi("Ok") 				Size C(037),C(012) PIXEL OF _oDlg 	Action(GERM())  
@ C(024),C(110) Button OemtoAnsi("Parametros") 	    Size C(037),C(012) PIXEL OF _oDlg 	Action(Pergunte(cPerg,.t.))
@ C(042),C(110) Button OemtoAnsi("Sair") 			Size C(037),C(012) PIXEL OF _oDlg 	Action(_oDlg:End())

@ C(008),C(007) Say 'Este programa cria a MOD na estrutura do   '	Size C(150),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(018),C(008) Say 'produto informado no parametro, baseado no '	Size C(150),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(028),C(008) Say 'cadastro de recursos do produto informado. '	Size C(150),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)

/*

cProduto := G2_PRODUTO

//�������������������������������������������������Ŀ
//�Esta funcao CRIAMOD processa a tabela inteira SG2�
//���������������������������������������������������
While !Eof()
	cProduto:= U_GERM2(cProduto)
EndDo

MsgBox("Atualiza��o concluida com Sucesso")

Return(.T.)    
 
 */
 

//***********************************************************************
//*Esta funcao GERACALC  recebe um parametro cPRODUTO da funcao CRIAMOD *
//*e efetua o procedimento para o unico produto recebido no parametro   *
//***********************************************************************
User Function GERM2(cProduto)

Local nTempo    := 0
Local cCusto    := ""
Local nTempo100 := 100
Local nTempo60  := 60
Local aItens    := {}
LOCAL _TIPO     := ''                         

DBSELECTAREA("SB1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SB1")+cProduto)
	OPER:= SB1->B1_OPERPAD
Else
	Alert("Produto n�o encontrado na TABELA DE PRODUTOS, Processamento Cancelado!")
	return
ENDIF

dbSelectArea("SG2")
dbSetOrder(1)
If SG2->(MsSeek(xFilial("SG2")+cProduto+OPER))

	While !Eof() .AND. SG2->G2_PRODUTO+SG2->G2_CODIGO == cProduto+OPER
		
		dbSelectArea("SH1")
		dbSetOrder(1)
		If dbSeek( xFilial("SH1") + SG2->G2_RECURSO )
			cCusto := H1_CCUSTO
		EndIf
		
		dbSelectArea("SG2")
		
		//Precisa rever este conceito de transformacao da unidade de TEMPO.
		//Acredito que o segundo bloco possui incorrecoes no algoritmo		
		/*
		If G2_TEMPAD < 1
			nTempo := G2_TEMPAD * nTempo100
			nTempo := nTempo / nTempo60
			nTempo := nTempo / G2_LOTEPAD
			nTempo := nTempo * G2_MAOOBRA
		Else //    <<--
			nTempo := (G2_TEMPAD	- INT(G2_TEMPAD))
			nTempo := nTempo * nTempo100
			nTempo := nTempo / nTempo60
			nTempo := nTempo + INT(G2_TEMPAD)
			nTempo := nTempo / G2_LOTEPAD
			nTempo := nTempo * G2_MAOOBRA
		EndIf  */
		
		
		//if SG2->G2_TPOPER == '1'
		//    nTempo := G2_TEMPAD
		//    _TIPO:= SG2->G2_TPOPER
		//ELSE
		    nTempo := G2_TEMPAD * G2_MAOOBRA / G2_LOTEPAD
		    _TIPO  := SG2->G2_TPOPER
		//ENDIF
		
		dbSkip()
		
		aAdd(aItens,{AllTrim(cCusto),nTempo,_TIPO})	
		
	EndDo	     
                             
	    u_GrMOD2(aItens,cProduto)

Else
  Alert("Produto n�o encontrado na TABELA DE RECURSOS!")
EndIf

//u_GravaMOD(aItens,cProduto)

cProduto := SG2->G2_PRODUTO 

dbSelectArea("SG2")

Return(cProduto)

//************************************************************************
// Esta funcao GRAVAMOD  recebe dois parametros da funcao GERACAL:       *
// 1- um ARRAY com o tempo padrao, por centro de custo, apurado na tabela*
//    de RECURSOS do sistema;                                            *
// 2- um parametro cProduto, que identifica o item Pai da Estrutura que  *
//    esta sendo processada.                                             *
//************************************************************************
User Function GRMOD2(aItens,cProduto)

Local aCount := {}
Local nCount := 0
Local nFlag  := 1
Local nConv  := 0

aSort(aItens,,,{|x,y| x[1] > y[1]})

cCusto := aItens[1,1]
nCount := aItens[1,2]
_SETUP := aItens[1,3]

if  Len(aItens) <> 1

  While nFlag <= Len(aItens)

  //	For N1 := nFlag To Len(aItens)
  //	If aItens[N1,1] == cCusto
  //    nCount := aItens[N1,2]
  //    nFlag ++
  //	EndIf
  //	Next       
	
	dbSelectArea("SB1")
	dbSetorder(1)
	If dbSeek(xFilial("SB1") + cProduto )
		nConv := B1_QB
	EndIf	
	
   	
     cCusto := aItens[nFlag,1]
     nCount := aItens[nFlag,2]
     _SETUP := aItens[nFlag,3]

   	
   	
   	//IF _SETUP == '1'
    // 	aAdd(aCount,{AllTrim(cCusto),(Round(nCount,6)),_SETUP})
    //ELSE
   	    aAdd(aCount,{AllTrim(cCusto),(Round(nCount,6)*nConv),_SETUP})
    //ENDIF
   
   //	aAdd(aCount,{AllTrim(cCusto),nCount})
	
	//If nFlag <= Len(aItens)
	//	cCusto := aItens[nFlag,1]
	//EndIf
	nFlag ++
		
EndDo	

else
	dbSelectArea("SB1")
	dbSetorder(1)
	If dbSeek(xFilial("SB1") + cProduto )
		nConv := B1_QB
	EndIf	
	
	//IF _SETUP == '1'
    //  	aAdd(aCount,{AllTrim(cCusto),(Round(nCount,6)),_SETUP})
    //ELSE
   	   aAdd(aCount,{AllTrim(cCusto),(Round(nCount,6)*nConv),_SETUP})
    //ENDIF
   //	aAdd(aCount,{AllTrim(cCusto),nCount})
ENDIF	

	
u_Gr2(cProduto,aCount)

aItens := {}


Return(.T.)


//************************************************************************
// Esta funcao GRAVAEST recebe dois parametros da funcao GRAVAMOD:       *
//1 - um parametro cProduto, que identifica o item Pai da Estrutura que  *
//    esta sendo processada.                                             *
//2 - um ARRAY com o total do tempo padrao, acumulado por Centro de Custo*
//    conforme apontado na tabela de de RECURSOS do sistema              *
//***********************************************************************
User Function GR2(cProduto,aCount)

Local cProduto := cProduto
Local cTRT     := ""


_cQuery:= "UPDATE " + RetSQLName('SG1') + ' '"
_cQuery+= " SET D_E_L_E_T_ = '*' ,R_E_C_D_E_L_ = R_E_C_N_O_  "
_cQuery+= "WHERE D_E_L_E_T_ = '' "
_cQuery+= "AND G1_COD = '" + cProduto + "' " 
_cQuery+= "AND SUBSTRING(G1_COMP,1,3) = 'MOD' "

TCSQLEXEC( _cQuery )

//cTrt := "999" 
//aSort(aCount,,,{|x,y| x[1] < y[1]})
cTrt := 900


 
For N1 := 1 To Len(aCount)
	cTrt:=cTrt+1
	dbSelectArea("SG1")
	RecLock("SG1",.T.)
	G1_FILIAL := xFilial("SG1")
	G1_COD    := cProduto
	G1_COMP   := "MOD"+aCount[N1,1]
	G1_TRT    := str(cTRT,3)
	G1_QUANT  := aCount[N1,2]
	G1_INI    := dDataBase
    G1_FIM    := SToD("20491231")
	//if aCount[N1,3] == '1'
	//   G1_FIXVAR := "F"
	//ELSE
	   G1_FIXVAR := "V"
	//ENDIF
	G1_REVINI := "000"
	G1_REVFIM := "ZZZ"
	G1_NIV    := "01"
	G1_NIVINV := "99"
	MsUnlock()
Next   

dbSelectArea("SG1")

MsgBox("Atualiza��o concluida com Sucesso")

Return(.T.)
                 


/*/      
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � RESTM02    � Autor � Elias Reis            � Data �15/06/2007���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por cadastrar as MODS dos produtos baseado���
���           � no cadastro de recurso do produto informado no parametro.    ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/    
/*
User Function RESTM05() 
***********************
Local 	cPerg 	:= U_CRIAPERG("ESTM02")
Local 	aRegs 	:= {}
Private 	_oDlg				// Dialog Principal
Private 	INCLUI	:= .F.	// (na Enchoice) .T. Traz registro para Inclusao / .F. Traz registro para Alteracao/Visualizacao

AADD(aRegs,{cPerg,"01","Produto?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","","",""})

//Constroi o Pergunte se n�o existir 
If lValidPerg(aRegs)
	Pergunte(cPerg,.f.) 
EndIf

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Criacao de MODs nas Estruturas") FROM C(178),C(181) TO C(323),C(653) PIXEL
@ C(001),C(003) TO C(072),C(195) LABEL "" PIXEL OF _oDlg

// Cria Componentes Padroes do Sistema
@ C(006),C(197) Button OemtoAnsi("Ok") 				Size C(037),C(012) PIXEL OF _oDlg 	Action(GERM())  
@ C(024),C(197) Button OemtoAnsi("Parametros") 	    Size C(037),C(012) PIXEL OF _oDlg 	Action(Pergunte(cPerg,.t.))
@ C(042),C(197) Button OemtoAnsi("Sair") 			Size C(037),C(012) PIXEL OF _oDlg 	Action(_oDlg:End())

@ C(008),C(007) Say 'Este programa cria a MOD na estrutura do   ' 	Size C(177),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(019),C(008) Say 'produto informado no parametro, baseado no '		Size C(060),C(008) COLOR CLR_BLACK PIXEL OF _oDlg
@ C(028),C(009) Say 'cadastro de recursos do produto informado. '		Size C(090),C(008) COLOR CLR_BLACK PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED 

Return(.T.)
*/
   
//********************************
//utilizada para chamar o fonte
//********************************
Static Function GERM()
If Len(AllTrim(mv_par01))>0
	u_GERM2(MV_PAR01)
Else
	Alert("Produto n�o informado!")
EndIf

Close(_oDlg)
Return          


/*/      
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
Do Case                                                                         
	Case nHRes == 640	//Resolucao 640x480                                         
		nTam *= 0.8                                                                
	Case nHRes == 800	//Resolucao 800x600                                         
		nTam *= 1                                                                  
	OtherWise			//Resolucao 1024x768 e acima                                
		nTam *= 1.28                                                               
EndCase                                                                         
If "MP8" $ oApp:cVersion                                                        
  //���������������������������Ŀ                                               
  //�Tratamento para tema "Flat"�                                               
  //�����������������������������                                               
  If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()                          
       	nTam *= 0.90                                                            
  EndIf                                                                         
EndIf                                                                           
Return Int(nTam) 