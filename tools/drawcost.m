function drawcost(varargin)
%DRAWCOST draw JIGSAW cost data.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   01-Aug-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    cost = meshcost(varargin{:}) ;

%-- draw sub-axes directly -- sub-plot gives
%-- silly inconsistent ax spacing...!

    axpos = cell(4,4);
    axpos{2,1} = [.125,.600,.800,.275] ;
    axpos{2,2} = [.125,.150,.800,.275] ;

    axpos{3,1} = [.125,.750,.800,.150] ;
    axpos{3,2} = [.125,.450,.800,.150] ;
    axpos{3,3} = [.125,.150,.800,.150] ;

    axpos{4,1} = [.125,.835,.800,.125] ;
    axpos{4,2} = [.125,.590,.800,.125] ;
    axpos{4,3} = [.125,.345,.800,.125] ;
    axpos{4,4} = [.125,.100,.800,.125] ;

%-- draw cost histograms for 2-tria elements
    if (isfield(cost,'tria3'))

    figure;
    set(gcf,'color','w','units','normalized', ...
        'position',[.05,.10,.30,.30]);

    ipos = 2 ; jpos = 1 ;
    if (isfield(cost.tria3,'score_d'))
        ipos = ipos + 1 ;
    end
    if (isfield(cost.tria3,'scale_t'))
        ipos = ipos + 1 ;
    end

    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    scrhist(cost.tria3.score_t,'tria3');
    if (isfield(cost.tria3,'score_d'))
    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    scrhist(cost.tria3.score_d,'dual3');
    end
    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    anghist(cost.tria3.angle_t,'tria3');
    if (isfield(cost.tria3,'scale_t'))
    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    hfnhist(cost.tria3.scale_t,'tria3');
    end

    end

%-- draw cost histograms for 3-tria elements
    if (isfield(cost,'tria4'))

    figure;
    set(gcf,'color','w','units','normalized', ...
        'position',[.05,.10,.30,.30]);

    ipos = 2 ; jpos = 1 ;
    if (isfield(cost.tria4,'score_d'))
        ipos = ipos + 1 ;
    end
    if (isfield(cost.tria4,'scale_t'))
        ipos = ipos + 1 ;
    end

    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    scrhist(cost.tria4.score_t,'tria4');
    if (isfield(cost.tria4,'score_d'))
    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    scrhist(cost.tria4.score_d,'dual4');
    end
    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    anghist(cost.tria4.angle_t,'tria4');
    if (isfield(cost.tria4,'scale_t'))
    axes('position',axpos{ipos,jpos});
    jpos = jpos+1 ; hold on ;
    hfnhist(cost.tria4.scale_t,'tria4');
    end

    end

end

function [mf] = mad(ff)
%MAD return mean absolute deviation (from the mean).

    mf = mean(abs(ff-mean(ff))) ;

end

function deghist(dd,ty)
%DEGHIST draw histogram for "degree" quality-metric.

    dd = cast(dd(:),'double');
    be = 1:max(dd);
    hc = histc(dd,be);

    r = [.85,.00,.00] ; y = [1.0,.95,.00] ;
    g = [.00,.90,.00] ; k = [.60,.60,.60] ;

    bar(be,hc,1.05,'facecolor',k,'edgecolor',k);

    axis tight;
    set(gca,'ycolor', get(gca,'color'),'ytick',[],...
        'xtick',2:2:12,'layer','top','fontsize',...
            14,'linewidth',2.,'ticklength',[.025,.025],...
                'box','off','xlim',[0,12]);

    switch (ty)
    case 'tria4'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-.225,0,'$|d|_{\tau}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-.225,0, '|d|_{\tau}' ,...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    case 'tria3'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-.225,0,'$|d|_{f}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-.225,0, '|d|_{\tau}' ,...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    end

end

