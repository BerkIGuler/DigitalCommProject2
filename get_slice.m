function [slice] = get_slice(slice_len, right_idx, input)
    % get a slice and pad with 0 if necessary
    
    % slice_len: lenth of slice
    % right_idx: slice start right index
    %       if right_idx < slice_len, the output is zero padded from left
    % input: input vector to be sliced

    slice = zeros(slice_len, 1);
    start = max(1, right_idx - slice_len + 1);
    end_ = right_idx; 
    sliced_values = input(start : end_);  
    slice(slice_len - length(sliced_values) + 1 : end) = sliced_values; 
end