; $Id: xhelp.pro,v 1.1 1993/04/02 19:54:08 idl Exp $

; Copyright (c) 1991-1993, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
PRO XDispFile_evt, event

WIDGET_CONTROL, GET_UVALUE = retval, event.id

IF(retval EQ "EXIT") THEN WIDGET_CONTROL, event.top, /DESTROY

END


PRO xhelp, FILENAME, TITLE = TITLE, GROUP = GROUP, WIDTH = WIDTH, $
		HEIGHT = HEIGHT, TEXT = TEXT, FONT = font, unmanaged=unmanaged
;+
; NAME: 
;	xhelp
;
; PURPOSE:
;	Display an IDL procedure header using widgets and the widget manager.
;
; CATEGORY:
;	Widgets.
;
; CALLING SEQUENCE:
;	xhelp, Filename
;
; INPUTS:
;     Filename:	A scalar string that contains the filename of the file
;		to display.  If FILENAME does not include a complete path
;               specification, xhelp will search for the file in
;               the current working directory and then each of the
;               directories listed in !PATH environment variable.  The
;               ".pro" file suffix will be appended if it is not supplied.
;
; KEYWORD PARAMETERS:
;	FONT:   The name of the font to use.  If omitted use the default
;		font. If font is set to 1 then a fixed width font is used:
;               "-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
;
;	GROUP:	The widget ID of the group leader of the widget.  If this 
;		keyword is specified, the death of the group leader results in
;		the death of xhelp.
;
;	HEIGHT:	The number of text lines that the widget should display at one
;		time.  If this keyword is not specified, 24 lines is the 
;		default.
;
;	TEXT:	A string or string array to be displayed in the widget
;		instead of the contents of a file.  This keyword supercedes
;		the FILENAME input parameter.
;
;	TITLE:	A string to use as the widget title rather than the file name 
;		or "xhelp".
;
;	WIDTH:	The number of characters wide the widget should be.  If this
;		keyword is not specified, 80 characters is the default.
;
;   UNMANAGED:  do not call xmanager and do not include a "DONE" button
;               on the widget.  In this case the x window manager must be
;               used to kill the widget.
;
; OUTPUTS:
;	No explicit outputs.  A file viewing widget is created.
;
; SIDE EFFECTS:
;	Triggers the XMANAGER if it is not already in use.
;
; RESTRICTIONS:
;	None.
;
; PROCEDURE:
;	Open a file and create a widget to display its contents.
;
; MODIFICATION HISTORY:
;	Written By Steve Richards, December 1990
;	Graceful error recovery, DMS, Feb, 1992.
;       Modified to extract .pro documentation headers, PJR/ESRG mar94
;
;  author:  Paul Ricchiazzi                            jun93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

IF(NOT(KEYWORD_SET(TITLE))) THEN TITLE = FILENAME	;use the defaults if
IF(NOT(KEYWORD_SET(HEIGHT))) THEN HEIGHT = 24		;the keywords were not
IF(NOT(KEYWORD_SET(WIDTH))) THEN WIDTH = 80		;passed in

IF(NOT(KEYWORD_SET(TEXT)))THEN BEGIN
  pfile=FILENAME
  if strpos(pfile,".pro") lt 0 then pfile=pfile+".pro" 
  if strpos(pfile,"/") lt 0 then pfile=[".",str_sep(!path,":")] + "/" + pfile

  nfile=n_elements(pfile)
  ii=0 
  repeat begin
    OPENR, unit, pfile(ii), /GET_LUN, ERROR=file_found
    ii=ii+1
  endrep until ii eq nfile or file_found ge 0

  if file_found lt 0 then begin		;OK?
	a = [ !err_string, ' Can not display ' + filename]  ;No
  endif else begin
	  a = strarr(1000)				;Maximum # of lines
	  i = 0
	  c = ''
          readon=0
	  while not eof(unit) do begin
		readf,unit,c
                if strpos(c,';-') eq 0 then readon=0
                if readon then begin
                  a(i) = strmid(c,1,200)
                  i = i + 1
                endif
                if strpos(c,';+') eq 0 then readon=1
     		endwhile
	  a = a(0:i-1)
	  FREE_LUN, unit				;free the file unit.
  endelse
ENDIF ELSE a = TEXT


xless,a,title=title,/unmanaged

end

