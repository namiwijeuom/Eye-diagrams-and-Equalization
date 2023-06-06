# Eye-diagrams-and-Equalization
This is a group assignment done under the module EN2074 Communication Systems Engineering, Semester 4, Department of Electronic &amp; Telecommunication Engineering, University of Moratuwa, Sri Lanka.
The task description of the assignment is as follows.

Task 1
In Task I, you are expected to generate eye diagrams for baseband 2-PAM signaling with different pulse shaping filters.
  1. Generate an impulse train representing BPSK symbols.
  2. Obtain transmit signal by convolving the impulse train with a pulse shaping filter where the impulse response is a sinc function.
  3. Generate the eye diagram of the transmit signal.
  4. Repeat 1-3 for raised cosine pulse shaping filters with roll-off factor 0.5 and 1.
  5. Compare the robustness of the system with respect to noise, sampling tine and synchronization errors.

Task 2
In Task 2, you are required to repeat Task 1, in the presence of additive white Gaussian noise (AWGN). To generate noise, use ‘randn’ function. Set the variance of noise such that 𝐸𝑏𝑁0=10 dB, where 𝐸𝑏 is the average bit energy and 𝑁0 is the noise power spectral density.

Task 3
For Task 3, you will design a zero-forcing (ZF) equalizer for a 3-tap multipath channel. Please follow the following steps for Task 3.
  1. Generate a random binary sequence.
  2. 2-PAM modulation - bit 0 represented as -1 and bit 1 represented as +1. You can ignore pulse shaping here. Assume you are transmitting impulses.
  3. Generate the received signal samples by convolving the symbols with a 3-tap multipath channel with impulse response h = [0.3 0.9 0.4].
  4. Add White Gaussian noise such that 𝐸𝑏𝑁0=0 dB.
  5. Computing the ZF equalization filters at the receiver for 3, 5, 7, and 9 taps in length.
  6. Demodulation and conversion to bits
  7. Calculate the bit error rate (BER) by counting the number of bit errors.
  8. Repeat steps 1-7 for 𝐸𝑏𝑁0 values 0 -10 dB.
  9. Plot the BER for all tap settings and 𝐸𝑏𝑁0 values in the same figure.
  10. Plot the BER for an additive white Gaussian noise (AWGN) channel in the same figure.
  11. Why there is a discrepancy between the AWGN channel BER and the ZF equalized multipath channel. Explain your results referring to the design of the ZF equalizer.
  12. Comment on the BER performance if binary orthogonal signaling was used instead of BPSK.

* MATLAB 2021 software was used to complete this assignment.

  * Group Members
    * A.A.H Pramuditha
    * W.L.N.K Wijetunga
