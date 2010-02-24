 pro connected,image,nstring,view=view
;+
; routine:      connected
;
; useage:       connected,image,nstring,view=view
;
; purpose:      The bi-level image is searched for all pixels which are
;               are part a continous set of adjacent pixels. Those pixel
;               groupings which contain fewer than NSTRING "on" pixels are
;               set to zero.
; input:
;
;   image       a bi-level image array (2d)
;
;   nstring     the number of "on" pixels required for a given cluster of
;               adjacent pixels to survive.
;
; output:
;   image       a bi-level image with islands composed of fewer than nstring
;               pixels removed.
;
; EXAMPLE:
;
;   r=randata(128,128,s=2) gt 7
;   connected,r,3,/view
;
; WARNING:      this procedure can take a lot of time for large images.
;               for images larger than 64 x 64 computation times goes
;               something like 
;                               time=c * (NX x NY)^2
;
;               for a DecStation 5000/240, c=7.4e-8, and 
;               a 256x256 image takes about 5 minutes.
;
;  author:  Paul Ricchiazzi                            Nov93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
; first get rid of singletons

sz=size(image)
nx=sz(1)
ny=sz(2)

kern=replicate(1,3,3)
ii=where(convol(image,kern,/center) lt 2 and (image ne 0),nsing)
if nsing ne 0 then image(ii)=0

; recognize as connected square blocks containing NSTRING "on" pixels

if keyword_set(view) then begin
  poff=30
  xmult=(!d.x_vsize-poff)/nx
  ymult=(!d.y_vsize-poff)/ny
  tvscl,rebin(image,nx*xmult,ny*ymult,/sample),poff,poff
  pos=[poff,poff,xmult*nx+poff,ymult*ny+poff]
  plot,[0,nx-1],[0,ny-1],/nodata,pos=pos,/device,/noerase,/xstyle,/ystyle

  nlab=strcompress(string(nstring))
  label1='points connected to at least '+nlab+' others are shown in white'
  label2='unconfirmed points are grey'
  label3=' counting connected blocks... '
  xmessage,[label1,label2,' '],wbase=wbase,wlabels=wlabels
endif

isok=2
if nstring le 9 then begin
  ii=where(erode(image,kern) eq 1, nblock)
  if nblock gt 0 then begin
    image(ii)=isok             ; central pixel
    xx=ii mod nx
    yy=ii / nx
    image(xx-1,yy+1)=isok      ; upper left
    image(xx  ,yy+1)=isok      ; above center
    image(xx+1,yy+1)=isok      ; upper right
    image(xx-1,yy  )=isok      ; left of center
    image(xx+1,yy  )=isok      ; right of center
    image(xx-1,yy-1)=isok      ; lower left
    image(xx  ,yy-1)=isok      ; below center
    image(xx+1,yy-1)=isok      ; lower right
  endif
endif
  
if keyword_set(view) then begin
  tvscl,rebin(image,nx*xmult,ny*ymult,/sample),poff,poff
  plot,[0,nx-1],[0,ny-1],/nodata,pos=pos,/device,/noerase,/xstyle,/ystyle
  xmessage,'identify potentially connected points...' , relabel=wlabels(2)
endif

; find potential hits

ii=where(image eq 1,nc)

if keyword_set(view) then begin
  nlab='consider '+string(nc)+' remaining points...' 
  nlab=strcompress(nlab)
  xmessage,nlab, relabel=wlabels(2)
endif

for i=0l,nc-1 do begin
  xpos=ii(i) mod nx
  ypos=ii(i) / nx
  if image(xpos,ypos) eq 1 then begin
    jj=search2d(image<1,xpos,ypos,1,1,/diagonal)
    nn=n_elements(jj)
    if nn lt nstring then begin
      image(jj)=0                 ; zero out this string, its too short
    endif else begin
      image(jj)=isok              ; this one is long enough, no need to
                                  ;       consider others in string
    endelse
    if keyword_set(view) then begin
      tvscl,rebin(image,nx*xmult,ny*ymult,/sample),poff,poff
      plot,[0,nx-1],[0,ny-1],/nodata,pos=pos,/device,/noerase,/xstyle,/ystyle
      plots,[0,nx-1],[ypos,ypos],color=100
      plots,[xpos,xpos],[0,ny-1],color=100
      nlab='consider '+string(nc-1-i)+' remaining points...' 
      nlab=strcompress(nlab)
      xmessage,nlab, relabel=wlabels(2)
    endif
  endif
endfor

if keyword_set(view) then begin
  tvscl,rebin(image,nx*xmult,ny*ymult,/sample),poff,poff
  plot,[0,nx-1],[0,ny-1],/nodata,pos=pos,/device,/noerase,/xstyle,/ystyle
  xmessage,kill=wbase
endif

jone=where(image eq isok,nn)
if nn ne 0 then image(jone)=1
return
end    





