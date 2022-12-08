function [merged_matrix] = generate_mask_plus_initial_values(yes_no_option,mask,initial_values)
    if strcmp(yes_no_option,"yes") == 1
        fprintf("CREATING MATRIX MERGED WITH MASK \n")
        merged_matrix = mask.*initial_values;
    else
        fprintf("NOT MERGING ANYTHING\n")
    end
end

