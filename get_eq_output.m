function [d_hat] = get_eq_output(i, c, v)
    % i: output index
    % c: filter coefficients
    % v: rx symbols to be equalized
    %       only a subset of v is processed by the filter
    

    K = (length(c) - 1) / 2;
    d_hat = 0;  % filter output at position i
    for l = -K:K
        if (i - l) >= 0 && (i - l) < length(v)
            d_hat = d_hat + c(l + K + 1) * v(i - l + 1);
        end
    end
end