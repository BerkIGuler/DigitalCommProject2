function [y] = symmetric_fir_filter(x, c)
    K = (length(c) - 1) / 2;  % non-zero filter coefficient are indexed
                              % from -K to K
    y = zeros(length(x), 1);

    idx = 0;  % output index
    while idx < length(x)
        for k = -K:K
            if (idx - k) >= 0 & (idx - k) < length(x) 
                y(idx + 1) = y(idx + 1) + c(k + K + 1) * x(idx - k + 1);
            end
        end
        idx = idx + 1;
    end
end