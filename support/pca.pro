PRO PCA, data, eigenval, eigenvect, percentages, proj_obj, proj_atr, $
      MATRIX=A,TEXTOUT=textout,COVARIANCE=cov,SSQ=ssq,SILENT=silent
     
; this version has changed TQLI to NR_TQLI and TRED2 to NR_TRED2.
; JAH 4/19/94

;+NAME:
;	PCA
;
; PURPOSE:
;	Carry out a Principal Components Analysis (Karhunen-Loeve Transform)
;	Results can be directed to the screen, a file, or output variables
;
; CALLING SEQUENCE:
;	PCA, data, eigenval, eigenvect, percentages, proj_obj, proj_atr, 
;		[MATRIX =, TEXTOUT = ,/COVARIANCE, /SSQ, /SILENT ]
;
; INPUT PARAMETERS:
;	data -  2-d data matrix, data(i,j) contains the jth attribute value
;		for the ith object in the sample.    If N_OBJ is the total
;		number of objects (rows) in the sample, and N_ATTRIB is the 
;		total number of attributes (columns) then data should be
;		dimensioned N_OBJ x N_ATTRIB.
;
; OPTIONAL INPUT KEYWORD PARAMETERS:
;	/COVARIANCE - if this keyword set, then the PCA will be carried out
;		on the covariance matrix (rare), the default is to use the
;		correlation matrix
;	/SSQ - if this keyword is set, then the PCA will be carried out on
;		on the sums-of-squares & cross-products matrix (rare)
;	TEXTOUT - Controls print output device, defaults to !TEXTOUT
;
;		textout=1	TERMINAL using /more option
;		textout=2	TERMINAL without /more option
;		textout=3	file pca.prt
;		textout=4	laser.tmp
;		textout=5      user must open file (see TEXTOPEN)
;		textout = 'filename' (default extension of .prt)
;
; OPTIONAL OUTPUT PARAMETERS:
;	eigenval -  N_ATTRIB element vector containing the sorted eigenvalues
;	eigenvect - N_ATRRIB x N_ATTRIB matrix containing the corresponding 
;		eigenvectors
;	percentages - N_ATTRIB element containing the cumulative percentage 
;		variances associated with the principal components
;	proj_obj - N_OBJ by N_ATTRIB matrix containing the projections of the 
;		objects on the principal components
;	proj_atr - N_ATTRIB by N_ATTRIB	matrix containing the projections of 
;		the attributes on the principal components
;
; OPTIONAL OUTPUT PARAMETER:
; 	MATRIX   = analysed matrix, either the covariance matrix if /COVARIANCE
;		is set, the "sum of squares and cross-products" matrix if
;		/SSQ is set, or the (by default) correlation matrix.    Matrix
;		will have dimensions N_ATTRIB x N_ATTRIB
;
; NOTES:
;	This procedure performs Principal Components Analysis (Karhunen-Loeve
;	Transform) according to the method described in "Multivariate Data 
;	Analysis" by Murtagh & Heck [Reidel : Dordrecht 1987], pp. 33-48. 
;
;	Keywords /COVARIANCE and /SSQ are mutually exclusive.
;
;	The printout contains only (at most) the first seven principle 
;	eigenvectors.    However, the output variables EIGENVECT contain 
;	all the eigenvectors
;	
;       Different authors scale the covariance matrix in different ways.
;	The eigenvalues output by PCA may have to be scaled by 1/N_OBJ or
;	1/(N_OBJ-1) to agree with other author's calculations when /COVAR is 
;	set.
;
;	PCA uses the non-standard system variables !TEXTOUT and !TEXTUNIT.
;	These can be added to one's session using the procedure ASTROLIB.
;
;	Users of V3.5.0 or later could change the calls to TQLI and TRED2
;	to NR_TQLI and NR_TRED2
;
; EXAMPLE:
;	Perform a PCA analysis on the covariance matrix of a data matrix, DATA,
;	and write the results to a file
;
;	IDL> PCA, data, /COVAR, t = 'pca.dat'
;
; 	Perform a PCA analysis on the correlation matrix.   Suppress all 
;	printing, and save the eigenvectors and eigenvalues in output varaibles
;
;	IDL> PCA, data, eigenval, eigenvect, /SILENT
;
; PROCEDURES CALLED:
;	Procedures TEXTOPEN, TEXTCLOSE
;
; COPYRIGHT:
;	Copyright 1993, Hughes STX Corporation, Lanham MD 20706.
;
; REVISION HISTORY:
;	Immanuel Freedman (after Murtagh F. and Heck A.).     December 1993
;	Wayne Landsman, modified I/O              December 1993
;- 
 ON_ERROR,2     ; return to user if error

; Constants
  TOLERANCE = 1.0E-5       ; are array elements near-zero ?

; Dispatch table

 IF N_PARAMS() EQ 0  THEN BEGIN
  print,'Syntax  - PCA, data, [eigenval, eigenvect, percentages, proj_obj, proj_atr, '
  print,'               [MATRIX =, filename=, FORMAT= , /COVARIANCE, /SSQ, /DEBUG]'
  RETURN
 ENDIF 

  SZ = size(data)
  if SZ(0) NE 2 THEN $
  BEGIN
   HELP,data
   MESSAGE,'ERROR - Data matrix is not two-dimensional'
  ENDIF

  Nobj = sz(1)   &  Mattr = sz(2)      ;Number of objects and attributes


  IF KEYWORD_SET(cov) THEN BEGIN
	msg = 'Covariance matrix will be analyzed'
 	GOTO,covariance	
  ENDIF ELSE $
  IF KEYWORD_SET(ssq) THEN BEGIN
	msg = 'Sum-of-squares & cross-products matrix will be analyzed'
        GOTO,ssq
  ENDIF ELSE BEGIN
   	msg = 'Default: correlation matrix will be analyzed' 
        GOTO,correlation
  ENDELSE

