clear; clc; close all;

alpha  = 2;
eta    = 1;
rho    = 1.3;
gamma  = 2.0;
phistar = -asin(eta/alpha);

lambda_c = gamma - alpha*cos(phistar);

lambdas = linspace(0,1,101);
nL = numel(lambdas);

tr  = nan(1,nL);
detJ= nan(1,nL);
reEig = nan(1,nL);

optsFS = optimoptions('fsolve','Display','off','FunctionTolerance',1e-12,'StepTolerance',1e-12);

theta_star = nan(1,nL);
phi_star   = nan(1,nL);

for k = 1:nL
    lambda = lambdas(k);
    f = @(z)[ alpha*sin(z(2)-z(1)) + lambda - gamma*sin(z(1)); ...
              rho*cos(z(1)) - eta*sin(z(2)-phistar)];
    z_guess = [pi/2; phistar+pi];
    try
        z0 = fsolve(@(z) f(z), z_guess, optsFS);
    catch
        z0 = z_guess;
    end
    th = z0(1); ph = z0(2);
    theta_star(k) = th;
    phi_star(k) = ph;

    cpt = cos(ph-th); cth = cos(th); sth = sin(th); cpp = cos(ph-phistar);
    J = [-alpha*cpt - gamma*cth, alpha*cpt;
         -rho*sth, -eta*cpp];
    tr(k) = trace(J);
    detJ(k) = det(J);
    ee = eig(J); [~,idx] = max(real(ee)); reEig(k) = real(ee(idx));
end

fig_width = 800; fig_height = 900;
fig_left = 100; fig_bottom = 100;

f1 = figure('Color','w','Position',[fig_left fig_bottom fig_width fig_height]);
set(groot,'defaultAxesLineWidth',1.5);
set(f1,'PaperPositionMode','auto');

tl = tiledlayout(3,1,'TileSpacing','compact','Padding','compact');

nexttile;
plot(lambdas, tr,'-o','Color',[0.1216,0.4667,0.7059],'LineWidth',3); hold on;
yline(0,'--k','LineWidth',2);
xline(lambda_c,'--r','\lambda_c','FontSize',20,'LabelVerticalAlignment','bottom','LineWidth',2);
ylabel('trace(J)');
title('Hopf condition check: trace=0, det>0, trace crosses 0','FontName','Helvetica','FontSize',20,'FontWeight','normal');
xlim([0 1]); ylim([-4 2]);

nexttile;
plot(lambdas, detJ,'-o','Color',[0.1216,0.4667,0.7059],'LineWidth',3); hold on;
yline(0,'--k','LineWidth',2);
xline(lambda_c,'--r','LineWidth',2);
ylabel('det(J)');
xlim([0 1]); ylim([-1 3]);

nexttile;
plot(lambdas, reEig,'-o','Color',[0.1216,0.4667,0.7059],'LineWidth',3); hold on;
yline(0,'--k','LineWidth',2);
xline(lambda_c,'--r','LineWidth',2);
ylabel('max Re(eig(J))'); xlabel('\lambda');
xlim([0 1]); ylim([-1 1]); yticks(-1:1:1);

exportgraphics(f1,'j2_1.svg','ContentType','vector','BackgroundColor','none');

epsi1 = 0.03;
epsi2 = 0.005;
lam_lo = lambda_c - epsi1; lam_hi = lambda_c + epsi2;
vf = @(lam) @(t,z)[alpha*sin(z(2)-z(1)) + lam - gamma*sin(z(1)); rho*cos(z(1)) - eta*sin(z(2)-phistar)];
z_eq = [pi/2; phistar+pi];
z0_lo = z_eq + [0.05;0.04]; z0_hi = z_eq + [-0.05;0.02];
Tspan = [0 250];
[t1,z1] = ode45(vf(lam_lo),Tspan,z0_lo);
[t2,z2] = ode45(vf(lam_hi),Tspan,z0_hi);

f2 = figure('Color','w','Position',[fig_left fig_bottom fig_width fig_height]);
set(f2,'PaperPositionMode','auto');

set(groot,'defaultAxesFontName','Helvetica','defaultAxesFontWeight','normal','defaultAxesFontSize',20);
set(groot,'defaultTextFontName','Helvetica','defaultTextFontWeight','normal','defaultTextFontSize',20);
set(groot,'defaultLegendFontName','Helvetica','defaultLegendFontWeight','normal','defaultLegendFontSize',20);

