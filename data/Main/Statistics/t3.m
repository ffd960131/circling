clear; close all; clc;

filename = 'data.xlsx';
nPred = 8;
nOut = 6;

X_all = zeros(30,nPred);
Y_all = zeros(30,nPred,nOut);

natureColors = [ ...
    135 206 250;
    123 201 111;
    197 144 222;
    250 128 114;
    102 204 204;
    240 128 160;
    180 180 200;
    176 224 230];
natureColors = natureColors ./ 255;

for i = 1:nPred
    T = readmatrix(filename,'Sheet',i);
    X_all(:,i) = T(:,1);
    Y_all(:,i,:) = T(:,2:end);
end

predNames = {'N','v_0','κ','ω','β','σ_x_(_y_)','σ_v','λ'}; 
outNames  = {'N_C','L_l','NT','S','PDR','SAI'};

nSamples = size(X_all,1);

importance = zeros(nPred,nOut);

for i = 1:nPred
    Xi = X_all(:,i);
    Yi = squeeze(Y_all(:,i,:));
    for j = 1:nOut
        y = Yi(:,j);
        Xz = zscore(Xi);
        yz = zscore(y);
        b = regress(yz, [Xz ones(nSamples,1)]);
        beta = b(1);
        importance(i,j) = abs(beta);
    end
end

meanImp = mean(importance,2);
[meanImp_sorted, idx] = sort(meanImp,'descend');
predNames_sorted = predNames(idx);

f = figure('Color','w');

b = bar(meanImp_sorted,'FaceColor',[0.2 0.4 0.7],'EdgeColor','none','BarWidth',0.6);
set(gca,'XTick',1:nPred,'XTickLabel',predNames_sorted,'FontName','Helvetica','FontSize',37);
ylabel('Average Influence (|β_a_v_e|)','FontSize',37,'FontName','Helvetica');
xlabel('Variables (ranked)','FontSize',37,'FontName','Helvetica');

box off;

for k = 1:nPred
    text(k, meanImp_sorted(k)+0.03, sprintf('%.2f',meanImp_sorted(k)),...
        'HorizontalAlignment','center','FontSize',37,'FontName','Helvetica');
    b.FaceColor = 'flat';
    b.CData(k,:) = natureColors(mod(k-1,8)+1,:);
end

hold on;
hLegend = gobjects(nPred,1);
for k = 1:nPred
    hLegend(k) = plot(nan, nan, 's', ...
        'MarkerFaceColor', b.CData(k,:), ...
        'MarkerEdgeColor','none', ...
        'MarkerSize',37);
end

lgd = legend(hLegend, predNames_sorted, ...
    'FontSize',37, 'Box','off');

lgd.Position = [0.8 0.6 0.1 0.3];
ax = gca;
ax.LineWidth = 3.5;
ylim([0 1]);
yticks(0:0.2:1);

exportgraphics(gcf,'3.svg','ContentType','vector','BackgroundColor','none');
