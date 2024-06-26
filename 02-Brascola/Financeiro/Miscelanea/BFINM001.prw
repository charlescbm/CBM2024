#include "rwmake.ch"
#include "topconn.ch"
                  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BFINM001 �Autor  � Marcelo da Cunha   � Data �  09/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para gerar arquivo Boa Vista                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BFINM001()
*********************
LOCAL aRegs := {}, cPerg := "BFINM001"

//��������������������������������������������������������������Ŀ
//� Crio o grupo de perguntas                                    �
//����������������������������������������������������������������
aadd(aRegs,{cPerg,"01","Nome do Arquivo      ?","mv_ch1","C",80,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Diretorio do Arquivo ?","mv_ch2","C",80,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Cliente De           ?","mv_ch3","C",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA1"})
aadd(aRegs,{cPerg,"04","Cliente Ate          ?","mv_ch4","C",08,0,0,"G","","MV_PAR04","","ZZZZZZZZ","","","","","","","","","","","","","SA1"})
aadd(aRegs,{cPerg,"05","Data Emissao De      ?","mv_ch5","D	",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Data Emissao Ate     ?","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Data Vencimento De   ?","mv_ch7","D	",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"08","Data Vencimento Ate  ?","mv_ch8","D",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs)
If Pergunte(cPerg,.T.)
	Processa({|| BFinProc() })
Endif                        

Return

Static Function BFinProc()
***********************
LOCAL nHandle, cQuery, cLinha
LOCAL cArq := Alltrim(mv_par01)
LOCAL cDir := Alltrim(mv_par02)
LOCAL nDiaUti, nUsoDia

//��������������������������������������������������������������Ŀ
//� Monto Query para buscar Informacoes para exportar            �
//����������������������������������������������������������������
If (Right(cDir,1) != "\")
	cDir += "\"
Endif     
nHandle := MsfCreate(cDir+cArq,0)
If (nHandle <= 0)
	Help("",1,"BRASCOLA",,OemToAnsi("N�o foi poss�vel gerar o arquivo "+cDir+cArq+"!"),1,0) 
	Return        
Endif
     
//��������������������������������������������������������������Ŀ
//� Monto Query para buscar Informacoes para exportar            �
//����������������������������������������������������������������
cQuery := "SELECT E1.R_E_C_N_O_ MRECSE1 "
cQuery += "FROM "+RetSqlName("SE1")+" E1 "
cQuery += "WHERE E1.D_E_L_E_T_ = '' AND E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += "AND E1.E1_TIPO IN ('NF','DP') "
cQuery += "AND E1.E1_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += "AND E1.E1_EMISSAO BETWEEN '"+dtos(mv_par05)+"' AND '"+dtos(mv_par06)+"' "
cQuery += "AND E1.E1_VENCREA  BETWEEN '"+dtos(mv_par07)+"' AND '"+dtos(mv_par08)+"' "
cQuery += "ORDER BY E1_PREFIXO,E1_NUM,E1_PARCELA "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
Procregua(1)
SE1->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())
	SE1->(dbGoto(MAR->MRECSE1))
	SA1->(dbSeek(xFilial("SA1")+SE1->E1_cliente+SE1->E1_loja,.T.))
	Incproc("> Exportando Dados... "+SE1->E1_prefixo+SE1->E1_num+SE1->E1_parcela)
	cLinha := BCampo(SA1->A1_pessoa,"C",1,0) //Pessoal
	cLinha += BCampo(SA1->A1_cgc,"C",14,0) //CNPJ
	cLinha += BCampo(SA1->A1_nome,"C",55,0) //Razao Social
	cLinha += BCampo(SA1->A1_nreduz,"C",55,0) //Razao Social
	cLinha += BCampo("M","C",01,0) //DDD //Natureza Endereco (Cobranca/Entrega/Matriz/Desconhecido)
	cLinha += BCampo(SA1->A1_end,"C",70,0) //Endereco
	cLinha += BCampo(SA1->A1_mun,"C",30,0) //Cidade
	cLinha += BCampo(SA1->A1_est,"C",02,0) //Estado
	cLinha += BCampo(Val(SA1->A1_cep),"N",08,0) //CEP
	cLinha += BCampo(Val(SA1->A1_ddd),"N",04,0) //DDD
	cLinha += BCampo(Val(SA1->A1_tel),"N",10,0) //Telefone
	cLinha += BCampo(0,"N",04,0) //DDD Fax
	cLinha += BCampo(0,"N",10,0) //Numero Fax
	cLinha += BCampo(SA1->A1_email,"C",50,0) //Email
	cLinha += BCampo(iif(!Empty(SA1->A1_pricom),SA1->A1_pricom,SE1->E1_emissao),"D",6,0,"1") //Cliente Desde
	cLinha += BCampo(SE1->E1_prefixo+SE1->E1_num,"C",12,0) //Numero do Titulo
	If (Alltrim(SE1->E1_tipo) == "NF")
		cLinha += BCampo("N","C",01,0) //Tipo de Titulo
	Elseif (Alltrim(SE1->E1_tipo) == "DP")
		cLinha += BCampo("D","C",01,0) //Tipo de Titulo
	Elseif (Alltrim(SE1->E1_tipo) == "FT")
		cLinha += BCampo("F","C",01,0) //Tipo de Titulo
	Else
		cLinha += BCampo("O","C",01,0) //Tipo de Titulo
	Endif
	cLinha += BCampo("R$","C",04,0) //Moeda
	nInt := Int(SE1->E1_valor)
	nDec := SE1->E1_valor-nInt
	cLinha += BCampo(nInt,"N",11,0) //Valor Venda
	cLinha += BCampo(nDec,"N",02,0) //Centavos
	nInt := Int(SE1->E1_valor-SE1->E1_saldo)
	nDec := (SE1->E1_valor-SE1->E1_saldo)-nInt
	nInt := iif(nInt>0,nInt,0)
	nDec := iif(nDec>0,nDec,0)
	cLinha += BCampo(nInt,"N",11,0) //Valor Pagamento
	cLinha += BCampo(nDec,"N",02,0) //Centavos
	cLinha += BCampo(SE1->E1_emissao,"D",08,0,"2") //Data da Venda
	cLinha += BCampo(SE1->E1_vencrea,"D",08,0,"2") //Data do Vencimento
	cLinha += BCampo(SE1->E1_baixa,"D",08,0,"2") //Data do Pagamento
	cLinha += chr(13)+chr(10)
	FWrite(nHandle,cLinha,Len(cLinha))
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
fClose(nHandle)

MsgInfo("> Arquivo "+cDir+cArq+" gerado com sucesso!")

Return            

Static Function BCampo(xValor,xTipo,xTam,xDec,xTpDat)
************************************************
LOCAL cRetu := ""
If (xTipo == "C")
	cRetu := Alltrim(Substr(xValor,1,xTam))
	cRetu := cRetu+Space(xTam-Len(cRetu))
Elseif (xTipo == "N")
	cRetu := Strzero(xValor,xTam)
Elseif (xTipo == "D") 
	If (xTpDat == "1") //MMAAAA
		cRetu := Substr(dtos(xValor),5,2)+Substr(dtos(xValor),1,4)
	Elseif (xTpDat == "2") //DDMMAAAA
		cRetu := Substr(dtos(xValor),7,2)+Substr(dtos(xValor),5,2)+Substr(dtos(xValor),1,4)
	Endif
Endif
Return cRetu