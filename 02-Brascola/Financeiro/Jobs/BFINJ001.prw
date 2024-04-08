#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFINJ001 ºAutor  ³ Marcelo da Cunha   º Data ³  28/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow para envio dos titulos em atraso                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFINJ001()
*********************                    
LOCAL cVend1:=Space(6), cSuper1:=Space(6), cGeren1:=Space(6)
LOCAL nTotVen1, nTotSup1, nTotGer1, nTotDir1, nLin := 0
LOCAL cEmail1, cEmail2, cEmail3, cNome1, cNome2, cNome3
LOCAL aResSup := {}, aResGer := {}, aResDir := {}
LOCAL cCodProc 	:= "Titulos em Atraso"
LOCAL cDescProc	:= "Titulos em Atraso"
LOCAL cHTMLModelo	:= "", cSubject := ""
LOCAL cFromName	:= "Workflow -  BRASCOLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do Ambiente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RpcSetEnv("01","01","","","FIN","",{"SA1","SA3","SE1"})
dData := MsDate()-1
                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Titulos em Atraso   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT E1_VEND1,E1_FILIAL,E1_CLIENTE,E1_LOJA,E1_NOMCLI,E1_NUM,E1_PARCELA,E1_EMIS1,E1_VENCREA,E1_SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" WHERE D_E_L_E_T_='' AND E1_FILIAL = '"+xFilial("SE1")+"' AND E1_VEND1 <> '' "
cQuery += "AND E1_VENCREA<'"+dtos(dData)+"' AND E1_SALDO>0 AND E1_TIPO='NF' AND E1_EMISSAO >= '20120101' AND E1_PORTADO NOT IN ('634','999')"
cQuery += "ORDER BY E1_VEND1,E1_VENCREA "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
TCSetField("MAR","E1_EMIS1"   ,"D",08,0)
TCSetField("MAR","E1_VENCREA" ,"D",08,0)

SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Processo de Workflow ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSuper1:= Space(6) ; cEmail1 := ""
	cVend1 := MAR->E1_vend1 ; cNome1 := "" ; nTotVen1 := 0
	If SA3->(dbSeek(xFilial("SA3")+cVend1))
		cNome1 := Alltrim(SA3->A3_nome)
		cEmail1:= Alltrim(SA3->A3_email)
		cSuper1:= iif(!Empty(SA3->A3_super),SA3->A3_super,SA3->A3_geren)
		If Empty(cSuper1)
			cSuper1 := 	cVend1
		Endif
	Endif     
	cHTMLModelo	:= "\workflow\wfrepatr.htm"
	cSubject	:= "WORKFLOW:Titulos em Atraso dos Clientes do Representante "+cVend1+" "+cNome1+" | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	oProcess:oHtml:ValByName("Representante",Alltrim(cVend1)+"-"+Alltrim(cNome1))

	dbSelectArea("MAR")
	While !MAR->(Eof()).and.(MAR->E1_vend1 == cVend1)
	   SA1->(dbSeek(xFilial("SA1")+MAR->E1_cliente+MAR->E1_loja,.T.))
	   AAdd( oProcess:oHtml:ValByName("Item.filial")	, MAR->E1_filial )      
	   AAdd( oProcess:oHtml:ValByName("Item.cli")		, MAR->E1_cliente+MAR->E1_loja )
       AAdd( oProcess:oHtml:ValByName("Item.desc")		, MAR->E1_nomcli )
	   AAdd( oProcess:oHtml:ValByName("Item.est")		, SA1->A1_est )
       AAdd( oProcess:oHtml:ValByName("Item.titulo")  , MAR->E1_num+" "+MAR->E1_parcela )
   	   AAdd( oProcess:oHtml:ValByName("Item.emissao") , dtoc(MAR->E1_emis1) )
   	   AAdd( oProcess:oHtml:ValByName("Item.vencrea") , dtoc(MAR->E1_vencrea) )
   	   AAdd( oProcess:oHtml:ValByName("Item.val")		, Transform(MAR->E1_saldo,"@E 999,999,999.99"))
   	//Resumo Supervisos///////////////////////////////
   	nPos1 := aScan(aResSup,{|x| x[1]+x[2]+x[3]+x[4] == cSuper1+cVend1+MAR->E1_filial+MAR->E1_cliente+MAR->E1_loja })
   	If (nPos1 == 0)
   		aadd(aResSup,{cSuper1,cVend1,MAR->E1_filial,MAR->E1_cliente+MAR->E1_loja,MAR->E1_nomcli,SA1->A1_est,ctod("//"),0})
   		nPos1 := Len(aResSup)
   	Endif
   	If (nPos1 > 0)
   		If Empty(aResSup[nPos1,7]).or.(aResSup[nPos1,7] > MAR->E1_vencrea)
	   		aResSup[nPos1,7] := MAR->E1_vencrea
   		Endif
   	   aResSup[nPos1,8] += MAR->E1_saldo
   	Endif
   	//Resumo Gerencial////////////////////////////////////
   	cGeren1 := Space(6)
		If SA3->(dbSeek(xFilial("SA3")+cSuper1))
			cGeren1 := SA3->A3_geren
			If Empty(cGeren1)
				cGeren1 := cSuper1
			Endif
		Endif
   	nPos1 := aScan(aResGer,{|x| x[1]+x[2] == cGeren1+cSuper1 })
   	If (nPos1 == 0)
   		aadd(aResGer,{cGeren1,cSuper1,ctod("//"),0})
   		nPos1 := Len(aResGer)
   	Endif
   	If (nPos1 > 0)
   		If Empty(aResGer[nPos1,3]).or.(aResGer[nPos1,3] > MAR->E1_vencrea)
	   		aResGer[nPos1,3] := MAR->E1_vencrea
   		Endif
   	   aResGer[nPos1,4] += MAR->E1_saldo
   	Endif
   	//Resumo Diretoria////////////////////////////////
   	nPos1 := aScan(aResDir,{|x| x[1] == MAR->E1_cliente+MAR->E1_loja })
   	If (nPos1 == 0)
   		aadd(aResDir,{MAR->E1_cliente+MAR->E1_loja,MAR->E1_nomcli,SA1->A1_est,ctod("//"),0})
   		nPos1 := Len(aResDir)
   	Endif
   	If (nPos1 > 0)
   		If Empty(aResDir[nPos1,4]).or.(aResDir[nPos1,4] > MAR->E1_vencrea)
	   		aResDir[nPos1,4] := MAR->E1_vencrea
   		Endif
   	   aResDir[nPos1,5] += MAR->E1_saldo
   	Endif
   	//////////////////////////////////////////////////
   	nTotVen1 += MAR->E1_saldo
		MAR->(dbSkip())
	Enddo
   AAdd( oProcess:oHtml:ValByName("Item.filial")	, "&nbsp;" )      
   AAdd( oProcess:oHtml:ValByName("Item.cli")		, "&nbsp;" )
  	AAdd( oProcess:oHtml:ValByName("Item.desc")		, "<b>Total Representante "+cVend1+"</b>" )
   AAdd( oProcess:oHtml:ValByName("Item.est")		, "&nbsp;" )
  	AAdd( oProcess:oHtml:ValByName("Item.titulo")  , "&nbsp;" )
  	AAdd( oProcess:oHtml:ValByName("Item.emissao") , "&nbsp;" )
  	AAdd( oProcess:oHtml:ValByName("Item.vencrea") , "&nbsp;" )
  	AAdd( oProcess:oHtml:ValByName("Item.val")		, "<b>"+Transform(nTotVen1,"@E 999,999,999.99")+"</b>")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza Processo Workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:ClientName(cUserName)
	cEmail1 := u_BXFormatEmail(cEmail1)
	If Empty(cEmail1)
		oProcess:cTo := "charlesm@brascola.com.br"
	Else
		oProcess:cTo := cEmail1
	Endif                 
	If (cVend1 != cSuper1)
		If SA3->(dbSeek(xFilial("SA3")+cSuper1)).and.!Empty(SA3->A3_email)
			oProcess:cCC := Alltrim(SA3->A3_email)
		Endif
	Endif
	oProcess:cSubject := cSubject
	oProcess:cFromName:= cFromName
	oProcess:Start()
	oProcess:Free()

	dbSelectArea("MAR")
