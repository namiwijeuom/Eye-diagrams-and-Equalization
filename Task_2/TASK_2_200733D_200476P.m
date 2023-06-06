clear;                                
clc;                                   
close all; 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters
numSymbols = 1000; % Number of symbols to generate(Since BPSK, this is equal to no.of bits)

bitRate = 1; % Bit rate (symbols per second)
samplingRate = 10 * bitRate; % Sampling rate (samples per second)

symbolDuration = 1 / bitRate; % Duration of each symbol in seconds

% Generate random binary data
binaryData = randi([0, 1], 1, numSymbols);

% Generate BPSK symbols as impulse train
bpskSymbols = 2 * binaryData - 1;
%disp(bpskSymbols)


%It is important that the convolution between the filters should occur at
%symbol periods. So, it is necessary to adjust the Sinc filter such that
%the data points on such periods are present. Here 30 zeros have been put 
%between the impulses in the bpsk vector to achieve it.
padded_bpsk_vector = reshape([bpskSymbols; zeros(29,numel(bpskSymbols))],1,[]);
%disp(padded_bpsk_vector)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = -20:0.1:20;  

% Put time vector into sinc filter and plotting it
sinc_Filter = sinc(t);

% Convolve BPSK symbols with pulse shaping filter
transmitSignal_1 = conv(padded_bpsk_vector, sinc_Filter);

%n = length(transmitSignal_1);
%disp(n)
%disp(transmitSignal)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rolloff_factor1 = 0.5;       % Roll-off factor for first raised cosine filter 1.
rolloff_factor2 = 1;         % Roll-off factor for second raised cosine filter 2.

r_c_f_1 = rcosdesign(rolloff_factor1,10,30,'sqrt');   % Make raised cosine filter 1
r_c_f_1 = r_c_f_1 / max(r_c_f_1);

r_c_f_2 = rcosdesign(rolloff_factor2,10,30,'sqrt');   % Make raised cosine filter 2
r_c_f_2 = r_c_f_2 / max(r_c_f_2);

% Make transitSignal_2 by convolving raised cosine filter and padded bpsk vector
transmitSignal_2 = conv(padded_bpsk_vector, r_c_f_1,'same');  


% Make transitSignal_3 by convolving raised cosine filter and padded bpsk vector
transmitSignal_3 = conv(padded_bpsk_vector, r_c_f_2,'same');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Additive White Gaussian Noise is in action from here onwards.

% The average bit energy (Eb)
Eb = sum(abs(padded_bpsk_vector).^2)/numSymbols;

% No where Eb/No = 10dB
EbNo_dB = 10;  
No = Eb/(10^(EbNo_dB/10)); 

% Noise variance
noise_variance = No/2;

 
%It is necessary to generate the noise with zero mean and the calculated variance
%seperately for all 3 transmitted signals since they have different
%lengths.

n_1 = noise_variance*normrnd(0,1,1,length(transmitSignal_1));
n_2 = noise_variance*normrnd(0,1,1,length(transmitSignal_2));
n_3 = noise_variance*normrnd(0,1,1,length(transmitSignal_3));

% Add the noise to each transmitted signals
noisy_transmitSignal_1 = transmitSignal_1 + n_1;
noisy_transmitSignal_2 = transmitSignal_2 + n_2;
noisy_transmitSignal_3 = transmitSignal_3 + n_3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot eye-diagrams for each transmit signal
figure;
eyediagram(noisy_transmitSignal_1,80,2*symbolDuration);     
title('Eye Diagram for Noisy Transmit Signal when Pulse Shaping Filter is a Sinc')

figure;
eyediagram(noisy_transmitSignal_2,80,2*symbolDuration);    
title('Eye Diagram for Noisy Transmit Signal_2 when Pulse Shaping Filter is Raised Cosine with RF=0.5.');

figure;
eyediagram(noisy_transmitSignal_3,80,2*symbolDuration);   
title('Eye Diagram for Noisy Transmit Signal_3 when Pulse Shaping Filter is Raised Cosine with RF=1.0.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting all the filters
figure; 

subplot(3,1,1);
plot(sinc_Filter)
title('Sinc Filter');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(r_c_f_1)
title('Raised cosine filter 1');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(r_c_f_2)
title('Raised cosine filter 2');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting all the transmitted signals
figure; 

subplot(3,1,1);
plot(transmitSignal_1)
title('Transmit Signal 1');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,2);
plot(transmitSignal_2)
title('Transmit Signal 2');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(3,1,3);
plot(transmitSignal_3)
title('Transmit Signal 3');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Close all the empty figures
close(1);
close(3);
close(5);