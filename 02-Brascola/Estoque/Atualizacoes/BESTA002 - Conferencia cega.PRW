#INCLUDE "RWMAKE.CH"          

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA002         AUTOR:                         DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Conferencia cega de produtos.


----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BESTA002()

	Private aRotina,cCadastro,aRecCols,aCores,aHeader,aCpoEnchoice,aAltEnchoice,cOpcao

	cCadastro := "Geracao de Relatorio Para Conferencia Cega"

	// Matriz de definição dos menus
	aRotina := {}
	Aadd(aRotina,{"Pesquisar"   ,"AxPesqui"       ,0,1})
	Aadd(aRotina,{"Visualizar"  ,"U_Mod3Visual"   ,0,2})
	Aadd(aRotina,{"Incluir"     ,"U_Mod3Incluir"  ,0,3})
	Aadd(aRotina,{"Alterar"     ,"U_Mod3Alterar"  ,0,4})
	Aadd(aRotina,{"Excluir"     ,"U_Mod3Excluir"  ,0,5})
	Aadd(aRotina,{"Imprimir"    ,"U_Mod3Imprimir" ,0,6})

	// Matriz de definição de cores da legenda
	// Matriz de definição de cores da legenda
	aCores := {}
	Aadd(aCores,{"SZD_OK=='2'" ,'ENABLE' })
	Aadd(aCores,{"SZD_OK=='1'" ,'DISABLE'})

    mBrowse( 15, 1,22,75,"SZC",,,,,,) // Cria o browse

Return(NIL)     


//Visualizar**********************************************************************************************
User Function Mod3Visual()
    Private aRecCols := {}  // Registros atuais dos Itens
	Private aCols    := {}

	cOpcao:="VISUALIZAR"
	nOpcE:=nOpcG:=2

	dbSelectArea("SZC")
	RegToMemory("SZC",(cOpcao=="INCLUIR"))

	U_LoadCpo()
	U_LoadRecs()
	U_OpenMod3()		
Return nil
//********************************************************************************************************
      

//Imprimir**********************************************************************************************
User Function Mod3Imprimir()
	U_AVISOIMP()
Return nil
//********************************************************************************************************       

    
//Incluir**********************************************************************************************
User Function Mod3Incluir()
	cOpcao:="INCLUIR"   
	nOpcE:=nOpcG:=3

	dbSelectArea("SZC")
	RegToMemory("SZC",(cOpcao=="INCLUIR"))

   	U_LoadCpo()

	//Cria aCols em Branco
	aCols:={Array(Len(aHeader)+1)}
	aCols[1,Len(aHeader)+1]:=.F.
	For _ni:=1 to Len(aHeader)
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next                                         
   	aRecCols := {}  // Registros atuais dos Itens

   	U_OpenMod3()		
Return nil
//********************************************************************************************************                    
                           

//Alterar*************************************************************************************************
User Function Mod3Alterar()
    Private aRecCols := {}  // Registros atuais dos Itens
	Private aCols    := {}
	cOpcao:="ALTERAR"    
	nOpcE:=nOpcG:=4

	dbSelectArea("SZC")
	RegToMemory("SZC",(cOpcao=="INCLUIR"))

	U_LoadCpo()
	U_LoadRecs()
	U_OpenMod3()		
Return nil
//********************************************************************************************************                          


//Excluir*************************************************************************************************
User Function Mod3Excluir()
    Private aRecCols := {}  // Registros atuais dos Itens
	Private aCols    := {}
	cOpcao:="EXCLUIR"   
	nOpcE:=nOpcG:=5

	dbSelectArea("SZC")
	RegToMemory("SZC",(cOpcao=="INCLUIR"))

	U_LoadCpo()
	U_LoadRecs()
	U_OpenMod3()		
Return nil            
//********************************************************************************************************  

      

