from readcol import readcol
from pylab import *
from matplotlib.patches import Ellipse
from matplotlib.collections import PatchCollection
import matplotlib

uranus=[
'050619_o23' ,
'050619_o24' ,
'050628_o33' ,
'050628_o34' ,
'050904_o31' ,
'050904_o32' ,
'050911_ob8' ,
'070702_o41' 
]

for obsdate in uranus:

    d_angle = open('/scratch/adam_work/distmaps/uranus_'+obsdate+'.txt','r').readline().split().pop()

    bolonum,base,amp,xwid,ywid,xcen,ycen,angle = readcol('/scratch/adam_work/distmaps/uranus_'+obsdate+'_bolofits.txt',twod=False)

    good = ((amp > (median(amp)-3*std(amp))) * (amp < (median(amp)+3*std(amp))))

    colorscale = (amp-min(amp))/max(amp-min(amp))
    xwid = xwid[good] / max(xcen[good]-min(xcen[good]))
    ywid = ywid[good] / max(ycen[good]-min(ycen[good]))
    xcen = (xcen[good]-min(xcen[good]))/max(xcen[good]-min(xcen[good]))
    ycen = (ycen[good]-min(ycen[good]))/max(ycen[good]-min(ycen[good]))
    angle= angle[good] + float(d_angle)/180*pi

    ells = [Ellipse(xy=[xcen[i],ycen[i]], width=xwid[i], height=ywid[i], angle=angle[i]) for i in xrange(good.sum())]

    fig = figure(0)
    clf()
    ax = fig.add_subplot(111, aspect='equal')
    p=PatchCollection(ells,cmap=matplotlib.cm.hot_r,alpha=1)
    ax.add_collection(p)
    p.set_array(colorscale)

    ax.set_xlim(-.1,1.1)
    ax.set_ylim(-.1,1.1)

    colorbar(p)

    savefig('/home/milkyway/student/ginsbura/paper_figures/bolosens'+obsdate+'.png')
    savefig('/home/milkyway/student/ginsbura/paper_figures/bolosens'+obsdate+'.ps')

