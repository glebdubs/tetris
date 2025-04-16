pieceCoords        = [[1, 1]; [1, 2]; [1, 3]; [1, 4]];
pieceCoords(:,:,2) = [[1, 1]; [1, 2]; [1, 3]; [2, 3]];
pieceCoords(:,:,3) = [[2, 1]; [2, 2]; [2, 3]; [1, 3]];
pieceCoords(:,:,4) = [[1, 1]; [1, 2]; [1, 3]; [2, 2]];
pieceCoords(:,:,5) = [[1, 2]; [1, 3]; [2, 2]; [2, 3]];
pieceCoords(:,:,6) = [[1, 2]; [1, 3]; [2, 1]; [2, 2]];
pieceCoords(:,:,7) = [[1, 2]; [1, 3]; [2, 3]; [2, 4]];

arrSize = size(pieceCoords);

randomPiece = randi([1, arrSize(3)], 1, 1);

for i=1:arrSize(1)
    fprintf("(")
    for j = 1:2
        fprintf(" %d ", pieceCoords(i, j, randomPiece));
    end
    fprintf(")\n");
end


str = ["Mercury","Gemini","Apollo";
       "Skylab","Skylab B","ISS"];

disp(str(3))