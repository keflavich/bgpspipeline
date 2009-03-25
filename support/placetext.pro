pro placetext,text,center=center,pos=pos,$
           color=color,thick=thick,fg_color=fg_color,bg_color=bg_color,$
           box=box,numsym=numsym,ystretch=ystretch,silent=silent

;+
; NAME:
;       PLACETEXT
;
; PURPOSE:
;       Put text on a plot using LEGEND.PRO.
;
; CALLING SEQUENCE:
;       placetext,'this is a test'
;
; INPUTS:
;       text        text to be written to screen.  May either be string
;                   array or string with different lines separated by '\'.
;
; OPTIONAL INPUTS:
;   center      lines are centered rather than left justified
;
;   (below are taken from legend.pro)
;
;   pos         position and size of legend area in normalized data
;               coordinates.  Format of this four element vector is
;               [x0,y0,x1,y1] where x0,y0 is the position of lower
;               left corner and x1,y1 is the position of the upper
;               right corner.  For example pos=[.5,.5,.9,.9] specifies
;               a legend in the upper right quadrant of the data
;               window.  If the POS parameter is not set or if POS is
;               set to zero, then the CURBOX procedure is called to
;               set the legend position interactively.
;
;               NOTE: the value of POS can be retrieved by setting POS
;               to a named variable which has an initial value of zero.
;
;   linestyle   an array of linestyle types, one for each element of LABELS
;
;   psym    an array of symbol types, one for each element of LABELS
;
;   color       an array of color indices, one for each element of LABELS.
;               Any elements of COLOR set to -1 causes the default color,
;               !P.COLOR, to be used.
;
;   thick       an array of line thicknesses, one for each element of LABELS
;               (default=!p.thick)
;
;   numsym      number of symbol nodes used to indicate linestyle or symbol
;               type.  The length of the line is measured in units of 4
;               character widths so that the length of the line
;               = 4*(NUMSYM-1) * X_CHARSIZE    (default=3)
;
;   fg_color    color of box and legend titles (default=!P.COLOR)
;
;   bg_color    background color. Setting BG_COLOR erases the area
;               covered by the legend (filling it with color BG_COLOR)
;               prior to writing the legend.  If both BG_COLOR and !p.color
;               are zero then the background color is reset to 255 to
;               gaurantee a readability.
;
;
;   box         if set draw a box around the legend text
;
;   ystretch    factor by which to increase vertical spacing of legend
;               entries. (default = 1)
;
;   silent      if set, don't print anything to the terminal
;
; OUTPUTS:
;
; EXAMPLE:
;
; PROCEDURE
;
; COMMON BLOCKS:
;       None.
;
; NOTES
;
; REFERENCES
; 
; AUTHOR and DATE:
;     Jeff Hicke     Earth Space Research Group, UCSB  2/22/94
;
; MODIFICATION HISTORY:
;
;-
;

   str_prefix = '.l'
   if (keyword_set(center)) then str_prefix = '.c'

   if (n_elements(text) eq 1)   $
   then labels=str_sep(text,'\')  $
   else labels=text

   for i=0,(n_elements(labels)-1) do  $
       labels(i) = str_prefix + labels(i)

   if (n_elements(labels) eq 1) then labels = labels(0) ; reduce to scalar

   linestyle=intarr(n_elements(labels))

   legend,labels,pos=pos,linestyle=linestyle,psym=psym,$
           color=color,thick=thick,fg_color=fg_color,bg_color=bg_color,$
           box=box,numsym=numsym,ystretch=ystretch,silent=silent

end
