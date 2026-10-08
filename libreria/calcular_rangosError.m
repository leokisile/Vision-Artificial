function rangos = calcular_rangosError(maximo, minimo, combinaciones)
    % calcular_rangosError: Clacular los rangos de error de una matriz de error
    %   maximo: Error maximo de la matriz (vector 1xN)
    %   minimo: Error minimo de la matriz (vector 1xN)
    %   combinaciones: Numero de combinaciones 2^n con n=No bits a comprimir

    num_canales = length(maximo);
    rangos = zeros(num_canales, combinaciones);

    for k = 1:num_canales
        peso = (maximo(k) - minimo(k)) / combinaciones;

        rangos(k, :) = minimo(k) + (1:combinaciones) * peso;
    end
end
