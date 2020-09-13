function drawpyra_5(pp,p5,varargin)
%DRAWPYRA-5 draw PYRA-5 elements defined by [PP,P5].
%   DRAWPYRA_5(PP,P5) draws elements onto the current axes,
%   where PP is an NP-by-ND array of vertex positions and
%   P5 is an NC-by-5 array of cell-indexing. Additional
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

    if (isempty(p5)), return; end

    ec = [.20,.20,.20] ;
    ei = [.25,.25,.25] ;
    fe = [.95,.75,.50] ;
    fi = [.95,.95,.90] ;

    if (nargin >= 3)
%-- extract users R^3 splitting plane
        ti = varargin{+1} ;
    else
%-- calc. default R^3 splitting plane
        if (size(p5,1) > 1)

        dc = max(pp( :,:),[],1) - ...
             min(pp( :,:),[],1) ;
       [dd,id] = max( dc) ;

        ok = pp( :,id) < ...
          median(pp( :,id))+ .10*dd ;

        ti = all(ok(p5),2);

        else

        ti = true (size(p5,1),1);

        end
    end

    if (all(ti) || all(~ti))                % a single part

   [t1,q1] = build_surf_5(p5(  :,:));

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

   [t1,q1] = build_surf_5(p5( ti,:));
   [t2,q2] = build_surf_5(p5(~ti,:));

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

function [te,qe] = build_surf_5(p5)
%BUILD-SURF-5 return surface facets from a PYRA-5 topology.

    tt = [p5(:,[1,2,5]);
          p5(:,[2,3,5]);
          p5(:,[3,4,5]);
          p5(:,[4,1,5]);
         ] ;

   [tj,ii,jj] = unique (sort(tt,2),'rows');

    tt = tt(ii,:);

    ss = accumarray(jj, ...
        ones(size(jj)),[size(tt,1),1]) ;

    te = tt(ss==+1,:);  % external faces
   %ti = tt(ss~=+1,:);  % internal faces

    qq = [p5(:,[1,2,3,4]);
         ] ;

   [qj,ii,jj] = unique (sort(qq,2),'rows');

    qq = qq(ii,:);

    ss = accumarray(jj, ...
        ones(size(jj)),[size(qq,1),1]) ;

    qe = qq(ss==+1,:);  % external faces
   %qi = qq(ss~=+1,:);  % internal faces

end



