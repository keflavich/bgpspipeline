; Most filenames, if they include the full path, will include the source name in that path
; therefore, this table is used to match source names to RA/Dec for centroiding, and
; outputs the source name for placement in the fits header
; This routine is only needed for pointing sources, not survey fields
pro find_object_radec,filename,ra,dec,source_name=source_name 
    ra = !values.f_nan & dec = !values.f_nan & source_name="not_named"
    if -1 ne stregex(filename,'[/_]pcal1[/_]') or  -1 ne stregex(filename,'1622m253[/_]')    then begin source_name='1622m253' &   ra= 246.445  &   dec=  -25.4606 & endif
    if -1 ne stregex(filename,'[/_]pcal2[/_]') or  -1 ne stregex(filename,'16293-2422[/_]')  then begin source_name='16293-2422' &   ra= 248.095  &   dec=  -24.4766 & endif
    if -1 ne stregex(filename,'[/_]pcal3[/_]') or  -1 ne stregex(filename,'1657m261[/_]')    then begin source_name='1657m261' &   ra= 255.222  &   dec=  -26.181 & endif
    if -1 ne stregex(filename,'[/_]pcal4[/_]') or  -1 ne stregex(filename,'ngc6334i[/_]')    then begin source_name='ngc6334i' &   ra= 260.222  &   dec=  -35.7838 & endif
    if -1 ne stregex(filename,'[/_]pcal5[/_]') or  -1 ne stregex(filename,'nrao-530[/_]')     then begin source_name='nrao-530' &   ra= 263.261  &   dec=  -13.0804 & endif
    if -1 ne stregex(filename,'[/_]pcal5[/_]') or  -1 ne stregex(filename,'nrao530[/_]')     then begin source_name='nrao530' &   ra= 263.261  &   dec=  -13.0804 & endif
    if -1 ne stregex(filename,'[/_]pcal6[/_]') or  -1 ne stregex(filename,'1741m038[/_]')    then begin source_name='1741m038' &   ra= 265.995  &   dec=  -3.83461 & endif
    if -1 ne stregex(filename,'[/_]pcal7[/_]') or  -1 ne stregex(filename,'1749p096[/_]')    then begin source_name='1749p096' &   ra= 267.887  &   dec=   9.65019 & endif
    if -1 ne stregex(filename,'[/_]pcal8[/_]') or  -1 ne stregex(filename,'g5.89[/_]')       then begin source_name='g5.89' &   ra= 270.127  &   dec=  -24.0668 & endif
    if -1 ne stregex(filename,'[/_]pcal9[/_]') or  -1 ne stregex(filename,'m8e[/_]')         then begin source_name='m8e' &   ra= 271.221  &   dec=  -24.4443 & endif
    if -1 ne stregex(filename,'[/_]pcal10[/_]') or -1 ne stregex(filename,'g10.62[/_c]')      then begin source_name='g10.62' &   ra= 272.62   &   dec=  -19.9305 & endif
    if -1 ne stregex(filename,'[/_]pcal11[/_]') or -1 ne stregex(filename,'1830m211[/_]')    then begin source_name='1830m211' &   ra= 278.416  &   dec=  -21.0611 & endif
    if -1 ne stregex(filename,'[/_]pcal12[/_]') or -1 ne stregex(filename,'g34.3[/_]')       then begin source_name='g34.3' &   ra= 283.327  &   dec=   1.24953 & endif
    if -1 ne stregex(filename,'[/_]pcal13[/_]') or -1 ne stregex(filename,'1908m202[/_]')    then begin source_name='1908m202' &   ra= 287.79   &   dec=  -20.1153 & endif
    if -1 ne stregex(filename,'[/_]pcal14[/_]') or -1 ne stregex(filename,'g45.1[/_]')       then begin source_name='g45.1' &   ra= 288.342  &   dec=   10.8482 & endif
    if -1 ne stregex(filename,'[/_]pcal15[/_]') or -1 ne stregex(filename,'ov236[/_]')       then begin source_name='ov236' &   ra= 291.212  &   dec=  -29.2416 & endif
    if -1 ne stregex(filename,'[/_]pcal16[/_]') or -1 ne stregex(filename,'1923p210[/_]')    then begin source_name='1923p210' &   ra= 291.498  &   dec=   21.1073 & endif
    if -1 ne stregex(filename,'[/_]pcal17[/_]') or -1 ne stregex(filename,'1954p513[/_]')    then begin source_name='1954p513' &   ra= 298.928  &   dec=   51.5302 & endif
    if -1 ne stregex(filename,'[/_]pcal18[/_]') or -1 ne stregex(filename,'cyga[/_]')        then begin source_name='cyga' &   ra= 299.869  &   dec=   40.7338 & endif
    if -1 ne stregex(filename,'[/_]pcal19[/_]') or -1 ne stregex(filename,'k3m50[/_]')  or -1 ne stregex(filename,'k3-50[/_]')      then begin source_name='k3m50' &   ra= 300.44   &   dec=   33.5454 & endif
    if -1 ne stregex(filename,'[/_]pcal20[/_]') or -1 ne stregex(filename,'2005p403[/_]')    then begin source_name='2005p403' &   ra= 301.937  &   dec=   40.4968 & endif
    if -1 ne stregex(filename,'[/_]pcal21[/_]') or -1 ne stregex(filename,'on1[/_]')         then begin source_name='on1' &   ra= 302.538  &   dec=   31.5271 & endif
    if -1 ne stregex(filename,'[/_]pcal22[/_]') or -1 ne stregex(filename,'2013p37[/_]')     then begin source_name='2013p37' &   ra= 303.87   &   dec=   37.1832 & endif
    if -1 ne stregex(filename,'[/_]pcal23[/_]') or -1 ne stregex(filename,'2021p317[/_]')    then begin source_name='2021p317' &   ra= 305.829  &   dec=   31.884 & endif
    if -1 ne stregex(filename,'[/_]pcal24[/_]') or -1 ne stregex(filename,'2023p336[/_]')    then begin source_name='2023p336' &   ra= 306.295  &   dec=   33.7168 & endif
    if -1 ne stregex(filename,'[/_]pcal25[/_]') or -1 ne stregex(filename,'gl2591[/_]')      then begin source_name='gl2591' &   ra= 307.353  &   dec=   40.1886 & endif
    if -1 ne stregex(filename,'[/_]pcal26[/_]') or -1 ne stregex(filename,'mwc_349[/_]')     then begin source_name='mwc_349' &   ra= 308.19   &   dec=   40.6602 & endif
    if -1 ne stregex(filename,'[/_]pcal27[/_]') or -1 ne stregex(filename,'w75n[/_]')        then begin source_name='w75n' &   ra= 309.652  &   dec=   42.6262 & endif
    if -1 ne stregex(filename,'[/_]pcal28[/_]') or -1 ne stregex(filename,'3c418[/_]')       then begin source_name='3c418' &   ra= 309.654  &   dec=   51.3202 & endif
    if -1 ne stregex(filename,'[/_]pcal29[/_]') or -1 ne stregex(filename,'crl2688[/_]')    then begin source_name='crl2688' &   ra= 315.578  &   dec=   36.6938 & endif
    if -1 ne stregex(filename,'[/_]pcal30[/_]') or -1 ne stregex(filename,'ngc_7027[/_]')     then begin source_name='ngc_7027' &   ra= 316.757  &   dec=   42.2362 & endif
    if -1 ne stregex(filename,'[/_]pcal31[/_]') or -1 ne stregex(filename,'2201p315[/_]')    then begin source_name='2201p315' &   ra= 330.812  &   dec=   31.7607 & endif
    if -1 ne stregex(filename,'[/_]3c454.3[/_]') or -1 ne stregex(filename,'2251p158[/_]')   then begin source_name='3c454.3' & ra= 343.490616 & dec =  +16.148211 & endif
    if -1 ne stregex(filename,'[/_]ngc7538[/_]')      then begin source_name='ngc7538' & ra=   348.4404 & dec =  +61.4725  & endif
    if -1 ne stregex(filename,'[/_]ngc7538irs1[/_]')      then begin source_name='ngc7538irs1' & ra=   348.4404 & dec =  +61.4725  & endif
    if -1 ne stregex(filename,'[/_]iras1629a[/_]')      then begin source_name='iras1629a'   & ra=   248.0958 & dec = -24.4778  & endif
    if -1 ne stregex(filename,'[/_]w3oh[/_b]')      then begin source_name='w3oh'   & ra=   36.7671 & dec =  61.8728  & endif
    if -1 ne stregex(filename,'[/_]cena[/_]')      then begin source_name='cena'   & ra=   201.365063 & dec =  -43.019112  & endif
    if -1 ne stregex(filename,'[/_]dr21[/_]')      then begin source_name='dr21'   & ra=   309.7546 & dec =  42.3286  & endif
    if -1 ne stregex(filename,'[/_]b335[/_]')      then begin source_name='b335'   & ra=   294.229 & dec =  +7.573  & endif
    if -1 ne stregex(filename,'[/_]sgrb2[/_]')      then begin source_name='sgrb2' & ra=   266.8350 & dec =  -28.3853  & endif
    if -1 ne stregex(filename,'[/_]gl591[/_]')      then begin source_name='gl591' & ra=   233.985692 & dec =  +39.831117  & endif
    if -1 ne stregex(filename,'[/_]3c273[/_]')      then begin source_name='3c273' & ra=   187.277915 & dec =  +02.052388  & endif
    if -1 ne stregex(filename,'[/_]3c274[/_]')      then begin source_name='3c274' & ra=   187.705931 & dec =  +12.391123  & endif
    if -1 ne stregex(filename,'[/_]3c279[/_]')      then begin source_name='3c279' & ra=   194.046527 & dec =  -05.789312  & endif
    if -1 ne stregex(filename,'[/_]3c345[/_]')      then begin source_name='3c345' & ra=   250.74504  & dec =  +39.81028  & endif
    if -1 ne stregex(filename,'[/_]3c446[/_]')      then begin source_name='3c446' & ra=   336.446914  & dec =  -04.950386  & endif
    if -1 ne stregex(filename,'[/_]arp220[/_]')      then begin source_name='arp220' & ra=   233.73837  & dec =  +23.50264  & endif
    if -1 ne stregex(filename,'[/_]hd115617[/_]')     then begin source_name= 'hd115617'  & ra =  199.601311  & dec = -18.311196   & endif
    if -1 ne stregex(filename,'[/_]oj287[/_]')        then begin source_name= 'oj287'     & ra =  133.703645  & dec = +20.108511   & endif      
    if -1 ne stregex(filename,'[/_]3c271[/_]')        then begin source_name= '3c271'     & ra =  185.9671    & dec = +16.1375 	   & endif
    if -1 ne stregex(filename,'[/_]1055p018[/_]')     then begin source_name= '1055p018'  & ra =  164.623355  & dec = +01.566340   & endif      
    if -1 ne stregex(filename,'[/_]rcra[/_]')         then begin source_name= 'rcra'      & ra =  285.473543  & dec = -36.952117   & endif      
    if -1 ne stregex(filename,'[/_]waql[/_]')         then begin source_name= 'waql'      & ra =  288.84767   & dec = -07.04719    & endif      
    if -1 ne stregex(filename,'[/_]oj287[/_]')        then begin source_name= 'oj287'     & ra =  133.703645  & dec = +20.108511   & endif      
    if -1 ne stregex(filename,'[/_]irc10216[/_]')     then begin source_name= 'irc10216'  & ra =  146.989092  & dec = +13.278794   & endif
    if -1 ne stregex(filename,'[/_]m51[/_]')       then begin source_name='m51'  & ra= 202.46821  & dec = 47.19467 & endif
    if -1 ne stregex(filename,'[/_]m82[/_i]')       then begin source_name='m82'  & ra= 148.96746  & dec = 69.68022 & endif
    if -1 ne stregex(filename,'[/_]m101[/_]')      then begin source_name='m101' & ra= 210.80212  & dec = 54.34808 & endif
    if -1 ne stregex(filename,'[/_]0007p106[/_]')      then begin source_name='0007p106' & ra=     002.629191  & dec =  +10.974862  & endif
    if -1 ne stregex(filename,'[/_]0202p149[/_]')      then begin source_name='0202p149' & ra=     031.210058  & dec =  +15.236401  & endif
    if -1 ne stregex(filename,'[/_]0234p285[/_]')      then begin source_name='0234p285' & ra=     039.468357  & dec =  +28.802497  & endif
    if -1 ne stregex(filename,'[/_]0420m014[/_]')      then begin source_name='0420m014' & ra=     065.815836  & dec =  -01.342518  & endif
    if -1 ne stregex(filename,'[/_]2145p067[/_]')      then begin source_name='2145p067' & ra=     327.022745  & dec =  +06.960723  & endif
    if -1 ne stregex(filename,'[/_]2223m052[/_]')      then begin source_name='2223m052' & ra=     336.446914  & dec =  -04.950386  & endif
    if -1 ne stregex(filename,'[/_]2255m282[/_]')      then begin source_name='2255m282' & ra=     344.524845  & dec =  -27.972571  & endif
    if -1 ne stregex(filename,'[/_]ngc7538s[/_]')      then begin source_name='ngc7538s' & ra=     348.4367    & dec =  +61.4475 	& endif
    if -1 ne stregex(filename,'[/_]ngc6823map[/_]')      then begin source_name='ngc6823map' & ra=     295.792    & dec =  +23.298 	& endif
    if -1 ne stregex(filename,'[/_]1334-127[/_]')      then begin source_name='1334-127' & ra=   204.415762  & dec =  -12.956859  & endif
    if -1 ne stregex(filename,'[/_]1655p077[/_]')      then begin source_name='1655p077' & ra=   254.537548  & dec =  7.690983  & endif
    if -1 ne stregex(filename,'[/_]1730m130[/_]')      then begin source_name='1730m130' & ra=   263.261274  & dec =  -13.080430  & endif
    if -1 ne stregex(filename,'[/_]1849p670[/_]')      then begin source_name='1849p670' & ra=   282.316968  & dec =  67.094911  & endif
    if -1 ne stregex(filename,'[/_]1921m293[/_]')      then begin source_name='1921m293' & ra=   291.212733  & dec =  -29.241700  & endif
    if -1 ne stregex(filename,'[/_]2200p420[/_]')      then begin source_name='2200p420' & ra=   330.680381  & dec =  42.277772  & endif
    if -1 ne stregex(filename,'[/_]2230p114[/_]')      then begin source_name='2230p114' & ra=   338.151704  & dec =  11.730807  & endif
    if -1 ne stregex(filename,'[/_]1418p546[/_]')      then begin source_name='1418p546' & ra=   214.944156  & dec =  54.387441  & endif
    if -1 ne stregex(filename,'[/_]0235p164[/_]')      then begin source_name='0235p164' & ra=   039.662209  & dec = +16.616465 & endif
    if -1 ne stregex(filename,'[/_]2255m282[/_]')      then begin source_name='2255m282' & ra=   344.524845  & dec = -27.972571 & endif
    if -1 ne stregex(filename,'[/_]0336m019[/_]')      then begin source_name='0336m019' & ra=   054.878907  & dec = -01.776612 & endif
    if -1 ne stregex(filename,'[/_]0355p508[/_]')      then begin source_name='0355p508' & ra=   059.873947  & dec = +50.963934 & endif
    if -1 ne stregex(filename,'[/_]0316p413[/_]')      then begin source_name='0316p413' & ra=   049.950667  & dec = +41.511695 & endif
    if -1 ne stregex(filename,'[/_]0415p379[/_]')      then begin source_name='0415p379' & ra=   064.588655  & dec = +38.026612 & endif
    if -1 ne stregex(filename,'[/_]0454m463[/_]')      then begin source_name='0454m463' & ra=   073.961552  & dec = -46.266301 & endif
    if -1 ne stregex(filename,'[/_]0528p134[/_]')      then begin source_name='0528p134' & ra=   082.735070  & dec = +13.531986 & endif
    if -1 ne stregex(filename,'[/_]0605m085[/_]')      then begin source_name='0605m085' & ra=   091.998747  & dec = -08.580549 & endif
    if -1 ne stregex(filename,'[/_]0607m157[/_]')      then begin source_name='0607m157' & ra=   092.420623  & dec = -15.711298 & endif
    if -1 ne stregex(filename,'[/_]0736p017[/_]')      then begin source_name='0736p017' & ra=   114.825141  & dec = +01.617949 & endif
    if -1 ne stregex(filename,'[/_]0754p100[/_]')      then begin source_name='0754p100' & ra=   119.277679  & dec = +09.943014 & endif
    if -1 ne stregex(filename,'[/_]ngc7129[/_]')      then begin source_name='ngc7129'   & ra=   325.733     & dec = +66.103    & endif
    if -1 ne stregex(filename,'[/_]XXXX[/_]')      then begin source_name='XXXX' & ra= 0  & dec = 0  & endif
