#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ?MT410ACE ºAutor  ?IR			     ?Data ? 		      º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Valida alteração de pedido de venda                   	  º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                          º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
*/
//DESENVOLVIDO POR INOVEN

User Function MT410ACE()

Local lRet := .T.
Local aDadosUsu := {}
Local cGrpAprv := GetMv("FS_GRPGPED",,"000000")
Local nOpc  := PARAMIXB [1] 

If nOpc == 4 .and. !Empty(SC5->C5_XPEDPGT)
	MsgAlert(OemToAnsi('Em caso de alteração, ser?necessario reenviar o Link de Pgto!!'))
EndIf

If Type("l410Auto") <> "U" 
	If !l410Auto
	    If  ALTERA .AND. !EMPTY(SC5->C5_LIBEROK)
			//If fValProg(SC5->C5_NUM,SC5->C5_FILIAL) .AND. !EMPTY(SC5->C5_LIBEROK)
				//--Avalia se pedido est?na fila de transferencia de saldo
				lRet := .F.
			  	aDadosUsu := U_FSLogin("<b>Ser?necessário solicitar</n>aprovação do gerente para acesso a esta rotina.</b>", .F.)
				If(aDadosUsu != Nil)//Achou o usuário
					If (aDadosUsu[1] == .F. .or. !(aDadosUsu[3]$ cGrpAprv))  //Se o usuário for valido ainda dever?estar dentro do grupo de aprovadores
						Alert("O usuário ?inválido ou não pertence ao grupo de gerentes!!!")
					Else
						lRet := .T.
					EndIf	
				EndIF
			//EndIf
		EndIf
	EndIf
EndIf

Return(lRet)

//-- Valida se pedido j?foi programado e não permite fazer nova liberação.
Static Function fValProg(cPedido,cFilZ05)

Local cQuery := ""

cQuery := " SELECT 1 "
cQuery += " FROM "+RetSqlName("Z05")+" Z05 "
cQuery += " WHERE Z05_PEDIDO = '"+cPedido+"'"
cQuery += " AND Z05_FILIAL = '"+cFilZ05+"'"
cQuery += " AND Z05_STATUS = '000006' "
cQuery += " AND D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
If !Eof()
	Return(.T.)
EndIf

Return(.F.)

//______________________________________________________________________________________________________________________________________             
/*/{Protheus.doc} FSLogin

Tela de Autenticação do usuário
                               
@param cHelp	texto html que ser?exibido no caption da janela
@Return aDadoUsu := {aprovado,userBlock,cCodUsr,cName,aGrupos, cMotivo }

@author  Waldir de Oliveira
@since   14/10/2011
/*/
//______________________________________________________________________________________________________________________________________     
User Function FSLogin(cHelp, lMotivo)
Local oDlg		:= Nil
Local oSayUser	:= Nil
Local oGetUsr	:= Nil
Local oSayPass	:= Nil
Local oGetPss	:= Nil
Local oSayHelp	:= Nil  
Local oBtnOk	:= Nil
Local oBtnEsc	:= Nil   

Local lOk		:= .F.
Local aDadLog	:= {}  
Local cMotivo   := Space(200)

Local cUsrLogin := Space(30)
Local cUsrPss	:= Space(30)   
Local nAltura 	:= 160
Local nLargura	:= 310  
Local lPosBut	:= 60
Default lMotivo := .F.

If(lMotivo)
	nAltura := 260
	nLargura:= 410
	lPosBut := 115
EndIf

oDlg := MSDialog():New(0,0,nAltura,nLargura,'Autenticação do Usuário',,,,,CLR_BLACK,CLR_WHITE,,,.T.)      

oSayHelp:= TSay():New(02,05,{||cHelp},oDlg,,,,,,.T.,,,200,25,,,,,,.T.)

oSayUser:= TSay():New(30,05,{|| 'Usuário'},oDlg,,,,,,.T.,,,200,20,,,,,,.T.)
oGetUsr := TGet():New(30,30,{|u| If(PCount() > 0, cUsrLogin := u, cUsrLogin  ) },oDlg,096,009,"",{|| .T. },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cUsrLogin,,,, )

oSayPass:= TSay():New(45,05,{|| 'Senha'},oDlg,,,,,,.T.,,,200,20,,,,,,.T.)
oGetPss := TGet():New(45,30,{|u| If(PCount() > 0, cUsrPss := u,cUsrPss  ) },oDlg,096,009,"",{|| .T. },0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.T./*PassWord*/,,cUsrPss,,,, )

