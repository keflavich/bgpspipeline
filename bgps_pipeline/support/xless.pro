;+
; ROUTINE:    xless
;
; PURPOSE:    create a text widget to scroll through a string array or
;             a file
;
; USEAGE:     xless,text,file=file,space=space,xsize=xsize,ysize=ysize,$
;                   xpad=xpad,ypad=ypad,title=title,font=font,group=group,$
;                   unmanaged=unmanaged
;
; INPUT:
;   text      string array containing text.  if TEXT is set FILE is ignored
;
; KEYWORD INPUT:
;   file      pathname of text file to display
;   space     space to put around text widget
;   xsize     x size of text widget (characters)
;   ysize     y size of text widget (lines)
;   xpad      padding 
;   ypad      padding
;   title     title of text widget (default = XLESS)
;   font      text font to use
;   group     widget group leader 
;   unmanaged don't put widget under control of the XMANAGER. This
;             also means there will be no DONE button: to kill the widget
;             use a XWINDOW manager command (EG, menu option "close")
;             
;
; OUTPUT:
;   none
;
; EXAMPLE:
;
;; list a string array
;
;             text=string(indgen(40)) & text(*)=text(*)+' this is a test'
;             xless,text
;
;             xless,text,/unman ; notice how control returns to the terminal
;                               ; imediately after this command
;
;; list a file
;             
;             xless,file=pickfile(/noconfirm)
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            Jul94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

PRO xless_event, event

WIDGET_CONTROL, GET_UVALUE = retval, event.id

IF(retval EQ "EXIT") THEN WIDGET_CONTROL, event.top, /DESTROY

END

;=======================================================================

pro xless,text,file=file,space=space,xsize=xsize,ysize=ysize,xpad=xpad,$
          ypad=ypad,title=title,font=font,group=group,unmanaged=unmanaged


if n_elements(text) eq 0 then begin
  text=strarr(1000)
  openr,lun,/get_lun,file
  i=0
  line=''
  while not eof(lun) do begin
    readf,lun,line
    text(i)=line
    i=i+1
  endwhile
  text=text(0:i-1)
  free_lun,lun
endif



fontfixed="-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
if not keyword_set(font)  then font=fontfixed
if not keyword_set(xsize) then xsize=max(strlen(text)) < 120
if not keyword_set(ysize) then ysize=n_elements(text) < 25
if not keyword_set(space) then space=20
if not keyword_set(xpad)  then xpad=20
if not keyword_set(ypad)  then ypad=20
if not keyword_set(title) then begin
  if keyword_set(file) then title=file else title='XLESS'
endif

filebase = WIDGET_BASE(TITLE = TITLE, $			;create the base
		/COLUMN, $
		SPACE = space, $
		XPAD = xpad, $
		YPAD = ypad)

if keyword_set(unmanaged) eq 0 then $
  filequit = WIDGET_BUTTON(filebase, $			;create a Done Button
		VALUE = "Done with XLESS", $
		UVALUE = "EXIT")



filetext = WIDGET_TEXT(filebase, $			;create a text widget
                XSIZE = xsize, $			;to display the file's
                YSIZE = ysize, $			;contents
                /SCROLL, FONT = font, $
                VALUE = text) 


WIDGET_CONTROL, filebase, /REALIZE			;instantiate the widget

if keyword_set(unmanaged) eq 0 then $
  Xmanager, "xless", $  				;register it with the
		filebase, $				;widget manager
		GROUP_LEADER = GROUP

END


