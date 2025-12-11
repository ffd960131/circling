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

sig_alpha = 0.05;
r_thres   = 0.30;

nodeNames = [predNames, outNames];
nPred     = numel(predNames);
nOut      = numel(outNames);
nNodes    = numel(nodeNames);

theta  = linspace(0, 2*pi, nNodes+1);
theta(end) = [];
radius_node  = 1.0;
radius_label = 1.18;
radius_arc   = 1.02;

xNode = radius_node  * cos(theta);
yNode = radius_node  * sin(theta);

f2 = figure('Color','w'); 
hold on;
axis equal off;

cmapChord = make_chord_colormap();
colormap(cmapChord);
caxis([-1 1]);
nC2 = size(cmapChord,1);

hcb2 = colorbar('Location','eastoutside');
set(hcb2,'FontSize',18,'FontName','Helvetica','FontWeight','normal');

th_bg = linspace(0, 2*pi, 400);
plot(1.06*cos(th_bg), 1.06*sin(th_bg), ...
     'Color',[0.9 0.9 0.9], 'LineWidth',2);

arcHalfWidth = 0.5 * 2*pi / nNodes;

colPred = [0.1216, 0.4667, 0.7059];
colOut  = [0.8902, 0.4667, 0.0];

for k = 1:nNodes
    th1 = theta(k) - arcHalfWidth;
    th2 = theta(k) + arcHalfWidth;
    tArc = linspace(th1, th2, 40);

    if k <= nPred
        cc = colPred;
    else
        cc = colOut;
    end

    plot(radius_arc*cos(tArc), radius_arc*sin(tArc), ...
         'Color', cc, 'LineWidth', 6);
end

for i = 1:nPred
    for j = 1:nOut
        r  = R(i,j);
        pv = P_corrected(i,j);

        if abs(r) < r_thres || pv > sig_alpha
            continue;
        end

        idxStart = i;
        idxEnd   = nPred + j;

        rChord = 0.92;
        x1 = rChord * cos(theta(idxStart)); 
        y1 = rChord * sin(theta(idxStart));
        x2 = rChord * cos(theta(idxEnd));   
        y2 = rChord * sin(theta(idxEnd));

        rCtrl = 0.15;
        xc = rCtrl * cos( (theta(idxStart)+theta(idxEnd))/2 );
        yc = rCtrl * sin( (theta(idxStart)+theta(idxEnd))/2 );

        t = linspace(0,1,120);
        xCurve = (1-t).^2 * x1 + 2*(1-t).*t * xc + t.^2 * x2;
        yCurve = (1-t).^2 * y1 + 2*(1-t).*t * yc + t.^2 * y2;

        colorIdx = round((r+1)/2*(nC2-1)) + 1;
        colorIdx = max(1, min(nC2, colorIdx));
        baseCol  = cmapChord(colorIdx,:);

        softCol  = 0.7*baseCol + 0.3*[1 1 1];

        lw = 4 + 4*abs(r);

        plot(xCurve, yCurve, 'LineWidth', lw, 'Color', softCol);
    end
end

scatter(xNode(1:nPred), yNode(1:nPred), 90, ...
        'MarkerFaceColor', colPred, ...
        'MarkerEdgeColor', [0 0 0], ...
        'LineWidth', 0.8);

scatter(xNode(nPred+1:end), yNode(nPred+1:end), 90, ...
        'MarkerFaceColor', colOut, ...
        'MarkerEdgeColor', [0 0 0], ...
        'LineWidth', 0.8);

for k = 1:nNodes
    ang = theta(k);
    xT = radius_label * cos(ang);
    yT = radius_label * sin(ang);

    if cos(ang) >= 0
        ha = 'left';
    else
        ha = 'right';
    end

    text(xT, yT, nodeNames{k}, ...
        'HorizontalAlignment',ha, ...
        'VerticalAlignment','middle', ...
        'FontSize',18, ...
        'FontName','Helvetica', ...
        'FontWeight','normal', ...
        'Color',[0 0 0]);
end

exportgraphics(f2,'6.svg','ContentType','vector','BackgroundColor','none');

function cmap = make_chord_colormap()
    n = 128;

    neg1 = [ 40 120 160 ]/255;
    neg2 = [180 220 230 ]/255;
    r_neg = linspace(neg1(1),neg2(1),n/2)';
    g_neg = linspace(neg1(2),neg2(2),n/2)';
    b_neg = linspace(neg1(3),neg2(3),n/2)';
    cmap_neg = [r_neg, g_neg, b_neg];

    pos1 = [ 255 220 160 ]/255;
    pos2 = [ 200  80  40 ]/255;
    r_pos = linspace(pos1(1),pos2(1),n/2)';
    g_pos = linspace(pos1(2),pos2(2),n/2)';
    b_pos = linspace(pos1(3),pos2(3),n/2)';
    cmap_pos = [r_pos, g_pos, b_pos];

    cmap = [cmap_neg; cmap_pos];
end

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
