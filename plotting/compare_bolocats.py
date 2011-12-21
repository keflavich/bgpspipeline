import idlsave
import os
from pylab import *
from agpy import PCA_tools
from agpy.gaussfitter import onedgaussfit,onedgaussian
if not locals().has_key('pipeline_root'): pipeline_root = '/Users/adam/work/bgps_pipeline/'
sys.path.append(pipeline_root+"plotting/")
import compare_images


def compare_bolocats(field, savepath='/Volumes/disk3/adam_work/v1v2compare/',
        suffix="_v1v2_bolocat_compare.sav", bolocatfile=None, linestyle='none',
        marker=',', clearplots=False, prefix="", **kwargs):
    """
    Compare v1 and v2 bolocats made from identical labelmaps using the v1v2 compare codes
    """
    if bolocatfile is None:
        bolocatfile = savepath+field+suffix
    if os.path.exists(bolocatfile):
        savedata = idlsave.read(bolocatfile)
    else:
        print "Failed to read %s" % bolocatfile
        return
    v1 = savedata.propsv1
    v2 = savedata.propsv2

    if not os.path.exists("%s/%s" % (savepath,field)):
        os.mkdir("%s/%s" % (savepath,field))

    figure(1)
    if clearplots: clf()
    title("40\" aperture"); xlabel("V1 Jy"); ylabel("V2 Jy")
    ll = loglog(v1.flux_40_nobg, v2.flux_40_nobg, linestyle=linestyle, marker=marker, label=field, **kwargs)[0]
    m40,b40 = PCA_tools.total_least_squares(v1.flux_40_nobg, v2.flux_40_nobg, print_results=True)
    m40noint = PCA_tools.total_least_squares(v1.flux_40_nobg, v2.flux_40_nobg, print_results=True, intercept=False)
    m40l,b40l = polyfit(v1.flux_40_nobg,v2.flux_40_nobg,1)
    #plot([v1.flux_40_nobg.min(),v1.flux_40_nobg.max()],[v1.flux_40_nobg.min()*m40+b40,v1.flux_40_nobg.max()*m40+b40], color=ll.get_color(), label="%0.3g,%0.3g" % (m40,b40))
    plot([v1.flux_40_nobg.min(),v1.flux_40_nobg.max()],[v1.flux_40_nobg.min()*m40noint,v1.flux_40_nobg.max()*m40noint], color=ll.get_color(), label="%0.3g" % (m40noint))
    plot([v1.flux_40_nobg.min(),v1.flux_40_nobg.max()],[v1.flux_40_nobg.min()*m40l+b40l,v1.flux_40_nobg.max()*m40l+b40l], color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m40l,b40l))
    legend(loc='best')
    savefig("%s/%s/%s%s_40_v1vsv2.png" % (savepath,field,prefix,field))

    figure(20)
    clf()
    title("40\" aperture"); xlabel("V1 Jy"); ylabel("V2/V1 Jy")
    ll = semilogx(v1.flux_40_nobg, v2.flux_40_nobg/v1.flux_40_nobg, linestyle=linestyle, marker=marker, label=field, **kwargs)[0]
    print "FITTING RESIDUALS"
    m40,b40 = PCA_tools.total_least_squares(v1.flux_40_nobg, v2.flux_40_nobg/v1.flux_40_nobg, print_results=True)
    plot([v1.flux_40_nobg.min(),v1.flux_40_nobg.max()],array([v1.flux_40_nobg.min(),v1.flux_40_nobg.max()])*m40+b40, color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m40,b40))
    legend(loc='best')
    savefig("%s/%s/%s%s_40_v1vsratio.png" % (savepath,field,prefix,field))

    figure(19)
    clf()
    title("80\" aperture"); xlabel("V1 Jy"); ylabel("V2/V1 Jy")
    ll = semilogx(v1.flux_80, v2.flux_80/v1.flux_80, linestyle=linestyle, marker=marker, label=field, **kwargs)[0]
    print "FITTING RESIDUALS"
    m80,b80 = PCA_tools.total_least_squares(v1.flux_80, v2.flux_80/v1.flux_80, print_results=True)
    plot([v1.flux_80.min(),v1.flux_80.max()],array([v1.flux_80.min(),v1.flux_80.max()])*m80+b80, color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m80,b80))
    legend(loc='best')
    savefig("%s/%s/%s%s_80_v1vsratio.png" % (savepath,field,prefix,field))

    figure(18)
    clf()
    title("120\" aperture"); xlabel("V1 Jy"); ylabel("V2/V1 Jy")
    ll = semilogx(v1.flux_120, v2.flux_120/v1.flux_120, linestyle=linestyle, marker=marker, label=field, **kwargs)[0]
    print "FITTING RESIDUALS"
    m120,b120 = PCA_tools.total_least_squares(v1.flux_120, v2.flux_120/v1.flux_120, print_results=True)
    plot([v1.flux_120.min(),v1.flux_120.max()],array([v1.flux_120.min(),v1.flux_120.max()])*m120+b120, color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m120,b120))
    legend(loc='best')
    savefig("%s/%s/%s%s_120_v1vsratio.png" % (savepath,field,prefix,field))

    figure(5)
    if clearplots: clf()
    title("40\" aperture (bg)"); xlabel("V1 Jy"); ylabel("V2 Jy")
    ll = loglog(v1.flux_40, v2.flux_40, linestyle=linestyle, marker=marker, label=field, **kwargs)[0]
    m40,b40 = PCA_tools.total_least_squares(v1.flux_40, v2.flux_40, print_results=True)
    m40l,b40l = polyfit(v1.flux_40,v2.flux_40,1)
    m40noint = PCA_tools.total_least_squares(v1.flux_40, v2.flux_40, print_results=True, intercept=False)
    plot([v1.flux_40.min(),v1.flux_40.max()],[v1.flux_40.min()*m40noint,v1.flux_40.max()*m40noint], color=ll.get_color(), label="%0.3g" % (m40noint))
    #plot([v1.flux_40.min(),v1.flux_40.max()],[v1.flux_40.min()*m40+b40,v1.flux_40.max()*m40+b40], color=ll.get_color(), label="%0.3g,%0.3g" % (m40,b40))
    plot([v1.flux_40.min(),v1.flux_40.max()],[v1.flux_40.min()*m40l+b40l,v1.flux_40.max()*m40l+b40l], color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m40l,b40l))
    legend(loc='best')
    savefig("%s/%s/%s%s_40_bg_v1vsv2.png" % (savepath,field,prefix,field))

    figure(2)
    if clearplots: clf()
    title("80\" aperture"); xlabel("V1 Jy"); ylabel("V2 Jy")
    loglog(v1.flux_80, v2.flux_80, linestyle=linestyle, marker=marker, label=field, **kwargs)
    m80,b80 = PCA_tools.total_least_squares(v1.flux_80, v2.flux_80, print_results=True)
    m80l,b80l = polyfit(v1.flux_80,v2.flux_80,1)
    m80noint = PCA_tools.total_least_squares(v1.flux_80, v2.flux_80, print_results=True, intercept=False)
    plot([v1.flux_80.min(),v1.flux_80.max()],[v1.flux_80.min()*m80noint,v1.flux_80.max()*m80noint], color=ll.get_color(), label="%0.3g" % (m80noint))
    #plot([v1.flux_80.min(),v1.flux_80.max()],[v1.flux_80.min()*m80+b80,v1.flux_80.max()*m80+b80], color=ll.get_color(), label="%0.3g,%0.3g" % (m80,b80))
    plot([v1.flux_80.min(),v1.flux_80.max()],[v1.flux_80.min()*m80l+b80l,v1.flux_80.max()*m80l+b80l], color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m80l,b80l))
    legend(loc='best')
    savefig("%s/%s/%s%s_80_v1vsv2.png" % (savepath,field,prefix,field))

    figure(3)
    if clearplots: clf()
    title("120\" aperture"); xlabel("V1 Jy"); ylabel("V2 Jy")
    loglog(v1.flux_120, v2.flux_120, linestyle=linestyle, marker=marker, label=field, **kwargs)
    m120,b120 = PCA_tools.total_least_squares(v1.flux_120, v2.flux_120, print_results=True)
    m120l,b120l = polyfit(v1.flux_120,v2.flux_120,1)
    m120noint = PCA_tools.total_least_squares(v1.flux_120, v2.flux_120, print_results=True, intercept=False)
    plot([v1.flux_120.min(),v1.flux_120.max()],[v1.flux_120.min()*m120noint,v1.flux_120.max()*m120noint], color=ll.get_color(), label="%0.3g" % (m120noint))
    #plot([v1.flux_120.min(),v1.flux_120.max()],[v1.flux_120.min()*m120+b120,v1.flux_120.max()*m120+b120], color=ll.get_color(), label="%0.3g,%0.3g" % (m120,b120))
    plot([v1.flux_120.min(),v1.flux_120.max()],[v1.flux_120.min()*m120l+b120l,v1.flux_120.max()*m120l+b120l], color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (m120l,b120l))
    legend(loc='best')
    savefig("%s/%s/%s%s_120_v1vsv2.png" % (savepath,field,prefix,field))

    figure(4)
    if clearplots: clf()
    title("Source Mask"); xlabel("V1 Jy"); ylabel("V2 Jy")
    loglog(v1.flux, v2.flux, linestyle=linestyle, marker=marker, label=field, **kwargs)
    mflux,bflux = PCA_tools.total_least_squares(v1.flux, v2.flux, print_results=True)
    mfluxl,bfluxl = polyfit(v1.flux,v2.flux,1)
    mfluxnoint = PCA_tools.total_least_squares(v1.flux, v2.flux, print_results=True, intercept=False)
    plot([v1.flux.min(),v1.flux.max()],[v1.flux.min()*mfluxnoint,v1.flux.max()*mfluxnoint], color=ll.get_color(), label="%0.3g" % (mfluxnoint))
    #plot([v1.flux.min(),v1.flux.max()],[v1.flux.min()*mflux+bflux,v1.flux.max()*mflux+bflux], color=ll.get_color(), label="%0.3g,%0.3g" % (mflux,bflux))
    plot([v1.flux.min(),v1.flux.max()],[v1.flux.min()*mfluxl+bfluxl,v1.flux.max()*mfluxl+bfluxl], color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (mfluxl,bfluxl))
    legend(loc='best')
    savefig("%s/%s/%s%s_mask_v1vsv2.png" % (savepath,field,prefix,field))

    figure(21)
    clf()
    title("Source Mask"); xlabel("V1 Jy"); ylabel("V2/V1 Jy")
    ll = semilogx(v1.flux, v2.flux/v1.flux, linestyle=linestyle, marker=marker, label=field, **kwargs)[0]
    print "FITTING RESIDUALS (FLUX)"
    mfluxresid,bfluxresid = PCA_tools.total_least_squares(v1.flux, v2.flux/v1.flux, print_results=True)
    plot([v1.flux.min(),v1.flux.max()],array([v1.flux.min(),v1.flux.max()])*mfluxresid+bfluxresid, color=ll.get_color(), linestyle='--', label="%0.3g,%0.3g" % (mfluxresid,bfluxresid))
    legend(loc='best')
    savefig("%s/%s/%s%s_mask_v1vsratio.png" % (savepath,field,prefix,field))

    figure(22)
    clf()
    title("Ratios"); xlabel("V2/V1"); ylabel('Number of Sources')
    hf,lf,pf = hist(v2.flux/v1.flux, bins=linspace(-1,3,21), histtype='stepfilled', alpha=0.5, label='Source Aperture')
    l1 = (lf[1:]+lf[:-1])/2. 
    pars,model,perr,chi = onedgaussfit(l1,hf,params=[0,hf.max(),1.0,(v2.flux/v1.flux).std()],fixed=[True,False,False,False])
    plot(linspace(-1,3,201), onedgaussian(linspace(-1,3,201),*pars), color=pf[0].get_facecolor(), label="$\\mu=%0.2f;\\sigma=%0.2f $" % (pars[-2],pars[-1],) )
    h40,l40,p40 = hist(v2.flux_40/v1.flux_40, bins=linspace(-1,3,21), histtype='stepfilled', alpha=0.5, label='40"')
    pars,model,perr,chi = onedgaussfit(l1,h40,params=[0,h40.max(),1.0,(v2.flux_40/v1.flux_40).std()],fixed=[True,False,False,False])
    plot(linspace(-1,3,201), onedgaussian(linspace(-1,3,201),*pars), color=p40[0].get_facecolor(), label="$\\mu=%0.2f;\\sigma=%0.2f $" % (pars[-2],pars[-1],) )
    h80,l80,p80 = hist(v2.flux_80/v1.flux_80, bins=linspace(-1,3,21), histtype='stepfilled', alpha=0.5, label='80"')
    pars,model,perr,chi = onedgaussfit(l1,h80,params=[0,h80.max(),1.0,(v2.flux_80/v1.flux_80).std()],fixed=[True,False,False,False])
    plot(linspace(-1,3,201), onedgaussian(linspace(-1,3,201),*pars), color=p80[0].get_facecolor(), label="$\\mu=%0.2f;\\sigma=%0.2f $" % (pars[-2],pars[-1],) )
    h120,l120,p120 = hist(v2.flux_120/v1.flux_120, bins=linspace(-1,3,21), histtype='stepfilled', alpha=0.5, label='120"')
    pars,model,perr,chi = onedgaussfit(l1,h120,params=[0,h120.max(),1.0,(v2.flux_120/v1.flux_120).std()],fixed=[True,False,False,False])
    plot(linspace(-1,3,201), onedgaussian(linspace(-1,3,201),*pars), color=p120[0].get_facecolor(), label="$\\mu=%0.2f;\\sigma=%0.2f $" % (pars[-2],pars[-1],) )
    legend(loc='best')
    legend(loc='best')
    savefig("%s/%s/%s%s_ratiohistograms.png" % (savepath,field,prefix,field))

    return v1,v2

if __name__=="__main__":
    import optparse
    parser=optparse.OptionParser()
    parser.add_option("--savepath",help="Save path",default='/Volumes/disk3/adam_work/v1v2compare/')
    parser.add_option("--suffix",help="File suffix",default="_v1v2_bolocat_compare.sav")
    parser.add_option("--prefix",help="File prefix",default="")
    parser.add_option("--bolocatfile",help="Bolocat file name",default=None)
    parser.add_option("--linestyle",help="Line style",default='none')
    parser.add_option("--clearplots",help="Clear plots first?",default=False)
    parser.add_option("--marker",help="Marker symbol",default=',')
    options,args = parser.parse_args()

    print(options,args)

    compare_bolocats(*args, savepath=options.savepath, suffix=options.suffix,
            bolocatfile=options.bolocatfile, linestyle=options.linestyle,
            marker=options.marker, clearplots=options.clearplots,
            prefix=options.prefix)
