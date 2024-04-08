#Include "rwmake.ch"        

User Function ETIQREC1()    
**********************
SetPrvt("CPERG,CCOMBO,AITENS,VQETIQ,VCODIGO,VNFISCAL")
SetPrvt("VLOTE,VDESC,VFORNEC,VLOTEFOR,VQUANT,VDTAREC")
SetPrvt("VCONF,VDTAVAL,VSAIR,_CPORTA,_SALIAS,AREGS")
SetPrvt("I,J,qQetiq,nQtdeEmb,nQtdeNF,vFornec,vLoja")
 
cCombo  := "LPT1"
aItens  := {"COM1","COM2","LPT1"}
cMonta  := "1"
aItens1 := {"1","2","3","4","5"}
cTipo   := Space(01)
Aviso   := Space(50)
vDesc   := Space(30)
vCodigo := Space(30)
Descli  := Space(30)
cNumNF  := Space(09)
cSerie  := space(03)
cBarra  := Space(08)
cBarra2 := Space(08)
vSair   := .f.
VQetiq  := 001
qQetiq  := 0
VQuant  := 0
vQtpc   := 0
nQtdeEmb:= 0
nQtdeNF := 0
vFornec := Space(08)
vLoja   := Space(04)
nlote   := space(10)
nItem   := space(4)
While vSair==.f.
   @ 003,001 To 350,500 Dialog oDlg1 Title "ETIQUETA Recebimento - Produto x NF"
   @ 005,003 To 030,250
   @ 014,030 Say "Quantidade:"
   @ 014,060 Get VQetiq                   Size 015,20 Picture "999"  
   @ 014,100 Say "Porta:"
   @ 014,120 ComboBox cCombo Items aItens Size 030,50   
   
   @ 040,002 Say "Fornecedor:"
   @ 040,050 Get  VFornec                  SIZE 40,20 Pict "@!"  F3("SA2") 
   @ 040,095 Say "Loja:"
   @ 040,110 Get VLoja                      SIZE 30,20 Pict "@!"
   
   @ 060,002 Say "Nt.Fiscal:"
   @ 060,050 Get cNumNF                   Size 040,20 Picture "@R XXXXXXXXX"  f3("SF1")//Valid Verif_Nota(cNumNF) 
   @ 060,095 Say "Serie:"
   @ 060,110 Get cSerie                   Size 040,20 Picture "@R XXX"  Valid Verif_Nota(cNumNF+cSerie) 
   
   @ 060,155 Say "Item:"
   @ 060,170 Get  nItem                   Size 040,20 Picture "@R XXXX" 


   @ 080,002 Say "Cod. Produto:"
   @ 080,050 Get VCodigo                  Size 045,20 Picture "@!"  F3("SB1")  Valid Verif_Prod(vCodigo) 
   @ 080,095 Get VDesc      When .f.      Size 105,20 Picture "@!"  

   @ 100,002 Say "Lote. Produto:"
   @ 100,050 Get nLote                  Size 045,20 Picture "@!"  

   
   @ 120,002 Say "Qtde p/Embalagem:"
   @ 120,050 Get nQtdeEmb                 Size 050,20 Picture "@E 999,999.99"   valid Verif_Qtde(nQtdeEmb)
   @ 135,002 Say "Qtde no Item NF:"
   @ 135,050 Get nQtdeNF    When .f.      Size 050,20 Picture "@E 999,999.99"  
   @ 150,140 Button "_Imprimir"           Size 035,15 Action Impetiq()
   @ 150,180 Button "_Sair"               Size 035,15 Action Sair()
   Activate Dialog oDlg1 Centered
EndDo

Return


Static Function Impetiq()
**********************
If cCombo =="COM1"
   _cPorta := "COM1:9600,e,8,1"
ElseIf cCombo =="COM2"
   _cPorta := "COM2:9600,e,8,1"
ElseIf cCombo =="LPT1"
   _cPorta := "LPT1"
EndIf              

cCodigo:= AllTrim(SB1->B1_COD)
cLote  := " "

DbSelectArea("SA2")
DbSetOrder(1)
MsSeek(xfilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA)

DbSelectArea("QEK")
DbSetOrder(6)
MsSeek(xFilial("QEK")+SD1->D1_DOC)

DbSelectArea("QEL")
DbSetOrder(1)
MsSeek(xFilial("QEL")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_COD+DtoS(QEK->QEK_DTENTR))
cDescSitua:= "PENDENTE"
If QEK->QEK_VERIFI== 1
	cDescSitua:= "APROVADO"
