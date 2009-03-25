
; plane2d - a simple bilinear background model
function plane2d,x,y,p

    z = p[0] + p[1] * (x-p[2]) + p[3] * (y-p[4])
    return,z

end    


