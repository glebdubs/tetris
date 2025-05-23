clc;clear;
% INITIALISATION

FIELDHEIGHT = 24;
FIELDWIDTH = 10;

game.field = zeros(FIELDHEIGHT, FIELDWIDTH);

f = figure;
set(f, 'MenuBar', 'none', 'ToolBar', 'none', 'NumberTitle', 'off', 'WindowState', 'fullscreen', ...
    'KeyPressFcn', @keyHandler, 'CloseRequestFcn', @cleanup);

game.timer = timer('ExecutionMode', 'fixedSpacing', ...
                   'Period', 0.5, ...
                   'TimerFcn', @(~,~) autoDrop());

game.pieceCoords        = [[1, 1]; [1, 2]; [1, 3]; [1, 4]]; %  line
game.pieceCoords(:,:,2) = [[1, 1]; [1, 2]; [1, 3]; [2, 3]]; %  backwards L
game.pieceCoords(:,:,3) = [[2, 1]; [2, 2]; [2, 3]; [1, 3]]; %  L
game.pieceCoords(:,:,4) = [[1, 1]; [1, 2]; [1, 3]; [2, 2]]; %  T
game.pieceCoords(:,:,5) = [[1, 2]; [1, 3]; [2, 2]; [2, 3]]; %  square
game.pieceCoords(:,:,6) = [[1, 2]; [1, 3]; [2, 1]; [2, 2]]; %  S
game.pieceCoords(:,:,7) = [[1, 2]; [1, 3]; [2, 3]; [2, 4]]; %  Z

game.currentCoords = [0, 3];

game.pieceVariations          = [[1, 2]; [2, 2]; [3, 2]; [4, 2]]; % line ALLGOOD
game.pieceVariations(:,:,1,2) = [[2, 1]; [2, 2]; [2, 3]; [2, 4]];
game.pieceVariations(:,:,1,3) = [[1, 3]; [2, 3]; [3, 3]; [4, 3]];
game.pieceVariations(:,:,1,4) = [[3, 1]; [3, 2]; [3, 3]; [3, 4]];

game.pieceVariations(:,:,2,1) = [[1, 2]; [2, 2]; [3, 2]; [3, 3]]; % backwards L allgood
game.pieceVariations(:,:,2,2) = [[2, 1]; [2, 2]; [2, 3]; [3, 1]];
game.pieceVariations(:,:,2,3) = [[1, 1]; [2, 2]; [3, 2]; [1, 2]];
game.pieceVariations(:,:,2,4) = [[2, 1]; [2, 2]; [2, 3]; [1, 3]];

game.pieceVariations(:,:,3,1) = [[1, 2]; [2, 2]; [3, 2]; [3, 1]]; % L allgood
game.pieceVariations(:,:,3,2) = [[1, 1]; [2, 1]; [2, 2]; [2, 3]];
game.pieceVariations(:,:,3,3) = [[1, 2]; [2, 2]; [3, 2]; [1, 3]];
game.pieceVariations(:,:,3,4) = [[2, 1]; [2, 2]; [2, 3]; [3, 3]];

game.pieceVariations(:,:,4,1) = [[1, 2]; [2, 2]; [2, 3]; [3, 2]]; % T ALLGOOD
game.pieceVariations(:,:,4,2) = [[2, 1]; [2, 2]; [2, 3]; [3, 2]];
game.pieceVariations(:,:,4,3) = [[1, 2]; [2, 2]; [3, 2]; [2, 1]];
game.pieceVariations(:,:,4,4) = [[1, 2]; [2, 2]; [2, 3]; [2, 1]];

game.pieceVariations(:,:,5,1) = [[1, 1]; [1, 2]; [2, 1]; [2, 2]]; % square ALLGOOD
game.pieceVariations(:,:,5,2) = [[1, 1]; [1, 2]; [2, 1]; [2, 2]];
game.pieceVariations(:,:,5,3) = [[1, 1]; [1, 2]; [2, 1]; [2, 2]];
game.pieceVariations(:,:,5,4) = [[1, 1]; [1, 2]; [2, 1]; [2, 2]];

game.pieceVariations(:,:,6,1) = [[1, 2]; [2, 2]; [2, 1]; [3, 1]]; % S allgood
game.pieceVariations(:,:,6,2) = [[1, 1]; [1, 2]; [2, 2]; [2, 3]];
game.pieceVariations(:,:,6,3) = [[1, 3]; [2, 2]; [2, 3]; [3, 2]];
game.pieceVariations(:,:,6,4) = [[2, 1]; [2, 2]; [3, 2]; [3, 3]];

