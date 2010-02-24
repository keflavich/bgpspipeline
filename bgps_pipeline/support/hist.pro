pro hist,arr,binsz,abs=abs,overplot=overplot,xrange=xrange, $
     xtitle=xtitle,ytitle=ytitle,yrange=yrange,title=title,   $
     linestyle=linestyle,ymargin=ymargin


;+
; NAME:
;       HIST
;
; PURPOSE:
;         call histo procedure to plot a histogram with
;         correct values along the x-axis.  Calculates min, max for you.
;         If binsz is set, uses it, otherwise = 1.
;       
;
; CALLING SEQUENCE:
;       hist,variable
;
; INPUTS:
;         arr    array to be plotted
;
; KEYWORD INPUTS:
;
; OPTIONAL INPUTS:
;         binsz         bin size of histogram
;         /abs      --> compute the histogram in number of values
;         /cumul    --> compute the cumulative histogram
;         /overplot --> overplot the histogram
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
;     Jeff Hicke     Earth Space Research Group, UCSB  9/22/92
;
; MODIFICATION HISTORY:
;
;-
;


  if (keyword_set(linestyle) ne 0) then !p.linestyle = linestyle

  old_ymargin = !y.margin
  if (keyword_set(ymargin) ne 0) then !y.margin = ymargin

  if (n_elements(binsz) eq 0) then binsz = 1

  histo,arr,min(arr),max(arr),binsz,overplot=overplot,abs=abs,xrange=xrange,$
     xtitle=xtitle,ytitle=ytitle,yrange=yrange,title=title,/nochangefont

  !p.linestyle = 0

  !y.margin = old_ymargin 

end
