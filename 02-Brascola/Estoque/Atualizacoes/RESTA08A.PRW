/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ INPPA01                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Tela para geracao da ordem de separacao para utilizacao do  ³±±
±±³          ³  FIFO no controle de Fibras                                 ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Criado em ³ 28/06/2007 ³ Analista ³ Rodolfo Gaboardi.TDI                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±                   

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
DIN - Desenvolvimento Inylbra              -                      Documentacao
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
#include "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
User Function RESTA08A()



Private cOP :=SPACE(13)
PRIVATE oOrdem
Private oQuant
Private nQuant:=0
//Private oMAINWND
Private cCodigo
Private  oBmp
Private cDoc
Private oFont
Private  oDlg1
Private  oDlg1Dados
Private nQuant := 0
Private _SLDT  :=0
Private _SLD   :=0
Private _SALDO :=0
Private aList:={}
dData := Date()
_Time := Time()


// Definicao das fontes utilizadas no sistema
DEFINE FONT oFont  	NAME "Arial" Size 11,15 BOLD
DEFINE FONT oFont1	NAME "Arial" Size 09,10

DEFINE MSDIALOG oDlg1 FROM 5, 5 TO 25, 80 TITLE OemToAnsi("Tela De Pick List") FONT oFont



@ 015 ,005 TO  100, 250 of oDlg1 Pixel

@ 1.7,01.3 Say "Trasferencia para Producao"  SIZE 090,15 COLOR CLR_RED FONT oFont


@ 02.9,01.3 SAY "Data/Hora" COLOR CLR_RED
@ 02.9,8.0 SAY		oData		VAR dData								SIZE 060,10 COLOR CLR_BLUE
@ 02.9,15.0 SAY		oTimer		VAR _Time								SIZE 060,10 COLOR CLR_BLUE

@ 04.0,01.3 SAY "Ordem de produção	" COLOR CLR_RED
//@ 05.0,01.3 SAY "Quantidade da OP.	" COLOR CLR_HRED
@ 04.0,15.0 MSGET oOrdem    Var cOP       SIZE 80,10 COLOR CLR_BLUE F3 "SC2" VALID verOP() //(ChkProd(cEdit_Prod),oImage:CBMPFILE:=cCaminho,oImage:Refresh())
//@ 05.0,15.0 MSGET oQuant	VAR nQuant  	PICTURE "@E 999999"			SIZE 40,10 COLOR CLR_BLUE //WHEN .F.


//@ 05.0,15.0 MSGET oProd		VAR cProdut		PICTURE "@!"			SIZE 100,10 COLOR CLR_BLUE WHEN .F.
//@ 06.0,15.0 MSGET oPartida	VAR cPartida    PICTURE "@!"			SIZE 100,10 COLOR CLR_BLUE VALID VERQUANT()//WHEN .F.

//@ 7.7,15.0 MSGET oPesoTotal	VAR nPesoTotal  PICTURE "@E 999999"	SIZE 100,10 COLOR CLR_BLUE
DEFINE SBUTTON oConfirma FROM 135,215 TYPE 1 ACTION Requi() ENABLE OF oDlg1
DEFINE SBUTTON oCancela  FROM 135,249 TYPE 2 ACTION oDlg1:End() ENABLE OF oDlg1

ACTIVATE MSDIALOG oDlg1 CENTERED  //on init (MyEnchoBar(oDlg,{||Iif(MsgYesNo("Deseja sair ?","Confirmação"),oDlg1:End(),.F.)}),)


return

************************************************************
static Function Requi()

aC       := {}
aR       := {}
PosGrava := {}
nOpcx    := 3 //nao permiti incluir linhas 3 - permite
nUsado   := 0
i        := 0
aHeader  := {}
//aCGD     :={60,5,118,315}// {44,5,118,315}
//aCordW :={125,100,600,750}
aCGD:={50,5,300,550}
aCordw:={100,10,750,1130}



bF4      :={|| }
//aCordw := {800,800,516,790}
nLinGetD := 0
cTitulo  := "Alteracao da Quantidade de Materia Prima"
aHeader  := {}
nCnt     := 0
vnCnt    := 1
aCOLS    := {}
i        := 0
nUsado   := 0
aQUANT   := {}
_SALDO   := 0
//aGetsGD:={"Produto"}
vVenc:= ""