If(lMotivo)                               
	oSayMot:= TSay():New(60,05,{|| 'Motivo'},oDlg,,,,,,.T.,,,300,20,,,,,,.T.)
  	@ 70,05 GET oMemo VAR cMotivo MEMO SIZE 190,40  OF oDlg PIXEL
EndIf
                                                                                                 

oBtnOk	:= TButton():New( lPosBut, 40, "OK",oDlg,{|| lOk := .T., oDlg:End() },40,       12,,,.T.,.T.,.T.,,.F.,,,.F. )
oBtnEsc	:= TButton():New( lPosBut, 86, "Cancelar",oDlg,{|| lOk := .F. , oDlg:End() },40,12,,,.T.,.T.,.T.,,.F.,,,.F. )

oDlg:Activate(,,,.T.,{|| aDadLog := U_FSUsrPas(cUsrLogin, cUsrPss, lOk,cMotivo,lMotivo ), lOk == .F. .Or. aDadLog != Nil },,{|| "Iniciando" } )

Return aDadLog                                

//-- Valida usuário e senha.
User Function FSUsrPas(cUsr,cPass,lMens,cMotivo,lMotivo)
Local aAreas	:= {GetArea()}
Local lAprv		:= .F.     
Local aGrupos	:= {}
Local cName		:= ""    
Local cCodUsr	:= ""
Local lBlock	:= .F.
Local aDadoUsu	:= Nil                 

Default lMens  := .T.
Default lMotivo := .F.      
Default cMotivo := ""
        
If(lMotivo == .T. .And. Empty(cMotivo) ) 
	Alert("O motivo ?obrigatório")
	Return aDadoUsu
EndIf

If(! lMens )
	Return aDadoUsu
EndIf

cUser := AllTrim(cUsr)

PswOrder(2) //Buscar pelo Login
If ( PswSeek(cUser, .T.) )
	aInfo		:= PswRet(1) //Buscando as informações do usuário
	cCodUsr		:= aInfo[1][1] //Código do Usuário 
	aGrupos		:= aInfo[1][10]//Grupo do usuário
	cName		:= aInfo[1][4] //Nome do Usuário
	lBlock		:= aInfo[1][17]//Usuário bloqueado

	PswOrder(1) //Buscar pelo Login
	PswSeek(cCodUsr, .T.)

	lAprv		:= pswName(cPass) .And. !lBlock //Ter?que ter senha válida e não não poder?est?bloqueado
	aDadoUsu 	:= {lAprv,lBlock,cCodUsr,cName,aGrupos,cMotivo  }
Else
	If(lMens)
		MsgStop("Usuário ou senha inválidos, ou usuário est?bloqueado","Erro")
	EndIf
EndIf
AEval(aAreas,{|x| restArea(x) })	
Return aDadoUsu
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FsVldPSZ3
Função valida existencia de pedido na fila para transferencia de saldo

@author		[Rodolfo] [.iNi Sistemas]
@since     	04/10/17
@version  	P.12              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FsVldPSZ3()

	Local cQuery	:= ''
	Local aSZ3		:= GetNextAlias()
	Local cCodId	:= ''
	
	cQuery+=Chr(13)+Chr(10)+"SELECT TOP 1 Z3_IDPROC " 
	cQuery+=Chr(13)+Chr(10)+"FROM "+RetSqlName('SZ3')+" "
	cQuery+=Chr(13)+Chr(10)+"WHERE Z3_NUMPED = '"+SC5->C5_NUM+"' "
	cQuery+=Chr(13)+Chr(10)+"AND Z3_FILIAL   = '"+SC5->C5_FILIAL+"' 
	//cQuery+=Chr(13)+Chr(10)+"AND Z3_STATUS   IN ('I','T') "
	cQuery+=Chr(13)+Chr(10)+"AND D_E_L_E_T_  = '' "
	cQuery+=Chr(13)+Chr(10)+"ORDER BY Z3_IDPROC DESC "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),aSZ3,.F.,.T.)

	(aSZ3)->(DbGoTop())
	If (aSZ3)->(!Eof())	
		cCodId:= (aSZ3)->Z3_IDPROC
	EndIf	  
	//--Fecha tabela temporaria
	(aSZ3)->(DbCloseArea())

Return(IIF(!Empty(cCodId),.T.,.F.))
