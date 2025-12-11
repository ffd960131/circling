clear; clc;
AA={'ω=1/(6π)','ω=1/(5π)','ω=1/(4π)','ω=1/(3π)','ω=1/(2π)','ω=1/π'};
figSize = 1000;
f = figure('Color','w');
f.WindowState = 'maximized';

t = tiledlayout('Units','centimeters', 'Position',[2 0 40 7]);
t.Padding = 'compact';
t.TileSpacing = 'compact';

S1=[]; PDR1=[]; SAI1=[];

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
x = linspace(0,1,size(myColors,1));
xq = linspace(0,1,nColors);
myColors = interp1(x, myColors, xq);

load('traj4_1.mat');
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

nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3;
delete(c);
ax = gca;
title(AA(1));

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

xlabel('');ax.XTick = [];

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
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


load('traj4_2.mat');
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

nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3;
delete(c);

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ax = gca;
xlabel('');ax.XTick = [];
ylabel('');ax.YTick = [];

title(AA(2));

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / (sum(PX_mean(:)) * dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
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


load('traj4_3.mat');
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

nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3;
delete(c);

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ax = gca;
xlabel('');ax.XTick = [];
ylabel('');ax.YTick = [];

title(AA(3));

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
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


load('traj4_4.mat');
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

nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3;
delete(c);

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ax = gca;
xlabel('');ax.XTick = [];
ylabel('');ax.YTick = [];

title(AA(4));

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
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


load('traj4_5.mat');
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

nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar;
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3;
delete(c);

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ax = gca;
xlabel('');ax.XTick = [];
ylabel('');ax.YTick = [];

title(AA(5));

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
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


load('traj4_6.mat');
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

nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar('Location','northoutside');
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3;
delete(c);

numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

ax = gca;
xlabel('');ax.XTick = [];
ylabel('');ax.YTick = [];

title(AA(6));

dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy;

PXn = PX_mean / sum(PX_mean(:)*dA);

mask = PXn>0;
epsilon = 1e-12;
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:)));
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
figHeight = 8;

set(f,'PaperUnits','centimeters');
set(f,'PaperSize',[figWidth figHeight]);
set(f,'PaperPosition',[0 0 figWidth figHeight]);
set(f,'PaperPositionMode','manual');

print(f,'simulate_kern_4.svg','-dsvg','-vector');
