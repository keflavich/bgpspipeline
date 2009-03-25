pro def_user_common
;
; $Id: 
; $Log:
;+
; NAME:
;	DEF_USER_COMMON
;
; PURPOSE:
;       Creates USER_COMMON common block and fills it.
;       This common block contains useful information like
;       the users's main idl directory, the file and path
;       separators for the system and the default window setup.
;
; CALLING SEQUENCE:
;       def_user_common
;
; COMMON BLOCKS:
;       USER_COMMON: creates it!
;
; MODIFICATION HISTORY:
;       2003/12/04 SG Separated from observer startup.pro
;       2005/04/24 SG Get rid of journaling -- no one seems to want it.
;-

common USER_COMMON, IDL_USER_PATH, IDL_PATHSEP, IDL_FILESEP, IDL_WIN

; set the delimiter that separates paths in the IDL_PATH variable
; IDL_PATHSEP is now obsolete because idl has introduce the PATH_SEP
; function, but we retain for backward compatibility
IDL_PATHSEP = path_sep(/search_path)

; set the delimiter that separates files in filenames
; IDL_FILESEP is now obsolete because idl has introduce the PATH_SEP
; function, but we retain for backward compatibility
IDL_FILESEP = path_sep()

; define the main idl directory 
IDL_USER_PATH = getenv('HOME') + IDL_FILESEP + 'idl'

; set standard plotting window
scrsize = [1024, 748]
;if not strcmp(getenv('DISPLAY'),'') then scrsize = get_screen_size()

; define standard window sizes and positions
; set POSNTYPE to 0 if your xwindow system has its origin in the upper
; left, 1 if in the lower left

xsize = 400
ysize = 400 
xwin = {XSIZE: xsize, YSIZE: ysize, $
        XPOS: 0, YPOS: 30, $
        XBORDER: 12, YBORDER: 30, $
        XSCRSIZE: scrsize[0], YSCRSIZE: scrsize[1], $
        UNITS: 'PIXELS', POSNTYPE: 1}

xsize = 4.5
ysize = 4.5
pswin = {XSIZE: xsize, YSIZE: ysize, $ 
         XPOS: (8.5-xsize)/2.0, YPOS: (11.0-ysize)/2.0, $
         XBORDER: 0, YBORDER: 0, $
         XSCRSIZE: 8.5, YSCRSIZE: 11.0, $
         UNITS: 'INCHES', POSNTYPE: 0}

; change "default" field in order to set the default screen device;
; e.g., if you are on a mac, you should set default to 'mac'
IDL_WIN = {default: 'X', X: xwin, PS: pswin}

end
