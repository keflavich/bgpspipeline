pro psd,image,wavenum,power,beta,scale=scale,check=check,view=view,$
        unit=unit,title=title,binpower=binpower,xrange=xrange,density=density
;+
;ROUTINE:      psd
;               
;USEAGE:       psd,image,wavenum,power,scale=scale,view=view,$
;                      unit=unit,title=title,binpower=binpower,$
;                      xrange=xrange,density=density
;
;               
;PURPOSE:      compute angle averaged power spectral density of an image
;               
;INPUT:        
;
;   image
;       a one or two dimensional data array
;               
;OUTPUT:
;       
;   wavenum     
;       The spatial wave number of the scene (averaged over angle if
;       image is 2-D).  WAVENUM ranges from a minimum value of about
;       2/max(NX,NY) cycle/pixel (i.e., the zero frequency component
;       should not be included) to a maximum value of 1 cycle/pixel,
;       i.e, the Nyquist frequency of the scene.  If SCALE is set,
;       WAVENUM has units of cycles/unit where unit is the physical
;       units used to set SCALE (see UNIT and SCALE, below).  If you
;       want to have WAVENUM expressed in units of cycles/frame,
;       (which only makes sense when NX=NY) set
;       SCALE=[1./fix(NX/2),1./fix(NY/2)]
;               
;               
;   power       
;       energy spectra of scene.  if image has only one dimension POWER
;       is the squared modulus of the fourier transform.  If image is
;       two dimensional POWER is the angular integration of the
;       squared modulus of fourier transform coeficients, P, over the
;       anulus defined by a given value of k=sqrt(kx^2+ky^2).
;               
;       total power = integral(2 pi P k dk) = integral(POWER(k) dk),
;
;KEYWORD INPUT:
;
;   scale
;       physical resolution of image, i.e., the size of a single picture
;       element in physical units such as kilometers.  If SCALE is set
;       to a two element vector, the two values specify the resolution
;       in the x and y directions, respectively.  When SCALE is set, the
;       units of WAVENUM are cycles/unit where UNIT are the physical
;       units (see below) in which SCALE is specified.
;               
;   unit
;       string variable specifying the physical units used to specify
;       SCALE (used in xtitle of plot)
;               
;   view
;       if set, plot log-log plot of psd
;               
;       if VIEW=2, WAVENUM and POWER are taken as input parameters
;       (i.e., psd is not computed) for the PSD plot option.  In this
;       case the IMAGE parameter is not used, but a dummy value must be
;       supplied.
;               
;   title
;       plot title
;               
;   binpower
;       If set, changes the default bin size used for 2-D wavevector
;       binning.  Normally wavevector binning is set up to put one
;       unit of the scalor wavevector in each wavenumber bin:
;     
;             k = sqrt(kx^2+ky^2)         scalor wavenumber
;       
;             n < k < n+1
;     
;       where n is an integer index for each wavenuber bin.  anulus. The
;       kx and ky wavenumbers run from 0 to NX/2 and 0 to NY/2,
;       respectively, (NX/2 and NY/2 represent the Nyquist frequency) If
;       BINPOWER is set, the size of the wavenumber bins can be made to
;       increase as a power of the wavenumber so that
;     
;             binsize = wavenumber^BINPOWER
;     
;       for example setting binpower gt 0 causes more averaging at large
;       wavenumber and can be used to smooth out noisy power spectra.
;       A value of BINPOWER between .1 and .5 seems to be sufficient to
;       smooth out high frequency noise.  (default: binpower=0)
;               
;   xrange
;       XRANGE sets the min and max wavenumber included in power
;       spectrum plot. XRANGE is used to clip off noisy high frequency
;       part of psd which sometimes occurs beyond 1 cycle per pixel in
;       the horizontal or vertical direction.  XRANGE does not affect
;       the returned values of WAVENUM and POWER, but it does affect the
;       value of BETA.
;     
;       NOTE: For a square uniform grid the maximum wavenumber is
;       sqrt(2) x 1 cycle/pixel.
;               
;   density 
;       if set, plot spectral power density instead of spectral power.
;       This is equivalent to dividing the power spectra by the
;       wavenumber.
;               
;
;EXAMPLE:
;
;; PSD of a scaling field
;
;     w8x11
;     !p.multi=[0,1,2]
;     n=512                                          ; 
;     slope=3                                        ; power law slope
;     power=1./(1.>(dist(n)^(slope+1)))
;     gg=sqrt(power)                                 ; fourier modulus
;     gg=gg*exp(complex(0,2*!pi*randomu(iseed,n,n))) ; randomized phase
;     ff=float(fft(gg,1))                              ; realization
;     tvim,ff
;     psd,ff,/view
;
;; Spectra of a 1-d data
;
;     n=2^14
;     f=randf(n,2)
;     !p.multi=[0,1,2]
;     plot,w,f
;     psd,f,w,p,/view
;                                        
;     
;; PSD of a submatrix of a scene with spatially varying spectral structure, 
;;
;;     1. lower left quandrant:  scaling scene (SS) with spectral slope -2.5
;;     2. upper left quandrant:  SS plus structure at 0.125 nyq
;;     3. upper right quandrant: SS plus structure at .25 and 0.125 nyq
;;     4. upper left quandrant:  SS plus structure at .25  nyq
;;
;;        where nyq = 1.4141 cycles/(horizontal or vertical pixel)
;;
;;        to stop looping this example, put box in lower frame and click RMB
;
;   w8x11
;   !p.multi=[0,1,2]
;   nx=512 & ny=512
;   ff=randata(nx,ny,s=2.5)
;   ff=5*cos(0.125*!pi*findgen(nx))#cos(0.125*!pi*findgen(ny))*$
;       (((replicate(1,nx)#findgen(ny)/(ny-1))-.5)>0)+ff
;   ff=5*cos(0.25*!pi*findgen(nx))#cos(0.25*!pi*findgen(ny))*$
;       (((findgen(ny)/(ny-1))#replicate(1,ny)-.5)>0)+ff
;   tvim,ff
;   xwin=!x.window & xrng=!x.crange
;   ywin=!y.window & yrng=!y.crange
;   x1=nx/4 & x2=x1+nx/2
;   y1=ny/4 & y2=y1+ny/2
;
;   !p.multi=[4,2,4]
;   curbox,x1,x2,y1,y2,xwin,ywin,xrng,yrng,inc=8,/init,/mess,label='region 1'
;   psd,ff(x1:x2,y1:y2),/view,title='region 1'
;   curbox,x1,x2,y1,y2,xwin,ywin,xrng,yrng,inc=8,/init,/mess,label='region 2'
;   psd,ff(x1:x2,y1:y2),/view,title='region 2'
;   curbox,x1,x2,y1,y2,xwin,ywin,xrng,yrng,inc=8,/init,/mess,label='region 3'
;   psd,ff(x1:x2,y1:y2),/view,title='region 3'
;   curbox,x1,x2,y1,y2,xwin,ywin,xrng,yrng,inc=8,/init,/mess,label='region 4'
;   psd,ff(x1:x2,y1:y2),/view,title='region 4'

; 
;
;  author:  Paul Ricchiazzi                            may93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
; NOTE: the relation between a function and its FFT transform
;       is such that
;
;       n=128
;       f=randata(n,n,s=s)
;       g=fft(f,-1)                       ; forward transform
;       
;       ; total(f^2)/n^2=total(abs(g)^2)
;       
;       ; the average dispersion is equal to the total of the
;       ' squared norm of the fourier coefficients
;
;       print,total(f^2)/n^2,total(abs(g)^2)
;             3.32886      3.32879
;
;       ; if not for neglecting the zero freq component, this
;       ; would imply that
;
;       ; total((hanning(n,n)*f-fbar)^2)/n^2 = integral(w,p)*n^2
;
;       ; the factor of n^2 on the RHS is to compensate for the 
;       ; normalization of w to the Nyquist frequency 
;
;       fbar=total(f)/n^2
;       psd,f-fbar,w,p
;       print,total((hanning(n,n)*f-fbar)^2)/n^2,integral(w,p)*n^2
;             0.760900     0.652477
;       
;       ; pretty good
;

if not keyword_set(view) then view=0
if view lt 2 then begin
  sz=size(image)
  nx=sz(1)
  if sz(0) eq 2 then ny=sz(2) else ny=0
  
  case n_elements(scale) of
    0: begin &  sclx=1. &  scly=1. & end
    1: begin &  sclx=scale & scly=scale & end
    2: begin &  sclx=scale(0) & scly=scale(1) & end
  end
  
  imsig=stdev(image,imave)
  if ny eq 0 then begin
    ff=hanning(nx)*(image-imave)
    g=fft(ff,-1)
    wavenum=[findgen((nx+1)/2),1.+reverse(findgen(nx/2))]/(sclx*fix(nx/2))
    power=abs(g)^2
    wavenum=wavenum(1:nx/2)
    power=power(1:nx/2)
    if keyword_set(binpower) then begin
      power=exp(smooth(alog(power),binpower))
      wavenum=smooth(wavenum,binpower)
    endif
  endif else begin
    ff=hanning(nx,ny)*(image-imave)
    g=fft(ff,-1)
    
    wxv=[findgen((nx+1)/2),1.+reverse(findgen(nx/2))]/(sclx*fix(nx/2))
    wyv=[findgen((ny+1)/2),1.+reverse(findgen(ny/2))]/(scly*fix(ny/2)) 
  
    wavenum=sqrt((wxv # replicate(1,ny))^2+(replicate(1,nx) # wyv)^2)
  
    binsz=(sclx/fix(nx/2)) > (scly/fix(ny/2))
    power=2*!pi*wavenum*abs(g)^2
    ii=sort(wavenum)
    wavenum=wavenum(ii)
    power=power(ii)
    
;   average within wavenumber bins 
    if keyword_set(binpower) then bp=1.-binpower else bp=1 
    i=0
    dum=histogram((wavenum/binsz)^bp,reverse=ii)
    nbin=ii(0)-1
    for i=1,ii(0)-2 do begin
      is=ii(ii(i):ii(i+1)-1)
      ns=ii(i+1)-ii(i)
;      wavenum(i)=exp(total(alog(wavenum(is)))/ns)
;      power(i)=exp(total(alog(power(is)))/ns)
      wavenum(i)=total(wavenum(is))/ns
      power(i)=total(power(is))/ns
    endfor
    power=power(1:nbin-1)
    wavenum=wavenum(1:nbin-1)
  endelse
endif

if not keyword_set(xrange) then xrange=[min(wavenum,max=mx),mx]
if xrange(0) eq 0. then xrange(0)=min(wavenum)
ii=where(wavenum ge xrange(0) and wavenum le xrange(1))

if keyword_set(density) then begin
  p=power(ii)/wavenum(ii)
  ytitle='Spectral Power Density'
endif else begin
  ytitle='Spectral Power'
  p=power(ii)
endelse

beta=poly_fit(alog(wavenum(ii)),alog(p),1)

if keyword_set(view) then begin
  if keyword_set(unit) eq 0 then xt='wavenumber (normalized)' else $
                                 xt='wavenumber (cycles/'+unit+')'
  if keyword_set(title) eq 0 then title=' ' 
  plot_oo,wavenum(ii),p,title=title,ytitle=ytitle,$
      xtitle=xt,xstyle=1,xrange=[xrange(0),1.2*xrange(1)]
  ww=alog(10)*!x.crange([0,1])
  oplot,exp(ww),exp(poly(ww,beta)),li=3
  xs=10^(.05*!x.crange(0)+.95*!x.crange(1))
  ys=10^(.1*!y.crange(0)+.9*!y.crange(1))
  xyouts,xs,ys,string(f='(a,f6.2)','slope =',beta(1)),/data,$
       charsize=!p.charsize,align=1
endif

return
end




