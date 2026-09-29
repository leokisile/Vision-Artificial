function maxProb = maxima_probabilidad(vector, valores, clases)
    % MAXIMA_PROBABILIDAD: Calcula la distancia de un vector a una lista de valores dadas
    %   vector: Vector con cordenadas [vx, vy]
    %   valores: Matriz numerica donde cada columna representa el centroide [cx; cy] de cada clase.
    %   clases: Un cell array con las clases a considerar

    n_clases = size(valores, 2);
    maxProb = zeros(1, n_clases);
    mahalanobis = calcular_mahalanobis(vector, valores, clases);
    dim = size(vector, 1);

    for i = 1:n_clases
      c_actual = clases{i};
      mu = valores(:, i);
      n_muestras = size(c_actual, 2);

      % Matriz de covarianza
      c_centrado = c_actual - mu;
      sigma = (c_centrado * c_centrado')/(n_muestras) + eye(2) * 1e-5;

      exponente = -0.5 * (mahalanobis(:, i) ^ 2);
      denominador = ((2 * 3.1416) ^ (dim / 2)) * sqrt(det(sigma));

      maxProb(1, i) = exp(exponente) / denominador;
    endfor

end
