%archivos terminación .m

%comentar codigo

clc %limpia pantalla
clear %limpia todo
close all %cierra todo
warning off all %apaga o inhibe las advertencias

disp("mensaje") % imprime el mensaje

%Definición de clases

% si se coloca un ; al final de la declaración, no se imprimirá en la pantalla
% Se puede usar el comando "whos" para revisar las variables declaradas
c1 = [0 2 1; 1 3 2]; % Se considera una fila cada conjunto antes de ;
c2 = [3 4 5; 4 0 2];
c3 = [6 7 8; 7 4 2];
vx = input("Dame la coordenada del vector en x=");
vy = input("Dame la coordenada del vector en y=");
x = [vx; vy]
%x = [5; -2]

%Graficando clases
figure(1)
plot(c1(1,:), c1(2,:), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r')
grid on %Crea la cuadrícula
hold on %Mantiene lo ya graficado, solo se necesita colocar una vez
plot(c2(1,:), c2(2,:), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b')
plot(c3(1,:), c3(2,:), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g')
plot(x(1,:), x(2,:), 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k')
legend('Clase 1', 'Clase 2', 'Clase 3', 'Vector') %Le da nombre de acuerdo al orden de los plots

% Calculo del centroide
c1x= (1/length(c1))*sum(c1(1,:));
c1y= (1/length(c1))*sum(c1(2,:));
m1= [c1x; c1y]

c2x= (1/length(c2))*sum(c2(1,:));
c2y= (1/length(c2))*sum(c2(2,:));
m2= [c2x; c2y]

c3x= (1/length(c3))*sum(c3(1,:));
c3y= (1/length(c3))*sum(c3(2,:));
m3= [c3x; c3y]

media1= mean(c1, 2); %Define el arreglo a utilizar y el # de dimensiones

%Calculo de las distancias
dist1= norm(x-m1);
dist2= norm(x-m2);
dist3= norm(x-m3);

dist_total = [dist1 dist2 dist3]
dist1_normalizada = (dist1/sum(dist_total))*100; %Conversión en porcentaje para asegurar una medida escalar
dist2_normalizada = (dist2/sum(dist_total))*100;
dist3_normalizada = (dist3/sum(dist_total))*100;

dist_tot_norma = [dist1_normalizada dist2_normalizada dist3_normalizada]

%Encontrar el minimo
minimo = min(min(dist_tot_norma)) %Min da un renglón, min min da el valor unico

dato = find(dist_tot_norma==minimo) %Busca la posicion de un elemento en un arreglo

% Toma de decision buscada es:
fprintf("El vector x pertenece a la clase %d\n", dato)


