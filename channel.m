function [y] = channel(x, h)
    y = zeros(length(x), 1);
    idx = 0;
    while idx < length(x)
        for k = 0:(length(h) - 1)
            if idx - k >= 0
                y(idx + 1) = y(idx + 1) + h(k + 1) * x(idx - k + 1);
            end
        end
        idx = idx + 1;
    end
end