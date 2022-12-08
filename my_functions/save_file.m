function [] = save_file(yes_no_option,file_name_mask,mask,file_name_mask_merged,merged_matrix)
    if strcmp(yes_no_option,"yes") == 1
        fprintf("SAVING MERGED AND MASK MATRIX \n")
        save(file_name_mask,'mask')
        save(file_name_mask_merged,'merged_matrix')
    else
        fprintf("NOT SAVING MASK\n")
        fprintf("NOT SAVING MERGED MATRIX\n")
    end
end

