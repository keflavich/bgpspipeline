pro toggle,color=color,landscape=landscape,portrait=portrait,legal=legal, $
           queue=queue,print=print,filename=filename,eps=eps,xoffset=xoffset, $
           yoffset=yoffset,xsize=xsize,ysize=ysize,_extra=_extra
;+
; ROUTINE:      toggle
;
; USEAGE For opening a postscript file:
;
;       toggle,color=color,landscape=landscape,portrait=portrait, $
;              legal=legal,queue=queue,print=print,filename=filename, $
;              eps=eps,xoffset=xoffset,yoffset=yoffset,xsize=xsize, $
;              ysize=ysize,_extra=_extra
;
; USEAGE For closing a postscript file:
;
;       toggle,print=print, queue=queue
;
; PURPOSE:      toggles IDL graphics output between X-window and a postscript
;               output file.
;
; OPTIONAL INPUTS (keyword parameters):
;
;;;; these keywords recognized when opening a postscript file:
; 
;   COLOR
;     Enable color plotting (output to Tek Phaser color printer)
;
;   LANDSCAPE   
;     Horizontal plotting format (i.e., long side of paper is horizontal)
;
;   PORTRAIT
;     Vertical plotting format (default)
;
;   LEGAL       
;     8.5 x 14 inch page size 
;     (8.5 x 11 is default)
;
;   EPS
;     If set, an encapsulated postscript file is produced.  Many word
;     processing and typesetting programs provide facilities to
;     include encapsulated PostScript output within documents (for
;     example groff's PSPIC command).  If the XSIZE and YSIZE
;     parameters are not set the value of EPS is interpreted as an
;     aspect ratio of the graphic.  
;     
;     NOTE: Using the SET_CHARSIZE procedure to set the character size
;           makes it easier to use an x-window preview to predict the
;           appearance of PS output.
;
;   XSIZE, YSIZE
;     Controls the size of the plotting area (inches).  These
;     parameters can be used to set the size of an EPS graphic.  If
;     XSIZE and YSIZE are not set the value of of EPS is used to
;     compute the aspect ratio.  In that case, the internal values of
;     XSIZE and YSIZE are set to 8 and 8/EPS inches, respectively.
;     Setting XSIZE and YSIZE explicitly is useful for controlling the
;     appearance of different linestyles.  For example, when linestyle
;     2 is used to produce dashed lines, a 4"x4" plot size will
;     produce half as many dashes as a 8"x8" plot size.
;
;   XOFFSET,YOFFSET
;     In PORTRAIT mode XOFFSET,YOFFSET is the coordinate position of
;     the lower left corner of the plotting area (inches) with respect
;     to the lower left corner of the paper.  In LANDSCAPE mode the
;     whole coordinate system is turned to 90 degrees counter-
;     clockwise, so that XOFFSET is the bottom margin and YOFFSET is
;     the distance from the lower-left corner of the plotting area to
;     the RIGHT (yup, that's RIGHT) edge of the page.
;
;   FILENAME
;     name of postscript file (default = plot.ps or plotc.ps). 
;
;;;; these keywords recognized when closing a postscript file:
;
;   PRINT
;     PRINT=1 => submit to default printer ( setenv PRINTER ????)
;     otherwise if PRINT is a string variable the job will be spooled
;     to the named print queue (e.g., PRINT='tree'). 
;
;   QUEUE
;     if set, print queue is selected from a pop-up menu. 
;
; PROCEDURE:
;     The first call to TOGGLE (and all odd number calls) changes the
;     output device from X-window to a Postscript output file.  If the
;     output file name is not specified on the command line the
;     default file name will be plot.ps for the laser printers, or
;     plotc.ps for the TEK Phaser color printer.
;     
;     The next call (and all even number calls) switches back to the
;     X-window and closes the plot file.  If the keyword PRINT is set
;     the plotfile will be submitted to one of the ICESS print queues.
;     
;     NOTE: Only one postscript file can be open at any given time
;
; SIDE EFFECTS: 
;     In order to maintain a font size which keeps the same
;     relation to the screen size, the global variable
;     !p.charsize is changed when switching to and from
;     postscript mode, as follows,
;     
;     When toggleing to PS !p.charsize --> !p.charsize/fac
;     When toggleing to X  !p.charsize --> !p.charsize*fac
;     
;                 [!d.x_ch_size]    [!d.x_vsize  ]
;     where fac=  [------------]    [----------- ]
;                 [!d.x_vsize  ]    [!d.x_ch_size]
;                               PS                X 
;     
;     Thus, to ensure that plotted character strings scale
;     properly in postscript mode, specify all character
;     sizes as as multiples of !p.charsize.
;
; EXAMPLE:  View the IDL dist function and then make a hardcopy:
;     
;      d=dist(200)
;      loadct,5
;      tvscl,d                    ; view the plot on X-windows
;      toggle,/color,/landscape   ; redirect output to plotc.ps
;      tvscl,d                    ; write plot onto plotc.ps
;      toggle,/print              ; resume output to X-windows
;                                 ; submit plot job to default printer
;      toggle,/color,/land
;      tvscl,d
;      toggle,print='term'        ; submit plot "term" print queue
;               
;
; BUGS:  EPS option does not work in LANDSCAPE format.  Looks like a 
;        a problem in IDL's DEVICE proceedure.
;   
;
;
;  author:  Paul Ricchiazzi                            1jun92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
; 
;
; NOTE: you can check for the currently defined print queues in /etc/printcap
;
; REVISIONS:
;  feb93: added PRINT keyword
;  feb93: set yoffset=10.5 in landscape mode
;  feb93: added FILENAME keyword
;  mar93: added bits=8 in black and white mode
;  mar96: modify !p.charsize to compensate for larger ps font size
;  mar96: send output to print queue tree on eos
;  sep96: added EPS,XSIZE and YSIZE keywords
;  dec96: make PORTRAIT format standard for color plots
;-
;
;;;;;;;;
;
; THE FOLLOWING CODE LOOKS MESSY BECAUSE IDL'S DEVICE COMMAND IS BROKEN.
; IT INCORRECTLY INTERPRETS KEYWORDS SET TO ZERO AS ENABLED OPTIONS.
; I.E., IT DISABLES AN OPTION ONLY IF THE KEYWORD DOES NOT APPEAR IN THE CALL
;
;;;;;;;;

common toggle_blk,psfile
chpscr=float(!d.x_vsize)/!d.x_ch_size

if !d.name eq 'X' then begin

  if keyword_set(eps) then begin
    if keyword_set(landscape) then  $
       message,'Can not make encapsulated postscript in LANDSCAPE format'
    if not keyword_set(xsize) then xsize=8.
    if not keyword_set(ysize) then ysize=xsize/eps
    xoffset=0
    yoffset=0
    eps=1
    sufx='.eps'
  endif else begin
    eps=0
    sufx='.ps'
  endelse

  if !p.charsize eq 0 then !p.charsize=1.
  set_plot, 'PS'
  !p.charsize=!p.charsize*float(!d.x_vsize)/(!d.x_ch_size*chpscr)

  if keyword_set(color) eq 0 then begin

    if keyword_set(filename) eq 0 then psfile='plot'+sufx  $
                                  else psfile=filename
;
; Apple Laserwriter
;
    if keyword_set(landscape) then begin	

      if not keyword_set(xsize) then xsize=10.
      if not keyword_set(ysize) then ysize=7.
      if not keyword_set(yoffset) then yoffset=10.5
      if not keyword_set(xoffset) then xoffset=0
      print,form='(5a10)','xsize','ysize','xoffset','yoffset'
      print,form='(4g10.5)',xsize,ysize,xoffset,yoffset
      device,bits=8,filename=psfile,xsize=xsize,ysize=ysize,xoffset=xoffset, $
         yoffset=yoffset,/inches,/landscape,encapsulate=eps,_extra=_extra

    endif else begin

      if not eps then begin
        if not keyword_set(xsize) then xsize=7.
        if not keyword_set(ysize) then ysize=10.
        if not keyword_set(yoffset) then yoffset=.5
        if not keyword_set(xoffset) then xoffset=0.
      endif
      print,form='(5a10)','xsize','ysize','xoffset','yoffset'
      print,form='(4g10.5)',xsize,ysize,xoffset,yoffset
      device,bits=8,filename=psfile,xsize=xsize,ysize=ysize,xoffset=xoffset, $
         yoffset=yoffset,/inches,/portrait,encapsulate=eps,_extra=_extra

    endelse

  endif else begin
;
; Tektronics Phaser color printer
;
    if keyword_set(filename) eq 0 then psfile='plotc'+sufx  $
                                  else psfile=filename

    short_side = 8.0
    small_offset=(8.5-short_side)/2.
    set_plot, 'ps'
    if n_elements(legal) ne 0 then begin
      long_side=10.5
      big_offset=(14.-long_side)/2.
    endif else begin
      long_side=8.5
      big_offset=(11.-long_side)/2
    endelse

    if keyword_set(landscape) then begin
      if not keyword_set(yoffset) then yoffset=long_side+big_offset+.5
      if not keyword_set(xoffset) then xoffset=small_offset
      if not keyword_set(xsize) then xsize=long_side
      if not keyword_set(ysize) then ysize=short_side
      print,form='(5a10)','xsize','ysize','xoffset','yoffset'
      print,form='(4g10.5)',xsize,ysize,xoffset,yoffset
      device,bits=8,/color,xsize=xsize,ysize=ysize,xoffset=xoffset,/inch, $
         yoffset=yoffset,/landscape,file=psfile,encapsulate=eps,_extra=_extra
    endif else begin
      if not eps then begin
        if not keyword_set(yoffset) then yoffset=big_offset
        if not keyword_set(xoffset) then xoffset=small_offset
        if not keyword_set(xsize) then xsize=short_side
        if not keyword_set(ysize) then ysize=long_side
      endif
      print,form='(5a10)','xsize','ysize','xoffset','yoffset'
      print,form='(4g10.5)',xsize,ysize,xoffset,yoffset
      device,bits=8,/color,xsize=xsize,ysize=ysize,xoffset=xoffset,/inch, $
         yoffset=yoffset,/portrait,file=psfile,encapsulate=eps,_extra=_extra
    endelse
  endelse  

  print, 'Output directed to file '+psfile

endif else begin
  device, /close_file 
  set_plot, 'X' 
  !p.charsize=!p.charsize*float(!d.x_vsize)/(!d.x_ch_size*chpscr)
  print,'File '+psfile+' closed. Output directed to Xwindow  ' 

  if keyword_set(print) or keyword_set(queue) then begin

    pdefault=getenv("PRINTER")

    if keyword_set(queue) then begin
      printers=['do not print',pdefault]
      descrip =['','(the default printer)']
      descrip(0)='(output saved in '+psfile+')'
      openr,lunp,/get_lun,"/etc/printcap"
      line='' & blank='                       '

      while eof(lunp) eq 0 do begin
        readf,lunp,line
        if strpos(line,'|') ge 0 then begin
          parse=str_sep(line,"|")
          if strpos(parse(0),'6') eq 0 then parse(0)=parse(1)
          dsc=parse(n_elements(parse)-1)
          printers=[printers,parse(0)]
          nd=strlen(dsc)-2
          descrip=[descrip,strmid(dsc,0,nd)]
        endif
      endwhile

      free_lun,lunp
      plen=strlen(printers)
      pspace=fix(5+max(plen)-plen)
      nprn=n_elements(printers)
      for i=0,nprn-1 do descrip(i)=printers(i)+$
                                   strmid(blank,0,pspace(i)) + descrip(i)
      descrip=['Choose a print queue',descrip]
      p=wmenu(descrip,title=0,init=1)-1
      printq=printers(p)
      if p le 0 then return
    endif else begin
      if (size(print))(1) eq 7 then printq=print else printq=pdefault
    endelse

    print,psfile+" spooled to printer queue "+printq

    case printq of
      'tree':  spawn,'rsh eos cd $PWD ";" lpr -Ptree  '+psfile
      'tree2': spawn,'rsh eos cd $PWD ";" lpr -Ptree2 '+psfile
      else:    spawn,['lpr','-P',printq,psfile],/noshell
    endcase

  endif
endelse
return
end





