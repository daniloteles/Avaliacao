#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RSANG001  ºAutor  ³Danilo Teles        º Data ³  26/11/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de compensação ECO		                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function RSANG001
Private oSize 			:= FwDefSize():New(.T.) 
Private dEnce 			:= stod("")
Private nX
Private aHeaderEx 		:= {}
Private aColsEx 		:= {}
Private aFieldFill  	:= {}
Private aFields 		:= {"O_K","E1_FILORIG","A1_CGC","A1_NOME","A1_XRECEBE","A1_XPAGAR ","A1_XSALDO"}
Private aAlterFields 	:= {"O_K"}
Private cFilialDe 		:= cFilAnt
Private cFilialAte 		:= cFilAnt   
Private dVctoDe 		:= stod("") 
Private dVctoAte 		:= stod("") 
Private _cCNPJ			:= space(14)

	oSize:AddObject( "CABECALHO",  100, 10, .T., .T. ) // Totalmente dimensionavel
	oSize:AddObject( "RODAPE"   ,  100, 85, .T., .T. ) // Totalmente dimensionavel
	oSize:lProp 	:= .T. // Proporcional             
	oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
	oSize:Process()
	
	aButtons:={}
	Aadd(aButtons, {"EXCEL", {|| fMarca()}, "Selecionar Todos", "Selecionar Todos" , {|| .T.}} )
	Aadd(aButtons, {"EXCEL", {|| fDesmarc()}, "Remover Seleção", "Remover Seleção" , {|| .T.}} )
	Aadd(aButtons, {"EXCEL", {|| RSANG01A()}, "Compensar", "Compensar" , {|| .T.}} )
		
	_ctitulo := "Compensação Automática ECO"
	
	oDlg := MSDialog():New(oSize:aWindSize[1],oSize:aWindSize[2],oSize:aWindSize[3],oSize:aWindSize[4],_ctitulo,,,,,,,,,.T.)
	
	EnchoiceBar(oDlg,   {||oDlg:end()}, {||oDlg:end()},,aButtons)

	_LnIniCb := oSize:GetDimension("CABECALHO","LININI")
	_ClIniCb := oSize:GetDimension("CABECALHO","COLINI")
	_LnEndCb := oSize:GetDimension("CABECALHO","LINEND")
	_ClEndCb := oSize:GetDimension("CABECALHO","COLEND")
		
	_LnIniRd := oSize:GetDimension("RODAPE","LININI")	
	_ClIniRd := oSize:GetDimension("RODAPE","COLINI")	
	_LnEndRd := oSize:GetDimension("RODAPE","LINEND")	
	_ClEndRd := oSize:GetDimension("RODAPE","COLEND")
		
	oSFilDe   := TSay():New(_LnIniCb+006, _ClIniCb+002, {|| "Filial:" }, Odlg, , , .F., .F., .F., .T., CLR_BLACK, CLR_GRAY, 40, 008)	
	oTFilDe   := TGet():Create( oDlg,{|u| If(PCount()>0,cFilialDe:=u,cFilialDe)},_LnIniCb+004,_ClIniCb+018,018,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cFilialDe",,,, )
	
	oSFilAte  := TSay():New(_LnIniCb+006, _ClIniCb+046, {|| "à" }, Odlg, , , .F., .F., .F., .T., CLR_BLACK, CLR_GRAY, 40, 008)
	oTFilAte  := TGet():Create( oDlg,{|u| If(PCount()>0,cFilialAte:=u,cFilialAte)},_LnIniCb+004,_ClIniCb+053,018,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cFilialAte",,,, )
		
	oSVctoDe   := TSay():New(_LnIniCb+006, _ClIniCb+085, {|| "Vencimento:" }, Odlg, , , .F., .F., .F., .T., CLR_BLACK, CLR_GRAY, 40, 008)	
	oTVctoDe   := TGet():Create( oDlg,{|u| If(PCount()>0,dVctoDe:=u,dVctoDe)},_LnIniCb+004,_ClIniCb+120,050,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"dVctoDe",,,,.t. )

	oSVctoAte  := TSay():New(_LnIniCb+006, _ClIniCb+172, {|| "à" }, Odlg, , , .F., .F., .F., .T., CLR_BLACK, CLR_GRAY, 40, 008)
   	oTVctoAte  := TGet():Create( oDlg,{|u| If(PCount()>0,dVctoAte:=u,dVctoAte)},_LnIniCb+004,_ClIniCb+180,050,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"dVctoAte",,,,.t. )
	
	oSCNPJ     := TSay():New(_LnIniCb+006, _ClIniCb+235, {|| "CNPJ:" }, Odlg, , , .F., .F., .F., .T., CLR_BLACK, CLR_GRAY, 40, 008)
	oTCNPJ 	   := TGet():Create( oDlg,{|u| If(PCount()>0,_cCNPJ:=u,_cCNPJ)},_LnIniCb+004,_ClIniCb+255,080,010,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"A1CNPJ","_cCNPJ",,,,.T. )
	
	oBtAtu1    := TButton():New(_LnIniCb+004, _ClIniCb+345, "Filtrar",oDlg,{|| fCarrega()}, 40,12,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	fMSNewGe1()
			
	activate dialog oDlg
Return


static function funAtualizar
	
	fCarrega()
return 

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 

Static oMSNewGe1

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    else
		SX3->(DbSeek("O_K"))
		Aadd(aHeaderEx, {"Selec.","OK","@BMP",SX3->X3_TAMANHO,SX3->X3_DECIMAL,"AllwaysTrue()",;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
  Next nX                                                            

  oMSNewGe1 := MsNewGetDados():New(_LnIniRd,_ClIniRd, _LnEndRd, _ClEndRd, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
  
  fCarrega()
  
  bSvblDblClick := oMSNewGe1:oBrowse:bLDblClick
  oMSNewGe1:oBrowse:bLDblClick := {|| if(oMSNewGe1:oBrowse:nColPos<>1,GdRstDblClick(@oMSNewGe1,@bSvblDblClick),CLIQUE())}
  
Return

Static Function fCarrega()
Local cQry := ""
	aColsEx := {}
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	Endif
	cQry := "SELECT E1_FILORIG, SA1.A1_CGC, A1_NOME,  SUM(RECEBER) RECEBER, SUM(PAGAR) PAGAR, "
	cQry += " SUM(RECEBER) - SUM(PAGAR) SALDO  "
	cQry += "  FROM ( "
	cQry += " SELECT 'Receber' Tipo, E1_FILORIG, A1_CGC, E1_NUM, E1_PARCELA, E1_PREFIXO, E1_EMISSAO, E1_VENCREA, E1_SALDO RECEBER, 0 PAGAR, SE1.R_E_C_N_O_   "
	cQry += " FROM SE1010 SE1, SA1010 SA1 "
	cQry += " WHERE E1_TIPO = 'ECO' "
	cQry += " AND E1_PREFIXO <> 'REN' "
	cQry += " AND E1_SALDO > 0  "
	cQry += " AND A1_COD = E1_CLIENTE "
	cQry += " AND A1_LOJA = E1_LOJA "
	cQry += " AND SA1.D_E_L_E_T_ <> '*' "
	cQry += " AND SE1.D_E_L_E_T_ <> '*' "
	                                     
	if !empty(dVctoDe) .AND. !empty(dVctoAte)
		cQry += " AND SE1.E1_EMISSAO BETWEEN '"+DTOS(dVctoDe)+"' AND '"+DTOS(dVctoAte)+"' "
	endif                                                                          
	
	if !empty(cFilialDe) .AND. !empty(cFilialAte)
		cQry += " AND SE1.E1_FILORIG BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
	endif	

	if alltrim(_cCNPJ) != ""
		cQry += " AND SA1.A1_CGC = '"+_cCNPJ+"'"
	endif                                                                          

	cQry += " UNION ALL "

	cQry += " SELECT 'Pagar' Tipo, E2_FILORIG, A2_CGC, E2_NUM, E2_PARCELA, E2_PREFIXO, E2_EMISSAO, E2_VENCREA, 0, E2_SALDO, SE2.R_E_C_N_O_   "
	cQry += " FROM SE2010 SE2, SA2010 SA2 "
	cQry += " WHERE E2_TIPO = 'ECO' "
	cQry += " AND E2_PREFIXO <> 'REN' "
	cQry += " AND E2_SALDO > 0  "
	cQry += " AND A2_COD = E2_FORNECE "
	cQry += " AND A2_LOJA = E2_LOJA "
	cQry += " AND SA2.D_E_L_E_T_ <> '*' "
	if !empty(cFilialDe) .AND. !empty(cFilialAte)
		cQry += " AND SE2.E2_FILORIG BETWEEN '"+cFilialDe+"' AND '"+cFilialAte+"' "
	endif	
	
	if !empty(dVctoDe) .AND. !empty(dVctoAte)
		cQry += " AND SE2.E2_EMISSAO BETWEEN '"+DTOS(dVctoDe)+"' AND '"+DTOS(dVctoAte)+"' "
	endif	

	if alltrim(_cCNPJ) != ""
		cQry += " AND SA2.A2_CGC = '"+_cCNPJ+"'"
	endif                                                                          

	cQry += " AND SE2.D_E_L_E_T_ <> '*') TBAUX  "
	cQry += "   INNER JOIN SA1010 SA1 ON SA1.A1_CGC = TBAUX.A1_CGC AND SA1.D_E_L_E_T_ <> '*' "
	cQry += " GROUP BY SA1.A1_CGC, A1_NOME, E1_FILORIG "
	cQry += " HAVING SUM(PAGAR) <> 0 AND SUM(RECEBER) <> 0  "
    cQry += " ORDER BY A1_NOME "
		
	TCQUERY cQry NEW ALIAS "TMP"

	While !TMP->(EOF())
		Aadd(aColsEx, {"LBNO", alltrim(TMP->E1_FILORIG), alltrim(TMP->A1_CGC), alltrim(TMP->A1_NOME), TMP->RECEBER, TMP->PAGAR, TMP->SALDO, .F. } )
		TMP->(dbskip())
	end
		
	oMSNewGe1:SetArray(aColsEx,.T.)
	oMSNewGe1:Refresh()
Return

static Function funSelc
                      
	for nY := 1 to len(oMSNewGe1:ACOLS)
		if oMSNewGe1:ACOLS[nY][1] == "LBOK"
			oMSNewGe1:ACOLS[nY][1] := "LBNO"
		else
			oMSNewGe1:ACOLS[nY][1] := "LBOK"
		endif
	next nY
	oMSNewGe1:REFRESH()
return

Static function RSANG01A()
	lPeloMenosUm := .F. 
	
	if MsgYesNo("Tem certeza que deseja fazer a compensação?") 
		for nX := 1 to len(oMSNewGe1:ACOLS)
			if oMSNewGe1:ACOLS[nX][1] == "LBOK"				
				TCompEco(oMSNewGe1:ACOLS[nX][3])			
			endif		
		next nX	
	endif            
	if lPeloMenosUm                                                       
		Aviso("Informação","Compensação realizada com sucesso!",{"OK"})   
		funAtualizar()		
	else
		Aviso("Atenção","Nenhum título compensado!",{"OK"})
	endif
return 


static Function CLIQUE()

if oMSNewGe1:ACOLS[oMSNewGe1:NAT][1] == "LBOK"
	oMSNewGe1:ACOLS[oMSNewGe1:NAT][1] := "LBNO"
else
	oMSNewGe1:ACOLS[oMSNewGe1:NAT][1] := "LBOK"
endif
	oMSNewGe1:REFRESH()

return


Static Function TCompEco(cCNPJ)
Local aArea     := GetArea()
Local aAux		:=  {}
Local aTitSE1	:= 	{}
Local aTitSE2	:=	{}
Local cCliente	:= ""
Local cLojaCli	:= ""
Local cFornece	:= ""
Local cLojaFor	:= ""
Local dDtIni	:= cTod(" / / ")
Local dDtFim	:= cTod(" / / ")
Local lRet		:= .T.
Local nX		:= 0
Local nValSE1	:= 0
Local nValSE2	:= 0
Local nPos		:= 0
Local nPosSerie	:= 0

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.
	
	dbselectarea("SA1")
	SA1->(dbsetorder(3))
	SA1->(dbgotop())
	if SA1->(dbseek(xFilial("SA1")+cCNPJ))
	  	_cCliente := SA1->A1_COD
	  	_cLojaCli := SA1->A1_LOJA  	
	endif
	
	dbselectarea("SA2")
	SA2->(dbsetorder(3))
	SA2->(dbgotop())
	if SA2->(dbseek(xFilial("SA2")+cCNPJ))
	  	_cFornece := SA2->A2_COD
	  	_cLojaFor := SA2->A2_LOJA  	
	endif 
	  
	If Select("TMPSE1") > 0
		TMPSE1->(DbCloseArea())
	Endif      
	
	cQry := " SELECT E1_FILIAL, E1_CLIENTE,  E1_LOJA,  E1_SALDO, E1_VENCREA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO "
	cQry += " FROM SE1010 SE1 "
	cQry += " WHERE E1_TIPO = 'ECO'  "
	cQry += " AND E1_PREFIXO <> 'REN'  "
	cQry += " AND E1_SALDO > 0   "
	cQry += " AND E1_CLIENTE = '" + _cCliente + "'"
	cQry += " AND E1_LOJA = '" + _cLojaCli + "'"
	cQry += " AND SE1.D_E_L_E_T_ <> '*'  "
		   
	TCQUERY cQry NEW ALIAS "TMPSE1"
	
	While TMPSE1->(!EOF())
		SE1->( dbSetOrder(1))
		If SE1->(dbSeek(TMPSE1->E1_FILIAL + TMPSE1->E1_PREFIXO + TMPSE1->E1_NUM + TMPSE1->E1_PARCELA + TMPSE1->E1_TIPO) ) .And. SE1->E1_SALDO > 0
	
			cCliente	:= SE1->E1_CLIENTE
			cLojaCli	:= SE1->E1_LOJA
			nValSE1 	+= SE1->E1_SALDO
	
			If SE1->E1_VENCREA < dDtIni .Or. Empty( dDtIni )
				dDtIni	:= SE1->E1_VENCREA
			EndIf
	
			If SE1->E1_VENCREA > dDtFim .Or. Empty( dDtFim )
				dDtFim := SE1->E1_VENCREA
			EndIf
	
			AAdd(aTitSE1, {SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA + SE1->E1_TIPO})
		EndIf
	 	TMPSE1->(DbSkip()) 
    Enddo
    
    If Select("TMPSE2") > 0
		TMPSE2->(DbCloseArea())
	Endif    
	
    cQry := " SELECT E2_FORNECE, E2_LOJA, E2_SALDO, E2_VENCREA, E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO "
  	cQry += " FROM SE2010 SE2 "
  	cQry += " WHERE E2_TIPO = 'ECO'  "
  	cQry += " AND E2_PREFIXO <> 'REN'  "
  	cQry += " AND E2_SALDO > 0   "
  	cQry += " AND E2_FORNECE = '" + _cFornece + "'"
  	cQry += " AND E2_LOJA  = '" + _cLojaFor + "'"
  	cQry += " AND SE2.D_E_L_E_T_ <> '*'  "
  	      
  	TCQUERY cQry NEW ALIAS "TMPSE2" 
	    
    While TMPSE2->(!EOF())
    	SE2->( dbSetOrder(1) )	
    	If SE2->( dbSeek(TMPSE2->E2_FILIAL + TMPSE2->E2_PREFIXO + TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECE + TMPSE2->E2_LOJA) ) .And. SE2->E2_SALDO > 0
			cFornece	:= SE2->E2_FORNECE
			cLojaFor	:= SE2->E2_LOJA
			nValSE2 	+= SE2->E2_SALDO
	
			If SE2->E2_VENCREA < dDtIni .Or. Empty( dDtIni )
				dDtIni	:= SE2->E2_VENCREA
			EndIf
	
			If SE2->E2_VENCREA > dDtFim .Or. Empty( dDtFim )
				dDtFim := SE2->E2_VENCREA
			EndIf
	
			AAdd(aTitSE2, {SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA	+ SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA})
		EndIf
		TMPSE2->(DbSkip()) 
    Enddo
    
	dbSelectArea("SE2")
	
	If Len(aTitSE1) > 0 .And. Len(aTitSE2) > 0
		aAutoCab := {{"AUTDVENINI450", dDtIni				  , nil},; 
			         {"AUTDVENFIM450", dDtFim				  , nil},; 
			         {"AUTNLIM450"   , Max( nValSE1, nValSE2 ), nil},; 
			         {"AUTCCLI450"   , cCliente				  , nil},; 
			         {"AUTCLJCLI"    , cLojaCli				  , nil},; 
			         {"AUTCFOR450"   , cFornece				  , nil},; 
			         {"AUTCLJFOR"    , cLojaFor				  , nil},; 
			         {"AUTCMOEDA450" , "01"					  , nil},; 
			         {"AUTNDEBCRED"  , 1					  , nil},; 
			         {"AUTLTITFUTURO", .F.					  , nil},; 
			         {"AUTARECCHAVE" , aTitSE1				  , nil},; 
			         {"AUTAPAGCHAVE" , aTitSE2				  , nil}}

		MSExecAuto({|x,y,z| Fina450(x,y,z)}, nil , aAutoCab , 3 )
		If !lMsErroAuto
			confirmsx8()	
			lPeloMenosUm := .T.	
		Else
			lRet := .F.
			rollbacksx8()
			MostraErro()
		EndIf
	EndIf

	RestArea(aArea)

Return lRet

static function fMarca
	for _x := 1 to len(oMSNewGe1:acols)
		oMSNewGe1:ACOLS[_x][1] := "LBOK"
	next _x
	oMSNewGe1:REFRESH()
return

static function fDesmarc
	for _x := 1 to len(oMSNewGe1:acols)
		oMSNewGe1:ACOLS[_x][1] := "LBNO"
	next _x
	oMSNewGe1:REFRESH()
return