import aplpy
import coords
from agpy import readcol
import pylab

def make_overlay(file,xc,yc,xtr,ytr):
    print file
    ff = aplpy.FITSFigure(file,convention='calabretta',figure=pylab.figure(0))
    ff.show_grayscale()
    ff.show_markers(xc,yc,edgecolor='red')
    ff.show_markers(xtr,ytr,edgecolor='blue')
    pylab.title(file)
    ff.save(file.replace('.fits','_centroidoverlay.png'))

def cenfile_overlays(cenfile):
    cen = readcol(cenfile,comment="#",asStruct=True)

    for name,ra,dec,obra,obdec in zip(cen.filename,cen.radeg,cen.decdeg,cen.obj_ra,cen.obj_dec):
        print name
        pos = coords.Position((ra,dec))
        xc,yc = pos.galactic()
        objpos = coords.Position((obra,obdec))
        xtr,ytr = objpos.galactic()

        make_overlay(name.tolist(),xc,yc,xtr,ytr)
        pylab.figure(0)
        pylab.clf()

if __name__=="__main__":
    import sys
    infile = sys.argv[1]
    cenfile_overlays(infile)

            
