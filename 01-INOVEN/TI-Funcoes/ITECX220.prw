#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX220													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Envio relacao de Clientes         				 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 22/03/2022												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX220( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SA1","SA3"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Relacao de Clientes sem Comprar - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
ITECX220W(.T.)

FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Relacao de Semaforo de Clientes - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
ITECX221W(.T.)

RpcClearEnv()

Return

Static Function ITECX220W( lAuto )

Local dDataPro := dDataBase

If File("\workflow\clientes_sem_comprar.htm")

    If (Select("QRYCLI") <> 0)
        QRYCLI->(dbCloseArea())
    Endif
    BEGINSQL ALIAS "QRYCLI"
        column A1_DTCAD as Date, A1_PRICOM as Date, A1_ULTCOM as Date
        SELECT A1_ULTCOM, A1_VEND, A3_NOME, A3_SUPER, A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_EST, A1_MUN, A1_DTCAD, A1_PRICOM,
        A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL
        FROM %table:SA1% A1 
        INNER JOIN %table:SA3% A3 ON A1_VEND = A3_COD
        WHERE A1.%notdel% AND A3.%notdel%
        AND A1_MSBLQL <> '1' AND A1_ULTCOM = ' '
        AND A3_SUPER != ' '
        ORDER BY A3_SUPER, A1_VEND, A1_NOME
    ENDSQL
//        and a3_super = '000004'

//    ncont := 0

    cSuper := ''
    QRYCLI->(dbGotop())
    While !QRYCLI->(eof())

        SA3->(dbSetOrder(1))
        SA3->(msSeek(xFilial('SA3') + QRYCLI->A3_SUPER))
        if empty(SA3->A3_EMAIL)
            QRYCLI->(dbSkip())
            Loop
        endif

        cSuper := QRYCLI->A3_SUPER
        cVend := ''
        While !QRYCLI->(eof()) .and. cSuper == QRYCLI->A3_SUPER

            oProcess := TWFProcess():New("000010", OemToAnsi("Clientes sem Comprar"))
            oProcess:NewTask("000001", "\workflow\clientes_sem_comprar.htm")
            
            oProcess:cSubject 	:= "Clientes sem Comprar - processado em " + dtoc(dDataPro)
            oProcess:bTimeOut	:= {}
            oProcess:fDesc 		:= "Clientes sem Comprar - processado em " + dtoc(dDataPro)
            oProcess:ClientName(cUserName)
            oHTML := oProcess:oHTML

    		oHTML:ValByName('dtbase', dDataPro)

            //ncont++

            cVend := QRYCLI->A1_VEND
            While !QRYCLI->(eof()) .and. cSuper == QRYCLI->A3_SUPER .and. cVend == QRYCLI->A1_VEND
        
                /*
                AAdd(oProcess:oHtml:ValByName('cli.vend')	, QRYCLI->A3_NOME)
                AAdd(oProcess:oHtml:ValByName('cli.cnpj')	, QRYCLI->A1_CGC)
                AAdd(oProcess:oHtml:ValByName('cli.razao')	, QRYCLI->A1_NOME)
                AAdd(oProcess:oHtml:ValByName('cli.uf')	    , QRYCLI->A1_EST)
                AAdd(oProcess:oHtml:ValByName('cli.mun')	, QRYCLI->A1_MUN)
                AAdd(oProcess:oHtml:ValByName('cli.dtcad')	, dtoc(QRYCLI->A1_DTCAD))
                AAdd(oProcess:oHtml:ValByName('cli.compra')	, dtoc(QRYCLI->A1_PRICOM))
                AAdd(oProcess:oHtml:ValByName('cli.ultcom')	, dtoc(QRYCLI->A1_ULTCOM))
                AAdd(oProcess:oHtml:ValByName('cli.ddd')	, QRYCLI->A1_DDD)
                AAdd(oProcess:oHtml:ValByName('cli.fone')	, QRYCLI->A1_TEL)
                AAdd(oProcess:oHtml:ValByName('cli.contato'), QRYCLI->A1_CONTATO)
                AAdd(oProcess:oHtml:ValByName('cli.email')	, QRYCLI->A1_EMAIL)
                */
                cBody := '<td align="center" style="border: 1px solid #002544; border-top: 0;">'
                cBody += '<img border="0" src="http://inovencomercio122019.protheus.cloudtotvs.com.br:4040/ws9901/images/star_black.png"></td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A3_NOME+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_CGC+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_NOME+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_EST+'</td>'
                cBody += '<td style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_MUN+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYCLI->A1_DTCAD)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYCLI->A1_PRICOM)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYCLI->A1_ULTCOM)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_DDD+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_TEL+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_CONTATO+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_EMAIL+'</td>'
                //cBody += '</tr>'

                AAdd(oProcess:oHtml:ValByName('cli.tlinha')	, cBody)

                SA1->(dbSetOrder(1))
                if SA1->(msSeek(xFilial('SA1') + QRYCLI->A1_COD + QRYCLI->A1_LOJA))
                    SA1->(recLock('SA1', .F.))
                    SA1->A1_ZSEMAF := 'B'
                    SA1->(msUnlock())
                endif

                QRYCLI->(dbSkip())
            End

            oProcess:cTo := SA3->A3_EMAIL
            //oProcess:cTo := "crelec@gmail.com"
            //oProcess:cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
                    
            // Inicia o processo
            oProcess:Start()
            // Finaliza o processo
            oProcess:Finish()					

            //if ncont == 3
            //    exit				
            //endif

        End

    End

