function [cost] = meshcost(mesh)
%MESHCOST calculate cost metrics for a given mesh.

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   22-Mar-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
%

    cost = [];
    
    if (meshhas(mesh,'tria3'))
    
        cost.tria3.score = ...
            score2(mesh.point.coord(:,1:end-1), ...
                   mesh.tria3.index(:,1:end-1)) ;
        cost.tria3.angle = ...
            angle2(mesh.point.coord(:,1:end-1), ...
                   mesh.tria3.index(:,1:end-1)) ;

    end
    
    if (meshhas(mesh,'tria4'))
    
        cost.tria4.score = ...
            score3(mesh.point.coord(:,1:end-1), ...
                   mesh.tria4.index(:,1:end-1)) ;
        cost.tria4.angle = ...
            angle3(mesh.point.coord(:,1:end-1), ...
                   mesh.tria4.index(:,1:end-1)) ;
    
    end

    if (meshhas(mesh,'point','sizfn'))
        
    if (meshhas(mesh,'edge2'))
  
        hvec = zeros(size(mesh.point.coord,1),1) ;
        hvec(mesh.point.sizfn.index) = ...
             mesh.point.sizfn.value ;
        
        cost.edge2.hfunc = ...
            hfunc1(mesh.point.coord(:,1:end-1), ...
                   mesh.edge2.index(:,1:end-1), ...
                   hvec) ;
                         
    end
    if (meshhas(mesh,'tria3'))
  
        hvec = zeros(size(mesh.point.coord,1),1) ;
        hvec(mesh.point.sizfn.index) = ...
             mesh.point.sizfn.value ;
        
        cost.tria3.hfunc = ...
            hfunc2(mesh.point.coord(:,1:end-1), ...
                   mesh.tria3.index(:,1:end-1), ...
                   hvec) ;
        
    end
    if (meshhas(mesh,'tria4'))
  
        hvec = zeros(size(mesh.point.coord,1),1) ;
        hvec(mesh.point.sizfn.index) = ...
             mesh.point.sizfn.value ;
        
        cost.tria4.hfunc = ...
            hfunc3(mesh.point.coord(:,1:end-1), ...
                   mesh.tria4.index(:,1:end-1), ...
                   hvec) ;
        
    end
    
    end
    
end

function [ad] = mad(ff)
%MAD mean absolute deviation (from the mean).

    ad = mean(abs(ff-mean(ff))) ;
    
end

function [hr] = hfunc1(pp,ee,hh)
%HFUNC1 calc. relative sizing for 1-edges.

    ev = pp(ee(:,2),:)-pp(ee(:,1),:);
    el = sqrt(sum(ev.^2,+2)); 
    eh =(hh(ee(:,2))+hh(ee(:,1)))*.5;
    
    hr = el ./ eh ;
    
end

function [hr] = hfunc2(pp,t2,hh)
%HFUNC2 calc. relative sizing for 2-trias.

    ee = [t2(:,[1,2])
          t2(:,[2,3])
          t2(:,[3,1])
         ] ;
    ee = unique(sort(ee,2),'rows');
    
    ev = pp(ee(:,2),:)-pp(ee(:,1),:);
    el = sqrt(sum(ev.^2,+2)); 
    eh =(hh(ee(:,2))+hh(ee(:,1)))*.5;
    
    hr = el ./ eh ;
    
end

function [hr] = hfunc3(pp,t3,hh)
%HFUNC3 calc. relative sizing for 3-trias.

    ee = [t3(:,[1,2])
          t3(:,[2,3])
          t3(:,[3,1])
          t3(:,[1,4])
          t3(:,[2,4])
          t3(:,[3,4])
         ] ;
    ee = unique(sort(ee,2),'rows');
    
    ev = pp(ee(:,2),:)-pp(ee(:,1),:);
    el = sqrt(sum(ev.^2,+2)); 
    eh =(hh(ee(:,2))+hh(ee(:,1)))*.5;
    
    hr = el ./ eh ;
    
end

function [nvec] = trianorm(pp,t2)
%TRIANORM calc. normal vectors for 2-trias.

    ee12 = pp(t2(:,2),:) - pp(t2(:,1),:);
    ee13 = pp(t2(:,3),:) - pp(t2(:,1),:);

    nvec = zeros(size(t2,1),3);
    nvec(:,1) = ee12(:,2).*ee13(:,3) - ...
                ee12(:,3).*ee13(:,2) ;
    nvec(:,2) = ee12(:,3).*ee13(:,1) - ...
                ee12(:,1).*ee13(:,3) ;
    nvec(:,3) = ee12(:,1).*ee13(:,2) - ...
                ee12(:,2).*ee13(:,1) ;

end

function [dcos] = angle2(pp,t2)
%ANGLE2 calc. dihedral angles for 2-trias.

    ev12 = pp(t2(:,2),:)-pp(t2(:,1),:);
    ev23 = pp(t2(:,3),:)-pp(t2(:,2),:);
    ev31 = pp(t2(:,1),:)-pp(t2(:,3),:);
   
    lv11 = sqrt(sum(ev12.^2,2));
    lv22 = sqrt(sum(ev23.^2,2));
    lv33 = sqrt(sum(ev31.^2,2));
    
    ev12 = ev12./lv11(:,ones(1,size(pp,2)));
    ev23 = ev23./lv22(:,ones(1,size(pp,2)));
    ev31 = ev31./lv33(:,ones(1,size(pp,2)));
        
    dcos = zeros(size(t2,1),3);
    dcos(:,1) = sum(-ev12.*ev23,2);
    dcos(:,2) = sum(-ev23.*ev31,2);
    dcos(:,3) = sum(-ev31.*ev12,2);
    
    dcos = acos(dcos) * 180. / pi ;
    
