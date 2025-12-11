
clear; close all; clc;

filename = 'data.xlsx'; 
nPred = 8;
nOut = 6;
nSamples = 30;
predNames = {'N','v_0','κ','ω','β','σ_x_(_y_)','σ_v','λ'}; 
outNames = {'N_C','L_l','NT','S','PDR','SAI'}; 

X_all = zeros(nSamples,nPred); 
Y_all = zeros(nSamples,nPred,nOut); 

for i = 1:nPred 
    T = readmatrix(filename,'Sheet',i); 
    X_all(:,i) = T(:,1);
    Y_all(:,i,:) = T(:,2:7);
end 

R = zeros(nPred,nOut); 
P = zeros(nPred,nOut);

for i = 1:nPred
    Xi = X_all(:,i); 
    Yi = squeeze(Y_all(:,i,:)); 
    for j = 1:nOut 
        y = Yi(:,j); 
        [r,p] = corr(Xi,y,'Type','Pearson','Rows','complete'); 
        R(i,j) = r; 
        P(i,j) = p; 
    end 
end

alpha = 0.05; 
pvec = P(:); 
m = numel(pvec); 
P_bonf = min(1, pvec*m);
P_corrected = reshape(P_bonf,size(P));

f = figure('Color','w'); hold on;

cmap = make_diverging_colormap();
colormap(cmap);
caxis([-1 1]);

hcb = colorbar('Location','eastoutside');
set(hcb,'FontSize',18,'FontName','Helvetica','FontWeight','normal');

maxBubble = 5000;
minBubble = 2500;

[nPred, nOut] = size(R);

for i = 1:nPred
    for j = 1:nOut
        r = R(i,j);
        bubbleSize = minBubble + (maxBubble - minBubble)*abs(r);
        colorIdx = round((r+1)/2*(size(cmap,1)-1)) + 1;
        scatter(j, i, bubbleSize, ...
                'MarkerFaceColor', cmap(colorIdx,:), ...
                'MarkerEdgeColor', [0 0 0], ...
                'LineWidth',0.5);
        
        pv = P_corrected(i,j);
        if pv <= 0.001
            sig = '***';
        elseif pv <= 0.01
            sig = '**';
        elseif pv <= 0.05
            sig = '*';
        else
            sig = '';
        end
        
        text(j, i, sprintf('%.2f\n%s', r, sig), ...
            'HorizontalAlignment','center', ...
            'VerticalAlignment','middle', ...
            'FontSize',18, ...
            'FontName','Helvetica', ...
            'FontWeight','normal', ...
            'Color',[0 0 0]);
    end
end

xlim([0.5 nOut+0.5]); 
ylim([0.5 nPred+0.5]);

set(gca,'XTick',1:nOut,...
        'XTickLabel',outNames,...
        'XTickLabelRotation',65,...
        'YTick',1:nPred,...
        'YTickLabel',predNames,...
        'FontName','Helvetica',...
        'FontSize',18,...
        'FontWeight','normal');

grid on; 
box on;

ax = gca; 
ax.GridColor = [0.8 0.8 0.8]; 
ax.GridAlpha = 0;

ax.XTickLabelRotation = 0;
ax.LineWidth = 2;

set(gca, 'YDir','reverse');

exportgraphics(gcf,'4.svg','ContentType','vector','BackgroundColor','none');

function cmap = make_diverging_colormap()
    n = 128;
    bluePurple = [linspace(120,240,n/2)'./255, ...
                  linspace(130,230,n/2)'./255, ...
                  linspace(200,255,n/2)'./255];
    pinkRed = [linspace(245,255,n/2)'./255, ...
               linspace(180,230,n/2)'./255, ...
               linspace(200,230,n/2)'./255];
    cmap = [flipud(bluePurple); pinkRed];
end
