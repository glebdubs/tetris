% make a window

f = figure;
set(f, 'MenuBar', 'none', 'ToolBar', 'none', 'NumberTitle', 'off', 'WindowState', 'fullscreen');

hold on;
axis equal;

FIELDHEIGHT = 24;
FIELDWIDTH = 10;

xlim([0, FIELDWIDTH]);
ylim([0, FIELDHEIGHT]);

% turn hex codes into matlab-usable RGB value triplets
function rgb = hex2rgb(hex)
    hex = strrep(hex, '#', '');
    hexChar = convertStringsToChars(hex);

    if length(hexChar) == 3
        hex = [hexChar(1), hexChar(1), hexChar(2), hexChar(2), hexChar(3), hexChar(3)];
    end

    if strlength(hex) ~= 6
        error("Invalid hex color code: %s", hex);
    end

    rgb = reshape(sscanf(hex, '%2x%2x%2x', [1 3]) / 255, 1, 3);
end


function colourCell(ax, x, y, hex)
    axes(ax)
    rgb = hex2rgb(hex);
    patch([x-1, x, x, x-1], [y-1, y-1, y, y], rgb, 'FaceAlpha', 1, 'EdgeColor', 'none');
end


% make gridlines
for x = 0:FIELDWIDTH
    plot([x x], [0 FIELDHEIGHT], "Color", "#ddd");
end

for y = 0:FIELDHEIGHT
    plot([0 FIELDWIDTH], [y y], "Color", "#ddd");
end

% tetris components - field and pieces

field = zeros(FIELDHEIGHT, FIELDWIDTH);

pieceColours = [
    "#2571b9"; ... % line
    "#23336f"; ... % backwards L 
    "#f15632"; ... % L
    "#712672"; ... % T
    "#f79031"; ... % square
    "#f04e64"; ... % Z
    "#1e914d"     % S
];

initialPieces = [ % likely not going to need this at all
    [1, 1, 1, 1, 0, 0, 0, 0]; %  line
    [1, 1, 1, 0, 0, 0, 1, 0]; %  backwards L
    [0, 0, 1, 0, 1, 1, 1, 0]; %  L
    [1, 1, 1, 0, 0, 1, 0, 0]; %  T
    [0, 1, 1, 0, 0, 1, 1, 0]; %  square
    [0, 1, 1, 0, 1, 1, 0, 0]; %  Z
    [0, 1, 1, 0, 0, 0, 1, 1]  %  S
];

pieceCoords        = [[1, 1]; [1, 2]; [1, 3]; [1, 4]]; %  line
pieceCoords(:,:,2) = [[1, 1]; [1, 2]; [1, 3]; [2, 3]]; %  backwards L
pieceCoords(:,:,3) = [[2, 1]; [2, 2]; [2, 3]; [1, 3]]; %  L
pieceCoords(:,:,4) = [[1, 1]; [1, 2]; [1, 3]; [2, 2]]; %  T
pieceCoords(:,:,5) = [[1, 2]; [1, 3]; [2, 2]; [2, 3]]; %  square
pieceCoords(:,:,6) = [[1, 2]; [1, 3]; [2, 1]; [2, 2]]; %  Z
pieceCoords(:,:,7) = [[1, 2]; [1, 3]; [2, 3]; [2, 4]]; %  S

piecesSize = size(initialPieces);

cellRow = 5;
cellCol = 3;

%colourCell(gca, cellCol, cellRow, "#333")

hold off;
set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
    'XTickLabel', [], 'YTickLabel', [], 'XColor', '#ddd', 'YColor', "#ddd");

% TESTING SECTION

randomPiece = randi([1, piecesSize(1)], 1, 1);

for i=1:4
    xCoord = pieceCoords(i, 2, randomPiece)+3;
    yCoord = pieceCoords(i, 1, randomPiece);
    colourCell(gca, xCoord, 25-yCoord, pieceColours(randomPiece));
end

%patch([cellCol-1 cellCol cellCol cellCol-1], ...
%      [cellRow-1 cellRow-1 cellRow cellRow], ...
%      hex2rgb('#40AD5A'), 'FaceAlpha', 1, 'EdgeColor', 'none');
