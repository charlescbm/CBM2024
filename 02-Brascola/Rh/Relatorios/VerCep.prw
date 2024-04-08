#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


User Function VerCep()

Private cBairro    := Space(100)
Private cCidade    := Space(100)
Private cLog       := Space(100)
Private cTipLog    := Space(20)
Private cUF        := Space(20)      
Private cCep       := Space(12)


SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oGet1","oSBtn1")


oDlg1      := MSDialog():New( 088,232,316,624,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 012,012,{||"Digite o CEP:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay2      := TSay():New( 044,016,,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 044,056,,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,012)
oSay4      := TSay():New( 064,016,,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,012)
oSay5      := TSay():New( 084,012,,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,012)
oSay6      := TSay():New( 084,052,,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,012)
oGet1      := TGet():New( 012,052,{|u| If(PCount()>0,cCep:=u,cCep)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCep",,)
oSBtn1     := SButton():New( 012,160,1,,oDlg1,,"", )    

oSBtn1:bLClicked := {|| LoadCEP() }

oDlg1:Activate(,,,.T.)

Return 

Static Function LoadCEP()
Local cError   := ""
Local cWarning := ""
Local aRetorno := {} 
Local cRETORNO  //obtem o xml

cRETORNO := HttpGet( 'http://republicavirtual.com.br/web_cep.php?cep='+cCep+'&formato=xml' )

if cRETORNO == nil
   MsgStop( Alert( "Servidor de CEP indisponível." ) )
else
   oScript := XmlParser( cRETORNO, "_", @cError, @cWarning )
   if oScript <> nil
      if XmlChildEx( oSCRIPT, "_WEBSERVICECEP" ) <> nil      
         if Val(oSCRIPT:_WEBSERVICECEP:_RESULTADO:TEXT) > 0
            cUF     := oSCRIPT:_WEBSERVICECEP:_UF:TEXT 
            cCidade := oSCRIPT:_WEBSERVICECEP:_CIDADE:TEXT 
            cBairro := oSCRIPT:_WEBSERVICECEP:_BAIRRO:TEXT 
            cTipLog := oSCRIPT:_WEBSERVICECEP:_TIPO_LOGRADOURO:TEXT 
            cLog    := oSCRIPT:_WEBSERVICECEP:_LOGRADOURO:TEXT 
         endif   
      endif
   endif
endif 

oSay2      := TSay():New( 044,016,{||"UF: " + cUF},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay3      := TSay():New( 044,056,{||"Cidade: " + cCidade},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,128,012)
oSay4      := TSay():New( 064,016,{||"Bairro: " + cBairro},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,168,012)
oSay5      := TSay():New( 084,012,{|| cTipLog},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,012)
oSay6      := TSay():New( 084,052,{|| cLog},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,132,012)      

Return