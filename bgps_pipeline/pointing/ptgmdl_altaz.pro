pro ptgmdl_altaz,alt,az,altoff,azoff,altaltoff_model=altaltoff_model,altazoff_model=altazoff_model,altoff_fit=altoff_fit,azoff_fit=azoff_fit,$
    azaltoff_model=azaltoff_model,azazoff_model=azazoff_model
    azaltoff_model = poly_fit(az,altoff,3)
    azazoff_model = poly_fit(az,azoff,3)
    altoff_azcorr = altoff - poly(az,azaltoff_model)
    azoff_azcorr  = azoff  - poly(az,azazoff_model)
    altaltoff_model = poly_fit(alt,altoff_azcorr,2)
    altazoff_model = poly_fit(alt,azoff_azcorr,2)
    altoff_fit = poly(alt,altaltoff_model) + poly(az,azaltoff_model)
    azoff_fit = poly(alt,altazoff_model) + poly(az,azazoff_model)
end

    
