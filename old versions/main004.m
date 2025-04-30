% make a window

FIELDHEIGHT = 24;
FIELDWIDTH = 10;

field = zeros(FIELDHEIGHT, FIELDWIDTH);
game.field = field;

f = figure;
set(f, 'MenuBar', 'none', 'ToolBar', 'none', 'NumberTitle', 'off', 'WindowState', 'fullscreen', ...
    'KeyPressFcn', @keyHandler, 'CloseRequestFcn', @cleanup);

game.timer = timer('ExecutionMode', 'fixedSpacing', ...
                   'Period', 0.5, ...
                   'TimerFcn', @(~,~) autoDrop());

guidata(f, game); % store data in the figure

% Start the automatic drop
start(game.timer);

% Drop function (auto or manual)
function autoDrop()
    f = gcf;
    game = guidata(f);
    disp('Auto drop');
    game.currentPiece(:,1) = game.currentPiece(:,1) - 1; % move down
    redraw(game);
    guidata(f, game);
end

function keyHandler(~, event)
    f=gcf;
    game = guidata(f);

    switch event.Key
        case 'downarrow'
            disp('Manual drop');
            % Move down manually
            game.currentPiece(:,1) = game.currentPiece(:,1) - 1;
            % Reset timer
            stop(game.timer);
            start(game.timer);
    end

    redraw(game);
    guidata(f, game);
end

function cleanup(~, ~)
    f=gcf;
    game = guidata(f);
    stop(game.timer);
    delete(game.timer);
    delete(f);
end

% turn hex codes into matlab-usable RGB value triplets
function rgb = hex2rgb(hex)
    hex = strrep(hex, ' #', '');
    hexChar = convertStringsToChars(hex);

    if length(hexChar) == 3
        hex = [hexChar(1), hexChar(1), hexChar(2), hexChar(2), hexChar(3), hexChar(3)];
    end

    if strlength(hex) ~= 6
        error("Invalid hex color code: %s", hex);
    end

    rgb = reshape(sscanf(hex, '%2x%2x%2x', [1 3]) / 255, 1, 3);
end

function redraw(game)
    % Reset field
    tempField = game.field;

    % Overlay current piece
    for i = 1:4
        y = game.currentPiece(i,1);
        x = game.currentPiece(i,2);
        if y >= 1 && y <= size(tempField,1) && x >= 1 && x <= size(tempField,2)
            tempField(y, x) = game.pieceID;
        end
    end

    % Redraw the matrix
    imagesc(0.5:9.5, 0.5:23.5, tempField);
    clim([0 7]);

    % Reset colormap (in case MATLAB resets it)
    pieceColours = [ ...
        " #2571b9"; " #23336f"; " #f15632"; ...
        " #712672"; " #f79031"; " #f04e64"; " #1e914d" ];

    colourmapArray = [1, 1, 1];
    for i = 1:length(pieceColours)
        colourmapArray = [colourmapArray; hex2rgb(pieceColours(i))];
    end
    colormap(colourmapArray);

    % Formatting
    axis equal;
    xlim([0, 10]);
    ylim([0, 24]);
    set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
        'XTickLabel', [], 'YTickLabel', [], 'XColor', '#ddd', 'YColor', "#ddd");
end



% make gridlines
for x = 0:FIELDWIDTH
    plot([x x], [0 FIELDHEIGHT], "Color", "#ddd");
end

for y = 0:FIELDHEIGHT
    plot([0 FIELDWIDTH], [y y], "Color", "#ddd");
end

% tetris components - field and pieces


pieceColours = [
    " #2571b9"; ... % line
    " #23336f"; ... % backwards L 
    " #f15632"; ... % L
    " #712672"; ... % T
    " #f79031"; ... % square
    " #f04e64"; ... % Z
    " #1e914d"     % S
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

%piecesSize = size(initialPieces);

game.currentPiece = [[0, 0]; [0, 0]; [0, 0]; [0, 0]];

randomPiece = randi([1, size(pieceCoords, 3)], 1, 1);

%game.currentPiece = currentPiece;
game.pieceID = randomPiece;

%colourCell(gca, cellCol, cellRow, "#333")

% TESTING SECTION



for i=1:4
    yCoord = 25-pieceCoords(i, 1, randomPiece);
    xCoord = pieceCoords(i, 2, randomPiece)+3;
    game.currentPiece(i, 1) = yCoord;
    game.currentPiece(i, 2) = xCoord;
    game.field(yCoord, xCoord) = randomPiece;
end


imagesc(0.5:9.5, 0.5:23.5, game.field);  % Center cells on integer grid
clim([0 7]);


colourmapArray = [1, 1, 1];
for i = 1:length(pieceColours)
    colourmapArray = [colourmapArray; hex2rgb(pieceColours(i))];
end
colormap(colourmapArray)

hold off;
set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
    'XTickLabel', [], 'YTickLabel', [], 'XColor', '#ddd', 'YColor', "#ddd");


%axis equal;
%xlim([0 10]); ylim([0 24]);
%set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
%         'XTickLabel', []);
