function [action] = menu2()
    % Crea un cuadro de diálogo con dos botones
%     fprintf('MENU OPCIONS:\n\t1 - Operar dades inicials  - 1.1 - Crea mascara mitjançant IsOutlier\n\t\t\t\t\t\t\t  |- 1.2 - Crea mascara mitjançant Quartils\n\t\t\t\t\t\t\t  |- 1.3 - Correlar\n\t2 - Reconstruir dades inicials mitjançant algorismes de reconstrucció per tensors\n\t3 - Analitzar dades ini   |- 3.1 - Analitzar Outliers\n\t\t\t\t\t\t\t  |- 3.2 - Comparar 3 set de dades (inicials/finals/reconstruides)\n\t\t\t\t\t\t\t  |- 3.3 - Treure correlació\n');
    choice = questdlg('Menu per comparar dades:', ...
                      'Escull opció', ...
                      '3.1. Analitzar Outliers', '3.2. Comparar 3 sets de dades', '3.3. Valors correlacions', 'Cancelar');
    % Verifica qué botón fue seleccionado
    switch choice
        case '3.1. Analitzar Outliers'
            % Ejecuta la acción correspondiente a la selección "Opción 1"
            disp('Has seleccionat la opció d"Analitzar Outliers');
            action = 'outliers';
        case '3.2. Comparar 3 sets de dades'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionat la opció de comparar 3 datasets');
            action = 'dades';
        case '3.3. Valors correlacions'
            % Ejecuta la acción correspondiente a la selección "Opción 3"
            disp('Has seleccionat la opció de extreure valor de correlació');
            action = 'compcorrelacions';
        case 'Cancelar'
            % Ejecuta la acción correspondiente a la selección "Cancelar"
            disp('La acció ha sigut cancelada');
            action = 'cancelar';
    end
end
