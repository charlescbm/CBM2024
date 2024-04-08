/*
Funcao      : BuscaDados
Objetivos   : Busca dados necessários e já cria aHeader e aCols 
Autor       : Kanaãm L. R. Rodrigues 
Data/Hora   : 13/08/2012
*/
*--------------------------------*
Static Function BuscaDados(cAlias)
*--------------------------------*   
Local cQry   := ""
Local aCpoD4 := {"D4_COD","D4_LOCAL","D4_OP",;
                 "D4_DATA","D4_QTDEORI","D4_QUANT",;
                 "D4_TRT","D4_LOTECTL","D4_NUMLOTE",;
                 "D4_DTVALID","D4_QTSEGUM","D4_POTENCI"}

If cAlias == "SD4"
   //DEFINIÇÃO DO AHEADERS
   SX3->(dbSetOrder(1))
   SX3->(dbSeek(cAlias))
   While !SX3->(Eof()) .AND. SX3->X3_ARQUIVO == cAlias
      If X3Uso(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .AND.;
         (aScan(aCpoD4,{|x| x==AllTrim(SX3->X3_CAMPO)})>0)
         If SX3->X3_CAMPO != "D4_QUANT"
            aAdd(aHeader,{Trim(X3Titulo()),;
                           SX3->X3_CAMPO,;
                           SX3->X3_PICTURE,;
                           SX3->X3_TAMANHO,;
                           SX3->X3_DECIMAL,;
                           SX3->X3_VALID,;
                           "",;
                           SX3->X3_TIPO,;
                           "",;
                           ""})
         Else
            aAdd(aHeader,{Trim(X3Titulo()),;
                           SX3->X3_CAMPO,;
                           SX3->X3_PICTURE,;
                           SX3->X3_TAMANHO,;
                           SX3->X3_DECIMAL,;
                           "U_ValD4Qnt()",;
                           "",;
                           SX3->X3_TIPO,;
                           "",;
                           ""})
            aAdd(aHeader,{Trim("Diferença"),;
                           "DIFERE",;
                           SX3->X3_PICTURE,;
                           SX3->X3_TAMANHO,;
                           SX3->X3_DECIMAL,;
                           "",;
                           "",;
                           SX3->X3_TIPO,;
                           "",;
                           ""})
         EndIf
      EndIf
      SX3->(dbSkip())
   EndDo

   //ADICIONA CAMPOS QUE PODERÃO SER ALTERADOS
   aAdd(aAlter, "D4_QUANT")

   //CRIA ACOLS COM OS DADOS RETORNADOS DA QUERY
   cQry += "SELECT SD4.D_E_L_E_T_, SD4.D4_FILIAL, SD4.D4_OP, SD4.D4_COD, "
   cQry += "       SD4.D4_LOCAL, SD4.D4_DATA, SD4.D4_QTDEORI, SD4.D4_QUANT, "
   cQry += "       SD4.D4_TRT, SD4.D4_LOTECTL, SD4.D4_NUMLOTE, "
   cQry += "       SD4.D4_DTVALID, SD4.D4_QTSEGUM, SD4.D4_POTENCI "
   cQry += "FROM "+RetSqlName("SD4")+" SD4 "
   cQry += "WHERE SD4.D_E_L_E_T_ <> '*' AND "
   cQry += "      SD4.D4_FILIAL = '"+xFilial("SD4")+"' AND "          
   cQry += "      SD4.D4_OP = '"+cOP+"' AND "
   cQry += "      SD4.D4_X_DOC = '' "
   cQry += "ORDER BY SD4.D4_OP, SD4.D4_COD"
   PlsQuery(cQry, "TRB")

   TRB->(dbGoTop())
   While TRB->(!Eof())
      aAdd(aCols,{TRB->D4_COD,;
                  TRB->D4_LOCAL,;
                  TRB->D4_OP,;
                  TRB->D4_DATA,;
                  TRB->D4_QTDEORI,;
                  TRB->D4_QUANT,;
                  TRB->(D4_QTDEORI-D4_QUANT),;
                  TRB->D4_TRT,;
                  TRB->D4_LOTECTL,;
                  TRB->D4_NUMLOTE,;
                  TRB->D4_DTVALID,;
                  TRB->D4_QTSEGUM,;
                  TRB->D4_POTENCI,;
                  .F.})
      aAdd(aQtx, {TRB->D4_QTDEORI,;
                  TRB->D4_QUANT})
      TRB->(dbSkip())
   EndDo
   TRB->(dbCloseArea())

   aColsAux := aClone(aCols)
Else
   aTam := TamSX3('D3_COD'    ); Aadd(aHeader2, {"Prod.Orig."      , 'D3_COD'    , PesqPict('SD3', 'D3_COD'    , aTam[1]         ),	aTam[1], aTam[2], 'A261VldCod(1)'                    , USADO, 'C', 'SD3', ''}) // 'Prod.Orig.'
   aTam := TamSX3('D3_DESCRI' ); Aadd(aHeader2, {"Desc.Orig."      , 'D3_DESCRI' , PesqPict('SD3', 'D3_DESCRI' , aTam[1]         ),	aTam[1], aTam[2], ''                                 , USADO, 'C', 'SD3', ''}) // 'Desc.Orig.'
   aTam := TamSX3('D3_UM'     ); Aadd(aHeader2, {"UM Orig."        , 'D3_UM'     , PesqPict('SD3', 'D3_UM'     , aTam[1], aTam[1]),	aTam[1], aTam[2], ''	                             , USADO, 'C', 'SD3', ''}) // 'UM Orig.'
   aTam := TamSX3('D3_LOCAL'  ); Aadd(aHeader2, {"Armazem Orig."   , 'D3_LOCAL'  , PesqPict('SD3', 'D3_LOCAL'  , aTam[1]         ),	aTam[1], aTam[2], 'A261Almox(1)'                   	 , USADO, 'C', 'SD3', ''}) // 'Almox Orig.'
   aTam := TamSX3('D3_LOCAL'  ); Aadd(aHeader2, {"Armazem Destino" , 'D3_LOCAL'  , PesqPict('SD3', 'D3_LOCAL'  , aTam[1]         ), aTam[1], aTam[2], 'A261Almox(2)'                  	 , USADO, 'C', 'SD3', ''}) // 'Almox Destino'
   aTam := TamSX3('D3_QUANT'  ); Aadd(aHeader2, {"Quantidade"      , 'D3_QUANT'  , PesqPict('SD3', 'D3_QUANT'  ,  			     ), aTam[1], aTam[2], 'A261QtdGra(1).and.A261Quant(.T.)' , USADO, 'N', 'SD3', ''}) // 'Quantidade'
   aTam := TamSX3('D3_LOCALIZ'); Aadd(aHeader2, {"Endereco Orig."  , 'D3_LOCALIZ', PesqPict('SD3', 'D3_LOCALIZ', aTam[1]         ), aTam[1], aTam[2], 'A261Locali(1)'                    , USADO, 'C', 'SD3', ''}) // 'Localiz.Orig.'
   aTam := TamSX3('D3_COD'    ); Aadd(aHeader2, {"Prod.Destino"    , 'D3_COD'    , PesqPict('SD3', 'D3_COD'    , aTam[1]         ),	aTam[1], aTam[2], 'A261VldCod(2)'                 	 , USADO, 'C', 'SD3', ''}) // 'Prod.Destino'
   aTam := TamSX3('D3_DESCRI' ); Aadd(aHeader2, {"Desc.Destino"    , 'D3_DESCRI' , PesqPict('SD3', 'D3_DESCRI' , aTam[1]         ),	aTam[1], aTam[2], ''                              	 , USADO, 'C', 'SD3', ''}) // 'Desc.Destino'
   aTam := TamSX3('D3_UM'     ); Aadd(aHeader2, {"UM Destino"      , 'D3_UM'     , PesqPict('SD3', 'D3_UM'     , aTam[1], aTam[1]),	aTam[1], aTam[2], ''           	                 	 , USADO, 'C', 'SD3', ''}) // 'UM Destino'
   aTam := TamSX3('D3_LOCALIZ'); Aadd(aHeader2, {"Endereco Destino", 'D3_LOCALIZ', PesqPict('SD3', 'D3_LOCALIZ', aTam[1]         ), aTam[1], aTam[2], 'A261Locali(2)'                    , USADO, 'C', 'SD3', ''}) // 'Localiz.Destino'
   aTam := TamSX3('D3_NUMSERI'); Aadd(aHeader2, {"Numero Serie"    , 'D3_NUMSERI', PesqPict('SD3', 'D3_NUMSERI', aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'C', 'SD3', ''}) // 'N£mero Serie'
   aTam := TamSX3('D3_LOTECTL'); Aadd(aHeader2, {"Lote"            , 'D3_LOTECTL', PesqPict('SD3', 'D3_LOTECTL', aTam[1]         ), aTam[1], aTam[2], 'A261Lote()'                       , USADO, 'C', 'SD3', ''}) // 'Lote'
   aTam := TamSX3('D3_NUMLOTE'); Aadd(aHeader2, {"Sub-Lote"        , 'D3_NUMLOTE', PesqPict('SD3', 'D3_NUMLOTE', aTam[1]         ), aTam[1], aTam[2], 'A261Lote()'                       , USADO, 'C', 'SD3', ''}) // 'Sub-Lote'
   aTam := TamSX3('D3_DTVALID'); Aadd(aHeader2, {"Validade"        , 'D3_DTVALID', PesqPict('SD3', 'D3_DTVALID', aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'D', 'SD3', ''}) // 'Validade'
   aTam := TamSX3('D3_POTENCI'); Aadd(aHeader2, {"Potencia"        , 'D3_POTENCI', PesqPict('SD3', 'D3_POTENCI', aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'N', 'SD3', ''}) // 'Potencia'
   aTam := TamSX3('D3_QTSEGUM'); Aadd(aHeader2, {"Qt 2aUM"         , 'D3_QTSEGUM', PesqPict('SD3', 'D3_QTSEGUM',         		 ), aTam[1], aTam[2], 'A261QtdGra(1).and.A261Quant(.T.)' , USADO, 'N', 'SD3', ''}) // 'Qt 2aUM'
   aTam := TamSX3('D3_ESTORNO'); Aadd(aHeader2, {"Estornado"       , 'D3_ESTORNO', PesqPict('SD3', 'D3_ESTORNO', aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'C', 'SD3', ''}) // 'Estornado'
   aTam := TamSX3('D3_NUMSEQ' ); Aadd(aHeader2, {"Sequencia"       , 'D3_NUMSEQ' , PesqPict('SD3', 'D3_NUMSEQ' , aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'C', 'SD3', ''}) // 'Sequencia'
   aTam := TamSX3('D3_LOTECTL'); Aadd(aHeader2, {"Lote Destino"    , 'D3_LOTECTL', PesqPict('SD3', 'D3_LOTECTL', aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'C', 'SD3', ''})
   aTam := TamSX3('D3_DTVALID'); Aadd(aHeader2, {"Validade Destino", 'D3_DTVALID', PesqPict('SD3', 'D3_DTVALID', aTam[1]         ), aTam[1], aTam[2], 'A261DtPot(3)'                     , USADO, 'D', 'SD3', ''}) // 'Validade Destino'
   aTam := TamSX3('D3_ITEMGRD'); Aadd(aHeader2, {"Item Grade"      , 'D3_ITEMGRD', PesqPict('SD3', 'D3_ITEMGRD', aTam[1]         ), aTam[1], aTam[2], ''                                 , USADO, 'C', 'SD3', ''}) // 'Sequencia'

   For i:=1 To Len(aCols)
      SB1->(dbSeek(xFilial("SB1")+AvKey(aCols[i][nPosCod],"B1_COD")))
      aAdd(aCols2, {aCols[i][nPosCod],;  //Prod Origem
                    SB1->B1_DESC,;       //Descrição
                    SB1->B1_UM,;         //Unid Medida
                    cArmOri,;            //Armazem origem
                    cArmDes,;            //Armazém destino
                    aCols[i][nPosQuant],;//Quantidade
                    "",;                 //End. Origem
                    aCols[i][nPosCod],;  //Prod Dest.
                    SB1->B1_DESC,;       //Descrição
                    SB1->B1_UM,;         //Unid Medida
                    "",;                 //End. Dest.
                    "",;                 //Num. Serie
                    "",;                 //Lote
                    "",;                 //Sub-Lote
                    STOD(""),;           //Validade
                    0,;                  //Potencia
                    0,;                  //Qtde 2ª UM
                    "",;                 //Estornado
                    "",;                 //Seq.
                    "",;                 //Lote Dest.
                    STOD(""),;           //Valid Dest.
                    "",;                 //Item Grade
                    .F.})                //Delete
   Next i                   
EndIf
//
Return