function anghist(ad,ty)
%ANGHIST draw histogram for "angle" quality-metric.

    ad = cast(ad(:),'double');
    be = linspace(0.,180.,91);
    bm =(be(1:end-1)+be(2:end))/2.;
    hc = histc(ad,be);

    switch (ty)
    case 'tria4'
        poor = bm <  10.  | bm >= 160. ;
        okay =(bm >= 10.  & bm <  20. )| ...
              (bm >= 140. & bm <  160.);
        good =(bm >= 20.  & bm <  30. )| ...
              (bm >= 120. & bm <  140.);
        best = bm >= 30.  & bm <  120. ;

    case 'tria3'
        poor = bm <  15.  | bm >= 150. ;
        okay =(bm >= 15.  & bm <  30. )| ...
              (bm >= 120. & bm <  150.);
        good =(bm >= 30.  & bm <  45. )| ...
              (bm >= 90.  & bm <  120.);
        best = bm >= 45.  & bm <  90.  ;

    end

    r = [.85,.00,.00] ; y = [1.0,.95,.00] ;
    g = [.00,.90,.00] ; k = [.60,.60,.60] ;

    bar(bm(poor),hc(poor),1.05,...
        'facecolor',r,'edgecolor',r) ;
    bar(bm(okay),hc(okay),1.05,...
        'facecolor',y,'edgecolor',y) ;
    bar(bm(good),hc(good),1.05,...
        'facecolor',g,'edgecolor',g) ;
    bar(bm(best),hc(best),1.05,...
        'facecolor',k,'edgecolor',k) ;

    axis tight;
    set(gca,'ycolor', get(gca,'color'),'ytick',[],...
        'xtick',0:30:180,'layer','top','fontsize',...
            14,'linewidth',2.,'ticklength',[.025,.025],...
                'box','off','xlim',[0.,180.]) ;

    mina = max(1.000,min(ad)); %%!! so that axes don't obscure!
    maxa = min(179.0,max(ad));

    bara = mean(ad(:));
    mada = mad (ad(:));

    line([ mina, mina],...
        [0,max(hc)],'color','r','linewidth',1.5);
    line([ maxa, maxa],...
        [0,max(hc)],'color','r','linewidth',1.5);

    if ( mina > 25.0)
        text(mina-1.8,.90*max(hc),num2str(min(ad),'%16.1f'),...
            'horizontalalignment',...
                'right','fontsize',15) ;
    else
        text(mina+1.8,.90*max(hc),num2str(min(ad),'%16.1f'),...
            'horizontalalignment',...
                'left' ,'fontsize',15) ;
    end

    if ( maxa < 140.)
        text(maxa+1.8,.90*max(hc),num2str(max(ad),'%16.1f'),...
            'horizontalalignment',...
                'left' ,'fontsize',15) ;
    else
        text(maxa-1.8,.90*max(hc),num2str(max(ad),'%16.1f'),...
            'horizontalalignment',...
                'right','fontsize',15) ;
    end

    if ( maxa < 100.)

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(maxa-16.,.45*max(hc),...
        '$\bar{\sigma}_{\theta}\!= $',...
            'horizontalalignment', 'left',...
                'fontsize',16,'interpreter','latex') ;

        text(maxa+1.8,.45*max(hc),num2str(mad(ad),'%16.2f'),...
            'horizontalalignment',...
                'left' ,'fontsize',15) ;
    end

    else

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(maxa-16.,.45*max(hc),...
        '$\bar{\sigma}_{\theta}\!= $',...
            'horizontalalignment', 'left',...
                'fontsize',16,'interpreter','latex') ;

        text(maxa+1.8,.45*max(hc),num2str(mad(ad),'%16.3f'),...
            'horizontalalignment',...
                'left' ,'fontsize',15) ;
    end

    end

    switch (ty)
    case 'tria4'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-9.0,0.0,'$\theta_{\tau}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-9.0,0.0, '\theta_{\tau}' ,...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    case 'tria3'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-9.0,0.0,'$\theta_{f}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-9.0,0.0, '\theta_{f}' ,...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    end

end