correlation: 
; form column-means
 temp = replicate( 1.0, Nobj )
 column_mean = (temp # data)/ Nobj
 X = (data - temp # transpose(column_mean))
 S = sqrt(temp # (X*X)) & X=X/(temp # S)
 GOTO,reduce

covariance:  
 ; form column-means
 temp = replicate(1.0, Nobj)
 column_mean = (temp # data)/Nobj
 X = (data - temp # transpose(column_mean))
 GOTO,reduce

ssq:
 X = data 

reduce:
 A = transpose(X) # X

; Carry out eigenreduction
 nr_tred2, A, D, E 	      ; D contains diagonal, E contains off-diagonal
 nr_tqli, D, E, A                ; D contains the eigen-values, A(*,i) -vectors

; Use TOLERANCE to decide if eigenquantities are sufficiently near zero

 index = where(abs(D) LE TOLERANCE*MAX(abs(D)),count) 
 if count NE 0 THEN D(index)=0
 index = where(abs(A) LE TOLERANCE*MAX(abs(A)),count) 
 if count NE 0 THEN A(index)=0

 index = sort(D)                   ; Order by increasing eigenvalue
 D = D(index) & E=E(index)
 A = A(*,index)

; Eigenvalues expressed as percentage variance and ...
 temp = replicate(1.0, Mattr )
 W1 = 100.0 * reverse(D)/total(D)

;... Cumulative percentage variance
 C = fltarr( Mattr, Mattr) 
 C(where(lindgen(Mattr,Mattr) LE (Mattr+1)*(lindgen(Mattr)#temp))) = 1
 W = C # W1

;Define returned parameters
 eigenval = reverse(D)
 eigenvect = reverse(transpose(A))
 percentages = W

; Output eigen-values and -vectors 

  if not keyword_set(SILENT) then begin
;	Open output file 
	if not keyword_set( TEXTOUT ) then TEXTOUT = textout
	textopen,'PCA', TEXTOUT = textout
	printf,!TEXTUNIT,'PCA: ' + !STIME
	sz1 = strtrim( Nobj,2) & sz2 = strtrim( Mattr, 2 )
   	printf,!TEXTUNIT, 'Data  matrix has '+ sz1 + ' objects with up to ' + $
		 sz2 + ' attributes'
	printf,!TEXTUNIT, msg 
	printf,!TEXTUNIT, ""
	printf,!TEXTUNIT, $ 
		'   Eigenvalues     As Percentages       Cumul. percentages
	for i = 0, Mattr-1 do $
	printf,!TEXTUNIT, eigenval(i), W1(i), percentages(i) ,f = '(3f15.4)'
	printf,!TEXTUNIT,""
	printf,!TEXTUNIT, 'Corresponding eigenvectors follow...'
	Mprint = Mattr < 7
	header = ' VBLE  '
	for i = 1, Mprint do header = header + '  EV-' + strtrim(i,2) + '   '
	printf,!TEXTUNIT, header
	for i = 1, Mattr do printf,!TEXTUNIT, $
		 i, eigenvect(0:Mprint-1,i-1),f='(i4,7f9.4)'
  endif

; Obtain projection of row-point on principal axes  (Murtagh & Heck convention)
 projx = X # A

; Use TOLERANCE again...
 index = where(abs(projx) LE TOLERANCE*MAX(abs(projx)),count)
 if count NE 0 THEN projx(index)=0
 proj_obj = reverse( transpose(projx) )

 if not keyword_set( SILENT ) then begin
	 printf,!TEXTUNIT,' '
	 printf,!TEXTUNIT, 'Projection of objects on principal axes ...'
	 printf,!TEXTUNIT,' '
	 header = ' VBLE  '
	 for i = 1, Mprint do header = header + 'PROJ-' + strtrim(i,2) + '   '
	 printf,!TEXTUNIT, header 
	 for i = 0, Nobj-1 do printf,!TEXTUNIT, $
		i+1, proj_obj(0:Mprint-1,i), f='(i4,7f9.4)'
 endif

; Obtain projection of column-points on principal axes
 projy = transpose(projx)#X

; Use TOLERANCE again...
 index = where(abs(projy) LE TOLERANCE*MAX(abs(projy)),count)
 if count NE 0 THEN projy(index) = 0

; scale by square root of eigenvalues...
 temp = replicate( 1.0, Nobj )
 proj_atr = reverse(projy)/(sqrt(W)#temp)

 if not keyword_set( SILENT ) then begin
	printf,!TEXTUNIT,' '
	printf,!TEXTUNIT,'Projection of attributes on principal axes ...'
	printf,!TEXTUNIT,' '
	printf,!TEXTUNIT, header
	for i = 0, Mattr-1 do printf,!TEXTUNIT, $
		i+1, proj_atr(0:Mprint-1,i), f='(i4,7f9.4)'
	 textclose, TEXTOUT = textout           ; Close output file  
 endif

 RETURN
 END
