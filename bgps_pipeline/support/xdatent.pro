;+
; ROUTINE:  xdatent
;
; PURPOSE:  widget for text data entry.  
;
; USEAGE:   xdatent,labels,value,ncol=ncol,group=group
;
; INPUT:    
;   labels  string array of labels for data entry field
;
; KEYWORD INPUT:
;   ncol    number of columns of data entry fields
;   font    text font to use
;   group   group leader widget, when this widget dies, so does xdatent
;
; INPUT/OUTPUT
;   value   float, double, long or int array of values
;           on input: used to set default values
;           on exit:  edited values
;
; 
; COMMON BLOCKS:
;   xdatentblk
;
; EXAMPLE:  
;
;   labels=['min latitude','max latitude','min longitude','max longitude']
;   value=[30.,40.,-130.,-120.]
;   xdatent,labels,value,ncol=2
;   table,labels,value
;
;; NOTE: the input focus can be moved by hitting the tab key.  
;
;
; AUTHOR:   Paul Ricchiazzi                        05 Jul 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
; REVISIONS:
;
;-
;

pro xdatent_event,event

common xdatentblk,values

WIDGET_CONTROL, event.id,  GET_UVALUE=eventval, get_value=textvalue
if eventval eq "DONE" then begin
  WIDGET_CONTROL, event.top, /DESTROY
endif else begin
  ind=(str_sep(eventval,'_'))(1)
  ind=fix(ind)
  f=0.
  if textvalue(0) eq '-' then textvalue(0)=-1
  on_ioerror,bad
  reads,textvalue,f
  values(ind)=f
endelse

return

bad:
xmessage,'Input conversion error',wbase=wbase
wait,.7
xmessage,kill=wbase

return

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro xdatent,label,value,title=title,group=group,ncol=ncol

common xdatentblk,values
values=value

fontfixed="-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
if not keyword_set(font)  then font=fontfixed

if not keyword_set(ncol) then ncol=1
if not keyword_set(title) then title='data entry'

base=widget_base(title=title,/column)
labwidth=max(strlen(label))+3
valwidth=max(strlen(string(value)))+7
w=widget_button(base,value="  Done  ", uvalue='DONE')

for i=0,n_elements(label)-1 do begin
  uval='xdatent_'+strcompress(string(i),/remove_all)
  if i mod ncol eq 0 then b = widget_base(base,/row)
  lab=label(i)+':'
  lab=string((replicate(32b,(labwidth-strlen(lab))>1)))+lab
  val=string(value(i))
  val=string((replicate(32b,(valwidth-strlen(val))>1)))+val
  j = WIDGET_LABEL(b, VALUE=lab,font=font)
  j = WIDGET_TEXT(b,VALUE=val,UVALUE=uval,/EDITABLE,/All_EVENTS,font=font)
endfor

widget_control,base,/realize
xmanager, "xdatent", base, group_leader=group,/modal
value=values

end



