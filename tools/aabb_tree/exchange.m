function [qp,qx] = exchange(pp,px)
%EXCHANGE change the "associativity" of a sparse list set.
%   [QP,QX] = EXCHANGE(PP,PX) returns a new set of sparse
%   lists {QP,QX} as the "transpose" of the input collection
%   {PP,PX}. This operation can be used to form the inverse
%   associations between two collections of objects. For
%   example, given two collections A and B, if the input set
%   {PP,PI} represents the indexing of A-into-B, the new set
%   {QP,QI} represents the indexing of B-into-A.
%   List sets are defined via a "compressed sparse" format,
%   with the II-th list in a given collection {XP,XX} stored
%   as XX(XP(II,1):XP(II,2)).
%
%   See also QUERYSET

%   Darren Engwirda : 2020 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 05/06/2020

%---------------------------------------------- basic checks
    if ( ~isnumeric(pp) || ~isnumeric(px))
        error('exchange:incorrectInputClass', ...
            'Incorrect input class.') ;
    end

    if (size(pp,2) ~= 2 || size(px,2) ~= 1 )
        error('exchange:incorrectDimensions', ...
            'Incorrect input dimensions.') ;
    end

    if (min(px(:)) <= 0 || ...
            max(pp(:)) > length(px) )
        error('exchange:invalidListIndexing', ...
            'Invalid list indexing.') ;
    end

%----------------------------------- compute list "tranpose"

    qp = zeros(max(px),2);
    qx = zeros(length(px),1);

    for ip = 1:length(pp)          % accumulate column count
        for ii = pp(ip,1):pp(ip,2)
            qp(px(ii),2) = qp(px(ii),2) + 1;
        end
    end

    Z  = qp(:,2) == +0 ;           % deal with "empty" lists

    qp(:,2) = cumsum(qp(:,2));
    qp(:,1) = [+1;qp(1:end-1,2)+1];

    for ip = 1:length(pp)          % tranpose of items array
        for ii = pp(ip,1):pp(ip,2)
            qx(qp(px(ii),1)) = ip;
            qp(px(ii),1) = qp(px(ii),1) + 1;
        end
    end

    qp(:,1) = [+1;qp(1:end-1,2)+1];

    qp(Z,1) = +0;                  % deal with "empty" lists
    qp(Z,2) = -1;

end


