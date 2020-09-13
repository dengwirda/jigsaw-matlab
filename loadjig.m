function [opts] = loadjig(name)
%LOADJIG load a *.JIG configuration file for JIGSAW.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   29-Oct-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    opts = [] ;

    try

    ffid = fopen(name,'r') ;

    if (ffid < +0)
    error(['File not found: ', name]) ;
    end

    while (true)

    %-- read the next line from file
        lstr = fgetl(ffid);

        if (ischar(lstr) )

        if (length(lstr) > +0 && lstr(1) ~= '#')

        %-- tokenise line over '=' character
            tstr = regexp(lower(lstr),'=','split');

            if (length(tstr) ~= +2)
                warning(['Invalid tag: ',lstr]);
                continue;
            end

            switch (lower(strtrim(tstr{1})))
        %-------------------------------------- MISC options
            case 'verbosity'
            opts .verbosity = str2double(tstr{2});

            case 'tria_file'
            opts .tria_file = strtrim(tstr{2});

            case 'bnds_file'
            opts .bnds_file = strtrim(tstr{2});

        %-------------------------------------- INIT options
            case 'init_file'
            opts .init_file = strtrim(tstr{2});

            case 'init_near'
            opts .init_near = str2double(tstr{2});

        %-------------------------------------- GEOM options
            case 'geom_file'
            opts .geom_file = strtrim(tstr{2});

            case 'geom_seed'
            opts .geom_seed = str2double(tstr{2});

            case 'geom_feat'
            opts .geom_feat = ...
                strcmpi(strtrim(tstr{2}), 'true');

            case 'geom_phi1'
            opts .geom_phi1 = str2double(tstr{2});
            case 'geom_phi2'
            opts .geom_phi2 = str2double(tstr{2});

            case 'geom_eta1'
            opts .geom_eta1 = str2double(tstr{2});
            case 'geom_eta2'
            opts .geom_eta2 = str2double(tstr{2});

        %-------------------------------------- HFUN options
            case 'hfun_file'
            opts .hfun_file = strtrim(tstr{2});

            case 'hfun_scal'
            opts .hfun_scal = strtrim(tstr{2});

            case 'hfun_hmax'
            opts .hfun_hmax = str2double(tstr{2});
            case 'hfun_hmin'
            opts .hfun_hmin = str2double(tstr{2});

        %-------------------------------------- BNDS options
            case 'bnds_kern'
            opts .bnds_kern = strtrim(tstr{2});

        %-------------------------------------- MESH options
            case 'mesh_file'
            opts .mesh_file = strtrim(tstr{2});

            case 'mesh_kern'
            opts .mesh_kern = strtrim(tstr{2});

            case 'mesh_iter'
            opts .mesh_iter = str2double(tstr{2});

            case 'mesh_rule'
            opts .mesh_rule = str2double(tstr{2});

            case 'mesh_dims'
            opts .mesh_dims = str2double(tstr{2});

            case 'mesh_top1'
            opts .mesh_top1 = ...
                strcmpi(strtrim(tstr{2}), 'true');
            case 'mesh_top2'
            opts .mesh_top2 = ...
                strcmpi(strtrim(tstr{2}), 'true');

            case 'mesh_siz1'
            opts .mesh_siz1 = str2double(tstr{2});
            case 'mesh_siz2'
            opts .mesh_siz2 = str2double(tstr{2});
            case 'mesh_siz3'
            opts .mesh_siz3 = str2double(tstr{2});

            case 'mesh_eps1'
            opts .mesh_eps1 = str2double(tstr{2});
            case 'mesh_eps2'
            opts .mesh_eps2 = str2double(tstr{2});

            case 'mesh_rad2'
            opts .mesh_rad2 = str2double(tstr{2});
            case 'mesh_rad3'
            opts .mesh_rad3 = str2double(tstr{2});

            case 'mesh_off2'
            opts .mesh_off2 = str2double(tstr{2});
            case 'mesh_off3'
            opts .mesh_off3 = str2double(tstr{2});

            case 'mesh_snk2'
            opts .mesh_snk3 = str2double(tstr{2});
            case 'mesh_snk3'
            opts .mesh_snk3 = str2double(tstr{2});

            case 'mesh_vol3'
            opts .mesh_vol3 = str2double(tstr{2});

        %-------------------------------------- OPTM options
            case 'optm_kern'
            opts .optm_kern = strtrim(tstr{2});

            case 'optm_iter'
            opts .optm_iter = str2double(tstr{2});

            case 'optm_qtol'
            opts .optm_qtol = str2double(tstr{2});
            case 'optm_qlim'
            opts .optm_qlim = str2double(tstr{2});

            case 'optm_zip_'
            opts .optm_zip_ = ...
                strcmpi(strtrim(tstr{2}), 'true');
            case 'optm_div_'
            opts .optm_div_ = ...
                strcmpi(strtrim(tstr{2}), 'true');
            case 'optm_tria'
            opts .optm_tria = ...
                strcmpi(strtrim(tstr{2}), 'true');
            case 'optm_dual'
            opts .optm_dual = ...
                strcmpi(strtrim(tstr{2}), 'true');

            end

        end

        else
    %-- if(~ischar(lstr)) //i.e. end-of-file
            break;
        end

    end

    fclose(ffid) ;

    catch err

%-- ensure that we close the file regardless!
    if (ffid>-1)
    fclose(ffid) ;
    end

    rethrow(err) ;

    end

end



