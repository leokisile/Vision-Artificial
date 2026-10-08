function vaciar = vaciar_img(img)
    % vaciar_img: Crea una copia de la imagen, manteniendo unicamente su primera fila y columna
    %   img: Matriz de la imagen original

    vaciar = zeros(size(img), class(img));

    vaciar(1, :, :) = img(1, :, :); % Fila
    vaciar(:, 1, :) = img(:, 1, :); % Columna
end
