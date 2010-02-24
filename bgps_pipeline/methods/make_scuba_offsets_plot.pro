;pro make_scuba_offsets_plot

@apj_plot_setup
load_plot_colors
pixsize = 7.2

readcol,'scuba_offsets_all_v1.0.2.txt',comment=';',format='(A,F,F,F,F,F,F,F)',$
  filename,dx,dy,dra,ddec,dra_err,ddec_err,stamp_res

good = intarr(n_e(dx))+1
good[where(filename eq 'l018')] = 0
good[where(filename eq 'l045')] = 0
good[where(filename eq 'l050')] = 0
;
good[where(filename eq 'l065')] = 0
good[where(filename eq 'l354')] = 0
good[where(filename eq 'super_gc')] = 0
whgood = where(good)
dl = -dx[whgood]*pixsize
db = -dy[whgood]*pixsize

rng = 12

set_plot,'ps'
device,file = 'scuba_pointing_offsets.eps',/color,/encap
plot,dl,db,psy=1,/iso,/xst,xr=[-rng,rng],/yst,yr=[-rng,rng],sym=2,$
  xthick=2,ythick=2,$
  xtit=textoidl('\Delta l [arcsec]'), $
  ytit=textoidl('\Delta b [arcsec]')

tvcircle,5.68,0.,0.,/data,thick=2,col=!cols.aquamarine
device,/close
set_plot,'x'

print,stddev(dl)
print,stddev(db)
print,minmax(dl)
print,minmax(db)

end
