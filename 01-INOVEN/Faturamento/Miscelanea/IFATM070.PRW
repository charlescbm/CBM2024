#INCLUDE "RWMAKE.CH"        

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! IFATM070													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Validação do campo CNPJ do prospect					 	! 
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria											!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 27/03/2024 												!
+-------------------+-----------------------------------------------------------+
*/
User Function IFATM070()        

//Local nOpc		:= ParamIxb[1]
//Local oModel	:= ParamIxb[2]
Local lRet	  	:= .T.

//if nOpc == 3	//se Inclusao
	//alert(oModelK:GetValue( "SUSMASTER", "US_CGC" ))
	xCNPJ := M->US_CGC

	// VERIFICA SE JÁ NÃO EXISTE CLIENTE COM O MESMO CNPJ/CPF
	SA1->(dbSetOrder(3))	// FILIAL+CGC
	IF SA1->(msSeek(XFILIAL('SA1') + xCNPJ))

		cCGC := ""
		IF LEN(ALLTRIM(SA1->A1_CGC))==14
			cCGC := "CNPJ "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")
		ELSE
			cCGC := "CPF "+TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99")
		ENDIF
		
		//APMSGALERT("Não é possível incluir este prospect pois já existe um cliente cadastrado com o "+cCGC+" ("+SA1->A1_COD+"/"+SA1->A1_LOJA+").","CPF/CNPJ EXISTENTE-"+ALLTRIM(PROCNAME())+"-TMKVA1")
		APMSGALERT("Este CNPJ/CPF já existe cadastro como cliente. Não será possível digitar essa informação.","CPF/CNPJ EXISTENTE-"+ALLTRIM(PROCNAME())+"-IFATM070")
		lRet := .F. 

	ENDIF

//endif

Return(lRet)
