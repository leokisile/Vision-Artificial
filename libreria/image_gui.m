function resultados = image_gui()
    % Variable donde guardaremos los datos a retornar
    resultados = [];

    % Crear la ventana principal
    fig = figure('Name', 'Interfaz de Clasificación de Imágenes', ...
                 'Position', [100, 100, 900, 620], ...
                 'MenuBar', 'none', 'ToolBar', 'none', ...
                 'CloseRequestFcn', @close_callback);

    % Ejes (Axes) para mostrar la imagen (lado izquierdo)
    ax = axes('Parent', fig, 'Units', 'pixels', 'Position', [40, 50, 520, 520]);
    axis(ax, 'off');

% --- Controles de la Interfaz (Lado derecho) ---
    uicontrol('Style', 'pushbutton', 'String', 'Cargar Imagen', ...
        'Position', [590, 535, 260, 45], 'FontSize', 11, 'FontWeight', 'bold', ...
        'Callback', @load_image_callback);

    uicontrol('Style', 'text', 'String', 'No. de clases:', ...
        'Position', [590, 485, 120, 25], 'HorizontalAlignment', 'left', 'FontSize', 10);
    txt_clases = uicontrol('Style', 'edit', 'String', '2', ...
        'Position', [720, 483, 130, 30], 'FontSize', 10);

    uicontrol('Style', 'text', 'String', 'No. rep:', ...
        'Position', [590, 435, 120, 25], 'HorizontalAlignment', 'left', 'FontSize', 10);
    txt_rep = uicontrol('Style', 'edit', 'String', '5', ...
        'Position', [720, 433, 130, 30], 'FontSize', 10);

    uicontrol('Style', 'pushbutton', 'String', 'Seleccionar puntos', ...
        'Position', [590, 370, 260, 40], 'FontSize', 10, 'FontWeight', 'bold', ...
        'Callback', @select_points_callback);

    uicontrol('Style', 'text', 'String', 'Selección de métodos:', ...
        'Position', [590, 320, 260, 20], 'HorizontalAlignment', 'left', 'FontSize', 10, 'FontWeight', 'bold');
    pop_select = uicontrol('Style', 'popupmenu', ...
        'String', {'Euclidiana', 'Mahalanobis', 'Max prob'}, ...
        'Position', [590, 280, 260, 35], 'FontSize', 10);

    % --- Nuevos controles reubicados debajo del select ---
    uicontrol('Style', 'text', 'String', 'K-Cross Validation:', ...
        'Position', [590, 235, 120, 25], 'HorizontalAlignment', 'left', 'FontSize', 10);
    txt_kcross = uicontrol('Style', 'edit', 'String', '20', ...
        'Position', [720, 233, 130, 30], 'FontSize', 10);

    uicontrol('Style', 'text', 'String', 'K-Leave Out:', ...
        'Position', [590, 190, 120, 25], 'HorizontalAlignment', 'left', 'FontSize', 10);
    txt_kleave = uicontrol('Style', 'edit', 'String', '2', ...
        'Position', [720, 188, 130, 30], 'FontSize', 10);

    % --- Botón de ejecutar cálculo reubicado más abajo ---
    uicontrol('Style', 'pushbutton', 'String', 'Ejecutar cálculo', ...
        'Position', [590, 120, 260, 45], 'FontSize', 11, 'FontWeight', 'bold', ...
        'BackgroundColor', [0.1, 0.5, 0.2], 'ForegroundColor', [1, 1, 1], ...
        'Callback', @calculate_callback);

    % Variables internas
    img_data = [];
    rects_data = {};
    puntos_por_clase = {};

    % Pausar la ejecución del script principal hasta que se cierre la GUI
    uiwait(fig);

    % --- Callbacks ---

    function load_image_callback(~, ~)
        [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tif', 'Imágenes'});
        if filename ~= 0
            img_data = imread(fullfile(pathname, filename));
            axes(ax);
            imshow(img_data);
            title(ax, filename, 'Interpreter', 'none');
            rects_data = {};
            disp('¡Imagen cargada exitosamente!');
        end
    end

    function select_points_callback(~, ~)
        if isempty(img_data)
            errordlg('Primero debes cargar una imagen.', 'Error');
            return;
        end

        n_clases = str2double(get(txt_clases, 'String'));
        rects_data = cell(n_clases, 1);
        axes(ax);

        for i = 1:n_clases
            fprintf('Clase %d de %d: Da un clic en la esquina SUPERIOR-IZQUIERDA y otro en la INFERIOR-DERECHA...\n', i, n_clases);
            [x, y] = ginput(2);

            % Redondear a valores enteros exactos
            x_min = round(min(x));
            y_min = round(min(y));
            width = round(abs(x(2) - x(1)));
            height = round(abs(y(2) - y(1)));

            rect_coords = [x_min, y_min, width, height];
            rects_data{i} = rect_coords;
            dibujar_cuadrado(ax, rect_coords, i);
        end
        disp('¡Regiones seleccionadas!');
    end

    function calculate_callback(~, ~)
        n_clases = str2double(get(txt_clases, 'String'));
        n_rep = str2double(get(txt_rep, 'String'));
        kcross = str2double(get(txt_kcross, 'String'));
        kleave = str2double(get(txt_kleave, 'String'));
        pop_idx = get(pop_select, 'Value');
        pop_options = get(pop_select, 'String');

        if isempty(rects_data)
            warndlg('Debes seleccionar las regiones primero.', 'Advertencia');
            return;
        end

        % Generar y graficar puntos aleatorios por cada clase
        puntos_por_clase = cell(n_clases, 1);
        for i = 1:n_clases
            % Simulación de puntos dentro de la zona del rectángulo de la clase i
            r = rects_data{i}; % [x, y, ancho, alto]
            px = randi([r(1), r(1) + r(3)], n_rep, 1);
            py = randi([r(2), r(2) + r(4)], n_rep, 1);
            puntos_clase = [px, py];

            puntos_por_clase{i} = puntos_clase;

            % Llamada a la nueva función para graficar rotando color y símbolo
            dibujar_puntos_clase(ax, puntos_clase, i);

            fprintf('Se graficaron los %d puntos aleatorios para la clase %d\n', n_rep, i);
        end

        % Empaquetar los resultados para enviarlos al archivo principal
        resultados = struct();
        resultados.imagen = img_data;
        resultados.metodo = pop_options{pop_idx};
        resultados.n_clases = n_clases;
        resultados.n_rep = n_rep;
        resultados.kcross = kcross;
        resultados.kleave = kleave;
        resultados.rects = rects_data;
        resultados.puntos_aleatorios = puntos_por_clase;

        % Reanudar la ejecución del main y cerrar la ventana
        uiresume(fig);
        %close(fig);
    end

    function close_callback(~, ~)
        uiresume(fig);
        delete(fig);
    end
end

% --- Funciones auxiliares modulares ---

function dibujar_cuadrado(ax, rect_coords, indice_clase)
    colores = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
    color_actual = colores(mod(indice_clase - 1, length(colores)) + 1);

    hold(ax, 'on');
    rectangle(ax, 'Position', rect_coords, 'EdgeColor', color_actual, 'LineWidth', 2);
    hold(ax, 'off');
end

function dibujar_puntos_clase(ax, puntos, indice_clase)
    % Paleta de colores y símbolos (marcadores) disponibles para rotar
    colores = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
    simbolos = {'o', 's', '^', 'd', 'v', 'p', '*'}; % Círculo, Cuadrado, Triángulo, Diamante, etc.

    color_actual = colores(mod(indice_clase - 1, length(colores)) + 1);
    simbolo_actual = simbolos{mod(indice_clase - 1, length(simbolos)) + 1};

    hold(ax, 'on');
    plot(ax, puntos(:, 1), puntos(:, 2), simbolo_actual, ...
         'Color', color_actual, ...
         'MarkerFaceColor', color_actual, ...
         'MarkerSize', 5, ...
         'LineStyle', 'none');
    hold(ax, 'off');
end
