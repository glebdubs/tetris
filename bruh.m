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

% Create a 24x10 matrix (0=no color, 1=color)
colorMatrix = zeros(24, 10);
colorMatrix(1, 1) = 2;  % Mark cell (5,3)

figure;
imagesc(0.5:9.5, 0.5:23.5, colorMatrix);  % Center cells on integer grid
colourmapArray = [1 1 1; 1 0 0; 0 1 0];
colormap(colourmapArray);  % [white; red]
axis equal;
xlim([0 10]); ylim([0 24]);
set(gca, 'XTick', 0:10, 'YTick', 0:24, 'XGrid', 'on', 'YGrid', 'on', ...
         'XTickLabel', []);
