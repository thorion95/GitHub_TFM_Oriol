function [action] = menu()
    warning off all
    % Crea un cuadro de diálogo con dos botones
    fprintf('MENU OPCIONS:\n\t1 - Operar dades inicials  - 1.1 - Crea mascara mitjançant IsOutlier\n\t\t\t\t\t\t\t  |- 1.2 - Crea mascara mitjançant Quartils\n\t\t\t\t\t\t\t  |- 1.3 - Crear correlació entre dades inicials(A), construides i finals(B)\n\t2 - Reconstruir dades inicials mitjançant algorismes de reconstrucció per tensors\n\t3 - Analitzar dades ini   |- 3.1 - Analitzar Outliers\n\t\t\t\t\t\t\t  |- 3.2 - Comparar 3 set de dades NÚVOL DE PUNTS/REGRESSIÓ LINEAL\n\t\t\t\t\t\t\t  |- 3.3 - Comparar correlacions\n');
    choice = questdlg('Menu inicial:', ...
                      'Escull opció', ...
                      '1. Operar dades', '2. Reconstruir dades', '3. Comparar dades', 'Cancelar');
    % Verifica qué botón fue seleccionado
    switch choice
        case '1. Operar dades'
            % Ejecuta la acción correspondiente a la selección "Opción 1"
            disp('Has seleccionat la opció d"operar amb les dades');
            action = 'mask';
        case '2. Reconstruir dades'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionat la opció de reconstruir des de la mascara');
            action = 'reconstruct';
        case '3. Comparar dades'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionat la opció de comparar datasets');
            action = 'compare';
        case 'Cancelar'
            % Ejecuta la acción correspondiente a la selección "Cancelar"
    end
end
