#include "PROTHEUS.ch"
#include "AVERAGE.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EICNFE    ºAutor  ³Gerson Ricardo Soeltl º Data ³  05/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para enviar informacoes para a nota fiscal de       º±±
±±º          ³ Entrada                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ 25.05.07 - Elias Reis - Modificacao da ordem de gravacao do  º±±
±±º          ³                         Array de retorno.                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                     

User function EICNFE(cHawb,cDoc,cSerie)

Local aRet        := {} 
Local aMsg        := {}
Local aOrd        := SaveOrd({"SWD","SWZ","SWN","SYB","SYT","SW6","EIH","EII"})
Local cFilSWN, cFilSWD, cFilSWZ, cFilSYB 
Local cCFO, nTotPIS, nTotCOF, nTotDesp, cCPOICM 
Local nQtdeEmb, cDescEmb, nPesoBru, nPesoLiq
Local cMoedaBr    := Alltrim(GetMv("MV_SIMB1",,"R$"))
Local cPicDesp    := AVSX3("WD_VALOR_R",AV_PICTURE)
Local nTamDesc    := AVSX3("YB_DESCR",AV_TAMANHO)
Local lTxSiscomex := .F.
Local cTxSiscomex := Alltrim(GetMv("MV_CODTXSI",,"415"))

Local aEIC := {}

DEFAULT cHawb  := SF1->F1_HAWB
DEFAULT cDoc   := SF1->F1_DOC
DEFAULT cSerie := SF1->F1_SERIE

if ValType(cHawb) == "U" .or. ValType(cDoc) == "U" .or. ValType(cSerie) == "U"
  Return {}
endif

if Empty(cHawb) .or. Empty(cDoc) .or. Empty(cSerie)
  Return {}
endif

nQtdeEmb := 0
cDescEmb := ""                    
nPesoBru := 0
nPesoLiq := 0 

SW6->(DbSetOrder(1))
if SW6->(DbSeek(xFilial("SW6")+cHawb))
  nPesoBru := SW6->W6_PESO_BR
  nPesoLiq := SW6->W6_PESOL
  Aadd(aMsg,"DI - " + Alltrim(TRANSFORM(SW6->W6_DI_NUM,AVSX3("W6_DI_NUM",AV_PICTURE)))) 
  
  //Verifica se possui o campo do ICMS na U.F.
  SYT->(DBSETORDER(1))
  if SYT->(dBSeek(xFilial("SYT")+SW6->W6_IMPORT))
     cCPOICM := "YB_ICMS_"+SYT->YT_ESTADO
     if SYB->(FIELDPOS(cCPOICM)) == 0
       MsgInfo("Necessario criar o campo '"+"YB_ICMS_"+SYT->YT_ESTADO+"',"+ ENTER +;
               "para a U.F. '"+ SYT->YT_ESTADO + "'."+ ENTER +;
               "Tipo Caracter, tamanho 01, Opcao 1=Sim;2=Nao","Atencao")
       Return {}
     endif           
  endif       
  
  //Busca das informacoes de Quantidade e Especie                
  EIH->(DbSetOrder(1))
  if EIH->(DbSeek(xFilial("EIH")+cHawb))
    nQtdeEmb := EIH->EIH_QTDADE
    cDescEmb := Alltrim(POSICIONE("SJF",1,xFilial("SJF")+EIH->EIH_CODIGO,"JF_DESC"))
  endif  
  
else
  Return {}  
endif  
     
cFilSWN := xFilial("SWN")
cFilSWD := xFilial("SWD")
cFilSWZ := xFilial("SWZ")
cFilSYB := xFilial("SYB") 
cTec := cCFO := ""
nTotDesp := nTotPIS := nTotCof := 0
                       
//Taxa Siscomex das despesas bancarias
//GRS 13/06/07
EII->(DbSetOrder(1))
if EII->(DbSeek(xFilial("EII")+cHawb+"7811"))
  if EII->EII_VLTRIB > 0
     Aadd(aMsg,INCSPACE("TAXA SISCOMEX",nTamDesc+1,.F.) + cMoedaBr + Space(1)+Alltrim(TRANSFORM(EII->EII_VLTRIB,cPicDesp)))
     nTotDesp += EII->EII_VLTRIB
     lTxSiscomex := .T.
  endif   
endif  