game.pieceVariations(:,:,7,1) = [[1, 1]; [2, 1]; [2, 2]; [3, 2]]; % Z 
game.pieceVariations(:,:,7,2) = [[1, 2]; [1, 3]; [2, 1]; [2, 2]];
game.pieceVariations(:,:,7,3) = [[1, 2]; [2, 2]; [2, 3]; [3, 3]];
game.pieceVariations(:,:,7,4) = [[2, 2]; [2, 3]; [3, 1]; [3, 2]];


game.currentPiece = [[0, 0]; [0, 0]; [0, 0]; [0, 0]];

game.pieceID = randi([1, size(game.pieceCoords, 3)], 1, 1);
game.variation = 1;

for i=1:4
    game.currentPiece(i, 1) = game.pieceVariations(i, 1, game.pieceID, 1);
    game.currentPiece(i, 2) = game.pieceVariations(i, 2, game.pieceID, 1);
    %game.field(yCoord, xCoord) = game.pieceID;
end

% store data in the figure
guidata(f, game); 


imagesc(0.5:9.5, 0.5:23.5, game.field);  % Center cells on integer grid
clim([0 7]);


pieceColours = [
    " #2571b9"; ... % line
    " #23336f"; ... % backwards L 
    " #f15632"; ... % L
    " #712672"; ... % T
    " #f79031"; ... % square
    " #1e914d"; ... % S
    " #f04e64"      % Z
];

colourmapArray = [1, 1, 1];
for i = 1:length(pieceColours)
    colourmapArray = [colourmapArray; hex2rgb(pieceColours(i))];
end
colormap(colourmapArray)


hold off;
set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
    'XTickLabel', [], 'YTickLabel', [], 'XColor', '#ddd', 'YColor', "#ddd");


% store data in the figure
guidata(f, game); 

% Start the automatic drop
start(game.timer);


%% FUNCTIONS

function slam()
    f = gcf;
    game = guidata(f);
    validSpotFound = false;
    counter = 1;
    while ~validSpotFound


        valueWorks = true;

        for j = 1:4
            yCoord = game.currentPiece(j, 1) + game.currentCoords(1)+counter;
            xCoord = game.currentPiece(j, 2) + game.currentCoords(2);
            if yCoord >= 25
                fprintf("yCoord <= 1;\n")
                valueWorks = false;
            elseif game.field(yCoord, xCoord) ~= 0
                fprintf("hit something\n")
                valueWorks = false;
            end
        end
        fprintf("counter: %i\n", counter);

        if ~valueWorks
            fprintf("validSpotFound = true;\n")
            validSpotFound = true;
        else
            fprintf("counter = counter+1;\n")
            counter = counter + 1;
        end

        if counter >= 25
            validSpotFound = true;
            disp("exit");
        end

    end

    game.currentCoords(1) = game.currentCoords(1) + counter-1;
    guidata(f, game);
    redraw(game);

end
function tryRotateCCW()
    f = gcf;
    game = guidata(f);
    targetVar = game.variation + 1;
    if targetVar == 5
        targetVar = 1;
    end
    canRotate = true;
    fprintf("\n\n\n\n\n");

    for i = 1:4
        newXCoord = game.pieceVariations(i,1,game.pieceID,targetVar) + game.currentCoords(1);
        newYCoord = game.pieceVariations(i,2,game.pieceID,targetVar) + game.currentCoords(2);
        fprintf(" current coordinates: (%i, %i)\n", game.currentPiece(i, 1) + game.currentCoords(1), game.currentPiece(i, 2) + game.currentCoords(2))
        fprintf(" new coordinates: (%i, %i)\n", newXCoord, newYCoord);

        if game.field(newXCoord, newYCoord) ~= 0
            canRotate = false;
        end
    end

    fprintf("\n\ncanRotate: %s \n", string(canRotate));

    if canRotate
        game.variation = targetVar;
        fprintf("game.variation: %i \n", game.variation);
        game.currentPiece(:,1) = game.pieceVariations(:, 1, game.pieceID, targetVar);
        game.currentPiece(:,2) = game.pieceVariations(:, 2, game.pieceID, targetVar);
        guidata(f, game);
        redraw(game);
    end
    %finish rotation script
end




function tryMoveRight()
    f = gcf;
    game = guidata(f);
    canMove = true;

    for i = 1:4
        if game.currentPiece(i, 2)+game.currentCoords(2) ~= 10
            if game.field(game.currentPiece(i, 1)+game.currentCoords(1), game.currentPiece(i, 2)+game.currentCoords(2)+1) ~= 0
                canMove = false;
            end
        else
            canMove = false;
        end
    end

    if canMove
        %game.currentPiece(:,2) = game.currentPiece(:,2)+1; % move right
        game.currentCoords(2) = game.currentCoords(2)+1;
        guidata(f, game);
        redraw(game);
    end
end

