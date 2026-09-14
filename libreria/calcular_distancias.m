function distancias = calcular_distancias(vector, valores)
    % CALCULAR_DISTANCIAS: Calcula la distancia de un vector a una lista de valores dadas
    %   vector: Vector con cordenadas [vx, vy]
    %   valores: Matriz numerica donde cada columna representa una coordenada [cx; cy] de cada clase.

    distancias = zeros(1, size(valores,2));

    for i = 1:size(valores,2)
        v_actual = valores(:,i);

        % Almacenamos la distancia calculada
        distancias(1, i) = norm(vector - v_actual);
    end
end
