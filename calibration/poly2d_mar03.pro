function poly2d_mar03,Xin,B
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

a = [ $
       2.964620E-21, $
      -8.470330E-22, $
      -8.470330E-22, $
           1.001430, $
        -0.03109840, $
        0.002850950, $
       5.929230E-21, $
      -3.388130E-21, $
      -8.470330E-21, $
       0.0002646590, $
           1.001540, $
         0.01027270, $
       2.117580E-21, $
      -8.470330E-22, $
       3.388130E-21, $
         0.04126690, $
        0.001837160, $
      -0.0007926500  $
      ]

    x =  xin[*,0] * cos(b) - xin[*,1] * sin(b)
    y =  xin[*,0] * sin(b) + xin[*,1] * cos(b)

    xd = a[0] + a[1]*x + a[2]*x^2 + a[3]*y + a[4]*x*y + a[5]*x^2*y + a[6]*y^2 + a[7]*x*y^2 + a[8]*x^2*y^2
    yd = a[9] + a[10]*x + a[11]*x^2 + a[12]*y + a[13]*x*y + a[14]*x^2*y + a[15]*y^2 + a[16]*x*y^2 + a[17]*x^2*y^2

    x =  xd *      cos(b) + yd * sin(b)
    y =  xd * (-1)*sin(b) + yd * cos(b)

    return,[[x],[y]]
end


