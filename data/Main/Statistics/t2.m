clear; close all; clc;

filename = 'data.xlsx';
nPred = 8;
nOut = 6;

X_all = zeros(30,nPred);
Y_all = zeros(30,nPred,nOut);

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
hb = bar(importance,'grouped','EdgeColor','none','BarWidth',0.8);

natureColors = [ ...
    10 186 181;
    230 85 40;
    90 200 90;
    0 47 167;
    236 112 153;
    120 120 120];
natureColors = natureColors ./ 255;

for j = 1:nOut
    hb(j).FaceColor = natureColors(j,:);
    hb(j).FaceAlpha = 0.85;
end

set(gca,'XTick',1:nPred,'XTickLabel',predNames,'FontName','Helvetica','FontSize',38);
ylabel('Influence |β|','FontSize',38,'FontName','Helvetica');
xlabel('','FontSize',38,'FontName','Helvetica');

legend(outNames,'Location','northeastoutside','FontSize',38,'Box','off');

ylim([0 1]);
yticks(0:0.2:1);
ax = gca;
ax.LineWidth = 4;
box off;

exportgraphics(gcf,'2.svg','ContentType','vector','BackgroundColor','none');
