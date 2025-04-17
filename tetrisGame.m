function tetrisGame
    % Setup figure
    fig = figure('KeyPressFcn', @keyHandler, ...
                 'Name', 'MATLAB Tetris', ...
                 'NumberTitle', 'off', ...
                 'CloseRequestFcn', @cleanup);

    % Initialize game state
    game.piecePosition = [5, 20]; % arbitrary starting position
    game.timer = timer('ExecutionMode', 'fixedSpacing', ...
                       'Period', 0.5, ...
                       'TimerFcn', @(~,~) autoDrop());

    guidata(fig, game); % store data in the figure

    % Start the automatic drop
    start(game.timer);

    % Drop function (auto or manual)
    function autoDrop()
        game = guidata(fig);
        disp('Auto drop');
        game.piecePosition(2) = game.piecePosition(2) - 1; % move down
        guidata(fig, game);
        % Redraw board here...
    end

    function keyHandler(~, event)
        game = guidata(fig);

        switch event.Key
            case 'downarrow'
                disp('Manual drop');
                % Move down manually
                game.piecePosition(2) = game.piecePosition(2) - 1;
                % Reset timer
                stop(game.timer);
                start(game.timer);
        end

        guidata(fig, game);
        % Redraw board here...
    end

    function cleanup(~, ~)
        game = guidata(fig);
        stop(game.timer);
        delete(game.timer);
        delete(f);
    end
end
