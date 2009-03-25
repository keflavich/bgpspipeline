pro uav_path,buf,labels,coor,trange=trange,select=select,sprite=sprite
;+
; ROUTINE:	uav_path
;
; PURPOSE:	dispay a time history of measured quantities obtained 
;               on a moving ship or plane.  UAV_PATH provides an easy
;               user interface to 1) select measured quantities to plot
;               and 2) run SPRITE to hilight the correspondences of 
;               different data channels as a function of time and position.
;
; USEAGE:	uav_path,buf,labels,coor,trange=trange,select=select
;
; INPUT:       
;   buf         array of data values of dimension (number of variables) 
;               x (number of samples). Two of the measured quantities
;               should correspond to the horizontal coordiates of the
;               sample location, for example longitude and latitude.
;               A third quantity should provide the time coordinate of
;               the measurements.
;
;   labels      string array of variable names
;
;   coor        Three element vector array of indecies in BUF which
;               correspond to time and the "x" and "y" horizontal
;               coordinates of the measurement.  For example the
;               uav/tddr data set has GPS_TIME, GPS_LON and GPS_LAT at
;               [7,3,2]. If COOR is not set, it defaults to [7,3,2].
;
;
; KEYWORD INPUT:
;
;   trange      time range of interest
;
;   select      array of variable indecies to plot.  You can also use
;               SELECT to retrieve the indecies of the plot quantities
;               selected interactively.  Just set SELECT to an
;               undefined or zero valued variable on the first call to
;               UAV_PATH and reuse the returned value of SELECT in the
;               next call to UAV_PATH to repeat the plot set, (perhaps
;               with a different setting of TRANGE).
;
;   sprite      run SPRITE after plots are displayed 
;
;   bad         a single scalor value which is interpreted as a "bad"
;               measurement.  Any time sample returning this value for any
;               particular plot quantity will be rejected.
;
;  
; EXAMPLE:	
;
;  get_uavtddr,buf,labels
;  select=0              
;  uav_path,buf,labels,select=select ; select uav quantities interactively
;                                         ; save selections in SELECT
;
;  uav_path,buf,labels,select=select,trange=[16,17],/sprite
;
;
;; you can also use UAV_PATH with ZOOMBAR to zero in on a time range
;
;  
;  get_uavtddr,buf,labels,coor
;  select=[0,5,11,12,17]
;
;  uav_path,buf,labels,coor,select=select
;  while zoombar(rng) do uav_path,buf,labels,select=select,trange=rng
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            feb95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;   
;-
;

loadct,5
w8x11

if not keyword_set(select) then begin
  w=menuws(labels,prompt=['select plot quantities','(up to eight)'],/order)
  select=w
endif else begin
  w=select
endelse

if keyword_set(sprite) then sprt=1 else sprt=0

npq=n_elements(w)
if npq gt 8 then begin
  npq=8
  w=w(0:7)
endif


IF n_elements(coor) eq 3 THEN BEGIN
  itime=coor(0)
  ilon=coor(1)
  ilat=coor(2)
ENDIF ELSE BEGIN
  itime=7
  ilon=3
  ilat=2
ENDELSE

if not keyword_set(trange) then trange=[-1.e20,1.e20]
bad=-99999.

b=bytarr(n_elements(buf(0,*)))
for i=0,n_elements(w)-1 do b([where(buf(w(i),*) eq bad)])=1
b([where( buf(itime,*) lt trange(0) or buf(itime,*) gt trange(1))])=1
ii=where(b eq 0)
b=0

case 1 of 
  npq eq 0: !p.multi=0
  npq eq 1: !p.multi=[0,1,2]
  npq le 3: !p.multi=[0,2,2]
  npq le 5: !p.multi=[0,2,3]
  npq le 8: !p.multi=[0,3,3]
endcase

!p.charsize=1.5
yt='Longitude'
xt='Latitude'
ti='Flight Path'

plot,buf(ilon,ii),buf(ilat,ii),psym=3,title=ti,xtit=xt,ytit=yt,/yno
if sprt then sprite,buf(ilon,ii),buf(ilat,ii),xtit=xt,ytit=yt,/init

xt='Time (hours)'
yt=''

for i=0,npq-1 do begin
  ti=labels(w(i))
  plot,buf(itime,ii),buf(w(i),ii),psym=3,title=ti,xtit=xt,ytit=yt
  if sprt then sprite,buf(itime,ii),buf(w(i),ii),xtit=xt,ytit=ti
  xt=''
endfor

if sprt then sprite,color=120

!p.charsize=0
return
end

