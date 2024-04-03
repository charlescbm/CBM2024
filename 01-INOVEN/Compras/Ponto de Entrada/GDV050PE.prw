#include "protheus.ch"

// *********************************************************************** //
// GDV050PE - Pontos de Entrada utilizados no GDView NF-e XML              //
// @copyright (c) 2024-02-01  Marcelo da Cunha > INOVEN                   //
// *********************************************************************** //

User Function GP050IMPX()
    ***********************
    LOCAL nTipo := paramixb[1] //Tipo Importacao
    LOCAL cDirOri := paramixb[2] //Diretorio Origem
    LOCAL cArqOri := paramixb[3] //Arquivo Origem
    LOCAL cDirDst := "\edi\cte\" //Diretorio Destino

    Local cAviso := ""
    Local cErro  := ""

	If (nTipo == 1) //Importacao Ok XML
		If (ZGN->ZGN_modelo == "2") //CT-e

            oXMLZ := XmlParser(ZGN->ZGN_XMLNFE,"_",@cAviso,@cErro)	
            if Type("oXMLZ:_CTEPROC") <> "U"
                oZXML := WSAdvValue( oXMLZ,"_CTEPROC","string",NIL,NIL,NIL,NIL,NIL)
            else
                oZXML := oXMLZ
            endif

            oZCTE := oZXML:_CTE

            xVTPrest := ""
            xUF := ""
            if Type("oZCTE:_INFCTE:_VPREST:_VTPREST") <> "U"
                xVTPrest := oZCTE:_INFCTE:_VPREST:_VTPREST:Text
            endif
            if Type("oZCTE:_INFCTE:_REM:_ENDERREME:_UF") <> "U"
                xUF := oZCTE:_INFCTE:_REM:_ENDERREME:_UF:Text
            endif

            if alltrim(xVTPrest) <> "0.01" .and. alltrim(xUF) <> "EX"
                __CopyFile(cDirOri+cArqOri,cDirDst+cArqOri)
            endif
		Endif
	Endif
Return
