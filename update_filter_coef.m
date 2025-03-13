function [next_c] = update_filter_coef(c, eps, rx_symbols, step, k)
    % c: vector of filter coefficients of lenth (2K + 1) 
    %       nonzero values at indices -K to K
    % eps: error at kth step
    % rx_symbols: received symbol vector
    % delta: step size
    % k: update step, can have values in {0, 1, ....}

    K = (length(c) - 1) / 2;
    v = zeros(length(c), 1);  % subset of received symbols
                              % to be used for update
    for i = -K:K
        if k - i >= 0 & k - i < length(rx_symbols)
            v(i + K + 1) = rx_symbols(k - i + 1);
        end
    end
    next_c = c + step * eps * v;
end