AADD(aHeader,{"Produto            " ,"PRODUTO       "      ,"@!"          ,15,0,"u_vldProdA()","€€€€€€€","C","SB1"})
AADD(aHeader,{"Descrição          " ,"B1_DESC      "      ,"@!"          ,30,0,""             ,"€€€€€€€","C","SB1"})
AADD(aHeader,{"Lote               " ,"D4_LOTECTL   "      ,"@!"          ,10,0,""             ,"€€€€€€€","C","SD4"})
AADD(aHeader,{"Dt Valid Lote      " ,"D4_DATA      "      ,""            ,8,0,"u_vdata()   ","€€€€€€€","D","SD4"}) //"99/99/9999
AADD(aHeader,{"Quant Original     " ,"D4_POTENCI   "      ,"@E 999,999.9999",9,4,"","€€€€€€€","N","SD4"})
AADD(aHeader,{"Quant Transferida  " ,"D4_POTENCI   "      ,"@E 999,999.99",9,2,"","€€€€€€€","N","SD4"})
//AADD(aHeader,{"Quant Lote         " ,"D4_QTDORI    "      ,"@E 999,999.99",9,2,"","€€€€€€€","N","SD4"})
AADD(aHeader,{"Quantidade         " ,"D4_QTDORI    "      ,"@E 999,999.9999",9,4,"","€€€€€€€","N","SD4"})
AADD(aHeader,{"Num Lote           " ,"D4_POTENCI  "      ,"@!"          ,10,0,"","€€€€€€€","C","SD4"})


/*
AADD(aHeader,{"Quantidade"     ,"G1_QUANT    "      ,"@E 999,999.99",9,2,"","€€€€€€€","N","SG1"})
AADD(aHeader,{"Produto"        ,"Produto     "      ,"@!"          ,15,0,"U_vldProd()","€€€€€€€","C","SB1"})
AADD(aHeader,{"Descrição"      ,"B1_DESC     "      ,"@!"          ,30,0,"","€€€€€€€","C","SB1"})
*/
//Aadd(aHeader,{"Lote"      , "B8_NUMLOTE"            ,"@!"          , 06, 0, "u_VldLote1()",  "ÇÇÇÇÇÇÇÇÇÇÇÇÇÇá", "C", "SB8", ""})

Dbselectarea("SC2")
Dbsetorder(1)
Dbseek(xfilial("SC2")+cOP)

cCodigo:=SC2->C2_PRODUTO

cDoc :=NextNumero("SD3",2,"D3_DOC",.T.)

AADD(aC,{'cDoc',{25,05} ,"Documento",,,,.f.,})
AADD(aC,{'cOP', {25,100} ,"Ordem de Producao",,,,.f.})
//AADD(aC,{DTOS(SC1->C1_EMISSAO),{50,10} ,"Data SC"  ,,,,.F.})
AADD(aC,{'cCodigo',{25,250},"Produto",,,,.f.})



Dbselectarea("SD4")
dBSETORDER(1)



_cQuery := " SELECT D4_COD,D4_QUANT,D4_QTDEORI FROM "+RetSqlName("SD4")+","+RetSqlName("SB1")+" "
_cQuery += " WHERE " +RetSqlName("SD4")+ ".D_E_L_E_T_ <> '* ' AND  D4_OP = '"+cOP+"'  AND SUBSTRING(D4_COD,1,3) <> 'MOD' and D4_FILIAL = '"+xFilial("SD4")+"' "
_cQuery += " AND D4_COD = B1_COD AND B1_TIPO NOT IN  ('4','3','5') AND " +RetSqlName("SB1")+".D_E_L_E_T_ ='' AND D4_QTDEORI > D4_SLDT "
_cQuery += " ORDER BY D4_COD

If Select("QUERY") > 0
	dbCloseArea()
EndIf
TCQUERY _cQuery NEW ALIAS "QUERY"
//_cAnexo := ""

dbSelectArea("QUERY")
dbgotop()

