#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA12   � Autor � AP6 IDE            � Data �  31/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Este programa gera um arquivo txt com informacoes de produ ���
���          � tos, seguindo layout fornecido pela TUPAN                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function BGPER002

Private cPerg	:= U_CriaPerg("BGPER002")
Private oGeraTxt
Private cString	:= "SRA"

dbSelectArea("SRA")
dbSetOrder(1) 




//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera��o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " Produtos, seguindo layout da Tupan.                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
//@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  31/05/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTxt

// Cria o arquivo texto                                               

Private nHdl    := fCreate("C:\TESTE.TXT")

If nHdl == -1
    MsgAlert("O arquivo nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//  Inicializa a regua de processamento
Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  31/05/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local nTamLin, cLin1, cLin2, cLin3, cCpo := ""    
Local aArray := {}
Local dDataBase := Date()
cNasc := ""
nIdade := 0
nCapacid := 1

dbSelectArea(cString)
dbSetOrder(1)
dbGoTop()

ProcRegua(RecCount()) // Numero de registros a processar  

cNasc := (cString)->RA_NASC
nIdade := YEAR(dDataBase) - YEAR(cNasc)	  

If nIdade >= 18
	nCapacid := 1
else
	nCapacid := 2
EndIf  


While !EOF()

    IncProc("Processando o Produto :" + (cString)->B1_COD)
    
    If !(Alltrim((cString)->B1_TIPO)=="PA").Or.(cString)->B1_MSBLQL=="1"
    	dbSkip()
    	Loop
    EndIf   
    		

    nTamLin := 421
    cLin1	:= Space(nTamLin) 

    clin1 := Stuff(cLin1,001,001, 	"1")//TIPO REGISTRO
    cLin1 := Stuff(cLin1,002,009,	"00"+(cString)->RA_MAT)//MATRICULA
    cLin1 := Stuff(cLin1,010,018,	SubStr((cString)->RA_CIC,1,09))//CGC/CPF
    cLin1 := Stuff(cLin1,019,022,	"00"+(cString)->RA_FILIAL)//FILIAL
    cLin1 := Stuff(cLin1,023,024,	SubStr((cString)->RA_CIC,9,02))//DIGITO VERIFICADOR CPF
    cLin1 := Stuff(cLin1,025,025,	Str(nCapacid))//CAPACIDADE CIVIL 
    cLin1 := Stuff(cLin1,026,026,	Str(nCapacid))//TIPO MOVIMENTO
    cLin1 := Stuff(cLin1,027,096,	(cString)->RA_NOME))//NOME FUNCIONARIO 
    cLin1 := Stuff(cLin1,097,136,	(cString)->RA_ENDEREC))//ENDERECO RESIDENCIAL
    cLin1 := Stuff(cLin1,137,143,	(cString)->RA_ENDEREC))//N�MERO RESIDENCIAL 

     
    
    
    
    
    
    //--continuar......
    
    
    
    cLin1 := Stuff(cLin1,072,096,	PADL((cString)->B1_DESC,25))
    cLin1 := Stuff(cLin1,097,195,	Space(100))
    cLin1 := Stuff(cLin1,196,201,	u_Tr((cString)->B1_IPI,	06))
    cLin1 := Stuff(cLin1,202,212,	u_Tr((cString)->B1_PESO,11))
    cLin1 := Stuff(cLin1,213,223,	u_Tr((cString)->B1_PESBRU,	11))
    cLin1 := Stuff(cLin1,224,262,	Space(39))
    cLin1 := Stuff(cLin1,263,411,	Space(149))
    cLin1 := Stuff(cLin1,412,421,	StrZero(Val((cString)->B1_POSIPI),8) + Space(2) )   
    
    
    nTamLin := 117
    cLin2   := Space(nTamLin)

	 clin2 := Stuff(cLin2,001,002,	"02")
    cLin2 := Stuff(cLin2,003,016,	"61105060000163")  
    cLin2 := Stuff(cLin2,017,031,	SubStr((cString)->B1_COD,1,15))    
    cLin2 := Stuff(cLin2,032,061,	"CAIXA                         ")
    cLin2 := Stuff(cLin2,062,063,	(cString)->B1_UM)
    cLin2 := Stuff(cLin2,064,071,	u_Tr((cString)->B1_QTDEMB,8)   )
    cLin2 := Stuff(cLin2,072,073,	(cString)->B1_UM)
	 cLin2 := Stuff(cLin2,074,084,	"0000000.000")
	 cLin2 := sTuff(cLin2,085,095,	"0000000.000")  
	 cLin2 := sTuff(cLin2,096,106,	"0000000.000")
	 cLin2 := sTuff(cLin2,107,117,	"0000000.000")	 	 
    


    nTamLin := 81 
    cLin3   := Space(nTamLin) // Variavel para criacao da linha do registros para gravacao

    clin3 := Stuff(cLin3,001,002,	"03")
    cLin3 := Stuff(cLin3,003,016,	"61105060000163")
    cLin3 := Stuff(cLin3,017,031,	SubStr((cString)->B1_COD,1,15))
    cLin3 := Stuff(cLin3,032,061,	"CAIXA                         ")
    cLin3 := Stuff(cLin3,062,081,	(cString)->B1_CODBAR + Space(20-Len((cString)->B1_CODBAR)) )
    
    // Gravacao no array que vai ser transferido para arquivo texto  
	
	 aAdd(aArray,{cLin1+Chr(13)+Chr(10),cLin2+Chr(13)+Chr(10),cLin3+Chr(13)+Chr(10)})

    dbSkip()
EndDo  


For i := 1 to 3

	If i == 1 
		For ix := 1 to Len(aArray)
    		If fWrite(nHdl,aArray[ix,i],Len(aArray[ix,i])) != Len(aArray[ix,i])
        		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
          		Exit
        		Endif
    		Endif	
		Next     
	Endif
	
	
	If i == 2 
		For ix:=1 to Len(aArray)
    		If fWrite(nHdl,aArray[ix,i],Len(aArray[ix,i])) != Len(aArray[ix,i])
        		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
           		Exit
        		Endif
    		Endif	
		Next
	EndIf
	

	If i == 3 	
		For ix:=1 to Len(aArray)
    		If fWrite(nHdl,aArray[ix,i],Len(aArray[ix,i])) != Len(aArray[ix,i])
        		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
           		Exit
        		Endif
    		Endif	
  		Next
  	Endif
	
Next


(cString)->(dbCloseArea())

fClose(nHdl)
Close(oGeraTxt)

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATA12   �Autor  �Microsiga           � Data �  06/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �ESTA FUNCAO CONVERTE UM VALOR PARA UM FORMATO DEFINIDO NO   ���
���          �LAYOUT DA TUPAN 1.32 -> 00001.320                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Tr(nValor, nTamanho)
Local cRet := ""

cRet		:= Alltrim(Transform(nValor, "9999999999.999"))
cInteira	:= Substr(cRet, 1, Len(cRet)-(3+1))
cInteira := StrZero(Val(cInteira),nTamanho-4)
cDecimal	:= Substr(cRet, Len(cRet)- 2, 3)
cRet		:= cInteira + "." + cDecimal

Return(cRet)