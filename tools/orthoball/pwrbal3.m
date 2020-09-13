function [bb] = pwrbal3(pp,pw,tt)
%PWRBAL3 compute the ortho-balls associated with a 3-simplex
%triangulation embedded in R^3.
%   [BB] = PWRBAL3(PP,PW,TT) returns the set of power balls
%   associated with the triangles in [PP,TT], such that BB =
%   [XC,YC,ZC,RC.^2]. PW is a vector of vertex weights.

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 20/06/2018

%---------------------------------------------- basic checks
    if ( ~isnumeric(pp) || ...
         ~isnumeric(pw) || ...
         ~isnumeric(tt) )
        error('pwrbal3:incorrectInputClass' , ...
            'Incorrect input class.');
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ...
        ndims(pw) ~= +2 || ...
        ndims(tt) ~= +2 )
        error('pwrbal3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    if (size(pp,2) < +3 || ...
            size(pp,1)~= size(pw,1) || ...
                size(tt,2) < +4 )
        error('pwrbal3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    switch (size(pp,2))
        case +3
    %-------------------------------------------- alloc work
        AA = zeros(3,3,size(tt,1)) ;
        Rv = zeros(3,1,size(tt,1)) ;
        bb = zeros(size(tt,1),4,1) ;

    %-------------------------------------------- lhs matrix
        ab = pp(tt(:,2),:)-pp(tt(:,1),:);
        ac = pp(tt(:,3),:)-pp(tt(:,1),:);
        ad = pp(tt(:,4),:)-pp(tt(:,1),:);

        AA(1,1,:) = ab(:,1) * +2.0 ;
        AA(1,2,:) = ab(:,2) * +2.0 ;
        AA(1,3,:) = ab(:,3) * +2.0 ;

        AA(2,1,:) = ac(:,1) * +2.0 ;
        AA(2,2,:) = ac(:,2) * +2.0 ;
        AA(2,3,:) = ac(:,3) * +2.0 ;

        AA(3,1,:) = ad(:,1) * +2.0 ;
        AA(3,2,:) = ad(:,2) * +2.0 ;
        AA(3,3,:) = ad(:,3) * +2.0 ;

    %-------------------------------------------- rhs vector
        Rv(1,1,:) = sum(ab.*ab,2) ...
        - ( pw(tt(:,2)) - pw(tt(:,1)) ) ;

        Rv(2,1,:) = sum(ac.*ac,2) ...
        - ( pw(tt(:,3)) - pw(tt(:,1)) ) ;

        Rv(3,1,:) = sum(ad.*ad,2) ...
        - ( pw(tt(:,4)) - pw(tt(:,1)) ) ;

    %-------------------------------------------- solve sys.
       [II,dd] = inv_3x3(AA) ;

        bb(:,1) = ( ...
            II(1,1,:).*Rv(1,1,:) + ...
            II(1,2,:).*Rv(2,1,:) + ...
            II(1,3,:).*Rv(3,1,:) ) ...
            ./ dd ;

        bb(:,2) = ( ...
            II(2,1,:).*Rv(1,1,:) + ...
            II(2,2,:).*Rv(2,1,:) + ...
            II(2,3,:).*Rv(3,1,:) ) ...
            ./ dd ;

        bb(:,3) = ( ...
            II(3,1,:).*Rv(1,1,:) + ...
            II(3,2,:).*Rv(2,1,:) + ...
            II(3,3,:).*Rv(3,1,:) ) ...
            ./ dd ;

        bb(:,1:3) = ...
            pp(tt(:,1),:) + bb(:,1:3) ;

    %-------------------------------------------- mean radii
        r1 = sum( ...
        (bb(:,1:3)-pp(tt(:,1),:)).^2,2) ;
        r2 = sum( ...
        (bb(:,1:3)-pp(tt(:,2),:)).^2,2) ;
        r3 = sum( ...
        (bb(:,1:3)-pp(tt(:,3),:)).^2,2) ;
        r4 = sum( ...
        (bb(:,1:3)-pp(tt(:,4),:)).^2,2) ;

        r1 = r1 - pw(tt(:,1));
        r2 = r2 - pw(tt(:,2));
        r3 = r3 - pw(tt(:,3));
        r4 = r4 - pw(tt(:,4));

        bb(:,4) = ( r1+r2+r3+r4 ) / +4. ;


    otherwise

    error('pwrbal3:unsupportedDimension' , ...
            'Dimension not supported.') ;

    end

end



