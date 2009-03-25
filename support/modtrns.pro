pro modtrns,buf,archive=archive,file=file,xrange=xrange,title=title,sort=sort
;+
; ROUTINE:    modtrns
;
; PURPOSE:    extract transmission from modtran tape8, display transmission
;             plots
;
; USEAGE:     modtrns,buf,archive=archive,file=file,xrange=xrange,$
;                     title=title,sort=sort
;
; KEYWORD INPUT:
;   file      input file name (defaults to "tape8")
;
;   archive   archive data set name, if this keyword is present and both 
;             FILE and BUF are not set, input is read from specified
;             modtran data set which has been previously benn saved
;             in machine independent XDL format.  IF either BUF or
;             FILE are set, the data in FILE or BUF are written to
;             ARCHIVE.
;
;
;   title     string which specifies title of transmission plot
;
;   xrange    wavelength range (defaults to wavelength range of modtran run)
;
;   sort      if set, plot four most opaque species in order of
;             increasing band opacity.  Otherwise order is
;             (total,h2o,co2,o3,o2, ch4+n2o+co+no2+so2+nh3+no)
;
; INPUT/OUTPUT:
;   buf       modtran transmission data fltarr(12,*)
;
;              0  wavenumber
;              1  H2O
;              2  O3
;              3  CO2
;              4  CO
;              5  CH4
;              6  N2O
;              7  O2
;              8  NH3
;              9  NO
;             10  NO2
;             11  SO2
;                  
; DISCUSSION
;
;     if none of BUF, FILE and ARCHIVE are specified MODTRNS opens and
;     reads /local/idl/user_contrib/esrg/modsaw.xdr
;
; EXAMPLE:
;
;;;   read default archive file and plot 
;
;    modtrns
;
;;;   read tape8 and make plot
;
;    modtrns,buf,title='Subarctic Winter Atmosphere',file='tape8'
;
;;;   save this run in an XDR archive to expedite data retrievals for
;;;   other IDL sessions.  
;
;    modtrns,buf,archive='~/yourdirectory/modsaw.xdr'
;
;;;  retrieve an archived run (this archive file really exists, so try it)
;
;    delvar,buf
;    modtrns,buf,archive='/local/idl/user_contrib/esrg/modsaw.xdr'
;
;;;   Here, the ZOOMBAR command is used in a WHILE loop to zoom in on 
;;;   a region of interest. Use previously retrieved value of buf to 
;;;   quicken plots.  Window 0 is used to show whole wavelength range
;;;   while window 2 shows the zoomed in region.
;
;    delvar,buf
;    window,2,xs=600,ys=900 & window,0,xs=600,ys=900
;    modtrns,buf & xs=!x & r=0
;    while zoombar(r,/mess,init=r) do begin &$
;      wset,2 & modtrns,buf,xrange=r & !x=xs & wset,0 & end
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            feb95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

;
if not keyword_set(title) then title=' '

ncol=12

IF keyword_set(file) THEN begin
  line=''
  print,'reading from file ',file
  openr,lun,/get_lun,file
  for i=1,5 do readf,lun,line
  print,strmid(line,5,100)
  for i=1,4 do readf,lun,line
  v=str_sep(line,' ')
  v=long(v(where(v ne '')))
  for i=1,3 do readf,lun,line
  nl=1+(v(1)-v(0))/v(2)
  buf=fltarr(ncol,nl)
  readf,lun,buf
  free_lun,lun
  wv=reform(buf(0,*))
  data = 1
ENDIF ELSE BEGIN
  IF keyword_set(buf) THEN begin
    wv=reform(buf(0,*))
    nl = n_elements(wv)
    data =  1
  ENDIF ELSE BEGIN
    IF NOT keyword_set(archive) THEN $
           archive = '/local/idl/user_contrib/esrg/modsaw.xdr'
    print,'reading from archive ',archive
    openr,lun,/get_lun,/xdr,archive
    comment = '' & nx = 0l & ny = 0l
    readu,lun,comment,nx,ny
    nl = ny
    wv = fltarr(ny)
    sp = bytarr(nx-1,ny)
    readu,lun,wv,sp
    print,comment
    buf = fltarr(nx,ny)
    buf(0,*) = wv
    buf(1:nx-1,*) = float(sp)/255.
    free_lun,lun
    data = 0
  ENDELSE
ENDELSE

IF keyword_set(archive) AND data EQ 1 THEN BEGIN
  openw,lun,/get_lun,/xdr,archive
  print,'Enter a comment string to document the archive:'
  comment = ' '
  read,comment
  sz = size(buf)
  nx = long(sz(1)) &  ny = long(sz(2))
  wv = buf(0,*)
  sp = byte(255*buf(1:nx-1,*))
  writeu,lun,comment,nx,ny,wv,sp
  free_lun,lun
ENDIF

if keyword_set(xrange) then wrng=xrange else wrng=10000./[max(wv,min=mn),mn]

