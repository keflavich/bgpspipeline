 pro zenday,day,lat,mubar,mumax,hours
;+
; purpose:      compute daylight average of solar zenith, daylight
;               hours per day and maximum solar zenith as a function of
;               latitude and day of year
;
; useage:       zenday,day,lat,mubar,mumax,hours
;
; input:
;   day         day of year
;   lat         latitude
;
; output:
;   mubar       cosine of solar zenith angle (SZA) averaged over 
;               daylight hours
;
;   mumax       maximum value of cos(SZA)
;
;   hours       hours of sunlight 
;
;               NOTE: mubar*hours*Fo = average daily insolance
;
;                     where Fo is the solar constant
;
; EXAMPLE:      as a function of latitude and season make plots of 
;;
;;                         1. hours of sunlight
;;                         2. average daylight value of cos(SZA)
;;                         3. daily average insolation
;;                         4. maximum cos(SZA)
;      
;    !p.multi=[0,2,2]
;    day = findgen(365)+1
;    lat=findrng(-90,90,37)
;    gengrid,day,lat
;    zenday,day,lat,mubar,mumax,hours
;
;    ytickv=[-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90] & ytitle='Latitude'
;    contour, hours,day,lat, ytitle=ytitle,xstyle=5,/follow,$
;    ytickv=ytickv,yticks=14,levels=indgen(25),$
;    title='Daylight Hours'
;    xaxis_month
;    contour, mubar,day,lat, ytitle=ytitle,xstyle=5,/follow,$
;    ytickv=ytickv,yticks=14,levels=indgen(20)*.05,$
;    title='Average Daylight cos(zenith)'
;    xaxis_month
;    contour, 1371*hours*mubar/24.,day,lat, ytitle=ytitle,xstyle=5,/follow,$
;    ytickv=ytickv,yticks=14,levels=indgen(12)*50,$
;    title='Daily Average Insolation (W/m2)'
;    xaxis_month
;    contour, mumax,day,lat, ytitle=ytitle,xstyle=5,/follow,$
;    ytickv=ytickv,yticks=14,levels=indgen(20)*.05,$
;    title='Maximum cos(zenith)'
;    xaxis_month
;
;;
;  AUTHOR:      Paul Ricchiazzi        23oct92
;               Earth Space Research Group,  UCSB
; 
;-
;
;   /                                  /
;   | zz dt      con1*delta_t + con2 * |  cos(a t) dt
;   /                                  /
; ---------- =  -------------------------------------    =   mubar
;  delta_t                 delta_t
;
;
;  eqt = equation of time (minutes)  ; solar longitude correction = -15*eqt
;  dec = declination angle (degrees) = solar latitude 
;
; Analemma information from Jeff Dozier
;     This data is characterized by 74 points
;

nday=[  1.0,   6.0,  11.0,  16.0,  21.0,  26.0,  31.0,  36.0,  41.0,  46.0,$
       51.0,  56.0,  61.0,  66.0,  71.0,  76.0,  81.0,  86.0,  91.0,  96.0,$
      101.0, 106.0, 111.0, 116.0, 121.0, 126.0, 131.0, 136.0, 141.0, 146.0,$
      151.0, 156.0, 161.0, 166.0, 171.0, 176.0, 181.0, 186.0, 191.0, 196.0,$
      201.0, 206.0, 211.0, 216.0, 221.0, 226.0, 231.0, 236.0, 241.0, 246.0,$
      251.0, 256.0, 261.0, 266.0, 271.0, 276.0, 281.0, 286.0, 291.0, 296.0,$
      301.0, 306.0, 311.0, 316.0, 321.0, 326.0, 331.0, 336.0, 341.0, 346.0,$
      351.0, 356.0, 361.0, 366.0]

dec=[-23.06,-22.57,-21.91,-21.06,-20.05,-18.88,-17.57,-16.13,-14.57,-12.91,$
     -11.16, -9.34, -7.46, -5.54, -3.59, -1.62,  0.36,  2.33,  4.28,  6.19,$
       8.06,  9.88, 11.62, 13.29, 14.87, 16.34, 17.70, 18.94, 20.04, 21.00,$
      21.81, 22.47, 22.95, 23.28, 23.43, 23.40, 23.21, 22.85, 22.32, 21.63,$
      20.79, 19.80, 18.67, 17.42, 16.05, 14.57, 13.00, 11.33,  9.60,  7.80,$
       5.95,  4.06,  2.13,  0.19, -1.75, -3.69, -5.62, -7.51, -9.36,-11.16,$
     -12.88,-14.53,-16.07,-17.50,-18.81,-19.98,-20.99,-21.85,-22.52,-23.02,$
     -23.33,-23.44,-23.35,-23.06]

;
; compute the subsolar coordinates
;
latsun=day-day
mubar=latsun
mumax=latsun
hours=latsun

dd=((fix(day)-1.) mod 365.25) +1.
ii=sort(dd)

latsun(ii)=spline(nday,dec,dd(ii))

; lonsun=-15.*time*!dtor


ulat=(lat < 89.5) > (-89.5)

t0=(90.-ulat)*!dtor                            ; colatitude of point
t1=(90.-latsun)*!dtor                         ; colatitude of sun

;zz=cos(t0)*cos(t1)+sin(t0)*sin(t1)*cos(-15*time*!dtor) 

; dayligth hours have zz > 0

con1=cos(t0)*cos(t1)
con2=sin(t0)*sin(t1)
arg=-con1/con2                          

; 24 hour day

juu=where(con1-abs(con2) gt 0.,nuu)     ; polar summer: 24 hour sunlight
jud=where(abs(arg) le 1.,nud)           ; day night region

mumax=con1+con2

if nuu ne 0 then begin
  mubar(juu)=con1(juu)
  hours(juu)=24.
endif
if nud ne 0 then begin
  dang=acos(arg(jud))
  mubar(jud)=con1(jud)+con2(jud)*sin(dang)/dang
  hours(jud)=2*acos(-con1(jud)/con2(jud))/(15*!dtor)
endif

return
end








