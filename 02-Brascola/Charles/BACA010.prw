#include "rwmake.ch"
#include "topconn.ch"
                
User Function BACA010()
*********************              

//RpcSetEnv("01","01","","","FIN","",{"SA1","SE1"})

cQuery1 := "SELECT SE1.R_E_C_N_O_ MRECSE1 FROM SE1010 SE1 "
cQuery1 += "WHERE SE1.D_E_L_E_T_ = '' AND SE1.E1_COMIS1 = 0 "
cQuery1 += "AND E1_VEND1 <> '' AND E1_EMISSAO > '20131101' AND E1_TIPO = 'NF' "
////////////////////////
//cQuery1 += "AND E1_NUM = '000046076'
////////////////////////
If (Select("MSE1") <> 0)
	dbSelectArea("MSE1")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSE1"
dbSelectArea("MSE1")
While !MSE1->(Eof())
	SE1->(dbGoto(MSE1->MRECSE1))
	//Function Fa440Comis(nRegistro,lGrava,lRefaz,nRegDevol,lCalcParc,nRecnoOrig)
	aBases := Fa440Comis(SE1->(Recno()),.T.,.T.,NIL,.F.)
	Reclock("SE1",.F.)
	If (SE1->E1_bascom1 == 0)
		SE1->E1_bascom1 := aBases[1,2]
	Endif
	If (SE1->E1_valcom1 == 0)
		SE1->E1_valcom1 := aBases[1,6]
	Endif
	If (SE1->E1_comis1 == 0).and.(aBases[1,2] > 0)
		SE1->E1_comis1 := Round((aBases[1,6]/aBases[1,2])*100,2)
	Endif
	MsUnlock("SE1")
	MSE1->(dbSkip())
Enddo
If (Select("MSE1") <> 0)
	dbSelectArea("MSE1")
	dbCloseArea()
Endif

Return