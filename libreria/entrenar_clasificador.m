function [pesos_finales, sesgo_final, num_iteraciones] = entrenar_clasificador(pixels_modelo, pesos_iniciales, sesgo_inicial, gamma, max_iter)
    % Si no se define un límite de iteraciones, por defecto será 100
    if nargin < 5
        max_iter = 100;
    end

    W = [pesos_iniciales(:); sesgo_inicial]; % Vector de pesos combinado [W1; W2; W3; W0]
    n_clases = length(pixels_modelo);

    if n_clases ~= 2
        error('Este algoritmo de clasificación lineal binaria está diseñado exactamente para 2 clases.');
    end

    hubo_cambios = true;
    iter = 0;

    while hubo_cambios && (iter < max_iter)
        iter = iter + 1;
        hubo_cambios = false;

        % --- CLASE 1 (Esperada < 0) ---
        datos_c1 = pixels_modelo{1};
        n_muestras_1 = size(datos_c1, 1);

        for k = 1:n_muestras_1
            x = datos_c1(k, :)';       % Vector de canales [x1, x2, x3]'
            x_bias = [x; 1];           % Añadir el 1 para el sesgo (W0 * 1)

            % Evaluación: W * X + sesgo
            resultado = W' * x_bias;

            % Regla de actualización para Clase 1 (debe ser < 0)
            if resultado >= 0
                % Clasificación mala: W = W_actual - gamma * X
                W = W - gamma * x_bias;
                hubo_cambios = true;
            end
        end

        % --- CLASE 2 (Esperada >= 0) ---
        datos_c2 = pixels_modelo{2};
        n_muestras_2 = size(datos_c2, 1);

        for k = 1:n_muestras_2
            x = datos_c2(k, :)';       % Vector de canales [x1, x2, x3]'
            x_bias = [x; 1];           % Añadir el 1 para el sesgo

            % Evaluación: W * X + sesgo
            resultado = W' * x_bias;

            % Regla de actualización para Clase 2 (debe ser >= 0)
            if resultado < 0
                % Clasificación mala: W = W_actual + gamma * X
                W = W + gamma * x_bias;
                hubo_cambios = true;
            end
        end

        fprintf('Iteración %d completada. ¿Hubo cambios?: %d\n', iter, hubo_cambios);
    end

    % Retornar pesos y sesgo separados
    pesos_finales = W(1:3)';
    sesgo_final = W(4);
    num_iteraciones = iter;
end
