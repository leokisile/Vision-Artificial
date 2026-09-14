function centroides = calcular_centroides(clases)
    % CALCULAR_CENTROIDES: Calcula el centroide de n clases
    %   clases: Un celdario (cell array) con las matrices de las clases.
    %   centroides: Matriz donde cada columna representa el centroide [cx; cy] de cada clase.

    centroides = zeros(2, length(clases));

    for i = 1:length(clases)
        c_actual = clases{i};

        % Calculamos el promedio para x y para y usando el numero de columnas
        cx = (1 / size(c_actual, 2)) * sum(c_actual(1, :));
        cy = (1 / size(c_actual, 2)) * sum(c_actual(2, :));

        % Almacenamos el centroide en su respectiva columna
        centroides(:, i) = [cx; cy];
    end
end
