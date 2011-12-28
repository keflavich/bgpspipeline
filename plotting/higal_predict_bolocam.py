"""
Use HiGal 350 and 500 micron images to predict the output Bolocam 1.1 mm flux 
"""
import numpy as np
import sys
from agpy import blackbody
# ok better now print "DON'T USE THIS AS IS!!!!  A greybody is NOT predicted by a spectral index at these frequencies!"

import os
pipeline_root = os.getenv('PIPELINE_ROOT')
if pipeline_root is None: pipeline_root = '/Users/adam/work/bgps_pipeline/'
sys.path.append(pipeline_root+'/filterfuncs/')
import filterfuncs

fca = [filterfuncs.freq_center(a,atmosphere=filterfuncs.tatm1p0) for a in np.linspace(0,5,301)]

# it turns out this is a stupid way to predict bolocam fluxes
def measure_alpha(f1,f2,l1,l2):
    ratio = f1/f2
    nuratio = 1./(float(l1)/float(l2)) # nu1/nu2 = lam2/lam1
    alpha = np.log(ratio)/np.log(nuratio)
    return alpha

def predict_bolo_hot(h250, h350):
    """
    Attempt to predict 1100um flux based on 250/350 ratio
    """
    alpha = measure_alpha(h250,h350,250,350)

    nucen = np.interp(alpha, np.linspace(0,5,301), fca) * 1e9
    
    ratiobolo = nucen / (3e14 / 350.)
    Ibolo = ratiobolo**alpha * h350

    return Ibolo

def predict_bolo(h350, h500):
    """
    Attempt to predict 1100um flux based on 350/500 ratio
    """

    alpha = measure_alpha(h350,h500,350,500)
    nucen = np.interp(alpha, np.linspace(0,5,301), fca) * 1e9
    
    ratiobolo = nucen / (3e14 / 500.)
    Ibolo = ratiobolo**alpha * h500

    return Ibolo

def predict_bolo_temp(higal, wav, temperature=20, beta=1.75, wavelength_units='microns'):
    """
    Whoop Whoop doopy doo
    """
    mult = ( blackbody.modified_blackbody_wavelength(1106.6, temperature, beta=beta, wavelength_units='microns', normalize=None, nu0=3e12, logscale=15) /
             blackbody.modified_blackbody_wavelength(wav, temperature, beta=beta, wavelength_units=wavelength_units, normalize=None, nu0=3e12, logscale=15) ) 
    print "For wavelength %0.1f, multiplier is %g" % (wav,mult)

    return higal * mult

