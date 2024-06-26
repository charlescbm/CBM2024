#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#include "topconn.ch"   

User Function EXMVC3()    

cQuery := ""                      
cQuery += "SELECT RA_MAT AS MATRICULA, RA_NOME AS NOME, RA_SITFOLH AS SITUACAO FROM SRA010 WHERE D_E_L_E_T_ <> '*' AND RA_FILIAL = '01' "              

If Select("TMP") <> 0
	dbSelectArea("TMP")
	dbCloseArea()
Endif              

TCQuery cQuery NEW ALIAS "TMP" 
DbSelectArea("TMP")
DbGoTop()



//instancia a classe
 oBrowse:=FWMBrowse():New()

//descri��o do browse
 oBrowse:SetDescription('FWMBrowse com Arquivo Tempor�rio')

//tabela temporaria
 oBrowse:SetAlias('TMP')

 //define as colunas para o browse
 aColunas:={; 
 			{"Matricula" ,"MATRICULA" ,"C", 8,0,"@!"},;
 			{"Nome"      ,"NOME"      ,"C",40,0,"@!"},;
 			{"Situa��o"  ,"SITUACAO"  ,"C",15,0,""}}



//seta as colunas para o browse
 oBrowse:SetFields(aColunas)

//define as legendas
 oBrowse:AddLegend('SITUACAO ==  "D" ',"BR_VERDE"   ,"DESLIGADO")
 oBrowse:AddLegend('SITUACAO !=  "D" ',"BR_VERMELHO","ATIVO")

//abre o browse
 oBrowse:Activate()
                    
Return nil