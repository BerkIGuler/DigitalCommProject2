% LMS Equalization Plots for Digital Communications Project
% EECS 241B

% Control params
plot_figures = true;

% assingment parameters
h = [0.2194 1.000 0.2194];
step_sizes = [0.0550 0.0275 0.0138];
noise_power = 0.001;  % linear power
number_of_runs = 200;
number_of_tx_symbols = 500;
num_filter_taps = 11;
K = (num_filter_taps - 1) / 2; % filter coefficients are indexed from -K to K
N = 7; % delay

% convergence matrix for each step size
MSE_convergence = zeros(length(step_sizes), number_of_tx_symbols);

%% LMS Average Convergence Plot for Each step size
for i = 1:length(step_sizes)
    step_size = step_sizes(i);
    fprintf('Computing LMS convergence for step size %.4f\n', step_size);
    

    for run = 1:number_of_runs
        % transmit symbols are a sequence of random -1's and 1's (PAM)
        tx_symbols = 2 * (rand(number_of_tx_symbols, 1) > 0.5) - 1;
        
        % desired signal is N sample delayed input sequence
        desired_symbols = zeros(number_of_tx_symbols + N, 1);
        desired_symbols(N + 1:end) = tx_symbols;
        
        % tx_symbols are convolved with CIR
        channel_response_to_tx = channel(tx_symbols, h);
        
        % add AWGN to channel output
        rx_symbols = add_awgn(channel_response_to_tx, noise_power);
        
        % randomly initialize filter coefficients from standard normal
        c = randn(num_filter_taps, 1);
        
        % LMS algorithm
        error = zeros(number_of_tx_symbols, 1);
        for k = 0:(number_of_tx_symbols - 1)
            d = desired_symbols(k + N + 1);
            eps = calculate_eps(d, c, rx_symbols, k);
            c = update_filter_coef(c, eps, rx_symbols, step_size, k);
            error(k + 1) = eps^2;  % report squared error (SE)
        end
        
        % Accumulate the SE
        MSE_convergence(i, :) = MSE_convergence(i, :) + error';
    end
    
    % Average the SE over number of runs
    MSE_convergence(i, :) = MSE_convergence(i, :) / number_of_runs;
end

% Plot the average convergence for each step size
figure(1);
semilogy(1:number_of_tx_symbols, MSE_convergence(1, :), 'b-', ...
         1:number_of_tx_symbols, MSE_convergence(2, :), 'r-', ...
         1:number_of_tx_symbols, MSE_convergence(3, :), 'g-');
legend({['Δ = ' num2str(step_sizes(1))], ...
        ['Δ = ' num2str(step_sizes(2))], ...
        ['Δ = ' num2str(step_sizes(3))]});
title('LMS Algorithm - Average Convergence');
xlabel('Iterations');
ylabel('Mean Squared Error (log scale)');
grid on;
saveas(gcf, 'lms_convergence.png');

%% Time Plots (samples 475-500)
% Choose a step size
step_size = step_sizes(1);

% Generate tx symbols
tx_symbols = 2 * (rand(number_of_tx_symbols, 1) > 0.5) - 1;

% desired signal is N sample delayed input sequence
desired_symbols = zeros(number_of_tx_symbols + N, 1);
desired_symbols(N + 1:end) = tx_symbols;

% tx_symbols are convolved with CIR
channel_response_to_tx = channel(tx_symbols, h);

% add AWGN to channel output
rx_symbols = add_awgn(channel_response_to_tx, noise_power);

% Initialize filter coefficients from standard normal
c = randn(num_filter_taps, 1);

% Initialize equalized output
eq_output = zeros(size(rx_symbols));

% Run LMS algorithm
for k = 0:(number_of_tx_symbols - 1)
    % Calculate the equalizer output for this sample
    eq_output(k + 1) = get_eq_output(k, c, rx_symbols);
    
    % Update coefficients
    d = desired_symbols(k + N + 1);
    eps = calculate_eps(d, c, rx_symbols, k);
    c = update_filter_coef(c, eps, rx_symbols, step_size, k);
end

% Plot time domain signals (samples 475-500)
range = 450:475;

figure(2);
subplot(3,1,1);
stem(range, tx_symbols(range), 'b');
title('Input Signal (Transmitted Symbols)');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;
ylim([-1.5 1.5]);

subplot(3,1,2);
stem(range, rx_symbols(range), 'r');
title('Signal After Channel');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
stem(range, eq_output(range), 'g');
title(['Signal After Equalizer (LMS, Δ = ' num2str(step_size) ')']);
xlabel('Sample Index');
ylabel('Amplitude');
grid on;
ylim([-1.5 1.5]);

saveas(gcf, 'lms_time_plots.png');