EndIf

cTipoBar := 'MB07' //128





MSCBPRINTER("S500-6" ,_cPorta,Nil,040,.f.,,,,)
MSCBCHKStatus(.f.)    
      
MSCBBEGIN(VQetiq,4) 
//MSCBBOX(08,03,80,120,3)
MSCBBOX(08,16,138,110,3)

  MSCBLineH(08,35,138,3) //Linhas Verticais
  MSCBLineH(08,46,138,3)
  MSCBLineH(08,58,138,3)
  MSCBLineH(08,78,138,3)
  MSCBLineH(08,96,138,3)
//MSCBLineH(19,65,29,3)
//MSCBLineH(08,65,19,3) 

    

 //MSCBLineV(59,03,108,3) //Linhas Horizontais   
 //MSCBLineV(49,03,108,3) 
 //MSCBLineV(39,03,108,3) 
 //MSCBLineV(29,03,110,3) 
 //MSCBLineV(19,03,110,3)

MSCBSAY(10,05,'IDENTIFICACAO DE MATERIAIS',"N","B","23,23")
MSCBSAY(45,10,'BRASCOLA',"N","O","23,23")

MSCBSAY(10,18,'Codigo Material',"N","B","010,010")

MSCBSAY(20,23,SB1->B1_COD,"N","0","070,070")
//MSCBSAYBAR(60,25,SB1->B1_COD ,"N","MB07",10,.F.,.T.,.F.,,2,1)
MSCBSAYBAR(68,21,cCodigo,"N","MB07",12,.F.,.F.,.F.,,3,2,.F.,.F.)//,"1",.T.)

//MSCBSAY(62,55,cDescSitua  ,"N","0","050,050")  

MSCBSAY(10,36,'Descricao' ,"N","B","010,010")
MSCBSAY(12,40,SB1->B1_DESC,"N","0","030,020")

//MSCBSAY(57,75,'Localizacao'  ,"R","B","010,010")
//MSCBSAY(50,75,SB1->B1_ENDEREC,"R","0","030,030")
MSCBSAY(10,48,'Fornecedor',"N","B","010,010")
MSCBSAY(12,52,SA2->A2_COD+'/'+SA2->A2_LOJA+' - '+SA2->A2_NREDUZ,"N","0","030,020")
//MSCBSAY(100,48,'Embal.Qtde',"N","B","010,010")
//MSCBSAY(104,52,Transform(nQtdeEmb,"@E 999,999.99"),"N","0","030,020")
MSCBSAY(100,48,'Nota Fiscal',"N","B","010,010")
MSCBSAY(102,52,RTRIM(SD1->D1_DOC)+'/'+SD1->D1_SERIE,"N","0","030,040")

MSCBSAY(10,60,'Lote',"N","B","010,010")
MSCBSAY(12,64,nLote,"N","O","050,020")

MSCBSAY(50,60,'Data Validade',"N","B","010,010")
MSCBSAY(52,64,DTOC(SD1->D1_DTVALID),"N","O","050,020")
//MSCBSAY(88,60,Transform(nQtdeNF,"@E 999,999")+" "+SB1->B1_UM ,"N","0","050,040")

MSCBSAY(88,60,'Quantidade',"N","B","010,010")
MSCBSAY(90,64,Transform(SD1->D1_QUANT,"@E 999,999")+" "+SB1->B1_UM ,"N","0","050,020")
MSCBSAYBAR(106,62,alltrim(str(nQtdeNF)),"N","MB07",12,.F.,.f.,.F.,,2,2,.F.,.F.)//,"1",.T.)
//MSCBSAYBAR(88,60,alltrim(sd1->D1_lotectl),"N","MB07",13,.F.,.F.,.F.,,2,2,.F.,.F.)//,"1",.T.)


//MSCBSAY(10,80,'Quantidade',"N","B","010,010")
//MSCBSAY(30,75,Transform(SD1->D1_QUANT,"@E 999,999")+" "+SB1->B1_UM ,"R","0","030,020")
//MSCBSAY(12,84,Transform(nQtdeNF,"@E 999,999")+" "+SB1->B1_UM ,"N","0","050,040")


//MSCBSAYBAR(40,81,alltrim(str(nQtdeNF)),"N","MB07",13,.F.,.F.,.F.,,2,2,.F.,.F.)//,"1",.T.)

//MSCBSAY(70,80,'Recebimento',"N","B","010,010")
//MSCBSAY(72,84,Iif(Empty(QEK->QEK_DTENTR),DtoC(dDataBase),DtoC(QEK->QEK_DTENTR)),"N","0","050,040")