end

function [dcos] = angle3(pp,t3)
%ANGLE3 calc. dihedral angles for 3-trias.

    fv11 = trianorm(pp,t3(:,[1,2,3]));
    fv22 = trianorm(pp,t3(:,[1,2,4]));
    fv33 = trianorm(pp,t3(:,[2,3,4]));
    fv44 = trianorm(pp,t3(:,[3,1,4]));
    
    lv11 = sqrt(sum(fv11.^2,2));
    lv22 = sqrt(sum(fv22.^2,2));
    lv33 = sqrt(sum(fv33.^2,2));
    lv44 = sqrt(sum(fv44.^2,2));
    
    fv11 = fv11./[lv11,lv11,lv11];
    fv22 = fv22./[lv22,lv22,lv22];
    fv33 = fv33./[lv33,lv33,lv33];
    fv44 = fv44./[lv44,lv44,lv44];
    
    % across six edges
    % 11,22
    % 11,33
    % 11,44
    % 44,22 (1,4)
    % 22,33 (2,4)
    % 33,44 (3,4)
    
    dcos = zeros(size(t3,1),6);
    dcos(:,1) = sum(+fv11.*fv22,2);
    dcos(:,2) = sum(+fv11.*fv33,2);
    dcos(:,3) = sum(+fv11.*fv44,2);
    dcos(:,4) = sum(-fv44.*fv22,2);
    dcos(:,5) = sum(-fv22.*fv33,2);
    dcos(:,6) = sum(-fv33.*fv44,2);
    
    dcos = acos(dcos) * 180. / pi ;
    
end

function [vol2] = vol2(pp,t2)
%VOL2 calc. volumes for 2-trias.

    d12 = pp(t2(:,2),:)-pp(t2(:,1),:) ;
    d13 = pp(t2(:,3),:)-pp(t2(:,1),:) ;

    switch (size(pp,2))
        case +2
           
        vol2 = d12(:,1).*d13(:,2) ...
             - d12(:,2).*d13(:,1) ;
        vol2 = 0.5 * vol2;
            
        case +3
            
        avec = cross(d12,d13);
        vol2 = sqrt(sum(avec.^2,2)) ;
        vol2 = 0.5 * vol2;    
        
        otherwise
        error('VOL2: unsupported dimension.');
    end
    
end

function [vol3] = vol3(pp,t3)
%VOL3 calc. volumes for 3-trias.

    vv14 = pp(t3(:,4),:)-pp(t3(:,1),:);
    vv24 = pp(t3(:,4),:)-pp(t3(:,2),:);
    vv34 = pp(t3(:,4),:)-pp(t3(:,3),:);

    vdet = + vv14(:,1) .* ...
            (vv24(:,2).*vv34(:,3)  ...
           - vv24(:,3).*vv34(:,2)) ...
           - vv14(:,2) .* ...
            (vv24(:,1).*vv34(:,3)  ...
           - vv24(:,3).*vv34(:,1)) ...
           + vv14(:,3) .* ...
            (vv24(:,1).*vv34(:,2)  ...
           - vv24(:,2).*vv34(:,1)) ;

    vol3 = vdet / 6.0;

end

function [tscr] = score2(pp,t2)
%SCORE3 calc. volume-length scores for 2-trias.

    scal = 4.0 * sqrt(3.0) / 3.0;

    lrms = sum((pp(t2(:,2),:)        ...
              - pp(t2(:,1),:)).^2,2) ...
         + sum((pp(t2(:,3),:)        ...
              - pp(t2(:,2),:)).^2,2) ...
         + sum((pp(t2(:,3),:)        ...
              - pp(t2(:,1),:)).^2,2) ;

    lrms =(lrms / 3.0) .^ 1.00;

    tvol = vol2(pp,t2);

    tscr = scal * tvol ./ lrms;

end

function [tscr] = score3(pp,t3)
%SCORE3 calc. volume-length scores for 3-trias.

    scal = 6.0 * sqrt(2.0);

    lrms = sum((pp(t3(:,2),:)        ...
              - pp(t3(:,1),:)).^2,2) ...
         + sum((pp(t3(:,3),:)        ...
              - pp(t3(:,2),:)).^2,2) ...
         + sum((pp(t3(:,1),:)        ...
              - pp(t3(:,3),:)).^2,2) ...
         + sum((pp(t3(:,4),:)        ...
              - pp(t3(:,1),:)).^2,2) ...
         + sum((pp(t3(:,4),:)        ...
              - pp(t3(:,2),:)).^2,2) ...
         + sum((pp(t3(:,4),:)        ...
              - pp(t3(:,3),:)).^2,2) ;

    lrms =(lrms / 6.0) .^ 1.50;

    tvol = vol3(pp,t3);

    tscr = scal * tvol ./ lrms;

end


