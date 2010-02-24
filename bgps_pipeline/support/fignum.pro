pro fignum,fig=fig,charsize=charsize,font=font
;+
; routine:        fignum
;
; useage:         fignum,fig=fig,charsize=charsize,font=font
;
; input:          none
;
; keyword input:  
;   fig
;     if FIG is set to an integer greater than zero figure numbering 
;     is enabled and the initial figure number is set to FIG.  If FIG
;     is set to zero figure numbering is disabled.  If FIG is set to a
;     string scalar then that string will be appended to "Figure" and
;     written to as usual.  For example fignum,fig="4a" writes "Figure 4a".
;
; output:         none
;
; PURPOSE:
;     automatical increment a figure number index and draw the number
;     on a sequence of plots.
;     
;
; COMMON BLOCKS: fignum_blk
;                       
; EXAMPLE:        
;
; plot,dist(20)
; fignum,fig=1,font='!3',charsize=2
; for i=1,4 do begin & plot,dist(20) & fignum & pause & end
;
;  author:  Paul Ricchiazzi                            22sep92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

common fignum_blk,figure_number,figure_chsz,figure_font

if !p.charsize eq 0. then !p.charsize=1.
if n_elements(fig) then begin
  if keyword_set(charsize) then figure_chsz=charsize else figure_chsz=1.
  if keyword_set(font)     then figure_font=font else figure_font='!17'

  if (size(fig))(1) eq 7 then begin
    figstr=figure_font+strcompress('Figure '+fig+'!x')
    yoff=!p.charsize*(figure_chsz-1.)*float(!d.y_ch_size)/!d.y_vsize
    xyouts,.01,.99-yoff,figstr,/norm,charsize=!p.charsize*figure_chsz
  endif else begin  
    figure_number=fig
  endelse
  return
endif

if keyword_set(figure_number) and !p.multi(0) eq 0 then begin
  figstr=figure_font+strcompress('Figure'+string(figure_number)+'!x')
  yoff=!p.charsize*(figure_chsz-1.)*float(!d.y_ch_size)/!d.y_vsize
  xyouts,.01,.99-yoff,figstr,/norm,charsize=!p.charsize*figure_chsz
  figure_number=figure_number+1
endif


end

