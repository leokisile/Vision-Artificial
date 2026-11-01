function resultados = interfazP7()
    % Variable donde guardaremos los datos a retornar
    resultados = [];

    % Crear la ventana principal
    fig = figure('Name', 'Interfaz P7 - Regresión Lineal y Modelos de Color', ...
                 'Position', [100, 100, 950, 650], ...
                 'MenuBar', 'none', 'ToolBar', 'none', ...
                 'CloseRequestFcn', @close_callback);

    % Ejes (Axes) para mostrar la imagen (lado izquierdo)
    ax = axes('Parent', fig, 'Units', 'pixels', 'Position', [40, 50, 500, 550]);
    axis(ax, 'off');

    % --- Controles de la Interfaz (Lado derecho) ---

    % 1. Botón Cargar Imagen (Explorador visual)
    uicontrol('Style', 'pushbutton', 'String', 'Explorar Carpeta de Imágenes', ...
        'Position', [570, 580, 330, 45], 'FontSize', 11, 'FontWeight', 'bold', ...
        'Callback', @open_thumbnail_explorer_callback);

    % 2. No. de clases
    uicontrol('Style', 'text', 'String', 'No. de clases:', ...
        'Position', [570, 530, 150, 25], 'HorizontalAlignment', 'left', 'FontSize', 10);
    txt_clases = uicontrol('Style', 'edit', 'String', '2', ...
        'Position', [740, 528, 160, 30], 'FontSize', 10);

    % 3. Modelos de color (Selector)
    uicontrol('Style', 'text', 'String', 'Modelos de color:', ...
        'Position', [570, 480, 150, 25], 'HorizontalAlignment', 'left', 'FontSize', 10, 'FontWeight', 'bold');
    pop_modelo = uicontrol('Style', 'popupmenu', ...
        'String', {'RGB', 'HSI', 'HSV'}, ...
        'Position', [740, 478, 160, 30], 'FontSize', 10);

    % 4. Botón Seleccionar puntos (Regiones rectangulares por clase)
    uicontrol('Style', 'pushbutton', 'String', 'Seleccionar Puntos / Regiones', ...
        'Position', [570, 420, 330, 40], 'FontSize', 10, 'FontWeight', 'bold', ...
        'Callback', @select_points_callback);

    % 5. Parámetros de Regresión Lineal (W1, W2, W3, W0, Gamma)
    uicontrol('Style', 'text', 'String', 'W1 (Canal 1):', ...
        'Position', [570, 375, 150, 22], 'HorizontalAlignment', 'left', 'FontSize', 9);
    txt_w1 = uicontrol('Style', 'edit', 'String', '0.0', ...
        'Position', [740, 373, 160, 26], 'FontSize', 9);

    uicontrol('Style', 'text', 'String', 'W2 (Canal 2):', ...
        'Position', [570, 340, 150, 22], 'HorizontalAlignment', 'left', 'FontSize', 9);
    txt_w2 = uicontrol('Style', 'edit', 'String', '0.0', ...
        'Position', [740, 338, 160, 26], 'FontSize', 9);

    uicontrol('Style', 'text', 'String', 'W3 (Canal 3):', ...
        'Position', [570, 305, 150, 22], 'HorizontalAlignment', 'left', 'FontSize', 9);
    txt_w3 = uicontrol('Style', 'edit', 'String', '0.0', ...
        'Position', [740, 303, 160, 26], 'FontSize', 9);

    uicontrol('Style', 'text', 'String', 'W0 (Sesgo):', ...
        'Position', [570, 270, 150, 22], 'HorizontalAlignment', 'left', 'FontSize', 9);
    txt_w0 = uicontrol('Style', 'edit', 'String', '0.0', ...
        'Position', [740, 268, 160, 26], 'FontSize', 9);

    uicontrol('Style', 'text', 'String', 'Tasa aprendizaje (\Gamma):', ...
        'Position', [570, 235, 150, 22], 'HorizontalAlignment', 'left', 'FontSize', 9);
    txt_gamma = uicontrol('Style', 'edit', 'String', '0.01', ...
        'Position', [740, 233, 160, 26], 'FontSize', 9);

    % 6. Botón Ejecutar cálculo
    uicontrol('Style', 'pushbutton', 'String', 'Ejecutar cálculo', ...
        'Position', [570, 165, 330, 45], 'FontSize', 11, 'FontWeight', 'bold', ...
        'BackgroundColor', [0.1, 0.5, 0.2], 'ForegroundColor', [1, 1, 1], ...
        'Callback', @calculate_callback);

    % Inicializar almacenamiento seguro en la ventana principal
    set(fig, 'UserData', []);
    rects_data = {};

    % Pausar ejecución hasta cerrar la GUI
    uiwait(fig);

    % --- Callbacks ---

    function open_thumbnail_explorer_callback(~, ~)
        pkg load image
        rutaCarpeta = uigetdir(pwd, 'Selecciona la carpeta contenedora de imágenes');
        if rutaCarpeta == 0; return; end

        exts = {'*.jpg', '*.png', '*.bmp', '*.tif', '*.jpeg'};
        archivos = [];
        for i = 1:numel(exts)
            archivos = [archivos; dir(fullfile(rutaCarpeta, exts{i}))];
        end

        numImgs = numel(archivos);
        if numImgs == 0
            errordlg('No se encontraron imágenes válidas en la carpeta.', 'Error');
            return;
        end

        columnas = ceil(sqrt(numImgs));
        filas = ceil(numImgs / columnas);

        fig_explorador = figure('Name', 'Explorador Visual Rápido: Da clic en una imagen', ...
                                'Position', [150, 150, 850, 550], 'MenuBar', 'none');

        for k = 1:numImgs
            ruta_img = fullfile(rutaCarpeta, archivos(k).name);
            try
                mini_img = imread(ruta_img);
                mini_img = imresize(mini_img, [150, NaN]);
            catch
                continue;
            end

            ax_thumb = subplot(filas, columnas, k);
            imshow(mini_img);

            nombre_corto = archivos(k).name;
            if length(nombre_corto) > 12; nombre_corto = [nombre_corto(1:9) '...']; end
            title(nombre_corto, 'FontSize', 8, 'Interpreter', 'none');

            current_path = ruta_img;
            current_name = archivos(k).name;

            set(ax_thumb, 'ButtonDownFcn', @(~,~) select_image_from_explorer(current_path, current_name, fig_explorador));
            set(get(ax_thumb, 'Children'), 'ButtonDownFcn', @(~,~) select_image_from_explorer(current_path, current_name, fig_explorador));
        end
    end

    function select_image_from_explorer(ruta_completa, nombre_archivo, ventana_explorador)
        nueva_img = imread(ruta_completa);
        set(fig, 'UserData', nueva_img);

        axes(ax);
        imshow(nueva_img);
        title(ax, nombre_archivo, 'Interpreter', 'none');
        rects_data = {};

        disp(['Imagen seleccionada desde el explorador: ', nombre_archivo]);
        delete(ventana_explorador);
    end

    function select_points_callback(~, ~)
        current_img = get(fig, 'UserData');
        if isempty(current_img)
            errordlg('Primero debes seleccionar una imagen.', 'Error');
            return;
        end

        n_clases = str2double(get(txt_clases, 'String'));
        if isnan(n_clases) || n_clases < 1
            errordlg('Ingresa un número de clases válido.', 'Error');
            return;
        end

        % Limpiar cuadrados anteriores volviendo a mostrar la imagen limpia en los ejes
        axes(ax);
        imshow(current_img);

        rects_data = cell(n_clases, 1);

        for i = 1:n_clases
            fprintf('Clase %d de %d: Da un clic en la esquina SUPERIOR-IZQUIERDA y otro en la INFERIOR-DERECHA...\n', i, n_clases);
            [x, y] = ginput(2);

            x_min = round(min(x));
            y_min = round(min(y));
            width = round(abs(x(2) - x(1)));
            height = round(abs(y(2) - y(1)));

            rect_coords = [x_min, y_min, width, height];
            rects_data{i} = rect_coords;
            dibujar_cuadrado(ax, rect_coords, i);
        end
        disp('¡Regiones seleccionadas exitosamente!');
    end

    function calculate_callback(~, ~)
        img_actualizada = get(fig, 'UserData');

        if isempty(img_actualizada)
            errordlg('Por favor selecciona una imagen del explorador primero.', 'Error');
            return;
        end

        n_clases = str2double(get(txt_clases, 'String'));
        modelo_idx = get(pop_modelo, 'Value');
        modelo_options = get(pop_modelo, 'String');
        modelo_elegido = modelo_options{modelo_idx};

        % Leer parámetros numéricos actualizados de la interfaz (Pesos W)
        w1_val = str2double(get(txt_w1, 'String'));
        w2_val = str2double(get(txt_w2, 'String'));
        w3_val = str2double(get(txt_w3, 'String'));
        w0_val = str2double(get(txt_w0, 'String'));
        gamma_val = str2double(get(txt_gamma, 'String'));

        if isempty(rects_data)
            warndlg('Debes seleccionar las regiones de las clases primero.', 'Advertencia');
            return;
        end

        % --- CONVERSIÓN A MODELO DE COLOR Y EXTRACCIÓN DE 500 PÍXELES ---
        img_double = im2double(img_actualizada);

        switch upper(modelo_elegido)
            case 'RGB'
                img_model = img_double;
            case 'HSV'
                img_model = rgb2hsv(img_double);
            case 'HSI'
                img_model = rgb2hsi_local(img_double);
            otherwise
                img_model = img_double;
        end

        pixels_clases_raw = cell(n_clases, 1);
        pixels_clases_modelo = cell(n_clases, 1);
        target_n = 500;

        % Llamar a la función auxiliar (por defecto sacará 500 píxeles)
        [pixels_clases_raw, pixels_clases_modelo] = extraer_pixeles(img_actualizada, img_model, rects_data, n_clases, 500);

        % 1. Extraer los píxeles (como hicimos antes)
        [pixels_clases_raw, pixels_clases_modelo] = extraer_pixeles(img_actualizada, img_model, rects_data, n_clases, 500);

        % 2. Ejecutar el entrenamiento iterativo con los pesos y parámetros actuales de la UI
        [pesos_optimos, sesgo_optimo, total_iter] = entrenar_clasificador(pixels_clases_modelo, [w1_val, w2_val, w3_val], w0_val, gamma_val, 100);

        % 3. Graficar la recta de decisión en la imagen
        % 1. Mostrar el mapa de segmentación en la imagen
        graficar_frontera_decision(pesos_optimos, sesgo_optimo, modelo_elegido, img_actualizada);

        % 2. Mostrar la gráfica 3D del espacio de color con los píxeles y el plano
        mostrar_espacio_3d(pesos_optimos, sesgo_optimo, modelo_elegido, pixels_clases_modelo);

        % Guardar todo en la estructura de resultados
        resultados = struct();
        resultados.imagen = img_actualizada;
        resultados.modelo_color = modelo_elegido;
        resultados.n_clases = n_clases;
        resultados.rects = rects_data;
        resultados.pixels_raw = pixels_clases_raw;
        resultados.pixels_modelo = pixels_clases_modelo;
        resultados.pesos = [w1_val, w2_val, w3_val];
        resultados.sesgo = w0_val;
        resultados.gamma = gamma_val;

        % --- IMPRESIÓN COMPLETA Y DE LOS PRIMEROS 5 ELEMENTOS ---
        disp('----------------------------------------');
        fprintf(' - Modelo de color elegido: %s\n', resultados.modelo_color);
        fprintf(' - Clases totales: %d\n', resultados.n_clases);
        fprintf(' - Pesos de entrenamiento (W1, W2, W3): [%f, %f, %f]\n', resultados.pesos);
        fprintf(' - Sesgo (W0): %f\n', resultados.sesgo);
        fprintf(' - Tasa de aprendizaje (Gamma): %f\n', resultados.gamma);
        fprintf(' - Dimensiones de la imagen: %dx%d\n', size(resultados.imagen,1), size(resultados.imagen,2));
        disp('----------------------------------------');

        disp('Primeros 5 elementos (píxeles) de cada clase en el modelo elegido:');
        for i = 1:n_clases
            fprintf('\n--- Clase %d ---\n', i);
            disp(pixels_clases_modelo{i}(1:min(5, size(pixels_clases_modelo{i}, 1)), :));
        end
        disp('----------------------------------------');

        fprintf('\n--- ENTRENAMIENTO FINALIZADO ---\n');
        fprintf('Total de iteraciones realizadas: %d\n', total_iter);
        fprintf('Nuevos pesos óptimos: [%f, %f, %f]\n', pesos_optimos);
        fprintf('Nuevo sesgo óptimo: %f\n', sesgo_optimo);

        uiresume(fig);
    end

    function close_callback(~, ~)
        uiresume(fig);
        delete(fig);
    end
end
