import pyflagger

# change this path if you want
figure_path = '/home/milkyway/student/ginsbura/paper_figures/'

f = pyflagger.Flagger('/usb/scratch1/super_gc/050703_o15_raw_ds5.nc_indiv13pca',mapnum='01',ncfilename='/scratch/sliced/l000/050703_o15_raw_ds5.nc')

f.scannum = 12
f.flags[f.scannum,:,:] -= (f.flags[f.scannum,:,:] > 0) * f.flags[f.scannum,:,:]

f.plotscan(12,seconds=1)
figure(1); savefig(figure_path+'flagger_withglitch.ps')

f.flag_box(97,123,97,132,1)
figure(1); savefig(figure_path+'flagger_glitchboxflagged.ps')

f.plotscan(12,seconds=1)
figure(1); savefig(figure_path+'flagger_glitchgone.ps')

figure(3)
xax = arange(f.data.shape[1])/20.  # assuming sample rate is 20 Hz or .05 s
plot(xax,f.data[12,:,10])  # timestream with no glitch but with sources
plot(xax,f.data[12,:,27])  # timestream with no glitch or sources
plot(xax,f.data[12,:,97])  # timestream with glitch
xlabel("Time (s)")
ylabel("Amplitude (Jy)")
savefig(figure_path+'flagger_plots.ps')

f.close()

