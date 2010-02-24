pro plotcompare,xquantity,yquantity,title=title,ymargin=ymargin, $
                xtitle=xtitle,ytitle=ytitle,xrange=xrange,yrange=yrange, $
                psym=psym,hist=hist,bigtext=bigtext,bindim=bindim,tvim=tvim, $
                interactive=interactive,pos=pos,widetext=widetext
   
;+
; NAME:
;       PLOTCOMPARE
;
; PURPOSE:
;       Scatter plot two similar variables, print statistics.
;
; CALLING SEQUENCE:
;       plotcompare,xquantity,yquantity
;
; INPUTS:
;      xquantity      variable to plot along x-axis
;      yquantity      variable to plot along y-axis
;
; KEYWORD INPUTS:
;      hist        plot as 2D histogram (xrange, yrange turned off)
;      bindim      number of bins on one side for 2D histogram
;      tvim        display 2D histogram as image (default is contour plot)
;      interactive interactively set the statistics legend
;      pos         after locating legend with interactive keyword, specify 
;                  legend location with this
;      bigtext     print statistics with bigger font
;      widetext    print statistics with wider font for use in printouts
;
;   below are plot keywords:
;      title          
;      ymargin        
;      xtitle         
;      ytitle         
;      xrange
;      yrange
;      psym
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
;     Jeff Hicke     Earth Space Research Group, UCSB  1/04/94
;
; MODIFICATION HISTORY:
;
;-
;

   b = regress2(xquantity,yquantity, Yfit, A0, Sigma, Ftest, R, Rmul, Chisq)

   mean_bias_error = mean(xquantity-yquantity)
   
   if (n_elements(xrange) eq 0) then xrange = [0,max([xquantity,yquantity])]
   if (n_elements(yrange) eq 0) then yrange = [0,max([xquantity,yquantity])]
   if (n_elements(ymargin) eq 0) then ymargin = [4,2]
   if (n_elements(title) eq 0) then title = ''
   if (n_elements(xtitle) eq 0) then xtitle = ''
   if (n_elements(ytitle) eq 0) then ytitle = ''
   if (n_elements(psym) eq 0) then psym = 3

   if (keyword_set(hist)) then $
      hist2d,xquantity,yquantity,ymargin=ymargin,title=title,    $
          xtitle=xtitle, ytitle=ytitle, $
          bindim=bindim,tvim=tvim $
   else $
      plot,xquantity,yquantity,psym=psym,ymargin=ymargin,   $
         title=title, xtitle=xtitle, ytitle=ytitle, xrange=xrange, yrange=yrange
   fit_x = 2 * xrange
   oplot,fit_x,fit_x,linestyle=0
   oplot,fit_x,a0+b(0)*fit_x,linestyle=2
   text = ['Y = '+strpack(a0)+' + '+strpack(b(0))+' * X',   $
           'MBE (X-Y) = '+strpack(mean_bias_error), $
           'R^2 = '+strpack(r^2),   $
           'RMSE = '+strpack(rms(xquantity,yquantity))]
   if ( (keyword_set(interactive) eq 0) and (n_elements(pos) eq 0) ) then begin
      pos=[0.02,0.72,0.52,0.98]
      if (keyword_set(bigtext)) then pos=[0.02,0.66,0.64,0.98]
      if (keyword_set(widetext)) then pos=[0.02,0.66,0.84,0.98]
   endif
   placetext,text,pos=pos
   
end
