#include "totvs.ch"

//------------------------------------------------------------------
// Exemplo de configuração de TGrid em array com navegação por linha
//------------------------------------------------------------------

#define GRID_MOVEUP       0
#define GRID_MOVEDOWN     1
#define GRID_MOVEHOME     2
#define GRID_MOVEEND      3
#define GRID_MOVEPAGEUP   4
#define GRID_MOVEPAGEDOWN 5           

// MyGrid ( Classe para encapsular acesso ao componente TGrid )
//------------------------------------------------------------------------------           
CLASS MyGrid
	DATA oGrid	
	DATA oFrame
	DATA oButtonsFrame
	DATA oButtonHome
	DATA oButtonPgUp
	DATA oButtonUp
	DATA oButtonDown
	DATA oButtonPgDown
	DATA oButtonEnd
	DATA aData
	DATA aColumns
	DATA nLenData
	DATA nRecNo
	DATA nCursorPos	 
	DATA nVisibleRows    
	DATA nCol
	DATA nRow
	DATA nWidth
	DATA nHeight
	          
	METHOD New(oDlg,nRow,nCol,nWidth,nHeight,nVisRows) CONSTRUCTOR
	METHOD onMove( o,nMvType,nCurPos,nOffSet,nVisRows )
	METHOD isBof()
	METHOD isEof()
	METHOD ShowData( nFirstRec, nCount) 
	METHOD ClearRows() 
	METHOD DoUpdate()   
	METHOD SelectRow(n)       
	METHOD addColumn(nId, cCaption, nWidth, nAlign)
	METHOD delColumn(nId)
	METHOD SetArray(aData)
	METHOD AtuLinha(nCursor,aData,nRecno)
	METHOD LDblClick(bExec)
	METHOD ColPos(cNome)
			
	METHOD GoHome()                       
	METHOD GoEnd() 
	METHOD GoPgUp() 
	METHOD GoPgDown()      
	METHOD GoUp(nOffSet)
	METHOD GoDown(nOffSet)     
	
	METHOD SetCSS(cCSS)
END CLASS

METHOD New(oDlg,nRow,nCol,nWidth,nHeight,nVisRows) CLASS MyGrid   
	::oFrame:= tPanel():New(nRow,nCol,,oDlg,,,,,,nWidth,nHeight )
	::nRecNo:= 1
	::nCursorPos:= 0
	::nVisibleRows:= nVisRows // Forçado para 1o ::GoEnd()

	::aColumns := {}
		
	::aData := {}
	::nLenData:= 0
	
	::oGrid:= tGrid():New( ::oFrame )
	::oGrid:Align:= CONTROL_ALIGN_ALLCLIENT                       
	
	::oButtonsFrame:= tPanel():New(0,0,, ::oFrame,,,,,, 10,200,.F.,.T. )
	::oButtonsFrame:Align:= CONTROL_ALIGN_RIGHT
    
	::oButtonHome:= tBtnBmp():NewBar( "VCTOP.BMP",,,,, {||::GoHome()},,::oButtonsFrame )
	::oButtonHome:Align:= CONTROL_ALIGN_TOP

	::oButtonPgUp:= tBtnBmp():NewBar( "VCPGUP.BMP",,,,, {||::GoPgUp()},,::oButtonsFrame )
	::oButtonPgUp:Align:= CONTROL_ALIGN_TOP 
	
	::oButtonUp:= tBtnBmp():NewBar( "VCUP.BMP",,,,,{||::GoUp(1)},,::oButtonsFrame )
	::oButtonUp:Align:= CONTROL_ALIGN_TOP 

	::oButtonEnd:= tBtnBmp():NewBar( "VCBOTTOM.BMP",,,,, {||::GoEnd()},,::oButtonsFrame )
	::oButtonEnd:Align:= CONTROL_ALIGN_BOTTOM

	::oButtonPgDown:= tBtnBmp():NewBar( "VCPGDOWN.BMP",,,,, {||::GoPgDown()},,::oButtonsFrame )
	::oButtonPgDown:Align:= CONTROL_ALIGN_BOTTOM

	::oButtonDown:= tBtnBmp():NewBar( "VCDOWN.BMP",,,,, {||::GoDown(1)},,::oButtonsFrame )
	::oButtonDown:Align:= CONTROL_ALIGN_BOTTOM 
	
	::oGrid:bCursorMove:= {|o,nMvType,nCurPos,nOffSet,nVisRows| ::onMove(o,nMvType,nCurPos,nOffSet,nVisRows) }   	