endif

Return


Static Function ITECX221W( lAuto )

Local dDataPro := dDataBase

If File("\workflow\clientes_semaforo.htm")

    If (Select("QRYCLI") <> 0)
        QRYCLI->(dbCloseArea())
    Endif
    BEGINSQL ALIAS "QRYCLI"
        column A1_DTCAD as Date, A1_PRICOM as Date, A1_ULTCOM as Date
        SELECT 
        CASE 
            WHEN A1_ULTCOM >= CONVERT(NCHAR(8),GETDATE()-55,112) THEN 'DZ' 
            WHEN A1_ULTCOM >= CONVERT(NCHAR(8),GETDATE()-112,112) AND A1_ULTCOM <= CONVERT(NCHAR(8),GETDATE()-60,112) THEN 'D5' 
            WHEN A1_ULTCOM < CONVERT(NCHAR(8),GETDATE()-120,112) THEN 'D0' 
        END SEMCOMP, 
        A1_ULTCOM, A1_VEND, A3_NOME, A3_SUPER, A1_COD, A1_LOJA, A1_NOME, A1_CGC, A1_EST, A1_MUN, A1_DTCAD, A1_PRICOM,
        A1_DDD, A1_TEL, A1_CONTATO, A1_EMAIL
        FROM %table:SA1% A1 
        INNER JOIN %table:SA3% A3 ON A1_VEND = A3_COD
        WHERE A1.%notdel% AND A3.%notdel%
        AND A1_MSBLQL <> '1' AND A3_SUPER != ' '
        AND A1_ULTCOM != ' '
        ORDER BY A3_SUPER, A1_VEND, SEMCOMP, A1_NOME
    ENDSQL
//        and a3_super = '000004'

