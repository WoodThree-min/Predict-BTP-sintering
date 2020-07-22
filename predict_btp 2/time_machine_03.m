clear;clc;

%% ��ȡ
load('data3_cleansed.mat'); %��ϴ��ķ�������
load('btp_data3.mat'); %�õ���zb_hat

  % A���ϲ���䣬B�Ǳ�����䣬C����All����������ƽ��
 zb_hat = zb_A_190313(1:2000);
% zb_hat = zb_B_190317;
% zb_hat = zb_All_190313;

% һ��BTP
for i=13:length(zb_hat)
    zb_hat_n(i-12)=mean(zb_hat(i-12:i-1));
end

figure;
subplot(121);plot(zb_hat_n);
subplot(122);hist(zb_hat_n,35);
 %�����¶ȵ�ƽ������------------------------------------------------------------------------------
 m = 1;
 C=cleaned_A;
nrC = size(C, 1);
YY_avg = zeros(nrC-m+1, size(C, 2));
for i = 1:(nrC-m+1)
    YY_avg(i,:) = mean(C(i:(i+m-1),:));
end


%% ����
% Ԥ�ⴰ��
window=10;
% Ԥ��ʱ��

l=5;

%% find a weight
w=0.1:0.02:1;
for i=1:length(w)-1
[zb_mf,zb_hat_filtered,lower1,upper1,lower2,upper2,cover_rate(i,:),Sig(i)]=predict_btp(window,l,zb_hat_n,w(i));
end
figure;
subplot(121);plot(w(1:length(w)-1),Sig);title('�в�ƽ����')
subplot(122);plot(w(1:length(w)-1),cover_rate(:,1));title('һ����׼�����')
grid on; grid minor;

%%
[zb_mf,zb_hat_filtered,lower1,upper1,lower2,upper2,cover_rate]=predict_btp(window,l,zb_hat_n,1);
% zb_mf ��Ԥ��
% zb_hat_filtered �Ƕ���BTP


disp(['һ����׼�����Ϊ',num2str(100*cover_rate(1)),'%']);
disp(['������׼�����Ϊ',num2str(100*cover_rate(2)),'%']);


%% animation
anima_pred_zb(YY_avg,zb_hat_n,zb_hat_filtered,zb_mf,lower1,upper1,lower2,upper2,window,l)

