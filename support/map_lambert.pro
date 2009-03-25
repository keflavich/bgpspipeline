;+
; ROUTINE:    map_lambert
;
; PURPOSE:    transformation into lambert azimuthal map projection
;
; USEAGE:     map_lambert,lat0,lon0,lat,lon,u,v
;
; INPUT:
;   lat0      latitude of tangent point
;   lon0      longitude of tangent point
;   lat       array of latitudes
;   lon       array of longitues
;
; OUTPUT:
;   u         horizontal projection coordinates (km)
;   v         vertical projection coordinates (km)
;
; EXAMPLE:    
;             lat=[ 23.5837576, 22.4793919, 46.7048989, 48.4030555]
;             lon=[ -119.9722899, -75.4163527, -65.3946489, -128.5300591]
;             map_lambert,45,-100,lat,lon,u,v
;             print,u,v
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

pro map_lambert,lat0,lon0,lat,lon,u,v

compass,lat0,lon0, lat,lon,rng,az

re=6371.2

u=re*sqrt(2*(1.-cos(rng/re)))*cos((270-az)*!dtor)
v=re*sqrt(2*(1.-cos(rng/re)))*sin((270-az)*!dtor)
return
end