RETURN

METHOD isBof() CLASS MyGrid
RETURN ( ::nRecno==1 )

METHOD isEof() CLASS MyGrid
RETURN ( ::nRecno==::nLenData)


METHOD ColPos(cNome) CLASS MyGrid
	Local nRet := ::oGrid:ColPos() 
	
	DEFAULT cNome := NIL
	
	If cNome != NIL
		nRet := aScan(::aColumns,{ |x| UPPER(ALLTRIM(x[2])) == UPPER(cNome) })
	EndIf
	
	If nRet <= 0
		nRet := ::oGrid:ColPos()
	EndIf
RETURN ( nRet )

METHOD LDblClick(bExec) CLASS MyGrid
	DEFAULT bExec := { || }
	::oGrid:bLDblClick := bExec
RETURN

METHOD addColumn(nId, cCaption, nWidth, nAlign) CLASS MyGrid
	::oGrid:addColumn(nId, cCaption, nWidth, nAlign)
	AADD(::aColumns,{nId, cCaption, nWidth, nAlign})
RETURN

METHOD delColumn(nId) CLASS MyGrid
	::oGrid:RemoveColumn(nId)
RETURN

METHOD SetArray(aData) CLASS MyGrid
	::aData := aData
	::nLenData := Len(aData)
	::ShowData( 1, ::nVisibleRows)
RETURN

METHOD GoHome() CLASS MyGrid
	if ::isBof()
		return
	endif		                 
	
	::nRecno := 1
	::oGrid:ClearRows()
	::ShowData( 1, ::nVisibleRows )    	
	::nCursorPos:= 0
	::SelectRow( ::nCursorPos )	
RETURN
                
METHOD GoEnd() CLASS MyGrid
	if ::isEof()
  		return
	endif

	::nRecno:= ::nLenData

	If ::nVisibleRows > ::nLenData
		::nVisibleRows := ::nLenData
	EndIf

	::oGrid:ClearRows()
	::ShowData( ::nRecno - ::nVisibleRows + 1, ::nVisibleRows )  
	
	If (::nVisibleRows-1) > ::nLenData
		::nCursorPos:= ::nLenData
	Else
		::nCursorPos:= ::nVisibleRows-1
	EndIf
	
	::SelectRow( ::nCursorPos )
RETURN

METHOD GoPgUp() CLASS MyGrid
	if ::isBof()
		return
	endif                                
	// força antes ir para a 1a linha da grid           
	if ::nCursorPos != 0
		::nRecno -= ::nCursorPos
		if ::nRecno<=1 
			::nRecno:=1
		endif			     
		::nCursorPos:= 0
//		::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } ) 		
		::AtuLinha(::nCursorPos, ::aData, ::nRecno)
	else
		::nRecno -= ::nVisibleRows
		if ::nRecno<=1 
			::nRecno:=1
		endif
		::oGrid:ClearRows()
		::ShowData( ::nRecno, ::nVisibleRows )
		::nCursorPos:= 0
	endif				

	::SelectRow( ::nCursorPos )
RETURN 

METHOD GoPgDown() CLASS MyGrid

Local nLastVisRow

if ::isEof()
		return
endif                                         
// força antes ir para a última linha da grid	
nLastVisRow:= ::nVisibleRows-2 

if ::nCursorPos!=nLastVisRow    
	if ::nRecno+nLastVisRow > ::nLenData
		nLastVisRow:= ( ::nRecno+nLastVisRow ) - ::nLenData
		::nRecno:= ::nLenData
	else		
		::nRecNo += nLastVisRow
	endif

	::nCursorPos:= nLastVisRow
//	::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } )
	::AtuLinha(::nCursorPos, ::aData, ::nRecno)
else  
	::oGrid:ClearRows()				
	::nRecno += ::nVisibleRows
	if ::nRecno > ::nLenData
		::nVisibleRows = ::nRecno-::nLenData
		::nRecno:= ::nLenData
	endif 
	::ShowData( ::nRecNo - ::nVisibleRows + 1, ::nVisibleRows )
	::nCursorPos:= ::nVisibleRows-1
