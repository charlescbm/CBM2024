#include 'protheus.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	                 		!
+-------------------------------------------------------------------------------+
!Programa			! UINOV005 - Programa carga contas a receber - INOVEN	! 
+-------------------+-----------------------------------------------------------+
!Descricao			! Rotina para processar os arquivos .csv manualmente				!
+-------------------+-----------------------------------------------------------+
!Autor         	! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 29/05/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UINOV005( cFileCsv )

Local nX

Default cFileCsv := ""

if empty(cFileCsv)
	Aviso("Cargas Manuais INOVEN -> Protheus", "NENHUM ARQUIVO INFORMADO PARA PROCESSAR", {"Ok"}, 2)
	Return( .F. )
endif

PRIVATE lMsErroAuto    := .F.
PRIVATE lAutoErrNoFile := .T.

Private cNomeArq := alltrim(cFileCsv)

// Abre o arquivo de clientes de__para__
nHdlCli := FT_FUse("\cargas\cli_de_para.csv")
// Se houver erro de abertura abandona processamento
if nHdlCli = -1  
	return
endif
// Posiciona na primeria linha
FT_FGoTop()

aCabecCli := {}
cCabecCli := ""
cLineCli  := ReadLine() // Pega primeira Linha
if substr(cLineCli,1,6)=='CODPES'
	aCabecCli := Separa(cLineCli,';',.t.)
	cCabecCli := cLineCli
endif
// Pula uma linha que é o cabeçalho.
FT_FSKIP()

aCLiDP := {}
cLineCli := ReadLine()
While !FT_FEOF()   

	aDados := Separa(cLineCli,';',.t.)
	aadd(aCLiDP,aDados)

	// Pula para próxima linha  
	FT_FSKIP()
	cLineCli := ReadLine()
End
// Fecha o Arquivo
FCLOSE(nHdlCli)
//FIM
//alert(len(aCLiDP))


// Abre o arquivo
oFile := FWFileReader():New(cFileCsv)

If (!oFile:Open())
	Aviso("Cargas Manuais INOVEN -> Protheus", "NAO FOI POSSIVEL ABRIR O ARQUIVO INFORMADO!", {"Ok"}, 2)
	Return( .F. )
endif


aCabec := {}
cCabec := ''
nCont := 1
lErro := .F.

lNovoF := .F.
cNovoF := ''

lSemDP := .F.
cSemDP := ''

