
function [zb_mf,zb_hat_filtered,lower1,upper1,lower2,upper2,cover_rate,Sig]=predict_btp(window,l,zb_hat,w)




% 计算
zb_hat=reshape(zb_hat,length(zb_hat),1);
zb_mf=zeros(length(zb_hat)+l*12-1,1);
sigma=zeros(length(zb_hat)+l*12-1,1);
lower1=zeros(length(zb_hat)+l*12-1,1);
upper1=zeros(length(zb_hat)+l*12-1,1);
lower2=zeros(length(zb_hat)+l*12-1,1);
upper2=zeros(length(zb_hat)+l*12-1,1);
zb_hat_filtered=zeros(length(zb_hat),1);

% 二级BTP
for i=window*12:length(zb_hat) 
    zb_hat_filtered(i)=mean(zb_hat(i-window*12+1:i));
end

% 预测
for i=(window+l)*12+1:length(zb_hat_filtered) 
     % 加权
     if w==1
         zb_mf(i-1)=mean(zb_hat_filtered(i-l*12:i-1));
     else
         W=repmat(w.^(0:l-1),12,1);
         zb_mf(i-1)=(reshape(W,1,l*12)*(1-w)/(1-w^l)*1/12)*zb_hat_filtered(i-l*12:i-1);
     end
    if i-1 <=length(zb_hat_filtered)
        Q=(zb_hat_filtered((l+window)*12:i-1)-zb_mf((l+window)*12:i-1)).^2;
        Sig=sum(Q);
        sigma(i-1)=sqrt(sum(Q)/length(Q));
        lower1(i-1) = zb_mf(i-1) - sigma(i-1);
        upper1(i-1) = zb_mf(i-1) + sigma(i-1);
        lower2(i-1) = zb_mf(i-1) - 2*sigma(i-1);
        upper2(i-1) = zb_mf(i-1) + 2*sigma(i-1);
    else
        Q=(zb_hat_filtered((l+window)*12:length(zb_hat_filtered))-zb_mf((l+window)*12:length(zb_hat_filtered))).^2;
        Sig=sum(Q);
        sigma(i-1)=sqrt(sum(Q)/length(Q));
        lower1(i-1) = zb_mf(i-1) - sigma(i-1);
        upper1(i-1) = zb_mf(i-1) + sigma(i-1);
        lower2(i-1) = zb_mf(i-1) - 2*sigma(i-1);
        upper2(i-1) = zb_mf(i-1) + 2*sigma(i-1);

    end
    
end


% 准确率
count1=0; count2=0;
for i=(l+window)*12:length(zb_hat)
    if(zb_hat_filtered(i)< upper1(i)) && (zb_hat_filtered(i)> lower1(i))
        count1=count1+1;
    end
    if(zb_hat_filtered(i)< upper2(i)) && (zb_hat_filtered(i)> lower2(i))
        count2=count2+1;
    end
end
  
cover_rate(1)=count1/(length(zb_hat_filtered)-(l+window)*12+1);
cover_rate(2)=count2/(length(zb_hat_filtered)-(l+window)*12+1);

end