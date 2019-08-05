function [pmsh] = mapproj(mesh,proj,kind)
%MAPPROJ projection operators for JIGSAW MSH objects.
%   [PMSH] = MAPPROJ(MESH,PROJ,KIND) returns the projected
%   mesh object PMSH resulting from application of the
%   projection operator PROJ to the input object MESH. KIND
%   is a string defining the 'direction' of the projection,
%   either KIND='FWD' or KIND='INV'.
%
%   The following projection operators are supported:
%
%       PROJ.KIND = 'STEREOGRAPHIC'
%       PROJ.RRAD = % sphere radii.
%       PROJ.XMID = % central XLON.
%       PROJ.YMID = % central YLAT.
%
%   See also STEREO3

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   26-Jul-2019
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    pmsh = [] ;

    if (~isstruct(mesh) || ...
        ~isstruct(proj) || ...
        ~ischar  (kind) )
    error('mapproj:incorrectInputClass', ...
        'Incorrect input class.') ; 
    end
    
   [ok] = certify(mesh) ;

%----------------------------------- do projection from MESH
    switch (upper(mesh.mshID))    
%----------------------------------- proj. from MESH to MESH
    case{'EUCLIDEAN-MESH',
         'ELLIPSOID-MESH'}
 
        if (meshhas(mesh,'point') && ...
                size(mesh.point.coord,2) == +3)
    
        pmsh = mesh;
    
        XPOS = mesh.point.coord(:, 1) ;
        YPOS = mesh.point.coord(:, 2) ;
        
    %------------------------------- proj. geometry parts
        switch (upper(proj.kind))
        case 'STEREOGRAPHIC'
        
           [XNEW,YNEW,SCAL] = stereo3( ...
                proj.rrad, ...
            XPOS,YPOS,proj.xmid,proj.ymid,kind) ;

        case 'HAMMER-AITOFF'
        
           [XNEW,YNEW,SCAL] = hammer3( ...
                proj.rrad, ...
            XPOS,YPOS,proj.xmid,proj.ymid,kind) ;
        
        otherwise
        
        error('mapproj:unsupportedProjection', ...
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
        pmsh.radii = proj.rrad(1) * ...
                     ones (+3,+1) ;
        
        otherwise
        
        error('mapproj:invalidProjectionKind', ...
            'Incorrect projection KIND flags.') ;
        
        end
     
        pmsh.point.coord = ...
        zeros(size( mesh.point.coord));
        pmsh.point.coord(:, 1) = XNEW ;
        pmsh.point.coord(:, 2) = YNEW ;
        
    %------------------------------- setup proj.'d extras
        if (meshhas(mesh,'value'))
        
        pmsh.value = mesh.value.*SCAL ;
        
        end
        
        if (meshhas(mesh,'point', ...
                         'power'))
        
        pmsh.point.power = ...
        pmsh.point.power .* sqrt(SCAL);
        
        end
    
        end
  
%----------------------------------- proj. from GRID to MESH
    case{'EUCLIDEAN-GRID',
         'ELLIPSOID-GRID'}
    
        if (meshhas(mesh,'point') && ...
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
        switch (upper(proj.kind))
        case 'STEREOGRAPHIC'
        
           [XNEW,YNEW,SCAL] = stereo3( ...
                proj.rrad, ...
            XPOS,YPOS,proj.xmid,proj.ymid,kind) ;

        case 'HAMMER-AITOFF'
        
           [XNEW,YNEW,SCAL] = hammer3( ...
                proj.rrad, ...
            XPOS,YPOS,proj.xmid,proj.ymid,kind) ;
        
        otherwise
        
        error('mapproj:unsupportedProjection', ...
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
        pmsh.radii = proj.rrad(1) * ...
                     ones (+3,+1) ;
        
        otherwise
        
        error('mapproj:invalidProjectionKind', ...
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
        if (meshhas(mesh,'value'))
        
        pmsh.value = mesh.value(:).*SCAL ;
        
        end
    
        end
    
    end

end



