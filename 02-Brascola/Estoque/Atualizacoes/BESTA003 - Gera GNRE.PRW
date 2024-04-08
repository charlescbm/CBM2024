#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA003         AUTOR:                         DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Gera guia GNRE

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BESTA003()



SetPrvt("CPERG,CCOMBO,AITENS,VQETIQ,VCODIGO,VNFISCAL")
SetPrvt("VLOTE,VDESC,VFORNEC,VLOTEFOR,VQUANT,VDTAREC")
SetPrvt("VCONF,VDTAVAL,VSAIR,_CPORTA,_SALIAS,AREGS")


cCombo:="LPT1"
aItens:={"COM1","COM2","LPT1"}
vSair := .f.
nNum:= 0
Aviso:= Space(50)

@ 96,42 TO 323,505 DIALOG oDlg TITLE "Gera E-mail das Notas com ST "
@ 30,20 say "Esta Rotina efetuara a geracao de e-mail gnre "
@ 50,20 say "a partir da nota digitada"
@ 70,20 say "BRASCOLA"
@ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("GERGNRE")
@ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()
@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED


Return
*************************************************************************************
//----------------------> Barra de Processamento
Static function OkProc()
Processa( {|| Rungrgnre() } )
Close(oDlg)
Return

*************************************************************************************
//----------------------> Processamento
Static Function Rungrgnre()

ProcRegua(5)
IncProc()

//--------------> Perguntas

Pergunte("GERGNRE",.F.)

PRIVATE aGNRE 			:= {}
PRIVATE aGNREMail		:= {}     
pRIVATE aItensProd   	:= {}  
PRIVATE lGnre := .F.

cQuery    := "SELECT SF2.F2_FILIAL,SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_FIMP,SF2.F2_ICMSRET,SF2.F2_EMISSAO"
cQuery    += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery    += " WHERE "
cQuery    += " SF2.F2_FILIAL = '"+xFilial("SF2")+"'  and SF2.F2_SERIE = '"+mv_par05+"'"
cQuery    += " AND SF2.F2_EMISSAO  >= '"+dtos(mv_par01)+"' And SF2.F2_EMISSAO  <= '"+DTOS(mv_par02)+"' And "
cQuery    += " SF2.F2_DOC  >= '"+mv_par03+"' And SF2.F2_DOC  <= '"+mv_par04+"' And "
//cQuery    += " SD2.D2_ICMSRET > 0 And SF2.F2_FIMP IN ('S','T') "
cQuery    += " SF2.D_E_L_E_T_ = ' ' "
cQuery    += " ORDER BY SF2.F2_DOC,SF2.F2_SERIE "

If Select("TRAB") > 0
	TRAB->(dbCloseArea())
EndIf

TCQUERY cQuery NEW ALIAS "TRAB"




// **********************************  GNRE  **********************************


DBSELECTAREA("TRAB")
DBGOTOP()


WHILE !TRAB->(EOF())
	
	lGnre := .f.
	
	dbSelectArea("SF2")
	dbSetOrder(1)
	MsSeek(xFilial("SF2")+TRAB->F2_DOC+TRAB->F2_SERIE)
	
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	MsSeek(xFilial("SA1")+TRAB->F2_CLIENTE+TRAB->F2_LOJA)
	
	
	AITENS()
	
	lGnre := .f.
	
	if TRAB->F2_ICMSRET <> 0
	
	  If  SA1->A1_EST <> 'MG'
	     For N1 := 1 To Len (aItensProd)
	       If aItensProd[N1][2] <> 0
	          aAdd(aGnre,{aItensProd[N1][1],aItensProd[N1][2]," "})
	          lGnre := .T.
	       Endif
	    Next
	  ELSE
	     For N1 := 1 To Len (aItensProd)
	        If aItensProd[N1][2] <> 0
	           aAdd(aGnre,{aItensProd[N1][3],aItensProd[N1][2]," "})
	           lGnre := .T.
	       Endif
	     Next
	  Endif
								
	ENDIF
	
	
	//marca se o produto possui Dif.aliq.Rs - (no caso do RS)
	If SA1->A1_EST $ "RS"
	   For N1 := 1 To Len (aItensProd)
	       If aItensProd[N1][4] == "1"
	          aAdd(aGnre,{aItensProd[N1][1],aItensProd[N1][6],aItensProd[N1][4]})
	          lGnre := .T.
	       Endif
	    Next
	Endif
								
	
	IF lGnre
	   xNUM_PED := Posicione("SD2",1,TRAB->F2_FILIAL+TRAB->F2_DOC+TRAB->F2_SERIE,"D2_PEDIDO")
	   xTIPO_CLI:= Posicione("SC5",1,xFilial("SC5")+xNUM_PED,"C5_TIPOCLI")
	   xTIPO_PED:= SC5->C5_TIPO
	   xICMS:= IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM)
								
	   cArqTxt   := U_GNRETXT(xICMS,xTIPO_CLI,xTIPO_PED,aGnre)
								
	   If cArqTxt <> nil .and. File(cArqTxt)
     	  aAdd(aGNREmail, {cArqTxt, RTRIM(SF2->F2_DOC), (TRAB->F2_EMISSAO), IIF(ALLTRIM(SA1->A1_EST) == 'SC',SA1->A1_EST+"  *",SA1->A1_EST), SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+Alltrim(SA1->A1_NREDUZ), TRAB->F2_ICMSRET  } )
	   EndIf
	EndIf
	
		
	TRAB->(DBSKIP())
		
	
