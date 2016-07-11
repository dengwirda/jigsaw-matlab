function drawcost(cost)
%DRAWCOST draw mesh cost metrics for a given mesh.

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   09-Jul-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
%

    dolabel = true ;

%-- draw sub-axes directly -- sub-plot gives
%-- silly inconsistent spacing...!
    
    axpos21 = [.125,.60,.80,.30] ;
    axpos22 = [.125,.15,.80,.30] ;
    
    axpos31 = [.125,.75,.80,.15] ;
    axpos32 = [.125,.45,.80,.15] ;
    axpos33 = [.125,.15,.80,.15] ;
    
%-- draw cost histograms for tria-3 elements
    if ( isfield(cost,'tria3') )
       
        if (~isfield(cost.tria3,'score') || ...
            ~isfield(cost.tria3,'angle') )
            error('DRAWCOST: invalid inputs.') ;
        end
        
        figure;
        set(gcf,'color','w','position',[128,128,640,300]);
        if (isfield(cost.tria3,'hfunc') )
    %-- have size-func data
        axes('position',axpos31); hold on;
        score_hist(cost.tria3.score(:),'tria3');
        if (dolabel)
        title('Quality metrics (TRIA-3)');
        end
        axes('position',axpos32); hold on;
        angle_hist(cost.tria3.angle(:),'tria3');
        axes('position',axpos33); hold on;
        hfunc_hist(cost.tria3.hfunc(:),'tria3');
        else
    %-- null size-func data
        axes('position',axpos21); hold on;
        score_hist(cost.tria3.score(:),'tria3');
        if (dolabel)
        title('Quality metrics (TRIA-3)');
        end
        axes('position',axpos22); hold on;
        angle_hist(cost.tria3.angle(:),'tria3');
        end
        
    end
    
%-- draw cost histograms for tria-4 elements
    if ( isfield(cost,'tria4') )
       
        if (~isfield(cost.tria4,'score') || ...
            ~isfield(cost.tria4,'angle') )
            error('DRAWCOST: invalid inputs.') ;
        end
        
        figure;
        set(gcf,'color','w','position',[128,128,640,300]);
        if (isfield(cost.tria4,'hfunc') )
    %-- have size-func data
        axes('position',axpos31); hold on;
        score_hist(cost.tria4.score(:),'tria4');
        if (dolabel)
        title('Quality metrics (TRIA-4)');
        end
        axes('position',axpos32); hold on;
        angle_hist(cost.tria4.angle(:),'tria4'); 
        axes('position',axpos33); hold on;
        hfunc_hist(cost.tria4.hfunc(:),'tria4');
        else
    %-- null size-func data
        axes('position',axpos21); hold on;
        score_hist(cost.tria4.score(:),'tria4');
        if (dolabel)
        title('Quality metrics (TRIA-4)');
        end
        axes('position',axpos22); hold on;
        angle_hist(cost.tria4.angle(:),'tria4');
        end
        
    end

end

function angle_hist(ad,ty)
%ANGLE_HIST draw histogram for "angle" data.

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
            18,'linewidth',2.,'ticklength',[.025,.025],...
                'box','off','xlim',[0.,180.]) ;
    
    mina = max(1.000,min(ad)); %%!! so that axes don't obscure!
    maxa = min(179.0,max(ad));
    
    line([ mina, mina],...
        [0,max(hc)],'color','r','linewidth',1.5);
    line([ maxa, maxa],...
        [0,max(hc)],'color','r','linewidth',1.5);
    
    if ( mina > 25.0)
        text(mina-1.8,.9*max(hc),num2str(min(ad),'%16.1f'),...
            'horizontalalignment',...
                'right','fontsize',22) ;
    else
        text(mina+1.8,.9*max(hc),num2str(min(ad),'%16.1f'),...
            'horizontalalignment',...
                'left' ,'fontsize',22) ;
    end
    
    if ( maxa < 140.)
        text(maxa+1.8,.9*max(hc),num2str(max(ad),'%16.1f'),...
            'horizontalalignment',...
                'left' ,'fontsize',22) ;    
    else
        text(maxa-1.8,.9*max(hc),num2str(max(ad),'%16.1f'),...
            'horizontalalignment',...
                'right','fontsize',22) ;     
    end
   
    switch (ty)
    case 'tria4'
        text(-9.0,0.0,'$\theta_{\tau}$',...
            'horizontalalignment','right',...
                'fontsize',28,'interpreter','latex') ;
        
    case 'tria3'
        text(-9.0,0.0,'$\theta_{f}$',...
            'horizontalalignment','right',...
                'fontsize',28,'interpreter','latex') ;
        
    end
    
end

function score_hist(sc,ty)
%SCORE_HIST draw histogram for "score" data.

    be = linspace(0.,1.,101);
    bm = (be(1:end-1)+be(2:end)) / 2.;
    hc = histc(sc,be);

    switch (ty)   
    case 'tria4'
        poor = bm <  .25 ;
        okay = bm >= .25 & bm <  .50 ;
        good = bm >= .50 & bm <  .75 ;
        best = bm >= .75 ;
    
    case 'tria3'
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
            18,'linewidth',2.,'ticklength',[.025,.025],...
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
                'right','fontsize',22) ;
    else
        text(mins+.01,.9*max(hc),num2str(min(sc),'%16.3f'),...
            'horizontalalignment',...
                'left' ,'fontsize',22) ;
    end
    
    text(mean(sc)-.01,.9*max(hc),num2str(mean(sc),'%16.3f'),...
        'horizontalalignment','right','fontsize',22) ;
    
    switch (ty)
    case 'tria4'
        text(-.05,0.0,'$v_{\tau}$',...
            'horizontalalignment','right',...
                'fontsize',28,'interpreter','latex') ;
        
    case 'tria3'
        text(-.05,0.0,'$a_{f}$',...
            'horizontalalignment','right',...
                'fontsize',28,'interpreter','latex') ;
        
    end
    
end

function hfunc_hist(hf,ty)
%HFUNC_HIST draw histogram for "hfunc" data.

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
    set(gca,'ycolor',get(gca,'color'),'ytick',[],...
        'xtick',[.0,.5,1.,1.5,2.0],'layer','top',...
            'fontsize',18,'linewidth',2.,'ticklength',[.025,.025],...
                'box','off','xlim',[0.,2.]);
    
    line([mean(hf),mean(hf)],...
        [0,max(hc)],'color','r','linewidth',1.5);
    
    text(mean(hf)+.02,.9*max(hc),num2str(mean(hf),'%16.2f'),...
        'horizontalalignment','left','fontsize',22);
    
    text(-0.100,0.0,'$h_{r}$','horizontalalignment','right',...
        'fontsize',28,'interpreter','latex');
    
end