species=[' H!b2!nO ',' O!b3!n ',' CO!b2!n ',' CO  ',' CH!b4!n ',$
         ' N!b2!nO ',' O!b2!n ',' NH!b3!n ',' NO  ',' NO!b2!n ',' SO!b2!n ']

vrange = 10000./[wrng(1),wrng(0)]
ii=where(reform(buf(0,*)) ge vrange(0) and reform(buf(0,*)) le vrange(1) , nc)
if nc eq 0 then begin
  dum=min(abs(reform(buf(0,*))-vrange(0)),ii)
  ii=[ii,ii+1]
  nc=2
endif

wl=10000./wv(ii)

IF keyword_set(sort) THEN begin
  minspec=total(buf(1:ncol-1,ii),2)
  j=1+reverse(sort(minspec))
ENDIF ELSE BEGIN
  j = 1+[8,7,10,9,3,5,4,6,1,2,0]
ENDELSE

; lump together 7 most transparent species

clear=buf(j(0),ii)*buf(j(1),ii)*buf(j(2),ii)* $
      buf(j(3),ii)*buf(j(4),ii)*buf(j(5),ii)*buf(j(6),ii)
clear=reform(clear)

clearlab=species(j(6)-1)
for i=5,0,-1 do clearlab=clearlab+'+'+species(j(i)-1)

trnsum=clear*buf(j(7),ii)*buf(j(8),ii)*buf(j(9),ii)*buf(j(10),ii)
trnsum=reform(trnsum)

sp=fltarr(6,nc)
splab=[clearlab,species(j(7:10)-1),"Total"]
sp(0,*)=clear
for i=1,4 do sp(i,*)=buf(j(i+6),ii)
sp(5,*)=trnsum
vspc=float(!d.y_ch_size)/!d.x_vsize
;w8x11
!p.multi=[0,1,6]

pos1=[0.03,0.05,0.4,0.3]
pos2=[0.12,0.05,0.2,0.3]

!y.omargin=[3,6]
if wrng(0)*3 lt wrng(1) then begin
  xtcksv=!x.ticklen
  !x.ticklen=.1

  plot_oi,wl,clear,ymarg=ymulti(p,np=6,sp=1,ymargin=[10,5]),$
      xstyle=1,xrange=wrng,xcharsize=.0001

  autorange,10000./10.^!x.crange([1,0]),nxl,xv,xlab,ntickmax=10,/log
  xvnorm = convert_coord(10000./xv,replicate(0,nxl),/data,/to_norm)
  xvnorm = reform(xvnorm(0,*,0))
  xyouts,xvnorm,!y.window(1)+1.5*vspc,xlab,align = .5,/norm
  xyouts,.5,!y.window(1)+3.5*vspc,'Wavenumber (cm!a-1!n)',align = .5,/norm
  xyouts,xvnorm,!y.window(1)+.5*vspc,replicate('|',n_elements(xvnorm)), $
     align=.5,/norm
  !x.ticklen=xtcksv
  
  legend,clearlab,/box,bg=0,pos=pos1
  for i = 1,5 do begin
    plot_oi,wl,sp(i,*),ymargin=ymulti(p),xstyle=1,xrange=wrng,xcharsize=.0001
    legend,splab(i),/box,bg=0,pos=pos2
  endfor
  autorange,10.^!x.crange,nxl,xv,xlab,ntickmax=10,/log
  xvnorm = convert_coord(xv,replicate(0,nxl),/data,/to_norm)
  xvnorm = reform(xvnorm(0,*,0))
  xyouts,xvnorm,!y.window(0)-1.5*vspc,xlab,align = .5,/norm
  xyouts,.5,!y.window(0)-2.5*vspc,'Wavelength (um)',align = .5,/norm
  !x.ticklen=xtcksv

endif else begin
  plot,wl,clear,ymarg=ymulti(p,np=6,sp=1,ymargin=[10,5]),$
      xchars=.001,/xsty,xrange=wrng,title=title
  legend,clearlab,/box,bg=0,pos=pos1

  autorange,10000./!x.crange([1,0]),nxl,xv,xlab,ntickmax=10
  xvnorm = convert_coord(10000./xv,replicate(0,nxl),/data,/to_norm)
  xvnorm = reform(xvnorm(0,*,0))
  xyouts,xvnorm,!y.window(1)+1.5*vspc,xlab,align = .5,/norm
  xyouts,.5,!y.window(1)+3*vspc,'Wavenumber (cm!a-1!n)',align = .5,/norm
  xyouts,xvnorm,!y.window(1)+.5*vspc,replicate('|',n_elements(xvnorm)), $
     align=.5,/norm
  
  for i = 1,5 do begin
    plot,wl,sp(i,*),ymargin=ymulti(p),xchars=.001,/xsty,xrange=wrng
    legend,splab(i),/box,bg=0,pos=pos2
  endfor
  axis,xaxis=0,xstyle=1,xtitle='Wavelength', xcharsize=1.5
endelse
!y.omargin=0
return
end


