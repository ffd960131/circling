clear; clc; close all;

filename = 'data.xlsx';
nPred    = 8;
nOut     = 6;
nSamples = 30;

predNames = {'N','v_0','κ','ω','β','σ_x_(_y_)','σ_v','λ'};
outNames  = {'N_C','L_l','NT','S','PDR','SAI'};

X_all = zeros(nSamples,nPred);
Y_all = zeros(nSamples,nPred,nOut);

for i = 1:nPred
    T = readmatrix(filename,'Sheet',i);
    X_all(:,i)   = T(:,1);
    Y_all(:,i,:) = T(:,2:7);
end

R = zeros(nPred,nOut);

for i = 1:nPred
    Xi = X_all(:,i);
    Yi = squeeze(Y_all(:,i,:));
    for j = 1:nOut
        y = Yi(:,j);
        r = corr(Xi,y,'Type','Pearson','Rows','complete');
        R(i,j) = r;
    end
end

[~, idxTopPred] = max(abs(R), [], 1);

f3 = figure('Color','w');
tiledlayout(2,3,'TileSpacing','compact','Padding','compact');

for j = 1:nOut
    iTop = idxTopPred(j);
    
    Xi = X_all(:, iTop);
    Yi = squeeze(Y_all(:, iTop, j));
    
    pfit = polyfit(Xi, Yi, 1);
    xfit = linspace(min(Xi), max(Xi), 100);
    yfit = polyval(pfit, xfit);
    
    nexttile; hold on;
    
    scatter(Xi, Yi, 40, ...
        'MarkerFaceColor',[0.7 0.7 0.7], ...
        'MarkerEdgeColor',[0.2 0.2 0.2], ...
        'LineWidth',0.5);
    
    mainCol = [0.1216, 0.4667, 0.7059];
    plot(xfit, yfit, 'Color', mainCol, 'LineWidth', 2.5);
    
    xlabel(predNames{iTop});
    ylabel(outNames{j});
    
    r_val = R(iTop, j);
    title(sprintf('%s vs %s (r = %.2f)', outNames{j}, predNames{iTop}, r_val), ...
        'FontName','Helvetica', 'FontSize',18, 'FontWeight','normal');
    
    box on;
    
    ax = gca;
    xt = get(ax,'XTick');
    yt = get(ax,'YTick');
    if ~isempty(xt)
        switch j
            case 1
                xt(end) = 2.5;
                set(ax,'XTick',xt,'XLim',[xt(1) 2.5]);
            case 2
                xt(end) = 3;
                yt(end) = 0.6;
                set(ax,'XTick',xt,'XLim',[xt(1) 3]);
                set(ax,'YTick',yt,'YLim',[yt(1) 0.6]);
            case 3
                yt(end) = 120;
            case 5
                yt(end) = 25;
                set(ax,'YTick',yt,'YLim',[yt(1) 25]);
            case 6
                yt(end) = 0.6;
                set(ax,'YTick',yt,'YLim',[yt(1) 0.6]);
                xt(end) = 60;
                set(ax,'XTick',xt,'XLim',[xt(1) 60]);
        end
    end
end

set(findall(f3, '-property', 'FontName'),   'FontName', 'Helvetica');
set(findall(f3, '-property', 'FontSize'),   'FontSize', 18);
set(findall(f3, '-property', 'FontWeight'), 'FontWeight','normal');

exportgraphics(f3,'5.svg','ContentType','vector','BackgroundColor','none');
