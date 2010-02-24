from readcol import readcol
from pylab import *
from matplotlib.patches import Ellipse
from matplotlib.collections import PatchCollection
import matplotlib
import os

uranus=[
'050619_o23-4_nofit' ,
'050628_o33-4_nofit' ]
#'050904_o31-2_nofit' 

obs = [ { 'uranus':'050619_o23-4_nofit' } ,
        { 'uranus':'050628_o33-4_nofit' } ,
        ]
#        { '3c279' :'050703_ob1-2' } ]

for o in obs:

    object = o.keys()[0]
    obsdate = o[object]
    
#    d_angle = open(os.environ['workingdir']+'/distmaps/'+object+'_'+obsdate+'.txt','r').readline().split().pop()
#    d_angle = 0 # I think that was a hack to rotate back to array frame

    bolonum,base,amp,xwid,ywid,xcen,ycen,angle = readcol(os.environ['workingdir']+'/distmaps/'+object+'_'+obsdate+'_bolofits.txt',twod=False,skipline=1)

    good = ((amp > (median(amp)-3*std(amp))) * (amp < (median(amp)+3*std(amp))))
    low  = amp[good] < median(amp)-std(amp)
    high = amp[good] > median(amp)+std(amp)

    amplot = amp[good]
    amplot[low]  = median(amp)-std(amp)
    amplot[high] = median(amp)+std(amp)
    colorscale = (amplot-min(amplot))/max(amplot-min(amplot))
    xwid = xwid[good] / max(xcen[good]-min(xcen[good]))
    ywid = ywid[good] / max(ycen[good]-min(ycen[good]))
    xcen = (xcen[good]-min(xcen[good]))/max(xcen[good]-min(xcen[good]))
    ycen = (ycen[good]-min(ycen[good]))/max(ycen[good]-min(ycen[good]))
    angle= angle[good] # + float(d_angle)/180*pi

    rad = (xwid+ywid)/2
    ells = [Ellipse(xy=[xcen[i],ycen[i]], width=xwid[i], height=ywid[i], angle=angle[i]) for i in xrange(good.sum())]
    lowells = [Ellipse(xy=[xcen[i],ycen[i]], width=xwid[i], height=ywid[i], angle=angle[i]) for i in where(low)[0].tolist()]
    highells = [Ellipse(xy=[xcen[i],ycen[i]], width=xwid[i], height=ywid[i], angle=angle[i]) for i in where(high)[0].tolist()]

    fig = figure(0)
    clf()
    ax = fig.add_subplot(111, aspect='equal')
    p=PatchCollection(ells,cmap=matplotlib.cm.hot_r,alpha=1)
    plohi=PatchCollection(lowells+highells,cmap=matplotlib.cm.cool_r,alpha=1)
    ax.add_collection(p)
    ax.add_collection(plohi)
    p.set_array(colorscale)
    plohi.set_array(concatenate((zeros(low.sum()),ones(high.sum()))))

    ax.set_xlim(-.1,1.1)
    ax.set_ylim(-.1,1.1)

    colorbar(p)

    savefig(os.environ['workingdir']+'/paper_figures/bolosens'+obsdate+'.png')
    savefig(os.environ['workingdir']+'/paper_figures/bolosens'+obsdate+'.ps')

