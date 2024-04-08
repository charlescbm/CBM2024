#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA261LIN  บAutor  ณteste  บ Data ณ  09/22/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao dos produtos transferidos.                        บฑฑ
ฑฑบ          ณo produto origem tem que ser identico ao destino.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ mp8- Brascola                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                     
User Function MA261LIN()

 lRET := .T. 
_cProdori := aCols[n,1]
_cProddes := aCols[n,6]
_CLOCAL   := aCols[n,4]                                      

if _CLOCAL $ '10*40*76*77*79' .and. !(Upper(AllTrim(cUserName))$Upper(GetMv("BR_000052")))
    LRET:=.f.
    msgalert(OemToAnsi("Usuario nao autorizado para fazer movimenta็ใo no local 10/40/76/77/79") )

endif


IF _cProdori <> _cProddes                                  
   IF (Upper(AllTrim(cUserName))$Upper(GetMv("BR_000038")))
       LRET:=.T.
       
       //IF !MsgYesNo(OemToAnsi("O Produto Origem,Cod:"+alltrim(_cProdori)+", possui um codigo diferente do destino,Cod:"+alltrim(_cProddes)+", Confirma Transferencia? ?"),OemToAnsi("Verificacao de Transferencia"))
   
   ELSE  
	   Help("",1,"BRASCOLA",,OemToAnsi("O Produto Origem,Cod:"+alltrim(_cProdori)+", possui um codigo diferente do destino,Cod:"+alltrim(_cProddes)+" nao permitida transferencia!Ligue para Controladoria"),1,0) 
	   //fmaiaMsgalert(OemToAnsi("O Produto Origem,Cod:"+alltrim(_cProdori)+", possui um codigo diferente do destino,Cod:"+alltrim(_cProddes)+" nao permitida transferencia!Ligue para Controladoria"))
	   LRET:=.F.
	ENDIF
ENDIF

Return(LRET)