function [action] = menu3()
    % Crea un cuadro de diálogo con dos botones
    choice = questdlg('Menu per crear màscara o correlació:', ...
                      'Escull opció', ...
                      'Metode isoutlier', 'Metode diferencia de quartils', 'Treure Correlacions', 'Cancelar');
    % Verifica qué botón fue seleccionado
    switch choice
        case 'Metode isoutlier'
            % Ejecuta la acción correspondiente a la selección "Opción 1"
            disp('Has seleccionat la opció isoutlier');
            action = 'isoutlier';
        case 'Metode diferencia de quartils'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionat la opció diferencia de quartils');
            action = 'quartils';
        case 'Treure Correlacions'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionat la opció de treure correlacions');
            action = 'correlacions';
        case 'Cancelar'
            % Ejecuta la acción correspondiente a la selección "Cancelar"
            disp('La acció ha sigut cancelada');
            action = 'cancelar';
    end
end
