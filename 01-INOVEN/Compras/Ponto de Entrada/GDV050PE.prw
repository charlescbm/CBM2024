#include "protheus.ch"

// *********************************************************************** //
// GDV050PE - Pontos de Entrada utilizados no GDView NF-e XML              //
// @copyright (c) 2024-02-01 > Marcelo da Cunha > INOVEN                   //
// *********************************************************************** //

User Function GP050IMPX()
    ***********************
    LOCAL nTipo := paramixb[1] //Tipo Importacao
    LOCAL cDirOri := paramixb[2] //Diretorio Origem
    LOCAL cArqOri := paramixb[3] //Arquivo Origem
    LOCAL cDirDst := "\edi\cte" //Diretorio Destino
	If (nTipo == 1) //Importacao Ok XML
		If (ZGN->ZGN_modelo == "2") //CT-e
			//If (cEmpAnt == "01").and.(cFilAnt == "0102") //Itajai
             //   cDirDst += "\Itajai\"
			//Endif
            __CopyFile(cDirOri+cArqOri,cDirDst+cArqOri)
		Endif
	Endif
Return
