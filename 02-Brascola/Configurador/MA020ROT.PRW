#include "Rwmake.ch" 
#include "Protheus.ch"
#include "Topconn.ch"    
#include "TbiConn.ch

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � BCFGV001    � Autor � Fernando S. maia   � Data � 16/11/11  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao de quem pode acessar o cadastro de Fornecedor     ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��                                                                         ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function MA020ROT()

Local aRotUser := {}

//Define Array contendo as Rotinas a executar do programa     
// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transacao a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs    

AAdd( aRotUser, { 'Documento', 'MsDocument('SA2', SA2->(recno()), 4)', 0, 4 } )

Return (aRotUser)

