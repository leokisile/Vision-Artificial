function error_reconstruido = inversa_MEQ(MEQ, rangos, minimo)
    % descuantizar_MEQ: Reconstruye la matriz de error asignando el promedio del rango
    %   MEQ: Matriz con los índices de clase/rango [1, 2, ..., combinaciones]
    %   rangos: Matriz o vector con los límites superiores de los rangos
    %   minimo: Vector con los valores mínimos originales por canal

    [m, n, num_canales] = size(MEQ);
    num_rangos = size(rangos, 2);
    error_reconstruido = zeros(m, n, num_canales);

    for k = 1:num_canales
        rangos_k = rangos(k, :);
        min_k = minimo(k);

        % 1. Obtener límites inferiores desplazando los límites superiores
        lim_inferiores = [min_k, rangos_k(1:end-1)];
        lim_superiores = rangos_k;

        % 2. Calcular los promedios/centros de cada rango (Representantes)
        promedios_rangos = (lim_inferiores + lim_superiores) / 2;

        % 3. Mapear cada índice en MEQ a su valor promedio correspondiente
        meq_k = MEQ(:, :, k);
        error_k = zeros(m, n);

        for i = 1:num_rangos
            error_k(meq_k == i) = promedios_rangos(i);
        end

        error_reconstruido(:, :, k) = error_k;
    end
end
