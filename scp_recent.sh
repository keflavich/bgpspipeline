cd /Users/adam/work/bolocam/AGidl/publish
scp mapping/map_iter.pro mapping/ts_to_map.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/mapping/
scp cleaning/clean_iter_struct.pro cleaning/psd_weight.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/cleaning/
scp cleaning/flagging/mad_flagger.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/cleaning/flagging/
scp reading/readall_pc.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/reading/
scp wrappers/mem_iter.pro wrappers/premap.pro wrappers/coalign_field.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/wrappers/
scp support/nantozero.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/support/
scp scripts/do_planets.pro scripts/do_fromsave.pro scripts/do_coalign* scripts/do_all_centroids_radec.pro ginsbura@milkyway.colorado.edu:./bgps_pipeline/scripts/
