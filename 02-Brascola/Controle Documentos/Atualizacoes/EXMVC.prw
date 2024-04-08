
#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function EXMVC()

oBrowse := FWMBrowse():New() 
oBrowse:SetAlias('SA3')
oBrowse:SetDescription('Cadastro de Vendedores MVC')
oBrowse:AddLegend( "A3_MSBLQL=='1'", "YELLOW", "Inativo" )
oBrowse:AddLegend( "A3_MSBLQL=='2'", "BLUE"  , "Ativo" )  
//oBrowse:SetFilterDefault("A3_MSBLQL=='2'")
oBrowse:DisableDetails()


oBrowse:Activate()

Return nil

