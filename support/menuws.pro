;+
; ROUTINE:    menuws
;
; PURPOSE:    create a multiple value menu widget and return a selections
;
; USEAGE:     w=menuws(choices,title=title,group=group,$
;                     font=font,ysize=ysize)
;
; INPUT:
;  choices    string array containing choices
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
;
; OUTPUT
;
;  result     the indecies of the selected items.  (-1 if no selections)
;
; EXAMPLES:
;
;
;; use MENUWS to make a sequence of menu selections
;
;       f=findfile('/home/paul/idl/esrg/[r-z]*.pro')
;       table,f(menuws(f))
;
; DISCUSSION:
;       MENUWS calls MENUW to do the widget setup and selection of
;       individual items.  MENUWS keeps track of which items have been
;       selected and updates the item labels to graphically indicate
;       active selections. When the operator makes a selection by
;       clicking with the LMB, the entire selection list is rewritten to
;       the menu widget.  Selected items are indicated with an
;       asterisk (*) prefix.  Selected items may be de-selected by
;       clicking on them again with the LMB.  The list of selected
;       items is not locked in until the operator hits the DONE button.
;
; BUGS:
;       Because MENUWS uses WIDGET_CONTROL to update the item list
;       there is a problem which only occurs when the the list is long
;       and you are selecting something near the bottom of the
;       scrolled list.  In this case, when WIDGET_CONTROL re-writes
;       the item list the widget display jumps up to the top of the
;       list.  This is disturbing but not disasterous: the selection
;       is recorded even though you have to scroll back down to see
;       it. The only fix I know is to make sure YSIZE is greater than
;       or equal to the number of menu items.  Right now YSIZE is 
;       defaulted to the min of the number of menu items and 60, which
;       is as many items as will fit on my screen when using the
;       default font.
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

function menuws,choices,title=title,prompt=prompt,$
               group=group,font=font,ysize=ysize,order=order

flagon ='   * '
flagoff='     '

items=flagoff+choices
fontfixed="-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
if not keyword_set(title) then title='Menuws'
if not keyword_set(prompt) then prompt=' '
if not keyword_set(font) then font=fontfixed
nn=n_elements(choices)
if keyword_set(ysize) eq 0 then ysize=nn < 60
w=menuw(items,title=title,prompt=prompt,font=font,ysize=ysize,/done)

ni=n_elements(items)

sorder = intarr(ni)
kk=-1
iord = 0
jj = menuw(w)
nsel = 0

WHILE jj GE 0 DO BEGIN
  iord = iord+1
  IF sorder(jj) GT 0 THEN BEGIN
    sorder(jj) = 0 
    nsel = nsel-1
  ENDIF ELSE begin
    sorder(jj) = iord
    nsel = nsel+1
  ENDELSE

  kk = sort(sorder)
  IF ni-nsel le ni-1 THEN kk = kk(ni-nsel:*) ELSE kk = [-1]
  
  flag=replicate(flagoff,ni)
  
  IF nsel GT 0 THEN BEGIN 
    IF keyword_set(order) THEN BEGIN
      flag(kk) = string(f='(i3)',1+indgen(nsel)) + replicate('. ',nsel)
    ENDIF ELSE BEGIN
      flag(kk) = flagon
    ENDELSE
  ENDIF

  items=flag+choices
  WIDGET_CONTROL, w.list, set_value=items, default_font=font
  jj = menuw(w)
ENDWHILE   

return,kk
end

