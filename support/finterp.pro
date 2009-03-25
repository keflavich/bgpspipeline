function finterp,tbl,uvar
;+
; FUNCTION       finterp 
;
; USEAGE         result=finterp(table,uvar)
;
; PURPOSE:       Compute the floating point interpolation index of
;                UVAR(i,j,k...) into TABLE(*,i,j,k...) or TABLE(*).
;                For example, if uvar(i,j) is half way between
;                table(4,i,j) and table(5,i,j) then result(i,j)=4.5.
;
;                NOTE: If TABLE is a vector the action of FINTERP is
;                the same as INTERPOL(findgen(n),TABLE,UVAR). However,
;                FINTERP should be much faster whenever UVAR is large
;                and the number of TABLE values (first dimension of
;                TABLE) is small.
;
;
; INPUT    
;
;    table       A matrix or vector.  If TABLE is not a vector, the 
;                first dimension of TABLE is interpreted as a vector
;                of values that correspond to each element of UVAR.
;                If TABLE is a vector, the action of FINTERP is the
;                same as INTERPOL(findgen(n),TABLE,UVAR)
;
;
;    uvar       a matrix of field values.
;
; OUTPUT:
;    result      the floating point interpolation index of  UVAR(i,j,k...)
;                into TABLE(*,i,j,k,...). 
; 
;; EXAMPLE:
;
; a=[[5.1,8.4],[6.7,3.1]]
; tbl=fltarr(5,2,2)
; 
; tbl(*,0,0)=3+findgen(5)
; tbl(*,1,0)=4+findgen(5)
; tbl(*,0,1)=4+findgen(5)*2
; tbl(*,1,1)=findgen(5)
; fi=finterp(tbl,a)
; print,f='(8a9)',' ','UVAR','/---','----','TBL','----','---\','FI' &$
; print,f='(a9,7f9.2)','(0,0):',a(0,0),tbl(*,0,0),fi(0,0) &$
; print,f='(a9,7f9.2)','(1,0):',a(1,0),tbl(*,1,0),fi(1,0) &$
; print,f='(a9,7f9.2)','(0,1):',a(0,1),tbl(*,0,1),fi(0,1) &$
; print,f='(a9,7f9.2)','(1,1):',a(1,1),tbl(*,1,1),fi(1,1) 
;   
; 
;; EXAMPLE:
;                Map surface albedo over some area, given satellite
;                radiance measurement on a 2d grid.  Assumptions:
;
;                 1. ff(m,i,j) = irradiance predictions at each point
;                    in a 2d grid.  The m index is over different
;                    values of surface albedo.  The table values vary
;                    from point-to point (the i and j indecies) due to
;                    changes in satellite and solar viewing angles as
;                    well as surface albedo.
;
;                 2. salb(m) = a vector of different surface albedos
;                    used in the model caculations.  
;
;                 3.  aa(i,j) = actual measured values of radiance
;                     on the same grid. 
;
;                To retrieve the optical surface albedo at each point
;                in the image use INTERPOLATE to compute the surface
;                albedo at each point:
;
;                     salb_map=interpolate(salb,finterp(ff,aa))
;
;                or if logrithmic interpolation is desired
;
;                     fndx=finterp(ff,aa)
;                     salb_map=interpolate(alog(salb_map+1),fndx)
;                     salb_map=exp(salb_map)-1.
;
; PROCEDURE:     uses WHERE to identify regions for interpolation.
;                a separate call to WHERE is used for each table interval.
;                The floating point index may extrapolate beyond the
;                limits of the TABLE. Hence UVAR values less-to or
;                greater-than the corresponding TABLE entries will
;                produce return values which are outside the TABLE
;                subscript range (INTERPOLATE knows how to handle this).
;
; RESTRICTIONS:  Table entries (first index of TABLE) must be monitonically 
;                increasing. If the table is not monitonically increasing
;                FINTERP only finds solutions for that part of the table
;                which is monitonically increasing.  In this case, the return
;                value for UVAR elements less than the relative minimum of
;                TABLE is set to -9999.
;
;  author:  Paul Ricchiazzi                            apr93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;- 

if n_params() eq 0 then begin
  xhelp,'finterp'
  return,0
endif

sz=size(uvar)
ndim=sz(0)

fndx=float(uvar)
fndx(*)=0.

szt=size(tbl)
nv=szt(1)


ndimtab=szt(0)

if ndimtab eq 1 then begin                      ; TBL is a vector

; if UVAR is actually a scalor, use FINDEX and return

  if ndim eq 0 then return, findex(tbl,float(uvar))

  tabmin=min(tbl)
  for i=0,nv-2 do begin
    tabbot=tbl(i)
    tabtop=tbl(i+1)
    ii=where(uvar gt tabbot and uvar le tabtop,nc)
    if nc gt 0 then fndx(ii)=i+float(uvar(ii)-tabbot)/(tabtop-tabbot)
  endfor

  tabbot=tbl(0)
  tabtop=tbl(1)
  ii=where(uvar le tabbot,nc)
  if nc gt 0 then fndx(ii)=float(uvar(ii)-tabbot)/(tabtop-tabbot)

  tabbot=tbl(nv-2)
  tabtop=tbl(nv-1)
  ii=where(uvar gt tabtop,nc)  
  if nc gt 0 then fndx(ii)=nv-2+float(uvar(ii)-tabbot)/(tabtop-tabbot)

  tabbot=tbl(0)
  ii=where(uvar lt tabmin and tabmin lt tabbot,nc)
  if nc gt 0 then fndx(ii)=-9999.

endif else begin                                ; TBL is a matrix

  nnarr=n_elements(uvar)
  nntab=n_elements(tbl)

  if nntab ne nnarr*nv then  message,'TBL size does not mesh with UVAR'
  
  jj=lindgen(nnarr)*nv

  tabmin=tbl(0+jj)                            ; same as tbl(0,*,*,*,...)
  
  for i=0,nv-2 do begin
    tabbot=tbl(i+jj)                          ; same as tbl(i,*,*,*,...)
    tabtop=tbl(i+1+jj)
    ii=where(uvar gt tabbot and uvar le tabtop,nc)
    if nc gt 0 then fndx(ii)=i+float(uvar(ii)-tabbot(ii))/ $
                                      (tabtop(ii)-tabbot(ii))
    tabmin=tabmin < tabbot
  endfor
  tabmin=tabmin < tabtop
  
  tabbot=tbl(0+jj)
  tabtop=tbl(1+jj)
  ii=where(uvar le tabbot,nc)
  if nc gt 0 then fndx(ii)=float(uvar(ii)-tabbot(ii))/(tabtop(ii)-tabbot(ii))
  
  tabbot=tbl(nv-2+jj)
  tabtop=tbl(nv-1+jj)
  ii=where(uvar gt tabtop,nc)  
  if nc gt 0 then fndx(ii)=nv-2+float(uvar(ii)-tabbot(ii))/ $
                                       (tabtop(ii)-tabbot(ii))
  
  tabbot=tbl(0+jj)
  ii=where(uvar lt tabmin and tabmin lt tabbot,nc)
  if nc gt 0 then fndx(ii)=-9999.

endelse

return,fndx

end


