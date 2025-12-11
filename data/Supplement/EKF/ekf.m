clear; clc;
f = figure('Color','w');
f.WindowState = 'maximized';

t = tiledlayout('Units','centimeters', 'Position',[3 0 40 7]);
t.Padding = 'compact';
t.TileSpacing = 'compact';

load('est_params_4_1.mat');
ax = nexttile;
plot(time(2:end), innovs(1,:),'LineWidth',3,'Color',[1.0000, 0.6980, 0.3549]);
hold on
plot(time(2:end), innovs(2,:),'LineWidth',3,'Color',[0.1725, 0.8275, 0.3725]);

xlabel('Time t (s)','FontSize',20,'FontName','Helvetica');
ylabel('Residual e','FontSize',20,'FontName','Helvetica');

ylim([-0.05 0.05]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

xlabel(''); ax.XTick = [];
axis square

load('est_params_4_2.mat');
ax = nexttile;
plot(time(2:end), innovs(1,:),'LineWidth',3,'Color',[1.0000, 0.6980, 0.3549]);
hold on
plot(time(2:end), innovs(2,:),'LineWidth',3,'Color',[0.1725, 0.8275, 0.3725]);

xlabel('Time t (s)','FontSize',20,'FontName','Helvetica');
ylabel('Residual e','FontSize',20,'FontName','Helvetica');

ylim([-0.05 0.05]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

xlabel(''); ax.XTick = [];
ylabel(''); ax.YTick = [];
axis square

load('est_params_4_3.mat');
ax = nexttile;
plot(time(2:end), innovs(1,:),'LineWidth',3,'Color',[1.0000, 0.6980, 0.3549]);
hold on
plot(time(2:end), innovs(2,:),'LineWidth',3,'Color',[0.1725, 0.8275, 0.3725]);

xlabel('Time t (s)','FontSize',20,'FontName','Helvetica');
ylabel('Residual e','FontSize',20,'FontName','Helvetica');

ylim([-0.05 0.05]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

xlabel(''); ax.XTick = [];
ylabel(''); ax.YTick = [];
axis square

load('est_params_4_4.mat');
ax = nexttile;
plot(time(2:end), innovs(1,:),'LineWidth',3,'Color',[1.0000, 0.6980, 0.3549]);
hold on
plot(time(2:end), innovs(2,:),'LineWidth',3,'Color',[0.1725, 0.8275, 0.3725]);

xlabel('Time t (s)','FontSize',20,'FontName','Helvetica');
ylabel('Residual e','FontSize',20,'FontName','Helvetica');

ylim([-0.05 0.05]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

xlabel(''); ax.XTick = [];
ylabel(''); ax.YTick = [];
axis square

load('est_params_4_5.mat');
ax = nexttile;
plot(time(2:end), innovs(1,:),'LineWidth',3,'Color',[1.0000, 0.6980, 0.3549]);
hold on
plot(time(2:end), innovs(2,:),'LineWidth',3,'Color',[0.1725, 0.8275, 0.3725]);

xlabel('Time t (s)','FontSize',20,'FontName','Helvetica');
ylabel('Residual e','FontSize',20,'FontName','Helvetica');

ylim([-0.05 0.05]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

xlabel(''); ax.XTick = [];
ylabel(''); ax.YTick = [];
axis square

load('est_params_4_6.mat');
ax = nexttile;
plot(time(2:end), innovs(1,:),'LineWidth',3,'Color',[1.0000, 0.6980, 0.3549]);
hold on
plot(time(2:end), innovs(2,:),'LineWidth',3,'Color',[0.1725, 0.8275, 0.3725]);

xlabel('Time t (s)','FontSize',20,'FontName','Helvetica');
ylabel('Residual e','FontSize',20,'FontName','Helvetica');

ylim([-0.05 0.05]);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

xlabel(''); ax.XTick = [];
ylabel(''); ax.YTick = [];
axis square

figWidth = 43.5;
figHeight = 7;

set(f,'PaperUnits','centimeters');
set(f,'PaperSize',[figWidth figHeight]);
set(f,'PaperPosition',[0 0 figWidth figHeight]);
set(f,'PaperPositionMode','manual');

print(f,'simulate_ekf_4.svg','-dsvg','-vector');
