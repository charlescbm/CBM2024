#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFINJ002 ºAutor  ³ Marcelo da Cunha   º Data ³  16/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow para envio do aviso sobre recebimento de boleto   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFINJ002()
*********************                    
LOCAL cCodProc := "BFINJ002A", oProcess := Nil
LOCAL cDescProc:= "Aviso Recebimento de Boleto"
LOCAL cFromName:= "Setor Financeiro -  BRASCOLA"
LOCAL cHTMLModelo:= "", cSubject:="", cQuery:=""
LOCAL nDias := 0, nConta := 0, aResumo := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do Ambiente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetEnv("01","01","","","FIN","",{"SA1","SE1"})
dData := MsDate()
//dData := (MsDate()-1)

If (Dow(dData) == 1).or.(Dow(dData) == 7)
	Return
Endif           
nDias := 2
If (Dow(dData) == 5).or.(Dow(dData) == 6)   
	nDias := 4
Endif        
                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Titulos que vencem em 2 dias ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_EMIS1,E1_VENCREA,E1_SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" WHERE D_E_L_E_T_='' AND E1_FILIAL = '"+xFilial("SE1")+"' AND E1_PARCELA IN ('','1') "
cQuery += "AND E1_VENCREA='"+dtos(dData+nDias)+"' AND E1_SALDO>0 AND E1_TIPO='NF' AND E1_EMISSAO >= '20120101' AND E1_PORTADO NOT IN ('634','999') "
cQuery += "ORDER BY E1_CLIENTE, E1_LOJA,E1_NUM "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
TCSetField("MAR","E1_EMIS1"   ,"D",08,0)
TCSetField("MAR","E1_VENCREA" ,"D",08,0)

SA1->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Processo de Workflow ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCliente := MAR->E1_cliente+MAR->E1_loja
	If !SA1->(dbSeek(xFilial("SA1")+cCliente))
		MAR->(dbSkip())
		Loop
	Endif
	cHTMLModelo	:= "\workflow\wfavisobol.htm"
	cSubject	:= "BRASCOLA: Aviso Recebimento de Boleto | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
	If (oProcess != Nil)
		oProcess:Free()
	Endif
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	oProcess:oHtml:ValByName("Data",	dtoc(dData+nDias))
	oProcess:oHtml:ValByName("Cliente",Alltrim(SA1->A1_nome))
	While !MAR->(Eof()).and.(cCliente == MAR->E1_cliente+MAR->E1_loja)
   	aadd(oProcess:oHtml:ValByName("it.prefixo") , MAR->E1_prefixo )
 		aadd(oProcess:oHtml:ValByName("it.titulo")  , MAR->E1_num )
	   aadd(oProcess:oHtml:ValByName("it.parcela") , MAR->E1_parcela )
 		aadd(oProcess:oHtml:ValByName("it.emissao") , dtoc(MAR->E1_emis1) )
	  	aadd(oProcess:oHtml:ValByName("it.vencrea") , dtoc(MAR->E1_vencrea) )
 		aadd(oProcess:oHtml:ValByName("it.saldo")	  , Transform(MAR->E1_saldo,"@E 999,999,999.99") )
 		aadd(aResumo,{MAR->E1_nomcli,cCliente,MAR->E1_prefixo,MAR->E1_num,MAR->E1_parcela,MAR->E1_emis1,MAR->E1_vencrea,MAR->E1_saldo})
  		MAR->(dbSkip())
 	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza Processo Workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:ClientName(cUserName)
	If !Empty(SA1->A1_email)
		oProcess:cTo := Alltrim(SA1->A1_email)
	Else
		oProcess:cTo := "cobranca@brascola.com.br"
		//oProcess:cTo := "marcelo@goldenview.com.br;charlesm@brascola.com.br;fmaia@brascola.com.br"
	Endif
	oProcess:cSubject := cSubject
	oProcess:cFromName:= cFromName  
	oProcess:cFromAddr := "cobranca@brascola.com.br"
	oProcess:Start()
	oProcess:Finish()
	
	//nConta++
 	//If (nConta > 0)
  	//	Exit
	//Endif

	dbSelectArea("MAR")
Enddo

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio resumo para cobranca³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aResumo) > 0)           
	cCodProc := "BFINJ002B"
	cDescProc:= "Resumo Aviso Recebimento de Boleto"
	cHTMLModelo	:= "\workflow\wfavresbol.htm"
	cSubject	:= "BRASCOLA: Resumo Aviso Recebimento de Boleto | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
	If (oProcess != Nil)
		oProcess:Free()
	Endif
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	oProcess:oHtml:ValByName("Data",	dtoc(dData+nDias))
	For nx := 1 to Len(aResumo)
	   aadd(oProcess:oHtml:ValByName("it.nomecli") , aResumo[nx,1] ) 
	   aadd(oProcess:oHtml:ValByName("it.cliente") , aResumo[nx,2] )
	   aadd(oProcess:oHtml:ValByName("it.prefixo") , aResumo[nx,3] )
  		aadd(oProcess:oHtml:ValByName("it.titulo")  , aResumo[nx,4] )
	   aadd(oProcess:oHtml:ValByName("it.parcela") , aResumo[nx,5] )
  		aadd(oProcess:oHtml:ValByName("it.emissao") , dtoc(aResumo[nx,6]) )
	  	aadd(oProcess:oHtml:ValByName("it.vencrea") , dtoc(aResumo[nx,7]) )
  		aadd(oProcess:oHtml:ValByName("it.saldo")	  , Transform(aResumo[nx,8],"@E 999,999,999.99") )
	Next nx
	oProcess:ClientName(cUserName)
	oProcess:cTo := "cobranca@brascola.com.br"
	//oProcess:cTo := "marcelo@goldenview.com.br;charlesm@brascola.com.br;fmaia@brascola.com.br"
	oProcess:cSubject := cSubject
	oProcess:cFromName:= cFromName  
	oProcess:cFromAddr := "cobranca@brascola.com.br"
	oProcess:Start()
	oProcess:Finish()
Endif

Return