Enddo
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio e-mail Supervisor   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aResSup) > 0)
	nLin := 1
	aResSup := aSort(aResSup,,,{ |x,y| x[1]+dtos(x[7])<y[1]+dtos(y[7]) })
	While (nLin <= Len(aResSup))
		cSuper1 := aResSup[nLin,1] ; cNome1 := "" ; cEmail1 := "" ; cEmail2 := "" ; nTotSup1 := 0                      
		SA3->(dbSetOrder(1))
		If SA3->(dbSeek(xFilial("SA3")+cSuper1))
			cNome1 := Alltrim(SA3->A3_nome)
			cEmail1:= Alltrim(SA3->A3_email)
			cGeren1:= SA3->A3_geren
			If !Empty(cGeren1).and.SA3->(dbSeek(xFilial("SA3")+cGeren1))
				cEmail2:= Alltrim(SA3->A3_email)
			Endif
		Endif
		cHTMLModelo	:= "\workflow\wfsupatr.htm"
		cSubject	:= "WORKFLOW:Titulos em Atraso dos Clientes do Supervisor "+cSuper1+" "+cNome1+" | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
		oProcess	:= TWFProcess():New(cCodProc,cDescProc)
		oProcess:NewTask(cDescProc,cHTMLModelo)
		oProcess:oHtml:ValByName("Supervisor",Alltrim(cSuper1)+"-"+Alltrim(cNome1))
		While (nLin <= Len(aResSup)).and.(cSuper1 == aResSup[nLin,1])
			cNome2 := ""
			If SA3->(dbSeek(xFilial("SA3")+aResSup[nLin,2]))
				cNome2 := Alltrim(SA3->A3_nome)
			Endif
		   AAdd( oProcess:oHtml:ValByName("Item.vend1")  	, Alltrim(aResSup[nLin,2])+" - "+cNome2 )
		   AAdd( oProcess:oHtml:ValByName("Item.filial")	, aResSup[nLin,3] )
		   AAdd( oProcess:oHtml:ValByName("Item.cli")		, aResSup[nLin,4] )
  		 	AAdd( oProcess:oHtml:ValByName("Item.desc")		, aResSup[nLin,5] )
		   AAdd( oProcess:oHtml:ValByName("Item.est")		, aResSup[nLin,6] )
   		AAdd( oProcess:oHtml:ValByName("Item.vencrea") , dtoc(aResSup[nLin,7]) )
   		AAdd( oProcess:oHtml:ValByName("Item.val")		, Transform(aResSup[nLin,8],"@E 999,999,999.99") )
   		nTotSup1 += aResSup[nLin,8]
   		nLin++
		Enddo     
  	 	AAdd( oProcess:oHtml:ValByName("Item.vend1")   , "&nbsp;" )      
  	 	AAdd( oProcess:oHtml:ValByName("Item.filial")  , "&nbsp;" )
  	 	AAdd( oProcess:oHtml:ValByName("Item.cli")		, "&nbsp;" )
  		AAdd( oProcess:oHtml:ValByName("Item.desc")		, "<b>Total Supervisor "+cSuper1+"</b>" )
   	AAdd( oProcess:oHtml:ValByName("Item.est")		, "&nbsp;" )
  		AAdd( oProcess:oHtml:ValByName("Item.vencrea") , "&nbsp;" )
  		AAdd( oProcess:oHtml:ValByName("Item.val")		, "<b>"+Transform(nTotSup1,"@E 999,999,999.99")+"</b>")
		oProcess:ClientName(cUserName)
		cEmail1 := u_BXFormatEmail(cEmail1)
		If Empty(cEmail1)
			oProcess:cTo := "charlesm@brascola.com.br"
		Else
			oProcess:cTo := cEmail1 //Email Supervisores
		Endif
		cEmail2 := u_BXFormatEmail(cEmail2)
		If Empty(cEmail2)
			oProcess:cCC := "charlesm@brascola.com.br"
		Else
			oProcess:cCC := cEmail2 //Email Gerente
		Endif
		oProcess:cSubject := cSubject
		oProcess:cFromName:= cFromName
		oProcess:Start()
		oProcess:Free()
	Enddo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio e-mail Gerente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aResGer) > 0)
	nLin := 1
	aResGer := aSort(aResGer,,,{ |x,y| x[1]+dtos(x[3])<y[1]+dtos(y[3]) })
	While (nLin <= Len(aResGer))
		cGeren1 := aResGer[nLin,1] ; cNome1 := "" ; cEmail1 := "" ; nTotGer1 := 0
		SA3->(dbSetOrder(1))
		If SA3->(dbSeek(xFilial("SA3")+cGeren1))
			cNome1 := Alltrim(SA3->A3_nome)
			cEmail1:= Alltrim(SA3->A3_email)
		Endif
		cHTMLModelo	:= "\workflow\wfgeratr.htm"
		cSubject	:= "WORKFLOW:Titulos em Atraso dos Clientes do Gerente "+cGeren1+" "+cNome1+" | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
		oProcess	:= TWFProcess():New(cCodProc,cDescProc)
		oProcess:NewTask(cDescProc,cHTMLModelo)
		oProcess:oHtml:ValByName("Gerente",Alltrim(cGeren1)+"-"+Alltrim(cNome1))
		While (nLin <= Len(aResGer)).and.(cGeren1 == aResGer[nLin,1])
			cNome2 := ""
			If SA3->(dbSeek(xFilial("SA3")+aResGer[nLin,2]))
				cNome2 := Alltrim(SA3->A3_nome)
				cEmail2:= Alltrim(SA3->A3_email)
			Endif
		   AAdd( oProcess:oHtml:ValByName("Item.super1")  	, Alltrim(aResGer[nLin,2])+" - "+cNome2 )
   		AAdd( oProcess:oHtml:ValByName("Item.vencrea") , dtoc(aResGer[nLin,3]) )
   		AAdd( oProcess:oHtml:ValByName("Item.val")		, Transform(aResGer[nLin,4],"@E 999,999,999.99") )
   		nTotGer1 += aResGer[nLin,4]
   		nLin++
		Enddo     
  	 	AAdd( oProcess:oHtml:ValByName("Item.super1")  , "<b>Total Gerente "+cGeren1+"</b>" )      
  		AAdd( oProcess:oHtml:ValByName("Item.vencrea") , "&nbsp;" )
  		AAdd( oProcess:oHtml:ValByName("Item.val")		, "<b>"+Transform(nTotGer1,"@E 999,999,999.99")+"</b>")
		oProcess:ClientName(cUserName)
		cEmail1 := u_BXFormatEmail(cEmail1)
		If Empty(cEmail1)
			oProcess:cTo := "charlesm@brascola.com.br"
		Else
			oProcess:cTo := cEmail1 //Email Gerencia
		Endif
		cEmail2 := 	GetMV("BR_000036") //Email Diretoria
		cEmail2 := u_BXFormatEmail(cEmail2)
		oProcess:cCC := cEmail2 
		oProcess:cSubject := cSubject
		oProcess:cFromName:= cFromName
		oProcess:Start()
		oProcess:Free()
	Enddo
