clear; clc;


f = figure('Color','w');


%% Ensure aspect ratio (manually set figure size)

t = tiledlayout('Units','centimeters', 'Position',[2 0 40 7]); % 0 7  1 8
t.Padding = 'compact';
t.TileSpacing = 'compact';



load('traj1_1.mat'); % contains x,y,dt
ax=nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;


for i=1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica'); ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica'); axis square;
%xlim([-100, 100]);  
%ylim([-100, 100]);  

xlim([-1 1]);  
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel('');ax.XTick = []; 

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03]; 


% Manually draw border
xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
% Right border
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
% Top border
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');


load('traj1_2.mat'); % contains x,y,dt
ax=nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i=1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica'); ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica'); axis square;
%xlim([-100, 100]);  
%ylim([-100, 100]);  

xlim([-1 1]);  
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel('');ax.XTick = []; 
ylabel('')
ax.YTick = []; 

ax.XAxisLocation = 'bottom';   % X-axis ticks only at the bottom
ax.YAxisLocation = 'left';     % Y-axis ticks only on the left

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03]; 

% Manually draw border
xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
% Right border
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
% Top border
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj1_3.mat'); % contains x,y,dt
ax=nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i=1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica'); ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica'); axis square;
%xlim([-100, 100]);  
%ylim([-100, 100]);  

xlim([-1 1]);  
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel('');ax.XTick = []; 
ylabel('')
ax.YTick = []; 

ax.XAxisLocation = 'bottom';   % X-axis ticks only at the bottom
ax.YAxisLocation = 'left';     % Y-axis ticks only on the left

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03]; 

% Manually draw border
xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
% Right border
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
% Top border
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj1_4.mat'); % contains x,y,dt
ax=nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i=1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica'); ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica'); axis square;
%xlim([-100, 100]);  
%ylim([-100, 100]);  

xlim([-1 1]);  
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel('');ax.XTick = []; 
ylabel('')
ax.YTick = []; 

ax.XAxisLocation = 'bottom';   % X-axis ticks only at the bottom
ax.YAxisLocation = 'left';     % Y-axis ticks only on the left

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03]; 

% Manually draw border
xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
% Right border
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
% Top border
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj1_5.mat'); % contains x,y,dt
ax=nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i=1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica'); ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica'); axis square;
%xlim([-100, 100]);  
%ylim([-100, 100]);  

xlim([-1 1]);  
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));

xlabel('');ax.XTick = []; 
ylabel('')
ax.YTick = []; 
ax.XAxisLocation = 'bottom';   % X-axis ticks only at the bottom
ax.YAxisLocation = 'left';     % Y-axis ticks only on the left

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03]; 

% Manually draw border
xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
% Right border
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
% Top border
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');

load('traj1_6.mat'); % contains x,y,dt
ax=nexttile;
x = 2*(x - min(x(:))) / (max(x(:)) - min(x(:))) - 1;
y = 2*(y - min(y(:))) / (max(y(:)) - min(y(:))) - 1;

for i=1:size(x,2)
    plot(x(:,i), y(:,i),'Color',[0.75 0.75 0.75],'LineWidth',5); hold on;
end
set(gca, 'FontName', 'Helvetica', 'FontSize', 20);
plot(x(end,1:size(x,2)),y(end,1:size(x,2)),'rx','Color',[0.1725, 0.8275, 0.3725],'MarkerSize',20,'LineWidth',5);
plot(x(1),y(1),'-o','Color',[1.0000, 0.6980, 0.3549],'MarkerSize',20,'LineWidth',5);
xlabel('Displacement X','FontSize', 20,'FontName', 'Helvetica'); ylabel('Displacement Y','FontSize', 20,'FontName', 'Helvetica'); axis square;
%xlim([-100, 100]);  
%ylim([-100, 100]);  

xlim([-1 1]);  
ylim([-1 1]);
ax = gca;
numTicks = 3;
xticks(linspace(-1, 1, numTicks));
yticks(linspace(-1, 1, numTicks));


% Add main title (control position using text)
%x = -0.85;  % Horizontally centered
%y = 2.38; % y>1 shifts upward
%  text(x, y, 'Motion trajectory (benchmark)', 'FontSize', 26, 'FontWeight', 'bold', ...
%     'HorizontalAlignment', 'center', 'Units', 'normalized','FontName', 'Helvetica');

xlabel('');ax.XTick = []; 
ylabel('')
ax.YTick = []; 

ax.XAxisLocation = 'bottom';   % X-axis ticks only at the bottom
ax.YAxisLocation = 'left';     % Y-axis ticks only on the left

ax.LineWidth = 1.5;
ax.TickLength = [0.03 0.03]; 

% Manually draw border
xL = ax.XLim;
yL = ax.YLim;
ax.Box = 'off';
hold(ax,'on');
% Right border
plot([xL(2) xL(2)], yL, 'k', 'LineWidth', 1.5);
% Top border
plot(xL, [yL(2) yL(2)], 'k', 'LineWidth', 1.5);
hold(ax,'off');


figWidth = 42.5;
figHeight = 7; % 7 8.5


%figWidth = 27.25;
%figHeight = 4.5; %  4.5 5.5


% Set Paper size to ensure white margins are cropped when exporting
set(f,'PaperUnits','centimeters');
set(f,'PaperSize',[figWidth figHeight]);
set(f,'PaperPosition',[2 0 figWidth figHeight]);
set(f,'PaperPositionMode','manual');  % Do not use auto adjustment
% Export as SVG vector graphics
print(f,'simulate_1.svg','-dsvg','-vector');
