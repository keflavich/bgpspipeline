pro load_plot_colors

;October 2008 LE

;This program loads a few colors so you have more options than just
;red, green, blue, and yellow.  It's basically copied straight out
;of an IDL reference manual.


;pro load_fav_colors,bottom=bottom,names=names

;if (n_e(bottom) eq 0) then 

bottom=0

red=[0,255,0,255,0,255,0,255,$
     0,255,255,112,219,127,0,255]
grn=[0,0,255,255,255,0,0,255,$
     0.187,127.219,112,127,163,171]
blu=[0,255,255,0,0,0,255,255,$
     115,0,127,147,219,127,255,127]
tvlct,red,grn,blu,bottom

cols = create_struct('black',0,$
                     'magenta',1,$
                     'cyan',2,$
                     'yellow',3,$
                     'green',4,$
                     'red',5,$
                     'blue',6,$
                     'white',7,$
                     'navy',8,$
                     'gold',9,$
                     'pink',10,$
                     'aquamarine',11,$
                     'orchid',12,$
                     'grey',13)

defsysv,'!cols',cols

;defsysv,'!black',0
;defsysv,'!magenta',1
;defsysv,'!cyan',2
;defsysv,'!yellow',3
;defsysv,'!green',4
;defsysv,'!red',5
;defsysv,'!blue',6
;defsysv,'!white',7
;defsysv,'!navy',8
;defsysv,'!gold',9
;defsysv,'!pink',10
;defsysv,'!aquamarine',11
;defsysv,'!orchid',12
;defsysv,'!grey',13
;
; Somehow don't work with Bolocam settings ...
;defsysv,'!sky',14
;defsysv,'!beige',15
     
end
