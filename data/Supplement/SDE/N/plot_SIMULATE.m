clear; clc;
A = {'N=49','N=51','N=53','N=55','N=57','N=59'};

f = figure('Color','w');

t = tiledlayout('Units','centimeters', 'Position',[2 1 40 8]);
t.Padding = 'compact';
t.TileSpacing = 'compact';

load('traj5_1.mat');
ax = nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i = 1:size(x,2)
    plot(x(:,i), y(:,i), 'Color',[0.75 0.75 0.75], 'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)), y(end,1:size(x,2)), 'rx', 'Color',[0.1725, 0.8275, 0.3725], 'MarkerSize',20, 'LineWidth',5);
plot(x(1), y(1), '-o', 'Color',[1.0000, 0.6980, 0.3549], 'MarkerSize',20, 'LineWidth',5);
xlabel('Displacement X', 'FontSize', 20, 'FontName', 'Helvetica');
ylabel('Displacement Y', 'FontSize', 20, 'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

title(A(1));

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj5_2.mat');
ax = nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i = 1:size(x,2)
    plot(x(:,i), y(:,i), 'Color',[0.75 0.75 0.75], 'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)), y(end,1:size(x,2)), 'rx', 'Color',[0.1725, 0.8275, 0.3725], 'MarkerSize',20, 'LineWidth',5);
plot(x(1), y(1), '-o', 'Color',[1.0000, 0.6980, 0.3549], 'MarkerSize',20, 'LineWidth',5);
xlabel('Displacement X', 'FontSize', 20, 'FontName', 'Helvetica');
ylabel('Displacement Y', 'FontSize', 20, 'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

ylabel('');
ax.YTick = [];

ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

title(A(2));

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj5_3.mat');
ax = nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i = 1:size(x,2)
    plot(x(:,i), y(:,i), 'Color',[0.75 0.75 0.75], 'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)), y(end,1:size(x,2)), 'rx', 'Color',[0.1725, 0.8275, 0.3725], 'MarkerSize',20, 'LineWidth',5);
plot(x(1), y(1), '-o', 'Color',[1.0000, 0.6980, 0.3549], 'MarkerSize',20, 'LineWidth',5);
xlabel('Displacement X', 'FontSize', 20, 'FontName', 'Helvetica');
ylabel('Displacement Y', 'FontSize', 20, 'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

ylabel('');
ax.YTick = [];

ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

title(A(3));

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj5_4.mat');
ax = nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i = 1:size(x,2)
    plot(x(:,i), y(:,i), 'Color',[0.75 0.75 0.75], 'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)), y(end,1:size(x,2)), 'rx', 'Color',[0.1725, 0.8275, 0.3725], 'MarkerSize',20, 'LineWidth',5);
plot(x(1), y(1), '-o', 'Color',[1.0000, 0.6980, 0.3549], 'MarkerSize',20, 'LineWidth',5);
xlabel('Displacement X', 'FontSize', 20, 'FontName', 'Helvetica');
ylabel('Displacement Y', 'FontSize', 20, 'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

ylabel('');
ax.YTick = [];

ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

title(A(4));

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj5_5.mat');
ax = nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i = 1:size(x,2)
    plot(x(:,i), y(:,i), 'Color',[0.75 0.75 0.75], 'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)), y(end,1:size(x,2)), 'rx', 'Color',[0.1725, 0.8275, 0.3725], 'MarkerSize',20, 'LineWidth',5);
plot(x(1), y(1), '-o', 'Color',[1.0000, 0.6980, 0.3549], 'MarkerSize',20, 'LineWidth',5);
xlabel('Displacement X', 'FontSize', 20, 'FontName', 'Helvetica');
ylabel('Displacement Y', 'FontSize', 20, 'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

ylabel('');
ax.YTick = [];
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

title(A(5));

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj5_6.mat');
ax = nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i = 1:size(x,2)
    plot(x(:,i), y(:,i), 'Color',[0.75 0.75 0.75], 'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)), y(end,1:size(x,2)), 'rx', 'Color',[0.1725, 0.8275, 0.3725], 'MarkerSize',20, 'LineWidth',5);
plot(x(1), y(1), '-o', 'Color',[1.0000, 0.6980, 0.3549], 'MarkerSize',20, 'LineWidth',5);
xlabel('Displacement X', 'FontSize', 20, 'FontName', 'Helvetica');
ylabel('Displacement Y', 'FontSize', 20, 'FontName', 'Helvetica');
axis square;

xlim([-1 1]);
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

ylabel('');
ax.YTick = [];

ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03];

title(A(6));

xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

figWidth = 42.5;
figHeight = 9.5;

set(f,'PaperUnits','centimeters');
set(f,'PaperSize',[figWidth figHeight]);
set(f,'PaperPosition',[2 0 figWidth figHeight]);
set(f,'PaperPositionMode','manual');
print(f,'simulate_5.svg','-dsvg','-vector');
