function ejecutar_proceso_clasificacion(datos_salida)
    if isempty(datos_salida)
        disp('No hay datos para procesar.');
        return;
    end

    % Extraer parametros de la interfaz
    n_clases = datos_salida.n_clases;
    metodo = datos_salida.metodo;
    num_iteraciones = datos_salida.kcross;
    k_leave = datos_salida.kleave;

    % Obtener los valores RGB
    valores = valor_pixel(datos_salida.puntos_aleatorios, n_clases, datos_salida.imagen);

    % =========================================================================
    % 1: VALIDACIÓN POR SUSTITUCIÓN (100% entrenamiento y prueba)
    % =========================================================================
    disp('--------------------------------------------------');
    disp(['Ejecutando metodo: ', metodo, ' (Validacion por Sustitucion)...']);

    centroides = calcular_centroides(valores);
    matriz_sustitucion = zeros(n_clases, n_clases);
    aciertos_sust = 0;
    total_sust = 0;

    for c = 1:n_clases
        muestras_rgb = valores{c};
        [m_muestras, ~] = size(muestras_rgb);

        for i = 1:m_muestras
            punto_actual = muestras_rgb(i, :);
            clase_predicha = evaluar_punto(punto_actual, centroides, valores, metodo);

            matriz_sustitucion(c, clase_predicha) = matriz_sustitucion(c, clase_predicha) + 1;
            if clase_predicha == c, aciertos_sust = aciertos_sust + 1; end
            total_sust = total_sust + 1;
        end
    end
    accuracy_sust = (aciertos_sust / total_sust) * 100;

    % Guardar resultados de Sustitucion
    guardar_resultados_txt([metodo, ' - Sustitucion'], matriz_sustitucion, accuracy_sust, n_clases);


    % =========================================================================
    % K-CROSS VALIDATION (Particion 50/50 con K iteraciones)
    % =========================================================================
    disp('--------------------------------------------------');
    disp(['Ejecutando K-Cross Validation (', num2str(num_iteraciones), ' iteraciones, 50/50)...']);

    acumulador_matrices = zeros(n_clases, n_clases);
    total_muestras_global = 0;
    aciertos_global_acumulados = 0;

    for k = 1:num_iteraciones
        train_rgb = cell(n_clases, 1);
        test_rgb = cell(n_clases, 1);

        % Particion aleatoria 50% / 50% por clase
        for c = 1:n_clases
            muestras_c = valores{c};
            m_total = size(muestras_c, 1);

            idx = randperm(m_total);
            n_train = floor(m_total * 0.5);

            train_rgb{c} = muestras_c(idx(1:n_train), :);
            test_rgb{c} = muestras_c(idx(n_train+1:end), :);
        end

        % Entrenar con el 50%
        centroides_train = calcular_centroides(train_rgb);

        % Evaluar con el 50% de prueba
        matriz_iter = zeros(n_clases, n_clases);
        aciertos_iter = 0;
        total_iter = 0;

        for c = 1:n_clases
            muestras_test = test_rgb{c};
            [m_test, ~] = size(muestras_test);

            for i = 1:m_test
                punto_actual = muestras_test(i, :);
                clase_predicha = evaluar_punto(punto_actual, centroides_train, train_rgb, metodo);

                matriz_iter(c, clase_predicha) = matriz_iter(c, clase_predicha) + 1;
                if clase_predicha == c, aciertos_iter = aciertos_iter + 1; end
                total_iter = total_iter + 1;
            end
        end

        % Calcular accuracy de esta iteracion individual
        accuracy_iter = (aciertos_iter / total_iter) * 100;

        % Guardar la iteracion en el txt
        guardar_resultados_txt([metodo, ' - K-Cross Validation (Iteracion ', num2str(k), ')'], matriz_iter, accuracy_iter, n_clases);

        % Acumular para el promedio global
        acumulador_matrices = acumulador_matrices + matriz_iter;
        aciertos_global_acumulados = aciertos_global_acumulados + aciertos_iter;
        total_muestras_global = total_muestras_global + total_iter;

        fprintf(' > Iteración %d/%d guardada - Accuracy: %.2f%%\n', k, num_iteraciones, accuracy_iter);
    end

    % Matriz promedio redondeada a entero
    matriz_cross_promedio = round(acumulador_matrices / num_iteraciones);

    % Accuracy calculado estrictamente a partir de la matriz promedio global acumulada
    % (Suma de la diagonal principal entre el total acumulado de muestras evaluadas)
    accuracy_cross_final = (sum(diag(matriz_cross_promedio)) / sum(matriz_cross_promedio(:))) * 100;

    % Guardar resultados finales promediados
    guardar_resultados_txt([metodo, ' - K-Cross Validation (MATRIZ PROMEDIO FINAL)'], matriz_cross_promedio, accuracy_cross_final, n_clases);


    % =========================================================================
    % K-LEAVE OUT VALIDATION (Leave-k-out)
    % =========================================================================
    disp('--------------------------------------------------');
    disp(['Ejecutando K-Leave Out (k = ', num2str(k_leave), ')...']);

    matriz_leaveout = zeros(n_clases, n_clases);
    aciertos_leave = 0;
    total_leave = 0;

    for c = 1:n_clases
        muestras_c = valores{c};
        m_total = size(muestras_c, 1);

        % Tomar k elementos como prueba y el resto como entrenamiento
        for i = 1:k_leave:m_total
            idx_test = i : min(i + k_leave - 1, m_total);
            idx_train = setdiff(1:m_total, idx_test);

            if isempty(idx_train), continue; end

            % Separar train y test
            train_leave = cell(n_clases, 1);
            for cl = 1:n_clases
                if cl == c
                    train_leave{cl} = valores{cl}(idx_train, :);
                else
                    train_leave{cl} = valores{cl}; % Clases completas para el resto
                end
            end

            centroides_leave = calcular_centroides(train_leave);
            muestras_test = valores{c}(idx_test, :);

            for j = 1:size(muestras_test, 1)
                punto_actual = muestras_test(j, :);
                clase_predicha = evaluar_punto(punto_actual, centroides_leave, train_leave, metodo);

                matriz_leaveout(c, clase_predicha) = matriz_leaveout(c, clase_predicha) + 1;
                if clase_predicha == c, aciertos_leave = aciertos_leave + 1; end
                total_leave = total_leave + 1;
            end
        end
    end

    accuracy_leave = (aciertos_leave / max(total_leave, 1)) * 100;
    guardar_resultados_txt([metodo, ' - K-Leave Out'], matriz_leaveout, accuracy_leave, n_clases);

    disp('--------------------------------------------------');
    disp('¡Procesos de validacion y guardado en la carpeta matrices finalizados!');

    % Graficar los resultados
    metodos_lista = {'Resustitution', 'K-cross validation', 'K-leave out'};
    accuracies_lista = [accuracy_sust, accuracy_cross_final, accuracy_leave];

    % Generar la grafica comparativa
    graficar_comparativa_accuracy(metodos_lista, accuracies_lista);
end
