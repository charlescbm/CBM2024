#INCLUDE "rwmake.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! F200FIM													!
+-------------------+-----------------------------------------------------------+
!Descricao			! O ponto de entrada F200VAR do CNAB a receber sera 		!
!					! executado apos carregar os dados do arquivo de recepcao 	!
!					! bancaria e sera utilizado para alterar os dados recebidos.!
!					+-----------------------------------------------------------+
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 21/06/2021												!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function F200FIM()

    Local pVlrTAC   := 0
    Local pVlrIOF   := 0
    Local pVlrJur   := 0
    Local lContinua := .T.
 
    Private lMsErroAuto     := .F.
    Private nVlrTac     := 0
    Private nVlrIOF     := 0
    Private nVlrJur     := 0
    Private aParam		:= {}


	//Se existiu movimento de transferencia de SIMPLES para DESCONTADA, solicitar taxas
	if Type("cCtrTrf200") <> 'U' .and. cCtrTrf200 == 'S'

        IF PARAMBOX( {	{1,"Vlr unico TAC", pVlrTAC,"@E 999,999,999.99",".T.","","",120,.F.},;
                    {1,"Vlr unico IOF", pVlrIOF,"@E 999,999,999.99",".T.","","",120,.F.},;
                    {1,"Vlr unico Juros", pVlrJur,"@E 999,999,999.99",".T.","","",120,.F.};
                    }, "Informe taxas ref/Transferencias", @aParam,,,,,,,,.F.,.T.)

            nVlrTac  := mv_par01
            nVlrIOF  := mv_par02
            nVlrJur  := mv_par03

            lContinua := .T.

            //Gera movimento bancario das taxas
            if !empty(nVlrTac)
                lMsErroAuto     := .F.
                SA6->(dbSetOrder(1))
                SA6->(msSeek(xFilial('SA6') + cBanco, .T.))
                SED->(dbSetOrder(1))
                SED->(msSeek(xFilial('SED') + padr('4.12.03',tamsx3('ED_CODIGO')[1])))
                cHistor := alltrim(SED->ED_DESCRIC)
                aSE5 := {}
                aAdd( aSE5, {"E5_DATA"    , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_DTDIGIT" , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_DTDISPO" , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_VALOR"   , nVlrTac    , NIL} )
                aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                aAdd( aSE5, {"E5_BANCO"   , SA6->A6_COD    , NIL} )
                aAdd( aSE5, {"E5_AGENCIA" , SA6->A6_AGENCIA  , NIL} )
                aAdd( aSE5, {"E5_CONTA"   , SA6->A6_NUMCON    , NIL} )
                aAdd( aSE5, {"E5_NATUREZ" , '4.12.03' , NIL} )
                aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                If lMsErroAuto
                    MostraErro()
                EndIf

            endif
            if !empty(nVlrIof)
                lMsErroAuto     := .F.
                SA6->(dbSetOrder(1))
                SA6->(msSeek(xFilial('SA6') + cBanco, .T.))
                SED->(dbSetOrder(1))
                SED->(msSeek(xFilial('SED') + padr('4.12.09',tamsx3('ED_CODIGO')[1])))
                cHistor := alltrim(SED->ED_DESCRIC)
                aSE5 := {}
                aAdd( aSE5, {"E5_DATA"    , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_DTDIGIT" , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_DTDISPO" , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_VALOR"   , nVlrIof    , NIL} )
                aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                aAdd( aSE5, {"E5_BANCO"   , SA6->A6_COD    , NIL} )
                aAdd( aSE5, {"E5_AGENCIA" , SA6->A6_AGENCIA  , NIL} )
                aAdd( aSE5, {"E5_CONTA"   , SA6->A6_NUMCON    , NIL} )
                aAdd( aSE5, {"E5_NATUREZ" , '4.12.09' , NIL} )
                aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                If lMsErroAuto
                    MostraErro()
                EndIf

            endif
            if !empty(nVlrJur)
                lMsErroAuto     := .F.
                SA6->(dbSetOrder(1))
                SA6->(msSeek(xFilial('SA6') + cBanco, .T.))
                SED->(dbSetOrder(1))
                SED->(msSeek(xFilial('SED') + padr('4.12.06',tamsx3('ED_CODIGO')[1])))
                cHistor := alltrim(SED->ED_DESCRIC)
                aSE5 := {}
                aAdd( aSE5, {"E5_DATA"    , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_DTDIGIT" , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_DTDISPO" , dDataBase  , NIL} )
                aAdd( aSE5, {"E5_VALOR"   , nVlrJur    , NIL} )
                aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                aAdd( aSE5, {"E5_BANCO"   , SA6->A6_COD    , NIL} )
                aAdd( aSE5, {"E5_AGENCIA" , SA6->A6_AGENCIA  , NIL} )
                aAdd( aSE5, {"E5_CONTA"   , SA6->A6_NUMCON    , NIL} )
                aAdd( aSE5, {"E5_NATUREZ" , '4.12.06' , NIL} )
                aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                If lMsErroAuto
                    MostraErro()
                EndIf

            endif

        else
            lContinua := .F.
        Endif

	endif


Return
