pro langley,sza,flx,flx0,tau,sigma,minmass=minmass,maxmass=maxmass, $
            am=am,pm=pm,view=view,psym=psym,color=color,overplot=overplot, $
            title=title,hw=hw,clrfilt=clrfilt
;+
; ROUTINE:  longley
;
; PURPOSE:  find TOA direct beam flux and atmospheric optical depth using
;           the Langley procedure. Additionally, produce Langley scatter
;           plot of direct beam flux vs airmass and show fit.
;
; USEAGE:   langley,sza,flx,flx0,tau,sigma,minmass=minmass,maxmass,
;                   view=view,psym=psym,color=color,$
;                   overplot=overplot,am=am,pm=pm,hw=hw
;
; INPUT:    
;
;  sza      solar zenith angle
;
;  flx      direct normal flux (direct beam irradiance divided by cos(sza))
;  
; KEYWORD INPUT:
;
;  minmass  minimum air mass limit.  points with air mass less then 
;           MINMASS are not used in regression.
;
;  maxmass  maximum air mass limit.  points with air mass greater then 
;           MAXMASS are not used in regression.
;
;  am       set to solar azimuth to obtain morning Langley regression
;  pm       set to solar azimuth to obtain afternoon Langley regression
;
;  clrfilt  if set values alog(flx)-smooth(alog(flx),n) gt CLRFILT are 
;           removed from the regression computation
;
;  view     display scatter plot and fitted regression line
;
;  psym     symbol used for scatter plot
;
;  color    used for regression line 
;
;  overplot if set, overplot results on existing plot frame
;
;  hw       if set use histogram weighting in regression computation.
;           This causes the regression to weigh all increments of air
;           mass equally.  Fractional values of HW (between 0 and 1)
;           causes the weighting factor to be raised to the HW
;           power. In some cases histogram weighting can improve the
;           accuracy of retrievals.
;
; OUTPUT:
;
;  flx0     intensity at zero airmass
;
;  tau      optical depth 
;
;  sigma    standard deviation of log (flx) from fitted line.  This is
;           an estimate of the fractional error.  For example sigma=.01
;           means the linear regression fits the data to within about 1%.
;           see example.
;
; DISCUSSION:
;  use langley procedure to fit direct normal flux by an equation of form
;
;          ln(I(m)) = ln(I(0)) - tau * m
; 
;  where I(m) is the direct normal flux at airmass m and tau is the 
;  optical depth.  Assumes direct beam transmission obeys Beers law.
;
;
; EXAMPLE:  
;
;    nn=200 &  doy=281 & lat=35. & lon=0. & time=findrng(7,17,nn)
;    zensun,doy,time,lat,lon,sza,az
;    szamx=80. & sza=sza(where(sza lt szamx)) & az=az(where(sza lt szamx))
;    flx=(100.+randomn(iseed,nn))*exp(-.1*airmass(sza))
;
;    w8x11 & !p.multi=[0,1,3] & set_charsize,1.5
;    langley,sza,flx,flx0,tau,sigma,/view,title='Morning, hw=1',/hw,am=az
;    langley,sza,flx,flx0,tau,sigma,/view,title='Morning',am=az
;    langley,sza,flx,flx0,tau,sigma,/view,title='Afternoon',pm=az
;    
;
; AUTHOR:   Paul Ricchiazzi                        09 Jan 97
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
                                 ; filter out bad points

ii=where(flx gt .01*max(flx))
y=alog(flx(ii))
m=airmass(sza(ii))

                                 ; select morning (pm) or afternoon (am) points

if keyword_set(am) then begin
  ii=where(sin(am*!dtor) gt 0.)
  y=y(ii)
  m=m(ii)
endif

if keyword_set(pm) then begin
  ii=where(sin(pm*!dtor) lt 0.)
  y=y(ii)
  m=m(ii)
endif

                                 ; remove points outside of airmass limits

yy=y
mm=m
nin=n_elements(mm)

if not keyword_set(minmass) then minmass=1.
if not keyword_set(maxmass) then maxmass=6.

ii=where(m ge minmass and m le maxmass,npnts)

if npnts eq 0 then $
  message,'no points between airmass limits MINMASS and MAXMASS'

y=y(ii)
m=m(ii)

if not keyword_set(hw) then begin
  w=m
  w(*)=1.
endif else begin
  nn=n_elements(m)
  w=abs(shift(m,-1)-shift(m,+1))
  w(0)=w(1)
  w(nn-1)=w(nn-2)
  w=w^hw
endelse

                                 ; remove points with too much variation


if keyword_set(clrfilt) then begin
  ii=where(abs(y-smooth(y,5)) lt clrfilt)
  y=y(ii)
  m=m(ii)
  w=w(ii)
endif
                                 ; do first regression

k=polyfitw(m,y,w,1,yfit,yband,sigma)

                                 ; remove outliers

ii=where(abs(y-yfit) lt .02<(1.5*sigma))
y=y(ii)
m=m(ii)
w=w(ii)

                                 ; do second regression

k=polyfitw(m,y,w,1,yfit,yband,sigma)

flx0=exp(k(0))
tau=-k(1)
  
sigmaw=sqrt(total(w*(yfit-y)^2)/total(w))

                                 ; make plots

if keyword_set(view) then begin

  if not keyword_set(psym) then psym=1

  if not keyword_set(title) then title=' '

  if n_elements(color) eq 0 then color=!p.color
  
  if keyword_set(overplot)  $
     then oplot,m,y,psym=psym $
     else plot,m,y,title=title,ytitle='Log(Direct Normal Irradiance)', $ $
                   xtitle='Air Mass',psym=psym,/ynozero
  oplot,mm,yy,psym=3,color=color
  oplot,m,k(0)+k(1)*m,color=color
  lgnd= '.rOptical Depth = '+string(f='(g7.3)',tau)
  lgnd= lgnd+'\.rTOA Flux = '+string(f='(g7.5)',flx0)
  legend,lgnd,pos=[.35,.65,.99,.99]

  lgnd= ' Sigma = '+string(f='(g7.3)',sigma)
  lgnd= lgnd+strcompress(string('\.l',n_elements(m),' out of ',nin,' points'))
  legend,lgnd,pos=[.01,.01,.65,.35]

endif

return
end


