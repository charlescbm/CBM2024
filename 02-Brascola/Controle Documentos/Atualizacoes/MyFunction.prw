#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"    
#include "dbtree.ch"

User Function Testex()
Local btFecha
Local btPesq
Local edPesquisa
Local cdPesquisa := "Digite o relatorio"
Local lbPesq
Local oSButton1
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Brascola" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

    frid()
    @ 013, 100 MSGET edPesquisa VAR cdPesquisa SIZE 106, 010 OF oDlg COLORS 0, 16777215 PIXEL When .T.
    @ 017, 013 SAY lbPesq PROMPT "Digite o nome do relatoriofmaia	" SIZE 076, 006 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM -071, -105 TYPE 01 OF oDlg ENABLE
    @ 111, 205 BUTTON btFecha PROMPT "&Finalizar" SIZE 036, 012 OF oDlg ACTION Fechar() PIXEL
    @ 012, 212 BUTTON btPesq PROMPT "&Relatorio" SIZE 036, 011 OF oDlg ACTION ExecCrystal(cdPesquisa) PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------
Static Function frid()
//------------------------------------------------
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"B1_COD","B1_DESC","B1_UM"}
Local aAlterFields := {}
Static grid

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  // Define field values
  For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)

  grid := MsNewGetDados():New( 037, 014, 105, 239, GD_INSERT+GD_DELETE+GD_UPDATE, "u_LineOk", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "u_mens", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)

Return



Static Function ExecCrystal(cRel)
	Local cOptions :="1;0;1;cRel"
	CallCrys(cRel,         ,cOptions  ,           ,             ,               ,    .T.   )
Return nil  
  
   


Static Function Fechar()
	If MsgBox("Deseja sair desta tela?","Atenção !!!","YESNO")
    	oDlg:End()
    Else
    	Return nil
	Endif                                        
Return