//    ncont := 0

    cSuper := ''
    QRYCLI->(dbGotop())
    While !QRYCLI->(eof())

        if empty(QRYCLI->SEMCOMP)
            QRYCLI->(dbSkip())
            Loop
        endif

        SA3->(dbSetOrder(1))
        SA3->(msSeek(xFilial('SA3') + QRYCLI->A3_SUPER))
        if empty(SA3->A3_EMAIL)
            QRYCLI->(dbSkip())
            Loop
        endif

        cSuper := QRYCLI->A3_SUPER
        cVend := ''
        While !QRYCLI->(eof()) .and. cSuper == QRYCLI->A3_SUPER

            if empty(QRYCLI->SEMCOMP)
                QRYCLI->(dbSkip())
                Loop
            endif

            oProcess := TWFProcess():New("000010", OemToAnsi("Semaforo de Clientes"))
            oProcess:NewTask("000001", "\workflow\clientes_semaforo.htm")
            
            oProcess:cSubject 	:= "Semaforo de Clientes - processado em " + dtoc(dDataPro)
            oProcess:bTimeOut	:= {}
            oProcess:fDesc 		:= "Semaforo de Clientes - processado em " + dtoc(dDataPro)
            oProcess:ClientName(cUserName)
            oHTML := oProcess:oHTML

    		oHTML:ValByName('dtbase', dDataPro)

            //ncont++

            cVend := QRYCLI->A1_VEND
            While !QRYCLI->(eof()) .and. cSuper == QRYCLI->A3_SUPER .and. cVend == QRYCLI->A1_VEND
        
                if empty(QRYCLI->SEMCOMP)
                    QRYCLI->(dbSkip())
                    Loop
                endif

                //Titulos em atraso
                If (Select("QRYTIT") <> 0)
                    QRYTIT->(dbCloseArea())
                Endif
                BEGINSQL ALIAS "QRYTIT"
                    column E1_VENCTO as Date
                    SELECT MAX(SE1.E1_VENCTO) AS E1_VENCTO
                    FROM %table:SE1% SE1 
                    WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = %exp:SubStr(xFilial("SE1"),1,2)% 
                    AND   SE1.E1_CLIENTE = %exp:QRYCLI->A1_COD% 
                    AND   SE1.E1_LOJA    = %exp:QRYCLI->A1_LOJA% 
                    AND   SE1.E1_SALDO   > 0 
                    AND   SE1.E1_VENCTO  <= %exp:DTOS(DataValida(dDatabase, .T.) - SUPERGETMV("FS_DIASRET" , .T., 2,))% 
                    AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) 
                    AND   SE1.%notdel%
                ENDSQL


                /*
                AAdd(oProcess:oHtml:ValByName('cli.vend')	, QRYCLI->A3_NOME)
                AAdd(oProcess:oHtml:ValByName('cli.cnpj')	, QRYCLI->A1_CGC)
                AAdd(oProcess:oHtml:ValByName('cli.razao')	, QRYCLI->A1_NOME)
                AAdd(oProcess:oHtml:ValByName('cli.uf')	    , QRYCLI->A1_EST)
                AAdd(oProcess:oHtml:ValByName('cli.mun')	, QRYCLI->A1_MUN)
                AAdd(oProcess:oHtml:ValByName('cli.dtcad')	, dtoc(QRYCLI->A1_DTCAD))
                AAdd(oProcess:oHtml:ValByName('cli.compra')	, dtoc(QRYCLI->A1_PRICOM))
                AAdd(oProcess:oHtml:ValByName('cli.ultcom')	, dtoc(QRYCLI->A1_ULTCOM))
                AAdd(oProcess:oHtml:ValByName('cli.ddd')	, QRYCLI->A1_DDD)
                AAdd(oProcess:oHtml:ValByName('cli.fone')	, QRYCLI->A1_TEL)
                AAdd(oProcess:oHtml:ValByName('cli.contato'), QRYCLI->A1_CONTATO)
                AAdd(oProcess:oHtml:ValByName('cli.email')	, QRYCLI->A1_EMAIL)
                */
                //cBody := '<tr>'
                cBody := '<td align="center" style="border: 1px solid #002544; border-top: 0;">'
                if QRYCLI->SEMCOMP == 'D0'
                    cBody += '<img border="0" src="http://inovencomercio122019.protheus.cloudtotvs.com.br:4040/ws9901/images/star_red.png"></td>'
                elseif QRYCLI->SEMCOMP == 'D5'
                    cBody += '<img border="0" src="http://inovencomercio122019.protheus.cloudtotvs.com.br:4040/ws9901/images/star_yellow.png"></td>'
                elseif QRYCLI->SEMCOMP == 'DZ'
                    cBody += '<img border="0" src="http://inovencomercio122019.protheus.cloudtotvs.com.br:4040/ws9901/images/star_green.png"></td>'
                endif
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A3_NOME+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_CGC+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_NOME+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_EST+'</td>'
                cBody += '<td style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_MUN+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYCLI->A1_DTCAD)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYCLI->A1_PRICOM)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYCLI->A1_ULTCOM)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+dtoc(QRYTIT->E1_VENCTO)+'</td>'
                cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_DDD+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_TEL+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_CONTATO+'</td>'
                cBody += '<td align="left" style="border: 1px solid #002544; border-top: 0; border-left: 0;">'+QRYCLI->A1_EMAIL+'</td>'
                //cBody += '</tr>'

                AAdd(oProcess:oHtml:ValByName('cli.tlinha')	, cBody)

                SA1->(dbSetOrder(1))
                if SA1->(msSeek(xFilial('SA1') + QRYCLI->A1_COD + QRYCLI->A1_LOJA))
                    SA1->(recLock('SA1', .F.))
                    if QRYCLI->SEMCOMP == 'D0'  //RED
                        SA1->A1_ZSEMAF := 'R'
                    elseif QRYCLI->SEMCOMP == 'D5'  //YELLOW
                        SA1->A1_ZSEMAF := 'Y'
                    elseif QRYCLI->SEMCOMP == 'DZ'  //GREEN
                        SA1->A1_ZSEMAF := 'G'
                    endif
                    SA1->(msUnlock())
                endif

                QRYTIT->(dbCloseArea())

                QRYCLI->(dbSkip())
            End

            oProcess:cTo := SA3->A3_EMAIL
            //oProcess:cTo := "crelec@gmail.com"
            //oProcess:cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
                    
            // Inicia o processo
            oProcess:Start()
            // Finaliza o processo
            oProcess:Finish()	

            //if ncont == 3
            //    exit				
            //endif

        End

    End

endif

Return
