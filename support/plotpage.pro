pro plotpage,x,y,npage=npage,xrange=xrange,yrange=yrange,xrng=xrng, $
             _extra=_extra
;+
; ROUTINE:  plotpage
;
; PURPOSE:  
;
; USEAGE:   plotpage,x,y,npage=npage
;
; INPUT:    
;   x       variable ploted along x-axis
;   y       variable ploted along y-axis
;
; KEYWORD INPUT:
;
;   npage   suggested number of pages into which horizontal range of
;           plot is broken.  the actual number of pages is chosen to
;           make the x range values come out to nice even numbers.
;
;   xrange  x axis range which will be broken up into pages
;
;   yrange  either a vector specifying y range, or a scalor.  If
;           yrange is set to a scalor (e.g., /yrange) then the yrange
;           adapts to the y variable range appropriate to each page.
;
;           All other plot keywords are also accepted and passed to
;           the plot procedure.
;
; KEYWORD OUTPUT:
;
;   xrng    the x-axis range that corresponds to the last active page 
;           before plotpage is terminated.
;
; DISCUSSION:
;          use plotpage to page through pages of a very high density 
;          plot.  New pages (i.e., the next increment in the x-range
;          of the plot) are selected by the middle (forward) or left
;          (backward) mouse button.  The number of plot pages in which
;          to break the horizontal range of the plot is selected with
;          the keyword parameter npage.
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;
; solar,x,y
; plotpage,x,y,npage=100
;
; AUTHOR:   Paul Ricchiazzi                        24 Feb 97
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

if n_params() eq 1 then begin 
  ymax=max(x,min=ymin)
  if not keyword_set(yrange) then yrange=[ymin,ymax]
  xmax=n_elements(x)-1
  xmin=0
  if keyword_set(xrange) then autorange,xrange,ntick,tickv,ntickmax=npage $
                         else autorange,[xmin,xmax],ntick,tickv,ntickmax=npage
  dx=(tickv(1)-tickv(0))
  if n_elements(yrange) eq 1 then begin 
    while stepind(ic,ntick-1) do begin
      cursor,xxx,yyy,/nowait
      if yyy lt !y.crange(0) then begin
        ic=(ntick-1)*(xxx-!x.crange(0))/(!x.crange(1)-!x.crange(0))
        ic=ic>0<(ntick-2)
      endif      
      xrng=tickv(ic)+.5*dx+.51*[-dx,dx]
      plot,x,xrange=xrng,/xstyle,_extra=_extra,  $
         title=strcompress(string(f='(a,i5,a,i5)','Page ',ic+1,' of ',ntick-1))
    endwhile
  endif else begin
    while stepind(ic,ntick-1) do begin
      cursor,xxx,yyy,/nowait
      if yyy lt !y.crange(0) then begin
        ic=(ntick-1)*(xxx-!x.crange(0))/(!x.crange(1)-!x.crange(0))
        ic=ic>0<(ntick-2)
      endif      
      xrng=tickv(ic)+.5*dx+.51*[-dx,dx]
      plot,x,xrange=xrng,yrange=yrange,/xstyle,_extra=_extra, $
         title=strcompress(string(f='(a,i5,a,i5)','Page ',ic+1,' of ',ntick-1))
    endwhile
  endelse
endif else begin
  ymax=max(y,min=ymin)
  if not keyword_set(yrange) then yrange=[ymin,ymax]
  xmax=max(x,min=xmin)
  if keyword_set(xrange) then autorange,x,ntick,tickv,ntickmax=npage $
                         else autorange,[xmin,xmax],ntick,tickv,ntickmax=npage
  dx=(tickv(1)-tickv(0))
  if n_elements(yrange) eq 1 then begin 
    while stepind(ic,ntick-1) do begin
      cursor,xxx,yyy,/nowait
      if yyy lt !y.crange(0) then begin
        ic=(ntick-1)*(xxx-!x.crange(0))/(!x.crange(1)-!x.crange(0))
        ic=ic>0<(ntick-2)
      endif      
      xrng=tickv(ic)+.5*dx+.51*[-dx,dx]
      plot,x,y,xrange=xrng,/xstyle,_extra=_extra,  $
         title=strcompress(string(f='(a,i5,a,i5)','Page ',ic+1,' of ',ntick-1))
    endwhile
  endif else begin
    while stepind(ic,ntick-1) do begin
      cursor,xxx,yyy,/nowait
      if yyy lt !y.crange(0) then begin
        ic=(ntick-1)*(xxx-!x.crange(0))/(!x.crange(1)-!x.crange(0))
        ic=ic>0<(ntick-2)
      endif      
      xrng=tickv(ic)+.5*dx+.51*[-dx,dx]
      plot,x,y, xrange=xrng,yrange=yrange,/xstyle,_extra=_extra, $
         title=strcompress(string(f='(a,i5,a,i5)','Page ',ic+1,' of ',ntick-1))
    endwhile
  endelse
endelse

return
end
