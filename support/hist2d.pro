pro hist2d,x_variable,y_variable,   $
           tvim=tvim,xtitle=xtitle,ytitle=ytitle,title=title,nlevels=nlevels, $
           follow=follow,c_charsize=c_charsize,ymargin=ymargin,bindim=bindim

;+
; NAME:
;       HIST2D
;
; PURPOSE:
;       Plot a 2-dimensional histogram.
;
; CALLING SEQUENCE:
;       hist2d,x_values,y_values
;
; INPUTS:
;       x_variable     self-explanatory
;       y_variable     self-explanatory
;
; KEYWORD INPUTS:
;       bindim         number of bins on one side
;       tvim           plot image rather than contour
;       xtitle         title for x axis
;       ytitle         title for y axis
;       title          title for plot
;       nlevels        number of levels for contouring
;       follow         keyword to contour to select algorithm allowing labeling
;       c_charsize     contour charsize
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
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
;     Jeff Hicke     Earth Space Research Group, UCSB  3/15/94
;
; MODIFICATION HISTORY:
;
;-
;

   if (n_elements(title) eq 0) then title = ''
   if (n_elements(xtitle) eq 0) then xtitle = ''
   if (n_elements(ytitle) eq 0) then ytitle = ''
   if (n_elements(nlevels) eq 0) then nlevels = 0
   if (n_elements(c_charsize) eq 0) then c_charsize = 0
   old_ymargin = !y.margin
   if (n_elements(ymargin) ne 0) then !y.margin = ymargin

   min_x = min(x_variable,max=max_x)
   min_y = min(y_variable,max=max_y)
   
   if (n_elements(bindim) eq 0) then bindim = 100

   hist2d = hist_2d(long( (x_variable-min_x)/(max_x-min_x) * bindim),    $
                    long( (y_variable-min_y)/(max_y-min_y) * bindim) )

   if (keyword_set(tvim))    $
   then tvim,hist2d,/sc,/noframe,title=title     $
   else contour,hist2d,xstyle=5,ystyle=5,title=title,nlevels=nlevels,   $
           follow=follow,c_charsize=c_charsize

   axis,xaxis=0,xstyle=1,xrange=[min_x,max_x],xtitle=xtitle,xtick_get=xget, $
      /save
   axis,xaxis=1,xstyle=1,xrange=[min_x,max_x],xtitle='',   $
      xtickname=replicate(' ',n_elements(xget)+1)

   axis,yaxis=0,ystyle=1,yrange=[min_y,max_y],ytitle=ytitle,ytick_get=yget, $
      /save
   axis,yaxis=1,ystyle=1,yrange=[min_y,max_y],ytitle='',   $
      ytickname=replicate(' ',n_elements(yget)+1)

   !y.margin = old_ymargin

end