While QUERY->(!Eof())
	
	_lfirst:=.t.
	_SALDO:= 0
	Set Key VK_F4 TO  slote()
	
	IF QUERY->D4_QTDEORI ==  0
		QUERY->(DBSKIP())
		LOOP
	ENDIF
	
	_COD:=QUERY->D4_COD
	_cQuery1 := " SELECT (D4_SLDT)AS QUANT FROM "+RetSqlName("SD4")+" "
	_cQuery1 +=  " WHERE D_E_L_E_T_ <> '* ' AND D4_COD = '"+_COD+"' AND D4_OP = '"+cOP+"' "
	_cQuery1 +=  " and D4_FILIAL = '"+xFilial("SD4")+"' "
	
	//If Select("QUERY1") > 0
	//	dbCloseArea()
	//EndIf
	TCQUERY _cQuery1 NEW ALIAS "QUERY1"
	
	nQtdc:=QUERY1->QUANT
	Dbclosearea("QUERY1")
	
	_cQuery2 := "SELECT B8_DTVALID,B8_PRODUTO,B8_LOTECTL,B8_NUMLOTE,(B8_SALDO - B8_EMPENHO)AS SALDO  "
	_cQuery2 += " FROM " +RetSqlName("SB8")+ ""
	_cQuery2 += " WHERE D_E_L_E_T_ <> '* ' AND  B8_PRODUTO = '"+_Cod+"'   "
	_cQuery2 += " AND B8_SALDO > 0 and B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = '10' " //AND B8_DTVALID > '"+dtos(DDATABASE)+"'
	_cQuery2 += " ORDER BY B8_DTVALID "
	
	TCQUERY _cQuery2 NEW ALIAS "QUERY2"
	DBSELECTAREA("QUERY2")
	DBGOTOP()
	
   	if QUERY2->(EOF())
	   SB1->(DBSEEK(XFILIAL("SB1")+QUERY->D4_COD))
	   AADD(aCOLS,{QUERY->D4_COD,sb1->b1_desc,space(13),ddatabase,QUERY->D4_QTDEORI,nQtdc,0,space(6),.F.})
     	AADD(PosGrava,{Recno()})
	endif
	
	WHILE QUERY2->(!EOF())
		
		
		_SLDT:=0
		_SLD:=QUERY2->SALDO
		_SALDO := _SALDO + QUERY2->SALDO
		
		
		if _lfirst ==.t.
			
			IF _SLD <= _SALDO
				IF _SALDO <= QUERY->D4_QTDEORI
				   	_SLDP:= 0//QUERY2->SALDO - nQtdc
				     SB1->(DBSEEK(XFILIAL("SB1")+QUERY->D4_COD))
					_DESC:=substr(SB1->B1_DESC,1,20)
				   _lfirst:=.F.
					vVenc := substr(QUERY2->B8_DTVALID,7,2)+"/"+substr(QUERY2->B8_DTVALID,5,2)+"/"+substr(QUERY2->B8_DTVALID,3,2)
					AADD(aCOLS,{QUERY->D4_COD,_DESC,QUERY2->B8_LOTECTL,vVenc,QUERY->D4_QTDEORI,nQtdc,_SLDP,QUERY2->B8_NUMLOTE,.F.})
				ELSE
					_SLDT:=QUERY->D4_QTDEORI - nQtdc  
					_lfirst :=.F.
					SB1->(DBSEEK(XFILIAL("SB1")+QUERY->D4_COD))
					_DESC:=substr(SB1->B1_DESC,1,20)
					vVenc := substr(QUERY2->B8_DTVALID,7,2)+"/"+substr(QUERY2->B8_DTVALID,5,2)+"/"+substr(QUERY2->B8_DTVALID,3,2)
					AADD(aCOLS,{QUERY->D4_COD,_DESC,QUERY2->B8_LOTECTL,vVenc,QUERY->D4_QTDEORI,nQtdc,_SLDT,QUERY2->B8_NUMLOTE,.F.})
				ENDIF
			Endif
		ENDIF
		AADD(PosGrava,{Recno()})
		DBSELECTAREA("QUERY2")
		QUERY2->(DBSKIP())
	END
	
	//	AADD(aQuant,{nQtdc,.F.})
	//	AADD(aQuant,{QUERY->D4_QTDEORI,.F.})
	
	
	
	dbselectarea("QUERY2")
	DBCLOSEAREA("QUERY2")
	
	dbselectarea("QUERY")
	
	// SET KEY VK_F4 TO
	
	QUERY->(dbskip())
	
   //	SET KEY VK_F4 TO
end


cLinhaOk := "ExecBlock('Md4LinOk',.f.,.f.)"//Md2LinOk()//".t."
//cLinhaOk := ".t."
cTudoOk  :=  "AllwaysTrue()" // ".t."  //        "ExecBlock('Md2TudoOk',.f.,.f.)"//Md2LinOk()//".t."  ".t."
lRetMod2 :=   ".t."

 
//M o d e l o 2 ( c T í t u l o , a C a b e c , a R o d a p é , a G d , n O p , c L O k , c T O k ,
//[aGetsGD,bF4,cIniCpos,nMax,aCordw,lDelget])


Set Key VK_F4 TO  slote()

lRetMod2 := Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,aCordw)
 



If lRetMod2
   U_grvA()
end


DbSelectArea('QUERY')
dbCloseArea()
SET KEY VK_F4 TO
Return



******************************************
static function verOP()
LRET:=.T.
Dbselectarea("SC2")
Dbsetorder(1)
IF Dbseek(xfilial("SC2")+cOP)
	cCodigo:=SC2->C2_PRODUTO
	
ELSE
	MSGALERT("Numero da OP Nao existe!Digite a OP correta")
	cOP:=space(13)
	LRET:=.f.
endif
//nQuant :=sc2->c2_quant

RETURN LRET
*******************************************************

User function vldProdA()
LRET1:=.t.
//nPos3 :=ascan(aHeader,{|X|  alltrim(X[2]) == "B1_DESC"})
_codigo:=ALLTRIM(M->PRODUTO)
Dbselectarea("SB1")
DBSETORDER(1)
IF !(SB1->(Dbseek(xfilial("SB1")+substr(_codigo,1,15))))
	MSGALERT("Produto nao encontrado")
	LRET1:=.f.
	
endif

return LRET1





*******************************************************