cCliErr := ''
nLinha := 0
While oFile:hasLine()

	cLine := oFile:GetLine()
	if empty(nLinha)

		if upper(substr(cLine,1,3))=='E1_'
			aCabec := Separa(cLine,';',.t.)
			cCabec := cLine
		endif
		nLinha := 1
		
	else

		//E1_NUM;E1_PARCELA;CODCLI;E1_VALOR;VLDESCONTADO;VLRLIQ;SALDO;E1_VENCTO;LIQUIDADO;DESCONTADO;E1_PORTADO;E1_SITUACA

		//if nCont > 26
		//	exit
		//endif
		
		lMsErroAuto := .F.
	
		//Prepara os dados em uma matriz
		aDados := Separa(cLine,';',.t.)

		lErro := .F.

		//Verificar o cliente
		nPosCli := Ascan(aCLiDP,{|e| alltrim(e[1]) == alltrim(aDados[3])})
		if !empty(nPosCli)
			cCgcCli := aCLiDP[nPosCli][3]
			cCgcCli := strTran(cCgcCli,".","")
			cCgcCli := strTran(cCgcCli,"-","")
			cCgcCli := strTran(cCgcCli,"/","")

			SA1->(dbSetOrder(3))
			if !SA1->(msSeek(xFilial('SA1') + cCgcCli))
				
				if !lNovoF
					lNovoF := .T.

					cTime := strTran(time(),':','')
					nHdlnew := FCREATE('\cargas\titulos_receber_'+dtos(dDatabase)+'_'+cTime+'.csv')
					cNovoF := '\cargas\titulos_receber_'+dtos(dDatabase)+'_'+cTime+'.csv'
					if nHdlnew = -1  
						return
					endif
					fWrite( nHdlnew ,cCabec + chr(13) + chr(10))

				endif
				fWrite( nHdlnew ,cLine + chr(13) + chr(10))
				
				//alert('nao existe cliente CGC: ' + cCgcCli)
				lErro := .T.
			endif
		else
			
			if !lSemDP
				lSemDP := .T.

				cTime := strTran(time(),':','')
				nHdlsemdp := FCREATE('\cargas\titulos_receber_semdepara_'+dtos(dDatabase)+'_'+cTime+'.csv')
				cSemDP := '\cargas\titulos_receber_semdepara_'+dtos(dDatabase)+'_'+cTime+'.csv'
				if nHdlsemdp = -1  
					return
				endif
				fWrite( nHdlsemdp ,cCabec + chr(13) + chr(10))

			endif
			fWrite( nHdlsemdp ,cLine + chr(13) + chr(10))
			
			//alert('nao achou cliente no de__para___')
			lErro := .T.
		endif

		if !lErro .and. !empty(len(aDados))
			//alert('Cliente: '+sa1->a1_cod+'/'+sa1->a1_loja+' - '+sa1->a1_nome)

			cPrf  := 'CON'
			cNat  := '1.2.1.01'
			cTipo := 'NF '
			cHist := 'VIA CONVERSAO DE DADOS'
			nValor := strTran(alltrim(aDados[4]),',','.')
			dEmis := ctod(aDados[12])

			cBanco := strzero(val(alltrim(aDados[11])),3)
			SA6->(dbSetOrder(1))
			SA6->(msSeek(xFilial('SA6')+cBanco))
			
			aVetor :={	{"E1_PREFIXO",cPrf				,Nil},;
				    	{"E1_NUM"	 ,strzero(val(aDados[1]),9)	,Nil},;
				    	{"E1_PARCELA",aDados[2]			,Nil},;
					    {"E1_TIPO"   ,cTipo  			,Nil},;
			      	    {"E1_NATUREZ",cNat   			,Nil},;
				    	{"E1_CLIENTE",SA1->A1_COD      	,Nil},;
			  	        {"E1_LOJA"   ,SA1->A1_LOJA     	,Nil},;
					    {"E1_EMISSAO",iif(empty(dEmis),ctod('01/06/2021'), dEmis)	,Nil},;
			         	{"E1_VENCTO" ,ctod(aDados[8])	,Nil},;
					    {"E1_HIST" 	 ,cHist				,Nil},;
			      	    {"E1_VALOR"  ,val(nValor)		,Nil},;
						{"E1_PORTADO",SA6->A6_COD		,Nil},;  
						{"E1_AGEDEP" ,SA6->A6_AGENCIA	,Nil},;  
						{"E1_CONTA"  ,SA6->A6_NUMCON	,Nil},; 
						{"E1_SITUACA",'1'			    ,Nil},;  
			           	{"E1_VLCRUZ" ,val(nValor)	  	,Nil}}


			Begin Transaction
		
				SE1->(dbSetOrder(1))
				if !SE1->(msSeek(xFilial("SE1") + cPrf + strzero(val(aDados[1]),9) + padr(aDados[2],tamsx3('E1_PARCELA')[1]) + cTipo))
					MsAguarde({|lEnd| FINA040(aVetor,3) },"Aguarde...","Criando Titulos a Receber",.T.)
					If lMsErroAuto
						aErro := GetAutoGRLog()
						cErro := ''	//'<pre>'
						For nX := 1 To Len(aErro)
							cErro += aErro[nX] 	+ " "	//+ Chr(13)+Chr(10)
						Next nX
						
						conout(cErro)
					else
						if alltrim(aDados[13]) == '2'
							nValor := strTran(alltrim(aDados[5]),',','.')
							SE1->(recLock('SE1', .F.))
							//SE1->E1_BAIXA	:= ctod(aDados[10])
							SE1->E1_MOVIMEN	:= ctod(aDados[10])
							SE1->E1_SITUACA := '2'
							//SE1->E1_SALDO	:= 0
							//SE1->E1_VALLIQ	:= val(nValor)
							SE1->E1_FLUXO	:= 'S'
							SE1->(msUnlock())
						endif
					EndIf
				endif
		
			End Transaction
			
		endif
		nCont++
	
	endif

