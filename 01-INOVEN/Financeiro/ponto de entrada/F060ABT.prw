#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//DESENVOLVIDO POR INOVEN


User Function F060ABT()

Private cSayHTML := ""
Private dDatFil	:= dDataBase-1
Private dDatFilA:= dDataBase-1

if IsInCallStack("U_UFINA005") .or. IsInCallStack("FINA200")
    Return(.F.)
endif

goAtuWin()

DEFINE FONT oFont NAME "Arial" SIZE 0, -11 //BOLD

//DEFINE MSDIALOG oDlg FROM 00,00 TO 350,700 PIXEL TITLE "Consulta Valores "
DEFINE MSDIALOG oDlg FROM 00,00 TO 540,700 PIXEL TITLE "Consulta Valores "

	oSayData := tSay():New(010,010,{|| "Data:" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
	oGetData := tGet():New(008,035,{|u| if(PCount()>0,dDatFil:=u,dDatFil)}, oDlg,50,9,,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dDatFil')

	oSayData := tSay():New(010,090,{|| "Até" },oDlg,,,,,,.T.,CLR_BLACK,CLR_WHITE,20,9)
	oGetData := tGet():New(008,110,{|u| if(PCount()>0,dDatFilA:=u,dDatFilA)}, oDlg,50,9,,{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dDatFilA')

	oBtnAtu  := tButton():New(008, 220, "Atualizar" , oDlg, { || (goAtuWin(), oFicha:refresh()) },50,12,,,,.T.,,,,,,)
	oBtnFim  := tButton():New(008, 280, "Sair" , oDlg, { || oDlg:End() },50,12,,,,.T.,,,,,,)

	//oScr:= TScrollBox():New(oDlg,5,5,165,345,.T.,.F.,.T.)
	oScr:= TScrollBox():New(oDlg,25,5,230,345,.T.,.F.,.T.)

	nW := ((2640 * len(cSayHTML)) / 14769) / 2

	//@ 5,5 SAY oFicha VAR cSayHTML OF oScr FONT oFont PIXEL SIZE 500,1000 HTML
	//@ 5,5 SAY oFicha VAR cSayHTML OF oScr FONT oFont PIXEL SIZE 500, (nW+20) HTML
	@ 5,5 SAY oFicha VAR cSayHTML OF oScr FONT oFont PIXEL SIZE 500, 400 HTML

ACTIVATE MSDIALOG oDlg CENTERED 


Return(.F.)


Static Function goAtuWin()

cSayHTML := '<table style="font-size:16px;font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;border-collapse: collapse;border-spacing: 0;width: 100%;">'+;
            '<tbody><tr><th colspan="4" style="border: 1px solid #ddd;text-align: left;padding: 8px;background:#6495ED;color:white;">FATURAMENTO</th>'+;
            '<th style="border: 1px solid #ddd;text-align: right;padding: 8px;background:#6495ED;color:white;">Total</th></tr>'

//Obtem o valor do faturamento
If ( Select('QRY') <> 0 )
    QRY->(dbCloseArea())
Endif
BeginSql alias "QRY"
    select e4_forma,sum(d2_total + d2_icmsret + d2_valipi) d2_total from %table:SD2% d2 
    inner join %table:SF2% f2 on f2_filial = d2_filial and f2_serie = d2_serie and f2_doc = d2_doc
    inner join %table:SE4% e4 on e4_codigo = f2_cond 
    where d2.%notDel% and e4.%notDel% and f2.%notDel%
    and d2_emissao between %exp:dtos(dDatFil)% and %exp:dtos(dDatFilA)% 
    and d2_tipo = 'N' and f2_dupl <> ' '
    group by e4_forma 
    order by e4_forma 
EndSql
While !QRY->(eof())
    cSayHTML += '<tr><td colspan="4" style="border: 1px solid #ddd;text-align: left;padding: 8px;">Notas Emitidas - '+QRY->E4_FORMA+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: right;padding: 8px;">'+alltrim(transf(QRY->D2_TOTAL,'@E 999,999,999.99'))+'</td></tr>'
    QRY->(dbSkip())
End

cSayHTML += '<tr><th colspan="5" style="border: 1px solid #ddd;text-align: left;padding: 8px;background:#6495ED;color:white;">FINANCEIRO</th></tr>'+;
            '<tr><th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Banco</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Forma</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Sem Numero</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Com Numero</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Total</th></tr>'

//Obtem os valores financeiros
If ( Select('QRY') <> 0 )
    QRY->(dbCloseArea())
Endif
BeginSql alias "QRY"
    select e1_xforma, e1_portado, e1_agedep, e1_conta, 
    sum(e1_valor) e1_valor,
    sum(case when e1_portado <> ' ' and e1_numbco <> ' ' then e1_valor else 0 end) comnumero,
    sum(case when e1_numbco = ' ' then e1_valor else 0 end) semnumero
    from %table:SE1% e1 
    where e1.%notDel%
    and e1_filial = ' ' 
    and e1_emissao between %exp:dtos(dDatFil)% and %exp:dtos(dDatFilA)%  and e1_tipo not in ('RA ', 'NCC')
    group by e1_xforma, e1_portado, e1_agedep, e1_conta 
    order by e1_xforma, e1_portado, e1_agedep, e1_conta 
EndSql
While !QRY->(eof())
    SA6->(dbSetOrder(1))
    SA6->(msSeek(xFilial('SA6') + QRY->E1_PORTADO + QRY->E1_AGEDEP + QRY->E1_CONTA))
    cSayHTML += '<tr><td style="border: 1px solid #ddd;text-align: left;padding: 8px;">'+Qry->E1_PORTADO+' - '+Alltrim(SA6->A6_NREDUZ)+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: left;padding: 8px;">'+QRY->E1_XFORMA+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: right;padding: 8px;">'+alltrim(transf(QRY->SEMNUMERO,'@E 999,999,999.99'))+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: right;padding: 8px;">'+alltrim(transf(QRY->COMNUMERO,'@E 999,999,999.99'))+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: right;padding: 8px;">'+alltrim(transf(QRY->E1_VALOR,'@E 999,999,999.99'))+'</td></tr>'
    QRY->(dbSkip())
End


cSayHTML += '<tr><th colspan="5" style="border: 1px solid #ddd;text-align: left;padding: 8px;background:#6495ED;color:white;">BORDERÔS</th></tr>'+;
            '<tr><th colspan="2" style="border: 1px solid #ddd;text-align: left;padding: 8px;">Banco</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Forma</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Borderô</th>'+;
            '<th style="border: 1px solid #ddd;text-align: left;padding: 8px;">Total</th></tr>'

//Obtem os valores financeiros - borderô
If ( Select('QRY') <> 0 )
    QRY->(dbCloseArea())
Endif
BeginSql alias "QRY"
    select e1_xforma,e1_portado, e1_agedep, e1_conta, ea_numbor,sum(e1_valor) e1_valor
    from %table:SE1% e1 
	LEFT JOIN %table:SEA% ea on ea_filial = ' ' and ea_filorig = e1_filorig and ea_prefixo = e1_prefixo 
	and ea_num = e1_num and ea_parcela = e1_parcela and ea_tipo = e1_tipo and ea_cart = 'R' and ea.%notDel% 
    where e1.%notDel%
    and e1_filial = ' ' 
    and e1_emissao between %exp:dtos(dDatFil)% and %exp:dtos(dDatFilA)%  and e1_tipo not in ('RA ', 'NCC')
    group by e1_xforma,e1_portado, e1_agedep, e1_conta , ea_numbor
    order by e1_xforma,e1_portado, e1_agedep, e1_conta , ea_numbor
EndSql
While !QRY->(eof())
    SA6->(dbSetOrder(1))
    SA6->(msSeek(xFilial('SA6') + QRY->E1_PORTADO + QRY->E1_AGEDEP + QRY->E1_CONTA))
    cSayHTML += '<tr><td colspan="2" width="30%" style="border: 1px solid #ddd;text-align: left;padding: 8px;">'+Qry->E1_PORTADO+' - '+Alltrim(SA6->A6_NREDUZ)+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: left;padding: 8px;">'+QRY->E1_XFORMA+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: center;padding: 8px;">'+iif(!empty(QRY->EA_NUMBOR),alltrim(QRY->EA_NUMBOR),'-')+'</td>'+;
                '<td style="border: 1px solid #ddd;text-align: right;padding: 8px;">'+alltrim(transf(QRY->E1_VALOR,'@E 999,999,999.99'))+'</td></tr>'
    QRY->(dbSkip())
End

cSayHTML += '</tbody></table>'

Return