function scrhist(sc,ty)
%SCRHIST draw histogram for "score" quality-metric.

    sc = cast(sc(:),'double');
    be = linspace(0.,1.,101);
    bm = (be(1:end-1)+be(2:end)) / 2.;
    hc = histc(sc,be);

    switch (ty)
    case{'tria4','dual4'}
        poor = bm <  .25 ;
        okay = bm >= .25 & bm <  .50 ;
        good = bm >= .50 & bm <  .75 ;
        best = bm >= .75 ;

    case{'tria3','dual3'}
        poor = bm <  .30 ;
        okay = bm >= .30 & bm <  .60 ;
        good = bm >= .60 & bm <  .90 ;
        best = bm >= .90 ;

    end

    r = [.85,.00,.00] ; y = [1.0,.95,.00] ;
    g = [.00,.90,.00] ; k = [.60,.60,.60] ;

    bar(bm(poor),hc(poor),1.05,...
        'facecolor',r,'edgecolor',r) ;
    bar(bm(okay),hc(okay),1.05,...
        'facecolor',y,'edgecolor',y) ;
    bar(bm(good),hc(good),1.05,...
        'facecolor',g,'edgecolor',g) ;
    bar(bm(best),hc(best),1.05,...
        'facecolor',k,'edgecolor',k) ;

    axis tight;
    set(gca,'ycolor', get(gca,'color'),'ytick',[],...
        'xtick',.0:.2:1.,'layer','top','fontsize',...
            14,'linewidth',2.,'ticklength',[.025,.025],...
                'box','off','xlim',[0.,1.]) ;

    mins = max(0.010,min(sc)); %%!! so that axes don't obscure!
    maxs = min(0.990,max(sc));

    line([ mins, mins],...
        [0,max(hc)],'color','r','linewidth',1.5);
    line([mean(sc),mean(sc)],...
        [0,max(hc)],'color','r','linewidth',1.5);

    if ( mins > .4)
        text(mins-.01,.9*max(hc),num2str(min(sc),'%16.3f'),...
            'horizontalalignment',...
                'right','fontsize',15) ;
    else
        text(mins+.01,.9*max(hc),num2str(min(sc),'%16.3f'),...
            'horizontalalignment',...
                'left' ,'fontsize',15) ;
    end

    if ( mean(sc) > mins + .150)
    text(mean(sc)-.01,.9*max(hc),num2str(mean(sc),'%16.3f'),...
        'horizontalalignment','right','fontsize',15) ;
    end

    switch (ty)
    case 'tria4'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-.04,0.0, ...
        '$\mathcal{Q}^{\mathcal{T}}_{\tau}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-.04,0.0,'Q^{t}_{\tau}',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    case 'tria3'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-.04,0.0, ...
        '$\mathcal{Q}^{\mathcal{T}}_{f}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-.04,0.0,'Q^{t}_{f}',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    case 'dual4'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-.04,0.0, ...
        '$\mathcal{Q}^{\mathcal{D}}_{\tau}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-.04,0.0,'Q^{d}_{\tau}',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    case 'dual3'

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )
        text(-.04,0.0, ...
        '$\mathcal{Q}^{\mathcal{D}}_{f}$',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter','latex') ;
    else
        text(-.04,0.0,'Q^{d}_{f}',...
            'horizontalalignment','right',...
                'fontsize',22,'interpreter',  'tex') ;
    end

    end

end

function hfnhist(hf,ty)
%HFNHIST draw histogram for "hfunc" quality-metric.

    hf = cast(hf(:),'double');
    be = linspace(0.,2.,101);
    bm = (be(1:end-1)+be(2:end)) / 2.;
    hc = histc(hf,be);

    poor = bm <  .40 | bm >= 1.6  ;
    okay =(bm >= .40 & bm <  .60 )| ...
          (bm >= 1.4 & bm <  1.6 );
    good =(bm >= .60 & bm <  .80 )| ...
          (bm >= 1.2 & bm <  1.4 );
    best = bm >= .80 & bm <  1.2 ;

    r = [.85,.00,.00] ; y = [1.0,.95,.00] ;
    g = [.00,.90,.00] ; k = [.60,.60,.60] ;

    bar(bm(poor),hc(poor),1.05,...
        'facecolor',r,'edgecolor',r) ;
    bar(bm(okay),hc(okay),1.05,...
        'facecolor',y,'edgecolor',y) ;
    bar(bm(good),hc(good),1.05,...
        'facecolor',g,'edgecolor',g) ;
    bar(bm(best),hc(best),1.05,...
        'facecolor',k,'edgecolor',k) ;

    axis tight;
    set(gca,'ycolor', get(gca,'color'),'ytick',[],...
        'xtick',.0:.5:2.,'layer','top','fontsize',...
            14,'linewidth',2.,'ticklength',[.025,.025],...
                'box','off','xlim',[0.,2.]);

    line([max(hf),max(hf)],...
        [0,max(hc)],'color','r','linewidth',1.5);

    text(max(hf)+.02,.90*max(hc),num2str(max(hf),'%16.2f'),...
        'horizontalalignment','left','fontsize',15) ;

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )

    text(max(hf)-.18,.45*max(hc),'$\bar{\sigma}_{h}\! = $',...
        'horizontalalignment','left',...
            'fontsize',16,'interpreter','latex') ;

    text(max(hf)+.02,.45*max(hc),num2str(mad(hf),'%16.2f'),...
        'horizontalalignment','left','fontsize',15) ;

    end

    if ( ~(exist('OCTAVE_VERSION','builtin') > +0) )

    text(-0.10,0.0,'$h_{r}$','horizontalalignment','right',...
        'fontsize',22,'interpreter','latex') ;

    else

    text(-0.10,0.0, 'h_{r}' ,'horizontalalignment','right',...
        'fontsize',22,'interpreter',  'tex') ;

    end

end



