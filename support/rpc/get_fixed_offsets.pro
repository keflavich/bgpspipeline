; $Id: get_fixed_offsets.pro,v 1.2 2008/02/20 19:33:08 jaguirre Exp $
; $Log: get_fixed_offsets.pro,v $
; Revision 1.2  2008/02/20 19:33:08  jaguirre
; Making the FAZO/FZAO reading from rpc ready to use on milkyway.
;

; A little kluge to get the FAZO and FZAO for a Bolocam observation.
; Not the full-on right way to do things.

pro get_fixed_offsets, sliced_dir, rpc_dir, field, date_obs, fazo, fzao

ncfile = sliced_dir+'/sliced/'+field+'/'+date_obs+'_raw.nc'

ncdf_varget_scale,ncfile,'ut',ut

; Weird shit sometimes creeps in
ut = ut[where(ut gt 0)]

firstmin = ceil(min(ut)/24.*1440.)
lastmin = floor(max(ut)/24.*1440.)

temp = strsplit(date_obs,'_',/extract)

minstr = string(firstmin,format='(I04)')
rpcfile = rpc_dir+'/rpc/'+'20'+temp[0]+'/20'+temp[0]+'_'+minstr+'_rpc.bin'

data = read_rpc(rpcfile)

fazo = median(data.AZIMUTH_FIXED_OFFSET)
fzao = median(-data.ELEVATION_FIXED_OFFSET)

end
