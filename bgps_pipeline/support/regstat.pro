pro regstat,im
;+
; ROUTINE:  regstat
;
; PURPOSE:  display regional statistics of an image.
;
; USEAGE:   regstat,im
;
; INPUT:    
;  im       2-d array
;
; KEYWORD INPUT: none
;
; OUTPUT:   none
;
; DISCUSSION:
;           Use REGSTAT to print the regional statistics of selected areas
;           within a TVIM image.  The region is selected using CURBOX. 
;           The left and middle mouse buttons reduce and increase the
;           region size.  The right mouse button causes the region
;           statistics to be printed to the terminal (mean, standard
;           deviation, minimum, maximum and array indicies).  Exit the
;           procedure by hitting the right mouse button while the the
;           box is outside the plot area
;  
; EXAMPLE:  
;           im=randata(128,128,s=3)
;           tvim,im
;           regstat,im
;
; REVISIONS:
;
; AUTHOR:   Paul Ricchiazzi                        01 Jun 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;


mve,im
print,' '
font='-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1
xmessage,[' REGIONAL STATISTICS','',$
          ' LMB     -- decrease box size  ',$
          ' MMB     -- increase box size  ',$
          ' RMB     -- print statistics   ','',$
          ' EXIT     = RMB outside of plot'],wb=wb,font=font,title='REGSTAT'

sz=size(im)
nx=sz(1)
ny=sz(2)
ds=fix(.2*(nx<ny))
x1=2*ds
x2=3*ds
y1=2*ds
y2=3*ds
xrng=[0,nx-1]
yrng=[0,ny-1]
loop=1

count=0
while loop do begin
  
  x1=x1 > 0 < (nx-1)
  x2=x2 > 0 < (nx-1)
  y1=y1 > 0 < (ny-1)
  y2=y2 > 0 < (ny-1)
  var=stdev(im(x1:x2,y1:y2),mean)
  mn=min(im(x1:x2,y1:y2),max=mx)
  nel=(x2-x1+1)*(y2-y1+1)
  str=strcompress(string('(',x1,':',x2,',',y1,':',y2,')'),/remove_all)
  str=str+'='+strcompress((string(nel)),/remove_all)
  if count mod 22 eq 0 then $
    print,f='(4a13,a20)','mean','std dev','minimum','maximum','elements'
  print,f='(4g13.5,a25)',mean,var,mn,mx,str
  count=count+1
  wait,.1
  curbox,x1,x2,y1,y2,!x.window,!y.window,xrng,yrng,/init
  if x2-x1 eq 0 or y2-y1 eq 0 then loop=0
endwhile
xmessage,kill=wb
end


