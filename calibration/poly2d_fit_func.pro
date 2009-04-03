function poly2d_fit_func,Xin,A
; given set of x,y points s.t. X = [[x],[y]]
; 
; A: fit parameters; coefficients of:
;
;   c   x   xx      0 1 2   
;   y   xy  xxy     3 4 5
;   yy  xyy xxyy    6 7 8
;
;   c   x   xx      9 10 11   
;   y   xy  xxy     12 13 14
;   yy  xyy xxyy    15 16 17
;
;   and a rotation angle, a[18]

    x =  xin[*,0] * cos(a[18]) - xin[*,1] * sin(a[18])
    y =  xin[*,0] * sin(a[18]) + xin[*,1] * cos(a[18])

    xd = a[0] + a[1]*x + a[2]*x^2 + a[3]*y + a[4]*x*y + a[5]*x^2*y + a[6]*y^2 + a[7]*x*y^2 + a[8]*x^2*y^2
    yd = a[9] + a[10]*x + a[11]*x^2 + a[12]*y + a[13]*x*y + a[14]*x^2*y + a[15]*y^2 + a[16]*x*y^2 + a[17]*x^2*y^2

    x =  xd * cos(-a[18]) - yd * sin(-a[18])
    y =  xd * sin(-a[18]) + yd * cos(-a[18])

    return,[[x],[y]]
end