User function vdata()
LRET3:=.f.
//nPos3 :=ascan(aHeader,{|X|  alltrim(X[2]) == "B1_DESC"})
//_data:=ALLTRIM(M->PRODUTO)
//Dbselectarea("SB1")
//DBSETORDER(1)
//IF !(SB1->(Dbseek(xfilial("SB1")+substr(_codigo,1,15))))
//	MSGALERT("Produto nao encontrado")
//	LRET1:=.f.
msgalert("Nao é possivel alterar a data de vencimento")	
//endif

return LRET3

********************************************************

Static  function slote()

Private lretorno := .f.
Private cChamada := ""
Private _qttra
Private _qtorig
Private pos:= n		
//Private lf:=.t.


aList2:={}



nPos2 := ascan(aHeader,{|X| alltrim(X[2]) == "PRODUTO"})

_cProduto:=aCols[n,nPos2]
//_qttra:=aCols[n,6]
//_qtorig:=aCols[n,5]                          
_cnumlote:=aCols[n,8]

//if ascan(aList,{|X| alltrim(X[1]) == alltrim(_cProduto)}) == 0 
   aList:={}
//endif

_cQuery3 := "SELECT B8_DTVALID,B8_PRODUTO,B8_LOTECTL,B8_NUMLOTE,(B8_SALDO - B8_EMPENHO)AS SALDO  "
_cQuery3 += " FROM "+RetSqlName("SB8")+ ""
_cQuery3 += " WHERE D_E_L_E_T_ <> '* ' AND  B8_PRODUTO = '"+_cProduto+"'   "
_cQuery3 += " AND B8_SALDO > 0 and B8_FILIAL = '"+xFilial("SB8")+"' AND B8_LOCAL = '10' "  //AND B8_DTVALID > '"+dtos(DDATABASE)+"'
_cQuery3 += " ORDER BY B8_DTVALID "

TCQUERY _cQuery3 NEW ALIAS "QUERY3"
//TCSetField('QUERY3', "SALDO"  , "N",9,2)
DBSELECTAREA("QUERY3")
DBGOTOP()                                            

For  s := 1 to Len(acols)
	_cCod := aCols[s,1]

//If !GDDeleted(i)
	if _cCod  ==  _cProduto  .and. !GDDeleted(s)
		
		_Lot:=aCols[s,8]
		_nQ1 :=aCols[s,7]
		
		
		if _nQ1 > 0
			
			t:= Ascan(aList2, {|x| alltrim(x[1])  == AllTrim(_lot)})
			
			if t= 0
				
				AADD(aList2,{_Lot,_nQ1} )
			else
				
				aList2[t,2]+=_nQ1
				
			endif
		endif
		
	endif
//endif
next

	



Do While QUERY3->(!EOF())
	
  cSaldo :=  QUERY3->SALDO    //Transform(QUERY3->SALDO,"@E 999,999.99")
  cVenc := substr(QUERY3->B8_DTVALID,7,2)+"/"+substr(QUERY3->B8_DTVALID,5,2)+"/"+substr(QUERY3->B8_DTVALID,3,2)
  
  AADD(aList,{QUERY3->B8_PRODUTO,QUERY3->B8_LOTECTL,cSaldo,cVenc,QUERY3->B8_NUMLOTE} )
  x:= Ascan(aList2, {|x| alltrim(x[1])  == AllTrim(QUERY3->B8_LOTECTL)}) 
  f:= Ascan(aList, {|x| alltrim(x[2])  == AllTrim(QUERY3->B8_LOTECTL)}) 
  
  if x > 0   

  if aList[f,3] > alist2[x,2]
	 aList[f,3]:= aList[f,3]-alist2[x,2]
	 aList2[x,2]:=0   
  else
     aList2[x,2]:=aList2[x,2]-alist[f,3]
     aList[f,3]:= 0
   endif
  endif         		
  
  /*
	
  
  f:= Ascan(aList, {|x| alltrim(x[5])  == AllTrim(QUERY3->B8_NUMLOTE)}) 
   // x:= Ascan(aList2, {|x| alltrim(x[1])  == AllTrim(QUERY3->B8_NUMLOTE)}) 
       
    if  len(alist2) == 0 .or. f == 0
        AADD(aList,{QUERY3->B8_PRODUTO,QUERY3->B8_LOTECTL,cSaldo,cVenc,QUERY3->B8_NUMLOTE} )
	else
	    x:= Ascan(aList2, {|x| alltrim(x[1])  == AllTrim(QUERY3->B8_NUMLOTE)}) 
	
	    if x > 0   
	      if n ==pos .and. lf == .t. 
             if aList[f,3] > alist2[x,2]
	            aList[f,3]:= aList[f,3]-alist2[x,2]
	            aList2[x,2]:=0   
                lf:=.f.
             else
                 aList2[x,2]:=aList2[x,2]-alist[f,3]
                 aList[f,3]:= 0
	          endif  
           elseif n ==pos .and. lf == .f.
                 if aList[f,3] > alist2[x,2]
	                aList[f,3]:= aList[f,3]//-alist2[x,2]
	                aList2[x,2]:=0   
                 else
                 aList2[x,2]:=aList2[x,2]-alist[f,3]
                 aList[f,3]:= 0
	           endif 
              
          else    
              if aList[f,3] > alist2[x,2]
	             aList[f,3]:= aList[f,3]-alist2[x,2]
	             aList2[x,2]:=0   
              else
                 aList2[x,2]:=aList2[x,2]-alist[f,3]
                 aList[f,3]:= 0
	          endif  
           endif
         endif
   
 endif
	
*/	
	
   //	cSaldo :=  QUERY3->SALDO    //Transform(QUERY3->SALDO,"@E 999,999.99")
	
