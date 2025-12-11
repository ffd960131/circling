AA = {'k=0.01','k=0.05'};

load('traj30_001.mat');
Ntraj = size(x,2);

x = 2*(x - min(x(:)))/(max(x(:))-min(x(:)))-1;
y = 2*(y - min(y(:)))/(max(y(:))-min(y(:)))-1;

computeKDE = @(X,Y) deal(...
    reshape(ksdensity([X(:),Y(:)], [Xgrid(:),Ygrid(:)]), size(Xgrid)) ...
    );

gridN = 100;
[Xgrid,Ygrid] = meshgrid(linspace(-1,1,gridN), linspace(-1,1,gridN));

PX_all = zeros(size(Xgrid));
for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    PX_all = PX_all + reshape(ksdensity(XY,[Xgrid(:),Ygrid(:)]), size(Xgrid));
end
PX_orig = PX_all / Ntraj;

x_star = 1; y_star = 1;
k_ctrl = 0.01;

dt = 0.1; T = size(x,1)*dt;
N = size(x,1);

x_ctrl = zeros(N,Ntraj); y_ctrl = zeros(N,Ntraj);
x_ctrl(1,:) = x(1,:); y_ctrl(1,:) = y(1,:);

sigma_x = 1; sigma_y = 1;
v = 2;

for j = 1:Ntraj
    for t = 1:N-1
        u_x = -k_ctrl*(x_ctrl(t,j)-x_star);
        u_y = -k_ctrl*(y_ctrl(t,j)-y_star);
        x_ctrl(t+1,j) = x_ctrl(t,j) + v*dt + u_x*dt + sigma_x*sqrt(dt)*randn;
        y_ctrl(t+1,j) = y_ctrl(t,j) + v*dt + u_y*dt + sigma_y*sqrt(dt)*randn;
    end
end

PX_all_ctrl = zeros(size(Xgrid));
for j = 1:Ntraj
    XY = [x_ctrl(:,j), y_ctrl(:,j)];
    PX_all_ctrl = PX_all_ctrl + reshape(ksdensity(XY,[Xgrid(:),Ygrid(:)]), size(Xgrid));
end
PX_ctrl = PX_all_ctrl / Ntraj;

PX_diff = PX_ctrl - PX_orig;

f = figure('Color','w');
f.WindowState = 'maximized';

t = tiledlayout('Units','centimeters', 'Position',[2 0 40 7]);
t.Padding = 'compact';
t.TileSpacing = 'compact';

ax = nexttile;
hold on; axis equal;

x_ctrl = 2*(x_ctrl - min(x_ctrl(:)))/(max(x_ctrl(:))-min(x_ctrl(:)))-1;
y_ctrl = 2*(y_ctrl - min(y_ctrl(:)))/(max(y_ctrl(:))-min(y_ctrl(:)))-1;

for j = 1:Ntraj
    plot(x_ctrl(:,j),y_ctrl(:,j),'Color',[0.1216, 0.4667, 0.7059],'LineWidth',5);
end
scatter(x_star,y_star,300,[1 0.5 0.8],'filled');

for i = 1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
scatter(-1,-1,300,[0.72 0.75 0.94],'filled');
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica');
ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel(''); ax.XTick = [];

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

S1 = []; PDR1 = []; SAI1 = [];

myColors = [
     8  29  88;
    37  52 148;
    34  94 168;
    29 145 192;
    65 182 196;
   127 205 187;
   219 200 180;
   253 174  97;
   215  25  28] / 255;

nColors = 16;
xx = linspace(0,1,size(myColors,1));
xq = linspace(0,1,nColors);
myColors = interp1(xx, myColors, xq);

Ntraj = size(x,2);

x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

[Xgrid,Ygrid] = meshgrid(linspace(min(x(:)),max(x(:)),100), ...
                         linspace(min(y(:)),max(y(:)),100));
PX_all = zeros(size(Xgrid));

for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    [pxy,~,~] = ksdensity(XY, [Xgrid(:), Ygrid(:)]);
    PX = reshape(pxy, size(Xgrid));
    PX_all = PX_all + PX;
end
PX_mean = PX_all / Ntraj;

h = title(AA(1));
set(h, 'Units', 'normalized');
set(h, 'Position', [0, 1, 0]);
set(h, 'HorizontalAlignment', 'left');

ax = nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 2]); cb.Ticks = 0:1:3;
delete(c);
ax = gca;

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ylabel(''); ax.YTick = [];
xlabel(''); ax.XTick = [];

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
pmax = max(PXn(:));
pmean = 1/A;
PDR = pmax / pmean;