ax_w = 0.34; ax_h = 0.338; x_gap = 0.09; y_gap = 0.06;

ax1 = subplot(2,2,1);
plot(t1,z1(:,1),'Color',[0.75 0.75 0.75],'LineWidth',7); hold on;
plot(t1,z1(:,2),'Color',[0.1725, 0.8275, 0.3725],'LineWidth',7);
xlabel('t'); ylabel('θ, ϕ'); 
lgd = legend('θ(t)','ϕ(t)'); lgd.Box='off';

ax1.Position = [x_gap 0.56 ax_w ax_h];
xlim([0 200]); ylim([0 4]);
t = title('λ=0.238 (<λ_c)');
pos = get(t,'Position');
pos(2) = pos(2) + 0.05;
set(t,'Position',pos);

ax2 = subplot(2,2,2); hold on;

[th_grid, ph_grid] = meshgrid(linspace(0,3,20), linspace(1,4,20));
lam = lam_lo;
dth = alpha.*sin(ph_grid - th_grid) + lam - gamma.*sin(th_grid);
dph = rho.*cos(th_grid) - eta.*sin(ph_grid - phistar);
hq  = quiver(th_grid, ph_grid, dth, dph, ...
             'Color',[0.7 0.7 0.7], 'AutoScaleFactor',2);

htraj = plot(z1(:,1), z1(:,2), ...
             'Color',[0.2216 0.6667 0.7059], 'LineWidth',8);

heq   = plot(z1(end,1), z1(end,2), 'ko', 'MarkerFaceColor','k', 'MarkerSize',8);

xlabel('θ'); ylabel('ϕ');
xlim([0 3]); ylim([1 4]);

ax2.Position = [0.54 0.56 ax_w ax_h];
t = title('Phase portrait');
pos = get(t,'Position');
pos(2) = pos(2) + 0.1;
set(t,'Position',pos);

lgd2 = legend([hq(1) htraj heq], {'Vector field','Track','Equilibrium'}, 'Location','best');
lgd2.Box = 'off';

ax3 = subplot(2,2,3);
plot(t2,z2(:,1),'Color',[0.75 0.75 0.75],'LineWidth',7); hold on;
plot(t2,z2(:,2),'Color',[0.1725, 0.8275, 0.3725],'LineWidth',7);
xlabel('t'); ylabel('θ, ϕ'); 
lgd = legend('θ(t)','ϕ(t)'); lgd.Box='off';
xlim([0 200]); ylim([0 4]);

ax3.Position = [x_gap 0.073 ax_w ax_h];
t = title('λ=0.273 (>λ_c)');
pos = get(t,'Position');
pos(2) = pos(2) + 0.05;
set(t,'Position',pos);

ax4 = subplot(2,2,4); hold on;

[th_grid2, ph_grid2] = meshgrid(linspace(0,3,20), linspace(1,4,20));
lam = lam_hi;
dth2 = alpha.*sin(ph_grid2 - th_grid2) + lam - gamma.*sin(th_grid2);
dph2 = rho.*cos(th_grid2) - eta.*sin(ph_grid2 - phistar);
hq2  = quiver(th_grid2, ph_grid2, dth2, dph2, ...
              'Color',[0.7 0.7 0.7], 'AutoScaleFactor',2);

htraj2 = plot(z2(:,1), z2(:,2), ...
              'Color',[0.2216 0.6667 0.7059], 'LineWidth',8);

idxTail = t2 > (Tspan(2) - 100);
hlc     = plot(z2(idxTail,1), z2(idxTail,2), ...
               'r--', 'LineWidth',8);

xlabel('θ'); ylabel('ϕ');
xlim([1 2]); ylim([2 3]);
xticks(0:0.5:2); yticks(2:1:4); xtickangle(0); ytickangle(0);

ax4.Position = [0.54 0.073 ax_w ax_h];
t = title('Phase portrait (limit cycle)');
pos = get(t,'Position');
pos(2) = pos(2) + 0.05;
set(t,'Position',pos);

lgd4 = legend([hq2(1) htraj2 hlc], ...
              {'Vector field','Track','Limit cycle'}, ...
              'Location','best');
lgd4.Box = 'off';

exportgraphics(f2,'j2_2.svg','ContentType','vector','BackgroundColor','none');
