function [action] = example_gui()
    % Crea un cuadro de diálogo con dos botones
    choice = questdlg('¿Qué acción deseas realizar?', ...
                      'Elegir acción', ...
                      'Create Mask', 'Compare', 'Reconstruct From Mask', 'Cancelar');
    % Verifica qué botón fue seleccionado
    switch choice
        case 'Create Mask'
            % Ejecuta la acción correspondiente a la selección "Opción 1"
            disp('Has seleccionado la opción de generar mascara');
            action = 'mask';
        case 'Compare'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionado la opción de comparar 2 datasets');
            action = 'compare';
        case 'Reconstruct From Mask'
            % Ejecuta la acción correspondiente a la selección "Opción 2"
            disp('Has seleccionado la opción de reconstruir des de la mascara');
            action = 'reconstruct';
        case 'Cancelar'
            % Ejecuta la acción correspondiente a la selección "Cancelar"
            disp('La acción ha sido cancelada');
    end
end
