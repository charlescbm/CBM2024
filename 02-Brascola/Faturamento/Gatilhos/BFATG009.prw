#include "rwmake.ch"
#include "topconn.ch"
      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BFATG009  ºAutor  ³ Marcelo da Cunha   º Data ³  30/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gatilho para avisar clientes com titulos em atraso e       º±±
±±º          ³ tratamento do percentual de comissao reduzido (BR_000026)  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATG009()
**********************
LOCAL cCampo, cQuery1, cRetu:="", aSeg1 := GetArea()
LOCAL cUsuReduz := Alltrim(GetMV("BR_000046")) //Usuario que ativa a reducao da comissao
              
//Verifico campo que disparou gatilho
/////////////////////////////////////
cCampo := Upper(Alltrim(ReadVar()))
If (cCampo == "M->C5_CLIENTE")
	cRetu := M->C5_CLIENTE
Elseif (cCampo == "M->C5_LOJACLI")
	cRetu := M->C5_LOJACLI
Endif
                   
//Busco Informacoes Financeiras
///////////////////////////////
If !Empty(M->C5_CLIENTE).and.!Empty(M->C5_LOJACLI)
	cQuery := "SELECT SUM(E1_SALDO) E1_SALDO "
	cQuery += "FROM "+RetSqlName("SE1")+" WHERE D_E_L_E_T_='' AND E1_FILIAL = '"+xFilial("SE1")+"' "
	cQuery += "AND E1_VENCREA<'"+dtos(MsDate())+"' AND E1_SALDO>0 AND E1_TIPO='NF' AND E1_EMIS1 >= '20120101' "
	cQuery += "AND E1_CLIENTE = '"+M->C5_CLIENTE+"' AND E1_LOJA = '"+M->C5_LOJACLI+"' "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	If !MAR->(Eof()).and.(MAR->E1_saldo > 0)
		cNomCli := Alltrim(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_NOME"))
		Help("",1,"BRASCOLA",,OemToAnsi("Atencao! O Cliente "+cNomCli+" possui R$ "+Alltrim(Transform(MAR->E1_saldo,PesqPict("SE1","E1_SALDO")))+" em atraso! Favor verificar."),1,0) 
	Endif
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
Endif

//Verifico se deve aplicar reducao da comissao pelo usuario que implantou pedido
////////////////////////////////////////////////////////////////////////////////
If !Empty(cUsuReduz).and.(RetCodUsr() $ cUsuReduz)
	If !Empty(M->C5_vend1)
		M->C5_comis1 := M->C5_comis1 / 2 //Reducao de 50%
		dbSelectArea("SC5")
		If ExistTrigger("C5_COMIS1")
			RunTrigger(1,Nil,Nil,,"C5_COMIS1")
		Endif
	Endif
Endif

RestArea(aSeg1)

Return cRetu