//	cVenc := substr(QUERY3->B8_DTVALID,7,2)+"/"+substr(QUERY3->B8_DTVALID,5,2)+"/"+substr(QUERY3->B8_DTVALID,3,2)
	//AADD(aList,"  "+SUBSTR(TM2->E1_PREFIXO,1,3)+"      "+TM2->E1_NUM+"          "+substr(TM2->E1_PARCELA,1,3)+"   "+TM2->E1_TIPO+"          "+ cSaldo+"                        "+cVenc )
	
	
	
	
  	//AADD(aList,{QUERY3->B8_PRODUTO,QUERY3->B8_LOTECTL,cSaldo,cVenc} )
	QUERY3->(DBSKIP())
EndDo
If Len(aList) == 0
	aAdd(aList,{" "," ",0," "," "})
EndIf


QUERY3->(DBCLOSEAREA())



DEFINE FONT oFont NAME "Arial" SIZE 0,-12 BOLD
DEFINE MSDIALOG oDlg FROM 096,042 TO 400,600 TITLE "Saldo Por Lote" PIXEL
@ 020,012 LISTBOX oListBox1 VAR cListBox1 Fields HEADER ;
OEMTOANSI("PRODUTO"),;
OEMTOANSI("LOTE"),;
OEMTOANSI("SALDO"),;
OEMTOANSI("VENCIMENTO"),;
OEMTOANSI("NUM.LOTE"),;
FIELDSIZES ;
GetTextWidth(0,"BBBBBB"),;
GetTextWidth(0,"BBBBBB"),;
GetTextWidth(0,"BBBBBBBBB"),;
GetTextWidth(0,"BBBBBB"),;
GetTextWidth(0,"BBBBBB"),;
SIZE 245,070 NOSCROLL PIXEL
oListBox1:SetArray(aList)
oListBox1:bLine 		:= {|| {aList[oListBox1:nAt,1],;
aList[oListBox1:nAt,2],;
Transform(aList[oListBox1:nAt,3],"@E 999,999.99"),;
aList[oListBox1:nAt,4],;
aList[oListBox1:nAt,5] }}
//oListBox1:bChange 		:= {|| RESTC02b(_aList,@aList2,@aList3,oListBox1,@oListBox2,@oListbox3,lBloq,cLocal,@oDlgABro) }
oListBox1:blDblClick 	:= {|| altlote(aList,oListBox1:nAt,@lRetorno,cChamada,oDlg)}
//oListBox1:cToolTip		:= "Duplo click para retornar o código do produto"
oListBox1:Refresh()
@ 128,190 BmpButton Type 1 Action  altlote(aList,oListBox1:nAt,@lRetorno,cChamada,oDlg)
@ 128,229 BmpButton Type 2 Action  (oDlg:End())
//@ 128,180 Button OemToAnsi("Alt Lote") Size 34,13 Action  AltLOTE()
ACTIVATE DIALOG oDlg CENTERED




//@ 128,180 Button OemToAnsi("Alt Lote") Size 34,13 Action  AltLOTE()
//@ 128,229 BmpButton Type 1 Action  _oDLEND()
//ACTIVATE DIALOG oDlg CENTERED


return

**************************************************************

Static Function altlote(aList1,nLinha,lRetorno,cChamada,oDlg)


nPos2 := ascan(aHeader,{|X| alltrim(X[2]) == "PRODUTO"})
_QTDA := 0
_qttra:= 0
_qtorig:= 0
dbselectArea("SB1")
DBSETORDER(1)
DBSEEK(XFILIAL("SB1")+aList1[nLinha,1])
_DESCRI:=SUBSTR(SB1->B1_DESC,1,25)

IF EMPTY(aCols[n,2])
	aCols[n,2]:=_DESCRI
ENDIF

dbselectarea("SD4")
DBSETORDER(1)
if DBSEEK(XFILIAL("SD4")+aList1[nLinha,1]+cOP)
_qttra:=SD4->D4_SLDT  
_qtorig:=D4_QTDEORI
ENDIF 