Endif 
                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Total Atraso Base Antiga  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT SUM(E1_SALDO) E1_SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" WHERE D_E_L_E_T_<>'*' AND E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += "AND E1_VENCREA<'"+dtos(dData)+"' AND E1_SALDO>0 AND E1_TIPO='NF' AND E1_EMISSAO < '20120101' AND E1_PORTADO NOT IN ('634','999') "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
nTotalAtr := 0
dbSelectArea("MAR")
If !MAR->(Eof())
	nTotalAtr := MAR->E1_saldo
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio e-mail Diretoria    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aResDir) > 0)
	nLin := 1 ; nTotDir1 := 0 
	aResDir := aSort(aResDir,,,{ |x,y| dtos(x[4])<dtos(y[4]) })
	cHTMLModelo	:= "\workflow\wfdiratr.htm"
	cSubject	:= "WORKFLOW:Titulos em Atraso por Cliente | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)
	While (nLin <= Len(aResDir))
	   AAdd( oProcess:oHtml:ValByName("Item.cli")		, aResDir[nLin,1] )
   	AAdd( oProcess:oHtml:ValByName("Item.desc")		, aResDir[nLin,2] )
	   AAdd( oProcess:oHtml:ValByName("Item.est")		, aResDir[nLin,3] )
   	AAdd( oProcess:oHtml:ValByName("Item.vencrea") , dtoc(aResDir[nLin,4]) )
   	AAdd( oProcess:oHtml:ValByName("Item.val")		, Transform(aResDir[nLin,5],"@E 999,999,999.99"))
  		nTotDir1 += aResDir[nLin,5]
  		nLin++
	Enddo     
 	AAdd( oProcess:oHtml:ValByName("Item.cli")     , "&nbsp;" )      
	AAdd( oProcess:oHtml:ValByName("Item.desc") 		, "<b>Total</b>" )
	AAdd( oProcess:oHtml:ValByName("Item.est")  		, "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.vencrea") , "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.val")		, "<b>"+Transform(nTotDir1,"@E 999,999,999.99")+"</b>")
 	AAdd( oProcess:oHtml:ValByName("Item.cli")     , "&nbsp;" )      
	AAdd( oProcess:oHtml:ValByName("Item.desc") 		, "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.est")  		, "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.vencrea") , "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.val")		, "&nbsp;" )
 	AAdd( oProcess:oHtml:ValByName("Item.cli")     , "&nbsp;" )      
	AAdd( oProcess:oHtml:ValByName("Item.desc") 		, "<b>Total em Atraso anterior 01/01/2012</b>" )
	AAdd( oProcess:oHtml:ValByName("Item.est")  		, "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.vencrea") , "&nbsp;" )
	AAdd( oProcess:oHtml:ValByName("Item.val")		, "<b>"+Transform(nTotalAtr,"@E 999,999,999.99")+"</b>")
	oProcess:ClientName(cUserName)
	cEmail1 := GetMV("BR_000036") //Email Diretoria
	cEmail1 := u_BXFormatEmail(cEmail1)
	If Empty(cEmail1)
		oProcess:cTo := "charlesm@brascola.com.br"
	Else
		oProcess:cTo := cEmail1
	Endif
	oProcess:cSubject := cSubject
	oProcess:cFromName:= cFromName
	oProcess:Start()
	oProcess:Free()
Endif 

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return