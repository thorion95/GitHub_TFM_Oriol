function [] = save_file(yes_no_option,data)
    if strcmp(yes_no_option,"yes") == 1
        [file, path] = uiputfile('*.mat');
        save(fullfile(path,file),'data');
        fprintf('File saved successfully\n')
    else
        fprintf('Not saved any file\n')
    end
end