For  T := 1 to Len(acols)
	_cCod := aCols[T,1]

//If !GDDeleted(i)
	if _cCod  ==  aList1[nLinha,1] .and. !GDDeleted(T)
		
		_nQ7 :=aCols[T,7]
		
		
		if _nQ7 > 0
			
			U:= Ascan(aCOLS, {|x| alltrim(x[1])  == AllTrim(_cCod)})
			
			if U<> 0
				
				_QTDA:=aCols[T,7]+_QTDA
							
			endif
		endif
		
	endif
//endif
next

	




aCols[n,3] :=aList1[nLinha,2]
aCols[n,4] :=aList1[nLinha,4]
//aCols[n,7] :=aList1[nLinha,3]

IF _qtorig == 0
   aCols[n,7] :=aList1[nLinha,3]

ELSEIF  aList1[nLinha,3] > _qtorig
   aCols[n,7] :=_qtorig - _QTDA//aList1[nLinha,3]
else
   aCols[n,7]:= aList1[nLinha,3] - _qttra
endif
aCols[n,8]:=aList1[nLinha,5]

oDlg:End()

lRetorno := .T.

Return(lRetorno)


User Function Md4LinOk()

//aCols[n,1] :="2222"

return .t.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


**************************************************************************
User function GrvA()

Local aTransf:={}
Local aGrv:={}
Local dValid
Local cNewDoc := " "
Local lMsErroAuto := .F.
Local dValid
Local cMsg := ""



nPos2 := ascan(aHeader,{|X| alltrim(X[2]) == "PRODUTO"})


//aSort(aCols,,, {|x, y| x < y})






nPosDel:= Len(aCols[1])

For I := 1 to Len(acols)
   SB1->(DbSetOrder(1))
		
   _cCod:=aCols[i,nPos2]
   _Lotectl:=aCols[i,3]
   _dtvalid:=aCols[i,4]
   _nQuant :=aCols[i,7]
   _nLote  :=aCols[i,8]	
	
	If !GDDeleted(i) .AND. _nQuant <> 0
	   
	   SB1->((DbSeek(xFilial("SB1")+_cCod)))
       p:= Ascan(aGrv, {|x| alltrim(x[5])  == AllTrim(_Lotectl)})
          if p == 0
              AADD(aGrv,{ _cCod,_Lotectl,_dtvalid,_nQuant,_nLote,.F.})
          else
               aGrv[p,4]+=_nQuant
              
          endif
     Endif
 next
 
 //if !TransfAuto(aGrv)
 //  	 msgAlert("Transferencia não foi bem sucedida.Etiqueta não será gerada.")
 //	 Return .f.
 //endif  
 
 U_TransfA(aGrv)//u_Tmata261(aGrv)
 
 return
 

 
 
 
 *********************************************
  //transferacia modelo2 
 ********************************************
User Function TransfA(aGrv)


Local aTransf:={}
Local j
lMsErroAuto := .F.
lMsHelpAuto := .T.                      
aTransf:=Array(len(aGrv)+1)

vlddoc(cDoc)
//begin Transaction 	
//aGrv[j,5],;
FOR j:=1 TO LEN(aGrv)
    
    
    aTransf[1] := {cDoc,dDataBase}
	SB1->((DbSeek(xFilial("SB1")+aGrv[j,1])))
		
	 aTransf[j+1]  := {SB1->B1_COD,;
		SB1->B1_DESC,;
		SB1->B1_UM,;
		"10",;
	    CriaVar("D3_LOCALIZ"),;	//Endereco Origem
		SB1->B1_COD,;
		SB1->B1_DESC,;
		SB1->B1_UM,;
		"11",;  	//Armazem Destino  "PORTO"
		CriaVar("D3_LOCALIZ"),; //Endereco Destino
		CriaVar("D3_NUMSERI"),;
	    aGrv[j,2] ,;
		aGrv[j,5],;
		ctod(aGrv[j,3]),;
		CriaVar("D3_POTENCI"),;
		aGrv[j,4],;  			//Quantidade transferida
		CriaVar("D3_QTSEGUM"),;
		CriaVar("D3_ESTORNO"),;
		CriaVar("D3_NUMSEQ"),;
	   	aGrv[j,2],;
	    ctod(aGrv[j,3]),;
	    CriaVar("D3_ITEMGRD")}

next
MSExecAuto({|x,y| mata261(x,y)},aTransf,3) //Inclusao

If lMsErroAuto
	mostraerro()	
    MSGALERT("Transferencia não foi bem sucedida")
    DisarmTransaction()
