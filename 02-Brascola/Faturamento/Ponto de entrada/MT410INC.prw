#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "colors.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410INC �Autor  � Marcelo da Cunha   � Data �  13/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para enviar pedido com aviso sobre itens  ���
���          � bloqueados.                                                ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410INC()
********************** 
LOCAL aProdutos:= {}, aRetu := {}, aListaWF := {}, nn, cEmail, cRespo
LOCAL nValLuc  := 0, nPrcNov := 0, nPerLuc := 0, nTotal := 0, lEnviaWF := .F.
LOCAL lNovaAlc := SuperGetMv("BR_ALNOVA",.F.,.F.) //Parametro para ativar Alcada
LOCAL lFlagLuc := SuperGetMv("BR_FLAGLUC",.F.,.F.) //Parametro para ativar FlagLucro
LOCAL cCodProc := "AVIGES", cDescProc := "Aviso Gestores sobre Pedido Bloqueado"
LOCAL cHTMLModelo	:= "\workflow\wfavisogestor.htm", cSubject := ""
LOCAL cFromName	:= "Workflow -  BRASCOLA"
    
PRIVATE nDescPre := SuperGetMv("BR_ALDESCP",.F.,55) //Presidencia
PRIVATE nDescDir := SuperGetMv("BR_ALDESCD",.F.,30) //Diretoria
PRIVATE nDescGer := SuperGetMv("BR_ALDESCG",.F.,22) //Gerencial
PRIVATE nDescSup := SuperGetMv("BR_ALDESCS",.F.,18) //Supervisao
PRIVATE nDescRep := SuperGetMv("BR_ALDESCR",.F.,15) //Representante

//����������������������������������������������������������Ŀ	
//� Verifico alcada esta ativa                               �
//������������������������������������������������������������
If (!lNovaAlc).or.(!lFlagLuc)
	Return
Endif

//����������������������������������������������������������Ŀ	
//� Alimento itens do e-mail para o supervisor               �
//������������������������������������������������������������
cEmail := ""
SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1)) ; SB1->(dbSetOrder(1))
SC5->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+M->C5_num,.T.))
SC6->(dbSeek(xFilial("SC6")+M->C5_num,.T.))
While !SC6->(Eof()).and.(xFilial("SC6") == SC6->C6_filial).and.(SC6->C6_num == M->C5_num)
	SB1->(dbSeek(xFilial("SB1")+SC6->C6_produto,.T.))
	nTotal += SC6->C6_valor         
	aadd(aListaWF,{SC6->C6_x_bldsc,SC6->C6_item,SC6->C6_produto,SB1->B1_desc,SC6->C6_qtdven,SC6->C6_prcven,SC6->C6_valor,SC6->C6_descont,SC6->C6_flagluc})
	aadd(aProdutos,{SC6->C6_produto,SC6->C6_qtdven,SC6->C6_prcven,SC6->C6_descont})
	cRespo := BRespEmail(M->C5_vend1,SC6->C6_descont)
	If !Empty(cRespo).and.!(cRespo $ cEmail)
		cEmail += Alltrim(cRespo)+";"
	Endif
	If (SC6->C6_x_bldsc == "B")
		lEnviaWF := .T.
	Endif
	SC6->(dbSkip())
Enddo
If (!lEnviaWF).or.(Len(aCols) <= 0).or.(Len(aListaWF) <= 0).or.Empty(cEmail)
	Return
Endif

//����������������������������������������������������������Ŀ	
//� Funcao para analisar o pedido de venda                   �
//������������������������������������������������������������
u_BRAXCUS(SC5->C5_tabela,aProdutos,,@aRetu)
For nn := 1 to Len(aRetu[2])
	nValLuc += aRetu[2,nn,GDFieldPos("MM_VALLUC",aRetu[1])]
	nPrcNov += aRetu[2,nn,GDFieldPos("MM_PRCNOV",aRetu[1])]
Next nn
If (nPrcNov != 0)
	nPerLuc := (nValLuc/nPrcNov)*100
Endif           

