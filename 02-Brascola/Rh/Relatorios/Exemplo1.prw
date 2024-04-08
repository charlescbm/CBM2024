#INCLUDE "PROTHEUS.CH"

User Function Exemplo1()
Local oWindow
Local abInit := {||ConOut("ativando!")}
Local abValid:= {||ConOut("encerrando!"),.T.}
Local lFocus := .F.


oWindow:= tWindow():New( 10, 10, 100, 100, "Minha janela",,,,,,,, CLR_WHITE,CLR_WHITE,,,,,,,.T. )

//Cria a Barra de Menu
oMenuBar := TMenuBar():New(oWindow)
oMenuBar:nClrPane := RGB(255,255,255)

//--------------------- Cria Menu ---------------------
oMenu1 := TMenu():New(0,0,0,0,.T.,,oWindow)
oMenu2 := TMenu():New(0,0,0,0,.T.,,oWindow)

//Adiciona items ao Menu
oMenuBar:AddItem("&Arquivo" , oMenu1, .T.)
oMenuBar:AddItem("&Editar"  , oMenu2, .T.)  



// --------------------- Cria SubMenus ---------------------
oMenuItem := TMenuItem():New(oWindow,"&Novo",,,,{|| MenuNovo() },,"ADDCONTAINER",,,,,,,.T.)
oMenu1:Add(oMenuItem)

oMenuItem := TMenuItem():New(oWindow,"Alerta&s",,,,{|| MenuAlerta() },,"SDUOPEN",,,,,,,.T.)
oMenu1:Add(oMenuItem)   


oMenuItem := TMenuItem():New(oWindow,"Listas",,,,{|| MenuLista() },,"SDUOPEN",,,,,,,.T.)
oMenu1:Add(oMenuItem)

oMenuItem := TMenuItem():New(oWindow,"&Copiar",,,,{|| MenuCopiar() },,"PCOCOPY",,,,,,,.T.)
oMenu2:Add(oMenuItem)

oMenuItem := TMenuItem():New(oWindow,"Co&lar",,,,{|| MenuColar() },,"PCOCOLA",,,,,,,.T.)
oMenu2:Add(oMenuItem)

oWindow:SetMenu( oMenuBar )

oWindow:Activate('MAXIMIZED',,,,,,abInit,,,,,,,,,abValid,,)


Static Function MenuNovo()
Local oTela1 := Nil

//Alert("Voc� clicou no item Novo do menu...")
//criando uma Dialog
lTransparent := .T.
cFonte := 'Arial'
nTamFonte := 14

//New([ nTop], [ nLeft], [ nBottom], [ nRight],    [ cCaption]    , [ uParam6], [ uParam7], [ uParam8],    [ uParam9]          , [ nClrText], [ nClrBack], [ uParam12], [ oWnd], [ lPixel], [ uParam15], [ uParam16], [ uParam17], [ nWidth], [ nHeight], [lTransparent] )
//oDlg   := TDialog():New(    00 ,     00  ,     800   ,     1000 , "Janela sem borda",           ,           ,           ,nOr(WS_VISIBLE,WS_POPUP),        0   ,   16777215 ,            ,        ,     .T.  ,            ,            ,            ,          ,           ,  lTransparent  )
oTela1 := TDialog():New(   180 ,    180  ,     450   ,     800  , "Janela Menu Novo",           ,           ,           ,                        ,  CLR_BLACK ,  CLR_WHITE ,            ,        ,     .T.  ,            ,            ,            ,          ,           ,  lTransparent  )


// TFont
oTFont := TFont():New(cFonte,,nTamFonte,,.T.,,,,,.F.,.F.)

//TButton():New([anRow], [anCol], [acCaption], [aoWnd],                     [abAction]                           , [anWidth], [anHeight], [nPar8], [aoFont], [lPar10], [alPixel],[lPar12],[cPar13], [lPar14], [abWhen], [bPar16], [lPar17])
oButton := TButton():New(   110 ,   250  , "&Fechar"   , oTela1 , {||IIf (MsgNoYes("Deseja Fechar a Janela?"),oTela1:End(), .F.)},     50   ,     20    ,        ,  oTFont ,         ,     .T.  ,        ,        ,         ,         ,         ,         )


