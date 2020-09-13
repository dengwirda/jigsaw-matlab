function [mesh] = bisect(mesh)
%BISECT bisect cells in a mesh object.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   08-Aug-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if(~inspect(mesh,'point','coord') )
        return ;
    end

%------------------------------ map elements to unique edges
    hexa = [] ; quad = [] ; edge = [] ;
    hmap = [] ; qmap = [] ; emap = [] ;

    if (inspect(mesh,'edge2','index') && ...
           ~isempty(mesh.edge2.index) )
    %-------------------------- map EDGE2's onto JOIN arrays
        nedg = size(edge,1) ;
        ncel = size(mesh.edge2.index,1);

        edge = [edge;
        mesh.edge2.index(:,[1,2])
            ] ;

        emap.edge2.index =zeros(ncel,1);
        emap.edge2.index(:, 1 ) = ...
        (1:ncel)' + ncel*0 + nedg ;
    end

    if (inspect(mesh,'tria3','index') && ...
           ~isempty(mesh.tria3.index) )
    %-------------------------- map TRIA3's onto JOIN arrays
        nedg = size(edge,1) ;
        ncel = size(mesh.tria3.index,1);

        edge = [edge;
        mesh.tria3.index(:,[1,2])
        mesh.tria3.index(:,[2,3])
        mesh.tria3.index(:,[3,1])
            ] ;

        emap.tria3.index =zeros(ncel,3);
        emap.tria3.index(:, 1 ) = ...
        (1:ncel)' + ncel*0 + nedg ;
        emap.tria3.index(:, 2 ) = ...
        (1:ncel)' + ncel*1 + nedg ;
        emap.tria3.index(:, 3 ) = ...
        (1:ncel)' + ncel*2 + nedg ;
    end

    if (inspect(mesh,'quad4','index') && ...
           ~isempty(mesh.quad4.index) )
    %-------------------------- map QUAD4's onto JOIN arrays
        nedg = size(edge,1) ;
        nfac = size(quad,1) ;
        ncel = size(mesh.quad4.index,1);

        quad = [quad;
        mesh.quad4.index(:, 1:4 )
            ] ;

        edge = [edge;
        mesh.quad4.index(:,[1,2])
        mesh.quad4.index(:,[2,3])
        mesh.quad4.index(:,[3,4])
        mesh.quad4.index(:,[4,1])
            ] ;

        qmap.quad4.index =zeros(ncel,1);
        qmap.quad4.index(:, 1 ) = ...
        (1:ncel)' + ncel*0 + nfac ;

        emap.quad4.index =zeros(ncel,4);
        emap.quad4.index(:, 1 ) = ...
        (1:ncel)' + ncel*0 + nedg ;
        emap.quad4.index(:, 2 ) = ...
        (1:ncel)' + ncel*1 + nedg ;
        emap.quad4.index(:, 3 ) = ...
        (1:ncel)' + ncel*2 + nedg ;
        emap.quad4.index(:, 4 ) = ...
        (1:ncel)' + ncel*3 + nedg ;
    end

    if (inspect(mesh,'tria4','index') && ...
           ~isempty(mesh.tria4.index) )
    %-------------------------- map TRIA4's onto JOIN arrays
        nedg = size(edge,1) ;
        ncel = size(mesh.tria4.index,1);

        edge = [edge;
        mesh.tria4.index(:,[1,2])
        mesh.tria4.index(:,[2,3])
        mesh.tria4.index(:,[3,1])
        mesh.tria4.index(:,[1,4])
        mesh.tria4.index(:,[2,4])
        mesh.tria4.index(:,[3,4])
            ] ;

        emap.tria4.index =zeros(ncel,6);
        emap.tria4.index(:, 1 ) = ...
        (1:ncel)' + ncel*0 + nedg ;
        emap.tria4.index(:, 2 ) = ...
        (1:ncel)' + ncel*1 + nedg ;
        emap.tria4.index(:, 3 ) = ...
        (1:ncel)' + ncel*2 + nedg ;
        emap.tria4.index(:, 4 ) = ...
        (1:ncel)' + ncel*3 + nedg ;
        emap.tria4.index(:, 5 ) = ...
        (1:ncel)' + ncel*4 + nedg ;
        emap.tria4.index(:, 6 ) = ...
        (1:ncel)' + ncel*5 + nedg ;
    end

    if (inspect(mesh,'hexa8','index') && ...
           ~isempty(mesh.hexa8.index) )
    %-------------------------- map HEXA8's onto JOIN arrays
        warning( ...
        'HEXA-8 currently unsupported');
    end

    if (inspect(mesh,'wedg6','index') && ...
           ~isempty(mesh.wedg6.index) )
    %-------------------------- map WEDG6's onto JOIN arrays
        warning( ...
        'WEDG-6 currently unsupported');
    end

    if (inspect(mesh,'pyra5','index') && ...
           ~isempty(mesh.pyra5.index) )
    %-------------------------- map PYRA5's onto JOIN arrays
        warning( ...
        'PYRA-5 currently unsupported');
    end