xc = sum(sum(Xgrid .* PXn)) * dA;
yc = sum(sum(Ygrid .* PXn)) * dA;
sigma_xx = sum(sum((Xgrid-xc).^2 .* PXn)) * dA;
sigma_yy = sum(sum((Ygrid-yc).^2 .* PXn)) * dA;
sigma_xy = sum(sum((Xgrid-xc).*(Ygrid-yc) .* PXn)) * dA;
Sigma = [sigma_xx sigma_xy; sigma_xy sigma_yy];
eigvals = eig(Sigma);
lambda_max = max(eigvals);
lambda_min = min(eigvals);
SAI = 1 - lambda_min/lambda_max;

S1=[S1;S];
PDR1=[PDR1;PDR];
SAI1=[SAI1;SAI];

Ntraj = size(x,2);

x = x_ctrl;
y = y_ctrl;

x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

[Xgrid,Ygrid] = meshgrid(linspace(min(x(:)),max(x(:)),100), ...
                         linspace(min(y(:)),max(y(:)),100));
PX_all = zeros(size(Xgrid));

for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    [pxy,~,~] = ksdensity(XY, [Xgrid(:), Ygrid(:)]);
    PX = reshape(pxy, size(Xgrid));
    PX_all = PX_all + PX;
end
PX_mean = PX_all / Ntraj;

ax = nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar('Location','northoutside');
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 2]); cb.Ticks = 0:1:3;
delete(c);

ax = gca;

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ylabel(''); ax.YTick = [];
xlabel(''); ax.XTick = [];

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
pmax = max(PXn(:));
pmean = 1/A;
PDR = pmax / pmean;

xc = sum(sum(Xgrid .* PXn)) * dA;
yc = sum(sum(Ygrid .* PXn)) * dA;
sigma_xx = sum(sum((Xgrid-xc).^2 .* PXn)) * dA;
sigma_yy = sum(sum((Ygrid-yc).^2 .* PXn)) * dA;
sigma_xy = sum(sum((Xgrid-xc).*(Ygrid-yc) .* PXn)) * dA;
Sigma = [sigma_xx sigma_xy; sigma_xy sigma_yy];
eigvals = eig(Sigma);
lambda_max = max(eigvals);
lambda_min = min(eigvals);
SAI = 1 - lambda_min/lambda_max;

S1=[S1;S];
PDR1=[PDR1;PDR];
SAI1=[SAI1;SAI];

load('traj30_005.mat');
Ntraj = size(x,2);

x = 2*(x - min(x(:)))/(max(x(:))-min(x(:)))-1;
y = 2*(y - min(y(:)))/(max(y(:))-min(y(:)))-1;

computeKDE = @(X,Y) deal(...
    reshape(ksdensity([X(:),Y(:)], [Xgrid(:),Ygrid(:)]), size(Xgrid)) ...
    );

gridN = 100;
[Xgrid,Ygrid] = meshgrid(linspace(-1,1,gridN), linspace(-1,1,gridN));

PX_all = zeros(size(Xgrid));
for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    PX_all = PX_all + reshape(ksdensity(XY,[Xgrid(:),Ygrid(:)]), size(Xgrid));
end
PX_orig = PX_all / Ntraj;

x_star = 1; y_star = 1;
k_ctrl = 0.05;

dt = 0.1; T = size(x,1)*dt;
N = size(x,1);

x_ctrl = zeros(N,Ntraj); y_ctrl = zeros(N,Ntraj);
x_ctrl(1,:) = x(1,:); y_ctrl(1,:) = y(1,:);

sigma_x = 1; sigma_y = 1;
v = 2;

for j = 1:Ntraj
    for t = 1:N-1
        u_x = -k_ctrl*(x_ctrl(t,j)-x_star);
        u_y = -k_ctrl*(y_ctrl(t,j)-y_star);
        x_ctrl(t+1,j) = x_ctrl(t,j) + v*dt + u_x*dt + sigma_x*sqrt(dt)*randn;
        y_ctrl(t+1,j) = y_ctrl(t,j) + v*dt + u_y*dt + sigma_y*sqrt(dt)*randn;
    end
end

PX_all_ctrl = zeros(size(Xgrid));
for j = 1:Ntraj
    XY = [x_ctrl(:,j), y_ctrl(:,j)];
    PX_all_ctrl = PX_all_ctrl + reshape(ksdensity(XY,[Xgrid(:),Ygrid(:)]), size(Xgrid));
end
PX_ctrl = PX_all_ctrl / Ntraj;

PX_diff = PX_ctrl - PX_orig;

ax = nexttile;
hold on; axis equal;

