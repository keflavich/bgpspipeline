function contlev,a,maxlev=maxlev
;+
; ROUTINE:    contlev
;
; PURPOSE:    find a good set of contour levels 
;
; USEAGE:     result=contlev(a)
;
; INPUT:      
;   a         an array
;
; KEYWORD INPUT:
;   maxlev    maximum number of levels on the plot.  Setting this keyword to,
;             say, 5 does not mean you will get 5 levels.  It just means no
;             more than 5 levels will be generated.
;
; OUTPUT:
;   result    a vector of contour levels
;
; EXAMPLE:    contour,dist(20),levels=contlev(dist(20),maxlev=8)
;
;  author:  Paul Ricchiazzi                            feb94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
;-
;
autorange,a,ntick,tickv,ntickmax=maxlev
return,tickv
end
