function vertical = corte_vertical(img)
    % corte_vertical: Divide la imagen en 3 franjas verticales, cada una con un solo canal del RGB
    %   img: Matriz de la imagen a aplicar el corte

    [m, n, canales]=size(img);
    vertical = img;
    cortev = round(n/3);

    % Rojo
    vertical(:,1:cortev,1);
    vertical(:,1:cortev,2)=0;
    vertical(:,1:cortev,3)=0;

    % Verde
    vertical(:,cortev+1:2*cortev,1)=0;
    vertical(:,cortev+1:2*cortev,2);
    vertical(:,cortev+1:2*cortev,3)=0;

    % Azul
    vertical(:,2*cortev+1:n,1)=0;
    vertical(:,2*cortev+1:n,2)=0;
    vertical(:,2*cortev+1:n,3);
end