endif   

::SelectRow( ::nCursorPos )				

RETURN

METHOD GoUp(nOffSet) CLASS MyGrid

Local lAdjustCursor:= .F.

if ::isBof()
	RETURN
endif		       

if ::nCursorPos==0
	::oGrid:scrollLine(-1)
	lAdjustCursor:= .T.
else            		
	::nCursorPos -= nOffSet		
endif		   
      
::nRecno -= nOffSet
  
  // atualiza linha corrente  
//::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } ) 
::AtuLinha(::nCursorPos, ::aData, ::nRecno)

if lAdjustCursor  
	::nCursorPos:= 0
endif	              

::SelectRow( ::nCursorPos )

RETURN

METHOD GoDown(nOffSet) CLASS MyGrid
    
Local lAdjustCursor:= .F.  
  
if ::isEof()
	RETURN
endif      

if ::nCursorPos==::nVisibleRows-1
	::oGrid:scrollLine(1)		 
	lAdjustCursor:= .T.
else
	::nCursorPos += nOffSet						
endif
                 
::nRecno += nOffSet

// atualiza linha corrente  
//::oGrid:setRowData( ::nCursorPos, {|o| { ::aData[::nRecno,1], ::aData[::nRecno,2], ::aData[::nRecno,3] } } ) 
::AtuLinha(::nCursorPos, ::aData, ::nRecno)
				
if lAdjustCursor 
	::nCursorPos:= ::nVisibleRows-1
endif		  	                   
             
::SelectRow( ::nCursorPos )       

RETURN

METHOD onMove( oGrid,nMvType,nCurPos,nOffSet,nVisRows ) CLASS MyGrid
                          
::nCursorPos:= nCurPos
::nVisibleRows:= nVisRows

if nMvType == GRID_MOVEUP  
	::GoUp(nOffSet)
elseif nMvType == GRID_MOVEDOWN       
	::GoDown(nOffSet)
elseif nMvType == GRID_MOVEHOME           
	::GoHome()
elseif nMvType == GRID_MOVEEND
	::GoEnd()  
elseif nMvType == GRID_MOVEPAGEUP
	::GoPgUp()
elseif nMvType == GRID_MOVEPAGEDOWN 
	::GoPgDown()
endif

RETURN
             
METHOD ShowData( nFirstRec, nCount) CLASS MyGrid

local i, nRec, ci, j
DEFAULT nCount:=30

If nFirstRec <= 0
	nFirstrec := 1
EndIf

for i:=0 to nCount-1
	nRec:= nFirstRec+i
	if nRec > ::nLenData
		RETURN
	endif			
	ci:= ALLTRIM(Str( nRec ))
	
	cb := "{|o| { "
	For j:=1 to (Len(::aData[nRec]))
		cb += "Self:aData["+ci+","+ALLTRIM(STR(j))+"],"
	Next j
	
	cb := SUBSTR(cb,1,Len(cb)-1)
	cb += " } }"
	
	::oGrid:setRowData( i, &cb )
next i     

RETURN

METHOD ClearRows() CLASS MyGrid
	::oGrid:ClearRows()
	::nRecNo:=1
RETURN                                                         

METHOD DoUpdate() CLASS MyGrid     
	::nRecNo:=1
	::Showdata(1)
	::SelectRow(0)
RETURN

METHOD SelectRow(n) CLASS MyGrid
	::oGrid:setSelectedRow(n)
RETURN           

METHOD SetCSS(cCSS) CLASS MyGrid
	::oGrid:setCSS(cCSS)
RETURN

METHOD AtuLinha(nCursor,aData,nRecno) CLASS MyGrid

Local cb, j
DEFAULT nCursor := 0

	cb := "{|o| { "
	For j:=1 to (Len(aData[j]))
		cb += "aData[nRecno,"+ALLTRIM(STR(j))+"],"
	Next j
	
	cb := SUBSTR(cb,1,Len(cb)-1)
	cb += " } }"
	
	::oGrid:setRowData(nCursor, &cb )
RETURN
