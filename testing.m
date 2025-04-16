%screenSize = get(0, 'ScreenSize');
f = figure;
set(f, 'MenuBar', 'none', 'ToolBar', 'none', 'NumberTitle', 'off', 'WindowState', 'fullscreen');
% maybe also add 'WindowState', 'fullscreen'
hold on;
axis equal;
xlim([0, 10]);
ylim([0, 24]);

% salmon: #f04e64 (f04e64) - Z
% orange: #f15632 (f15632) - L
% yellow: #f79031 (f79031) - square
% green : #1e914d (1e914d) - S
% blue  : #2571b9 (2571b9) - line
% purple: #712672 (712672) - T
% navy  : #23336f (23336f) - backwards L 


function rgb = hex2rgb(hex)
    hex = strrep(hex, '#', ''); % Remove the '#' symbol if present
    rgb = sscanf(hex, '%2x%2x%2x', [1 3]) / 255;
end

for x = 0:10
    plot([x x], [0 24], 'k');
end

for y = 0:24
    plot([0 10], [y y], 'k');
end

cellRow = 5;
cellCol = 3;

% cell coordinates: bottom left, bottom right, top right, top lef
% top list is x coordinates, bottom list is y coordinatse
patch([cellCol-1 cellCol cellCol cellCol-1], ...
      [cellRow-1 cellRow-1 cellRow cellRow], ...
      hex2rgb('#40AD5A'), 'FaceAlpha', 1, 'EdgeColor', 'none');

hold off;
set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
    'XTickLabel', [], 'YTickLabel', []);