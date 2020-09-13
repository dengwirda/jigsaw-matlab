function drawtria_4(pp,t4,varargin)
%DRAWTRIA-4 draw TRIA-4 elements defined by [PP,T4].
%   DRAWTRIA_4(PP,T4) draws elements onto the current axes,
%   where PP is an NP-by-ND array of vertex positions and
%   T4 is an NT-by-4 array of cell-indexing. Additional
%   plotting arguments can be passed as name / value pairs.
%
%   See also DRAWMESH

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   07-Aug-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if (isempty(t4)), return; end

    ec = [.20,.20,.20] ;
    ei = [.25,.25,.25] ;
    fe = [.95,.95,.50] ;
    fi = [.95,.95,.90] ;

    if (nargin >= 3)
%-- extract users R^3 splitting plane
        ti = varargin{+1} ;
    else
%-- calc. default R^3 splitting plane
        if (size(t4,1) > 1)

        dc = max(pp( :,:),[],1) - ...
             min(pp( :,:),[],1) ;
       [dd,id] = max( dc) ;

        ok = pp( :,id) < ...
          median(pp( :,id))+ .10*dd ;

        ti = all(ok(t4),2);

        else

        ti = true (size(t4,1),1);

        end
    end

    if (all(ti) || all(~ti))                % a single part

    f1 = build_surf_4(t4(  :,:));

%-- draw external surface
    patch('faces',f1(  :,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.40,...
        'facealpha',1.00) ;

    else

    f1 = build_surf_4(t4( ti,:));
    f2 = build_surf_4(t4(~ti,:));

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

end

function [fe] = build_surf_4(t4)
%BUILD-SURF-4 return surface facets from a TRIA-4 topology.

    ff = [t4(:,[1,2,3]);
          t4(:,[1,4,2]);
          t4(:,[2,4,3]);
          t4(:,[3,4,1])] ;

   [fj,ii,jj] = unique (sort(ff,2),'rows');

    ff = ff(ii,:);

    ss = accumarray(jj, ...
        ones(size(jj)),[size(ff,1),1]) ;

    fe = ff(ss==+1,:);  % external faces
   %fi = ff(ss~=+1,:);  % internal faces

end



