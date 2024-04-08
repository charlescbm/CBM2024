#include "rwmake.ch"
#include "topconn.ch"
            
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTM01  �Autor  � Marcelo da Cunha   � Data �  16/04/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Job para atualizar custo standard dos tipos 1,2,3 e 4      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RESTM01()
*********************
LOCAL aParam := {}, dData

conout("================================================")
conout("> JOB ATUALIZACAO CUSTO STANDARD:"+dtoc(MsDate())+" "+Time())

RpcSetEnv("01","01","","","EST","",{"SB1","SB2","SD1","SF4","SF8"})
dData := MsDate()          

//���������������������������������������������
//� RESTC06 - Job para atualizar tipos 1,2,3  �
//���������������������������������������������
aParam := {}
aadd(aParam,ctod("01/01/2012")) //Data Inicial
aadd(aParam,LastDay(dData)) //Data Final
aadd(aParam,"1/2/3") //Considera Tipos 
aadd(aParam,"") //Desonsidera TES
aadd(aParam,1) //Totaliza Complementos
aadd(aParam,Replicate(" ",15)) //Produto De
aadd(aParam,Replicate("Z",15)) //Produto Ate
conout("> RESTC06 [Tipos:1,2,3]: "+dtoc(MsDate())+" "+Time())
u_RESTC06(@aParam)                              

//���������������������������������������������
//� MATA320 - Job para atualizar tipo 4       �
//���������������������������������������������
mv_par01 := 1 //Escolhe a moeda para atualizacao (1=nenhuma)
mv_par02 := 1 //Se deve considerar taxa diaria ou mensal (1/2)
mv_par03 := 2 //Calcula custos por: 1 Standard 2 Estrutura
mv_par04 := 1 //Se deve ou nao considerar o ultimo preco de compra
mv_par05 := dData //Data final a considerar
mv_par06 := "4 " //Tipo de produto inicial
mv_par07 := "4 " //Tipo de produto final
mv_par08 := "    " //Grupo de produto inicial
mv_par09 := "ZZZZ" //Grupo de produto final
mv_par10 := 1 //Considera Qtd. Neg.?
mv_par11 := 2 //Avisar divergencia? (Avisar) (Atualizar) (Nao atualizar)
mv_par12 := 2 //Seleciona Filial? (Sim) (Nao)
mv_par13 := 3 //Considera Mao de Obra? (Da Estrutura) (Rot. Operacoes) (Ambos)
conout("> MATA320 [Tipo:4]: "+dtoc(MsDate())+" "+Time())
MATA320()                                                                      

//���������������������������������������������
//� MATA320 - Job para atualizar tipo 3       �
//���������������������������������������������
mv_par01 := 1 //Escolhe a moeda para atualizacao (1=nenhuma)
mv_par02 := 1 //Se deve considerar taxa diaria ou mensal (1/2)
mv_par03 := 2 //Calcula custos por: 1 Standard 2 Estrutura
mv_par04 := 1 //Se deve ou nao considerar o ultimo preco de compra
mv_par05 := dData //Data final a considerar
mv_par06 := "3 " //Tipo de produto inicial
mv_par07 := "3 " //Tipo de produto final
mv_par08 := "    " //Grupo de produto inicial
mv_par09 := "ZZZZ" //Grupo de produto final
mv_par10 := 1 //Considera Qtd. Neg.?
mv_par11 := 2 //Avisar divergencia? (Avisar) (Atualizar) (Nao atualizar)
mv_par12 := 2 //Seleciona Filial? (Sim) (Nao)
mv_par13 := 3 //Considera Mao de Obra? (Da Estrutura) (Rot. Operacoes) (Ambos)
conout("> MATA320 [Tipo:3]: "+dtoc(MsDate())+" "+Time())
MATA320()                                                                      

conout("> FIM JOB ATUALIZACAO CUSTO STANDARD:"+dtoc(MsDate())+" "+Time())
conout("================================================")

Return