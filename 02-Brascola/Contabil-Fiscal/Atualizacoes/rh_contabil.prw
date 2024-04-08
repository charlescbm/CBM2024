/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � deb_rh   � Autor � Gilberto Vanderlei    � Data � 05/10/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca a Conta Contabil gravada no campo RV_DEBITO da tabela���
���Descri��o � SRV - cadastro de Verbas                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � deb_rh()                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

user function deb_rh()

	cConta := space(20)
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada para a verba - " + SRZ->RZ_PD +" - "+ FDESC("SRV",SRZ->RZ_PD,"RV_DESC"))	
	endif  	

return(cConta)    



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � cre_rh   � Autor � Gilberto Vanderlei    � Data � 05/10/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Busca a Conta Contabil gravada no campo RV_CREDITO da tabela���
���Descri��o � SRV - cadastro de Verbas                                   ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � deb_rh()                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

user function cre_rh()

	cConta := space(20)
	cConta := FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO")
	if trim(cConta) = ""
	 	msgalert("Conta nao encontrada para a verba - " + SRZ->RZ_PD +" - "+ FDESC("SRV",SRZ->RZ_PD,"RV_DESC"))	
	endif  	

return(cConta)  


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � cc_deb_rh� Autor � Gilberto Vanderlei    � Data � 05/10/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se deve gravar o Centro de Custo a Debito no      ���
���Descri��o � lan�amento Contabil                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � cc_deb_rh()                                                ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

user function cc_deb_rh()

	cCC := space(10)
	cConta := ALLTRIM(FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO"))          
   cRecCC := FDESC("CT1",cConta,"CT1_CCOBRG")          

	if cRecCC = "1" 
       cCC:= SRZ->RZ_CC
    Else
    	cCC := space(1)
    endif 

return(cCC)    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � cc_cre_rh� Autor � Gilberto Vanderlei    � Data � 05/10/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se deve gravar o Centro de Custo a Debito no      ���
���Descri��o � lan�amento Contabil                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � cc_cre_rh()                                                ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

user function cc_cre_rh()

	cCC := space(10)
	cConta := ALLTRIM(FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO"))          
   cRecCC := FDESC("CT1",cConta,"CT1_CCOBRG")

	if cRecCC = "1" 
       cCC:= SRZ->RZ_CC
    Else
    	cCC := space(1)
    endif 

return(cCC)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � IT_DEB_rh� Autor � Gilberto Vanderlei    � Data � 05/10/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica se deve gravar o Centro de Custo a Debito no      ���
���Descri��o � lan�amento Contabil                                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � cc_cre_rh()                                                ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

user function IT_rh_deb()

  //cConta := ALLTRIM(FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO"))                                                       
     cLP  := (FDESC("SRV",SRZ->RZ_PD,"RV_LCTOP"))                                                       
     CConta  := Fdesc("CT5",cLP,"CT5_DEBITO")
   
   IF POSICIONE("CT1",1,XFILIAL("CT1")+alltrim(cConta),"CT1_ITOBRG")=="1"
   	dIt := "001"+SRZ->RZ_FILIAL+"0"
   else
   	dIt := " "
   Endif

return(dIt)

user function IT_rh_cred()

//	cConta := ALLTRIM(FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO"))                                                       
     cLP  := (FDESC("SRV",SRZ->RZ_PD,"RV_LCTOP"))                                                       
     CConta  := Fdesc("CT5",cLP,"CT5_CREDITO")

   IF POSICIONE("CT1",1,XFILIAL("CT1")+alltrim(cConta),"CT1_ITOBRG")=="1"
   	dIt := "001"+SRZ->RZ_FILIAL+"0"
   else
   	dIt := " "
   Endif

return(dIt) 






****************************************************
user function IT_rh_seg()

//cConta := ALLTRIM(FDESC("SRV",SRZ->RZ_PD,"RV_CREDITO")) 
cLP  := (FDESC("SRV",SRZ->RZ_PD,"RV_LCTOP"))                                                       
CConta  := Fdesc("CT5",cLP,"CT5_CREDITO")



 IF POSICIONE("CT1",1,XFILIAL("CT1")+CTK->CTK_CREDIT,"CT1_CLOBRG")=="1"
   	if alltrim(SRZ->RZ_CC) == '4346'
   	   dIt:= '006010' 
   	ELSEIF alltrim(SRZ->RZ_CC) == '4421'
   	    dIt:= '002060' 
   	ELSEIF alltrim(SRZ->RZ_CC) == '4423'
        dIt := '004010'
    ELSEIF alltrim(SRZ->RZ_CC) == '4424'
        dIt := '006010'
    ELSEIF alltrim(SRZ->RZ_CC) == '4425'
        dIt := '002060'
    ELSEIF alltrim(SRZ->RZ_CC) == '4426'
        dIt := '002060'
    ELSEIF alltrim(SRZ->RZ_CC) == '4429'
        dIt := '006010'
    Elseif alltrim(SRZ->RZ_CC) $ '4431*4432*4433*4434*4435*4436*4437'
        dIt := '001099'
    else 
       dIt := '009999'
    endif
 else
   	dIt := " "
 Endif

return(dIt)   

********************************************************
user function segdb()
 
 //cConta := ALLTRIM(FDESC("SRV",SRZ->RZ_PD,"RV_DEBITO"))   
 cLP  := (FDESC("SRV",SRZ->RZ_PD,"RV_LCTOP"))                                                       
 CConta  := Fdesc("CT5",cLP,"CT5_DEBITO")


 IF POSICIONE("CT1",1,XFILIAL("CT1")+CTK->CTK_DEBITO,"CT1_CLOBRG")=="1"
   	if alltrim(SRZ->RZ_CC) == '4346'
   	   dIt:= '006010' 
   	ELSEIF alltrim(SRZ->RZ_CC) == '4421'
   	    dIt:= '002060' 
   	ELSEIF alltrim(SRZ->RZ_CC) == '4423'
        dIt := '004010'
    ELSEIF alltrim(SRZ->RZ_CC) == '4424'
        dIt := '006010'
    ELSEIF alltrim(SRZ->RZ_CC) == '4425'
        dIt := '002060'
    ELSEIF alltrim(SRZ->RZ_CC) == '4426'
        dIt := '002060'
    ELSEIF alltrim(SRZ->RZ_CC) == '4429'
        dIt := '006010'
    Elseif alltrim(SRZ->RZ_CC) $ '4431*4432*4433*4434*4435*4436*4437'
        dIt := '001099'
   
    else 
       dIt := '009999'
    endif
 else
   
   	dIt := " "
 Endif

return(dIt)