;    if -1 ne stregex(filename,'[/_]0238p166[/_]')      then begin source_name='0238p166' & ra=   & dec =  & endif
    if -1 ne stregex(filename,'[/_]l000pps[/_]')    then begin source_name='l000pps' & ra=   266.648    & dec =  -29.1731 & endif
    if -1 ne stregex(filename,'[/_]l000pps[/_]')    then begin source_name='l000pps' & ra=   266.651    & dec =  -29.1723 & endif
    if -1 ne stregex(filename,'[/_]l002pps[/_]')    then begin source_name='l002pps' & ra=   267.345    & dec =  -26.5019 & endif
    if -1 ne stregex(filename,'[/_]l002pps[/_]')    then begin source_name='l002pps' & ra=   267.284    & dec =  -26.5527 & endif
    if -1 ne stregex(filename,'[/_]l006pps[/_]')    then begin source_name='l006pps' & ra=   269.396    & dec =  -23.9694 & endif
    if -1 ne stregex(filename,'[/_]l006pps[/_]')    then begin source_name='l006pps' & ra=   269.394    & dec =  -23.9676 & endif
    if -1 ne stregex(filename,'[/_]l006pps[/_]')    then begin source_name='l006pps' & ra=   269.394    & dec =  -23.9674 & endif
    if -1 ne stregex(filename,'[/_]l009pps[/_]')    then begin source_name='l009pps' & ra=   271.564    & dec =  -20.5290 & endif
    if -1 ne stregex(filename,'[/_]l009pps[/_]')    then begin source_name='l009pps' & ra=   271.563    & dec =  -20.5284 & endif
    if -1 ne stregex(filename,'[/_]l009pps[/_]')    then begin source_name='l009pps' & ra=   271.563    & dec =  -20.5288 & endif
    if -1 ne stregex(filename,'[/_]l009pps[/_]')    then begin source_name='l009pps' & ra=   271.561    & dec =  -20.5290 & endif
    if -1 ne stregex(filename,'[/_]l012pps[/_]')    then begin source_name='l012pps' & ra=   272.715    & dec =  -17.9318 & endif
    if -1 ne stregex(filename,'[/_]l012pps[/_]')    then begin source_name='l012pps' & ra=   272.710    & dec =  -17.9353 & endif
    if -1 ne stregex(filename,'[/_]l012pps[/_]')    then begin source_name='l012pps' & ra=   272.714    & dec =  -17.9315 & endif
    if -1 ne stregex(filename,'[/_]l012pps[/_]')    then begin source_name='l012pps' & ra=   272.712    & dec =  -17.9310 & endif
    if -1 ne stregex(filename,'[/_]l015pps[/_]')    then begin source_name='l015pps' & ra=   273.652    & dec =  -16.7612 & endif
    if -1 ne stregex(filename,'[/_]l015pps[/_]')    then begin source_name='l015pps' & ra=   273.653    & dec =  -16.7621 & endif
    if -1 ne stregex(filename,'[/_]l015pps[/_]')    then begin source_name='l015pps' & ra=   273.651    & dec =  -16.7628 & endif
    if -1 ne stregex(filename,'[/_]l015pps[/_]')    then begin source_name='l015pps' & ra=   273.652    & dec =  -16.7626 & endif
    if -1 ne stregex(filename,'[/_]l018pps[/_]')    then begin source_name='l018pps' & ra=   276.428    & dec =  -13.1746 & endif
    if -1 ne stregex(filename,'[/_]l018pps[/_]')    then begin source_name='l018pps' & ra=   276.429    & dec =  -13.1734 & endif
    if -1 ne stregex(filename,'[/_]l018pps[/_]')    then begin source_name='l018pps' & ra=   276.427    & dec =  -13.1754 & endif
    if -1 ne stregex(filename,'[/_]l018pps[/_]')    then begin source_name='l018pps' & ra=   276.425    & dec =  -13.1736 & endif
    if -1 ne stregex(filename,'[/_]l021pps[/_]')    then begin source_name='l021pps' & ra=   277.647    & dec =  -9.58007 & endif
    if -1 ne stregex(filename,'[/_]l021pps[/_]')    then begin source_name='l021pps' & ra=   277.647    & dec =  -9.58064 & endif
    if -1 ne stregex(filename,'[/_]l021pps[/_]')    then begin source_name='l021pps' & ra=   277.646    & dec =  -9.58085 & endif
    if -1 ne stregex(filename,'[/_]l021pps[/_]')    then begin source_name='l021pps' & ra=   277.647    & dec =  -9.58162 & endif
    if -1 ne stregex(filename,'[/_]l024pps[/_]')    then begin source_name='l024pps' & ra=   279.027    & dec =  -7.52565 & endif
    if -1 ne stregex(filename,'[/_]l024pps[/_]')    then begin source_name='l024pps' & ra=   279.027    & dec =  -7.52511 & endif
    if -1 ne stregex(filename,'[/_]l024pps[/_]')    then begin source_name='l024pps' & ra=   279.026    & dec =  -7.52468 & endif
    if -1 ne stregex(filename,'[/_]l024pps[/_]')    then begin source_name='l024pps' & ra=   279.027    & dec =  -7.52609 & endif
    if -1 ne stregex(filename,'[/_]l027pps[/_]')    then begin source_name='l027pps' & ra=   280.465    & dec =  -5.02977 & endif
    if -1 ne stregex(filename,'[/_]l027pps[/_]')    then begin source_name='l027pps' & ra=   280.465    & dec =  -5.03117 & endif
    if -1 ne stregex(filename,'[/_]l027pps[/_]')    then begin source_name='l027pps' & ra=   280.466    & dec =  -5.02916 & endif
    if -1 ne stregex(filename,'[/_]l027pps[/_]')    then begin source_name='l027pps' & ra=   280.465    & dec =  -5.02932 & endif
    if -1 ne stregex(filename,'[/_]l029pps[/_]')    then begin source_name='l029pps' & ra=   280.525    & dec =  -3.48671 & endif
    if -1 ne stregex(filename,'[/_]l029pps[/_]')    then begin source_name='l029pps' & ra=   280.569    & dec =  -3.58139 & endif
    if -1 ne stregex(filename,'[/_]l029pps[/_]')    then begin source_name='l029pps' & ra=   280.525    & dec =  -3.48833 & endif
    if -1 ne stregex(filename,'[/_]l029pps[/_]')    then begin source_name='l029pps' & ra=   280.523    & dec =  -3.54105 & endif
    if -1 ne stregex(filename,'[/_]l029pps[/_]')    then begin source_name='l029pps' & ra=   280.521    & dec =  -3.48833 & endif
    if -1 ne stregex(filename,'[/_]l029pps[/_]')    then begin source_name='l029pps' & ra=   280.520    & dec =  -3.54527 & endif
    if -1 ne stregex(filename,'[/_]l029pps_2[/_]')  then begin source_name='l029pps_2' & ra=   280.719    & dec =  -3.99919 & endif
    if -1 ne stregex(filename,'[/_]l029pps_2[/_]')  then begin source_name='l029pps_2' & ra=   280.717    & dec =  -3.99866 & endif
    if -1 ne stregex(filename,'[/_]l029pps_2[/_]')  then begin source_name='l029pps_2' & ra=   280.719    & dec =  -3.99919 & endif
    if -1 ne stregex(filename,'[/_]l029pps_2[/_]')  then begin source_name='l029pps_2' & ra=   280.718    & dec =  -4.00074 & endif
    if -1 ne stregex(filename,'[/_]l029pps_3[/_]')  then begin source_name='l029pps_3' & ra=   280.657    & dec =  -3.49457 & endif
    if -1 ne stregex(filename,'[/_]l029pps_3[/_]')  then begin source_name='l029pps_3' & ra=   280.657    & dec =  -3.49491 & endif
    if -1 ne stregex(filename,'[/_]l029pps_3[/_]')  then begin source_name='l029pps_3' & ra=   280.620    & dec =  -3.40124 & endif
    if -1 ne stregex(filename,'[/_]l029pps_3[/_]')  then begin source_name='l029pps_3' & ra=   280.617    & dec =  -3.45786 & endif
    if -1 ne stregex(filename,'[/_]l029pps_4[/_]')  then begin source_name='l029pps_4' & ra=   280.645    & dec =  -3.28481 & endif
    if -1 ne stregex(filename,'[/_]l029pps_4[/_]')  then begin source_name='l029pps_4' & ra=   280.645    & dec =  -3.33982 & endif
    if -1 ne stregex(filename,'[/_]l029pps_5[/_]')  then begin source_name='l029pps_5' & ra=   281.234    & dec =  -3.10849 & endif
    if -1 ne stregex(filename,'[/_]l029pps_5[/_]')  then begin source_name='l029pps_5' & ra=   281.233    & dec =  -3.15927 & endif
    if -1 ne stregex(filename,'[/_]l029pps_6[/_]')  then begin source_name='l029pps_6' & ra=   281.193    & dec =  -3.47157 & endif
    if -1 ne stregex(filename,'[/_]l029pps_6[/_]')  then begin source_name='l029pps_6' & ra=   281.195    & dec =  -3.52658 & endif
    if -1 ne stregex(filename,'[/_]l033pps[/_]')    then begin source_name='l033pps' & ra=   283.103    & dec =  -0.252475 & endif
    if -1 ne stregex(filename,'[/_]l033pps[/_]')    then begin source_name='l033pps' & ra=   282.982    & dec =  -0.208764 & endif
    if -1 ne stregex(filename,'[/_]l035pps[/_]')    then begin source_name='l035pps' & ra=   283.411    & dec =   1.83581 & endif
    if -1 ne stregex(filename,'[/_]l035pps[/_]')    then begin source_name='l035pps' & ra=   283.411    & dec =   1.83757 & endif
    if -1 ne stregex(filename,'[/_]l035pps[/_]')    then begin source_name='l035pps' & ra=   283.412    & dec =   1.83756 & endif
    if -1 ne stregex(filename,'[/_]l035pps[/_]')    then begin source_name='l035pps' & ra=   283.411    & dec =   1.83720 & endif
    if -1 ne stregex(filename,'[/_]l040pps[/_]')    then begin source_name='l040pps' & ra=   286.424    & dec =   6.43604 & endif
    if -1 ne stregex(filename,'[/_]l042pps[/_]')    then begin source_name='l042pps' & ra=   287.642    & dec =   9.13695 & endif
    if -1 ne stregex(filename,'[/_]l042pps[/_]')    then begin source_name='l042pps' & ra=   287.642    & dec =   9.13612 & endif
    if -1 ne stregex(filename,'[/_]l042pps[/_]')    then begin source_name='l042pps' & ra=   287.643    & dec =   9.13931 & endif
    if -1 ne stregex(filename,'[/_]l042pps[/_]')    then begin source_name='l042pps' & ra=   287.641    & dec =   9.13849 & endif
    if -1 ne stregex(filename,'[/_]l044pps[/_]')    then begin source_name='l044pps' & ra=   287.975    & dec =   9.59485 & endif
    if -1 ne stregex(filename,'[/_]l044pps[/_]')    then begin source_name='l044pps' & ra=   287.975    & dec =   9.59487 & endif
    if -1 ne stregex(filename,'[/_]l044pps[/_]')    then begin source_name='l044pps' & ra=   287.976    & dec =   9.59520 & endif
    if -1 ne stregex(filename,'[/_]l044pps[/_]')    then begin source_name='l044pps' & ra=   287.976    & dec =   9.59501 & endif
    if -1 ne stregex(filename,'[/_]l048pps[/_]')    then begin source_name='l048pps' & ra=   290.796    & dec =   14.4405 & endif
    if -1 ne stregex(filename,'[/_]l048pps[/_]')    then begin source_name='l048pps' & ra=   290.796    & dec =   14.4414 & endif
    if -1 ne stregex(filename,'[/_]l048pps[/_]')    then begin source_name='l048pps' & ra=   290.796    & dec =   14.4408 & endif
    if -1 ne stregex(filename,'[/_]l048pps[/_]')    then begin source_name='l048pps' & ra=   290.797    & dec =   14.4414 & endif
    if -1 ne stregex(filename,'[/_]l050pps[/_]')    then begin source_name='l050pps' & ra=   290.795    & dec =   14.4402 & endif
    if -1 ne stregex(filename,'[/_]l050pps[/_]')    then begin source_name='l050pps' & ra=   290.796    & dec =   14.4411 & endif
    if -1 ne stregex(filename,'[/_]l050pps[/_]')    then begin source_name='l050pps' & ra=   290.795    & dec =   14.4399 & endif
    if -1 ne stregex(filename,'[/_]l050pps[/_]')    then begin source_name='l050pps' & ra=   290.797    & dec =   14.4409 & endif
    if -1 ne stregex(filename,'[/_]l076pps[/_]')    then begin source_name='l076pps' & ra=   306.352    & dec =   37.3889 & endif
    if -1 ne stregex(filename,'[/_]l076pps[/_]')    then begin source_name='l076pps' & ra=   306.351    & dec =   37.3895 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.355    & dec =   40.1866 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.356    & dec =   40.1872 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.355    & dec =   40.1859 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.356    & dec =   40.1860 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.355    & dec =   40.1851 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.356    & dec =   40.1864 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.352    & dec =   40.1840 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.354    & dec =   40.1861 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.356    & dec =   40.1872 & endif
    if -1 ne stregex(filename,'[/_]l079pps[/_]')    then begin source_name='l079pps' & ra=   307.352    & dec =   40.1836 & endif
    if -1 ne stregex(filename,'[/_]l079pps_2[/_]')  then begin source_name='l079pps_2' & ra=   307.803    & dec =   40.0500 & endif
    if -1 ne stregex(filename,'[/_]l079pps_2[/_]')  then begin source_name='l079pps_2' & ra=   307.804    & dec =   40.0506 & endif
    if -1 ne stregex(filename,'[/_]l079pps_2[/_]')  then begin source_name='l079pps_2' & ra=   307.756    & dec =   40.1450 & endif
    if -1 ne stregex(filename,'[/_]l079pps_3[/_]')  then begin source_name='l079pps_3' & ra=   307.690    & dec =   39.7938 & endif
    if -1 ne stregex(filename,'[/_]l079pps_3[/_]')  then begin source_name='l079pps_3' & ra=   307.741    & dec =   39.7018 & endif
    if -1 ne stregex(filename,'[/_]l079pps_4[/_]')  then begin source_name='l079pps_4' & ra=   308.458    & dec =   40.1396 & endif
    if -1 ne stregex(filename,'[/_]l079pps_4[/_]')  then begin source_name='l079pps_4' & ra=   308.453    & dec =   40.1411 & endif
    if -1 ne stregex(filename,'[/_]l079pps_5[/_]')  then begin source_name='l079pps_5' & ra=   308.129    & dec =   39.9581 & endif
    if -1 ne stregex(filename,'[/_]l079pps_5[/_]')  then begin source_name='l079pps_5' & ra=   308.081    & dec =   40.0020 & endif
    if -1 ne stregex(filename,'[/_]l080_1pps[/_]')  then begin source_name='l080_1pps' & ra=   307.622    & dec =   41.2612 & endif
    if -1 ne stregex(filename,'[/_]l080_1pps[/_]')  then begin source_name='l080_1pps' & ra=   307.621    & dec =   41.2639 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.677    & dec =   39.7478 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.678    & dec =   39.7468 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.679    & dec =   39.7463 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.679    & dec =   39.7486 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.678    & dec =   39.7470 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.680    & dec =   39.7478 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.678    & dec =   39.7481 & endif
    if -1 ne stregex(filename,'[/_]l080pps[/_]')    then begin source_name='l080pps' & ra=   308.678    & dec =   39.7464 & endif
    if -1 ne stregex(filename,'[/_]l082pps[/_]')    then begin source_name='l082pps' & ra=   310.119    & dec =   41.9486 & endif
    if -1 ne stregex(filename,'[/_]l082pps[/_]')    then begin source_name='l082pps' & ra=   310.122    & dec =   41.9509 & endif
    if -1 ne stregex(filename,'[/_]l082pps[/_]')    then begin source_name='l082pps' & ra=   310.119    & dec =   41.9506 & endif
    if -1 ne stregex(filename,'[/_]l082pps[/_]')    then begin source_name='l082pps' & ra=   310.120    & dec =   41.9530 & endif
    if -1 ne stregex(filename,'[/_]l082pps[/_]')    then begin source_name='l082pps' & ra=   310.121    & dec =   41.9484 & endif
    if -1 ne stregex(filename,'[/_]l082pps[/_]')    then begin source_name='l082pps' & ra=   310.121    & dec =   41.9522 & endif
    if -1 ne stregex(filename,'[/_]l189pps1[/_]')   then begin source_name='l189pps1' & ra=   92.1960    & dec =   21.6084 & endif
    if -1 ne stregex(filename,'[/_]l189pps1[/_]')   then begin source_name='l189pps1' & ra=   92.1948    & dec =   21.6098 & endif
    if -1 ne stregex(filename,'[/_]l189pps2[/_]')   then begin source_name='l189pps2' & ra=   92.1439    & dec =   21.4882 & endif
    if -1 ne stregex(filename,'[/_]l189pps2[/_]')   then begin source_name='l189pps2' & ra=   92.1412    & dec =   21.4890 & endif
    if -1 ne stregex(filename,'[/_]l190pps[/_]')    then begin source_name='l190pps' & ra=   91.9222    & dec =   20.6300 & endif
    if -1 ne stregex(filename,'[/_]l190pps[/_]')    then begin source_name='l190pps' & ra=   91.9195    & dec =   20.6324 & endif
    if -1 ne stregex(filename,'[/_]l193pps[/_]')    then begin source_name='l193pps' & ra=   93.1945    & dec =   17.9785 & endif
    if -1 ne stregex(filename,'[/_]l193pps[/_]')    then begin source_name='l193pps' & ra=   93.1931    & dec =   17.9795 & endif
    if -1 ne stregex(filename,'[/_]l351pps[/_]')    then begin source_name='l351pps' & ra=   260.961    & dec =  -36.6501 & endif
    if -1 ne stregex(filename,'[/_]l351pps[/_]')    then begin source_name='l351pps' & ra=   260.962    & dec =  -36.6519 & endif
    if -1 ne stregex(filename,'[/_]l354pps[/_]')    then begin source_name='l354pps' & ra=   270.209    & dec =  -23.3456 & endif
    if -1 ne stregex(filename,'[/_]l354pps[/_]')    then begin source_name='l354pps' & ra=   270.210    & dec =  -23.3440 & endif
    if -1 ne stregex(filename,'[/_]l357pps[/_]')    then begin source_name='l357pps' & ra=   265.240    & dec =  -31.1849 & endif
    if -1 ne stregex(filename,'[/_]l357pps[/_]')    then begin source_name='l357pps' & ra=   265.240    & dec =  -31.1857 & endif
end 
