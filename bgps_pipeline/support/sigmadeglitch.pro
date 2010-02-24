; This function deglitches data based on the local mean and standard deviation
; in glitchy_data.  AVE is the number of data points over which the mean and standard
; deviation is calculated.  SIGMA is the number of standard deviations away from the
; local mean a point in glitchy_data must be to be cut.  The cut is done recursively
; so that very distant points don't foul-up the local mean and standard deviation
; calculation.  The returned vector is equal to glitchy_data for good data points
; and interpolated around the removed points, unless NO_INTERPOLATE is set.  If
; NO_INTERPOLATE is on, then the returned data is glitchy_data for all points.
; Keyword QUIET will suppress output messages.
;
; PARAMS: glitchy_data - a single timestream to be tested for glitches
;	  goodmask - after execution this is an array with the same size
;		     as glitchy_data that contains either 0 or 1 for
;		     each sample; 1 = good point, 0 = bad (glitch) point
function sigmadeglitch, glitchy_data, goodmask, SIGMA = SIGMA, AVE = AVE, $
				QUIET = QUIET, NO_INTERPOLATE = NO_INTERPOLATE

	; sigma is the number of standard deviations away from the mean a point
	; has to be in order to be cut
	if (keyword_set(sigma)) then sigma = sigma else sigma = 4.0
	; ave is the number of data points over which averages are taken
	if (keyword_set(ave)) then ave = ave else ave = 500

	; Set up variable for recursive glitch finding loop
	data = glitchy_data
	sdata = data
	sdev = data

	npts = N_ELEMENTS(data)
	ncurrpts = npts
	ngoodpts = LONG(0)
	goodflags = FLTARR(npts) + 1.0

	; and a recursion failsafe
	nloop = 0
	totalloops = 50

	;Time the deglitching process
	start = SYSTIME(/SEC)

	WHILE ((ngoodpts LT ncurrpts) AND (nloop LT totalloops)) DO BEGIN
		nloop = nloop + 1
		ncurrpts = N_ELEMENTS(data)

		; First compute local mean & stdev
		sdata = SMOOTH(data, ave, /EDGE_TRUNCATE)
		sdev = SQRT(ABS(SMOOTH(data^2, ave, /EDGE_TRUNCATE) - sdata^2))

		; Compute cutting varible & get good points
		goodpts = WHERE(ABS(data - sdata) LT sigma*sdev, ngoodpts)

		; Check to make sure there are some good points
		IF (ngoodpts EQ 0) THEN BEGIN
			message, /info, 'No good data points remain in loop ' + $
			       STRING(nloop, F = '(I0)')
			message, /info, 'Returning original data'
			data = glitchy_data
			goodflags = FLTARR(npts) ; Mark all points as bad
			BREAK
		ENDIF ELSE BEGIN
			; Set goodflags to 0 where there are bad points
			IF (ngoodpts LT ncurrpts) THEN BEGIN
				temp = FLTARR(ncurrpts)
				temp[goodpts] = 1.0
				goodflags[WHERE(goodflags EQ 1)] = temp
			ENDIF
			; Prepare for next iteration
			data = data[goodpts]
		ENDELSE
	ENDWHILE

	IF ~(KEYWORD_SET(NO_INTERPOLATE)) THEN BEGIN
		; Interpolate around bad data points
		goodpts = WHERE(goodflags EQ 1.0, ngoodpts)
		IF ngoodpts NE 0 THEN BEGIN
			time = LINDGEN(npts)
			data = interpol(glitchy_data[goodpts],time[goodpts],time)
		ENDIF ELSE BEGIN
			data = glitchy_data
		ENDELSE
	ENDIF ELSE BEGIN
		data = glitchy_data
	ENDELSE

	deltime = SYSTIME(/SEC) - start
	IF ~(KEYWORD_SET(quiet)) THEN $
		message, /info, 'Cut ' + STRING(npts - ngoodpts, F='(I0)') + ' of ' + $
		          STRING(npts, F='(I0)') + ' points using ' + STRING(nloop, F='(I0)') + $
	     	     ' iterations and taking ' + STRING(deltime, F='(F0.4)') + ' seconds'

	goodmask = goodflags
	RETURN, data
END
