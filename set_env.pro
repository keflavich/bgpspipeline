; set environmental variables
; choose computer name (compy)
pro set_env,compy=compy
    
    if n_e(compy) eq 0 then begin  ;default
        spawn,'echo $HOSTNAME',hn
        compy = strmid(hn,0,stregex(hn,"\."))
    endif
    
    if compy eq 'milkyway' then begin
        ; milkyway defaults
        setenv,'PIPELINE_ROOT=/home/milkyway/student/ginsbura/bgps_pipeline'
        setenv,'WORKINGDIR=/scratch/adam_work'
        setenv,'WORKINGDIR2=/usb/scratch1'
        setenv,'SLICED=/scratch/sliced'
        setenv,'SLICED_POLY=/scratch/sliced_polychrome'
        setenv,'REFDIR=/data/bgps/releases/v0.6'
        setenv,'V12=/data/bgps/releases/v1.0/v1.0.2'
        setenv,'RPCDIR=/data/bgps/raw'
    endif else if compy eq 'eta' then begin
        setenv,'PIPELINE_ROOT=/Users/adam/work/bolocam/AGidl/bgps_pipeline'
        setenv,'WORKINGDIR=/Volumes/milkyway/adam_work'
        setenv,'WORKINGDIR2=/Volumes/milkyway/adam_work'
        setenv,'SLICED=/Volumes/milkyway/sliced'
        setenv,'SLICED_POLY=/Volumes/milkyway/sliced_polychrome'
        setenv,'REFDIR=/Volumes/milkyway/ref_fields'
        setenv,'V12=/Volumes/milkyway/releases/v1.0/v1.0.2'
        setenv,'RPCDIR=/does/not/exist/yet'
    endif

end
