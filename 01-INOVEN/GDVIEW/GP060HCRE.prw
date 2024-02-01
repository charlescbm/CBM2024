#INCLUDE "rwmake.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! F200VAR													!
+-------------------+-----------------------------------------------------------+
!Descricao			! O ponto de entrada F200VAR do CNAB a receber sera 		!
!					! executado apos carregar os dados do arquivo de recepcao 	!
!					! bancaria e sera utilizado para alterar os dados recebidos.!
!					+-----------------------------------------------------------+
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 07/07/2008												!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

// Adicionar campos na planilha do contas a receber 
User Function GP060HCRE()
    ********************
    LOCAL aHdrCre := {}, aSX3 := FWTamSX3("E1_SALDO")
    GDVFW():addHdr(@aHdrCre,{"MSTATUS","E1_FILORIG","E1_PORTADO","E1_SITUACA","E1_NUMBOR","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO","E1_CLIENTE","E1_LOJA","E1_NOMCLI","A1_XCOLIG","E1_EMISSAO","E1_VENCTO","E1_VENCREA","E1_VALOR","E1_SALDO","E1_XCGCCLI"})
    aadd(aHdrCre,{"A Receber","MRECEBER",PesqPict("SE1","E1_SALDO"),aSX3[1],aSX3[2],"","","N","",""})
    GDVFW():addHdr(@aHdrCre,{"E1_BAIXA","E1_CARTA","E1_HIST","E1_PEDIDO","E1_GDVPROJ","E1_SERIE","E1_BORDERO","E1_VEND1","E1_FILIAL","E1_FLUXO","E1_IRRF","E1_CSLL","E1_PIS","E1_COFINS"})
Return aHdrCre
