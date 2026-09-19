function mahalanobis = calcular_mahalanobis(vector, valores, clases)
    % CALCULAR_MAHALANOBIS: Calcula la distancia de un vector a una lista de valores dadas
    %   vector: Vector con cordenadas [vx, vy]
    %   valores: Matriz numerica donde cada columna representa el centroide [cx; cy] de cada clase.
    %   clases: Un cell array con las clases a considerar

    n_clases = size(valores, 2);
    mahalanobis = zeros(1, n_clases);

    for i = 1:n_clases
      c_actual = clases{i};
      mu = valores(:, i);
      n_muestras = size(c_actual, 2);

      % Matriz de covarianza
      c_centrado = c_actual - mu;
      % Agrega una matriz de 1s de 2x2 para evitar la singularidad
      sigma = (c_centrado * c_centrado')/(n_muestras) + eye(2) * 1e-5;

      dif = vector - mu;

      mahalanobis(1, i) = sqrt((dif' * inv(sigma)) * dif);
    endfor

end