//Encerrar*************************************************************************************************
User Function Mod3Encerrar()
    Private aRecCols := {}  // Registros atuais dos Itens
	Private aCols    := {}
	cOpcao:="ENCERRAR"   
	nOpcE:=nOpcG:=2 

	dbSelectArea("SZC")
	RegToMemory("SZC",(cOpcao=="INCLUIR"))

	U_LoadCpo()
	U_LoadRecs()
	U_OpenMod3()		
Return nil    
//******************************************************************************************************** 

                                
//Abrir***************************************************************************************************
User Function OpenMod3()
	// Pega numero sequencial
//	if cOpcao == "INCLUIR"
//		M->SZC_COD := GetSx8Num("SZC","SZC_COD")
//	endif

	cLinOk  :="U_Mod3LinhaOk()"
	cTudOk  :="U_Mod3TudoOk()"
	cFieldOk:="AllwaysTrue()"
	_lRet:=Modelo3(cCadastro,"SZC","SZD",aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.T.,,aAltEnchoice)
	If _lRet
//		ConfirmSx8()
		fSS_Salvar()
	Else
		RollBackSX8()
	Endif
Return NIL
//*********************************************************************************************************         


// validação dos campos
User Function Mod3TudoOk()
	Local SS_RET:=.T.
// 	if Len(AllTrim(M->ZZB_NCONT1+M->ZZB_NCONT2)) > 0
//		if M->ZZB_NCONT1==M->ZZB_NCONT2
//			Help(" ",1,"Reclamações",,"Os contatos não podem ser iguais",4,1)
//			SS_RET:=.F.
//		endif
//	endif
Return SS_RET

       

// validação de linha de itens
User Function Mod3LinhaOk()
     Local SS_RET
//     nPos1 := ascan(aHeader,{|m| alltrim(m[2]) == "ZZC_CODIGO"})
//     nPosF := Len(aHeader)+1
     SS_RET := .T.   
//     If Empty(aCols[n,nPos1]) .and. !aCols[n,nPosF]
//        SS_RET := .F.
//     EndIf       
Return SS_RET     



// Salva Informações
Static Function fSS_Salvar()
	#IFDEF TOP
		BeginTran()
	#ENDIF   

	// Salva Cabecalho
	DbSelectArea("SZC")
	DbSetOrder(1)
	If cOpcao == "INCLUIR" 
		RecLock("SZC",.T.)
	ElseIF cOpcao == "ALTERAR"
		RecLock("SZC",.F.)
	ElseIF cOpcao == "EXCLUIR" 
		RecLock("SZC",.F.)
		Delete
	EndIf          
                

	IF cOpcao <> "VISUALIZAR" .AND. cOpcao <> "ENCERRAR"
		SZC->ZC_FILIAL  := xFilial("SZC")       
		SZC->ZC_COD     := M->ZC_COD
		SZC->ZC_FORNEC  := M->ZC_FORNEC
		SZC->ZC_LOJA	:= M->ZC_LOJA
		SZC->ZC_NOME	:= M->ZC_NOME
		SZC->ZC_NFISCAL	:= M->ZC_NFISCAL
		SZC->ZC_SERIE	:= M->ZC_SERIE 
		SZC->ZC_EMISSNF	:= M->ZC_EMISSNF
	    SZC->ZC_CHEGADA	:= M->ZC_CHEGADA
		SZC->ZC_SAIDA	:= M->ZC_SAIDA		
		MsUnLock()
		
		//grava código no parametro
		cParam := M->ZC_COD
        DBSELECTAREA("SX6")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SZC")+"MV_CONCEGA")
		IF FOUND()
		   RECLOCK("SX6",.F.)
		   X6_CONTEUD := STRZERO(VAL(CPARAM)+1,6)
		   MSUNLOCK()
		EndIf   

	Endif

     
	//Salva Itens
	iiRec   := 0  // registro inicial
	jjRec   := 0  // registro final
	V_CRIAR := .T.
	If Len(aRecCols) > 0
		V_CRIAR := .F.
		jjRec   := Len(aRecCols)
	EndIf   
              
                         
	DbSelectArea("SZD") 
	If cOpcao == "EXCLUIR"
		If Len(aRecCols) > 0
			For ii := 1 to Len(aCols)
				DbGoTo(aRecCols[ii])
				IF RecLock("SZD",.F.)
					Delete
				endif
				MsUnLock()
			Next                   
		EndIf   
	ElseIF cOpcao == "ALTERAR" .OR. cOpcao == "INCLUIR"
		For ii := 1 to Len(aCols)
			If aCols[ii,Len(aHeader)+1]  // Itens Excluidos
				Loop
			EndIf

			If V_CRIAR
				RecLock("SZD",.T.)
			ElseIf !V_CRIAR .and. iiRec <> jjRec
				iiRec := iiRec + 1
				DbGoTo(aRecCols[iiRec])
				RecLock("SZD",.F.)             
				V_CRIAR := If(iiRec == jjRec,.T.,.F.)
			EndIf   
            
            
			SZD->ZD_FILIAL   := xFilial("SZD")
			SZD->ZD_AVISO	 := SZC->ZC_COD
			For jj := 1 to Len(aHeader)
				FieldPut(FieldPos(Alltrim(aHeader[jj,2])),aCols[ii,jj])
			Next                         
			SZD->ZD_ITEM := ii
			MsUnLock()
		Next
		
		// Elimina registros excedentes   
		If !V_CRIAR
			iiRec := iirec + 1
			DbGoTo(aRecCols[iiRec])
			For ii := iiRec to jjRec
				If RecLock("SZD")
					Delete
					MsUnLock()
				EndIf
			Next
		EndIf 
	EndIf   

	#IFDEF TOP
		EndTran()
	#ENDIF   
