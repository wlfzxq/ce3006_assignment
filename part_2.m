clear
N=1024;
data_in=randint(1,1024,2);
data=data_in;
Fs = 160e3; %WLF
OOK_data=data; %OOK data signals are either +1 or -1
BPSK_data=data*2-1; %BPSK data signals are either 1 or 0
OOK_bit_error_rate=zeros(0,50);
BPSK_bit_error_rate=zeros(0,50);
SNR=0:1:50;
f=10000;
%t=1;
t = 0:1/Fs:1-(1/Fs); %WLF
carrier_signal=(cos(2*pi*f*t));

for k=0:1:50
s=1;
n=s/(10^(k/10));
noise=wgn(1,1024,10*log10(n));

%Modulating input signals
OOK_mod = OOK_data.*carrier_signal;
BPSK_mod = BPSK_data.*carrier_signal;

%Adding additive white noise to modulated signals
OOK_received = OOK_mod + noise;
BPSK_received = BPSK_mod + noise;

%Demodulating noisy signals at receiver
OOK_demod = OOK_received.*(2*carrier_signal);
BPSK_demod = BPSK_received.*(2*carrier_signal);

%Passing demodulated signals through low pass filter
[b,a] = butter(6,0.2);
OOK_filtered = filtfilt(b,a,OOK_demod);
BPSK_filtered = filtfilt(b,a,BPSK_demod);

%Decoding filtered signal by passing it through the decision device
for i=1:1:1024
    if (OOK_filtered(i)>=0.5)
        OOK_filtered(i)=1;
    end
    if (OOK_filtered(i)<0.5)
        OOK_filtered(i)=0;
    end
    if (BPSK_filtered(i)>=0)
        BPSK_filtered(i)=1;
    end
    if (BPSK_filtered(i)<0)
        BPSK_filtered(i)=-1;
    end
end

OOK_decoded = OOK_filtered;
BPSK_decoded = BPSK_filtered;

%Initiating error counter
OOK_error_count=0;
BPSK_error_count=0;
for i=1:1:1024
    if OOK_decoded(i)~=OOK_data(i)
        OOK_error_count=OOK_error_count+1;
    end
    if BPSK_decoded(i)~=BPSK_data(i)
        BPSK_error_count=BPSK_error_count+1;
    end
end

%Calculating bit error rate
OOK_bit_error_rate(k+1)=OOK_error_count/1024;
BPSK_bit_error_rate(k+1)=BPSK_error_count/1024;
end

figure(1);
semilogy(SNR,OOK_bit_error_rate);
xlabel('Signal-to-noise ratio -->');
ylabel('OOK bit error rate -->');

figure(2);
semilogy(SNR,BPSK_bit_error_rate);
xlabel('Signal-to-noise ratio -->');
ylabel('BPSK bit error rate -->');