// Monta o Texto no formato HTML
cTextHtml := '<img src="N:\Protheus11\ambientes\producao\system\lgrl02.bmp"><br>'+;
'<font size=2 color=red>Linha 01 Vermelha<br>'+;
'<font size=3 color=green>Linha 02 Verde<br>'+;
'<font size=4 color=pink>Linha 03 Pink<br>'+;
'<font size=5 color=blue>Linha 04 Azul'+;
'<hr>'+;
'<font size=2 color=black>'+;
'<table border=1 cellpadding=0 cellspacing=0>'+;
'<tr>'+;
'<td width=100 bgcolor="#FFFF87">C�digo'+;
'<td width=200 bgcolor="#FFFF87">Descri��o'+;
'<td width=100 bgcolor="#FFFF87">Valor'+;
'<tr>'+;
'<td>C�digo'+;
'<td>Descri��o'+;
'<td>Valor'+;
'<tr>'+;
'<td>Coluna 01c'+;
'<td>Coluna 02c'+;
'<td>Coluna 03c'+;
'</table>'

// Aplica Font em um TSay
//TSay():New ( [ nRow], [ nCol],   [ bText]   , [ oWnd], [ cPicture], [ oFont], [ uParam7], [ uParam8], [ uParam9], [ lPixels], [ nClrText], [ nClrBack], [ nWidth], [ nHeight], [ uParam15], [ uParam16], [ uParam17], [ uParam18], [ uParam19], [ lHTML] )
oSay := TSay():New(     10  ,    01  ,{||cTextHtml },  oTela1,            ,  oTFont ,     .T.   ,      .F.  ,      .F.  ,      .T.  ,      255   ,     050    ,     400  ,      60   ,      .F.   ,      .T.   ,      .F.   ,      .F.   ,      .F.   ,    .T.   )

Name      := oTFont:Name
nWidth    := oTFont:nWidth
nHeigh    := oTFont:nHeight
Bold      := oTFont:Bold
Italic    := oTFont:Italic
Underline := oTFont:Underline

//oSay:lWordWrap:= .F.
//oSay:lTransparent := lTransparent
//oSay:SetText( cTextHtml )
//oSay:CtrlRefresh()



//oTela1:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('Abrindo Janela Menu Novo')})

oTela1:Activate(,,,.T.,,,)

Return

// ----------------------------------------------------------------------------------------------

Static Function MenuAlerta()
Local oTela2 := Nil

oTela2 := TDialog():New(180,180,450,600,"Teste Botoes Alertas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

@ 2,3 TO 80,95 LABEL "Exemplo de Alertas" OF oTela2 PIXEL
@ 9,  7 BUTTON "&MsgInfo"      SIZE 40,10 OF oTela2 PIXEL ACTION MsgInfo("Informa��o","Mensagem")
@ 19, 7 BUTTON "M&sgAlert"     SIZE 40,10 OF oTela2 PIXEL ACTION MsgAlert("Alerta 1","Mensagem")
@ 29, 7 BUTTON "Ms&gStop"      SIZE 40,10 OF oTela2 PIXEL ACTION MsgStop("Stop","Mensagem")
@ 39, 7 BUTTON "RetryCancel"   SIZE 40,10 OF oTela2 PIXEL ACTION MsgRetryCancel("T�tulo","Mensagem")
@ 49, 7 BUTTON "&Help 1"       SIZE 40,10 OF oTela2 PIXEL ACTION Help("",1,"","HELP","Help Padr�o Protheus",1,0)
@ 59, 7 BUTTON "H&elp 2"       SIZE 40,10 OF oTela2 PIXEL ACTION Help("",1,"RECNO","HELP","Help 2",1,0)
@ 69, 7 BUTTON "&Fornecedores" SIZE 40,10 OF oTela2 PIXEL ACTION MATA020()
@ 9, 51 BUTTON "Msg&YesNo"     SIZE 40,10 OF oTela2 PIXEL ACTION MsgYesNo("Aceitar ?","Mensagem")
@ 19,51 BUTTON "Msg&NoYes"     SIZE 40,10 OF oTela2 PIXEL ACTION MsgNoYes("Aceitar ?","Mensagem")
@ 29,51 BUTTON "A&viso 1"      SIZE 40,10 OF oTela2 PIXEL ACTION Aviso("Titulo 1","Corpo para Mensagem",{"Ok","Cancelar"},1,"Titulo 2")
@ 39,51 BUTTON "Av&iso 2"      SIZE 40,10 OF oTela2 PIXEL ACTION Aviso("Titulo 1","Corpo para Mensagem",{"Ok","Cancelar"},2,"Titulo 2")
@ 49,51 BUTTON "Avi&so 3"      SIZE 40,10 OF oTela2 PIXEL ACTION Aviso("Titulo 1","Corpo para Mensagem",{"Ok","Cancelar"},3,"Titulo 2")
@ 59,51 BUTTON "&Produtos"     SIZE 40,10 OF oTela2 PIXEL ACTION MATA010()
@ 69,51 BUTTON "Sai&r"         SIZE 40,10 OF oTela2 PIXEL ACTION oTela2:End()

DEFINE SBUTTON FROM 80,38 TYPE 1 ACTION MATA010() ENABLE OF oTela2
DEFINE SBUTTON FROM 80,68 TYPE 2 ACTION oTela2:End() ENABLE OF oTela2

oTela2:Activate(,,,.T.,,,)

Return Nil

// ----------------------------------------------------------------------------------------------

Static Function MenuCopiar()
Local oTela3 := Nil

Alert("MenuCopiar")

oTela3 := TDialog():New(180,180,450,600,"TDialog - MenuCopiar",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oTela3:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('Abrindo tDialog MenuCopiar')})
Return