Return NIL   
                 
// LEGENDA

User Function LoadCpo
	// Cabecalho Modelo 2 Campos
	dbSelectArea("SX3")
	dbSeek("SZC")
	aCpoEnchoice:={}
	aAltEnchoice:={}
	Do While !Eof().And.(x3_arquivo=="SZC")     
		If X3USO(x3_usado).And.cNivel>=x3_nivel
			Aadd(aAltEnchoice,ALLTRIM(X3_CAMPO))
			Aadd(aCpoEnchoice,ALLTRIM(X3_CAMPO))
		Endif
		DbSkip()
	Enddo

	// Header/Acols Modelo 2 Itens
	nUsado:=0
	dbSelectArea("SX3")
	dbSeek("SZD")
	aHeader:={}
	Do While !Eof().And.(x3_arquivo=="SZD")     
		if X3USO(x3_usado).And.cNivel>=x3_nivel
			Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,x3_tamanho, x3_decimal,x3_valid,x3_usado, x3_tipo, x3_arquivo, x3_context })
			nUsado:=nUsado+1
		Endif
		dbSkip()
	Enddo
Return nil

User Function LoadRecs()
    aRecCols := {}  // Registros atuais dos Itens
	aCols    := {}

  	dbSelectArea("SZD")
  	dbgotop()
	dbSetOrder(2)
	dbSeek(xFilial("SZD")+SZC->ZC_COD)
	While !eof() .and. xFilial("SZD")==ZD_FILIAL .and. ZD_AVISO==SZC->ZC_COD
		AADD(aCols,Array(Len(aHeader)+1))
		AADD(aRecCols,Recno())
		For _ni:=1 to Len(aHeader)
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next 
		aCols[Len(aCols),Len(aHeader)+1]:=.F.
		dbSkip()
	Enddo

	If Len(aCols)=0
		aCols:={Array(Len(aHeader)+1)}
		aCols[1,Len(aHeader)+1]:=.F.
		For _ni:=1 to Len(aHeader)
			aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
		Next
	EndIf	
Return nil