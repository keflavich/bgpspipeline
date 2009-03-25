function interp,table,utab,u,vtab,v,xtab,x,ytab,y,ztab,z,$
                 grid=grid,missing=missing,clip=clip, $
                 i1=i1,i2=i2,i3=i3,i4=i4,i5=i5, $
                 f1=f1,f2=f2,f3=f3,f4=f4,f5=f5, $
                 use_if=use_if
;+
; ROUTINE:    interp
;
; PURPOSE:    interpolate on a table of up to 5 dimensions
;
; USEAGE:     result=interp(table,utab,u,[vtab,v,[xtab,x,[ytab,y,[ztab,z]]]])
;
; INPUT:
;   table     table of values depending on upto 5 parameters
;
;   utab      1-d  (monitonically increasing) table of 1st parameter 
;   u         array of values of 1st parameter
;   vtab      1-d  (monitonically increasing) table of 2nd parameter
;   v         array of values of 2nd parameter
;   xtab      1-d  (monitonically increasing) table of 3rd parameter
;   x         array of values of 3rd parameter
;   ytab      1-d  (monitonically increasing) table of 4th parameter
;   y         array of values of 4th parameter
;   ztab      1-d  (monitonically increasing) table of 5th parameter
;   z         array of values of 5th parameter
;
;   NOTE:     the number of input parameters must be appropriate to
;             the size of the look-up table.  For example for a 3-d table,
;             parameters ytab,y,ztab, and z should not be supplied.
;
; KEYWORD INPUT:
;  GRID       if set the input parameters are used to create a grid of
;             parameter values.  In this case the input parameters need not
;             be all the same size but should all be vectors.  If GRID is
;             not set all input arrays (u,v,x,y,z) and the returned value
;             are of the same size and dimensionality.
;
;  MISSING    The value to return for ARRAY elements outside the bounds 
;             of TABLE.  If MISSING is not set return value is either
;             the nearest value of TABLE or an extrapolated value, depending
;             on how CLIP is set. 
;
;  CLIP       If this keyword is set, locations less than the minimum or 
;             greater than the maximum corresponding subscript of TABLE
;             are set to the nearest element of TABLE.  The effect of 
;             MISSING is disabled when CLIP is set.
;
;   i1...i5
;   f1...f5   these keywords are used in conjunction with the use_if
;             keyword.  If use_if is not set, the i's and f's are
;             calculated and returned.  If use_if is set, the i's and
;             f's are not calculated but taken from the keywords.
;             This is useful when there exists multiple TABLEs based
;             on the same dimensions and variables, and one wishes to
;             improve the performance.  In this case, the first time
;             INTERP is called, the i's and f's are specified in the
;             call but use_if is not set.  In subsequent calls, use_if
;             is set.
;
;   use_if    keyword to indicate that i's and f's should not be calculated
;             but rather are input by user
; 
; OUTPUT:
;   result    interpolated value
;
; PROCEDURE:  FINDEX is used to compute the floating point interpolation
;             factors into lookup table TABLE. When the dimensionality 
;             of TABLE is 3 or less and either CLIP or MISSING is set,
;             then IDL library procedure INTERPOLATE is used to perform the
;             actual interpolations.  Otherwise the interpolations are
;             explicitly carried out as mono-, bi-, tri-, tetra- or
;             penta-linear interpolation, depending on the
;             dimensionality of TABLE.
;
; EXAMPLE:
;
;; Here is an example of how to interpolate into a large DISORT
;; radiance lookup table to find radiance at given values of optical
;; depth, surface albedo, relative azimuth, satellite zenith
;; angle and solar zenith angle.
;
;  file='~paul/palmer/runs/0901a.dat'
;  readrt20,file,winf,wsup,phidw,topdn,topup,topdir,botdn,botup,botdir,$
;                   phi,theta,rad,tau,salb,sza
;
;  phi=phi(*,0,0,0)
;  theta=theta(*,0,0,0)
;  tauv=alog(1.25^findgen(20)+1.)
;  taut=alog(tau+1.)
;  sa0=findgen(10)*.1
;
;;   rel azimuth    sat_zen   surface_albedo
;      p0=130 &      t0=20 &      s0=60
;  buf=interp(rad,phi,p0,theta,t0,taut,tauv,salb,sa0,sza,s0,/grid)
;  plot,exp(tauv)-1.,buf(0,0,*,9)
;  for i=0,8 do oplot,exp(tauv)-1.,buf(0,0,*,i)
;
;  An example for use_if:
;
;    DISORT is used to build two look up tables, RTM_bb_botdn and RTM_bb_topdn,
;    based on the same parameters of tau, sza, wv, and o3.  Given measurements
;    of these variables, BOTDN and TOPDN can be interpolated.  However, since
;    the measurements are the same, and the LUTs are built similarly, it is
;    redundant to calculate the i's and f's twice.
;
;  bb_botdn = interp(RTM_bb_botdn,    $
;                    RTM_bb_tau,       all_tau_arr, $
;                    RTM_bb_sza,       all_sza_arr, $
;                    RTM_bb_wv,        all_wv_arr , $
;                    RTM_bb_o3,        all_o3_arr, $
;                    i1=i1,f1=f1,i2=i2,f2=f2,i3=i3,f3=f3,i4=i4,f4=f4)
;  bb_topdn = interp(RTM_bb_topdn,    $
;                    RTM_bb_tau,       all_tau_arr, $
;                    RTM_bb_sza,       all_sza_arr, $
;                    RTM_bb_wv,        all_wv_arr , $
;                    RTM_bb_o3,        all_o3_arr, $
;                    i1=i1,f1=f1,i2=i2,f2=f2,i3=i3,f3=f3,i4=i4,f4=f4,/use_if)
;
;  
;  author:  Paul Ricchiazzi                            sep93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

