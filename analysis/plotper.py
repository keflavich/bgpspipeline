from readcol import readcol
from pylab import *

n,nper = readcol('noise_per_deg.txt',names=True)

figure()
clf()
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Noise (Jy/beam)')
plot(nper[:,0],nper[:,1],'k',ls='steps-mid',label="Mean")
plot(nper[:,0],nper[:,2],'b',ls='steps-mid',label="RMS")
legend()

savefig('noise_per_deg.eps')
savefig('noise_per_deg.png')

n,ffco = readcol('fillfact_CO.txt',names=True)
n,ffdec = readcol('fillfact_deconv_1deg.txt',names=True)
n,ffdec_co = readcol('fillfact_deconv_COmatched.txt',names=True)
n,ffdec_ds = readcol('fillfact_deconv_downsampled.txt',names=True)
n,meanbgps = readcol('meanper_smoothedBGPS.txt',names=True)
n,meanco = readcol('meanper_CO.txt',names=True)


figure()
clf()
subplot(211)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Fraction over cutoff')
plot(ffdec[:,0],ffdec[:,4],'k',ls='steps-mid',label=r'$300 \rm{mJy/beam;  } N_{H_2} = 3.5\times10^{20} \rm{cm}^{-2}$')
plot(ffdec_ds[:,0],ffdec_ds[:,2],'b',ls='steps-mid',label=r'$100 \rm{mJy;  } N_{H_2} = 2.5\times10^{21} \rm{cm}^{-2}$')
legend()

subplot(212)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Fraction over cutoff')
plot(ffco[:,0],ffco[:,6],'k',ls='steps-mid',label=r'$T_{mb}=150 \rm{K km/s; N_{H_2} = 7.9\times10^{21} \rm{cm}^{-2} } $')
legend()

savefig('fillfact_per_deg.eps')
savefig('fillfact_per_deg.png')

figure()
clf()
subplot(211)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Fraction over cutoff')
plot(ffdec[:,0],ffdec[:,2],'k',ls='steps-mid',label=r'$200 \rm{mJy/beam;  } N_{H_2} = 2.3\times10^{20} \rm{cm}^{-2}$')
legend()

subplot(212)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Fraction over cutoff')
plot(ffco[:,0],ffco[:,4],'k',ls='steps-mid',label=r'$T_{mb}=100 \rm{K km/s; N_{H_2} = 5.2\times10^{21} \rm{cm}^{-2} } $')
legend()

savefig('fillfact_per_deg_200mJy.eps')
savefig('fillfact_per_deg_200mJy.png')

figure()
clf()
subplot(211)
title('BGPS smoothed to Dame et al 2001 CO resolution')
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Fraction over cutoff')
plot(ffdec_ds[:,0],ffdec_ds[:,8],'k',ls='steps-mid',label=r'$1.3 \rm{Jy;  } N_{H_2} = 3.2\times10^{22} \rm{cm}^{-2}$')
legend()

subplot(212)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Fraction over cutoff')
plot(ffco[:,0],ffco[:,8],'k',ls='steps-mid',label=r'$T_{mb}=180 \rm{K km/s; N_{H_2} = 9.4\times10^{21} \rm{cm}^{-2} } $')
legend()

savefig('fillfact_per_deg_1.3Jy.eps')
savefig('fillfact_per_deg_1.3Jy.png')

n,nsrc = readcol('sources_per_deg.txt',names=True)

ax=figure()
clf()
sp=subplot(211)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
sp.set_xlim(-10.5,84.5)
plot(ffdec[:,0],ffdec[:,2],'k',ls='steps-mid',label='200 mJy/beam filling factor')
plot(meanbgps[:,0],meanbgps[:,1]/max(meanbgps[:,1]),'b',ls='steps-mid',label="BGPS mean flux (normalized to l=0)")
legend()

sp=subplot(212)
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Number over cutoff')
sp.set_xlim(-10.5,84.5)
plot(nsrc[:,0],nsrc[:,1],'k',ls='steps-mid')

savefig('sources_per_deg.eps')
savefig('sources_per_deg.png')

figure()
clf()
xt=xticks(arange(-10,100,5))
xlabel('Longitude')
ylabel('Mean flux (normalized to peak)')
plot(meanbgps[:,0],meanbgps[:,1]/max(meanbgps[:,1]),'k',ls='steps-mid',label="BGPS")
plot(meanco[:,0],meanco[:,1]/max(meanco[:,1]),'b',ls='steps-mid',label="CO")
legend()

savefig('mean_per_deg.eps')
savefig('mean_per_deg.png')

# fillfact_CO.txt 
# fillfact_deconv_0.5deg.txt
# fillfact_deconv_1deg.txt
# fillfact_deconv_COmatched.txt
# fillfact_deconv_downsampled.txt
# mosaic_l029-l040_list.txt
# noise_per_deg.txt
# noise_per_deg_noisemap.txt