x_ctrl = 2*(x_ctrl - min(x_ctrl(:)))/(max(x_ctrl(:))-min(x_ctrl(:)))-1;
y_ctrl = 2*(y_ctrl - min(y_ctrl(:)))/(max(y_ctrl(:))-min(y_ctrl(:)))-1;

for j = 1:Ntraj
    plot(x_ctrl(:,j),y_ctrl(:,j),'Color',[0.1216, 0.4667, 0.7059],'LineWidth',5);
end
scatter(x_star,y_star,300,[1 0.5 0.8],'filled');

for i = 1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
scatter(-1,-1,300,[0.72 0.75 0.94],'filled');
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica');
ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel(''); ax.XTick = [];
ylabel(''); ax.YTick = [];

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

myColors = [
     8  29  88;
    37  52 148;
    34  94 168;
    29 145 192;
    65 182 196;
   127 205 187;
   219 200 180;
   253 174  97;
   215  25  28] / 255;

nColors = 16;
xx = linspace(0,1,size(myColors,1));
xq = linspace(0,1,nColors);
myColors = interp1(xx, myColors, xq);

Ntraj = size(x,2);

x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

[Xgrid,Ygrid] = meshgrid(linspace(min(x(:)),max(x(:)),100), ...
                         linspace(min(y(:)),max(y(:)),100));
PX_all = zeros(size(Xgrid));

for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    [pxy,~,~] = ksdensity(XY, [Xgrid(:), Ygrid(:)]);
    PX = reshape(pxy, size(Xgrid));
    PX_all = PX_all + PX;
end
PX_mean = PX_all / Ntraj;

h = title(AA(2));
set(h, 'Units', 'normalized');
set(h, 'Position', [0, 1, 0]);
set(h, 'HorizontalAlignment', 'left');

ax = nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 2]); cb.Ticks = 0:1:3;
delete(c);
ax = gca;

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ylabel(''); ax.YTick = [];
xlabel(''); ax.XTick = [];

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
pmax = max(PXn(:));
pmean = 1/A;
PDR = pmax / pmean;

xc = sum(sum(Xgrid .* PXn)) * dA;
yc = sum(sum(Ygrid .* PXn)) * dA;
sigma_xx = sum(sum((Xgrid-xc).^2 .* PXn)) * dA;
sigma_yy = sum(sum((Ygrid-yc).^2 .* PXn)) * dA;
sigma_xy = sum(sum((Xgrid-xc).*(Ygrid-yc) .* PXn)) * dA;
Sigma = [sigma_xx sigma_xy; sigma_xy sigma_yy];
eigvals = eig(Sigma);
lambda_max = max(eigvals);
lambda_min = min(eigvals);
SAI = 1 - lambda_min/lambda_max;

S1=[S1;S];
PDR1=[PDR1;PDR];
SAI1=[SAI1;SAI];

Ntraj = size(x,2);

x = x_ctrl;
y = y_ctrl;

x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

[Xgrid,Ygrid] = meshgrid(linspace(min(x(:)),max(x(:)),100), ...
                         linspace(min(y(:)),max(y(:)),100));
PX_all = zeros(size(Xgrid));

for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    [pxy,~,~] = ksdensity(XY, [Xgrid(:), Ygrid(:)]);
    PX = reshape(pxy, size(Xgrid));
    PX_all = PX_all + PX;
end
PX_mean = PX_all / Ntraj;

ax = nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar('Location','northoutside');
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 2]); cb.Ticks = 0:1:3;
delete(c);

ax = gca;

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ylabel(''); ax.YTick = [];
xlabel(''); ax.XTick = [];

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
pmax = max(PXn(:));
pmean = 1/A;
PDR = pmax / pmean;

xc = sum(sum(Xgrid .* PXn)) * dA;
yc = sum(sum(Ygrid .* PXn)) * dA;
sigma_xx = sum(sum((Xgrid-xc).^2 .* PXn)) * dA;
sigma_yy = sum(sum((Ygrid-yc).^2 .* PXn)) * dA;
sigma_xy = sum(sum((Xgrid-xc).*(Ygrid-yc) .* PXn)) * dA;
Sigma = [sigma_xx sigma_xy; sigma_xy sigma_yy];
eigvals = eig(Sigma);
lambda_max = max(eigvals);
lambda_min = min(eigvals);
SAI = 1 - lambda_min/lambda_max;

S1=[S1;S];
PDR1=[PDR1;PDR];
SAI1=[SAI1;SAI];

figWidth = 42.5;
figHeight = 7.5;

set(f,'PaperUnits','centimeters');
set(f,'PaperSize',[figWidth figHeight]);
set(f,'PaperPosition',[0 0 figWidth figHeight]);
set(f,'PaperPositionMode','manual');

print(f,'contra_5_1.svg','-dsvg','-vector');
