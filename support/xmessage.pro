;+
; routine:      xmessage
; purpose:      create a simple set of widget labels
;
; useage:       xmessage,labels,charsize=charsize,wbase=wbase,group=group,$
;                   title=title,kill=kill,relabel=relabel,wlabels=wlabels,$
;                   done=done,font=font
;
; input:        
;  labels       string array of labels
;
; keyword input:
;  charsize     size of characters
;               
;  wbase        widget id of xmessage base widget
;               
;  group        widget id of parent widget 
;               
;  title        widget label 
;               
;  kill         kills xmessage widget if KILL is set to the value 
;               of WBASE returned from a previous call of XMESSAGE
;               
; relabel       scalor or integer array of widget id's.  Used to relabel
;               xmessage labels, relabel should be set to the values
;               (possibly a subset) of WLABELS from a previous call of
;               XMESSAGE.  When XMESSAGE is used with RELABEL, the
;               LABELS parameter should be set to a string array of
;               the new labels
;
;  done         if set, the XMESSAGE widget will have a "DONE" button
;               which can be used to destroy the widget.  Otherwise
;               the XMESSAGE widget is destroyed by calling XMESSAGE
;               with the KILL keyword set to the XMESSAGE widget id.
;               It is also destroyed when it is part of a widget
;               hierarchy whose group leader is killed
;
;  font         the hardware font used in the labels
;
; keyword output:
;  wbase        widget id of xmessage base widget
;  wlabels      widget id's of xmessage label widgets (intarr)
;
; EXAMPLE:
;
;; create xmessage widget
;   
;    labels=['here is an example','of the xmessage widget']
;    xmessage,labels,wbase=wbase,wlabel=wlabels
;
;; relabel 2'nd label
;
;    xmessage,'of The XMESSAGE WIDGET',relabel=wlabels(1)
;
;; kill the message
;
;    xmessage,kill=wbase
;
;  author:  Paul Ricchiazzi                            Jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

pro xmessage_event,event
WIDGET_CONTROL, event.id,  GET_UVALUE=eventval
if eventval eq "DONE" then WIDGET_CONTROL, event.top, /DESTROY
return
end


;======================================================================

pro xmessage,labels,group=group,title=title,charsize=charsize,wbase=wbase,$
             wlabels=wlabels,kill=kill,relabel=relabel,done=done,font=font

if !d.name ne 'X' then return

nl=n_elements(labels)
if keyword_set(font) eq 0 then font=""
if keyword_set(kill) ne 0 then begin

  widget_control,kill,/destroy
  return

endif 

if keyword_set(relabel) ne 0 then begin
  for i=0,nl-1 do widget_control,relabel(i),set_value=labels(i)
  return
endif

if keyword_set(title) eq 0 then title='Xmessage'
wbase = WIDGET_BASE(TITLE = title,/COLUMN)

if keyword_set(done) then w  = WIDGET_BUTTON(wbase, VALUE='  Done  ', UVALUE = "DONE")

wlabels=intarr(nl)

for i=0,nl-1 do $
  wlabels(i) = WIDGET_label(wbase,value=labels(i),font=font)

WIDGET_CONTROL, wbase, /REALIZE

if keyword_set(done) then XManager, "XMESSAGE", wbase, GROUP_LEADER = GROUP

return

end