else	
	If !Empty(cDoc).and.(SD3->(FieldPos("D3_X_NUMOP")) > 0)
		aSD3 := SD3->(GetArea())
		SD3->(dbSetOrder(2))
		SD3->(dbSeek(xFilial()+cDoc,.T.))
		While !SD3->(Eof()).and.(SD3->D3_FILIAL+SD3->D3_DOC == xFilial("SD3")+cDoc)
			If (SD3->D3_emissao == dDataBase)
				Reclock("SD3",.F.)
				SD3->D3_x_numop := cOp
				MsUnlock("SD3")
			Endif
			SD3->(dbSkip())
		Enddo		
		RestArea(aSD3)
	Endif	
	MSGALERT("Transferencia foi bem sucedida")
    u_grvopA(aGrv)
    u_confA(aGrv,cDoc) 
endif
 
//End Transaction

return


*******************************************************************


User Function confA(aGrv)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cString := 'SD3'
Private aOrd         := {}
Private Titulo   := "Produtos que foram Trasportados para o Almox de Processo "
Private cDesc1   := "Este programa ira emitir o Relatorio de "
Private cDesc2   := "produtos que foram trasferidos "
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 180
Private tamanho      := "M"
Private nomeprog     := "conf" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
Private nLastKey     := 0
//Private cPerg        := "conf"
Private titulo       := "Produtos Trasnferidos para o Processo de acordo com o Picklist"
Private li           := 06
Private Cabec1       := "Produto            Descrição                           Lote              Quantidade            Data         Status"
Private Cabec2       := ""
Private cbtxt        := "Regsitro(s) lido(s)"
Private cbcont       := 0
Private CONTFL       := 01
Private m_pag        := 01
Private lRet         := .T.
Private imprime      := .T.
Private wnrel        := "Nome"//SEPFIBR" // Coloque aqui o nome do arquivo usado para impressao em disco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas como Parametros                                ¿
//³ MV_PAR01 = Ordem de Separacao de       ?                            ¿
//³ MV_PAR02 = Ordem de Separacao Ate      ?                            ¿
//³ MV_PAR03 = Data de Emissao de          ?                            ¿
//³ MV_PAR04 = Data de Emissao Ate    	    ?                            ¿
//³ MV_PAR05 = Considera Ordens encerradas ?                            ¿
//³ MV_PAR06 = Imprime Codigo de barras    ?                            ¿
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//CriaPerg2()

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,Nil,.F.,aOrd,.F.,Tamanho,,.T.)
//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,.T.,aOrd,.T.,Tamanho,,.T.)

//Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|| Relatorio(aGrv) },Titulo)
//CB7->(DbClearFilter())
Return


Static Function Relatorio(aGrv)


local h



Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)


//VLIMPD(cDoc)

cMay := "SD3"+Alltrim(xFilial())+cDoc
IF !MayIUseCode(cMay)
    cDoc:=soma1(cDoc)
 endif   


@ li, 003 Psay "DOCUMENTO: "+cDoc
@ li, 050 Psay "OP: "+cOP
@ ++Li, 000 Psay Replicate("=",220)
Li++


FOR h:=1 TO LEN(aGrv)
	
  //	If lAbortPrint
  //		@Li,00 PSAY "*** CANCELADO PELO OPERADOR ***"
  //		Exit
 //	Endif
	
	If Li > 60
		Li:= Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf
	
	
	@  ++Li,002 PSay aGrv[h,1]
   	SB1->(DBSEEK(XFILIAL("SB1")+aGrv[h,1]))
   	cDescProd:=SUBSTR(sb1->B1_DESC,1,30)
	@   Li,020 PSay cDescProd
  	@   Li,055 PSay aGrv[h,2]
   	@   Li,065 PSay aGrv[h,4]    Picture "@E 999,999,999.99"
  	@   Li,095 PSay ((aGrv[h,3]))
	
 ///	Li++
next
   	@  50, 070 PSAY "Conferido Por: _____________________________"  
   	@  50, 010 PSAY "Separado  Por: _____________________________"  
   	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ CriaPerg2 º Autor ³ Anderson Rodrigues º Data ³  29/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Verifica a existencia das perguntas criando-as caso seja    º±±
±±º          ³ necessario (caso nao existam).                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAACD                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function CriaPerg2()
Local cAlias:= Alias()
Local aRegs := {}
Local i,j

