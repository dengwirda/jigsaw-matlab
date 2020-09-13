function [pmsh] = project(mesh,proj,kind)
%PROJECT cartographic projections for JIGSAW MSH objects.
%   [PMSH] = PROJECT(MESH,PROJ,KIND) returns the projected
%   mesh object PMSH resulting from application of the
%   projection operator PROJ to the input object MESH. KIND
%   is a string defining the 'direction' of the projection,
%   either KIND='FWD' or KIND='INV'.
%
%   The following projection operators are supported:
%
%       PROJ.PRJID = 'STEREOGRAPHIC'
%       PROJ.RADII = % sphere radii.
%       PROJ.XBASE = % central XLON.
%       PROJ.YBASE = % central YLAT.
%
%   See also STEREO3

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   30-Aug-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    pmsh = [] ;

    if (~isstruct(mesh) || ...
        ~isstruct(proj) || ...
        ~ischar  (kind) )
    error('project:incorrectInputClass', ...
        'Incorrect input class.') ;
    end

   [ok] = certify(mesh) ;

%----------------------------------- do projection from MESH
    switch (upper(mesh.mshID))
%----------------------------------- proj. from MESH to MESH
    case{'EUCLIDEAN-MESH',
         'ELLIPSOID-MESH'}

        if (inspect(mesh,'point') && ...
                size(mesh.point.coord,2) == +3)

        pmsh = mesh;

        XPOS = mesh.point.coord(:, 1) ;
        YPOS = mesh.point.coord(:, 2) ;

    %------------------------------- proj. geometry parts
        switch (upper(proj.prjID))
        case 'STEREOGRAPHIC'

           [XNEW,YNEW,SCAL] = stereo3( ...
                proj.radii, ...
            XPOS,YPOS,proj.xbase,proj.ybase,kind) ;

        case 'HAMMER-AITOFF'

           [XNEW,YNEW,SCAL] = hammer3( ...
                proj.radii, ...
            XPOS,YPOS,proj.xbase,proj.ybase,kind) ;

        otherwise

        error('project:unsupportedProjection', ...
            'Unsupported projection operator.') ;

        end

    %------------------------------- setup proj.'d object
        switch (upper(kind))
        case 'FWD'

        pmsh.mshID = 'EUCLIDEAN-MESH' ;

        if (isfield(pmsh,'radii'))
            pmsh = rmfield(pmsh,'radii') ;
        end

        case 'INV'

        pmsh.mshID = 'ELLIPSOID-MESH' ;
        pmsh.radii = proj.radii(1) * ...
                     ones (+3, +1) ;

        otherwise

        error('project:invalidProjectionKind', ...
            'Incorrect projection KIND flags.') ;

        end

        pmsh.point.coord = ...
        zeros(size( mesh.point.coord));
        pmsh.point.coord(:, 1) = XNEW ;
        pmsh.point.coord(:, 2) = YNEW ;

    %------------------------------- setup proj.'d extras
        if (inspect(mesh,'value'))

        pmsh.value = mesh.value.*SCAL ;

        end

        if (inspect(mesh,'point', ...
                         'power'))

        pmsh.point.power = ...
        pmsh.point.power .* sqrt(SCAL);

        end

        end

%----------------------------------- proj. from GRID to MESH
    case{'EUCLIDEAN-GRID',
         'ELLIPSOID-GRID'}

        if (inspect(mesh,'point') && ...
                size(mesh.point.coord,2) == +2)

        dim1 = ...
        length(mesh.point.coord{   2});
        dim2 = ...
        length(mesh.point.coord{   1});

        XPOS = mesh.point.coord{   1} ;
        YPOS = mesh.point.coord{   2} ;

       [XPOS,YPOS] = meshgrid(XPOS,YPOS);

        XPOS = XPOS(:);
        YPOS = YPOS(:);

    %------------------------------- proj. geometry parts
        switch (upper(proj.prjID))
        case 'STEREOGRAPHIC'

           [XNEW,YNEW,SCAL] = stereo3( ...
                proj.radii, ...
            XPOS,YPOS,proj.xbase,proj.ybase,kind) ;

        case 'HAMMER-AITOFF'

           [XNEW,YNEW,SCAL] = hammer3( ...
                proj.radii, ...
            XPOS,YPOS,proj.xbase,proj.ybase,kind) ;

        otherwise

        error('project:unsupportedProjection', ...
            'Unsupported projection operator.') ;

        end

    %------------------------------- setup proj.'d object
        switch (upper(kind))
        case 'FWD'

        pmsh.mshID = 'EUCLIDEAN-MESH' ;

        if (isfield(pmsh,'radii'))
            pmsh = rmfield(pmsh,'radii') ;
        end

        case 'INV'

        pmsh.mshID = 'ELLIPSOID-MESH' ;
        pmsh.radii = proj.radii(1) * ...
                     ones (+3, +1) ;

        otherwise

        error('project:invalidProjectionKind', ...
            'Incorrect projection KIND flags.') ;

        end

        pmsh.point.coord = ...
            zeros(length(XNEW),3);
        pmsh.point.coord(:, 1) = XNEW ;
        pmsh.point.coord(:, 2) = YNEW ;

    %------------------------------- setup proj.'d topol.
        pmsh.tria3.index = ...
        zeros(2*(dim1-1)*(dim2-1), 4) ;

        for jpos = +1:dim2-1

            moff = (dim1-1) *    2 ;
            noff = (jpos-1) * moff ;

            pmsh.tria3.index( ...
            noff+1:noff+moff,1:3) =  [ ...
            (1:dim1-1)'+(jpos-1)*dim1, ...
            (2:dim1-0)'+(jpos-1)*dim1, ...
            (2:dim1-0)'+(jpos-0)*dim1; ...
            (1:dim1-1)'+(jpos-1)*dim1, ...
            (2:dim1-0)'+(jpos-0)*dim1, ...
            (1:dim1-1)'+(jpos-0)*dim1];

        end

    %------------------------------- setup proj.'d extras
        if (inspect(mesh,'value'))

        pmsh.value = mesh.value(:).*SCAL ;

        end

        if (inspect(mesh,'slope'))

        pmsh.slope = mesh.slope(:) ;

        end

        end

    end

end



