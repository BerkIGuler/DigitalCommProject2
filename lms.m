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

function [y] = add_awgn(x, noise_power)
    noise = randn(length(x), 1) * sqrt(noise_power);
    y = x + noise;
end

% Control params
plot_figures = true;

% channel coefficients
h = [0.2194 1.000 0.2194];
step_sizes = [0.0550 0.0275 0.0138];
noise_power = 0.001;

number_of_runs = 200;
number_of_tx_symbols = 500;
num_filter_taps = 11;

N = 7;

% transmit symbols are a sequence of random -1's and 1's (PAM)
tx_symbols = 2 * (rand(number_of_tx_symbols, 1) > 0.5) - 1;
% desired signal is N sample delayed input
desired_symbols = zeros(number_of_tx_symbols + N, 1);
desired_symbols(N + 1:end) = tx_symbols;

% tx_symbols are convolved with CIR to obtain rx_symbols 
channel_response_to_tx = channel(tx_symbols, h);
% add AWGN to response to tx
rx_symbols = add_awgn(channel_response_to_tx, noise_power);

if plot_figures
    plot(rx_symbols);
    title("Received Symbols")
    xlabel("Symbol index")
    ylabel("Symbol")
end


% the LMS algorithm is
% c_(k+1) = c_k + delta * epsilon_k * conj(v_k)
% where c_k is the vector of parameters at update step k
% delta is the step size
% epsilon_k is the estimation error made at step k
% v_k is the vector of input received symbols 

% randomly initialize filter coefficients
c = randn(num_filter_taps, 1);


