function clases = generar_clases(num, elementos, cent_x, cent_y, disp_x, disp_y)
    % GENERAR_CLASES: Genera n clases aleatorias
    %   num: Numero de clases
    %   elementos: Cantidad de elementos por calse
    %   cent_x: Centroide en x de cada clase (arreglo)
    %   cent_x: Centroide en y de cada clase (arreglo)
    %   dips_x: Dispersion en x de cada clase (arreglo)
    %   dips_y: Dispersion en y de cada clase (arreglo)

    clases = cell(1, num);

    for i = 1:num
        % Calculo de los elementos de la clase
        ci_x=(randn(1,elementos)+cent_x(i))*disp_x(i);
        ci_y=(randn(1,elementos)+cent_y(i))*disp_y(i);

        ci = [ci_x; ci_y];

        % Almacenamos las clases en su cell array
        clases{i} = [ci_x; ci_y];
    end
end