sz=size(table)
nd=sz(0)
if n_params() ne 2*nd+1 then $
     message,'number of parameters does not match TABLE dimension'

case nd of
  1:begin                                       ; linear
    n1=sz(1)
    
    if (keyword_set(use_if) eq 0) then $
       f1=findex(utab,u)
    
    if keyword_set(clip) then begin
      sum=interpolate(table,f1)
    endif else begin
      if n_elements(missing) ne 0 then begin
        sum=interpolate(table,f1,missing=missing)
      endif else begin
        if (keyword_set(use_if) eq 0) then begin
           i1=fix(f1)<(n1-2)>0
           f1=f1-i1
        endif
        sum=table(i1  )*(1-f1)+table(i1+1)*   f1
      endelse
    endelse
  end

  2:begin                                       ; bi-linear
    n1=sz(1)
    n2=sz(2)
    
    if (keyword_set(use_if) eq 0) then begin
       f1=findex(utab,u)
       f2=findex(vtab,v)
    endif
    
    if keyword_set(grid) then gengrid,f1,f2
    
    if keyword_set(clip) then begin
      sum=interpolate(table,f1,f2)
    endif else begin
      if n_elements(missing) ne 0 then begin
        sum=interpolate(table,f1,f2,missing=missing)
      endif else begin
        if (keyword_set(use_if) eq 0) then begin
           i1=fix(f1)<(n1-2)>0
           i2=fix(f2)<(n2-2)>0
           f1=f1-i1
           f2=f2-i2
        endif
        sum=table(i1  ,i2  )*(1-f1)*(1-f2)
        sum=table(i1+1,i2  )*   f1 *(1-f2)+sum
        sum=table(i1  ,i2+1)*(1-f1)*   f2 +sum
        sum=table(i1+1,i2+1)*   f1 *   f2 +sum
      endelse
    endelse
  end

  3:begin                                       ; tri-linear
    n1=sz(1)
    n2=sz(2)
    n3=sz(3)
    
    if (keyword_set(use_if) eq 0) then begin
       f1=findex(utab,u)
       f2=findex(vtab,v)
       f3=findex(xtab,x)
    endif

    if keyword_set(grid) then gengrid,f1,f2,f3
    
    if keyword_set(clip) then begin
      sum=interpolate(table,f1,f2,f3)
    endif else begin
      if n_elements(missing) ne 0 then begin
        sum=interpolate(table,f1,f2,f3,missing=missing)
      endif else begin
        if (keyword_set(use_if) eq 0) then begin
           i1=fix(f1)<(n1-2)>0
           i2=fix(f2)<(n2-2)>0
           i3=fix(f3)<(n3-2)>0
           f1=f1-i1
           f2=f2-i2
           f3=f3-i3
        endif
        sum=table(i1  ,i2  ,i3  )*(1-f1)*(1-f2)*(1-f3)
        sum=table(i1+1,i2  ,i3  )*   f1 *(1-f2)*(1-f3)+sum
        sum=table(i1  ,i2+1,i3  )*(1-f1)*   f2 *(1-f3)+sum
        sum=table(i1+1,i2+1,i3  )*   f1 *   f2 *(1-f3)+sum
        sum=table(i1  ,i2  ,i3+1)*(1-f1)*(1-f2)*   f3 +sum
        sum=table(i1+1,i2  ,i3+1)*   f1 *(1-f2)*   f3 +sum
        sum=table(i1  ,i2+1,i3+1)*(1-f1)*   f2 *   f3 +sum
        sum=table(i1+1,i2+1,i3+1)*   f1 *   f2 *   f3 +sum
      endelse
    endelse
  end

  4:begin                                       ; tetra-linear
    n1=sz(1)
    n2=sz(2)
    n3=sz(3)
    n4=sz(4)
    
    if (keyword_set(use_if) eq 0) then begin
       f1=findex(utab,u)
       f2=findex(vtab,v)
       f3=findex(xtab,x)
       f4=findex(ytab,y)
       
       if keyword_set(grid) then gengrid,f1,f2,f3,f4
       
       i1=fix(f1)<(n1-2)>0
       i2=fix(f2)<(n2-2)>0
       i3=fix(f3)<(n3-2)>0
       i4=fix(f4)<(n4-2)>0
       f1=f1-i1
       f2=f2-i2
       f3=f3-i3
       f4=f4-i4
    endif

    if keyword_set(clip) then begin
      f1=f1>0.<1.
      f2=f2>0.<1.
      f3=f3>0.<1.
      f4=f4>0.<1.
    endif else begin
      jmiss=where(f1 lt 0. or f1 gt 1. or $
                  f2 lt 0. or f2 gt 1. or $
                  f3 lt 0. or f3 gt 1. or $
                  f4 lt 0. or f4 gt 1.,nmiss)
    endelse
    
    sum=table(i1  ,i2  ,i3  ,i4  )*(1-f1)*(1-f2)*(1-f3)*(1-f4)
    sum=table(i1+1,i2  ,i3  ,i4  )*   f1 *(1-f2)*(1-f3)*(1-f4)+sum
    sum=table(i1  ,i2+1,i3  ,i4  )*(1-f1)*   f2 *(1-f3)*(1-f4)+sum
    sum=table(i1+1,i2+1,i3  ,i4  )*   f1 *   f2 *(1-f3)*(1-f4)+sum
    sum=table(i1  ,i2  ,i3+1,i4  )*(1-f1)*(1-f2)*   f3 *(1-f4)+sum
    sum=table(i1+1,i2  ,i3+1,i4  )*   f1 *(1-f2)*   f3 *(1-f4)+sum
    sum=table(i1  ,i2+1,i3+1,i4  )*(1-f1)*   f2 *   f3 *(1-f4)+sum
    sum=table(i1+1,i2+1,i3+1,i4  )*   f1 *   f2 *   f3 *(1-f4)+sum
    sum=table(i1  ,i2  ,i3  ,i4+1)*(1-f1)*(1-f2)*(1-f3)*   f4 +sum
    sum=table(i1+1,i2  ,i3  ,i4+1)*   f1 *(1-f2)*(1-f3)*   f4 +sum
    sum=table(i1  ,i2+1,i3  ,i4+1)*(1-f1)*   f2 *(1-f3)*   f4 +sum
    sum=table(i1+1,i2+1,i3  ,i4+1)*   f1 *   f2 *(1-f3)*   f4 +sum
    sum=table(i1  ,i2  ,i3+1,i4+1)*(1-f1)*(1-f2)*   f3 *   f4 +sum
    sum=table(i1+1,i2  ,i3+1,i4+1)*   f1 *(1-f2)*   f3 *   f4 +sum
    sum=table(i1  ,i2+1,i3+1,i4+1)*(1-f1)*   f2 *   f3 *   f4 +sum
    sum=table(i1+1,i2+1,i3+1,i4+1)*   f1 *   f2 *   f3 *   f4 +sum
    if n_elements(missing) gt 0 then begin
      if keyword_set(nmiss) ne 0 then sum(jmiss)=missing
    endif  
  end

  5:begin                                       ; penta-linear
    n1=sz(1)
    n2=sz(2)
    n3=sz(3)
    n4=sz(4)
    n5=sz(5)
    
    if (keyword_set(use_if) eq 0) then begin
       f1=findex(utab,u)
       f2=findex(vtab,v)
       f3=findex(xtab,x)
       f4=findex(ytab,y)
       f5=findex(ztab,z)
       
       if keyword_set(grid) then gengrid,f1,f2,f3,f4,f5
       
       i1=fix(f1)<(n1-2)>0
       i2=fix(f2)<(n2-2)>0
       i3=fix(f3)<(n3-2)>0
       i4=fix(f4)<(n4-2)>0
       i5=fix(f5)<(n5-2)>0
       f1=f1-i1
       f2=f2-i2
       f3=f3-i3
       f4=f4-i4
       f5=f5-i5
    endif

    if keyword_set(clip) then begin
      f1=f1>0.<1.
      f2=f2>0.<1.
      f3=f3>0.<1.
      f4=f4>0.<1.
      f5=f5>0.<1.
    endif else begin
      jmiss=where(f1 lt 0. or f1 gt 1. or $
                  f2 lt 0. or f2 gt 1. or $
                  f3 lt 0. or f3 gt 1. or $
                  f4 lt 0. or f4 gt 1. or $
                  f5 lt 0. or f5 gt 1.,nmiss)
    endelse
    
    sum=table(i1  ,i2  ,i3  ,i4  ,i5  )*(1-f1)*(1-f2)*(1-f3)*(1-f4)*(1-f5)
    sum=table(i1+1,i2  ,i3  ,i4  ,i5  )*   f1 *(1-f2)*(1-f3)*(1-f4)*(1-f5)+sum
    sum=table(i1  ,i2+1,i3  ,i4  ,i5  )*(1-f1)*   f2 *(1-f3)*(1-f4)*(1-f5)+sum
    sum=table(i1+1,i2+1,i3  ,i4  ,i5  )*   f1 *   f2 *(1-f3)*(1-f4)*(1-f5)+sum
    sum=table(i1  ,i2  ,i3+1,i4  ,i5  )*(1-f1)*(1-f2)*   f3 *(1-f4)*(1-f5)+sum
    sum=table(i1+1,i2  ,i3+1,i4  ,i5  )*   f1 *(1-f2)*   f3 *(1-f4)*(1-f5)+sum
    sum=table(i1  ,i2+1,i3+1,i4  ,i5  )*(1-f1)*   f2 *   f3 *(1-f4)*(1-f5)+sum
    sum=table(i1+1,i2+1,i3+1,i4  ,i5  )*   f1 *   f2 *   f3 *(1-f4)*(1-f5)+sum
    sum=table(i1  ,i2  ,i3  ,i4+1,i5  )*(1-f1)*(1-f2)*(1-f3)*   f4 *(1-f5)+sum
    sum=table(i1+1,i2  ,i3  ,i4+1,i5  )*   f1 *(1-f2)*(1-f3)*   f4 *(1-f5)+sum
    sum=table(i1  ,i2+1,i3  ,i4+1,i5  )*(1-f1)*   f2 *(1-f3)*   f4 *(1-f5)+sum
    sum=table(i1+1,i2+1,i3  ,i4+1,i5  )*   f1 *   f2 *(1-f3)*   f4 *(1-f5)+sum
    sum=table(i1  ,i2  ,i3+1,i4+1,i5  )*(1-f1)*(1-f2)*   f3 *   f4 *(1-f5)+sum
    sum=table(i1+1,i2  ,i3+1,i4+1,i5  )*   f1 *(1-f2)*   f3 *   f4 *(1-f5)+sum
    sum=table(i1  ,i2+1,i3+1,i4+1,i5  )*(1-f1)*   f2 *   f3 *   f4 *(1-f5)+sum
    sum=table(i1+1,i2+1,i3+1,i4+1,i5  )*   f1 *   f2 *   f3 *   f4 *(1-f5)+sum
    sum=table(i1  ,i2  ,i3  ,i4  ,i5+1)*(1-f1)*(1-f2)*(1-f3)*(1-f4)*   f5 +sum
    sum=table(i1+1,i2  ,i3  ,i4  ,i5+1)*   f1 *(1-f2)*(1-f3)*(1-f4)*   f5 +sum
    sum=table(i1  ,i2+1,i3  ,i4  ,i5+1)*(1-f1)*   f2 *(1-f3)*(1-f4)*   f5 +sum
    sum=table(i1+1,i2+1,i3  ,i4  ,i5+1)*   f1 *   f2 *(1-f3)*(1-f4)*   f5 +sum
    sum=table(i1  ,i2  ,i3+1,i4  ,i5+1)*(1-f1)*(1-f2)*   f3 *(1-f4)*   f5 +sum
    sum=table(i1+1,i2  ,i3+1,i4  ,i5+1)*   f1 *(1-f2)*   f3 *(1-f4)*   f5 +sum
    sum=table(i1  ,i2+1,i3+1,i4  ,i5+1)*(1-f1)*   f2 *   f3 *(1-f4)*   f5 +sum
    sum=table(i1+1,i2+1,i3+1,i4  ,i5+1)*   f1 *   f2 *   f3 *(1-f4)*   f5 +sum
    sum=table(i1  ,i2  ,i3  ,i4+1,i5+1)*(1-f1)*(1-f2)*(1-f3)*   f4 *   f5 +sum
    sum=table(i1+1,i2  ,i3  ,i4+1,i5+1)*   f1 *(1-f2)*(1-f3)*   f4 *   f5 +sum
    sum=table(i1  ,i2+1,i3  ,i4+1,i5+1)*(1-f1)*   f2 *(1-f3)*   f4 *   f5 +sum
    sum=table(i1+1,i2+1,i3  ,i4+1,i5+1)*   f1 *   f2 *(1-f3)*   f4 *   f5 +sum
    sum=table(i1  ,i2  ,i3+1,i4+1,i5+1)*(1-f1)*(1-f2)*   f3 *   f4 *   f5 +sum
    sum=table(i1+1,i2  ,i3+1,i4+1,i5+1)*   f1 *(1-f2)*   f3 *   f4 *   f5 +sum
    sum=table(i1  ,i2+1,i3+1,i4+1,i5+1)*(1-f1)*   f2 *   f3 *   f4 *   f5 +sum
    sum=table(i1+1,i2+1,i3+1,i4+1,i5+1)*   f1 *   f2 *   f3 *   f4 *   f5 +sum
    if n_elements(missing) gt 0 then begin
      if keyword_set(nmiss) ne 0 then sum(jmiss)=missing
    endif  
  end

endcase   
   
return,sum

end




