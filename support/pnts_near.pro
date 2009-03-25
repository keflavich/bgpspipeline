 pro pnts_near,plon,plat,lonrng,latrng,nx,ny,radius,ii,nc
;+
; routine:       pnts_near
; purpose:       return index array of points within radius
;
; useage:        pnts_near,plon,plat,lonrng,latrng,nx,ny,radius,ii,nc
;
; input:
;   plon         longitude of point
;   plat         latitude of point
;   lonrng       longitude range (two element vector)
;   latrng       latitude range
;   nx           number of points across lonrng
;   ny           number of points across latrng
;   radius       radius of region
; 
; output:
;   ii           index array of point within disk
;   nc           number of points within disk
;
;  author:  Paul Ricchiazzi                            jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
; plon=-65.0 & plat=-65. & lonrng=[-65.5,-60.5] & latrng=[-65.5,-63.6]
; nx=251       & ny=191       & radius=3.
; tvim,xx,xrange=lonrng,yrange=latrng,/scale

iarr=lindgen(nx,ny)
dellon=lonrng(1)-lonrng(0)
dellat=latrng(1)-latrng(0)
dlondi=dellon/(nx-1)
dlatdj=dellat/(ny-1)
dxdlon=111.*cos(!dtor*plat)
dydlat=111.
dxdi=dxdlon*dlondi
dydj=dydlat*dlatdj
i0=(nx-1)*(plon-lonrng(0))/dellon
j0=(ny-1)*(plat-latrng(0))/dellat
im=fix(i0-radius/dxdi-.5) > 0 < (nx-1)
ip=fix(i0+radius/dxdi+.5) > 0 < (nx-1)
jm=fix(j0-radius/dydj-.5) > 0 < (ny-1)
jp=fix(j0+radius/dydj+.5) > 0 < (ny-1)
iii=iarr(im:ip,jm:jp)
alon=lonrng(0)+dellon*(im+lindgen(ip-im+1))/(nx-1)
alat=latrng(0)+dellat*(jm+lindgen(jp-jm+1))/(ny-1)
lon=alon # replicate(1,n_elements(alat))
lat=replicate(1,n_elements(alon)) # alat
jj=where((dxdlon*(lon-plon))^2+(dydlat*(lat-plat))^2 lt radius^2,nc)
ii=iii(jj)
return
end
