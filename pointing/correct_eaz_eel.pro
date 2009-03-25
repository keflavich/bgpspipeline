; correct for az/el error offsets
; I don't know what these are, but these corrections MUST be made for
; anything to work.  It's absurd.
pro correct_eaz_eel,ra,dec,el,az,eel,eaz,pa
    dra=-eaz*cos(!dtor*pa)*cos(!dtor*el)+eel*sin(!dtor*pa)
    ddec=eaz*sin(!dtor*pa)*cos(!dtor*el)+eel*cos(!dtor*pa)
    dec += ddec/3600.
    ra  += dra/3600. / cos(!dtor*dec)
end    