function tryMoveLeft()
    f = gcf;
    game = guidata(f);
    canMove = true;

    for i = 1:4
        if game.currentPiece(i, 2)+game.currentCoords(2) ~= 1
            if game.field(game.currentPiece(i, 1)+game.currentCoords(1), game.currentPiece(i, 2)+game.currentCoords(2)-1) ~= 0
                canMove = false;
            end
        else
            canMove = false;
        end
    end

    if canMove
        %game.currentPiece(:,2) = game.currentPiece(:,2)-1; % move left
        game.currentCoords(2) = game.currentCoords(2)-1;
        guidata(f, game);
        redraw(game);
    end
end

function tryMoveDown()
    f = gcf;
    game = guidata(f);
    canMove = true;

    for i = 1:4
        if game.currentPiece(i, 1)+game.currentCoords(1) ~= 24
            if game.field(game.currentPiece(i, 1)+game.currentCoords(1)+1, game.currentPiece(i, 2)+game.currentCoords(2)) ~= 0
                canMove = false;
            end
        else
            canMove = false;
        end
    end

    if canMove
        %game.currentPiece(:,1) = game.currentPiece(:,1) + 1; % move down
        game.currentCoords(1) = game.currentCoords(1)+1;
        guidata(f, game);
        redraw(game);
    else
        for i = 1:4
            y=game.currentPiece(i, 1) + game.currentCoords(1);
            x=game.currentPiece(i, 2) + game.currentCoords(2);
            %fprintf("game.field(%d, %d) = %d\n", y, x, game.pieceID);
            game.field(y, x) = game.pieceID;
        end
        %disp("making another piece!");
        guidata(f, game);
        nextMove();
    end
    %guidata(f, game);
    %redraw(game);
end

function nextMove()
    f=gcf;
    game = guidata(f);
    %disp('Current Piece before:');
    %disp(game.currentPiece);

    game.pieceID = randi([1, size(game.pieceCoords, 3)], 1, 1);
    %canPlayOn = true;
    for i=1:4
        game.currentPiece(i, 1) = game.pieceVariations(i, 1, game.pieceID, 1);
        game.currentPiece(i, 2) = game.pieceVariations(i, 2, game.pieceID, 1);
        game.currentCoords = [0, 3];
        game.variation = 1;
        %game.field(yCoord, xCoord) = game.pieceID;
        if game.field(game.currentPiece(i, 1), game.currentPiece(i, 2)) ~= 0
            %canPlayOn = false;
        end
    end
    guidata(f, game);
    redraw(game);
    %disp('Current Piece after:');
    %disp(game.currentPiece);
end

% Drop function (auto or manual)
function autoDrop()
    %f = gcf;
    %game = guidata(f);
    %disp('Auto drop');
    %game.currentPiece(:,1) = game.currentPiece(:,1) + 1; % move down
    %redraw(game);
    %guidata(f, game);
    tryMoveDown();
end

function keyHandler(~, event)
    switch event.Key
        case 'downarrow'
            %disp('Manual drop');
            % Move down manually
            tryMoveDown();
            f=gcf;
            game = guidata(f);
            %game.currentPiece(:,1) = game.currentPiece(:,1) + 1;
            % Reset timer
            stop(game.timer);
            start(game.timer);
            guidata(f, game);
            redraw(game);
        case 'rightarrow'
            tryMoveRight();

        case 'leftarrow'
            tryMoveLeft();

        case 'uparrow'
            tryRotateCCW();
        case 'space'
            slam()
    end
end

function cleanup(~, ~)
    f=gcf;
    game = guidata(f);
    stop(game.timer);
    delete(game.timer);
    delete(f);
end

hold on;
axis equal;


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

    persistent imgHandle;

    tempField = game.field;

    for i = 1:4
        y = game.currentPiece(i, 1)+game.currentCoords(1);
        x = game.currentPiece(i, 2)+game.currentCoords(2);
        if y>=1 && y <= size(tempField, 1) && x >= 1 && x <= size(tempField, 2)
            tempField(y, x) = game.pieceID;
        end
    end

    if isempty(imgHandle) || ~isvalid(imgHandle)
        % First-time setup
        imgHandle = imagesc(0.5:9.5, 0.5:23.5, tempField);
        clim([0 7]);

        pieceColours = [ ...
            " #2571b9"; " #23336f"; " #f15632"; ...
            " #712672"; " #f79031"; " #f04e64"; " #1e914d" ];

        colourmapArray = [1, 1, 1];
        for i = 1:length(pieceColours)
            colourmapArray = [colourmapArray; hex2rgb(pieceColours(i))];
        end
        colormap(colourmapArray);

        axis equal;
        xlim([0, 10]);
        ylim([0, 24]);
        set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
            'XTickLabel', [], 'YTickLabel', [], 'XColor', '#ddd', 'YColor', "#ddd");
    else
        % Only update image data
        imgHandle.CData = tempField;
    end
end
