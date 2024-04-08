#Include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CARTEIRA  º Autor ³ AP6 IDE            º Data ³  22/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function previsao()

Local cVldAlt	  := ".T." 
Local cVldExc 	  := ".T." 
Private cCadastro := "Cadastramento de Previsao"
Private aRotina   := {}
Private _filial   :=xfilial("SB3")


Aadd(aRotina,{"Visualizar"      ,"AxVisual"          ,0,2})
Aadd(aRotina,{"Incluir"         ,"AxInclui"          ,0,3})
Aadd(aRotina,{"Alterar"         ,"AxAltera"          ,0,4})
Aadd(aRotina,{"Excluir"         ,"AxDeleta"          ,0,5})
Aadd(aRotina,{"Relatório"       ,"U_Prev(_filial)  "          ,0,6})

MBrowse(100,001,300,400,"SHC")

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³xCARTEIRA º Autor ³ AP6 IDE            º Data ³  22/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ 															  º±±
±±º          ³ 															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Prev()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Previsao de Consumo"
Local cPict          := ""
Local titulo  	     := "Previsao de Consumo"
Local nLin     	     := 80
Local Cabec1 		 := ""
Local Cabec2         := ""
Local imprime     	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "Prevcon"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CriaPerg("PREVCO")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "PREVCON"
Private cString      := ""
Private aRetorno     := {}
Private aRegs := {}


