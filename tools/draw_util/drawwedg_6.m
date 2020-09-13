function drawwedg_6(pp,w6,varargin)
%DRAWWEDG-6 draw WEDG-6 elements defined by [PP,W6].
%   DRAWWEDG_6(PP,W6) draws elements onto the current axes,
%   where PP is an NP-by-ND array of vertex positions and
%   W6 is an NW-by-6 array of cell-indexing. Additional
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

    if (isempty(w6)), return; end

    ec = [.20,.20,.20] ;
    ei = [.25,.25,.25] ;
    fe = [.75,.95,.50] ;
    fi = [.95,.95,.90] ;

    if (nargin >= 3)
%-- extract users R^3 splitting plane
        ti = varargin{+1} ;
    else
%-- calc. default R^3 splitting plane
        if (size(w6,1) > 1)

        dc = max(pp( :,:),[],1) - ...
             min(pp( :,:),[],1) ;
       [dd,id] = max( dc) ;

        ok = pp( :,id) < ...
          median(pp( :,id))+ .10*dd ;

        ti = all(ok(w6),2);

        else

        ti = true (size(w6,1),1);

        end
    end

    if (all(ti) || all(~ti))                % a single part

   [t1,q1] = build_surf_6(w6(  :,:));

%-- draw external surface
    patch('faces',t1(  :,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
    patch('faces',q1(  :,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.40,...
        'facealpha',1.00) ;

    else

   [t1,q1] = build_surf_6(w6( ti,:));
   [t2,q2] = build_surf_6(w6(~ti,:));

    c1 = ismember(sort(t1,2), ...
                  sort(t2,2),'rows');       % common facets
    c2 = ismember(sort(t2,2), ...
                  sort(t1,2),'rows');

    c3 = ismember(sort(q1,2), ...
                  sort(q2,2),'rows');
    c4 = ismember(sort(q2,2), ...
                  sort(q1,2),'rows');

%-- draw external surface
    patch('faces',t1(~c1,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
    patch('faces',q1(~c3,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
%-- draw internal surface
    patch('faces',t1( c1,:),'vertices',pp,...
        'facecolor',fi,...
        'edgecolor',ei,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
    patch('faces',q1( c3,:),'vertices',pp,...
        'facecolor',fi,...
        'edgecolor',ei,...
        'linewidth',0.40,...
        'facealpha',1.00) ;
%-- draw transparent part
    patch('faces',t2(~c2,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor','none',...
        'linewidth',0.40,...
        'facealpha',0.20) ;
    patch('faces',q2(~c4,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor','none',...
        'linewidth',0.40,...
        'facealpha',0.20) ;

    end

end

function [te,qe] = build_surf_6(w6)
%BUILD-SURF-6 return surface facets from a WEDG-6 topology.

    tt = [w6(:,[1,2,3]);
          w6(:,[4,5,6]);
         ] ;

   [tj,ii,jj] = unique (sort(tt,2),'rows');

    tt = tt(ii,:);

    ss = accumarray(jj, ...
        ones(size(jj)),[size(tt,1),1]) ;

    te = tt(ss==+1,:);  % external faces
   %ti = tt(ss~=+1,:);  % internal faces

    qq = [w6(:,[1,2,5,4]);
          w6(:,[2,3,6,5]);
          w6(:,[3,1,4,6]);
         ] ;

   [qj,ii,jj] = unique (sort(qq,2),'rows');

    qq = qq(ii,:);

    ss = accumarray(jj, ...
        ones(size(jj)),[size(qq,1),1]) ;

    qe = qq(ss==+1,:);  % external faces
   %qi = qq(ss~=+1,:);  % internal faces

end



