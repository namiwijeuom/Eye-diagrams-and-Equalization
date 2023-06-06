clear;                                
clc;                                   
close all; 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Number of symbols to generate(Since BPSK, this is equal to no.of bits)
numSymbols = 10^6;

% Multiple Eb/N0 values
EbN0_dB = [0:10]; 

%Number of taps used in the equalizer.
no_of_taps = 4; 

for ii = 1:length(EbN0_dB)

   %% Transmitter
   
   % Generate random binary data
   binaryData = randi([0 1],1,numSymbols); 
   
   % Generate BPSK symbols as impulse train
   bpskSymbols = 2*binaryData-1; 

   %% Characteristics of the channel
   
   %No. of taps 
   nTap = 3;
   
   %The impusle reponse of the channel
   impulse_response = [0.3 0.9 0.4]; 
   
   %% Simulating the effect of a multipath channel.
   channel_output_signal = conv(bpskSymbols,impulse_response);  
   
   %% Noise calculations
   
   %Generating random numbers from a standard normal distribution 
   %with a mean of 0 and variance of 1
   x = randn(1,numSymbols+length(impulse_response)-1); 
   
   %Gaussian noise with mean 0 and variance 1
   gaussian_noise = 1/sqrt(2)*[x + 1j*x]; % white gaussian noise, 0dB variance 
   
   % Noise addition
   noise_power = 10^(-EbN0_dB(ii)/20)*gaussian_noise;
   
   noisy_signal = channel_output_signal + noise_power; 
   
   for kk = 1:no_of_taps

     L  = length(impulse_response);
     
     %Create a Toeplitz matrix that represents 
     %the channel impulse response for the equalizer
     column = [impulse_response([2:end]) zeros(1,2*kk+1-L+1)];
     row = [ impulse_response([2:-1:1]) zeros(1,2*kk+1-L+1) ];
     channel_impulse_response = toeplitz(column, row);
     
     %Create a unit impulse response at the desired tap position
     d  = zeros(1,2*kk+1);
     d(kk+1) = 1;
     
     %Calculate the equalizer coefficients
     equilizer_coefficients  = [inv(channel_impulse_response)*d.'].';

     %% mathched filter
     yFilt = conv(noisy_signal,equilizer_coefficients);
     yFilt = yFilt(kk+2:end); 
     yFilt = conv(yFilt,ones(1,1)); % convolution
     ySamp = yFilt(1:1:numSymbols);  % sampling at time T
   

     %% At the receiver, hard decision decoding is performed 
     recieved_binary_data = real(ySamp)>0;

     % Counting the errors
     no_of_bit_errors(kk,ii) = size(find([binaryData- recieved_binary_data]),2);

   end
   

end

% Simulated BER
simulated_BER = no_of_bit_errors/numSymbols; 

% Theoretical BER
theoryBer = 0.5*erfc(sqrt(10.^(EbN0_dB/10))); 

%% Plotting BER for different no.of taps
close all
figure
semilogy(EbN0_dB,simulated_BER(1,:),'bs-'),'Linewidth';2;
hold on
semilogy(EbN0_dB,simulated_BER(2,:),'gd-'),'Linewidth';2;
semilogy(EbN0_dB,simulated_BER(3,:),'ks-'),'Linewidth';2;
semilogy(EbN0_dB,simulated_BER(4,:),'mx-'),'Linewidth';2;
semilogy(EbN0_dB,theoryBer,'--'),'Linewidth';2;
axis([0 10 10^-3 0.5])
grid on
legend('3-tap-length', '5-tap-length','7-tap-length','9-tap-length');
xlabel('Eb/No, dB');
ylabel('BER');
title('Bit Error Probability Curve for BPSK in ISI with ZF Equalizer');
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
