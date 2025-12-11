clear; clc;
figSize = 1000; % Side length of the square in pixels
f = figure('Color','w');
f.WindowState = 'maximized';


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

%% ============ Load matrix ================
load('traj1_1.mat'); 

Ntraj = size(x,2);

% Normalize uniformly to [-1,1]
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

% Unified grid
[Xgrid,Ygrid] = meshgrid(linspace(min(x(:)),max(x(:)),100), ...
                         linspace(min(y(:)),max(y(:)),100));
PX_all = zeros(size(Xgrid));

% ============ Loop-averaged KDE ============
for j = 1:Ntraj
    XY = [x(:,j), y(:,j)];
    [pxy,~,~] = ksdensity(XY, [Xgrid(:), Ygrid(:)]);
    PX = reshape(pxy, size(Xgrid));
    PX_all = PX_all + PX;
end
PX_mean = PX_all / Ntraj;   % Mean distribution

%% ============ Visualize mean KDE ===================
nexttile;
contourf(Xgrid, Ygrid, PX_mean, 20,'LineColor','none');
colormap(myColors);
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
c = colorbar; 
axis square
xlabel('Displacement X','FontSize',20,'FontName','Helvetica');
ylabel('Displacement Y','FontSize',20,'FontName','Helvetica');
clim([0 3]); cb.Ticks = 0:1:3; 
ax = gca;


numTicks = 3;
xticks(linspace(min(x(:)), max(x(:)), numTicks));
yticks(linspace(min(y(:)), max(y(:)), numTicks));

%ylabel('');ax.YTick = []; 
%xlabel('');ax.XTick = []; 

%% ============ Compute metrics ============
dx = Xgrid(1,2)-Xgrid(1,1);
dy = Ygrid(2,1)-Ygrid(1,1);
dA = dx*dy; % Area element of grid cell

% Normalization
PXn = PX_mean / sum(PX_mean(:)*dA);

% 1) Entropy
mask = PXn>0;
epsilon = 1e-12;               % Prevent log(0)
S = -sum(PXn(mask).*log(PXn(mask) + epsilon))*dA;

% 2) PDR
A  = (max(Xgrid(:)) - min(Xgrid(:))) * (max(Ygrid(:)) - min(Ygrid(:))); 
pmax = max(PXn(:));
pmean = 1/A;
PDR = pmax / pmean;

% 3) SAI
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
