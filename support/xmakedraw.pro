;+
; ROUTINE:      xmakedraw
;
; PURPOSE:      create a simple draw widget with a done button
;
; USEAGE:       xmakedraw,group=group,x_window_size=x_window_size,$
;                 y_window_size=y_window_size,widget_label=widget_label,$
;                 make_draw_index=make_draw_index,nowait=nowait
;
; INPUT:        none required
;
; KEYWORD INPUT:
;
;  group                widget id of parent widget 
;
;  x_window_size        width of draw widget
;
;  y_window_size        height of draw widget
;
;  widget_label         widget label 
;
;  base_id              widget id of base widget
;
;  nowait               if set do not call xmanager, return immediately
;                       after draw widget is realized
;
;                       This keyword should be used when XMAKEDRAW is
;                       not called by another widget procedure (see example)
; EXAMPLE:
;
;; called from non-widget application (e.g., interactive input)
;
;   xmakedraw,base_id=base_id,x_w=500,y_w=500,/nowait
;   !p.multi=[0,2,2]
;   loadct,5
;   plot,dist(10)
;   tvim,dist(100)
;   plot,hanning(10,10)
;   tvim,hanning(10,10)
;   xmanager,'xmakedraw',base_id
;
;;  in this example control is returned from the XMANAGER routine only
;;  after the operator hits the DONE button.  If instead, this program
;;  segment were called from another widget application, the highest
;;  level call to the XMANAGER would supercede all lower level calls.
;;  That is, program flow in not halted and normal widget event
;;  processing would continue. In this case the NOWAIT parameter should
;;  not be set and the call to XMANAGER is not required.
; 
; Author:       Jeff Hicke                                      sep93
;               Earth Space Research Group, UC Santa Barbara
;-


pro Xmakedraw_event, event

   WIDGET_CONTROL, event.id,  GET_UVALUE=eventval

   case eventval of

      "DONE"     :  WIDGET_CONTROL, event.top, /DESTROY

   endcase

end

;======================================================================

pro Xmakedraw,group=group,x_window_size=x_window_size,$
     y_window_size=y_window_size,widget_label=widget_label,$
     base_id=base_id,nowait=nowait

   if keyword_set(x_window_size) eq 0 then x_window_size = 300
   if keyword_set(y_window_size) eq 0 then y_window_size = 300
   if keyword_set(widget_label) eq 0 then widget_label=' '
   
   base_id = WIDGET_BASE(TITLE = widget_label,/COLUMN)

   button_id = WIDGET_BASE(base_id,/row)

   w  = WIDGET_BUTTON(button_id, VALUE='  Done  ', UVALUE = "DONE")

   w = WIDGET_DRAW(base_id, xsize=x_window_size,   $
                            ysize=y_window_size,     /FRAME)

   WIDGET_CONTROL, base_id, /REALIZE

   if keyword_set(nowait) then return

   XManager, "Xmakedraw", base_id, GROUP_LEADER = GROUP

   return

end
