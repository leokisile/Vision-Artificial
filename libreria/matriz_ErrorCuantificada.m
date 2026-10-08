function MEQ = matriz_ErrorCuantificada(error, rangos)
    % MEQ: Matriz de error cuantificada, calcula una matriz con la clase/rango al que pertence cada elemento
    %   error: Matriz de error
    %   rangos: Arreglo con los limites superiores de cada rango y cada canal

    [m, n, num_canales] = size(error);
    num_rangos = size(rangos, 2);
    MEQ = zeros(m, n, num_canales, 'uint8');

    for k = 1:num_canales
        error_k = error(:, :, k);
        rangos_k = rangos(k, :);
        meq_k = zeros(m, n, 'uint8');

        % Recorre el for de mayor a menor
        for i = num_rangos:-1:1
            meq_k(error_k <= rangos_k(i)) = i;
        end

        MEQ(:, :, k) = meq_k;
    end
end
