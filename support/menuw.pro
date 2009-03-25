function menuw,choices,selection,title=title,prompt=prompt,$
     group=group,font=font,ysize=ysize,done=done

;+
; ROUTINE:    menuw 
;
; PURPOSE:    create a menu widget and return a selection
;
; USEAGE:     w=menuw(choices,title=title,group=group,$
;                     font=font,ysize=ysize,done=done)
;
;             result=menuw(w) 
;
;             while menus(w,ii) do (something that depends on ii)
;
; PROCEDURE:
;             The value returned from MENUW is either a widget id or a
;             selection index, depending on the variable type of its
;             first argument.  If the argument is a string array then
;             MENUW sets up a menu, based on an IDL list widget, and
;             returns a structure of widget identifiers of the
;             component widgets.  If the argument is a structure then
;             MENUW returns the index of the selected menu choice.
;
;             Set up the widget with          w=MENUW(choices)
;             Return choices with             result=MENUW(w)
;             where 
;                choices = a string array of menu choices 
;                w       = a structure variable containing the widget id.
;                result  = index of the selected menu choice 
;
; INPUT:
;  choices    string array containing choices
;  w          widget id (returned by setup call to MENUW)
;  
;
; KEYWORD INPUT:
;  title      title of the widget
;
;  prompt     string array of prompt message. each element of string
;             array appears on a new line.
;
;  ysize      the number of lines to show in the list widget.  If the
;             number of choices is greater than ysize the list widget
;             creates a vertical slider to allow the user to scan all
;             selections.
;
;  font       String specifying font type. If omitted use the default
;             fixed width font:
;             "-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
;
;  done       if set, a "DONE" button is created.  If a "DONE" button
;             is not present the MENUW widget is destroyed the first
;             time result=MENUW(w) is executed.
;
; OUTPUT, SETUP MODE:
;
;  w          widget indentifier used in subsequent calls to MENUW
;             When multiple copies of the MENUW widget exist, a call to
;             to MENUW(w) will interact only with the widget which
;             set W.
;
; OUTPUT, SELECTION MODE:
;
;  selection  If selection parameter is included in parameter list it
;             will contain the index of the selection and the function
;             return value will be set to -1 or 1 depending on whether
;             the DONE button was/was_not pressed.  When used in a
;             while loop (see examples), the last selected value is
;             available even after DONE is pressed.  If the SELECTION
;             parameter is not in the argument list the function
;             return value will be set to....
;
;  result     if the DONE button is pressed =>  -1
;             otherwise the index of the list widget 
;             (0 -- n_elements(choices)-1)
;
;
; EXAMPLES:
;
;; use MENUW in one-shot mode
;
;       items=findfile('/local/idl/user_contrib/esrg/t*.pro')
;       prompt='choose a file to display'
;       print,items(menuw(menuw(items,prompt=prompt)))
;
;
;; use MENUW to make a sequence of menu selections
;
;       items=findfile('/local/idl/user_contrib/esrg/t*.pro')
;       prompt='choose a file to display'
;       w2=menuw(items,prompt=prompt,/done)
;       k=menuw(w2) 
;       while k ne -1 do begin & print,items(k) & k=menuw(w2) & end
;
;       while menuw(w2,k) do print,items(k)
;       print,items(k)
;
;
;  author:  Paul Ricchiazzi                            may94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
; REVISIONS:
;
;-
;
;======================================================================

;
; if choices is a structure, return the choice index selected from the widget
;

if n_tags(choices) gt 0 then begin            ; return the choice 
  w=choices
  j=widget_event(w.base)
  index=-1
  if j.id eq w.button or w.button eq -1 then WIDGET_CONTROL, w.base, /DESTROY
  if j.id eq w.list   then index=j.index
  if(n_params() eq 2) then begin
    if(j.id ne w.button) then selection=index
    return,index ne -1
  endif else begin
    return,index
  endelse
endif 

;
;  otherwise setup the menu widget
;

index=-1
fontfixed="-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
if keyword_set(font) eq 0 then font=fontfixed
if not keyword_set(done) then done=0 

if keyword_set(title) eq 0 then title='Menuw'
wbase = WIDGET_BASE(TITLE = title,/COLUMN) 

if done then begin
  wbutton  = WIDGET_BUTTON(wbase, VALUE='  Done  ', UVALUE = "DONE")
endif else begin
  wbutton=-1
endelse

wbase1= WIDGET_BASE(wbase,/COLUMN)
for i=0,n_elements(prompt)-1 do $
  junk=widget_label(wbase1,value=prompt(i),font=font)

wbase2=WIDGET_BASE(wbase,/COLUMN,/frame) 
nn=n_elements(choices)
if keyword_set(ysize) eq 0 then ysize=nn < 15
wlist=widget_list(wbase2,value=choices,ysize = ysize,$
                 font=font,uvalue="LIST")

w={base:wbase,button:wbutton,list:wlist}

WIDGET_CONTROL, wbase, /REALIZE

return,w

end