// ----------------------------------------------------------------------------------------------

Static Function MenuColar()
Local oTela4 := Nil

Alert("MenuColar")

oTela4 := TDialog():New(180,180,450,600,"TDialog - MenuColar",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
oTela4:Activate(,,,.T.,{||msgstop('validou!'),.T.},,{||msgstop('Abrindo tDialog MenuColar')})
Return       
        

//Listas
Static Function MenuLista()
Local oTela5 := Nil
Local oList1, oList2, oList3
Private nList2 := 0
Private aList2 := {{"Linha 1a", "Linha 1b"},{"Linha 2a","Linha 2b"}}  
Private aList3 := {{.F.,"Linha 1 a", "Linha 1 b"},{.F., "Linha2 a", "Linha 2 b"}}
Private oOk      := LoadBitmap( GetResources(), "LBOK" )
Private oNo      := LoadBitmap( GetResources(), "LBNO" )



oTela5 := TDialog():New(180,180,600,800,"Listas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

/*
//Criando lista simples
aItems := {'Item 1','Item 2','Item 3','Disable...'}
nList := 1 
        //TListBox():New( [ nRow], [ nCol],        [ bSetGet]                , [ aItems], [ nWidth], [ nHeight], [ bChange]    , [ oWnd], [ bValid], [ nClrFore], [ nClrBack], [ lPixel], [ uParam13],                               [ bLDBLClick]                , [ oFont], [ uParam16], [ uParam17], [ bWhen] , [ uParam19], [ uParam20], [ uParam21], [ uParam22], [ bRClick] )
oList1 := TListBox():New(    001 ,   001  ,{|u|if(Pcount()>0,nList:=u,nList)},   aItems ,     100  ,     100   ,               ,  oTela5,          ,     230    ,            ,     .T.  ,            ,  {||MsgStop("Voc� deu duplo-clique no item: "+ Str(nList))},         ,            ,            ,          ,            ,            ,            ,            ,            )
*/ 
                                  
	// Cria Componentes Padroes do Sistema
	@ 30,05 LISTBOX oList3 FIELDS HEADER "", "C�digo" ,"Descri��o" PIXEL SIZE 100,80 OF oTela5 ON dblClick(aList3[oList3:nAt,1] := !aList3[oList3:nAt,1],oList3:Refresh())     
	
	oList3:SetArray( aList3 )
	oList3:bLine := {||{IIf(aList3[oList3:nAt,1],oOk,oNo),aList3[oList3:nAt,2],aList3[oList3:nAt,3]}}


/*
@ 05,05 LISTBOX oList2 FIELDS HEADER "Coluna 1" ,"Coluna 2" PIXEL SIZE 100,50 OF oTela5 
oList2:SetArray(aList2)
oList2:bLine := {||{aList2[oList2:nAt,1], aList2[oList2:nAt,2]}}
*/                                                                   

oTela5:Activate(,,,.T.,,,)      

Return


Return NIL
