N=1024;
data_in=randint(1,1024,2);
data=data_in;
data=data*2-1; 
bit_error_rate=zeros(0,50);
SNR=0:1:15
for k=0:1:15
s=1;
n=s/(10^(k/10));
noise=wgn(1,1024,10*log10(n));
%noise=sqrt(n)*randn(1,1024);
%noise=normrnd(0,sqrt(n),1,1024);
%data_with_noise=noise+data;
%noise=rand(1,1024);
%noise=noise-mean(noise);
%noise=sqrt(n)/sqrt(var(noise))*noise;
data_with_noise=noise+data;
for i=1:1:1024
    if (data_with_noise(i)>0)
        data_with_noise(i)=1;
    end
    if (data_with_noise(i)<=0)
        data_with_noise(i)=0;
    end
end   
count=0;
for i=1:1:1024
    if data_with_noise(i)~=data_in(i)
        count=count+1;
    end
end
bit_error_rate(k+1)=count/1024;
end
plot(SNR,bit_error_rate);


