 pro flicker,a,b,message=message

;+
; NAME:
;	FLICKER
;
; PURPOSE:
;	Flicker between two output images
;
; CATEGORY:
;	Image display, animation.
;
; CALLING SEQUENCE:
;	FLICKER, A, B
;
; INPUTS:
;	A:	Byte image number 1, scaled from 0 to 255.
;	B:	Byte image number 2, scaled from 0 to 255.
;
;       if a and b are not supplied FLICKER will enter interactive mode
;       wherin the user will be asked to select two windows (by a LMB
;       click inside the chosen window).  These two windows will be read
;       using tvrd() and compared.
;       
;               
;
; KEYWORD PARAMETERS:
;	None.
;
; OUTPUTS:
;	No explicit outputs.
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	Sunview: Modifies the display, changes the write mask.
;	X and Windows: uses two additional pixmaps.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;  SunView:
;	Image A is written to the bottom 4 bits of the display.
;	Image B is written to the top 4 bits.
;	Two color tables are created from the current table, one that
;	shows the low 4 bits using 16 of the original colors, and one
;	that shows the high 4 bits.  The color table is changed to
;	switch between images.
;  Other window systems:
;	two off screen pixmaps are used to contain the images.
;       on exit image A is left on the display
;
; MODIFICATION HISTORY:
;	DMS, 3/ 88.
;	DMS, 4/92, Added X window and MS window optimizations.
;       PJR/ESRG, 1/94, "flicker" control by mouse
;       PJR/ESRG, 1/94, put in tvrd() of windows for interactive use
;
;
; EXAMPLE:
;       window,0,xs=200,ys=200 & plot,sin(dist(10))
;       window,1,xs=200,ys=200 & plot,sin(dist(10)+.05)
;       window,2,xs=200,ys=200 & plot,sin(dist(10)+.1)
;       window,3,xs=200,ys=200 & plot,sin(dist(10)+.15)
;       flicker  ; choose two windows to compare
;       
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
;-
common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr
on_error,2                        ;Return to caller if an error occurs

if n_params() eq 0 then begin
  xmessage,'       choose first window      ',wbase=wbase,wlabels=wlabels
  st=systime(1)
  wselect
  awin=!d.window
  b=tvrd()
  xmessage,'       choose second window     ',relabel=wlabels(0)
  wselect
  bwin=!d.window
  xmessage,kill=wbase
  if awin eq bwin then return
  a=tvrd()
endif
if keyword_set(message) then $
      xmessage,['press LMB to toggle between cases',$
                'hold down LMB to flicker between cases',$
                'press RMB to quit Flicker Mode'],$
                wbase=wbase,title='Flicker Mode'
  
ichl = 0

if !d.name eq "SUN" then begin
	if n_elements(r_orig) eq 0 then begin	;colors defined?
		r_orig=indgen(256) & g_orig = r_orig & b_orig = r_orig
		endif

	p1 = 16 * [[ lindgen(256)/16], [ lindgen(256) and 15]] ;(256,2)

	device, set_write=240	;load top 4 bits
	tv,a
	empty
	device, set_write=15	;load bottom 4 bits
	tv,b/16b
	empty
	device,set_write=255	;re-enable all 8 bits

	while 1 do begin	;loop infinitely over each chl
		p = p1(*,ichl)	;get appropriate table
		tvlct,r_orig(p), g_orig(p), b_orig(p) ;load 4 bit table
                pause
                button=!err
                wait,.2
;                cursor,xdum,ydum,/device,/up
                if button eq 1 then ichl = 1 - ichl	;Other image
                if button eq 4  then goto,done
	endwhile
;
	done:	tvlct, r_orig, g_orig, b_orig
	empty
        if keyword_set(message) then xmessage,kill=wbase
	return

ENDIF ELSE BEGIN			;Assume X or Windows
	if !d.window lt 0 then window
	cwin = !d.window
	pix = intarr(2)		;Make 2 pixmaps
	for i=0,1 do begin
		window, /FREE, /PIX, xs = !d.x_size, ys = !d.y_size
		pix(i) = !d.window
		if i eq 0 then tv,a else tv,b
	endfor
	wset, cwin
	while 1 do begin	;loop infinitely over each chl
		device, copy=[0,0,!d.x_size, !d.y_size, 0, 0, pix(ichl)]
                pause
                button=!err
                wait,.2
;                cursor,xdum,ydum,/device,/up
                if button eq 1 then ichl = 1 - ichl	;Other image
                if button eq 4 then goto,done1
	endwhile
done1:	device, copy=[0,0,!d.x_size, !d.y_size, 0, 0, pix(0)]
        wdelete, pix(0), pix(1)
        if keyword_set(message) then xmessage,kill=wbase
	return
ENDELSE
end