SWN->(DbSetOrder(1)) //WN_FILIAL+WN_DOC+WN_SERIE+WN_TEC
IF SWN->(DbSeek(cFilSWN+cDoc+cSerie))
  IF SWN->WN_TIPO_NF # "1" //GRS 13/06/2007 - Montar o array somente para NFE
    RestOrd(aOrd)
    Return {}
  Endif
Endif    
  
While !SWN->(EOF()) .AND. SWN->(WN_FILIAL+WN_DOC+WN_SERIE)==cFilSWN+cDoc+cSerie
  if Alltrim(cHawb) # Alltrim(SWN->WN_HAWB)
    SWN->(DBSKIP()) 
    Loop
  endif              
  if cCFO # SWN->(WN_CFO+WN_OPERACA)
    cCFO := SWN->(WN_CFO+WN_OPERACA)
    SWZ->(DbSetOrder(1)) //WZ_FILIAL+WZ_CFO+WZ_OPERACA
    if SWZ->(DbSeek(cFilSWZ+cCFO))
      if !Empty(SWZ->WZ_MSG_ICM)
        Aadd(aMsg,Alltrim(SWZ->WZ_MSG_ICM))
      endif
    endif
  endif      
  nTotPIS += SWN->WN_VLRPIS
  nTotCof += SWN->WN_VLRCOF
  SWN->(DBSKIP()) 
enddo

if nTotPis > 0 
  Aadd(aMsg,INCSPACE("PIS",nTamDesc+1,.F.)+cMoedaBr+Space(1)+Alltrim(TRANSFORM(nTotPIS,cPicDesp)))
endif
if nTotCOF > 0 
  Aadd(aMsg,INCSPACE("COFINS",nTamDesc+1,.F.)+cMoedaBr+Space(1)+Alltrim(TRANSFORM(nTotCOF,cPicDesp)))      
endif  

nTotDesp += nTotPIS + nTotCOF

SWD->(DbSetOrder(1)) //WD_FILIAL+WD_HAWB+WD_DESPESA+...
SWD->(DbSeek(cFilSWD+cHawb))
While !SWD->(EOF()) .AND. SWD->(WD_FILIAL+WD_HAWB) == cFilSWD+cHAWB
  if Alltrim(SWD->(WD_NF_COMP+WD_SE_NFC)) # Alltrim((cDoc+cSerie))
    SWD->(DbSkip())
    Loop
  endif
  
  if !lTxSiscomex
    lTxSiscomex := IF(Alltrim(SWD->WD_DESPESA) == cTxSiscomex, .T., .F.)
  else
    SWD->(DbSkip())  
  endif
    
  SYB->(DbSetOrder(1)) //YB_FILIAL+YB_DESP
  if SYB->(DbSeek(cFilSYB+SWD->WD_DESPESA))
    if SYB->YB_BASEICM == "1" .AND. SYB->&(cCPOICM) == "1"
      Aadd(aMsg,SYB->YB_DESCR+Space(1) + cMoedaBr + Space(1)+Alltrim(TRANSFORM(SWD->WD_VALOR_R,cPicDesp))) 
      nTotDesp += SWD->WD_VALOR_R
    endif
  endif  
  SWD->(DbSkip())
Enddo
 
aRet := {aMsg,;
			nQtdeEmb,; 	// Rodape - Campo quantidade
			cDescEmb,;	// Rodape - Campo Especie
			nTotDesp,; 	// Obs - Somatoria dos valores pagos (Pis/Cofins/Siscomex/Taxas... )
			nPesoLiq,;	// Rodape - Peso Liquido
			nPesoBru}	// Rodape - Peso Bruto   
			                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Elias Reis - 25.05.07 - Modifiquei o array de retorno para facilitar a manipulacao dos dados ³
//³                        Nas posicoes de 1 a 4, retorna valores fixos. Nas posicoes de 5 em   ³
//³                        diante, retornam mensagems do processo                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aEIC,nQtdeEmb)
aAdd(aEIC,cDescEmb)
aAdd(aEIC,nPesoLiq)
aAdd(aEIC,nPesoBru)
For n1:=1 To Len(aMSG)
    aAdd(aEIC,aMSG[N1])
Next
If nTotDesp>0     
	Aadd(aEIC,nTotDesp)
EndIf

RestOrd(aOrd)

//Return aRet 
REturn aEIC