DbSelectArea("SX1")
DbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AAdd(aRegs,{cPerg,"01","Ordem de  De      ?","Ordem de Separacao De      ?","Ordem de Separacao De      ?","mv_ch1","C",06,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CB7"})
AAdd(aRegs,{cPerg,"02","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","mv_ch2","C",06,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CB7"})
AAdd(aRegs,{cPerg,"03","Data de Emissao De         ?","Data de Emissao De         ?","Data de Emissao De         ?","mv_ch3","D",08,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"04","Data de Emissao Ate        ?","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","mv_ch4","D",08,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"05","Considera Ordens encerradas?","Ordem de Separacao Ate     ?","Ordem de Separacao Ate     ?","mv_ch5","N",01,00,1,"C","","mv_par05","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","",""})
AAdd(aRegs,{cPerg,"06","Imprime codigo de barras   ?","Imprime codigo de barras   ?","Imprime codigo de barras   ?","mv_ch6","N",01,00,1,"C","","mv_par06","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
If !DbSeek(cPerg+aRegs[i,2])
RecLock("SX1",.T.)
For j:=1 to FCount()
If j <= Len(aRegs[i])
FieldPut(j,aRegs[i,j])
Endif
Next
MsUnlock()
Endif
Next
DbSelectArea(cAlias)
Return

*/
*******************************************

 user function grvopA(aGrv)
 FOR y:=1 TO LEN(aGrv)
 
 	dbselectarea("SD4")
	DBSETORDER(1)
	if DBSEEK(XFILIAL("SD4")+(aGrv[y,1])+cOP)
	reclock("SD4",.F.)
	SD4->D4_SLDT    :=aGrv[y,4]+SD4->D4_SLDT
	SD4->(MSUNLOCK())
    ENDIF  
 next
 
 
/* 
 
 _TRT :=SPACE(3)
  FOR y:=1 TO LEN(aGrv)
	dbselectarea("SD4")
	DBSETORDER(1)
	if DBSEEK(XFILIAL("SD4")+(aGrv[y,1])+cOP)
		IF EMPTY(SD4->D4_LOTECTL)
			reclock("SD4",.F.)
			SD4->D4_LOTECTL :=aGrv[Y,2]
			SD4->D4_NUMLOTE :=aGrv[Y,5]
			SD4->D4_DTVALID :=STOD(aGrv[Y,3])
			SD4->D4_SLDT    :=aGrv[y,4]+SD4->D4_SLDT
			SD4->(MSUNLOCK())
			if DBSEEK(XFILIAL("SB8")+aGrv[Y,5]+aGrv[Y,2]+(aGrv[y,1]))
				reclock("SB8",.F.)
				SB8->B8_EMPENHO:=aGrv[Y,4]
				SB8->(MSUNLOCK())
			ENDIF
		else
			DBselectarea("SD4")
			DBSETORDER(6)
			if DBSEEK(XFILIAL("SD4")+cOP+(aGrv[y,1])+aGrv[Y,2])
				reclock("SD4",.F.)
				SD4->D4_SLDT :=aGrv[y,4]+SD4->D4_SLDT
				sd4->(MSUNLOCK())
			else
				dbselectarea("SD4")
				DBSETORDER(1)
				if DBSEEK(XFILIAL("SD4")+(aGrv[y,1])+cOP)
					_TRT:=SD4->D4_TRT
					reclock("SD4",.F.)
					SD4->D4_QTDEORI:=SD4->D4_QTEDORI - aGrv[y,4]
					SD4->D4_QUANT :=SD4->D4_QUANT  - aGrv[y,4]
					SD4->(MSUNLOCK())
				endif
				
				reclock("SD4",.T.)
				SD4->D4_FILIAL := XFILIAL("SD4")
				SD4->D4_COD := aGrv[y,1]
				SD4->D4_LOCAL:='11'
				SD4->D4_OP :=cOP
				SD4->D4_QTDEORI:=aGrv[y,4]
				SD4->D4_QUANT := aGrv[y,4]
				SD4->D4_TRT:=_TRT
				SD4->D4_LOTECTL :=aGrv[Y,2]
				sd4->D4_NUMLOTE :=aGrv[Y,5]
				SD4->D4_DTVALID :=STOD(aGrv[Y,3])
				SD4->D4_SLDT:=aGrv[y,4]
				MSUNLOCK()
				
				
				if DBSEEK(XFILIAL("SB8")+aGrv[Y,5]+aGrv[Y,2]+(aGrv[y,1]))
					reclock("SB8",.F.)
					SB8->B8_EMPENHO:=aGrv[Y,4]
					SB8->(MSUNLOCK())
				ENDIF
			ENDIF
	 ENDIF		
	ENDIF	
NEXT
*/

RETURN
/*       
***************************************
      VALIDA DOCUMENTO
**************************************      
*/

static function vlddoc(cDoc)

Local cAlias:=Alias(),nOrder:=IndexOrd(),nRecno:=Recno()
Local nRecSD3    := SD3->(Recno())
Local nOrdSD3    := SD3->(IndexOrd())

If !Empty(cDoc)
   dbSelectArea("SD3")
   dbSetOrder(2)
   If dbSeek(xFilial()+cDoc)
      Do While !Eof() .And. D3_FILIAL+D3_DOC == xFilial()+cDoc 
         If D3_ESTORNO # "S"
         cDoc:= NextNumero("SD3",2,"D3_DOC",.T.)					
         EndIf
      dbSkip()
     EndDo
   EndIf
 SD3->(dbGoto(nRecSD3))
 SD3->(dbSetOrder(nOrdSD3))
 dbSelectArea(cAlias)
 dbSetOrder(nOrder)
 dbGoTo(nRecno)
EndIf        
Return 