%------------------------------ unique joins and re-indexing
   [ ~ , efwd, erev] = ...
        unique(sort(edge, 2), 'rows');
   [ ~ , qfwd, qrev] = ...
        unique(sort(quad, 2), 'rows');
   [ ~ , hfwd, hrev] = ...
        unique(sort(hexa, 2), 'rows');

    edge = edge(efwd,:) ;
    quad = quad(qfwd,:) ;
    hexa = hexa(hfwd,:) ;

%------------------------------ map unique joins to elements
    if (inspect(mesh,'edge2','index'))
        emap.edge2.index(:,1) = erev( ...
        emap.edge2.index(:,1)) ;
    end

    if (inspect(mesh,'tria3','index'))
        emap.tria3.index(:,1) = erev( ...
        emap.tria3.index(:,1)) ;
        emap.tria3.index(:,2) = erev( ...
        emap.tria3.index(:,2)) ;
        emap.tria3.index(:,3) = erev( ...
        emap.tria3.index(:,3)) ;
    end

    if (inspect(mesh,'quad4','index'))
        qmap.quad4.index(:,1) = qrev( ...
        qmap.quad4.index(:,1)) ;

        emap.quad4.index(:,1) = erev( ...
        emap.quad4.index(:,1)) ;
        emap.quad4.index(:,2) = erev( ...
        emap.quad4.index(:,2)) ;
        emap.quad4.index(:,3) = erev( ...
        emap.quad4.index(:,3)) ;
        emap.quad4.index(:,4) = erev( ...
        emap.quad4.index(:,4)) ;
    end

    if (inspect(mesh,'tria4','index'))
        emap.tria4.index(:,1) = erev( ...
        emap.tria4.index(:,1)) ;
        emap.tria4.index(:,2) = erev( ...
        emap.tria4.index(:,2)) ;
        emap.tria4.index(:,3) = erev( ...
        emap.tria4.index(:,3)) ;
        emap.tria4.index(:,4) = erev( ...
        emap.tria4.index(:,4)) ;
        emap.tria4.index(:,5) = erev( ...
        emap.tria4.index(:,5)) ;
        emap.tria4.index(:,6) = erev( ...
        emap.tria4.index(:,6)) ;
    end

%------------------------------ create new midpoint vertices
    enew = [] ; qnew = [] ; hnew = [] ;

    if (~isempty(edge))
    emid = mesh.point.coord(edge(:,1),:) ...
         + mesh.point.coord(edge(:,2),:) ;
    emid = emid / +2. ;

    enew = [(1:size(emid,1))' + ...
        size(mesh.point.coord,1)] ;

    mesh.point.coord = [
        mesh.point.coord ; emid ] ;
    end

    if (~isempty(quad))
    qmid = mesh.point.coord(quad(:,1),:) ...
         + mesh.point.coord(quad(:,2),:) ...
         + mesh.point.coord(quad(:,3),:) ...
         + mesh.point.coord(quad(:,4),:) ;
    qmid = qmid / +4. ;

    qnew = [(1:size(qmid,1))' + ...
        size(mesh.point.coord,1)] ;

    mesh.point.coord = [
        mesh.point.coord ; qmid ] ;
    end

    if (~isempty(hexa))
    hmid = mesh.point.coord(hexa(:,1),:) ...
         + mesh.point.coord(hexa(:,2),:) ...
         + mesh.point.coord(hexa(:,3),:) ...
         + mesh.point.coord(hexa(:,4),:) ...
         + mesh.point.coord(hexa(:,5),:) ...
         + mesh.point.coord(hexa(:,6),:) ...
         + mesh.point.coord(hexa(:,7),:) ...
         + mesh.point.coord(hexa(:,8),:) ;
    hmid = hmid / +8. ;

    hnew = [(1:size(hmid,1))' + ...
        size(mesh.point.coord,1)] ;

    mesh.point.coord = [
        mesh.point.coord ; hmid ] ;
    end

    if (inspect(mesh,'edge2','index'))
%------------------------------ create new indexes for EDGE2
        mesh.edge2.index = [
        % 1st sub-edge
             mesh.edge2.index(:,1) , ...
        enew(emap.edge2.index(:,1)), ...
             mesh.edge2.index(:,3)
        % 2nd sub-edge
        enew(emap.edge2.index(:,1)), ...
             mesh.edge2.index(:,2) , ...
             mesh.edge2.index(:,3)
            ] ;
    end

    if (inspect(mesh,'tria3','index'))
%------------------------------ create new indexes for TRIA3
        mesh.tria3.index = [
        % 1st sub-tria
             mesh.tria3.index(:,1) , ...
        enew(emap.tria3.index(:,1)), ...
        enew(emap.tria3.index(:,3)), ...
             mesh.tria3.index(:,4)
        % 2nd sub-tria
             mesh.tria3.index(:,2) , ...
        enew(emap.tria3.index(:,2)), ...
        enew(emap.tria3.index(:,1)), ...
             mesh.tria3.index(:,4)
        % 3rd sub-tria
             mesh.tria3.index(:,3) , ...
        enew(emap.tria3.index(:,3)), ...
        enew(emap.tria3.index(:,2)), ...
             mesh.tria3.index(:,4)
        % 4th sub-tria
        enew(emap.tria3.index(:,1)), ...
        enew(emap.tria3.index(:,2)), ...
        enew(emap.tria3.index(:,3)), ...
             mesh.tria3.index(:,4)
            ] ;
    end

    if (inspect(mesh,'quad4','index'))
