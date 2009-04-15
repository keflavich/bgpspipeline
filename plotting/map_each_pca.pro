restore,'/usb/scratch1/l111/v1.0.2_l111_13pca_postiter.sav'

for i=1,20 do begin
    pca_subtract,bgps.raw-bgps.astrosignal,i,lower_n=i-1,uncorr_part=new_astro,corr_part=pca_atmo 
    map = ts_to_map(mapstr.blank_map_size,mapstr.ts,pca_atmo,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
    writefits,'/usb/scratch1/PCA/l111_20iter_pca'+string(i,format='(I02)')+'.fits',map,mapstr.hdr
endfor

simts=sim_wrapper(bgps,mapstr,150,niter=1,/linearsim)
for i=1,20 do begin
    pca_subtract,simts,i,lower_n=i-1,uncorr_part=new_astro,corr_part=pca_atmo 
    map = ts_to_map(mapstr.blank_map_size,mapstr.ts,pca_atmo,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
    writefits,'/usb/scratch1/PCA/l111_pca'+string(i,format='(I02)')+'_sim.fits',map,mapstr.hdr
endfor

restore,'/usb/scratch1/l111/v1.0.2_l111_13pca_preiter.sav'

for i=1,20 do begin
    pca_subtract,bgps.raw,i,lower_n=i-1,uncorr_part=new_astro,corr_part=pca_atmo 
    map = ts_to_map(mapstr.blank_map_size,mapstr.ts,pca_atmo,weight=bgps.weight,scans_info=bgps.scans_info,wtmap=mapstr.wt_map,_extra=_extra)
    writefits,'/usb/scratch1/PCA/l111_pca'+string(i,format='(I02)')+'.fits',map,mapstr.hdr
endfor

end