//����������������������������������������������������������Ŀ	
//� Montagem do Workflow de Aviso para gestor                �
//������������������������������������������������������������
SA1->(dbSeek(xFilial("SA1")+M->C5_cliente+M->C5_lojacli,.T.))
SA3->(dbSeek(xFilial("SA3")+M->C5_vend1,.T.))
cSubject	:= "WORKFLOW:Pedido de Venda Bloqueado por Regra Comercial para Analise "+M->C5_num+" | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Pedido"  , M->C5_num )
oProcess:oHtml:ValByName("Cliente" , Alltrim(M->C5_cliente)+"/"+Alltrim(M->C5_lojacli)+"-"+Alltrim(SA1->A1_nome) )
oProcess:oHtml:ValByName("Repres"  , Alltrim(M->C5_vend1)+"-"+Alltrim(SA3->A3_nome) )
oProcess:oHtml:ValByName("Email"   , Alltrim(cEmail) )
For nn := 1 to Len(aListaWF)                        
	cStatus := ""
	If (aListaWF[nn,1] == "L") 
		cStatus := "Liberado"
	Elseif (aListaWF[nn,1] == "B")
		cStatus := "Bloqueado"
	Elseif (aListaWF[nn,1] == "R")
		cStatus := "Rejeitado"
	Endif	
   AAdd( oProcess:oHtml:ValByName("Item.status")  , cStatus )
  	AAdd( oProcess:oHtml:ValByName("Item.item")    , aListaWF[nn,2] )
   AAdd( oProcess:oHtml:ValByName("Item.produto") , aListaWF[nn,3] )
  	AAdd( oProcess:oHtml:ValByName("Item.descri")  , aListaWF[nn,4] )
  	AAdd( oProcess:oHtml:ValByName("Item.qtdven")  , Transform(aListaWF[nn,5],PesqPict("SC6","C6_QTDVEN")) )
  	AAdd( oProcess:oHtml:ValByName("Item.prcven")  , Transform(aListaWF[nn,6],PesqPict("SC6","C6_PRCVEN")) )
  	AAdd( oProcess:oHtml:ValByName("Item.valor")   , Transform(aListaWF[nn,7],PesqPict("SC6","C6_VALOR")) )
  	AAdd( oProcess:oHtml:ValByName("Item.descont") , Transform(aListaWF[nn,8],PesqPict("SC6","C6_DESCONT")) )
  	If (aListaWF[nn,9] == "A")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#96D2FA" )
  	Elseif (aListaWF[nn,9] == "B")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#96F5BE" )
  	Elseif (aListaWF[nn,9] == "C")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#F5F5B4" )
  	Elseif (aListaWF[nn,9] == "D")
	  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#FABEBE" )
	Endif
