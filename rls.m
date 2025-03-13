% RLS Equalization Plots for Digital Communications Project
% EECS 241B

% Assignment parameters
h = [0.2194 1.000 0.2194];
noise_power = 0.001; % linear power
number_of_runs = 200;
number_of_tx_symbols = 500;
num_filter_taps = 11;
N = 7; % delay
lambdas = [0.9 0.7 0.5];

% Initialize the convergence matrix for each lambda value
MSE_convergence = zeros(length(lambdas), number_of_tx_symbols);

%% RLS Average Convergence Plot for Each Lambda Value
for l = 1:length(lambdas)
    lambda = lambdas(l);
    fprintf('Computing RLS convergence for lambda %.1f\n', lambda);
    
    % Run the simulation multiple times and average the results
    for run = 1:number_of_runs
        % transmit symbols are a sequence of random -1's and 1's (PAM)
        tx_symbols = 2 * (rand(number_of_tx_symbols, 1) > 0.5) - 1;
        
        % Desired signal is N sample delayed input sequence
        desired_symbols = zeros(number_of_tx_symbols + N, 1);
        desired_symbols(N + 1:end) = tx_symbols;
        
        % tx_symbols are convolved with CIR
        channel_response_to_tx = channel(tx_symbols, h);
        
        % Add AWGN to channel output
        rx_symbols = add_awgn(channel_response_to_tx, noise_power);
        
        % Initialize RLS parameters
        del = 0.000001;  % delta from the course notes
        Q = eye(num_filter_taps) / del;  % inverse autocorrelation matrix estimate
        w = zeros(num_filter_taps, 1);  % filter coefficients
        
        error = zeros(number_of_tx_symbols, 1);
        
        % RLS algorithm - using your implementation
        for n = 1:number_of_tx_symbols
            % Get a slice from rx_symbols using your get_slice function
            v_n = get_slice(num_filter_taps, n, rx_symbols);
            
            % RLS formulas from the course notes 
            x_n = (1 / lambda) * Q * v_n;
            k_n = x_n / (1 + v_n' * x_n);
            apr_error = desired_symbols(n + N) - w' * v_n;
            w = w + k_n * conj(apr_error);
            Q = (Q - k_n * v_n' * Q) / lambda;
            
            error(n) = apr_error^2;
        end
        
        % Accumulate squared error for averaging
        MSE_convergence(l, :) = MSE_convergence(l, :) + error';
    end
    
    % Average the MSE over the number of runs
    MSE_convergence(l, :) = MSE_convergence(l, :) / number_of_runs;
end

% Plot the average convergence for each lambda value
figure(1);
semilogy(1:number_of_tx_symbols, MSE_convergence(1, :), 'b-', ...
         1:number_of_tx_symbols, MSE_convergence(2, :), 'r-', ...
         1:number_of_tx_symbols, MSE_convergence(3, :), 'g-');
legend({['λ = ' num2str(lambdas(1))], ...
        ['λ = ' num2str(lambdas(2))], ...
        ['λ = ' num2str(lambdas(3))]});
title('RLS Algorithm - Average Convergence');
xlabel('Iterations');
ylabel('Mean Squared Error (log scale)');
grid on;
saveas(gcf, 'rls_convergence.png');

%% Representative Time Plots
% Choose one lambda for demonstration (using the first one)
lambda = lambdas(1);

% Generate a new set of symbols
tx_symbols = 2 * (rand(number_of_tx_symbols, 1) > 0.5) - 1;

% Desired signal is N sample delayed input sequence
desired_symbols = zeros(number_of_tx_symbols + N, 1);
desired_symbols(N + 1:end) = tx_symbols;

% tx_symbols are convolved with CIR
channel_response_to_tx = channel(tx_symbols, h);

% Add AWGN to channel output
rx_symbols = add_awgn(channel_response_to_tx, noise_power);

% Initialize RLS parameters
del = 0.0001;
Q = eye(num_filter_taps) / del;
w = zeros(num_filter_taps, 1);

% Initialize equalized output
eq_output = zeros(length(rx_symbols), 1);

% RLS algorithm
for n = 1:number_of_tx_symbols
    % Get input vector using your get_slice function
    v_n = get_slice(num_filter_taps, n, rx_symbols);
    
    % Calculate equalizer output for this sample
    eq_output(n) = w' * v_n;
    
    % RLS update
    x_n = (1 / lambda) * Q * v_n;
    k_n = x_n / (1 + v_n' * x_n);
    apr_error = desired_symbols(n + N) - w' * v_n;
    w = w + k_n * conj(apr_error);
    Q = (Q - k_n * v_n' * Q) / lambda;
end

% Plot time domain signals
range = 475:500;

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
title(['Signal After Equalizer (RLS, λ = ' num2str(lambda) ')']);
xlabel('Sample Index');
ylabel('Amplitude');
grid on;
ylim([-1.5 1.5]);

saveas(gcf, 'rls_time_plots.png');
