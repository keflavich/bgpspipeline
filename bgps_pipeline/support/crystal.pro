pro crystal,type,rsph,nsph,area,volume, $
            g1=g1,g2=g2,g3=g3,g4=g4,g5=g5,g6=g6
;+
; ROUTINE:  crystal
;
; PURPOSE:  compute the radius of an mie-sphere with scattering
;           properties equivalent to a irregular crystal shape. 
;
; USEAGE:   crystal,type,area,volumn,nsph,rsph,geom=geom
;
; INPUT:    
;   type    crystal type      description            Geom parameters
;           ------------      -----------            ----------
;               1             hollow column          L,a,d
;               2             bullet rosette         L,a,t
;               3             dendrite on plate      L,a,bb,bt
;               4             capped column          L1,L2,L3,a1,a2,a3
;
;
; KEYWORD INPUT:
;;
;
;   g1,g2...    geometry parameters in order given above, The geometry
;               parameters may be an array of values, in which case the
;               the output is also an array.
;               
;   L    g1     column length (1,2) or disk thickness (3)         (um)
;   a    g2     hexagonal face width (1,2,3)                      (um)
;   d    g3     cavity depth at each end of column (1)            (um)
;   t    g3     conical pyramid height on bullet rosettes (2)     (um)
;   bb   g3     base width of dendrite (3)                        (um)
;   bt   g4     length of dendrite (3)                            (um)
;   L1   g1     cap thickness (4)                                 (um) 
;   L2   g2     column length (4)                                 (um)
;   L3   g3     other cap thickness (4)                           (um)
;   a1   g4     cap hexagonal face width (4)                      (um)
;   a2   g5     hexagonal face width of column (4)                (um)
;   a3   g6     other cap hexagonal face width (4)                (um)
;
; OUTPUT:
;   rsph        radius of equivalent Mie spheres (um)
;   nsph        number of equivalent Mie spheres (not required for mie
;               parameter calculation)
;   area        area in um^2
;   volume      volume in um^3
;
;
; DISCUSSION:
;               According to Warren and Grenfeld, the scattering
;               parameters of an irregular the crystal can be
;               approximated by those of the set of equivalent Mie
;               spheres, such that the both the area and volume of the
;               set of spheres match those of the original crystal.
;
;               Say the density of a given crystal type is N per unit volume
;               the extinction coefficient, kappa, (per unit distance) is 
;               given by,  
;
;                     kappa = N * Q * A / 4 
;
;               where Q is the unknown extinction efficiency and the factor
;               of 4 is to turn area into average cross-sectional area.
;               According to W&G, kappa is approximately given by,
;
;                     kappa = N * Q_mie(rsph) * (nsph * pi rsph^2)
;
;                           = N * Q_mie(rsph) * A/4
;
;               The single scattering albedo and asymmetry factor are given by,
;
;                     omega = omega_mie(rsph)
;
;                     g = g_mie(rsph)
;
;
; EXAMPLE:  
;;
;        l=findrng(50,200,100)
;        crystal,1,r,g1=l,g2=50,g3=50
;        plot,l,r
;
;
; REVISIONS:
;
; AUTHOR:   Paul Ricchiazzi                        27 Jul 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
if n_params() eq 0 then begin
  xhelp,'crystal'
  return
endif

sr3=sqrt(3)
case type of
 1:begin                      ; hollow columns
    l=g1
    a=g2
    if n_elements(g3) ne 0 then d=g3 else d=0.
    volume=1.5*sr3*a^2*l*(1.-(2.*d)/(3.*l))
    area=3*a^2*(sqrt(3+4*(d/a)^2)+4*l/(2*a))
   end

 2:begin                      ; bullet rosettes
    l=g1
    a=g2
    t=g3
    volume=2*sr3*a^2*(3*l-2*t)
    area=6*a*(sr3*a+4*(l-t)+sqrt(3*a^2+4*t^2))
   end

 3:begin                      ; hexagonal plate with dendrites

    l=g1
    a=g2
    if n_elements(g3) ne 0 then bb=g3 else bb=0
    if n_elements(g4) ne 0 then bt=g4 else bt=0
    volume=1.5*sr3*l*(2*bb*bt+a^2)
    area=4*(3*l*sqrt(bb^2+bt^2+bb*bt)+1.5*sr3*bb*bt-3*bb*l+.75*sr3*a^2+1.5*l*a)
   end

 4:begin                      ; capped columns

    l1=g1
    l2=g2
    l3=g3
    a1=g4
    a2=g5
    a3=g6
    volume=1.5*sr3*(l1*a1^2+l2*a2^2+l3*a3^2)
    area=3*(a1^2*(2*l1/a1+sr3)+a2^2*(2*l2/a2-sr3)+a3^2*(2*l3/a3+sr3))
   end

endcase

rsph=3.*volume/area
nsph=area/(4*!pi*rsph^2)

return
end
