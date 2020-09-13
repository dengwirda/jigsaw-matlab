function [bb] = quadbal2(pp,pw,qq)
%QUADBAL...

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 02/05/2018


%   blah, checks


    b1 = tribal2(pp,qq(:,[1,2,3]));
    b2 = tribal2(pp,qq(:,[1,3,4]));
    b3 = tribal2(pp,qq(:,[1,2,4]));
    b4 = tribal2(pp,qq(:,[2,3,4]));

    bb = .25*(b1+b2+b3+b4);
    return

    switch (size(pp,2))
        case +2
    %-------------------------------------------- alloc work
        AA = zeros(2,2,size(tt,1)) ;
        Rv = zeros(2,1,size(tt,1)) ;
        bb = zeros(size(tt,1),3,1) ;

    %-------------------------------------------- lhs matrix
        ab = pp(tt(:,2),:)-pp(tt(:,1),:);
        ac = pp(tt(:,3),:)-pp(tt(:,1),:);

        AA(1,1,:) = ab(:,1) * +2.0 ;
        AA(1,2,:) = ab(:,2) * +2.0 ;
        AA(2,1,:) = ac(:,1) * +2.0 ;
        AA(2,2,:) = ac(:,2) * +2.0 ;

    %-------------------------------------------- rhs vector
        Rv(1,1,:) = sum(ab.*ab,2) ...
        - ( pw(tt(:,2)) - pw(tt(:,1)) ) ;

        Rv(2,1,:) = sum(ac.*ac,2) ...
        - ( pw(tt(:,3)) - pw(tt(:,1)) ) ;

    %-------------------------------------------- solve sys.
       [II,dd] = inv_2x2(AA) ;

        bb(:,1) = ( ...
            II(1,1,:).*Rv(1,1,:) + ...
            II(1,2,:).*Rv(2,1,:) ) ...
            ./ dd ;

        bb(:,2) = ( ...
            II(2,1,:).*Rv(1,1,:) + ...
            II(2,2,:).*Rv(2,1,:) ) ...
            ./ dd ;

        bb(:,1:2) = ...
            pp(tt(:,1),:) + bb(:,1:2) ;

    %-------------------------------------------- mean radii
        r1 = sum( ...
        (bb(:,1:2)-pp(tt(:,1),:)).^2,2) ;
        r2 = sum( ...
        (bb(:,1:2)-pp(tt(:,2),:)).^2,2) ;
        r3 = sum( ...
        (bb(:,1:2)-pp(tt(:,3),:)).^2,2) ;

        r1 = r1 - pw(tt(:,1));
        r2 = r2 - pw(tt(:,2));
        r3 = r3 - pw(tt(:,3));

        bb(:,3) = ( r1+r2+r3 ) / +3.0 ;

        case +3
    %-------------------------------------------- alloc work
        AA = zeros(3,3,size(qq,1)) ;
        Rv = zeros(3,1,size(qq,1)) ;
        bb = zeros(size(qq,1),4,1) ;

    %-------------------------------------------- lhs matrix
        ab = pp(qq(:,2),:)-pp(qq(:,1),:);
        ac = pp(qq(:,3),:)-pp(qq(:,1),:);
        ad = pp(qq(:,4),:)-pp(qq(:,1),:);
        
        bc = pp(qq(:,3),:)-pp(qq(:,2),:);
        bd = pp(qq(:,4),:)-pp(qq(:,2),:);

        n1 = cross(ab,ac) ;
        n2 = cross(ac,ad) ;
        n3 = cross(ab,bd) ;
        n4 = cross(bd,bc) ;
        
        absq = sum(ab.*ab,2);
        acsq = sum(ac.*ac,2);
        adsq = sum(ad.*ad,2);
        
        for ii = 1:size(qq,1)
        
        As(1,1) = ab(ii,1) * +2.0 ;
        As(1,2) = ab(ii,2) * +2.0 ;
        As(1,3) = ab(ii,3) * +2.0 ;
        As(2,1) = ac(ii,1) * +2.0 ;
        As(2,2) = ac(ii,2) * +2.0 ;
        As(2,3) = ac(ii,3) * +2.0 ;
        As(3,1) = ad(ii,1) * +2.0 ;
        As(3,2) = ad(ii,2) * +2.0 ;
        As(3,3) = ad(ii,3) * +2.0 ;

        As(4,1) = n1(ii,1) * +1.0 ;
        As(4,2) = n1(ii,2) * +1.0 ;
        As(4,3) = n1(ii,3) * +1.0 ;
        As(5,1) = n2(ii,1) * +1.0 ;
        As(5,2) = n2(ii,2) * +1.0 ;
        As(5,3) = n2(ii,3) * +1.0 ;
        
        As(6,1) = n3(ii,1) * +1.0 ;
        As(6,2) = n3(ii,2) * +1.0 ;
        As(6,3) = n3(ii,3) * +1.0 ;
        As(7,1) = n4(ii,1) * +1.0 ;
        As(7,2) = n4(ii,2) * +1.0 ;
        As(7,3) = n4(ii,3) * +1.0 ;

    %-------------------------------------------- rhs vector
        Rs(1,1) = absq(ii,:) ...
        - ( pw(qq(ii,2)) - pw(qq(ii,1)) ) ;

        Rs(2,1) = acsq(ii,:) ...
        - ( pw(qq(ii,3)) - pw(qq(ii,1)) ) ;
    
        Rs(3,1) = adsq(ii,:) ...
        - ( pw(qq(ii,4)) - pw(qq(ii,1)) ) ;

        Rs(4:7,1) = 0.0 ;
    
        AA(1:3,:,ii) = As' * As ;
        Rv(1:3,1,ii) = As' * Rs ; 
    
        end
    
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
            pp(qq(:,1),:) + bb(:,1:3) ;

    %-------------------------------------------- mean radii
        r1 = sum( ...
        (bb(:,1:3)-pp(qq(:,1),:)).^2,2) ;
        r2 = sum( ...
        (bb(:,1:3)-pp(qq(:,2),:)).^2,2) ;
        r3 = sum( ...
        (bb(:,1:3)-pp(qq(:,3),:)).^2,2) ;
        r4 = sum( ...
        (bb(:,1:3)-pp(qq(:,4),:)).^2,2) ;

        r1 = r1 - pw(qq(:,1));
        r2 = r2 - pw(qq(:,2));
        r3 = r3 - pw(qq(:,3));
        r4 = r4 - pw(qq(:,4));

        bb(:,4) = ( r1+r2+r3+r4 ) / +4. ;

    otherwise

    error('pwrbal2:unsupportedDimension' , ...
            'Dimension not supported.') ;

    end

end



