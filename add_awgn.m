function [y] = add_awgn(x, noise_power)
    noise = randn(length(x), 1) * sqrt(noise_power);
    y = x + noise;
end