ENDDO

  If Len(aGNREMail)>0  // se possuir nfs que geram GNRE envia email.
		cPLin     := Chr(13)+Chr(10)
		cMailDest := AllTrim(GetMV("BR_000021")) //"charlesb@brascola.com.br"
		cTextoMail:= ""
		
		_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
		_cBody += "<html>"
		_cBody += "<head>"
		_cBody += "<title>Documento sem t&iacute;tulo</title>"
		_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
		_cBody += "</head>"
		_cBody += "<body>"
		_cBody += "   <b><font face='Tahoma' size='2'>Foram disponibizados os arquivos com os dados para geração da GNRE referente as nota fiscais relacionadas abaixo:</font></b></td>"
		_cBody += "   <b><font face='Tahoma' size='2'> "+cPLin+" </font></b></td>"
		_cBody += "<table border='1' cellspacing='1' width='100%'>"
		_cBody += "  <TBODY>"
		_cBody += "    <tr>"
		_cBody += "      <td width='35%' align='center' bgcolor='#dfefff'><b><font face='Tahoma' size='2'>Arquivo</font></b></td>"
		_cBody += "      <td width='10%' align='center' bgcolor='#dfefff'><b><font face='Tahoma' size='2'>Nota Fiscal</font></b></td>"
		_cBody += "      <td width='10%' align='center' bgcolor='#dfefff'><b><font face='Tahoma' size='2'>Emissao</font></b></td>"
		_cBody += "      <td width='10%' align='center' bgcolor='#dfefff'><b><font face='Tahoma' size='2'>Estado</font></b></td>"
		_cBody += "      <td width='25%' align='center' bgcolor='#dfefff'><b><font face='Tahoma' size='2'>Cliente</font></b></td>"
		_cBody += "      <td width='10%' align='center' bgcolor='#dfefff'><b><font face='Tahoma' size='2'>Valor Sub.Trib.</font></b></td>"
		
		_cBody += "    </tr>"
		_cBody += "  <tbody>"
		For nI:= 1 to Len(aGNREMail)
			_cBody += "    <tr>"
			_cBody += "      <td width='35%' bgcolor='#ffffff'><font size='2' face='Tahoma'>"+aGNREMail[nI][1]+"</font></td>"
			_cBody += "      <td width='10%' align='center' bgcolor='#ffffff'><font size='2' face='Tahoma'>"+aGNREMail[nI][2]+"</font></td>"
			_cBody += "      <td width='10%' align='center' bgcolor='#ffffff'><font size='2' face='Tahoma'>"+aGNREMail[nI][3]+"</font></td>"
			_cBody += "      <td width='10%' align='center' bgcolor='#ffffff'><font size='2' face='Tahoma'>"+aGNREMail[nI][4]+"</font></td>"
			_cBody += "      <td width='25%' align='left' bgcolor='#ffffff'><font size='2' face='Tahoma'>"+aGNREMail[nI][5]+"</font></td>"
			_cBody += "      <td width='10%' align='right' bgcolor='#ffffff'><font size='2' face='Tahoma'>"+AllTrim(Transform(aGNREMail[nI][6],"@E 999,999,999,999.99"))+"</font></td>"
			_cBody += "    </tr>"
			_cBody += "    </tr>"
		Next
		_cBody += "  </tbody>"
		_cBody += "</table>"
		_cBody += "<body>"
		_cBody += "   <b><font face='Tahoma' size='2'> "+cPLin+" </font></b></td>"
		_cBody += "   <font face='Tahoma' size='2'>"+DtoC(Date())+" - "+Time()+"</font></td>"
		_cBody += "</body>"
		_cBody += "</html>"
		
		cTextoMail:= _cBody
		//	EndIf
		//	  	       Destinatario   Assunto               Texto       Anexos
		U_SendMail(cMailDest    , "Arquivo para GNRE ", cTextoMail, ""    , .f. )
	EndIf
            

STATIC FUNCTION   AITENS() 

dbselectarea("SD2")
DBSETORDER(3)
MsSeek(xFilial("SD2")+TRAB->F2_DOC+TRAB->F2_SERIE+TRAB->F2_CLIENTE)

_DOC := SD2->D2_DOC
_SERIE := SD2->D2_SERIE
_CLIENTE := SD2->D2_CLIENTE

dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+SD2->D2_COD)

WHILE !EOF() .AND. SD2->D2_DOC = _DOC .AND. SD2->D2_SERIE = _SERIE .AND. SD2->D2_CLIENTE = _CLIENTE 

   aAdd(aItensProd,{SD2->D2_COD,;
   SD2->D2_ICMSRET,;
   SB1->B1_GRTRIB,;
   SB1->B1_DIFALRS,;
   SD2->D2_PICM,;
   SD2->D2_TOTAL})          

SD2->(DBSKIP())

END

RETURN
