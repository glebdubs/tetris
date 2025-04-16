clc
field = zeros(24, 10);

initialPieces = [
    [1, 1, 1, 1, 0, 0, 0, 0]; % line
    [2, 2, 2, 0, 0, 0, 2, 0]; % backwards L
    [0, 0, 3, 0, 3, 3, 3, 0]; % L
    [4, 4, 4, 0, 0, 4, 0, 0]; % T
    [0, 5, 5, 0, 0, 5, 5, 0]; % square
    [0, 6, 6, 0, 6, 6, 0, 0]; % Z
    [0, 7, 7, 0, 0, 0, 7, 7] % S
];

pieceCoords = [
    [[1, 1]; [1, 2]; [1, 3]; [1, 4]];
    [[1, 1]; [1, 2]; [1, 3]; [2, 3]];
    [[2, 1]; [2, 2]; [2, 3]; [1, 3]];
    [[1, 1]; [1, 2]; [1, 3]; [2, 2]];
    [[1, 2]; [1, 3]; [2, 2]; [2, 3]];
    [[1, 2]; [1, 3]; [2, 1]; [2, 2]];
    [[1, 2]; [1, 3]; [2, 3]; [2, 4]]
];
initSize = size(initialPieces);
pieceCount = initSize(1);

playing = true;

%while playing % main game loop
    % add a piece to the top
    nextPiece = randi([1, pieceCount], 1, 1);
    counter = 1;
    for i = 1:2
        for j = 1:4
            field(i, j+3) = initialPieces(nextPiece, counter);
            counter = counter + 1;
        end
    end
    disp(field);
    %input("bruh")
%end