Next nn       
AAdd( oProcess:oHtml:ValByName("Item.status")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.item")    , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.produto") , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.descri")  , "<b>TOTAL:</b>" )
AAdd( oProcess:oHtml:ValByName("Item.qtdven")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.prcven")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("Item.valor")   , "<b>"+Transform(nTotal,PesqPict("SC6","C6_VALOR"))+"</b>" )
AAdd( oProcess:oHtml:ValByName("Item.descont") , "&nbsp;" )
If (nPerLuc > 40)
 	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#96D2FA" )
	oProcess:oHtml:ValByName("Status", "PEDIDO "+M->C5_num+" IDEAL." )
Elseif ((nPerLuc >= 20).and.(nPerLuc < 40))
  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#96F5BE" )
	oProcess:oHtml:ValByName("Status", "PEDIDO "+M->C5_num+" BOM." )
Elseif ((nPerLuc >= 0).and.(nPerLuc < 20))
  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#F5F5B4" )
	oProcess:oHtml:ValByName("Status", "PEDIDO "+M->C5_num+" ATENCAO!" )
Elseif (nPerLuc < 0)
  	AAdd( oProcess:oHtml:ValByName("Item.corlin")   , "#FABEBE" )
	oProcess:oHtml:ValByName("Status", "PEDIDO "+M->C5_num+" COM RESTRI��ES." )
Endif                                      
aRetu := BClienFatur(M->C5_cliente,M->C5_lojacli)
oProcess:oHtml:ValByName("MesAnt", aRetu[1] )
oProcess:oHtml:ValByName("FatAnt", Transform(aRetu[2],PesqPict("SC6","C6_VALOR")) )
oProcess:oHtml:ValByName("MesAtu", aRetu[3] )
oProcess:oHtml:ValByName("FatAtu", Transform(aRetu[4],PesqPict("SC6","C6_VALOR")) )
cEmail := u_BXFormatEmail(cEmail)
oProcess:cTo := cEmail //Email dos Gestores
oProcess:cCC := Alltrim(SA3->A3_email)
//oProcess:cCC := "charlesm@brascola.com.br;marcelo@goldenview.com.br"
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Finish()

Return

Static Function BRespEmail(xVend,xDescont)
**************************************
LOCAL cRetu1 := "", cQuery1 := "", cCodSup := Space(6), cCodGer := Space(6)
SA3->(dbSetOrder(1))
If SA3->(dbSeek(xFilial("SA3")+xVend))
	cCodSup := SA3->A3_super
	cCodGer := SA3->A3_geren
Endif
If !Empty(cCodSup).and.SA3->(dbSeek(xFilial("SA3")+cCodSup)).and.(xDescont <= nDescSup).and.(SA3->A3_tipocad == "4") //Supervisor
	Return (cRetu1 := Alltrim(SA3->A3_email))
Endif
If !Empty(cCodGer).and.SA3->(dbSeek(xFilial("SA3")+cCodGer)).and.(xDescont <= nDescGer).and.(SA3->A3_tipocad == "3") //Gerente
	Return (cRetu1 := Alltrim(SA3->A3_email))
Endif      
//Busco Diretoria//////////////////////////////////////
If (xDescont <= nDescDir)
	cQuery1 := "SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_ = '' "
	cQuery1 += "AND A3_MSBLQL <> '1' AND A3_TIPOCAD = '2' AND A3_EMAIL <> '' "
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MSA3") <> 0)
		dbSelectArea("MSA3")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MSA3"
	dbSelectArea("MSA3")
	While !MSA3->(Eof())
		cRetu1 += Alltrim(MSA3->A3_email)+";"
		MSA3->(dbSkip())
	Enddo
	If !Empty(cRetu1)
		cRetu1 := Left(cRetu1,Len(cRetu1)-1)
	Endif
	If (Select("MSA3") <> 0)
		dbSelectArea("MSA3")
		dbCloseArea()
	Endif
	Return cRetu1
Endif
//Busco Presidencia////////////////////////////////////
If (xDescont <= nDescPre)
	cQuery1 := "SELECT A3_EMAIL FROM "+RetSqlName("SA3")+" A3 WHERE A3.D_E_L_E_T_ = '' "
	cQuery1 += "AND A3_MSBLQL <> '1' AND A3_TIPOCAD = '1' AND A3_EMAIL <> '' "
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MSA3") <> 0)
		dbSelectArea("MSA3")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MSA3"
	dbSelectArea("MSA3")
	While !MSA3->(Eof())
		cRetu1 += Alltrim(MSA3->A3_email)+";"
		MSA3->(dbSkip())
	Enddo
	If !Empty(cRetu1)
		cRetu1 := Left(cRetu1,Len(cRetu1)-1)
	Endif
	If (Select("MSA3") <> 0)
		dbSelectArea("MSA3")
		dbCloseArea()
	Endif
	Return cRetu1
Endif
Return cRetu1

Static Function BClienFatur(xCliente,xLoja)
**************************************
LOCAL aRetu1 := {"",0,"",0}, cQuery1 := "", dData1, dData2
//Faturamento Mes Anterior///////////////////////////////////////////////////
dData1 := FirstDay(dDatabase)-1
dData1 := FirstDay(dData1)
dData2 := LastDay(dData1)
cQuery1 := "SELECT SUM(F2_VALBRUT) F2_VALBRUT FROM "+RetSqlName("SF2")+" F2 "
cQuery1 += "WHERE F2.D_E_L_E_T_='' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery1 += "AND F2_CLIENTE = '"+xCliente+"' AND F2_LOJA = '"+xLoja+"' "
cQuery1 += "AND F2_DUPL <> '' AND F2_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSF2"
If !MSF2->(Eof())
	aRetu1[1] := Left(MesExtenso(Month(dData1)),3)+"/"+Strzero(Year(dData1),4)
	aRetu1[2] := MSF2->F2_valbrut
Endif
//Faturamento Mes Atual//////////////////////////////////////////////////////
dData1 := FirstDay(dDatabase)
dData2 := LastDay(dData1)
cQuery1 := "SELECT SUM(F2_VALBRUT) F2_VALBRUT FROM "+RetSqlName("SF2")+" F2 "
cQuery1 += "WHERE F2.D_E_L_E_T_='' AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery1 += "AND F2_CLIENTE = '"+xCliente+"' AND F2_LOJA = '"+xLoja+"' "
cQuery1 += "AND F2_DUPL <> '' AND F2_EMISSAO BETWEEN '"+dtos(dData1)+"' AND '"+dtos(dData2)+"' "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSF2"
If !MSF2->(Eof())
	aRetu1[3] := Left(MesExtenso(Month(dData1)),3)+"/"+Strzero(Year(dData1),4)
	aRetu1[4] := MSF2->F2_valbrut
Endif
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
Return aRetu1