End
// Fecha o Arquivo
oFile:Close()

if lNovoF
	fClose(nHdlnew)
	ApMsgAlert("Existem titulos que nao foram importados por falta de clientes. Arquivo novo gerado: "+cNovoF,"ATENÇÃO - "+ProcName())
endif

if lSemDP
	fClose(nHdlsemdp)
	ApMsgAlert("Existem titulos que nao foram importados por nao encontrar relacao nos clientes de__para__. Arquivo novo gerado: "+cSemDP,"ATENÇÃO - "+ProcName())
endif

lRet := iif(!empty(len(aCabec)), .T., .F.)

return( lRet )



Static Function ReadLine()
	
	Local cBufAux := ""
	Local cBuffer := ""
	
	cBufAux := FT_FReadLn()
	//alert(cBufAux)
	
	While Len(cBufAux) == 1023
		
		cBuffer += cBufAux
		
		FT_FSKIP()
		
		cBufAux := FT_FReadLn()
		
	EndDo
	
	cBuffer += cBufAux
	
Return( cBuffer )

Static Function ConvType(xValor,nTam,nDec)

Local cNovo	:= ""
DEFAULT nDec	:= 0
Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase

Return(cNovo)

Static Function goVerSA1( cE1Cli )
xTxt := '107400;102723|103981;101545|107482;106795|104797;104112|106321;106320|205565;205172|206656;206510|206924;206510|100903;100006|301782;300003|205329;203704|107670;102815|104413;101968|106329;104247|204790;202937|100913;100050|206903;204002|205267;205033|205057;202937|100899;100071|106285;100074|105158;101229|105446;105366|300017;300016|106019;106018|100933;100083|203949;203577|100093;100089|105115;100090|106775;102878|300871;206688|204628;202441|204637;204572|204892;204581|206742;204581|205324;200082|104338;102544|205520;201648|105198;105177|107752;101203|300251;200106|107820;107819|106035;106304|106580;101925|106297;106296|106796;103729|106952;105233|107736;107734|107190;101918|108000;107073|104460;101134|203640;203057|105110;104823|107196;104723|106214;104795|205743;203057|105159;101491|105954;102143|107968;101332|205990;205850|107879;103805|102488;101231|204151;201345|106450;104824|107972;100214|103841;103262|106237;100208|104155;100219|107145;102241|101030;100189|100200;100192|100202;100193|103854;102346|105464;101376|106455;101114|106456;101114|104927;104615|105242;102264|107906;107905|107984;106619|105726;100925|100966;100917|100216;100182|105835;101678|105112;102906|100228;100212|106915;103737|105547;105461|203462;202840|105974;105970|105996;102513|107214;107213|104818;103237|104154;101710|100936;100261|104764;100963|300051;300050|105212;100272|206435;206433|105796;104380|100907;100165|106405;104343|106192;106036|205473;205133|106286;104388|204895;201172|107457;104384|205655;200214|'+;
'105126;100297|106780;106778|107971;106446|205046;202529|203928;200910|205601;203526|205065;203163|205031;204545|106567;101290|106585;101290|103985;101308|206828;206771|206594;206113|102342;101312|105157;100309|105527;103169|105118;100315|107426;106978|105667;105537|106263;104389|106038;106037|106261;102733|104266;104131|106282;106228|206585;204533|206564;206218|300274;200293|200296;200295|105121;101035|206000;201983|206063;205993|105357;103289|107981;107800|204721;202688|205826;201149|205513;202139|203759;201124|204506;201341|206366;203550|104718;100906|104509;104135|107138;100006|104946;104892|106471;106470|104706;101298|300306;206697|206830;206640|206942;205138|105181;104041|101019;100397|108087;104604|107315;106861|101042;100399|103878;102430|105709;104347|107189;106064|105707;103677|104871;103574|301212;200380|104629;103995|107717;105665|100433;100234|204006;203985|107208;107166|206358;205663|204968;202942|205570;200394|105824;100441|301207;300248|104619;102700|204698;202356|105867;102015|103007;100456|204932;204578|104320;100462|302332;206769|101046;100468|205748;205716|206817;201262|301237;205283|204358;203885|205237;205236|205148;201764|206394;201764|107476;105560|106519;106517|300380;300312|301807;200464|203458;203075|302121;204763|205615;204763|300118;300116|206355;205566|107689;107658|107675;107051|105277;103912|205616;205112|300280;300252|105416;101006|106349;103359|106304;106303|105983;105971|205342;202939|103986;103968|105396;104999|104281;100539|104121;100540|106469;100540|200888;200530|'+;
'206445;201717|105538;104318|100892;100547|106236;100600|107669;101696|107533;101283|104425;101400|104081;101206|103901;103806|105124;100585|104598;103923|206378;206283|107254;100572|104488;101914|204972;200957|104810;104809|300821;300142|301909;300142|300143;300142|300145;300142|300237;300142|300144;300142|300310;206916|107696;104796|103845;103811|107677;103043|105068;105064|106973;105064|106411;105985|105795;104470|106245;105620|105945;100390|106572;101906|106056;106055|106058;106057|107496;102756|106078;100976|105472;100453|107804;107450|106283;105960|106010;105960|106475;106474|106784;106783|107399;105723|105822;105730|104577;103606|105463;100833|105846;103857|107880;102604|106120;101919|106305;100951|105160;100637|104448;101891|206580;205153|106576;105718|106021;100048|100675;100651|107761;102600|107325;106368|105221;101343|105728;101343|300270;200069|206108;200908|206882;201184|107899;103004|105087;101235|105950;104744|106426;106424|106352;103358|205526;201532|107412;100665|107428;103092|102813;100800|107562;107073|106260;104839|107854;106050|203155;203154|106521;102862|205481;203014|205911;204945|206645;201774|105471;105370|105963;104050|105745;104642|104952;102757|105933;105567|105508;105423|105633;105603|203793;203119|206566;206128|104210;103194|100700;100233|104055;103801|106531;100652|105220;101109|300775;202129|107194;106762|204573;201591|205530;200713|105334;104086|204835;204273|107401;101893|106575;103017|205337;202905|105465;100715|204487;201491|206314;205398|105447;105420|105301;102547|'+;
'107897;104354|105483;101718|107460;105651|107053;107049|105980;105964|103832;102229|105007;100173|204743;202653|203734;203681|106438;106437|106440;106439|204652;200765|105404;105393|206002;200909|105949;105943|106790;106072|100777;100225|105367;102661|106537;101704|106454;106453|105510;104628|106534;105797|106541;105797|107666;104559|105864;105640|105992;105640|107575;106600|105092;105060|105102;105060|104537;101070|106406;105365|100981;100960|101168;100960|107236;103668|101017;100881|105929;104333|107723;104232|106153;102669|105917;103294|105479;102672|100809;100785|105901;102225|107764;103201|107495;104935|103844;101649|104971;101171|105466;100924|200783;200776|102404;102210|106763;102037|104529;102145|101007;100297|107192;102280|106115;103634|101004;100843|106461;105010|106031;106030|205505;204828|100850;100812|101013;100059|302345;203382|203496;201187|206672;202909|100862;100233|104332;100872|100878;100217|101016;100968|105873;105868|106594;106593|205331;205211|206009;205211|105779;105735'
aClis := separa(xTxt, '|', .T.)
nPos := ASCAN(aClis, { |x| substr(x,1,6) == cE1Cli })
cCdRet := ''
if !empty(nPos)
	nPosp := AT(';',aClis[nPos])
	cCdRet := substr(aClis[nPos], nPosp+1, 10)
endif
Return(cCdRet)