MSCBSAYBAR(20,81,ALLTRIM(SB1->B1_COD)+alltrim(sd1->D1_lotectl)+dtos(SD1->D1_DTVALID),"N","MB07",13,.F.,.F.,.F.,,2,2,.F.,.F.)//,"1",.T.)


MSCBSAYBAR(050,98,RTRIM(SD1->D1_DOC)+SD1->D1_SERIE+SA2->A2_COD+SA2->A2_LOJA ,"N","MB07",08,.F.,.t.,.F.,,2,2)
*/


/*
MSCBSAY(37,06,'Produto',"R","B","010,010")
MSCBSAYBAR(30,05,cCodigo ,"R","MB07",06,.F.,.F.,.F.,,2,1)
MSCBSAY(36,55,'Nota Fiscal',"R","B","010,010")
MSCBSAY(30,55,SD1->D1_DOC+'/'+SD1->D1_SERIE,"R","0","030,020")
MSCBSAY(36,80,'Quantidade',"R","B","010,010")
//MSCBSAY(30,75,Transform(SD1->D1_QUANT,"@E 999,999")+" "+SB1->B1_UM ,"R","0","030,020")
MSCBSAY(30,84,Transform(nQtdeNF,"@E 999,999")+" "+SB1->B1_UM ,"R","0","030,020")
MSCBSAY(26,06,'Recebimento',"R","B","010,010")
MSCBSAY(20,06,Iif(Empty(QEK->QEK_DTENTR),DtoC(dDataBase)+"  "+SubStr(Time(),1,5),DtoC(QEK->QEK_DTENTR)+"  "+QEK->QEK_HRENTR),"R","0","030,020")
//MSCBSAY(26,33,'Numero R.E.',"R","B","010,010")
//MSCBSAY(20,34,SF1->F1_RE,"R","0","030,020")

MSCBSAY(26,40,'Lote',"R","B","010,010")                                        

MSCBSAY(20,44,SD1->D1_LOTECTL,"R","0","030,020")

MSCBSAY(26,80,'Data Validade',"R","B","010,010")
MSCBSAY(20,84,DTOC(SD1->D1_DTVALID),"R","0","030,020")
MSCBSAYBAR(10,05,SD1->D1_DOC+SD1->D1_SERIE+SA2->A2_COD+SA2->A2_LOJA ,"R","MB07",08,.F.,.F.,.F.,,2,2)
//MSCBSAY(16,69,"Lote","R","B","010,010")
//MSCBSAY(08,71,cLote ,"R","0","040,040")
 */
MSCBEND()
MSCBCLOSEPRINTER()


Return 	    
   

Static Function Sair()
********************
Close(oDlg1)
vSair := .t.

Return


Static Function Verif_Prod(vCodigo)
*******************************
DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+vCodigo)
If !Found()
   	MsgAlert('Cod.Produto nao encontrado!!','Atenção!')
	Return .f.
EndIf

//DbSelectArea("SD1")
//DbSetOrder(2)
//DbSeek(xFilial("SD1")+SB1->B1_COD+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SB1->B1_COD+nItem)
if found()
   nLote := SD1->D1_LOTECTL
ELSE
   	MsgAlert('Produto nao encontrado na Nota Fiscal informada!!','Atenção!')
	Return .f.
EndIf 

nQtdeItNF:= 0

nlote
//While !Eof() .And. xFilial("SD1")+SB1->B1_COD+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
//	nQtdeItNF+= SD1->D1_QUANT
//	DbSkip()
//EndDo

//DbSkip(-1)

nQtdeItNF:= SD1->D1_QUANT

VDesc   := SB1->B1_DESC
nQtdeEmb:= IIf(Empty(SB1->B1_QE), SD1->D1_QUANT, SB1->B1_QE)
nQtdeNF := nQtdeItNF //SD1->D1_QUANT
VQetiq :=nQtdeItNF/nQtdeEmb
Return .t.
      

Static Function Verif_Nota(cNotaF)
******************************
DbSelectArea("SF1")
DbSetOrder(1)
DbSeek(xFilial("SF1")+cNotaF+VFornec+Vloja)

If !Found()
   	MsgAlert('Nota fiscal nao encontrada!!','Atenção!')
	Return .f.
EndIf

Return .t.   





static function Verif_Qtde(nQtdeEmb)
******************************************
VQetiq :=nQtdeNF/nQtdeEmb
return