%------------------------------ create new indexes for QUAD4
        mesh.quad4.index = [
        % 1st sub-quad
             mesh.quad4.index(:,1) , ...
        enew(emap.quad4.index(:,1)), ...
        qnew(qmap.quad4.index(:,1)), ...
        enew(emap.quad4.index(:,4)), ...
             mesh.quad4.index(:,5)
        % 2nd sub-quad
             mesh.quad4.index(:,2) , ...
        enew(emap.quad4.index(:,2)), ...
        qnew(qmap.quad4.index(:,1)), ...
        enew(emap.quad4.index(:,1)), ...
             mesh.quad4.index(:,5)
        % 3rd sub-quad
             mesh.quad4.index(:,3) , ...
        enew(emap.quad4.index(:,3)), ...
        qnew(qmap.quad4.index(:,1)), ...
        enew(emap.quad4.index(:,2)), ...
             mesh.quad4.index(:,5)
        % 4th sub-quad
             mesh.quad4.index(:,4) , ...
        enew(emap.quad4.index(:,4)), ...
        qnew(qmap.quad4.index(:,1)), ...
        enew(emap.quad4.index(:,3)), ...
             mesh.quad4.index(:,5)
            ] ;
    end

    if (inspect(mesh,'tria4','index'))
%------------------------------ create new indexes for TRIA4

        % 1st subdiv. of octahedron
        triaA = [
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,2)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaB = [
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,6)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaC = [
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,6)), ...
        enew(emap.tria4.index(:,4)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaD = [
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,1)), ...
             mesh.tria4.index(:,5)
            ] ;

        costA = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaA(:,1:4) ) ;
        costB = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaB(:,1:4) ) ;
        costC = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaC(:,1:4) ) ;
        costD = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaD(:,1:4) ) ;

        % 2nd subdiv. of octahedron
        triaE = [
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,6)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,2)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaF = [
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,6)), ...
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,3)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaG = [
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,6)), ...
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,4)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaH = [
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,6)), ...
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,5)), ...
             mesh.tria4.index(:,5)
            ] ;

        costE = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaE(:,1:4) ) ;
        costF = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaF(:,1:4) ) ;
        costG = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaG(:,1:4) ) ;
        costH = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaH(:,1:4) ) ;

        % 3rd subdiv. of octahedron
        triaI = [
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,5)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaJ = [
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,6)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaK = [
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,6)), ...
        enew(emap.tria4.index(:,3)), ...
             mesh.tria4.index(:,5)
            ] ;
        triaL = [
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,1)), ...
             mesh.tria4.index(:,5)
            ] ;

        costI = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaI(:,1:4) ) ;
        costJ = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaJ(:,1:4) ) ;
        costK = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaK(:,1:4) ) ;
        costL = triscr3( ...
            mesh.point.coord(:,1:3), ...
            triaL(:,1:4) ) ;

        cost1 = ...
       [costA, costB, costC, costD];
        cost2 = ...
       [costE, costF, costG, costH];
        cost3 = ...
       [costI, costJ, costK, costL];

        cost1 = min (cost1, [], 2) ;
        cost2 = min (cost2, [], 2) ;
        cost3 = min (cost3, [], 2) ;

       [~,index] = sort( ...
            [cost1,cost2,cost3], +2) ;

        mesh.tria4.index = [
        % 1st sub-tria
             mesh.tria4.index(:,1) , ...
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,4)), ...
             mesh.tria4.index(:,5)
        % 2nd sub-tria
             mesh.tria4.index(:,2) , ...
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,1)), ...
        enew(emap.tria4.index(:,5)), ...
             mesh.tria4.index(:,5)
        % 3rd sub-tria
             mesh.tria4.index(:,3) , ...
        enew(emap.tria4.index(:,3)), ...
        enew(emap.tria4.index(:,2)), ...
        enew(emap.tria4.index(:,6)), ...
             mesh.tria4.index(:,5)
        % 4th sub-tria
        enew(emap.tria4.index(:,4)), ...
        enew(emap.tria4.index(:,5)), ...
        enew(emap.tria4.index(:,6)), ...
             mesh.tria4.index(:,4) , ...
             mesh.tria4.index(:,5)
        % 1st subdiv. of octahedron
             triaA(index(:,3)==1,:)
             triaB(index(:,3)==1,:)
             triaC(index(:,3)==1,:)
             triaD(index(:,3)==1,:)
        % 2nd subdiv. of octahedron
             triaE(index(:,3)==2,:)
             triaF(index(:,3)==2,:)
             triaG(index(:,3)==2,:)
             triaH(index(:,3)==2,:)
        % 3rd subdiv. of octahedron
             triaI(index(:,3)==3,:)
             triaJ(index(:,3)==3,:)
             triaK(index(:,3)==3,:)
             triaL(index(:,3)==3,:)
            ] ;
    end

end



