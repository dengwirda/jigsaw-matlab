function savejig(name,opts)
%SAVEJIG save a *.JIG configuration file for JIGSAW.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   21-Sep-2020
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

   [path,file,fext] = fileparts(name) ;

    if(~strcmp(lower(fext),'.jig'))
        error('Invalid file name');
    end

    try

    ffid = fopen(name, 'w' ) ;

    if (exist('OCTAVE_VERSION','builtin')  > 0)
    fprintf(ffid, ...
    '# %s.jig config. file; created by JIGSAW''s OCTAVE interface\n',file);
    else
    fprintf(ffid, ...
    '# %s.jig config. file; created by JIGSAW''s MATLAB interface\n',file);
    end

    data = fieldnames (opts) ;
    data = sort(data) ;

    for ii = +1:length(data)

    switch (lower(data{ii}))
    %------------------------------------------ MISC options
        case 'verbosity'
        pushints(ffid,opts.verbosity,'VERBOSITY');

        case 'tria_file'
        pushchar(ffid,opts.tria_file,'TRIA_FILE');

        case 'bnds_file'
        pushchar(ffid,opts.bnds_file,'BNDS_FILE');

        case 'jcfg_file' ;

    %------------------------------------------ INIT options
        case 'init_file'
        pushchar(ffid,opts.init_file,'INIT_FILE');

        case 'init_near'
        pushreal(ffid,opts.init_near,'INIT-NEAR');

    %------------------------------------------ GEOM options
        case 'geom_file'
        pushchar(ffid,opts.geom_file,'GEOM_FILE');

        case 'geom_seed'
        pushints(ffid,opts.geom_seed,'GEOM_SEED');

        case 'geom_feat'
        pushbool(ffid,opts.geom_feat,'GEOM_FEAT');

        case 'geom_phi1'
        pushreal(ffid,opts.geom_phi1,'GEOM_PHI1');
        case 'geom_phi2'
        pushreal(ffid,opts.geom_phi2,'GEOM_PHI2');

        case 'geom_eta1'
        pushreal(ffid,opts.geom_eta1,'GEOM_ETA1');
        case 'geom_eta2'
        pushreal(ffid,opts.geom_eta2,'GEOM_ETA2');

    %------------------------------------------ HFUN options
        case 'hfun_file'
        pushchar(ffid,opts.hfun_file,'HFUN_FILE');

        case 'hfun_scal'
        pushchar(ffid,opts.hfun_scal,'HFUN_SCAL');

        case 'hfun_hmax'
        pushreal(ffid,opts.hfun_hmax,'HFUN_HMAX');
        case 'hfun_hmin'
        pushreal(ffid,opts.hfun_hmin,'HFUN_HMIN');

    %------------------------------------------ BNDS options
        case 'bnds_kern'
        pushchar(ffid,opts.bnds_kern,'BNDS_KERN');

    %------------------------------------------ MESH options
        case 'mesh_file'
        pushchar(ffid,opts.mesh_file,'MESH_FILE');

        case 'mesh_kern'
        pushchar(ffid,opts.mesh_kern,'MESH_KERN');

        case 'mesh_iter'
        pushints(ffid,opts.mesh_iter,'MESH_ITER');

        case 'mesh_rule'
        pushints(ffid,opts.mesh_rule,'MESH_RULE');

        case 'mesh_dims'
        pushints(ffid,opts.mesh_dims,'MESH_DIMS');

        case 'mesh_top1'
        pushbool(ffid,opts.mesh_top1,'MESH_TOP1');
        case 'mesh_top2'
        pushbool(ffid,opts.mesh_top2,'MESH_TOP2');

        case 'mesh_siz1'
        pushreal(ffid,opts.mesh_siz1,'MESH_SIZ1');
        case 'mesh_siz2'
        pushreal(ffid,opts.mesh_siz2,'MESH_SIZ2');
        case 'mesh_siz3'
        pushreal(ffid,opts.mesh_siz3,'MESH_SIZ3');

        case 'mesh_eps1'
        pushreal(ffid,opts.mesh_eps1,'MESH_EPS1');
        case 'mesh_eps2'
        pushreal(ffid,opts.mesh_eps2,'MESH_EPS2');

        case 'mesh_rad2'
        pushreal(ffid,opts.mesh_rad2,'MESH_RAD2');
        case 'mesh_rad3'
        pushreal(ffid,opts.mesh_rad3,'MESH_RAD3');

        case 'mesh_off2'
        pushreal(ffid,opts.mesh_off2,'MESH_OFF2');
        case 'mesh_off3'
        pushreal(ffid,opts.mesh_off3,'MESH_OFF3');

        case 'mesh_snk2'
        pushreal(ffid,opts.mesh_snk2,'MESH_SNK2');
        case 'mesh_snk3'
        pushreal(ffid,opts.mesh_snk3,'MESH_SNK3');

        case 'mesh_vol3'
        pushreal(ffid,opts.mesh_vol3,'MESH_VOL3');

    %------------------------------------------ OPTM options
        case 'optm_kern'
        pushchar(ffid,opts.optm_kern,'OPTM_KERN');

        case 'optm_iter'
        pushints(ffid,opts.optm_iter,'OPTM_ITER');

        case 'optm_qtol'
        pushreal(ffid,opts.optm_qtol,'OPTM_QTOL');
        case 'optm_qlim'
        pushreal(ffid,opts.optm_qlim,'OPTM_QLIM');

        case 'optm_zip_'
        pushbool(ffid,opts.optm_zip_,'OPTM_ZIP_');
        case 'optm_div_'
        pushbool(ffid,opts.optm_div_,'OPTM_DIV_');
        case 'optm_tria'
        pushbool(ffid,opts.optm_tria,'OPTM_TRIA');
        case 'optm_dual'
        pushbool(ffid,opts.optm_dual,'OPTM_DUAL');


    %------------------------------------------ abandoned OP
        case{'hfun_kern', ...
             'hfun_grad'}
        warning( ...
        ['Deprecated!!: OPTS.', upper(data{ii})]);

        otherwise
        error  ( ...
        ['Invalid data: OPTS.', upper(data{ii})]);
    end

    end

    fclose(ffid);

    catch   err

    if (ffid>-1)
    fclose(ffid);
    end

    rethrow(err);

    end

end

function pushbool(ffid,data,name)
%PUSHBOOL push "bool" param-value onto JCFG file for JIGSAW.

    if (islogical(data))
        if (data)
            pushchar(ffid,'true' ,name);
        else
            pushchar(ffid,'false',name);
        end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushchar(ffid,data,name)
%PUSHCHAR push "char" param-value onto JCFG file for JIGSAW.

    if (ischar(data))
        fprintf(ffid,['  ',name,'=%s\n'],data);
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushints(ffid,data,name)
%PUSHINTS push "ints" param-value onto JCFG file for JIGSAW.

    if (isnumeric(data))
        if (numel(data) == +1)
        fprintf(ffid,['  ',name,'=%i\n'],data);
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushreal(ffid,data,name)
%PUSHREAL push "real" param-value onto JCFG file for JIGSAW.

    if (isnumeric(data))
        if (numel(data) == +1)
        fprintf(ffid,['  ',name,'=%1.17g\n'],data);
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end



