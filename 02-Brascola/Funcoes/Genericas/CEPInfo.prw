#INCLUDE "PROTHEUS.CH"

#DEFINE STR0001 "Informe a Nota Fiscal"
#DEFINE STR0002 "Consulta de Protocolo"
#DEFINE STR0003	"PROT"
#DEFINE STR0004 "Codigo" //Cidade
#DEFINE STR0005	"Descricao" //Bairro
//#DEFINE STR0006 "Tipo de Logradouro"
//#DEFINE STR0007 "Logradouro"
#DEFINE STR0008 "Resultado da Consulta"
#DEFINE STR0009 "NF"
#DEFINE STR0010 "Mensagem"
#DEFINE STR0011 "Consultar Novo Protocolo?"
#DEFINE STR0012 "Consultando Protocolo"
#DEFINE STR0013 "Aguarde..."

/*/
	Funcao: PROTInfo
	Autor:	Fernando Maia
	Data:	19/08/13
	Uso:	Consulta de Protocolo
	Obs.:	Exemplo de Consumo do WEB Service u_wsPROTInfo para Consulta de Protocolo ao NFE Sefaz (TSS)
/*/
User Function PROTInfo()

	Local aPerg			:= {}
	Local aResult		:= {}
	
	Local bPROTSearch
	
	Local cXML

	Local cError		:= ""
	Local cWarning		:= ""

	//Local cNF
	//Local cCidade
	//Local cBairro
	Local cMensagem
	Local cResultado
	//Local cLogradouro
	//Local cTpLogradouro

	Local oWSPROT
	Local oXML

	BEGIN SEQUENCE
	
		aAdd( aPerg , { 1 , STR0002 , Space(9) , "999999999" , ".T." , "" , ".T." , 9 , .T. } ) //"Informe a Nota Fiscal"
		IF ParamBox( @aPerg , STR0002 , NIL , NIL , NIL , .T. )
			
			bPROTSearch := { ||											; 
								oWSPROT 		:= WSU_WSPROTINFO():New(),	;
								oWSPROT:cPROT	:= MV_PAR01,				;
								oWSPROT:PROTSEARCH()						;
						   }	

			MsgRun( STR0013 , STR0012 , bPROTSearch ) //"Aguarde"###"Consultando PROTOCOLO"

			cXML		:= oWSPROT:cPROTSEARCHRESULT
			oXML		:= XmlParser( cXML , "_" , @cError , @cWarning )
	             		
			cResultado	:= oXml:_WebServiceProt:_Resultado:Text
			cMensagem	:= oXml:_WebServiceProt:_Resultado_Txt:Text
	
			IF ( cResultado == "1" )
	
				cNF				:= oXml:_WebServiceProt:_NF:Text
				cCodigo			:= oXml:_WebServiceProt:_Codigo:Text
				cDescricao		:= oXml:_WebServiceProt:_Descricao:Text
				//cLogradouro		:= oXml:_WebServiceProt:_Logradouro:Text
				//cTpLogradouro	:= oXml:_WebServiceProt:_Tipo_Logradouro:Text

				aAdd( aResult , { 1 , STR0009 , MV_PAR01		, "999999999"	, ".T." , "" , ".F." , 08	, .F. } ) //"NF"
				aAdd( aResult , { 1 , STR0003 , cPROT 	  		, "@"			, ".T." , "" , ".F." , 04 	, .F. } ) //"PROT"
				aAdd( aResult , { 1 , STR0004 , cCodigo			, "@"			, ".T." , "" , ".F." , 100	, .F. } ) //"Codigo"
				aAdd( aResult , { 1 , STR0005 , cDescricao		, "@" 		 	, ".T." , "" , ".F." , 100	, .F. } ) //"Descricao"
				//aAdd( aResult , { 1 , STR0006 , cTpLogradouro	, "@" 		 	, ".T." , "" , ".F." , 100	, .F. } ) //"Tipo de Logradouro"
				//aAdd( aResult , { 1 , STR0007 , cLogradouro		, "@"			, ".T." , "" , ".F." , 100	, .F. } ) //"Logradouro"

			Else
			
				aAdd( aResult , { 1 , STR0009 , MV_PAR01		, "999999999" 	, ".T." , "" , ".F." , 08	, .F. } ) //"NF"
	
			EndIF

			ParamBox( @aResult , STR0008 + " : " + cMensagem , NIL , NIL , NIL , .T. )	//"Resultado da Consulta"


			IF !( MsgNoYes( "Consultar Novo Protocolo?" , ProcName() ) )
				BREAK
			EndIF
	
			U_PROTInfo()
	
		EndIF

	END SEQUENCE

Return( MBrChgLoop( .F. ) )