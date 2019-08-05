function drawhexa_8(pp,h8,varargin)
%DRAWHEXA-8 draw HEXA-8 elements defined by [PP,H8]. 
%   DRAWHEXA_8(PP,H8) draws elements onto the current axes, 
%   where PP is an NP-by-ND array of vertex positions and 
%   H8 is an NH-by-8 array of cell-indexing. Additional 
%   plotting arguments can be passed as name / value pairs.
%
%   See also DRAWMESH

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   13-Aug-2018
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    if (isempty(h8)), return; end

    if (nargin >= 3)
%-- extract users R^3 splitting plane
        ti = varargin{+1} ; 
    else
%-- calc. default R^3 splitting plane        
        ip = unique(h8(:));
        
        dc = max(pp(ip,:),[],1) - ...
             min(pp(ip,:),[],1) ;
       [dd,id] = max( dc) ;
         
        ok = false(size(pp,1),1);
        ok(ip) = pp(ip,id) < ...
          median(pp(ip,id))+ .10*dd ;
            
        ti = all(ok(h8),2);  
    end

    ec = [.20,.20,.20];
    ei = [.25,.25,.25];
    fe = [.95,.95,.50];
    fi = [.95,.95,.90];
    
    f1 = build_surf_8(h8( ti,:));
    f2 = build_surf_8(h8(~ti,:));
    
    c1 = ismember(sort(f1,2), ...
                  sort(f2,2),'rows');       % common facets
    c2 = ismember(sort(f2,2), ...
                  sort(f1,2),'rows');
    
%-- draw external surface
    patch('faces',f1(~c1,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
%-- draw internal surface
    patch('faces',f1( c1,:),'vertices',pp,...
        'facecolor',fi,...
        'edgecolor',ei,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
%-- draw transparent part
    patch('faces',f2(~c2,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor','none',...
        'linewidth',0.40,...
        'facealpha',0.20) ;
  
end

function [fe] = build_surf_8(h8)
%BUILD-SURF-8 return surface facets from a HEXA-8 topology.

    ff = [h8(:,[1,2,3,4]);
          h8(:,[1,2,3,4]);
          h8(:,[1,2,3,4]);
          h8(:,[1,2,3,4]);
          h8(:,[1,2,3,4]);
          h8(:,[1,2,3,4])] ;

   [fj,ii,jj] = unique (sort(ff,2),'rows');
    
    ff = ff(ii,:);
    
    ss = accumarray(jj, ...
        ones(size(jj)),[size(ff,1),1]) ;
    
    fe = ff(ss==+1,:);  % external faces
   %fi = ff(ss~=+1,:);  % internal faces
      
end



