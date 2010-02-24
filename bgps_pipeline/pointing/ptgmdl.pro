function ptgmdl,x,p,xoff=xoff,yoff=yoff
;    myx = reform(x[0,*])
;    myy = reform(y[0,*])
    n_x = n_e(x)/2    
    myx = x[0:n_x-1]
    myy = x[n_x:n_e(x)-1]
    xoff = poly(myx,p[0:3]) + poly(myy,p[4:7])
    yoff = poly(myx,p[8:11]) + poly(myy,p[12:15])
;    f = transpose([[xoff],[yoff]])
    f = [xoff,yoff]    
    return,f
end
    

    
