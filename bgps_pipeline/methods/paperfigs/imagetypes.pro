

map = readfits(getenv('V12')+'/v1.0.2_l357_13pca_map50.fits',maphdr)
model = readfits(getenv('V12')+'/v1.0.2_l357_13pca_model50.fits',modelhdr)
noisemap = readfits(getenv('V12')+'/v1.0.2_l357_13pca_noisemap50.fits',noisemaphdr)
weightmap = readfits(getenv('V12')+'/v1.0.2_l357_13pca_weightmap50.fits',weightmaphdr)


crpix1 = sxpar(maphdr,'CRPIX1')
crpix2 = sxpar(maphdr,'CRPIX2')
crval1 = sxpar(maphdr,'CRVAL1')
crval2 = sxpar(maphdr,'CRVAL2')
cd1_1 = sxpar(maphdr,'CD1_1')
cd2_2 = sxpar(maphdr,'CD2_2')

x = lindgen(n_e(map[*,0]))
y = lindgen(n_e(map[0,*]))
l = (x-crpix1)*cd1_1+crval1
if max(l) gt 360 then l-=360
b = (y-crpix2)*cd2_2+crval2

minx=1077
maxx=minx+100
miny=195
maxy=miny+100
minz = -.1
maxz = .85

lplot=(l[minx:maxx]-mean(l[minx:maxx]))*60
bplot=(b[miny:maxy]-mean(b[miny:maxy]))*60

set_plot,'ps'
device,filename=getenv('HOME')+'/paper_figures/image_types.ps',/encapsulated,xsize=7,ysize=7,/inches
!p.multi=[0,2,2]
negative = 1
imdisp,map[minx:maxx,miny:maxy],/axis,xrange=[max(lplot),min(lplot)],yrange=[min(bplot),max(bplot)],range=[minz,maxz],margin=.05,$
    ticklen=.001,true=1,erase=0,negative=negative,_extra=_extra
imdisp,noisemap[minx:maxx,miny:maxy],/axis,xrange=[max(lplot),min(lplot)],yrange=[min(bplot),max(bplot)],range=[minz,maxz],margin=.05,$
    ticklen=.001,true=1,erase=0,negative=negative,_extra=_extra
imdisp,model[minx:maxx,miny:maxy],/axis,xrange=[max(lplot),min(lplot)],yrange=[min(bplot),max(bplot)],range=[minz,maxz],margin=.05,$
    ticklen=.001,true=1,erase=0,negative=negative,_extra=_extra
imdisp,weightmap[minx:maxx,miny:maxy],/axis,xrange=[max(lplot),min(lplot)],yrange=[min(bplot),max(bplot)],margin=.05,$
    ticklen=.001,true=1,erase=0,negative=negative,_extra=_extra
device,/close_file
set_plot,'x'

end
