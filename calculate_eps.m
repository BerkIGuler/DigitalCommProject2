function [e] = calculate_eps(d, c, v, i)
    % d: target for current (ith) received symbol
    % c: filter coefficients
    % v: received symbol sequence to be equalized 
    %       maximum (2K + 1) of those are accessed by this function
    % i: index of the equalizer output symbol 
    %       for which we calculate the error
    %       i is in {0, 1, ..., length(v) - 1}

    K = (length(c) - 1) / 2;
    d_hat = 0;  % filter output at position i
    for l = -K:K
        if (i - l) >= 0 & (i - l) < length(v)
            d_hat = d_hat + c(l + K + 1) * v(i - l + 1);
        end
    end
    e = d - d_hat;
end