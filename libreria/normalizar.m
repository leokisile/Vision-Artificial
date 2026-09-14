function normalizadas = normalizar(distancias)
    % NORMALIZAR: Normaliza a escalares un conjunto de valores (distancias)
    %   distancias: Matriz numerica donde cada columna representa la distancia calculada de un vector al centroide de una clase.

    normalizadas = zeros(1, size(distancias, 2));

    suma = sum(distancias)

    for i = 1:size(distancias,2)
        d_actual = distancias(1,i);

        % Almacenamos la distancia calculada
        if suma > 0
          normalizadas(1, i) = (d_actual/suma)*100;
        else
          normalizadas(1,i) = 0
         endif
    end
end
