filename = 'data.xlsx';
[~, sheets] = xlsfinfo(filename);
numSheets = length(sheets);

xLabels = {'N','v_0','κ','ω','β','σ_x_(_y_)','σ_v','λ'};
yLabels = {'N_C','L_l','NT','S','PDR','SAI'};

meann = [];

yLimits = [
    0 120;
    0.14 0.26;
    60 140;
    0 0.8;
    0 60;
    0.16 0.32;
];

natureColors = [ ...
    10 186 181;
    230 85 40;
    90 200 90;
    0 47 167;
    236 112 153;
    120 120 120];
natureColors = natureColors ./ 255;

f = figure('Color','w');

tiledlayout(2,3,'TileSpacing','compact','Padding','compact');
hScatter = gobjects(6,1);

for v = 1:6
    nexttile;
    hold on;
    
    for i = 1:numSheets
        data = readmatrix(filename,'Sheet',sheets{i});
        xVar = data(:,1);
        yVar = data(:,v+1);

        meanVal = mean(yVar,'omitnan');
        semVal  = std(yVar,'omitnan')/sqrt(length(yVar));

        meann=[meann,meanVal];

        baseColor = natureColors(v,:);
        lineColor = 0.6*baseColor + 0.4*[1 1 1];

        plot([i i],[meanVal-semVal meanVal+semVal],'-','Color',lineColor,'LineWidth',8);
        hScatter(v)=scatter(i,meanVal-semVal,100,baseColor,'filled','MarkerEdgeColor','k','LineWidth',1);
        scatter(i,meanVal+semVal,100,baseColor,'filled','MarkerEdgeColor','k','LineWidth',1);
    end
    
    set(gca,'XTick',1:numSheets,'XTickLabel',xLabels,'FontName','Helvetica','FontSize',20);
    xtickangle(0);
    ylabel(yLabels{v});
    
    ax = gca;
    ax.LineWidth = 2;
    ylim(yLimits(v,:));
    yticks(linspace(yLimits(v,1), yLimits(v,2), 5));
    
    xlim([0.5 numSheets+0.5]);
    box off;
end

set(gcf,'Color','w');

lgd = legend(hScatter, yLabels, ...
    'Orientation','horizontal','Box','off','FontSize',20);
lgd.Layout.Tile = 'north';

exportgraphics(gcf,'1.svg','ContentType','vector','BackgroundColor','none');