Aadd(aRegs,{cPerg,"01","Data da Prev de        ?","Da Data da Baixa ?","Da Data da Baixa ?","mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"02","Ate a Data de Previsao ?","Ate a Data de Previsao ?","Ate a Data da Baixa ?","mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"03","Codigo do Produto de   ?","Codigo do Produto de ?","Codigo de Produto de ?","mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
Aadd(aRegs,{cPerg,"04","Codigo do Produto ate  ?","Codigo do Produto ate ?","Codigo de Produto ate ?","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })

/*
Aadd( aRegs, { cPerg,"02","Do Vendedor ?","Do Vendedor ?","Do Vendedor ?","mv_ch2","C",6,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","" })
Aadd( aRegs, { cPerg,"03","Ate o Vendedor ?","Ate o Vendedor ?","Ate o Vendedor ?","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","" })
Aadd( aRegs, { cPerg,"04","Lista de Vendedor ?","Lista de Vendedor ?","Lista de Vendedor ?","mv_ch4","C",60,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
*/

lValidPerg( aRegs )

if Pergunte( cPerg, .T. )
	MsgRun( 'Executando Consulta', 'Aguarde...', {|| prev1() } )
endif

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  22/12/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function prev1

Local nOrdem
Local cMsg := " "
Local cAlias := 'TMPSR'

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Procedure ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	 ddata1:="'"+DTOS(MV_PAR01)+"'"
	 ddata2:="'"+DTOS(MV_PAR02)+"'"
	 prod1 :="'"+MV_PAR03+"'"
	 prod2 :="'"+MV_PAR04+"'"
  	 
  	 if _filial  == '01'
  	    TCSPExec( 'SP_BRESTRU',&ddata1,&ddata2,&prod1,&prod2)
  	 //ELSEIF _filial == '01'
  	 //   TCSPExec( 'SP_ESTRUSBC',&ddata1,&ddata2,&prod1,&prod2)
  	 ENDIF
  	 
  	 
  	 //TCSPExec( XPROCEDURES('SP_BRESTRU'), '20081101','20081231','0344604','0344604')
  	 //TCSPExec( 'SP_BRESTRU', '20081020','20081020','0604420','0604420')
   //	 DTOS(MV_PAR01),DTOS(MV_PAR02),MV_PAR03,MV_PAR04 )   				    
  // TCSQLEXEC('SP_BRESTRU', @IN_DATINI='20081101',@IN_DATFIM='20081231',@IN_PRDINI='0344604',@IN_PRDFIM='0344604')
  //  TCSQLExec( 'CART1 '+DTOS(MV_PAR02) )   
  //    TCSQLExec( ('SP_BRESTRU ') +DTOS(MV_PAR01) ) 
  //  TCSPExec( xProcedures('A330INI'), cxFilial, Dtos(dINICIO),"@@",;
  //		GetMv("MV_LOCPROC"), cFilAnt,;
  //		Substr(cUsuario,7,15), DTOS(dDataBase))


	
	Begin Sequence
       cQuery := " SELECT CODIGO,DESCRICAO,QTDPA,UM,TIPO,CONSUMO,NECESS,ESTOQUE,SALDO FROM ( "
       cQuery += "    SELECT HC_PRODUTO AS CODIGO,HC_QUANT AS QTDPA,SB1010.B1_DESC DESCRICAO,SB1010.B1_UM UM,SB1010.B1_TIPO TIPO,ISNULL(SB3010.B3_MEDIA,0) CONSUMO,'' NECESS,'' ESTOQUE ,'' SALDO FROM SHC010 "
       cQuery += "    INNER JOIN SB1010  ON SB1010.B1_COD = HC_PRODUTO AND SB1010.D_E_L_E_T_ = '' " 
       cQuery += "    LEFT JOIN SB3010  ON SB3010.B3_COD = HC_PRODUTO AND SB3010.D_E_L_E_T_ = '' AND SB3010.B3_FILIAL = '"+_filial+"'" 
       cQuery += "    WHERE HC_PRODUTO   BETWEEN '"+Mv_Par03+"' AND '"+Mv_Par04+"' "
   	   cQuery += "    AND HC_DATA      BETWEEN '"+DtoS(Mv_Par01)+"' AND '"+DtoS(Mv_Par02)+"' AND SHC010.D_E_L_E_T_ = '')AG"
   	   cQuery += "    UNION ALL "

       cQuery +=  " SELECT G1_COMP AS CODIGO,DESCOMP AS DESCRICAO,0 QTDPA ,UM,TIPO,ISNULL(CONSUMO,0)CONSUMO,NECESS,ISNULL(ESTOQUE,0) ESTOQUE,ESTOQUE - NECESS AS SALDO FROM ( "
       cQuery +=  " SELECT TMPESTRUAB.G1_COMP,DESCOMP,SB1010.B1_UM AS UM,SB1010.B1_TIPO AS TIPO,SB3010.B3_MEDIA AS CONSUMO,SUM(G1_TOTPROD) AS NECESS,B2_QATU AS ESTOQUE "
       cQuery +=  " FROM  TMPESTRUAB " 
       cQuery +=  " FULL OUTER JOIN TMPEST "
       cQuery +=  " ON G1_COMP = B2_COD "
       cQuery +=  " INNER JOIN SB1010 ON B1_COD = G1_COMP AND SB1010.D_E_L_E_T_ = '' "
       cQuery +=  " LEFT JOIN SB3010 ON B3_COD = G1_COMP AND SB3010.B3_FILIAL = '"+_filial+"'  AND  SB3010.D_E_L_E_T_ = '' "   //'"+xFilial("SB3")+"'
       cQuery +=  " WHERE ( " 
       cQuery +=  " ((G1_REVFIM >= REVPA AND G1_REVINI <= REVPA) AND REVCOMP  = ''  ) OR ((G1_REVFIM >= REVCOMP AND G1_REVINI <= REVCOMP) AND REVCOMP <> '' AND SB1010.B1_TIPO <> 'PI') "
       cQuery +=  " OR " 
       cQuery +=  "((G1_REVFIM >= REVPA AND G1_REVINI <= REVPA) AND REVCOMP  <> '' AND SB1010.B1_TIPO = 'PI' )
       cQuery +=  " )
       
       cQuery +=  " GROUP BY G1_COMP,DESCOMP,SB1010.B1_UM,SB1010.B1_TIPO,SB3010.B3_MEDIA,B2_QATU) AGRUPA1 "
       
     	cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T.,'TOPCONN', TCGenQry(,,cQuery), 'TMPSR',.T.,.T.)}, "Selecionando Registros ...")	
 	
 	    tCSetField( cAlias, 'NECESS'		, 'N', TamSx3('D2_QUANT')[1],	TamSx3('D2_QUANT')[2] )
 	    tCSetField( cAlias, 'ESTOQUE'		, 'N', TamSx3('D2_QUANT')[1],	TamSx3('D2_QUANT')[2] )
 	    //tCSetField( cAlias, 'SALDO'		    , 'N', TamSx3('D2_QUANT')[1],	TamSx3('D2_QUANT')[2] )
 	    tCSetField( cAlias, 'SALDO'		    , 'N', 14,	2 )
 
	    TMPSR->(DBGOTOP())


      //tCSetField( cAlias, 'VALOR'		, 'N', TamSx3('C6_PRCVEN')[1],	TamSx3('C6_PRCVEN')[2] )
      //tcSetField( cAlias, 'ENTREGA'	, 'D', 8, 0 )
     //tcSetField( cAlias, 'FATURADO'	, 'D', 8, 0 )

      u_PROCEXCEL( cAlias ) 

     (cAlias)->( dbCloseArea() ) 

//	TCSQLExec('DROP TABLE TMPESTRUAB')
//	TCSQLExec('DROP TABLE TMPEST')
	
	End Sequence		
	
//	TCSQLExec('DROP TABLE TMPESTRUAB')
//	TCSQLExec('DROP TABLE TMPEST')

    DbCloseArea("TMPSR")	             
    DbCloseArea("SHC")	             

Return

